Spree::HomeController.class_eval do
  helper 'spree/products'
    respond_to :html
    before_filter :vacation_mode_on_off
#    before_filter :require_user
    before_filter :set_current_user
    def index
#      raise "inside index".inspect
      @products = Spree::Product.all
      @features = Spree::Product.find_all_by_feature_product(1)
      @categories = Spree::Category.default_active_categories
      @categories.rotate!(@categories.collect(&:name).index("New Products")) if @categories.collect(&:name).include?("New Products")
      no_of_sec = Spree::Preference.find_by_key("spree/app_configuration/no_of_seconds")
      if no_of_sec
        @config_time = no_of_sec.value.to_i * 1000
      else
        @config_time = (2*1000)
      end
      respond_with(@products)      
    end

    
end
