class CreateManuUserGroups < ActiveRecord::Migration
  def self.up
    create_table :spree_manu_user_groups do |t|
      t.references :manufacture
      t.references :user_group
      t.float :price_discount
    end
  end

  def self.down
    drop_table :spree_manu_user_groups
  end
end
