# frozen_string_literal: true

module RailsRole::LinkHelper

  def link_to(name = nil, options = {}, html_options = {}, &block)
    if block_given?
      _options = name
      _html_options = options
    else
      _options = options
      _html_options = html_options
    end

    if role_permit?(_options, _html_options)
      super
    elsif _html_options[:text]
      ERB::Util.html_escape(name)
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
    else
      path_params = _options.slice(:controller, :action)
    end
    path_params[:controller] ||= controller_path
    path_params[:action] ||= 'index'
    extra_params = path_params.except(:controller, :action)

    if defined?(current_organ) && current_organ
      organ_permitted = current_organ.has_role?(
        path_params[:controller], path_params[:action], extra_params
      )
    else
      organ_permitted = true
    end
    if rails_role_user
      user_permitted = rails_role_user.has_role?(
        path_params[:controller], path_params[:action], extra_params
      )
    else
      user_permitted = true
    end

    organ_permitted && user_permitted
  end

end
