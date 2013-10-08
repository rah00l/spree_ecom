class Spree::Manufacture < ActiveRecord::Base
  has_many :products
  has_many :manu_user_groups,:dependent => :destroy
  has_many :user_groups, :through => :manu_user_groups
  accepts_nested_attributes_for :manu_user_groups
  after_create :add_manufacture_to_manu_user_groups
  def add_manufacture_to_manu_user_groups
  Spree::UserGroup.all.each do  |user_group|
     Spree::Manufacture.all.each do |manufacture|
       Spree::ManuUserGroup.find_or_create_by_manufacture_id_and_user_group_id(manufacture.id,user_group.id)
     end
   end
  end
end