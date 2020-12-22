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
    path_params[:controller].delete_prefix!('/')
    path_params[:action] ||= 'index'
    extra_params = path_params.except(:controller, :action)
    r = RailsCom::Routes.controllers.dig(path_params[:controller], path_params[:action])
    if r.present?
      path_params[:business] = r[:business]
      path_params[:namespace] = r[:namespace]
    else
      path_params[:business] = params[:business]
      path_params[:namespace] = params[:namespace]
      path_params[:controller] = "#{params[:business]}/#{params[:namespace]}/#{path_params[:controller]}" unless path_params[:controller].include?('/')
    end

    if defined?(current_organ) && current_organ
      organ_permitted = current_organ.has_role?(params: extra_params, **path_params.slice(:business, :namespace, :controller, :action).symbolize_keys)
    else
      organ_permitted = true
    end
    if rails_role_user
      user_permitted = rails_role_user.has_role?(params: extra_params, **path_params.slice(:business, :namespace, :controller, :action).symbolize_keys)
    else
      user_permitted = true
    end
    logger.debug "  ----------> Options: #{_options} | Params: #{path_params} | Organ: #{organ_permitted} | #{rails_role_user.class.name}_#{rails_role_user.id}: #{user_permitted}"

    organ_permitted && user_permitted
  end

end
