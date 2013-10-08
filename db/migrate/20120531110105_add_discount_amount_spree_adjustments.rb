class AddDiscountAmountSpreeAdjustments < ActiveRecord::Migration
  def up
    add_column :spree_adjustments, :discount_amount, :float
  end

  def down
    remove_column :spree_adjustments, :discount_amount
  end
end
