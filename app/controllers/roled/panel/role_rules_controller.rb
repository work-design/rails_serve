module Roled
  class Panel::RoleRulesController < Panel::BaseController
    before_action :set_role
    before_action :set_role_rule, only: [:show, :edit, :update]

    def index
      @role_rules = @role.role_rules.page(params[:page])
    end

    def new
      @role_rule = @role.role_rules.build
    end

    def create

      @role = @role.role_rules.build(role_rule_params)

      unless @role_rule.save
        render :new, locals: { model: @role_rule }, status: :unprocessable_entity
      end
    end

    def show
    end

    def edit
    end

    def update
      @role_rule.assign_attributes(role_rule_params)

      unless @role_rule.save
        render :edit, locals: { model: @role_rule }, status: :unprocessable_entity
      end
    end

    def disable

    end

    def destroy
      q_params = {
        namespace_identifier: nil,
        controller_identifier: nil,
        action_name: nil
      }
      q_params.merge! params.permit(:business_identifier, :namespace_identifier, :controller_identifier, :action_name)

      @role_rules = RoleRule.where(q_params)
      @role_rules.each(&:destroy)
    end

    private
    def set_role
      @role = Role.find params[:role_id]
    end

    def set_role_rule
      @role_rule = @role.role_rules.find params[:id]
    end

    def role_rule_params
      params.permit(
        :business_identifier,
        :namespace_identifier,
        :controller_identifier,
        :action_name,
        :params_name,
        :params_identifier
      )
    end

  end
end
