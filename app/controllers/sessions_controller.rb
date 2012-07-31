class SessionsController < ApplicationController
  def new
    reset_session
  end

  def create
    reset_session
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to :controller=>'home', :action=>'index'
    else
      flash[:notice] = "Email o contrasena invalida"
      render "new"
    end
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => "Logged out!"
  end
end
