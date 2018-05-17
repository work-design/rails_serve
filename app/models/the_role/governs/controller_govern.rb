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
    missing_controllers, invalid_controllers = analyze_controllers
    missing_controllers.each do |controller|
      govern = ControllerGovern.new code: controller
      path = controller.split('/')
      path.pop
      if path.size > 0
        taxon = GovernTaxon.find_by code: path.join('/')
        govern.govern_taxon_id = taxon&.id
      end
      govern.save
      govern.sync_rules
    end
    ControllerGovern.where(code: invalid_controllers).each do |controller|
      controller.destroy
    end
  end

  def self.analyze_controllers
    present_controllers = ControllerGovern.unscoped.select(:code).distinct.pluck(:code)
    all_controllers = RailsCom::Routes.controllers - TheRole.config.ignore_controllers

    missing_controllers = all_controllers - present_controllers
    invalid_controllers = present_controllers - all_controllers
    [missing_controllers, invalid_controllers]
  end


end