module Roled
  class Admin::WhoRolesController < Admin::BaseController
    before_action :set_who, only: [:show, :edit, :update]

    def edit
      @roles = Role.visible.default_where('who_types-any': params[:who_type])
    end

    def update
      if @who.class.column_names.include? 'cached_role_ids'
        @who.update cached_role_ids: who_params[:role_ids]
      else
        @who.update who_params
      end
    end

    private
    def set_who
      @who = params[:who_type].safe_constantize.find params[:who_id]
    end

    def who_params
      params.fetch(:who, {}).permit(
        role_ids: []
      )
    end

  end
end
