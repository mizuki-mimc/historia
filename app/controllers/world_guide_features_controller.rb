class WorldGuideFeaturesController < ApplicationController
  before_action :require_login
  before_action :set_story_and_feature

  def show
  end

  def edit
  end

  def update
    @world_guide_feature.image.purge if world_guide_feature_params[:remove_image] == "1"

    if @world_guide_feature.update(world_guide_feature_params.except(:remove_image))
      redirect_to story_world_guide_feature_path(@story, @world_guide_feature), notice: "特徴の詳細を更新しました。"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_story_and_feature
    @story = current_user.stories.find(params[:story_id])
    @world_guide_feature = @story.world_guide_features.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "指定された情報が見つかりません。"
  end

  def world_guide_feature_params
    params.require(:world_guide_feature).permit(:description, :image, :remove_image)
  end
end
