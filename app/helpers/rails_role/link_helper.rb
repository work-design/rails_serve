# frozen_string_literal: true

module RailsRole::LinkHelper

  def link_to(name = nil, options = nil, html_options = nil, &block)
    if block_given?
      _options = name
      _html_options = options || {}
    else
      _options = options
      _html_options = html_options || {}
    end

    if role_permit?(_options, _html_options)
      super
    elsif _html_options[:text]
      if block_given?
        capture(&block)
      else
        ERB::Util.html_escape(name)
      end
    end
  end

  def role_permit?(_options, _html_options)
    if _options.is_a? String
      begin
        path_params = Rails.application.routes.recognize_path _options, { method: _html_options.fetch(:method, nil) }
      rescue ActionController::RoutingError
        return true
      end
    elsif _options == :back
      return true
    elsif _options.is_a? Hash
      path_params = _options.slice(:controller, :action)
    else
      path_params = {}
    end
    path_params[:controller] ||= controller_path
    path_params[:action] ||= 'index'
    r = RailsExtend::Routes.controllers.dig(path_params[:controller].delete_prefix('/'), path_params[:action])
    Rails.application.routes.send :generate, nil, path_params, request.path_parameters  # 例如 'orders' -> 'trade/me/orders'
    if r.present?
      path_params[:business] = r[:business]
      path_params[:namespace] = r[:namespace]
    else
      path_params[:business] = params[:business]
      path_params[:namespace] = params[:namespace]
      path_params[:controller] = path_params[:controller]
    end
    extra_params = path_params.except(:controller, :action, :business, :namespace)

    if defined?(current_organ) && current_organ
      organ_permitted = current_organ.has_role?(params: extra_params, **path_params.slice(:business, :namespace, :controller, :action).symbolize_keys)
    else
      organ_permitted = true
    end
    if defined?(rails_role_user) && rails_role_user
      user_permitted = rails_role_user.has_role?(params: extra_params, **path_params.slice(:business, :namespace, :controller, :action).symbolize_keys)
    else
      user_permitted = true
    end

    result = organ_permitted && user_permitted
    if RailsRole.config.debug || !result
      logger.debug "  \e[35mOptions: #{_options}\e[0m"
      logger.debug "  \e[35mParams: #{path_params}\e[0m"
      logger.debug "  \e[35mOrgan: #{organ_permitted}\e[0m"
      logger.debug "  \e[35mUser: #{rails_role_user&.class&.name}_#{rails_role_user&.id}: #{user_permitted.inspect}\e[0m"
    end

    result
  end

end
