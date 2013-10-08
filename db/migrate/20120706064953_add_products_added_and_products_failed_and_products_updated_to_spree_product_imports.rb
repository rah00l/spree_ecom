class AddProductsAddedAndProductsFailedAndProductsUpdatedToSpreeProductImports < ActiveRecord::Migration
  def change
    add_column :spree_product_imports, :products_added, :integer
    add_column :spree_product_imports, :products_failed, :integer
    add_column :spree_product_imports, :products_updated, :integer
  end
end
