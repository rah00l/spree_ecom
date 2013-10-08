class AddMinQuntityToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :min_quantity, :integer
    add_column :spree_products, :max_quantity, :integer
  end

#  def down
#    remove_column :spree_products, :min_quantity
#    remove_column :spree_products, :max_quantity
#  end
end
