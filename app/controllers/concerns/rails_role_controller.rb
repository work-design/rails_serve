module RailsRoleController

  def self.prepended(controller)
    controller.helper_method :rails_role_user
  end

  def require_role(the_params = params['id'])
    if rails_role_user.has_role? controller_path, action_name, the_params
      return true
    end

    role_access_denied
  end

  private
  def role_access_denied
    access_denied_method = RailsRole.config.access_denied_method
    return send(access_denied_method) if access_denied_method && respond_to?(access_denied_method)

    default_access_denied_response
  end

  def default_access_denied_response
    access_denied_msg = t(:access_denied, scope: :rails_role)

    if request.xhr?
      render file: RailsRole::Engine.root + 'app/views/rails_role_admin/base/errors.js.erb', status: 403
    elsif request.format.json?
      raise ActionController::ForbiddenError
    else
      redirect_back fallback_location: root_url, flash: { error: access_denied_msg }
    end
  end

  def rails_role_user
    defined?(current_user) && current_user
  end

end

ActionController::Base.prepend RailsRoleController