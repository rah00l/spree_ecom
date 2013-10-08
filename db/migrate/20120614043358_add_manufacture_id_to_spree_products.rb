class AddManufactureIdToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :manufacture_id, :integer
  end
end
