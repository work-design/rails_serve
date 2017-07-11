module TheRoleHelper

  def link_to(name = nil, options = nil, html_options = nil, &block)
    if block_given?
      _options = name
      _html_options = options
    else
      _options = options
      _html_options = html_options
    end

    if _options.is_a? String
      path_params = Rails.application.routes.recognize_path _options, { method: _html_options&.fetch(:method, nil) }
    else
      path_params = _options.slice(:controller, :action)
    end

    if defined?(the_role_user) && the_role_user.has_role?(path_params[:controller], path_params[:action])
      super
    end
  end

end