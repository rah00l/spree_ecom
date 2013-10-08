class Admin::CategoriesController < Spree::Admin::ResourceController
  
  def index
    @categories = Spree::Category.page(params[:page] || 1).per(50)
  end

  def new
    @category = Spree::Category.new
  end

  def create
    @category = Spree::Category.new(params[:category])
    if @category.save
      flash[:notice] = "Successfully created Category."
      redirect_to main_app.admin_categories_url
    else
      render :action => 'new'
    end
  end

  def show
    @category = Spree::Category.find(params[:id])
    @products = @category.products   #.page(params[:page] || 1).per(10)
  end

  def edit
    @category = Spree::Category.find(params[:id])
  end

  def update
    @page = Spree::Category.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = "Successfully updated Category."
      redirect_to main_app.admin_categories_url
    else
      render :action => 'edit'
    end
  end



  def destroy
    @category = Spree::Category.find(params[:id])
    @category.destroy
    flash[:notice] = "Successfully destroyed Category."
    redirect_to admin_categories_url
  end

end