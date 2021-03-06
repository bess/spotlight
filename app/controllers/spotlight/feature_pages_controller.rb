module Spotlight
  class FeaturePagesController < PagesController

    load_and_authorize_resource through: :exhibit, instance_name: 'page'
    before_filter :attach_breadcrumbs

    protected
    def attach_breadcrumbs
      super

      if action_name == 'edit'
        add_breadcrumb t(:'spotlight.curation.sidebar.feature_pages'), exhibit_feature_pages_path(@exhibit)
      end

      if @page
        add_breadcrumb @page.parent_page.title, [@page.exhibit, @page.parent_page] unless @page.top_level_page?
        add_breadcrumb @page.title, action_name == 'edit' ? [:edit, @page.exhibit, @page] : [@page.exhibit, @page]
      elsif action_name == 'index'
        add_breadcrumb t(:'spotlight.curation.sidebar.header'), exhibit_dashboard_path(@exhibit)
        add_breadcrumb t(:'spotlight.curation.sidebar.feature_pages'), exhibit_feature_pages_path(@exhibit)
      end
    end

    def update_all_page_params
      params.require(:exhibit).permit(
        "feature_pages_attributes" => page_attributes,
        "home_page_attributes" => [:id, :title, :display_title]
      )
    end

    def allowed_page_params
      super.concat [:display_sidebar, :published]
    end
  end
end
