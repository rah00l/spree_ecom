class AddSpecialPriceToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :special_price, :float
  end
end
