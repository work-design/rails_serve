module RailsRole::Argument
  extend ActiveSupport::Concern

  included do
    attribute :controller_identifier, :string
    attribute :action_identifier, :string
    attribute :name, :string
    attribute :identifier, :string
  end

end
