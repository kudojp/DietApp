class MealPostsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @new_meal_post = current_user.meal_posts.build(meal_post_params)
    if @new_meal_post.save
      respond_to do |format|
        # TODO: freiendly forwardingを実装
        format.html { redirect_to root }
        format.js
      end
    else
      # TODO: save失敗時の処理
    end
  end

  def destroy
    @meal_post = MealPost.find(params[:id])

    if @meal_post.nil?
      redirect_to root_path, alert: 'This post you requested to delete does not exist'
    elsif @meal_post.user_id == current_user
      redirect_to root_path, alert: 'You are not authorized to delete the post'
    end

    if @meal_post.destroy
      respond_to do |format|
        # TODO: freiendly forwardingを実装
        format.html { redirect_to root }
        format.js
      end
    else
      # TODO: destroy失敗時の処理
    end
  end

  def show
    @meal_post = MealPost.find(params[:id])
  end

  def index
    @meal_posts = User.find(params[:id]).meal_posts
  end

  private

  def meal_post_params
    params.require(:meal_post).permit(:content, 'time(1i)', 'time(2i)', 'time(3i)', 'time(4i)', 'time(5i)')
  end
end
