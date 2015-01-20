class CommentsController < ApplicationController

  before_action :require_user
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.creator = current_user
    
    if @comment.save
      flash[:notice] = "You successfully submitted your comment."
      redirect_to post_path(@post)
    else
      render "posts/show"
    end
  end
  
  def vote
    comment = Comment.find(params[:id])
    @vote = Vote.create(voteable: comment, creator: current_user, vote: params[:vote])
    
    if @vote.valid?
      flash[:notice] = "Your vote was counted"
    else
      flash[:danger] = "You can only vote once"
    end
    
    redirect_to :back
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:body)
  end
  
end
