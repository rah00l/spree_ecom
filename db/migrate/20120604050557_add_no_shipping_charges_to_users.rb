class AddNoShippingChargesToUsers < ActiveRecord::Migration
  def up
    add_column :spree_users, :set_no_shipping_charges, :boolean , :default => false
  end
  def down
    remove_column :spree_users, :set_no_shipping_charges
  end
end
