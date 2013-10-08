Spree::CheckoutController.class_eval do
    before_filter :vacation_mode_on_off
    def before_address
#    raise current_user.bill_address.inspect
    if current_user
      @order.bill_address ||= current_user.bill_address
      @order.ship_address ||= current_user.ship_address
    end
    @order.bill_address ||= Spree::Address.new(:country_id => Spree::Config[:default_country_id])
    @order.ship_address ||= Spree::Address.new(:country_id => Spree::Config[:default_country_id])

  end
end
