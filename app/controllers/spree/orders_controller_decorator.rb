Spree::OrdersController.class_eval do
   # This method is to see-product price in cart added aginst Feature-39
   #    vacation_mode if vacation_mode.present?
    before_filter :vacation_mode_on_off
    def see_price_in_cart
      if user_signed_in?
        @order  = current_order(true)
        product = Spree::Product.find_by_permalink(params[:product_id])
        unless product.blank?
          @order.add_variant(product.master, 1)
        end
        fire_event('spree.cart.add')
        fire_event('spree.order.contents_changed')
        respond_with(@order) { |format| format.html { redirect_to cart_path } }
      else
        deny_access
      end
    end
    
end
