class AddSeePriceInTheCartToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :see_price_in_the_cart, :boolean, :default => 0
  end

#  def down
#    remove_column :spree_products, :see_price_in_the_cart
#  end


end
