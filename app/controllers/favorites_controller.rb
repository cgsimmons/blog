class FavoritesController < ApplicationController

  def index
    @user = current_user
    @favorites = @user.favorited_posts.page(params[:page]).per(10)
  end

  def create
    @post = Post.find(params[:post_id])
    @favorite = Favorite.new(user: current_user, post: @post)

    respond_to do |format|

      if (can?(:favorite, @post) && (@favorite.save))
        format.js {render :change_favorite}
        format.html{redirect_back fallback_location: post_path(@post), notice: '❤Added to your favorites!❤'}
      else
        format.js {render js: 'alert("Access denied!");'}
        format.html{redirect_back fallback_location: post_path(post), alert: '‼ Access Denied ‼'}
      end

    end
  end

  def destroy
    favorite = Favorite.find(params[:id])
    @post = favorite.post
    respond_to do |format|

      if (can?(:favorite, @post) && (favorite.destroy))
        format.js {render :change_favorite}
        format.html {redirect_back fallback_location: post_path(@post), notice: '💔Unfavorited post.💔'}
      else
        format.js {render js: 'alert("Access denied!");'}
        format.html {redirect_back fallback_location: post_path(@post), alert: 'Access Denied'}
      end

    end
  end
end
