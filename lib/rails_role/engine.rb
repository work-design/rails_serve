require 'rails_com'
class RailsRole::Engine < Rails::Engine

  config.autoload_paths += Dir[
    "#{config.root}/app/models/govern"
  ]

end
