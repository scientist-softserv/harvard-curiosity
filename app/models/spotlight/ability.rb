# frozen_string_literal: true
# OVERRIDE spotlight 3.3.0 to add mask roles

module Spotlight
  ##
  # Default Spotlight CanCan abilities
  module Ability
    include CanCan::Ability

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def initialize(user)
      user ||= Spotlight::Engine.user_class.new

      alias_action :process_import, to: :import

      can :manage, :all if user.superadmin?

      can :manage, [PaperTrail::Version, Spotlight::FeaturedImage] if user.exhibit_roles.any?

      # OVERRIDE spotlight 3.3.0 to add mask roles- begin overrides
      if (user.is_masked?)
        # exhibit admin
        if (user.masked_role.eql?('admin'))
          can [:update, :import, :export, :destroy], Spotlight::Exhibit
          can :manage, [Spotlight::BlacklightConfiguration, Spotlight::ContactEmail, Spotlight::Language]
          can :manage, Spotlight::Role, resource_type: 'Spotlight::Exhibit'
        end
        # exhibit curator
        can :manage, [
          Spotlight::Attachment,
          Spotlight::Search,
          Spotlight::Resource,
          Spotlight::Page,
          Spotlight::Contact,
          Spotlight::CustomField,
          Translation
        ]
        can :read, Spotlight::JobTracker
        can :read, Spotlight::Language
        can [:read, :curate], Spotlight::Exhibit
      else
        can [:update, :import, :export, :destroy], Spotlight::Exhibit, id: user.admin_roles.pluck(:resource_id)
        can :manage, [Spotlight::BlacklightConfiguration, Spotlight::ContactEmail, Spotlight::Language], exhibit_id: user.admin_roles.pluck(:resource_id)
        can :manage, Spotlight::Role, resource_id: user.admin_roles.pluck(:resource_id), resource_type: 'Spotlight::Exhibit'
        # exhibit curator
        can :manage, [
          Spotlight::Attachment,
          Spotlight::Search,
          Spotlight::Resource,
          Spotlight::Page,
          Spotlight::Contact,
          Spotlight::CustomField,
          Translation
        ], exhibit_id: user.exhibit_roles.pluck(:resource_id)
        can :read, Spotlight::JobTracker, on_id: user.exhibit_roles.pluck(:resource_id), on_type: 'Spotlight::Exhibit'
        can :read, Spotlight::Language, exhibit_id: user.exhibit_roles.pluck(:resource_id)
        can [:read, :curate], Spotlight::Exhibit, id: user.exhibit_roles.pluck(:resource_id)
        can :read, Spotlight::Exhibit, id: user.viewer_roles.pluck(:resource_id)
      end
      # OVERRIDE spotlight 3.3.0 to add mask roles- end overrides

      can :manage, Spotlight::Lock, by: user

      # public
      can :read, Spotlight::HomePage
      can :read, Spotlight::Exhibit, published: true
      can :read, Spotlight::Page, published: true
      can :read, Spotlight::Search, published: true
      can :read, Spotlight::Group, published: true
      can :read, Spotlight::Language, public: true

    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
    end
  end
end