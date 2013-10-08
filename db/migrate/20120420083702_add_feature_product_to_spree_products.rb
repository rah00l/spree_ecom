class AddFeatureProductToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :feature_product, :integer, :default=> 0
  end
end
