module RailsRole::RoleType
  extend ActiveSupport::Concern

  included do
    attribute :who_type, :string

    belongs_to :role
  end

end
