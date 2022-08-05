# Make sure roles are uniq
module Spotlight::RolesControllerDecorator
  def update_all
    authorize_nested_attributes! exhibit_params[:roles_attributes], Spotlight::Role

    if @exhibit.update(exhibit_params)
      notice = any_deleted ? t(:'helpers.submit.role.destroyed') : t(:'helpers.submit.role.updated')
      # OVERRIDE CAS vs invitable Spotlight::InviteUsersService.call(resource: @exhibit)
      redirect_to exhibit_roles_path(@exhibit), notice: notice
    else
      flash[:alert] = t(:'helpers.submit.role.batch_error', count: exhibit_params[:roles_attributes].to_unsafe_h.size)
      render action: 'index'
    end
  end

  def exhibit_params
    user_keys = []
    params['exhibit']['roles_attributes'].select! { |_k, v| user_keys << v['user_key'] unless user_keys.include?(v['user_key']) }
    params.require(:exhibit).permit(roles_attributes: %i[id user_key role _destroy])
  end
end

Spotlight::RolesController.prepend(Spotlight::RolesControllerDecorator)
