class CreateProductCategories < ActiveRecord::Migration
   def self.up
    create_table :spree_product_categories, :id => false do |t|
      t.references :product
      t.references :category
    end
    add_index :spree_product_categories, [:product_id, :category_id]
    add_index :spree_product_categories, [:category_id, :product_id]
  end

  def self.down
    drop_table :spree_product_categories  
  end
end
