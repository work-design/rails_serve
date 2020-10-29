module RailsRole::RuleOperation
  extend ActiveSupport::Concern

  included do
    attribute :action_identifier, :string

    enum operation: {
      list: 'list',
      read: 'read',
      add: 'add',
      edit: 'edit',
      remove: 'remove'
    }, _default: 'read'
  end

end
