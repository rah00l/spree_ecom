class AddDiscountPriceToSpreeManufactures < ActiveRecord::Migration
  def up
    add_column :spree_manufactures, :percent_discount, :integer
  end
  def down
    remove_column :spree_manufactures, :percent_discount
  end
end
