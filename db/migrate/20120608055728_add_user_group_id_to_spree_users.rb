class AddUserGroupIdToSpreeUsers < ActiveRecord::Migration
  def up
    add_column :spree_users, :user_group_id, :integer
  end
  def down
    remove_column :spree_users, :user_group_id
  end
end
