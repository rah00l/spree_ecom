class CreateUserGroups < ActiveRecord::Migration
  def self.up
    create_table :spree_user_groups do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :spree_user_groups
  end
end