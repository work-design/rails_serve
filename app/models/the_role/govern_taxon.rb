require 'acts_as_list'
class GovernTaxon < ApplicationRecord
  acts_as_list

  has_many :governs, -> { order(position: :asc) }, dependent: :nullify
  default_scope -> { order(position: :asc, id: :asc) }


  def self.sync_controllers
    missing_controllers.each do |controller|
      govern = Govern.create code: controller
      govern.sync_rules
    end
  end

  def self.missing_controllers
    present_controllers = Govern.unscoped.select(:code).distinct.pluck(:code)
    all_controllers = RailsCom::Routes.controllers - TheRole.config.ignore_controllers

    all_controllers - present_controllers
  end


end