module RailsRole::Application
  extend ActiveSupport::Concern

  included do
    helper_method :rails_role_user, :rails_role_organ
  end

  def support_organ(role_params = params['id'])
    if rails_role_organ && rails_role_organ.has_role?(controller_path, action_name, role_params)
      return
    elsif rails_role_organ.nil?
      return
    elsif request.path == RailsRole.config.default_return_path
      return
    end

    role_access_denied
  end

  def require_role
    if rails_role_user.has_role? controller_path, action_name, role_params
      return
    end

    role_access_denied
  end

  def rails_role_organ
    defined?(current_organ) && current_organ
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
