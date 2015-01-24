class SessionsController < ApplicationController

  def new; end
  
  def create
    user = User.find_by(username: params[:username])
    
    if user && user.authenticate(params[:password])
      if user.two_factor_auth?
        session[:two_factor] = true
        user.generate_pin!
        user.send_pin_to_twilio
        redirect_to pin_path
      else
        login_user!(user)
      end
    else
      flash[:danger] = "There is a problem with your username or password"
      redirect_to login_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:notice] = "You've logged out"
    redirect_to root_path 
  end
  
  def pin
    access_denied if session[:two_factor].nil?
    
    if request.post?
      user = User.find_by(pin: params[:pin])
      if user
        session[:two_factor] = nil
        user.remove_pin!
        login_user!(user)
      else
        flash[:error] = "Sorry, something is wrong with your pin number"
        redirect_to pin_path
      end
    end
  end
  
  private
  
  def login_user!(user)
    session[:user_id] = user.id #this is backed by the browsers cookie to track if the user is authenticated
    flash[:notice] = "Welcome #{current_user.username}, you're logged in!"
    redirect_to root_path
  end
  
end
