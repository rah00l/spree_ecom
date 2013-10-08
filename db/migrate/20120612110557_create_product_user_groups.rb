class CreateProductUserGroups < ActiveRecord::Migration
  def self.up
    create_table :spree_product_user_groups do |t|
      t.references :product
      t.references :user_group
#      t.float :delear_price
    end
  end

  def self.down
    drop_table :spree_product_user_groups
  end
end


   

