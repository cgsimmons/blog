class PostsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]
  def index
    if params[:search]
      if params[:sort_by] == 'category_id'
        @posts = Post.search(params[:search]).joins(:category).order('name ASC').page(params[:page]).per(10)
        # @post = Post.search(params[:search]).join(:categories).order('name').page(params[:page]).per(10)
      else
        @posts = Post.search(params[:search]).order(params[:sort_by]).page(params[:page]).per(10)
      end
    else
      @posts = Post.order(:created_at).page(params[:page]).per(10)
    end
  end


  def show
    @post = Post.find(params[:id])
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
    redirect_to posts_path
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
    if @post.save
      redirect_to post_path(@post)
    else
      render :new
    end

  end
end
