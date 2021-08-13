module Roled
  class Panel::RolesController < Panel::BaseController
    before_action :set_role, only: [
      :show, :overview, :edit, :update, :destroy,
      :namespaces, :controllers, :actions,
      :business_on, :business_off, :namespace_on, :namespace_off, :controller_on, :controller_off, :action_on, :action_off
    ]
    before_action :set_new_role, only: [:new, :create]

    def index
      @roles = Role.order(created_at: :asc)
    end

    def show
      q_params = {}

      @meta_controllers = MetaController.includes(:meta_actions).default_where(q_params)
      @meta_businesses = MetaBusiness.all
    end

    def namespaces
      @meta_business = MetaBusiness.find_by identifier: params[:business_identifier].presence
    end

    def controllers
      @meta_namespace = MetaNamespace.find_by identifier: params[:namespace_identifier].presence
      q_params = {
        business_identifier: nil,
        namespace_identifier: nil,
        allow: { business_identifier: nil, namespace_identifier: nil }
      }
      q_params.merge! params.permit(:business_identifier, :namespace_identifier)

      @meta_controllers = MetaController.default_where(q_params)
    end

    def actions
      @meta_controller = MetaController.find params[:meta_controller_id]

      @meta_actions = @meta_controller.meta_actions
    end

    def overview
      @taxon_ids = @role.meta_controllers.unscope(:order).uniq
    end

    def business_on
      @busyness = Busyness.find_by identifier: params[:business_identifier].presence
      @role.business_on @busyness

      @role.save
    end

    def business_off
      @busyness = Busyness.find_by identifier: params[:business_identifier].presence
      @role.role_hash.delete params[:business_identifier]
      @role.save
    end

    def namespace_on
      @meta_namespace = MetaNamespace.find_by identifier: params[:namespace_identifier].presence
      @role.namespace_on(@meta_namespace, params[:business_identifier])
      @role.save

      q_params = {
        business_identifier: nil,
        namespace_identifier: nil,
        allow: { business_identifier: nil, namespace_identifier: nil }
      }
      q_params.merge! params.permit(:business_identifier, :namespace_identifier)

      @meta_controllers = MetaController.default_where(q_params)
    end

    def namespace_off
      @meta_namespace = MetaNamespace.find_by identifier: params[:namespace_identifier].presence
      @role.namespace_off(@meta_namespace, params[:business_identifier])
      @role.save

      q_params = {
        business_identifier: nil,
        namespace_identifier: nil,
        allow: { business_identifier: nil, namespace_identifier: nil }
      }
      q_params.merge! params.permit(:business_identifier, :namespace_identifier)

      @meta_controllers = MetaController.default_where(q_params)
    end

    def controller_on
      @meta_controller = MetaController.find params[:meta_controller_id]
      @role.controller_on(@meta_controller)
      @role.save
    end

    def controller_off
      @meta_controller = MetaController.find params[:meta_controller_id]
      @role.controller_off(@meta_controller)
      @role.save
    end

    def action_on
      @meta_action = MetaAction.find params[:meta_action_id]

      @role.role_hash.deep_merge!(@meta_action.business_identifier.to_s => {
        @meta_action.namespace_identifier.to_s => {
          @meta_action.controller_path => {
            @meta_action.action_name => true
          }
        }
      })
      @role.save
    end

    def action_off
      @meta_action = MetaAction.find params[:meta_action_id]

      @role.role_hash.fetch(@meta_action.business_identifier.to_s, {}).fetch(@meta_action.namespace_identifier.to_s, {}).fetch(@meta_action.controller_path, {}).delete(@meta_action.action_name)
      @role.save
    end

    private
    def role_params
      p = params.fetch(:role, {}).permit(
        :name,
        :code,
        :description,
        :visible,
        :default,
        who_types: []
      )
      p.fetch(:who_types, []).reject!(&:blank?)
      p
    end

    def set_role
      @role = Role.find params[:id]
    end

    def set_new_role
      @role = Role.new role_params
    end

  end
end
