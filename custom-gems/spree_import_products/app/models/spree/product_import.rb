# This model is the master routine for uploading products
# Requires Paperclip and CSV to upload the CSV file and read it nicely.

# Original Author:: Josh McArthur
# Author:: Chetan Mittal
# License:: MIT

class Spree::ProductImport < ActiveRecord::Base
  has_attached_file :data_file, :path => ":rails_root/lib/etc/product_data/data-files/:basename.:extension"
  validates_attachment_presence :data_file

  require 'csv'
  require 'pp'
  require 'open-uri'
  EXPORT_ATTR = ["name","description","image","categories","manufacturer","price","quantity",]
  EXPORT_ATTR1 = ["weight","tax_class","available","date_added","status","special"]

#  EXPORT_ATTR = ["name","description","url","price","count_on_hand","manufacturer"]
#  EXPORT_ATTR1 = ["weight","tax_class_title","available_on","created_at","status"]


#  pre_hash = {"name" => "name", "description" => "description" , "url" => "permalink",
#    "manufacturer" => "manufacture.name","price" => "price","quantity" => "count_on_hand","weight"=>"weight","tax_class" => "tax_class_title","available" => "available_on","date_added"=>"created_at","status" =>"status" }

  ## Data Importing:
  # List Price maps to Master Price, Current MAP to Cost Price, Net 30 Cost unused
  # Width, height, Depth all map directly to object
  # Image main is created independtly, then each other image also created and associated with the product
  # Meta keywords and description are created on the product model

  def import_data!(import_type=nil)
      #Get products *before* import -
      $product_cnt = 0
      $product_updated_cnt = 0
      
#      begin
      @products_before_import = Spree::Product.all
      @names_of_products_before_import = []
      @products_before_import.each do |product|
        @names_of_products_before_import << product.name
      end
#      log("#{@names_of_products_before_import}")

      rows = CSV.read(self.data_file.path)


      if IMPORT_PRODUCT_SETTINGS[:first_row_is_headings]
        col = get_column_mappings(rows[0])
      else
        col = IMPORT_PRODUCT_SETTINGS[:column_mappings]
      end

#      rows[IMPORT_PRODUCT_SETTINGS[:rows_to_skip]..-1].inspect

      log("Importing products for #{self.data_file_file_name} began at #{Time.now}")
#      log("********************** Started here *******************")
      rows[IMPORT_PRODUCT_SETTINGS[:rows_to_skip]..-1].each do |row|

        product_information = {}
        #Automatically map 'mapped' fields to a collection of product information.
        #NOTE: This code will deal better with the auto-mapping function - i.e. if there
        #are named columns in the spreadsheet that correspond to product
        # and variant field names.
        col.each do |key, value|
          product_information[key] = row[value]
        end

        #Manually set available_on if it is not already set
#        raise product_information[:available_on].inspect
        product_information[:available_on] = DateTime.now - 1.day if product_information[:available_on].nil?

#        raise product_information[:available_on].inspect
        #Trim whitespace off the beginning and end of row fields
        row.each do |r|
          next unless r.is_a?(String)
          r.gsub!(/\A\s*/, '').chomp!
        end

        if IMPORT_PRODUCT_SETTINGS[:create_variants]
          field = IMPORT_PRODUCT_SETTINGS[:variant_comparator_field].to_s

          if p = Spree::Product.find(:first, :conditions => ["#{field} = ?", row[col[field.to_sym]]])
         unless import_type.eql?('Delete Only')
#      product_information.reject!{|k| k == :image_main}
      product_information.merge!(:manufacture_id => product_information[:manufacture_name]).delete(:manufacture_name)
      if product_information.has_key?(:manufacture_id)
        product_information[:manufacture_id] = map_or_create_manufacture(product_information[:manufacture_id])
      end
      
      if product_information.has_key?(:categories_name_1)
        product_information[:categories_name_1] = map_or_create_category(product_information[:categories_name_1],p).join(", ")
      end
      
      if product_information.has_key?(:available_on) && product_information[:available_on].blank?
        product_information[:available_on] = DateTime.now - 1.day
      end

##      raise  product_information[:available_on].inspect
#        raise product_information.inspect
        p.update_attributes(product_information)
        variant_hash = {sku: product_information[:sku] ,
          price: product_information[:price],
          weight: product_information[:weight],
          height: product_information[:height],
          width: product_information[:width],
          depth: product_information[:depth],
          deleted_at: product_information[:deleted_at],
          product_id: p.id,
          count_on_hand: product_information[:count_on_hand],
          cost_price: product_information[:cost_price],
          position: product_information[:position],
        }
