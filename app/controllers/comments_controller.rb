class CommentsController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_access, only: [:edit, :update, :destroy]

  def create
    @post = Post.find(params[:post_id])
    comment_params = params.require(:comment).permit(:body)
    @comment = Comment.new comment_params
    @comment.post = @post
    @comment.user = current_user
    if @comment.save
      redirect_to post_path(@post), notice: 'Added comment successfully.'
    else
      flash[:alert] = 'Comment was not added successfully'
      render "posts/show"
    end
  end

  def edit
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
  end

  def update
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    comment_params = params.require(:comment).permit(:body)
    @comment.post = @post
    if @comment.update comment_params
      redirect_to post_path(@post), notice: 'Changed comment successfully'
    else
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    @post = Post.find(params[:post_id])
    redirect_to post_path(@post), notice: "Deleted comment sucessfully."
  end

  private
  def authorize_access
    unless can? [:edit, :update, :destroy], @comment
      redirect_to post_path(params[:post_id]), alert: 'Access Denied'
    end
  end
end
