module RailsRole::Govern::ControllerGovern
  extend ActiveSupport::Concern
  included do
    after_create_commit :sync_govern_taxon
  end
  
  def sync_govern_taxon
    path = code.split('/')
    path.pop
    if path.size > 0
      taxon = GovernTaxon.find_by code: path.join('/')
      self.govern_taxon_id = taxon&.id
      self.save
    end
  end

  class_methods do
    def sync_controllers
      missing_controllers, invalid_controllers = analyze_controllers
      RailsCom::Routes.controllers.extract!(*missing_controllers).each do |controller, routes|
        govern = ControllerGovern.find_or_initialize_by(code: controller)
        present_rules = govern.rules.pluck(:code)
        
        all_rules = routes.select do |route|
          _controller = RailsCom::Controllers.controller(controller, route[:action])
          _controller.detect_filter(:require_role) if _controller
        end.map(&->(i){ i[:action] })
        all_rules = ['admin', 'read'] + all_rules if all_rules.present?
        
        (all_rules - present_rules).each do |action|
          govern.rules.build(code: action)
        end

        (present_rules - all_rules).each do |action|
          r = govern.rules.find_by(code: action)
          r.mark_for_destruction
        end
        
        govern.save if govern.rules.length > 0
      end
      ControllerGovern.where(code: invalid_controllers).each do |controller|
        controller.destroy
      end
    end

    def analyze_controllers
      present_controllers = ControllerGovern.unscoped.select(:code).distinct.pluck(:code)
      all_controllers = RailsCom::Routes.controllers.except!(*RailsRole.config.ignore_controllers).keys

      missing_controllers = all_controllers - present_controllers
      invalid_controllers = present_controllers - all_controllers
      [missing_controllers, invalid_controllers]
    end
  end

end
