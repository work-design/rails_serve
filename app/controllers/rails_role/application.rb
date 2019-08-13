module RailsRole::Application
  extend ActiveSupport::Concern
  included do
    helper_method :rails_role_user
  end

  def require_role(role_params = params['id'])
    if rails_role_user.has_role? controller_path, action_name, role_params
      return true
    end

    role_access_denied
  end

  def rails_role_user
    defined?(current_user) && current_user
  end

  private
  def role_access_denied
    message = I18n.t(:access_denied, scope: :rails_role)

    if request.xhr?
      render 'errors.js.erb', status: 403
    elsif request.format.json?
      raise ActionController::ForbiddenError
    else
      redirect_to RailsRole.config.default_return_path, alert: message
    end
  end
  
end
