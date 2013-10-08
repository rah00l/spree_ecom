class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :spree_categories do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :spree_categories
  end
end