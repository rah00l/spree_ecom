Spree::CheckoutController.class_eval do

  #TODO 90% of this method is duplicated code. DRY
  def update
    if @order.update_attributes(object_params)

      fire_event('spree.checkout.update')
      if @order.coupon_code.present?
        if Spree::Promotion.exists?(:code => @order.coupon_code)
          promotion = Spree::Promotion.find_by_code(@order.coupon_code)
          event_name = promotion.event_name
           if event_name.eql?('spree.checkout.monthly_coupons')
              used_pomo = Spree::PromotionHistory.find_by_user_id_and_activator_id(@order.user.id,promotion.id) 
              unless used_pomo && promotion.expires_at > Time.zone.now
                    Spree::PromotionHistory.create(:user_id=> @order.user.id,:activator_id=>promotion.id)
                    fire_event('spree.checkout.monthly_coupons', :coupon_code => @order.coupon_code)
                 else
                   flash[:error] = t(:promotion_was_already_used)
                    render :edit and return
                 end
           else
               fire_event('spree.checkout.coupon_code_added', :coupon_code => @order.coupon_code)
           end
        else
          flash[:error] = t(:promotion_not_found)
          render :edit and return
        end
          # If it doesn't exist, raise an error!
          # Giving them another chance to enter a valid coupon code
      end

      if @order.next
        state_callback(:after)
      else
        flash[:error] = t(:payment_processing_failed)
        respond_with(@order, :location => checkout_state_path(@order.state))
        return
      end

      if @order.state == 'complete' || @order.completed?
        flash.notice = t(:order_processed_successfully)
        flash[:commerce_tracking] = 'nothing special'
        respond_with(@order, :location => completion_route)
      else
        respond_with(@order, :location => checkout_state_path(@order.state))
      end
    else
      respond_with(@order) { |format| format.html { render :edit } }
    end
  end

end
