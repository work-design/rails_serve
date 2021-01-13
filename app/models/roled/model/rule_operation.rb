module Roled
  module Model::RuleOperation
    extend ActiveSupport::Concern

    included do
      attribute :action_name, :string

      enum operation: {
        list: 'list',
        read: 'read',
        add: 'add',
        edit: 'edit',
        remove: 'remove'
      }, _default: 'read'
    end

  end
end
