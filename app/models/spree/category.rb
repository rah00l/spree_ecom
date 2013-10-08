class Spree::Category < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :product_categories
  has_many :products, :through => :product_categories
  scope :default_active_categories, :conditions => ['activate != 0']
  scope :exclude_spl_categories, :conditions => [ 'name != "New Products" and name != "Upcoming Products"' ]
#  scope :exclude_up_coming_categories, :conditions => [ 'name != "Upcoming Products"' ]
end