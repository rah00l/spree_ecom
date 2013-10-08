class AddactivateToSpreeCategories < ActiveRecord::Migration
  def up
    add_column :spree_categories, :activate, :boolean, :default=> 1
    add_column :spree_categories, :no_of_rows_to_show, :integer
  end

  def down
    remove_column :spree_categories, :activate
    remove_column :spree_categories, :no_of_rows_to_show
  end
end
