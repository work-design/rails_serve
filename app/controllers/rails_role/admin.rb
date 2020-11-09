module RailsRole::Admin
  extend ActiveSupport::Concern

  included do

  end


  def rails_role_user
    defined?(current_member) && current_member
  end

end
