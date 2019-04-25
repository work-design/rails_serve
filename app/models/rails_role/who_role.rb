module RailsRole::WhoRole
  extend ActiveSupport::Concern
  included do
    belongs_to :who, polymorphic: true
    belongs_to :role
  end

end
