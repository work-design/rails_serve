class TheRole::Engine < Rails::Engine

  config.eager_load_paths += Dir[
    "#{config.root}/app/models/the_role",
    "#{config.root}/app/models/the_role/concerns",
    "#{config.root}/app/models/the_role/governs"
  ]

  initializer 'the_role.prepare' do |app|
  end

end
