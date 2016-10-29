class FavoritesController < ApplicationController

  def index
    @user = current_user
    @favorites = @user.favorited_posts.page(params[:page]).per(10)
  end

  def create
    post = Post.find(params[:post_id])
    favorite = Favorite.new(user: current_user, post: post)
    if cannot? :favorite, post
      redirect_back fallback_location: post_path(post), alert: '‼ Access Denied ‼'
    elsif favorite.save
      redirect_back fallback_location: post_path(post), notice: '❤Added to your favorites!❤'
    else
      redirect_back fallback_location: post_path(post), alert: favorite.errors.full_messages.join(", ")
    end
  end

  def destroy
    post = Post.find(params[:post_id])
    favorite = Favorite.find(params[:id])
    if(current_user != favorite.user)
      redirect_back fallback_location: post_path(post), alert: 'Access Denied'
    elsif favorite.destroy
      redirect_back fallback_location: post_path(post), notice: '💔Unfavorited post.💔'
    else
      redirect_back fallback_location: post_path(post), alert: favorite.errors.full_messages.join(", ")
    end
  end
end
