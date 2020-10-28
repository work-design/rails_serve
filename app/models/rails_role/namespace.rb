module RailsRole::Namespace
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :identifier, :string
    attribute :verify_organ, :boolean, default: false
    attribute :verify_member, :boolean, default: false
    attribute :verify_user, :boolean, default: false

    has_many :governs, dependent: :destroy

    validates :identifier, uniqueness: true
  end

  def sync_modules
    missing_modules.each do |m|

    end
  end

  def missing_modules
    RailsCom::Routes.modules.select do |k, v|
      k[-1] == identifier
    end
  end

end
