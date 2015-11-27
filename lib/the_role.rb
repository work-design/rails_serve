module TheRole; end
require 'the_role/hash'
require 'the_role/config'
require 'the_role/version'

require 'multi_json'
require 'the_string_to_slug'

module TheRole

  class << self
    def create_admin!
      admin_role = ::Role.where(name: :admin).first_or_create!(
        name:        :admin,
        title:       "Role for admin",
        description: "This user can do anything"
      )
      admin_role.create_rule(:system, :administrator)
      admin_role.rule_on(:system, :administrator)
      admin_role
    end
  end

end