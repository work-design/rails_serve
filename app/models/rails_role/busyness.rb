module RailsRole::Busyness
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :identifier, :string
    attribute :position, :integer

    has_many :governs, foreign_key: :business_identifier, primary_key: :identifier

    validates :identifier, uniqueness: true

    acts_as_list
  end

  class_methods do

    def sync
      existing = Busyness.select(:identifier).distinct.pluck(:identifier)
      (RailsCom::Routes.businesses.keys - existing).each do |business|
        busyness = Busyness.find_or_initialize_by(identifier: business)
        busyness.save
      end
    end

  end

end
