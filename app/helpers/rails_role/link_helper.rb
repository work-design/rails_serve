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
    path_params[:action] ||= action_name
    
    controller = RailsCom::Controllers.controller(path_params[:controller], path_params[:action])
    unless controller.detect_filter(:require_role)
      return true
    end

    if defined?(rails_role_user) && rails_role_user&.has_role?(path_params[:controller], path_params[:action])
      true
    end
  end

end
