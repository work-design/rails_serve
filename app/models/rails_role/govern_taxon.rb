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

  def name
    if super
      return super
    else
      t = I18n.t "#{code.split('/').join('.')}.title", default: nil
      return t if t
    end

    code
  end

  class_methods do

    def sync_modules
      missing_modules.each do |m|
        gt = GovernTaxon.find_or_initialize_by(code: m.join('/'))
        gt.parent = GovernTaxon.find_or_create_by(code: m[0..-2].join('/')) if m.size > 1
        gt.save
      end
    end

    def missing_modules
      existing = GovernTaxon.unscoped.select(:code).distinct.pluck(:code).map(&->(i){ i.split('/') })
      r = (RailsCom::Routes.modules.keys - existing).sort_by(&:size)
      r.delete([])
      r
    end

  end

end
