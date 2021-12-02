module Roled
  module Model::WhoRole::WhoJobTitleRole
    extend ActiveSupport::Concern

    included do
      belongs_to :who, class_name: 'Org::JobTitle'
      belongs_to :role, class_name: 'JobTitleRole'
    end

  end
end
