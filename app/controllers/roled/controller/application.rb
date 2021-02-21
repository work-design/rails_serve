module Roled
  module Controller::Application
    extend ActiveSupport::Concern

    included do
      helper_method :rails_role_user
    end

    def support_organ
      if current_organ.has_role?(
        business: params[:business] || 'application',
        namespace: params[:namespace] || 'application',
        controller: controller_name,
        action: action_name,
        params: params
      )
        return
      elsif current_organ.nil?
        return
      elsif request.path == RailsRole.config.default_return_path
        return
      end

      role_access_denied
    end

    def require_role
      if rails_role_user && rails_role_user.has_role?(
        business: params[:business],
        namespace: params[:namespace],
        controller: controller_path,
        action: action_name,
        params: params
      )
        return
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
end
