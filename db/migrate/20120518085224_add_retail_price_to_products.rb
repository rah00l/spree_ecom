class AddRetailPriceToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :retail_price, :float
  end
#  def down
#    remove_column :spree_products, :retail_price
#  end
end
