class Admin::UserGroupsController < Spree::Admin::ResourceController
  
  def index
    @user_groups = Spree::UserGroup.page(params[:page] || 1).per(50)
  end

  def new
    @user_group = Spree::UserGroup.new
  end

  def create
    @user_group = Spree::UserGroup.new(params[:user_group])
    if @user_group.save
      flash[:notice] = "Successfully created User Group."
      redirect_to main_app.edit_admin_user_group_path(@user_group)
    else
      render :action => 'new'
    end
  end

  def edit
    @user_group = Spree::UserGroup.find(params[:id])
  end

  def update
    @page = Spree::UserGroup.find(params[:id])
    if @user_group.update_attributes(params[:user_group])
      flash[:notice] = "Successfully updated User Group."
      redirect_to main_app.admin_user_groups_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user_group = Spree::UserGroup.find(params[:id])
    @user_group.destroy
    flash[:notice] = "Successfully destroyed User Group."
    redirect_to main_app.admin_user_groups_url
  end

end