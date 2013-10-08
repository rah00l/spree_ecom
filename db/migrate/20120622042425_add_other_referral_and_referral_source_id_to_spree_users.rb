class AddOtherReferralAndReferralSourceIdToSpreeUsers < ActiveRecord::Migration
  def up
    add_column :spree_users, :other_referral, :string
    add_column :spree_users, :referral_source_id, :integer
    add_column :spree_users, :birthdate, :date
  end
  def down
    remove_column :spree_users, :other_referral
    remove_column :spree_users, :referral_source_id
    remove_column :spree_users, :birthdate, :date

  end
end
