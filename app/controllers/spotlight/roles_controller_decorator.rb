# Make sure roles are uniq
module Spotlight
  module Spotlight::RolesControllerDecorator
    def exhibit_params
      user_keys = []
      params['exhibit']['roles_attributes'].select! { |k, v| user_keys << v['user_key'] if !user_keys.include?(v['user_key'])}
      params.require(:exhibit).permit(roles_attributes: %i[id user_key role _destroy])
    end
  end
end

Spotlight::RolesController.prepend(Spotlight::RolesControllerDecorator)