#        raise variant_hash.inspect
        p.master.update_attributes(variant_hash)
#        raise p.master.inspect
#      log("******************* Updating product ends   here ...!")
            p.update_attribute(:deleted_at, nil) if p.deleted_at #Un-delete product if it is there
#            p.variants.each { |variant| variant.update_attribute(:deleted_at, nil) }
#            create_variant_for(p, :with => product_information)
#            raise p.master.is_master.inspect
#            p.master.update_attribute "is_master",false if p.master
#            p.variants.last.update_attribute "is_master", true
#            raise p.variants.last.is_master.inspect
            $product_updated_cnt = $product_updated_cnt +1
            self.update_attributes(:products_failed =>$product_updated_cnt)
          else
              p.destroy
          end
          else
            next unless create_product_using(product_information)
          end

        else
          next unless create_product_using(product_information)
        end

      end

      if IMPORT_PRODUCT_SETTINGS[:destroy_original_products]
        @products_before_import.each { |p| p.destroy }
      end

      log("Importing products for #{self.data_file_file_name} completed at #{DateTime.now}")

#    rescue Exception => exp
#      self.update_attributes(:products_failed =>$product__updated_cnt)
#      log("An error occurred during import, please check file and try again. (#{exp.message})\n#{exp.backtrace.join('\n')}", :error)
#      raise Exception(exp.message)
#    end

    #All done!
    return [:notice, "Product data was successfully imported."]
  end


  private

def map_or_create_manufacture(manufacture_name)
  manufacture = Spree::Manufacture.find_by_name(manufacture_name)
  if manufacture.present?
     manufacture.id
  else
    new_manufacture = Spree::Manufacture.create(:name => manufacture_name)
    new_manufacture.id
  end
end

#def map_or_create_category1(category_name,product)
#  if category_name && product
#    str = category_name.include?('/')? category_name.split('/').first : category_name
#    taxonomy = Spree::Taxonomy.find_by_name(str.strip)
#    taxon = Spree::Taxon.find_by_name(str.strip)
#    unless taxonomy && taxon
#      new_taxon = Spree::Taxonomy.create(:name => str.strip)
#    end
#      child_cats = category_name.split('/')
#      child_cats.shift(1)
#      child_cats.each do |child|
#      ex_child = Spree::Taxon.find_by_name(child.strip)
#      condition_for = ex_child.blank?
#      create_taxon = taxonomy.present?
##      raise create_taxon.inspect
#      if condition_for && create_taxon
#        str1 = {:name => child.strip}
#        p "~"*10
#        p "~"*10
#        puts str1
#        child_cat = taxonomy.taxons.create(str1)
#        p "~"*10
#        p "~"*10
#      end
#  end
#  end
#end




def map_or_create_category(category_name,product)
  if category_name && product
    str = category_name.include?('/')? category_name.split('/').first : category_name
    category = Spree::Taxon.find_by_name_and_parent_id(str.strip,nil)
    if category.present?
      category.products << product unless category.products.include?(product)
    else
      Spree::Taxonomy.create(:name => str.strip)
      parent_taxon = Spree::Taxon.find_by_name_and_parent_id(str, nil)
      parent_taxon.products << product
    end

    child_cats = category_name.split('/')
    child_cats.shift(1)
    child_cats.each_with_index do |child, index|
      child_category = Spree::Taxon.find_by_name(child.strip)
      if child_category.present?
        child_category.products << product unless child_category.products.include?(product)
      else
        parent_cat = Spree::Taxonomy.find_by_name(str)
        parent_taxon = Spree::Taxon.find_by_name_and_parent_id(str, nil)
        child_cat = parent_cat.taxons.create(:name => child.strip, :position => index+1,
          :parent_id => parent_taxon.id, :taxonomy_id=> parent_cat.id)
        child_cat.products << product
      end
    end
  end
  #raise "".inspect
