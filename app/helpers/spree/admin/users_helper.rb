module Spree
  module Admin
    module UsersHelper
      def list_roles(user)
        # while testing spree-core itself user model does not have method roles
        user.respond_to?(:roles) ? user.roles.collect { |role| role.name }.join(", ") : []
      end
      def user_groups_for_select
          UserGroup.find(:all, :order => 'name').collect {|ug| [ ug.name, ug.id ] }
      end
      def select_referrals
        ReferralSource.find(:all,:order => 'name').collect {|rs| [rs.name, rs.id]}
      end
    end
  end
end
