require 'rails_com'
class RailsRole::Engine < Rails::Engine

  config.autoload_paths += Dir[
    "#{config.root}/app/models/govern"
  ]

  config.generators do |g|
    g.rails = {
      assets: false,
      stylesheets: false,
      helper: false
    }
    g.test_unit = {
      fixture: true,
      fixture_replacement: :factory_girl
    }
    g.templates.unshift File.expand_path('lib/templates', RailsCom::Engine.root)
  end

end
