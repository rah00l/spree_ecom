class AddNewsletterToUsers < ActiveRecord::Migration
  def up
    add_column :spree_users, :newsletter, :boolean, :default => 0
  end
  def down
    remove_column :spree_users, :newsletter
  end
end
