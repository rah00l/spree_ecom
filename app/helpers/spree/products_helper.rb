module Spree
  module ProductsHelper
    # returns the formatted change in price (from the master price) for the specified variant (or simply return
    # the variant price if no master price was supplied)
    def variant_price_diff(variant)
      diff = variant.price - variant.product.price
      return nil if diff == 0
      if diff > 0
        "(#{t(:add)}: #{number_to_currency diff.abs})"
      else
        "(#{t(:subtract)}: #{number_to_currency diff.abs})"
      end
    end

    # returns the price of the product to show for display purposes
    def product_price(product_or_variant, options={})
       ActiveSupport::Deprecation.warn('product_price is deprecated and no longer calculates
                                        tax.  Use number_to_currency instead.', caller)
    end

    # converts line breaks in product description into <p> tags (for html display purposes)
    def product_description(product)
      raw(product.description.gsub(/^(.*)$/, '<p>\1</p>'))
    end

    def variant_images_hash(product)
      product.variant_images.inject({}) { |h, img| (h[img.viewable_id] ||= []) << img; h }
    end

    def conditional_order(name)
      order = name.eql?('New Products')
      set_order = name.eql?('New Products') ? 'available_on desc' : ''
    end

    def conditional_limit(name)
       limit = Spree::Category.default_active_categories.find_by_name(name).no_of_rows_to_show if Spree::Category.default_active_categories.find_by_name(name)
       limit.blank? ? (5*3) : (limit*3)
    end

    def need_to_buy(max,available)
      need_to_buy = max.to_i - available.to_i
      need_to_buy> 0?  need_to_buy  : 0
    end

    def manufactures_for_select
      Spree::Manufacture.order('name').collect{ |manu| [manu.name, manu.id] }
    end

  end
end