end

  # create_variant_for
  # This method assumes that some form of checking has already been done to
  # make sure that we do actually want to create a variant.
  # It performs a similar task to a product, but it also must pick up on
  # size/color options
  def create_variant_for(product, options = {:with => {}})
    return if options[:with].nil?
    variant = product.variants.new

    #Remap the options - oddly enough, Spree's product model has master_price and cost_price, while
    #variant has price and cost_price.
    options[:with][:price] = options[:with].delete(:master_price)

    #First, set the primitive fields on the object (prices, etc.)
    options[:with].each do |field, value|
      variant.send("#{field}=", value) if variant.respond_to?("#{field}=")

      applicable_option_type = Spree::OptionType.find(:first, :conditions => [
        "lower(presentation) = ? OR lower(name) = ?",
        field.to_s, field.to_s]
      )


      if applicable_option_type.is_a?(Spree::OptionType)
        product.option_types << applicable_option_type unless product.option_types.include?(applicable_option_type)
        variant.option_values << applicable_option_type.option_values.find(
          :all,
          :conditions => ["presentation = ? OR name = ?", value, value]
        )
      end
    end

    if variant.valid?
      variant.save

      #Associate our new variant with any new taxonomies
      IMPORT_PRODUCT_SETTINGS[:taxonomy_fields].each do |field|
        associate_product_with_taxon(variant.product, field.to_s, options[:with][field.to_sym])
      end

      #Finally, attach any images that have been specified
      IMPORT_PRODUCT_SETTINGS[:image_fields].each do |field|
        find_and_attach_image_to(variant, options[:with][field.to_sym])
      end

      #Log a success message
      log("Variant of SKU #{variant.sku} successfully imported.\n")
    else
      log("A variant could not be imported - here is the information we have:\n" +
          "#{pp options[:with]}, :error")
      return false
    end
  end


  # create_product_using
  # This method performs the meaty bit of the import - taking the parameters for the
  # product we have gathered, and creating the product and related objects.
  # It also logs throughout the method to try and give some indication of process.
  def create_product_using(params_hash)
    product = Spree::Product.new
    #The product is inclined to complain if we just dump all params
    # into the product (including images and taxonomies).
    # What this does is only assigns values to products if the product accepts that field.
    params_hash.each do |field, value|
      if field == :manufacture_name
          field = :manufacture_id
          value = map_or_create_manufacture(value)
      end
      product.send("#{field}=", value) if product.respond_to?("#{field}=")
    end
    params_hash.each do |field, value|
      if field == :categories_name_1
          field = :tax_category_id
          value = map_or_create_category(value,product) if value.present?
      end
      product.send("#{field}=", value) if product.respond_to?("#{field}=")
    end

    after_product_built(product, params_hash)

    #We can't continue without a valid product here
    unless product.valid?
      log("A product could not be imported - here is the information we have:\n" +
          "#{pp params_hash}, :error")
      return false
    end


    #Just log which product we're processing
    log(product.name)
    #This should be caught by code in the main import code that checks whether to create
    #variants or not. Since that check can be turned off, however, we should double check.

    if @names_of_products_before_import.include? product.name
      log("#{product.name} is already in the system.\n")
    else
      product.save
      $product_cnt = $product_cnt +1
      self.update_attributes(:products_added =>$product_cnt)

      #Associate our new product with any taxonomies that we need to worry about
      IMPORT_PRODUCT_SETTINGS[:taxonomy_fields].each do |field|
        associate_product_with_taxon(product, field.to_s, params_hash[field.to_sym])
      end

      #Finally, attach any images that have been specified
      IMPORT_PRODUCT_SETTINGS[:image_fields].each do |field|
        find_and_attach_image_to(product, params_hash[field.to_sym])
      end

      if IMPORT_PRODUCT_SETTINGS[:multi_domain_importing] && product.respond_to?(:stores)
        begin
          store = Store.find(
            :first,
            :conditions => ["id = ? OR code = ?",
              params_hash[IMPORT_PRODUCT_SETTINGS[:store_field]],
              params_hash[IMPORT_PRODUCT_SETTINGS[:store_field]]
            ]
          )

          product.stores << store
        rescue
          log("#{product.name} could not be associated with a store. Ensure that Spree's multi_domain extension is installed and that fields are mapped to the CSV correctly.")
        end
      end

      #Log a success message
      log("#{product.name} successfully imported.\n")
    end
    return true
  end




  def conditional_hash_chanage(field,value)
    case field
        when :manufacture_name
          field = :manufacture_id
          value = map_or_create_manufacture(value)
    end
    return field,value
  end

  # get_column_mappings
  # This method attempts to automatically map headings in the CSV files
  # with fields in the product and variant models.
  # If the headings of columns are going to be called something other than this,
  # or if the files will not have headings, then the manual initializer
  # mapping of columns must be used.
  # Row is an array of headings for columns - SKU, Master Price, etc.)
  # @return a hash of symbol heading => column index pairs
  def get_column_mappings(row)
    mappings = {}
    row.each_with_index do |heading, index|
      mappings[heading.downcase.gsub(/\A\s*/, '').chomp.gsub(/\s/, '_').to_sym] = index
    end
    mappings
  end


  ### MISC HELPERS ####

  #Log a message to a file - logs in standard Rails format to logfile set up in the import_products initializer
  #and console.
  #Message is string, severity symbol - either :info, :warn or :error

