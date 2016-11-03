class PostsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]
  before_action :authorize_access, only: [:edit, :update, :destroy]

  def index
    if params[:search]
      if params[:sort_by] == 'category_id'
        @posts = Post.search(params[:search]).joins(:category).order('name ASC').page(params[:page]).per(10)
        # @post = Post.search(params[:search]).join(:categories).order('name').page(params[:page]).per(10)
      elsif params[:sort_by] == 'created_at'
        @posts = Post.search(params[:search]).order("created_at DESC").page(params[:page]).per(10)
      else
        @posts = Post.search(params[:search]).order(params[:sort_by]).page(params[:page]).per(10)
      end
    else
      @posts = Post.order("created_at DESC").page(params[:page]).per(10)
    end
  end


  def show
    @post = Post.find(params[:id])
    @favorite = @post.favorite_for(current_user)
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    if can? :modify, @post
      redirect_to posts_path
    else
      redirect_to root_path
    end
  end

  def update
    @post = Post.find(params[:id])
    post_params = params.require(:post).permit(:title, :body, :category_id)
    if @post.update post_params
      redirect_to post_path(@post)
    else
      redirect :edit
    end

  end

  def create
    post_params = params.require(:post).permit(:title, :body, :category_id)
    @post = Post.new post_params
    @post.user = current_user
    if @post.save
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def authorize_access
    unless can? :modify, Post
      redirect_to root_path, alert: 'Access Denied'
    end
  end
end
