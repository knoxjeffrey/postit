class SessionsController < ApplicationController

  def new; end
  
  def create
    user = User.find_by(username: params[:username])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id #this is backed by the browsers cookie to track if the user is authenticated
      flash[:notice] = "Welcome #{current_user.username}, you're logged in!"
      redirect_to root_path
    else
      flash[:error] = "There is a problem with your username or password"
      redirect_to login_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:notice] = "You've logged out"
    redirect_to root_path 
  end
  
end