#  def log(message, severity = :info)
#    @rake_log ||= ActiveSupport::BufferedLogger.new(File.join(Rails.root, "/doc/product_data/import_logs/#{self.id}", "import.log"))
#    message = "[#{Time.now.to_s(:db)}] [#{severity.to_s.capitalize}] #{message}\n"
#    @rake_log.send severity, message
#  end


  def log(message, severity = :info)
    @rake_log ||= ActiveSupport::BufferedLogger.new(IMPORT_PRODUCT_SETTINGS[:log_to])
    message = "[#{Time.now.to_s(:db)}] [#{severity.to_s.capitalize}] #{message}\n"
    @rake_log.send severity, message
    puts message
  end


  ### IMAGE HELPERS ###

  # find_and_attach_image_to
  # This method attaches images to products. The images may come
  # from a local source (i.e. on disk), or they may be online (HTTP/HTTPS).
  def find_and_attach_image_to(product_or_variant, filename)
    return if filename.blank?
    file_name = filename.split('/').last
    #The image can be fetched from an HTTP or local source - either method returns a Tempfile
    file = filename =~ /\Ahttp[s]*:\/\// ? fetch_remote_image(filename) : fetch_local_image(filename)
    #An image has an attachment (the image file) and some object which 'views' it
    product_image = Spree::Image.new({:attachment => file,
                              :viewable => product_or_variant,
                              :position => product_or_variant.images.length,
                              :file_name => file_name
                              })

    product_or_variant.images << product_image if product_image.save
  end

  # This method is used when we have a set location on disk for
  # images, and the file is accessible to the script.
  # It is basically just a wrapper around basic File IO methods.
  def fetch_local_image(filename)
    filename = IMPORT_PRODUCT_SETTINGS[:product_image_path] + filename
    unless File.exists?(filename) && File.readable?(filename)
      log("Image #{filename} was not found on the server, so this image was not imported.", :warn)
      return nil
    else
      return File.open(filename, 'rb')
    end
  end


  #This method can be used when the filename matches the format of a URL.
  # It uses open-uri to fetch the file, returning a Tempfile object if it
  # is successful.
  # If it fails, it in the first instance logs the HTTP error (404, 500 etc)
  # If it fails altogether, it logs it and exits the method.
  def fetch_remote_image(filename)
    begin
      open(filename)
    rescue OpenURI::HTTPError => error
      log("Image #{filename} retrival returned #{error.message}, so this image was not imported")
    rescue
      log("Image #{filename} could not be downloaded, so was not imported.")
    end
  end

  ### TAXON HELPERS ###

  # associate_product_with_taxon
  # This method accepts three formats of taxon hierarchy strings which will
  # associate the given products with taxons:
  # 1. A string on it's own will will just find or create the taxon and
  # add the product to it. e.g. taxonomy = "Category", taxon_hierarchy = "Tools" will
  # add the product to the 'Tools' category.
  # 2. A item > item > item structured string will read this like a tree - allowing
  # a particular taxon to be picked out
  # 3. An item > item & item > item will work as above, but will associate multiple
  # taxons with that product. This form should also work with format 1.
  def associate_product_with_taxon(product, taxonomy, taxon_hierarchy)
    return if product.nil? || taxonomy.nil? || taxon_hierarchy.nil?
    #Using find_or_create_by_name is more elegant, but our magical params code automatically downcases
    # the taxonomy name, so unless we are using MySQL, this isn't going to work.
    taxonomy_name = taxonomy
    taxonomy = Spree::Taxonomy.find(:first, :conditions => ["lower(name) = ?", taxonomy])
    taxonomy = Spree::Taxonomy.create(:name => taxonomy_name.capitalize) if taxonomy.nil? && IMPORT_PRODUCT_SETTINGS[:create_missing_taxonomies]

    taxon_hierarchy.split(/\s*\&\s*/).each do |hierarchy|
      hierarchy = hierarchy.split(/\s*>\s*/)
      last_taxon = taxonomy.root
      hierarchy.each do |taxon|
        last_taxon = last_taxon.children.find_or_create_by_name_and_taxonomy_id(taxon, taxonomy.id)
      end

      #Spree only needs to know the most detailed taxonomy item
      product.taxons << last_taxon unless product.taxons.include?(last_taxon)
    end
  end
  ### END TAXON HELPERS ###

  # May be implemented via decorator if useful:
  #
  #    ProductImport.class_eval do
  #
  #      private
  #
  #      def after_product_built(product, params_hash)
  #        # so something with the product
  #      end
  #    end
  def after_product_built(product, params_hash)
  end
end

