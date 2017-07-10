module TheRoleHelper

  def link_to_if_permit(name = nil, options = nil, html_options = nil, &block)
    path = url_for
    path_params = Rails.application.routes.recognize_path options, {method: options[:method]}
    if the_role_user.has_role? path_params[:controller], path_params[:action]
      link_to(name, options, html_options, &block)
    end
  end

end