module TheRoleHelper

  def link_to_if_permit(name = nil, options = nil, html_options = nil, &block)
    if block_given?
      _options = name
      _html_options = options
    else
      _options = options
      _html_options = html_options
    end

    if _options.is_a? String
      path_params = Rails.application.routes.recognize_path _options, { method: _html_options[:method] }
    else
      path_params = _options.slice(:controller, :action)
    end

    if the_role_user.has_role? path_params[:controller], path_params[:action]
      link_to(name, options, html_options, &block)
    end
  end

end