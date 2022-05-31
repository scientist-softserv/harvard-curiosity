# frozen_string_literal: true
# OVERRIDE spotlight 3.3.0 to add mask roles

module Spotlight
  ##
  # Exhibit roles helpers
  module RolesHelper
    ##
    # Format the available roles for a select_tag
    def roles_for_select
      # OVERRIDE spotlight 3.3.0 to add mask roles here
      Spotlight::Role::ROLES.each_with_object({}) do |key, object|
        object[t("spotlight.role.#{key}")] = key
      end
    end
  end
end
