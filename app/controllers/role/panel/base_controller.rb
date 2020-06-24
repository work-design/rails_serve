class Role::Panel::BaseController < RailsRole.config.panel_controller.constantize

  def set_govern_taxons
    if params[:govern_taxon_id]
      govern_taxon = GovernTaxon.find params[:govern_taxon_id]
      if govern_taxon.parent
        @govern_taxons = govern_taxon.parent.self_and_siblings
      else
        @govern_taxons = govern_taxon.self_and_siblings
      end
    else
      @govern_taxons = GovernTaxon.roots
    end
  end

end
