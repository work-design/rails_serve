module RailsRole::GovernTaxon
  extend ActiveSupport::Concern
  included do
    attribute :code, :string
    attribute :name, :string
    attribute :position, :integer
    attribute :governs_count, :integer, default: 0
    
    has_many :governs, -> { order(position: :asc) }, dependent: :nullify
    has_many :rules, through: :governs
    default_scope -> { order(position: :asc, id: :asc) }
    validates :code, uniqueness: true
  end

  def desc
    "#{name} [#{code}]"
  end

  class_methods do
    def sync_modules
      missing_modules.each do |m|
        GovernTaxon.create code: m
      end
    end

    def missing_modules
      RailsCom::Routes.modules - GovernTaxon.unscoped.select(:code).distinct.pluck(:code)
    end
  end


end
