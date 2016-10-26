class CommentsController < ApplicationController
  before_action :authenticate_user

  def create
    @post = Post.find(params[:post_id])
    comment_params = params.require(:comment).permit(:body)
    @comment = Comment.new comment_params
    @comment.post = @post
    if @comment.save
      redirect_to post_path(@post), notice: 'Added comment successfully.'
    else
      render 'post/show'
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
end
