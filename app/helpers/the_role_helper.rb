module TheRoleHelper

  def link_to(name = nil, options = nil, html_options = nil, &block)
    if block_given?
      _options = name || {}
      _html_options = options
    else
      _options = options || {}
      _html_options = html_options
    end

    if _options.is_a? String
      begin
        path_params = Rails.application.routes.recognize_path _options, { method: _html_options&.fetch(:method, nil) }
      rescue ActionController::RoutingError
        return super
      end
    elsif _options.is_a? Symbol
      return super
    else
      path_params = _options.slice(:controller, :action)
    end
    path_params[:controller] ||= controller_path
    path_params[:action] ||= action_name

    controller = RailsCom::Controllers.controller(path_params[:controller]).new
    controller.action_name = path_params[:action]
    unless controller.detect_filter(:require_role)
      return super
    end

    if defined?(the_role_user) && the_role_user&.has_role?(path_params[:controller], path_params[:action])
      super
    end
  end

end