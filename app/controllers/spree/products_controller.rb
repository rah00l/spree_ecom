module Spree
  class ProductsController < BaseController
    HTTP_REFERER_REGEXP = /^https?:\/\/[^\/]+\/t\/([a-z0-9\-\/]+)$/
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'spree/taxons'
#   before_filter :check_authenticity, :only => :show
    before_filter :vacation_mode_on_off

    respond_to :html

    def index
      @products = Spree::Product.all
#      raise Spree::Product.all.collect(&:feature_product).inspect
      @features = Spree::Product.find_all_by_feature_product(1)
      @categories = Spree::Category.default_active_categories
      @categories.rotate!(@categories.collect(&:name).index("New Products")) if @categories.collect(&:name).include?("New Products")
      if Spree::Preference.find_by_key("spree/app_configuration/rotator_time")
        @config_time = Spree::Preference.find_by_key("spree/app_configuration/rotator_time").value * 1000
      else
        @config_time = (2*1000)
      end
      respond_with(@products)      
    end

    def show
      @product = Product.find_by_permalink!(params[:id])
      return unless @product

      @variants = Variant.active.includes([:option_values, :images]).where(:product_id => @product.id)
      @product_properties = ProductProperty.includes(:property).where(:product_id => @product.id)

      referer = request.env['HTTP_REFERER']

      if referer && referer.match(HTTP_REFERER_REGEXP)
        @taxon = Taxon.find_by_permalink($1)
      end
      respond_with(@product)
    end

    def out_of_stock_notifier
      if user_signed_in?
        product = Spree::Product.find_by_permalink(params[:product_id])
        Spree::OutOfStockNotifier.find_or_create_by_product_id_and_user_id(:product_id=>product.id,:user_id=>current_user.id)
        flash[:notice] = "Currently this product is out of stock , We will Notify once product is available "
        session[:return_to] ||= request.env['HTTP_REFERER']
        redirect_to session[:return_to]
      else
        deny_access
      end
    end

    def update_states
      country = Spree::Country.find(params[:id])
      @states = country.states.order(:name)
    end

    private
      def accurate_title
        @product ? @product.name : super
      end
  end
end
