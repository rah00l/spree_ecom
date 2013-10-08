class Spree::UserGroup < ActiveRecord::Base
  validates :name, :presence => true,:uniqueness => true
  has_many :users

  has_many :product_user_groups ,:dependent => :destroy
  has_many :products, :through => :product_user_groups


  has_many :manu_user_groups,:dependent => :destroy
  has_many :manufactures, :through => :manu_user_groups

  after_create :add_product_to_product_user_group

  def add_product_to_product_user_group
  Spree::UserGroup.all.each do  |user_group|
      Spree::Product.all.each do |product|
       Spree::ProductUserGroup.find_or_create_by_product_id_and_user_group_id(product.id,user_group.id)
     end
   end

   Spree::UserGroup.all.each do  |user_group|
      Spree::Manufacture.all.each do |manufacture|
       Spree::ManuUserGroup.find_or_create_by_manufacture_id_and_user_group_id(manufacture.id,user_group.id)
     end
   end

  end

  def user_ids_string
    user_ids.join(',')
  end

  def user_ids_string=(s)
    users = s.to_s.split(',').map(&:strip)
    users_aary = users.collect {|x| x.to_i}
    unmapped_users = (self.users.collect(&:id)- users_aary)

    users.each do |user_id|
      user = Spree::User.find(user_id)
      user.update_attribute(:user_group_id,self.id)
    end

    unmapped_users.each do |user_id|
      user = Spree::User.find(user_id)
      user.update_attribute(:user_group_id,nil)
    end
#    self.user_ids = s.to_s.split(',').map(&:strip)
  end
end