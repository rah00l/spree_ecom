module Spree
  class Promotion < Spree::Activator
    MATCH_POLICIES = %w(all any)
    UNACTIVATABLE_ORDER_STATES = ["complete", "awaiting_return", "returned"]

    Activator.event_names << 'spree.checkout.coupon_code_added'
    Activator.event_names << 'spree.content.visited'
    Activator.event_names << 'spree.checkout.monthly_coupons'

    has_many :promotion_rules, :foreign_key => 'activator_id', :autosave => true, :dependent => :destroy
    has_many :promotion_histories, :foreign_key => 'activator_id'
    has_many :populate_multiple_promo_codes, :foreign_key => 'activator_id' ,:dependent => :destroy
    alias_method :rules, :promotion_rules
    accepts_nested_attributes_for :promotion_rules

    has_many :promotion_actions, :foreign_key => 'activator_id', :autosave => true, :dependent => :destroy
    alias_method :actions, :promotion_actions
    accepts_nested_attributes_for :promotion_actions

    # TODO: This shouldn't be necessary with :autosave option but nested attribute updating of actions is broken without it
    after_save :save_rules_and_actions
    after_save :users_populated_for_monthly_coupons
    def save_rules_and_actions
      (rules + actions).each &:save
    end

    validates :name, :presence => true
    validates :code, :presence => true, :if => lambda{|r| r.event_name == 'spree.checkout.coupon_code_added' }
    validates :code, :presence => true,:uniqueness => true, :if => lambda{|r| r.event_name == 'spree.checkout.monthly_coupons' }
    validates :path, :presence => true, :if => lambda{|r| r.event_name == 'spree.content.visited' }
    validates :usage_limit, :numericality => { :greater_than => 0, :allow_nil => true }
#    scope :event_name, lambda {where("event_name =?",'spree.checkout.monthly_coupons')}
    class << self
      def advertised
        where(:advertise => true)
      end
    end

    # TODO: Remove that after fix for https://rails.lighthouseapp.com/projects/8994/tickets/4329-has_many-through-association-does-not-link-models-on-association-save
    # is provided
    def save(*)
      if super
        promotion_rules.each { |p| p.save }
      end
    end

    def activate(payload)
      return unless order_activatable? payload[:order]

      if code.present?
        event_code = payload[:coupon_code].to_s.strip.downcase
        return unless event_code == self.code.to_s.strip.downcase
      end

      if path.present?
        return unless path == payload[:path]
      end

      actions.each do |action|
        action.perform(payload)
      end
    end

    # called anytime order.update! happens
    def eligible?(order)
      return false if expired? || usage_limit_exceeded?(order)
      rules_are_eligible?(order, {})
    end

    def rules_are_eligible?(order, options = {})
      return true if rules.none?
      eligible = lambda { |r| r.eligible?(order, options) }
      if match_policy == 'all'
        rules.all?(&eligible)
      else
        rules.any?(&eligible)
      end
    end

    def order_activatable?(order)
      order &&
      created_at.to_i < order.created_at.to_i &&
      !UNACTIVATABLE_ORDER_STATES.include?(order.state)
    end

    # Products assigned to all product rules
    def products
      @products ||= rules.of_type('Promotion::Rules::Product').map(&:products).flatten.uniq
    end

    def usage_limit_exceeded?(order = nil)
      usage_limit.present? && usage_limit > 0 && adjusted_credits_count(order) >= usage_limit
    end

    def adjusted_credits_count(order)
      return credits_count if order.nil?
      credits_count - (order.promotion_credit_exists?(self) ? 1 : 0)
    end

    def credits
      Adjustment.promotion.where(:originator_id => actions.map(&:id))
    end

    def credits_count
      credits.count
    end

    def users_populated_for_monthly_coupons
      if self.event_name == "spree.checkout.monthly_coupons"
        pmr = self.promotion_rules.create(:activator_id => self.id, :type => "Spree::Promotion::Rules::User")
        pmr.type = "Spree::Promotion::Rules::User"
        pmr.save
        self.update_attributes_without_callbacks(:usage_limit => Spree::User.count)
        Spree::User.all.each do |u |
          ActiveRecord::Base.connection.execute(
 "INSERT INTO `spree_promotion_rules_users` (`promotion_rule_id`, `user_id`) VALUES (#{pmr.id}, #{u.id})")
        end
      end
    end
  end
end
