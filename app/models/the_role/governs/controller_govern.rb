class ControllerGovern < Govern
  acts_as_list

  belongs_to :govern_taxon, counter_cache: true, optional: true
  has_many :rules, -> { order(position: :asc) }, dependent: :destroy

  default_scope -> { order(position: :asc, id: :asc) }
  scope :without_taxon, -> { where(govern_taxon_id: nil) }

  validates :code, uniqueness: true

  def desc
    "#{name} [#{code}]"
  end

  def sync_rules
    all_actions = ['admin', 'read'] + RailsCom::Routes.actions(self.code)
    govern_rules = self.rules.pluck(:code)

    (all_actions - govern_rules).each do |la|
      self.rules.create(code: la)
    end

    invalid_rules = (govern_rules - all_actions)
    invalid_rules.each do |la|
      self.rules.find_by(code: la).destroy
    end
  end

  def self.sync_controllers
    missing_controllers.each do |controller|
      govern = Govern.create code: controller
      govern.sync_rules
    end
  end

  def self.missing_controllers
    present_controllers = Govern.unscoped.select(:code).distinct.pluck(:code)
    all_controllers = RailsCom::Routes.controllers - TheRole.config.ignore_controllers

    all_controllers - present_controllers
  end

end