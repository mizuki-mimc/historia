class CharactersController < ApplicationController
  before_action :require_login
  before_action :set_story
  before_action :set_character, only: [ :show, :edit, :update, :destroy ]
  before_action :prepare_form_data, only: [ :new, :create, :edit, :update ]

  def index
    @characters = @story.characters.includes(character_features: :character_feature_category, relationships: :related_character).order(:created_at)
    @grouped_characters = @characters.group_by(&:category)
    @categories = Character.categories.keys
  end

  def show
  end

  def new
    @character = @story.characters.build
    @character.category = params[:character][:category] if params.dig(:character, :category)
  end

  def create
    @character = @story.characters.build(character_params.except(:remove_image))
    if @character.save
      redirect_to story_characters_path(@story), success: "キャラクターを追加しました。"
    else
      flash.now[:error] = "キャラクターの作成に失敗しました。"
      @validation_error = true
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    permitted_params = character_params
    @character.image.purge if permitted_params[:remove_image] == "1"

    if @character.update(permitted_params.except(:remove_image))
      redirect_to story_character_path(@story, @character), success: "キャラクターを更新しました。"
    else
      flash.now[:error] = "キャラクターの更新に失敗しました。"
      @validation_error = true
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @character.destroy
    redirect_to story_characters_path(@story), success: "キャラクターを削除しました。", status: :see_other
  end

  private

  def set_story
    @story = current_user.stories.find(params[:story_id])
  end

  def set_character
    @character = @story.characters.find_by(id: params[:id])
    unless @character
      flash[:error] = "キャラクターは存在しません。"
      redirect_to story_characters_path(@story)
    end
  end

  def prepare_form_data
    @world_guides = @story.world_guides.order(:created_at)
    @feature_categories = CharacterFeatureCategory.order(:id)
    @characters_for_relation = @story.characters.where.not(id: @character&.id).order(:created_at)
  end

  def character_params
    params.require(:character).permit(
      :name, :race, :gender, :age, :category,
      :birthplace_world_guide_id, :address_world_guide_id, :image, :remove_image,
      character_features_attributes: [ :id, :character_feature_category_id, :explanation, :_destroy ],
      relationships_attributes: [ :id, :related_character_id, :relationship_type, :_destroy ]
    )
  end
end
