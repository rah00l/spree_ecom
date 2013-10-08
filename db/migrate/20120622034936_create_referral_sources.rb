class CreateReferralSources < ActiveRecord::Migration
  def self.up
    create_table :spree_referral_sources do |t|
      t.string :name
    end
    Spree::ReferralSource.create(:name=> 'AOL')
    Spree::ReferralSource.create(:name=> 'Google')
    Spree::ReferralSource.create(:name=> 'MSN')
    Spree::ReferralSource.create(:name=> 'Neo Buggy')
    Spree::ReferralSource.create(:name=> 'RC Tech')
    Spree::ReferralSource.create(:name=> 'Sports Buggy')
    Spree::ReferralSource.create(:name=> 'Yahoo!')
    Spree::ReferralSource.create(:name=> 'Other - (Please specify)')
  end

  def self.down
    drop_table :spree_referral_sources
  end
end
