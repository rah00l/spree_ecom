class Admin::ProductImportsController < Spree::Admin::BaseController

  #Sorry for not using resource_controller railsdog - I wanted to, but then... I did it this way.
  #Verbosity is nice?
  #Feel free to refactor and submit a pull request.

  def index
    @imported_products = Spree::ProductImport.order('created_at DESC')
#    redirect_to :action => :new
  end

  def new
    @product_import = Spree::ProductImport.new
  end


  def create
    @import_type = params[:import_type]
    @product_import = Spree::ProductImport.create(params[:product_import])
    @test = ImportProducts::ImportJob.new(@product_import, @current_user , @import_type)
    @test.perform
    if $product_cnt == 0
      flash[:notice] =  "No product added, #{$product_updated_cnt} products updated."
    else
      flash[:notice] =  "Import successful, #{$product_cnt} products added successfully."
    end
    redirect_to main_app.admin_product_imports_url
  end

  def download_file
    @product_import = Spree::ProductImport.find(params[:id])
    if @product_import
      send_file(@product_import.data_file.path, :type => 'text/csv', :disposition => 'inline')
    else
      redirect_to :back
    end
  end


  def log_file
    @product_import = Spree::ProductImport.find(params[:id])
    if @product_import
#      raise "#{Rails.root}/doc/product_data/import_logs/#{@product_import.id}/import.log".inspect
      send_file("#{Rails.root}/doc/product_data/import_logs/#{@product_import.id}/import.log",:type => 'text/plain', :disposition => 'inline')
    else
      redirect_to :back
    end
  end

  def destroy
     @product_import = Spree::ProductImport.find(params[:id])
     if @product_import
        @product_import.delete
        flash[:notice] = "Product deleted sucessfully."
     else
       flash[:notice] = "No product found to delete."
     end
     redirect_to main_app.admin_product_imports_url
  end

  def build_export_file
    hedear=[]
    pre_hash = {"name" => "name", "description" => "description" , 
      "manufacturer" => "manufacture.name",
      "price" => "price","quantity" => "count_on_hand","weight"=>"weight",
      "tax_class" => "tax_class_title","available" => "available_on",
      "date_added"=>"created_at","status" =>"status",
      "categories" => "taxons.collect(&:name).join(', ')",
      "image" => "images.collect(&:file_name).join(' ,')",
      "special" => "special_price"}
    hedear = params[:exportable_fields].keys if params[:exportable_fields]
    @product = Spree::Taxon.find(params[:exportable][:category_id]).products.find(:all,:conditions => ["manufacture_id=? and status=?",params[:exportable_manufacture_id],params[:exportable_status]])
    CSV.open("#{Rails.root}/products.csv", "w") do |csv|
      csv << hedear
      @product.each do |p|
        data_array = []
        hedear.each do |i|

          data_array << eval("p.#{pre_hash[i]}")
        end
        csv << data_array
      end
    end
    send_file("#{Rails.root}/products.csv")
  end

end
