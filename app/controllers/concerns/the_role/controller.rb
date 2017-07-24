module TheRole::Controller

  def self.prepended(controller)
    controller.helper_method :the_role_user
  end

  def require_role(the_params = params['id'], &block)
    if block_given?
      yield block and return
    end

    if the_role_user.has_role? controller_path, action_name, the_params
      return true
    end

    if ['GET'].include?(request.method) && the_role_user.has_role?(controller_path, 'read', the_params)
      return true unless action_name.start_with?('new', 'edit')
    end

    role_access_denied
  end

  private
  def role_access_denied
    access_denied_method = TheRole.config.access_denied_method
    return send(access_denied_method) if access_denied_method && respond_to?(access_denied_method)

    default_access_denied_response
  end

  def default_access_denied_response
    access_denied_msg = t(:access_denied, scope: :the_role)

    if request.xhr?
      render file: TheRole::Engine.root + 'app/views/admin/base/errors.js.erb', status: 401
    else
      redirect_back fallback_location: root_url, flash: { error: access_denied_msg }
    end
  end

  def the_role_user
    defined?(current_user) && current_user
  end

end

ActionController::Base.prepend TheRole::Controller