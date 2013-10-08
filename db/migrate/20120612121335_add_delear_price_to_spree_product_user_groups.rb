class AddDelearPriceToSpreeProductUserGroups < ActiveRecord::Migration
  def up
    add_column :spree_product_user_groups, :delear_price, :float
  end
  def down
    remove_column :spree_product_user_groups, :delear_price
  end
end
