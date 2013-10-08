module Spree
  module Admin
    class ProductsController < ResourceController
      helper 'spree/products'

      before_filter :check_json_authenticity, :only => :index
      before_filter :load_data, :except => :index
      update.before :update_before
      def index
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end
      end

      def remove_product_taxons
        @product = load_product
        @taxon = Spree::Taxon.find(params[:taxonomy_id])
        @taxon.products.delete(@product)
        @taxon.save
        @products = @taxon.products
        respond_with(@product) { |format| format.js { render_js_for_destroy } }
      end

      def selected_product_taxons
        @product = load_product
        @taxons = @product.taxons
      end

      def available_products_for_taxon
#       @taxonomy = load_taxonomy
#       @taxon = @taxonomy.taxons.find_by_parent_id(nil)
        if params[:taxon_id].present?
            params[:taxon_id] = params[:taxon_id]
        else
            params[:taxon_id] = params[:taxonomy_id]
        end
#        raise params[:taxon_id].inspect
        @taxon = load_taxon
        @products = params[:q].blank? ? [] : Product.where('lower(name) LIKE ?', "%#{params[:q].mb_chars.downcase}%")
        @products.delete_if { |product| @taxon.products.include?(product) }
        respond_with(:admin, @products)
      end

      def select_products
        @product = load_product
#        @taxonomy = Spree::Taxonomy.find(params[:taxonomy_id])
#        @taxon = @taxonomy.taxons.find_by_parent_id(nil)
        @taxon = Spree::Taxon.find(params[:taxonomy_id])
        @taxon.products << @product
        @products = @taxon.products
      end


#      def select
#        @product = load_product
#        @taxon = Taxon.find(params[:id])
#        @product.taxons << @taxon
#        @product.save
#        @taxons = @product.taxons
#
#        respond_with(:admin, @taxons)
#      end

      # override the destory method to set deleted_at value
      # instead of actually deleting the product.
      def destroy
        @product = Product.find_by_permalink!(params[:id])
        @product.update_attribute(:deleted_at, Time.now)

        @product.variants_including_master.update_all(:deleted_at => Time.now)

        flash.notice = I18n.t('notice_messages.product_deleted')

        respond_with(@product) do |format|
          format.html { redirect_to collection_url }
          format.js  { render_js_for_destroy }
        end
      end

      def clone
        @new = @product.duplicate

        if @new.save
          flash.notice = I18n.t('notice_messages.product_cloned')
        else
          flash.notice = I18n.t('notice_messages.product_not_cloned')
        end

        respond_with(@new) { |format| format.html { redirect_to edit_admin_product_url(@new) } }
      end

      protected

      def find_resource
        Product.find_by_permalink!(params[:id])
      end

      def location_after_save
        edit_admin_product_url(@product)
      end

      # Allow different formats of json data to suit different ajax calls
      def json_data
        json_format = params[:json_format] or 'default'
        case json_format
        when 'basic'
          collection.map {|p| {'id' => p.id, 'name' => p.name}}.to_json
        else
          collection.to_json(:include => {:variants => {:include => {:option_values => {:include => :option_type}, 
                                                        :images => {:only => [:id], :methods => :mini_url}}}, 
                                                        :images => {:only => [:id], :methods => :mini_url}, :master => {}})
        end
      end

      def load_data
        @tax_categories = TaxCategory.order(:name)
        @shipping_categories = ShippingCategory.order(:name)
      end

      def collection
        return @collection if @collection.present?

        unless request.xhr?
          params[:search] ||= {}
          # Note: the MetaSearch scopes are on/off switches, so we need to select "not_deleted" explicitly if the switch is off
          if params[:search][:deleted_at_is_null].nil?
            params[:search][:deleted_at_is_null] = "1"
          end

          params[:search][:meta_sort] ||= "name.asc"
          @search = super.metasearch(params[:search])

          @collection = @search.relation.group_by_products_id.includes([:master, {:variants => [:images, :option_values]}]).page(params[:page]).per(Spree::Config[:admin_products_per_page])
        else
          includes = [{:variants => [:images,  {:option_values => :option_type}]}, :master, :images]

          @collection = super.where(["name #{LIKE} ?", "%#{params[:q]}%"])
          @collection = @collection.includes(includes).limit(params[:limit] || 10)

          tmp = super.where(["#{Variant.table_name}.sku #{LIKE} ?", "%#{params[:q]}%"])
          tmp = tmp.includes(:variants_including_master).limit(params[:limit] || 10)
          @collection.concat(tmp)

          @collection.uniq
        end

      end

      def update_before
        # note: we only reset the product properties if we're receiving a post from the form on that tab
        return unless params[:clear_product_properties]
        params[:product] ||= {}
      end

       def load_product
        Spree::Product.find_by_permalink! params[:product_id]
      end

       def load_taxonomy
        Spree::Taxonomy.find(params[:taxonomy_id])
      end

       def load_taxon
        Spree::Taxon.find(params[:taxon_id])
      end

    end
  end
end

