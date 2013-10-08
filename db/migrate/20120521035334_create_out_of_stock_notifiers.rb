class CreateOutOfStockNotifiers < ActiveRecord::Migration
  def up
    create_table :spree_out_of_stock_notifiers do |t|
      t.integer :product_id
      t.integer :user_id
      t.datetime :stock_notification

      t.timestamps
    end

    def down
      drop_table :spree_out_of_stock_notifiers
    end
  end
end
