module RailsRole::Namespace
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :identifier, :string
    attribute :verify_organ, :boolean, default: false
    attribute :verify_member, :boolean, default: false
    attribute :verify_user, :boolean, default: false

    has_many :governs, foreign_key: :namespace_identifier, primary_key: :identifier

    validates :identifier, uniqueness: true
  end

  def missing_modules
    RailsCom::Routes.modules.select do |k, v|
      k[-1] == identifier
    end
  end



end
