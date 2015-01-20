class PostsController < ApplicationController
  
  before_action :set_post_params, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show] #shut down routes if a user isn't logged in
  before_action :must_be_same_user, only: [:edit]
  
  def index
    @posts = Post.all.sort_by {|x| x.total_votes}.reverse
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.creator = current_user
    
    if @post.save
      flash[:notice] = "You successfully created your post!"
      redirect_to posts_path
    else
      render :new
    end
  end
  
  def show
    @comment = Comment.new
  end
  
  def edit; end
  
  def update
    if @post.update(post_params)
      flash[:notice] = "You successfully edited your post!"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end
  
  def vote
    vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])
    
    if vote.valid?
      flash[:notice] = "Your vote was counted"
    else
      flash[:danger] = "You can only vote once"
    end
    
    redirect_to :back
  end
  
  private
  
  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end
  
  def set_post_params
     @post = Post.find(params[:id])
  end
  
  def must_be_same_user
    if current_user != @post.creator
      flash[:danger] = "You cannot edit another users post."
      redirect_to root_path
    end
  end
  
end
