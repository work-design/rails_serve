class Admin::RoleSectionsController < Admin::BaseController
  before_action :set_role

  def create
    if @role.create_section params[:section_name]
      flash[:notice] = t('.section_created')
    else
      flash[:error]  = t('.section_not_created')
    end

    redirect_to admin_role_url(@role)
  end

  def destroy
    section_name = params[:id]

    if @role.delete_section section_name
      flash[:notice] = t('.section_deleted')
    else
      flash[:error]  = t('.section_not_deleted')
    end

    redirect_to admin_role_url(@role)
  end

  def create_rule
    if @role.create_rule params[:section_name], params[:rule_name]
      flash[:notice] = t('.section_rule_created')
    else
      flash[:error]  = t('.section_rule_not_created')
    end

    redirect_to admin_role_url(@role)
  end

  def rule_on
    if @role.rule_on params[:id], params[:name]
      flash[:notice] = t('.section_rule_on')
    else
      flash[:error]  = t('.state_not_changed')
    end

    redirect_to admin_role_url(@role)
  end

  def rule_off
    if @role.rule_off params[:id], params[:name]
      flash[:notice] = t('.section_rule_off')
    else
      flash[:error]  = t('.state_not_changed')
    end

    redirect_to admin_role_url(@role)
  end

  def destroy_rule
    if @role.delete_rule params[:id], params[:name]
      flash[:notice] = t('.section_rule_deleted')
    else
      flash[:error]  = t('.section_rule_not_deleted')
    end

    redirect_to admin_role_url(@role)
  end

  protected
  def set_role
    @role = Role.find params[:role_id]

    # TheRole: You have to define object for ownership check
    #for_ownership_check(@role)
  end

end
