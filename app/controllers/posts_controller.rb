class PostsController < ApplicationController
  
  before_action :set_post_params, only: [:show, :edit, :update]
  before_action :require_user, except: [:index, :show] #shut down routes if a user isn't logged in
  
  def index
    @posts = Post.all
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
  
  private
  
  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end
  
  def set_post_params
     @post = Post.find(params[:id])
  end
  
end
