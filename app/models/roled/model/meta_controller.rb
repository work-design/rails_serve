module Roled
  module Model::MetaController
    extend ActiveSupport::Concern

    included do
      has_many :role_rules, foreign_key: :controller_path, primary_key: :controller_path, dependent: :destroy
    end

  end
end
