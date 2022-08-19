require 'rails_com'
module RailsServe
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.helper false
      g.resource_route false
      g.templates.unshift File.expand_path('lib/templates', RailsCom::Engine.root)
    end
  end
end
