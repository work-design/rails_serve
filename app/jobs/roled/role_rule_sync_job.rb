module Roled
  class RoleRuleSyncJob < ApplicationJob
    queue_as :default

    def perform(ids = [])
      RoleRule.where(id: ids).each do |role_rule|
        role_rule.sync_rule
        role_rule.save
      end
    end

  end
end
