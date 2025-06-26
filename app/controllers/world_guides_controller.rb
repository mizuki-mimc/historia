class WorldGuidesController < ApplicationController
  before_action :require_login
  before_action :set_story
  before_action :set_world_guide, only: [ :show, :edit, :update, :destroy ]

  def index
    @world_guides = @story.world_guides.order(:created_at)
    @grouped_world_guides = @world_guides.group_by(&:category)
    @categories = WorldGuide.categories.keys
  end

  def show
  end

  def new
    @world_guide = @story.world_guides.build(category: params.dig(:world_guide, :category))
    @world_guide.world_guide_features.build
  end

  def edit
  end

  def create
    @world_guide = @story.world_guides.build(world_guide_params)
    if @world_guide.save
      redirect_to story_world_guides_path(@story), success: "ワールドガイドを追加しました。"
    else
      flash.now[:error] = "ワールドガイドの作成に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @world_guide.update(world_guide_params)
      redirect_to story_world_guide_path(@story, @world_guide), success: "ワールドガイドを更新しました。"
    else
      flash.now[:error] = "ワールドガイドの更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @world_guide.destroy
    redirect_to story_world_guides_path(@story), success: "ワールドガイドを削除しました。", status: :see_other
  end

  private

  def set_story
    @story = current_user.stories.find(params[:story_id])
  end

  def set_world_guide
    @world_guide = @story.world_guides.find(params[:id])
  end

  def world_guide_params
    params.require(:world_guide).permit(
      :category, :world_name, :country_name, :region_name,
      world_guide_features_attributes: [ :id, :world_feature_category_id, :explanation, :_destroy ]
    )
  end
end
