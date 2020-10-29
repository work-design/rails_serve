module RailsRole::NameSpace
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :identifier, :string, default: 'application'
    attribute :verify_organ, :boolean, default: false
    attribute :verify_member, :boolean, default: false
    attribute :verify_user, :boolean, default: false

    has_many :governs, foreign_key: :namespace_identifier, primary_key: :identifier

    validates :identifier, uniqueness: true
  end

  class_methods do

    def sync
      existing = NameSpace.select(:identifier).distinct.pluck(:identifier)
      (RailsCom::Routes.namespaces.keys - existing).each do |namespace|
        namespace = NameSpace.find_or_initialize_by(identifier: namespace)
        namespace.save
      end
    end

  end

end
