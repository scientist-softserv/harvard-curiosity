# frozen_string_literal: true
# OVERRIDE spotlight 3.3.0 to add mask roles

module Spotlight
  ##
  # Spotlight user mixins for roles
  module User
    extend ActiveSupport::Concern
    included do
      has_many :roles, class_name: 'Spotlight::Role', dependent: :destroy
      has_many :exhibits, class_name: 'Spotlight::Exhibit', through: :roles, source: 'resource', source_type: 'Spotlight::Exhibit'

      scope :with_roles, -> { where(id: Spotlight::Role.distinct.pluck(:user_id)) }

      before_create :add_default_roles
    end

    # OVERRIDE spotlight 3.3.0 to add mask roles- begin overrides
    def superadmin?
      #If the superadmin is in different view, then return false as superadmin
      if (!masked_role.nil?)
        false
      else
        roles.where(role: 'admin', resource: Spotlight::Site.instance).any?
      end
    end

    def exhibit_roles
      role = masked_role
      if (!role.nil? && !role.empty?)
        maskedroles = Array.new
        if (!role.eql?('public'))
          maskedroles << role
        end
      else
        roles.where(resource_type: 'Spotlight::Exhibit')
      end
    end

    def admin_roles
      role = masked_role
      if (!role.nil? && !role.empty?)
        maskedroles = Array.new
        if (role.eql?('admin'))
          maskedroles << role
        end
      else
        exhibit_roles.where(role: 'admin')
      end
    end

    def is_masked?
      role = masked_role
      !role.nil? && !role.empty?
    end

    def get_formatted_mask
      role = masked_role
      formatted = 'Public (Read Only)'
      if (role.eql?('admin'))
        formatted = 'Exhibit Admin'
      elsif (role.eql?('curator'))
        formatted = 'Curator'
      end
    end
    # OVERRIDE spotlight 3.3.0 to add mask roles- end overrides

    def viewer_roles
      roles.where(resource_type: 'Spotlight::Exhibit', role: 'viewer')
    end

    def add_default_roles
      return unless Spotlight::Engine.config.assign_default_roles_to_first_user

      roles.build role: 'admin', resource: Spotlight::Site.instance unless self.class.any?
    end

    def invite_pending?
      false
    end

    alias_attribute :user_key, :email

    ##
    # Class-level user mixins
    module ClassMethods
      def find_by_user_key(key)
        find_by email: key
      end
    end

    # OVERRIDE spotlight 3.3.0 to add mask roles- begin overrides
    def masked_role
      masked_role = roles.where.not(role_mask: [nil, '']).pluck(:role_mask).first
    end
    # OVERRIDE spotlight 3.3.0 to add mask roles- end overrides
  end
end
