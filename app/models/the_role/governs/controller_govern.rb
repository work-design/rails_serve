class ControllerGovern < Govern

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
      govern = ControllerGovern.create code: controller
      govern.sync_rules
    end
  end

  def self.missing_controllers
    present_controllers = ControllerGovern.unscoped.select(:code).distinct.pluck(:code)
    all_controllers = RailsCom::Routes.controllers - TheRole.config.ignore_controllers

    all_controllers - present_controllers
  end

end