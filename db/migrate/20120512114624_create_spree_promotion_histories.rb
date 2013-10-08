class CreateSpreePromotionHistories < ActiveRecord::Migration
  def up
    create_table :spree_promotion_histories do |t|
#      t.string :promo_name
#      t.datetime :starts_at
#      t.datetime :expires_at
      t.integer :user_id
      t.integer :activator_id
#      t.string :promo_code
      t.timestamps
    end
  end

  def down
    drop_table :spree_promotion_histories
  end

end
