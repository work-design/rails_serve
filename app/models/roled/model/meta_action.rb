module Roled
  module Model::MetaAction
    extend ActiveSupport::Concern

    included do
      has_many :role_rules, ->(o) { where(controller_path: o.controller_path) }, foreign_key: :action_name, primary_key: :action_name, dependent: :delete_all
      has_many :roles, through: :role_rules

      #after_destroy_commit :prune_from_role
    end

    def prune_from_role
      roles.each do |role|
        role.action_off(self)
      end
    end

  end
end
