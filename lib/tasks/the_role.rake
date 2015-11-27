namespace :db do
  namespace :the_role do

    # rake db:the_role:admin
    desc 'create Admin Role'
    task :admin => :environment do
      unless Role.with_name(:admin)
        TheRole.create_admin!
        puts "TheRole >>> Admin role created"
      else
        puts "TheRole >>> Admin role exists"
      end
    end

  end
end
