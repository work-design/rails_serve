class TheRoleGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../../../../', __FILE__)
  # argument :xname, type: :string, default: :xname

  # bundle exec rails g the_role NAME
  def generate_controllers
    if gen_name == 'install'
      cp_models
      cp_config
    elsif gen_name == 'config'
      cp_config
    elsif gen_name == 'models'
      cp_models
    elsif gen_name == 'controllers'
      cp_controllers
    elsif gen_name == 'locales'
      cp_locales
    elsif gen_name == 'help'
      cp_help
    else
      puts 'TheRole Generator - wrong Name'
      puts 'Try to use install'
    end
  end

  private

  def gen_name
    name.to_s.downcase
  end

  def cp_config
    copy_file 'config/initializers/the_role.rb',
              'config/initializers/the_role.rb'
  end

  def cp_models
    copy_file 'app/models/_templates_/role.rb',
              'app/models/role.rb'
  end

  def cp_controllers
    directory 'app/controllers',
              'app/controllers'
  end

  def cp_locales
    directory 'config/locales',
              'config/locales'
  end

  def cp_help
    puts File.read "#{ TheRoleGenerator.source_root }/lib/generators/the_role/USAGE"
  end
end
