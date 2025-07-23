class PlotsController < ApplicationController
  before_action :require_login
  before_action :set_story
  before_action :set_plot, only: [ :edit, :update, :destroy ]
  before_action :prepare_plot_form_data, only: [ :new, :create, :edit, :update ]
  before_action :check_for_missing_elements, only: [ :new, :edit ]

  def new
    @plot = @story.plots.build
  end

  def create
    @plot = @story.plots.build(plot_params)
    if @plot.save
      redirect_to story_path(@story), success: "プロットを追加しました。"
    else
      flash.now[:error] = "プロットの作成に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @plot.update(plot_params)
      redirect_to story_path(@story), success: "プロットを更新しました。"
    else
      flash.now[:error] = "プロットの更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plot.destroy
    redirect_to story_path(@story), success: "プロットを削除しました。", status: :see_other
  end

  private

  def set_story
    @story = current_user.stories.find(params[:story_id])
  end

  def set_plot
    @plot = @story.plots.find(params[:id])
  end

  def prepare_plot_form_data
    @world_guides = @story.world_guides.order(:created_at)
    @characters = @story.characters.order(:created_at)
    @flags_for_select = @story.flags.unrecovered.order(:created_at)
    @plot_templates = PlotTemplate.order(:id)
  end

  def plot_params
    params.require(:plot).permit(
      :chapter, :title, :summary, :content, :order,
      world_guide_ids: [],
      character_ids: [],
      plot_flags_attributes: [ :id, :flag_id, :check_created, :check_recovered, :_destroy ]
    )
  end

  def check_for_missing_elements
    missing_elements = []
    missing_elements << "「 ワールドガイド 」" unless @story.world_guides.exists?
    missing_elements << "「 キャラクター 」" unless @story.characters.exists?
    missing_elements << "「 フラグ 」" unless @story.flags.exists?

    if missing_elements.any?
      flash.now[:info] = "プロットに要素を紐付けるには、先に#{missing_elements.join('、')}を作成してください。"
    end
  end
end
