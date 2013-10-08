class CreatePopulateMultiplePromoCodes < ActiveRecord::Migration
  def up
    create_table :spree_populate_multiple_promo_codes do |t|
      t.integer :user_id
      t.integer :activator_id
      t.string :code

      t.timestamps
    end
  end
  def down
    drop_table :spree_populate_multiple_promo_codes
  end

end
