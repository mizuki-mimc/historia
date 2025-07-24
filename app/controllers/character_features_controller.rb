class CharacterFeaturesController < ApplicationController
  before_action :require_login
  before_action :set_story_and_feature

  def show
  end

  def edit
  end

  def update
    @character_feature.image.purge if character_feature_params[:remove_image] == "1"

    if @character_feature.update(character_feature_params.except(:remove_image))
      redirect_to story_character_feature_path(@story, @character_feature), notice: "特徴の詳細を更新しました。"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_story_and_feature
    @story = current_user.stories.find(params[:story_id])
    @character_feature = @story.character_features.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "指定された情報が見つかりません。"
  end

  def character_feature_params
    params.require(:character_feature).permit(:description, :image, :remove_image)
  end
end
