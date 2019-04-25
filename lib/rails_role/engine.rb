require 'rails_com'
class RailsRole::Engine < Rails::Engine

  initializer 'rails_role.assets.precompile' do |app|
    app.config.assets.precompile += ['rails_role_manifest.js']
  end

end
