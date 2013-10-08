class Admin::ManufacturesController < Spree::Admin::ResourceController
  
  def index
    @manufactures = Spree::Manufacture.page(params[:page] || 1).per(50)
  end

  def new
    @manufacture = Spree::Manufacture.new
  end

  def create
    @manufacture = Spree::Manufacture.new(params[:manufacture])
    if @manufacture.save
      flash[:notice] = "Successfully created Manufacture."
      redirect_to main_app.edit_admin_manufacture_path(@manufacture)
    else
      render :action => 'new'
    end
  end

  def edit
    @manufacture = Spree::Manufacture.find(params[:id])
  end

  def update
    @page = Spree::Manufacture.find(params[:id])
    if @manufacture.update_attributes(params[:manufacture])
      flash[:notice] = "Successfully updated Manufacture."
      redirect_to main_app.admin_manufactures_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @manufacture = Spree::Manufacture.find(params[:id])
    @manufacture.destroy
    flash[:notice] = "Successfully destroyed Manufacture."
    redirect_to main_app.admin_manufactures_path
  end

end