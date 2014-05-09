class SessionsController < ApplicationController

  def new
  end

  def create
    respond_to do |format|
      user = User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        format.html{ redirect_to root_path, notice: "Thanks for loggin in"}
        format.js do
          flash.now.notice = "Thanks for signing in"
          render
        end
      else
        flash.now[:alert] = "Email or password is invalid"
        format.html{render :new}
        format.js {render :new}
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You've been logged out"
  end

end
