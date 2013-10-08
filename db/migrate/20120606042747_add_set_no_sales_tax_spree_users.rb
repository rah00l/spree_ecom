class AddSetNoSalesTaxSpreeUsers < ActiveRecord::Migration
  def up
    add_column :spree_users, :set_no_sales_tax, :boolean , :default => false
  end

  def down
    remove_column :spree_users, :set_no_sales_tax
  end
end
