module Roled
  class Admin::BaseController < AdminController
    include Controller::Application
    before_action :require_role

  end
end
