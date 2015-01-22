class UsersController < ApplicationController
  
  before_action :set_user_params, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "You have successfully registered!  Welcome to PostIt #{current_user.username}."
      redirect_to root_path
    else
      render :new
    end
    
  end
  
  def show; end
  
  def edit; end
  
  def update
    if @user.update(user_params)
      flash[:notice] = "#{current_user.username}, you have successfully updated your profile!"
      redirect_to user_path(@user)
    else
      render :edit
    end  
  end
  
  private
  
  def user_params
    params.require(:user).permit(:username, :password)
  end
  
  def set_user_params
    @user = User.find_by(slug: params[:id])
  end
  
  def require_same_user
    if current_user != @user
      flash[:danger] = "You're not allowed to do that"
      redirect_to root_path
    end
  end
  
end