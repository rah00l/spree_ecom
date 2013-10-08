class AddFileNameToSpreeAssets < ActiveRecord::Migration
  def change
    add_column :spree_assets, :file_name, :string
  end
end
