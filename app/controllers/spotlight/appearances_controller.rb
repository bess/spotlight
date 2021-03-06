class Spotlight::AppearancesController < Spotlight::ApplicationController
  before_filter :authenticate_user!
  load_resource :exhibit, class: Spotlight::Exhibit
  before_filter :load_and_authorize_appearance

  def update
    if @appearance.update(appearance_params)
      redirect_to edit_exhibit_appearance_path(@exhibit), notice: t(:'helpers.submit.spotlight_default.updated', model: @appearance.class.model_name.human.downcase)
    else
      render 'edit'
    end
  end

  def edit
    add_breadcrumb t(:'spotlight.exhibits.breadcrumb', title: @exhibit.title), @exhibit
    add_breadcrumb t(:'spotlight.administration.sidebar.header'), exhibit_dashboard_path(@exhibit)
    add_breadcrumb t(:'spotlight.administration.sidebar.appearance'), edit_exhibit_appearance_path(@exhibit)
  end

  protected

  def load_and_authorize_appearance
    @appearance = Spotlight::Appearance.new(@exhibit.blacklight_configuration)
    authorize! action_name.to_sym, @appearance
  end

  def appearance_params
    params.require(:appearance).permit(:default_per_page, :thumbnail_size,
      document_index_view_types: @appearance.view_type_options,
      sort_fields: @appearance.allowed_params,
      main_navigations: [:id, :label, :weight])
  end
end
