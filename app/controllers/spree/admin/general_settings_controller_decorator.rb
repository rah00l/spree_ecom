Spree::Admin::GeneralSettingsController.class_eval do
  def show
    @preferences = ['site_name', 'default_seo_title', 'default_meta_keywords',
      'default_meta_description', 'site_url','no_of_seconds',
      'system_wide_notifications']
  end

  def edit
    @preferences = [:site_name, :default_seo_title, :default_meta_keywords,
      :default_meta_description, :site_url, :allow_ssl_in_production,
      :allow_ssl_in_staging, :allow_ssl_in_development_and_test,
      :check_for_spree_alerts,:no_of_seconds,:system_wide_notifications,:check_for_vacation_mode_on]
  end
  
end
  

