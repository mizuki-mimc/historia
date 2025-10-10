class StoriesController < ApplicationController
  before_action :require_login
  before_action :set_story, only: [ :show, :set_status, :destroy, :edit, :update ]

  def index
    @q = current_user.stories.ransack(params[:q])
    @stories = @q.result(distinct: true).order(updated_at: :desc)
  end

  def new
    @story = current_user.stories.build
  end

  def create
    @story = current_user.stories.build(story_params)
    if @story.save
      redirect_to story_path(@story), notice: "ストーリーが作成されました！"
    else
      flash.now[:alert] = "ストーリーの作成に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    @story.destroy
    redirect_to stories_path, notice: "ストーリー「#{@story.title}」を削除しました。", status: :see_other
  end

  def edit
  end

  def update
    if @story.update(story_params)
      redirect_to story_path(@story), success: "ストーリー「#{@story.title}」を更新しました。"
    else
      flash.now[:error] = "ストーリーの更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def set_status
    if @story.update(status: params[:status])
      redirect_to story_path(@story), notice: "ステータスを「#{t("activerecord.attributes.story.statuses.#{@story.status}")}」に変更しました。"
    else
      redirect_to story_path(@story), alert: "ステータスの変更に失敗しました。"
    end
  end


  private

  def set_story
    @story = current_user.stories.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "お探しのストーリーは存在しないか、削除された可能性があります。"
    redirect_to stories_path
  end

  def story_params
    params.require(:story).permit(:title, :genre, :thema, :synopsis, :status)
  end
end
