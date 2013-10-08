class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
#  protected
#
#  def login_reqired!
#    unless user_signed_in?
#      session[:return_to] = request.fullpath
#      redirect_to login_path and return
#    end
#  end
before_filter :set_user
  def set_user
    Spree::Variant.current_user = current_user
  end
  # Customize the Devise after_sign_in_path_for() for redirecct to previous page after login
  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when :user
      store_location = session[:return_to]
      clear_stored_location
      (store_location.nil?) ? "/" : store_location.to_s
    else
      super
    end
  end

  def vacation_mode_on_off
      vaction_name = get_vaction_name
      flash[:notice] = "#{vaction_name}" if vaction_name.present?
  end

  def get_vaction_name
    system_wide_notifications = Spree::Preference.find_by_key("spree/app_configuration/system_wide_notifications")
    vacation_name = system_wide_notifications.value if system_wide_notifications.present?
  end

  

end
