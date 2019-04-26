require 'rails_com'
class RailsRole::Engine < Rails::Engine

  config.autoload_paths += Dir[
    "#{config.root}/app/models/govern"
  ]
  
  initializer 'rails_role.assets.precompile' do |app|
    app.config.assets.precompile += ['rails_role_manifest.js']
  end

end
