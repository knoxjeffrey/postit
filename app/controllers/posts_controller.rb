class PostsController < ApplicationController
  
  before_action :set_post_params, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show] #shut down routes if a user isn't logged in
  before_action :must_be_creator, only: [:edit, :update]
  
  def index
    @posts = Post.all.sort_by {|x| x.total_votes}.reverse
    
    respond_to do |format|
      format.html
      format.json { render json: @posts }
      format.xml { render xml: @posts }
    end
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
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])
    
    #Any non ajaxified requests will follow the format.html block and the js requests will follow format.js.  
    #By not having a block for format.js it will try and do the default action of rendering a template, 
    #in this case a js template, called vote.js.erb.
    respond_to do |format|
      format.html do
        @vote.valid? ? flash[:notice] = "Your vote was counted" : flash[:danger] = "You can only vote once"

        redirect_to :back
      end
      format.js
    end
  end
  
  private
  
  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end
  
  def set_post_params
    @post = Post.find_by(slug: params[:id])
  end
  
  def must_be_creator
    access_denied unless logged_in? and (current_user == @post.creator || current_user.admin?)
  end
  
end
