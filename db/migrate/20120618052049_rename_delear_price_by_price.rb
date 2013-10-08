class RenameDelearPriceByPrice < ActiveRecord::Migration
  def up
    rename_column :spree_product_user_groups, :delear_price, :price
  end

  def down
    rename_column :my_table, :price, :delear_price
  end
end
