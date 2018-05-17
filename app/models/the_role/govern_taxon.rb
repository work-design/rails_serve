require 'acts_as_list'
class GovernTaxon < ApplicationRecord
  acts_as_list

  has_many :governs, -> { order(position: :asc) }, dependent: :nullify
  default_scope -> { order(position: :asc, id: :asc) }


  def self.sync_modules
    missing_modules.each do |m|
      GovernTaxon.create code: m
    end
  end

  def self.missing_modules
    RailsCom::Routes.modules - GovernTaxon.unscoped.select(:code).distinct.pluck(:code)
  end


end