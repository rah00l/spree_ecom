module Spree
  class Promotion::Rules::User < PromotionRule
    belongs_to :user
    has_and_belongs_to_many :users, :class_name => '::Spree::User', :join_table => 'spree_promotion_rules_users', :foreign_key => 'promotion_rule_id'

    belongs_to :bill_address, :foreign_key => 'bill_address_id', :class_name => 'Spree::Address'
    attr_accessible :bill_address,:user_ids_string
    def eligible?(order, options = {})
      users.none? or users.include?(order.user)
    end

    def user_ids_string
      user_ids.join(',')
    end

    def user_ids_string=(s)
      self.user_ids = s.to_s.split(',').map(&:strip)
    end
  end
end
