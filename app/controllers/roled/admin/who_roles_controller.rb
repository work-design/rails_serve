module Roled
  class Admin::WhoRolesController < Admin::BaseController
    before_action :set_who, only: [:show, :edit, :update]

    def edit
      type = "Roled::#{params[:who_type].split('::')[-1]}Role"
      @roles = Role.visible.default_where(type: type)
    end

    def update
      @who_role = @who.who_roles.find_or_initialize_by(role_id: params[:role_id])

      if @who_role.save
        render 'update'
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
