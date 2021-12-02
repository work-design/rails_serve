module Roled
  module Model::WhoRole::WhoOrganRole
    extend ActiveSupport::Concern

    included do
      belongs_to :who, class_name: 'Org::Organ'
      belongs_to :role, class_name: 'OrganRole'
    end

  end
end
