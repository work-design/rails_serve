require 'rails_com'
class RailsRole::Engine < Rails::Engine

  config.eager_load_paths += Dir[
    "#{config.root}/app/models/rails_role",
    "#{config.root}/app/models/rails_role/concerns",
    "#{config.root}/app/models/rails_role/governs"
  ]

  initializer 'rails_role.assets.precompile' do |app|
    app.config.assets.precompile += ['rails_role_manifest.js']
  end

end
