module Roled
  module Model::Busyness
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :identifier, :string
      attribute :position, :integer

      has_many :governs, foreign_key: :business_identifier, primary_key: :identifier
      has_many :rules, foreign_key: :business_identifier, primary_key: :identifier

      has_one_attached :logo

      validates :identifier, uniqueness: true

      acts_as_list
    end

    def name
      return super if super.present?

      t = I18n.t "#{identifier}.title", default: nil
      return t if t

      identifier
    end

    def name_spaces
      NameSpace.where(identifier: Govern.unscope(:order).select(:namespace_identifier).where(business_identifier: identifier).distinct.pluck(:namespace_identifier)).order(id: :asc)
    end

    def role_hash
      r = {}
      r.merge! identifier => namespace_hash if namespace_hash.present?
      r
    end

    def namespace_hash
      r = {}
      name_spaces.each do |name_space|
        nr = name_space.role_hash(identifier)
        r.merge! name_space.identifier => nr if nr.present?
      end
      r
    end

    class_methods do

      def sync
        existing = Busyness.select(:identifier).distinct.pluck(:identifier)
        (RailsCom::Routes.businesses.keys - existing).each do |business|
          busyness = Busyness.find_or_initialize_by(identifier: business)
          busyness.save
        end

        (existing - RailsCom::Routes.businesses.keys).each do |business|
          Busyness.find_by(identifier: business)&.destroy
        end
      end

    end

  end
end
