class TheRole::Engine < Rails::Engine

  initializer "the_role_precompile_hook", group: :all do |app|
    app.config.assets.precompile += %w(
        the_role_management_panel.js
        the_role_management_panel.css
      )
  end


end
