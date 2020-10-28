module RailsRole::Govern
  extend ActiveSupport::Concern

  included do
    attribute :type, :string
    attribute :name, :string
    attribute :code, :string
    attribute :position, :integer

    belongs_to :govern_taxon, counter_cache: true
    has_many :rules, -> { order(position: :asc) }, dependent: :destroy
    has_many :role_rules, dependent: :destroy
    accepts_nested_attributes_for :rules, allow_destroy: true

    default_scope -> { order(position: :asc, id: :asc) }

    validates :code, uniqueness: true

    acts_as_list
  end

  def desc
    "#{name} [#{code}]"
  end

  def name
    if super
      return super
    elsif code
      t = I18n.t "#{code.split('/').join('.')}.index.title", default: nil
      return t if t
    end

    code
  end

end
