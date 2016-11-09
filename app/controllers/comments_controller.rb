class CommentsController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_access, only: [:edit, :update, :destroy]

  def create
    @post = Post.find(params[:post_id])
    comment_params = params.require(:comment).permit(:body)
    @comment = Comment.new comment_params
    @comment.post = @post
    @comment.user = current_user

    respond_to do |format|

      if @comment.save
        format.js {render :create_success}
        format.html{redirect_to post_path(@post), notice: 'Added comment successfully.'}
      else
        format.js{render :create_failure}
        format.html do
          flash[:alert] = 'Comment was not added successfully'
          render "posts/show"
        end
      end

    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @post = @comment.post
  end

  def update
    @comment = Comment.find(params[:id])
    @post = @comment.post
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
    @post = @comment.post
    respond_to do |format|

      if @comment.destroy
        format.js {render}
        format.html {redirect_to post_path(@post), notice: "Deleted comment sucessfully."}
      else
        format.js {render js: 'alert("Access denied!");'}
        format.html {redirect_to post_path(@post), notice: "Access denied!"}
      end

    end
  end

  private
  def authorize_access
    unless can? :modify, Comment
      redirect_to post_path(params[:post_id]), alert: 'Access Denied'
    end
  end
end
