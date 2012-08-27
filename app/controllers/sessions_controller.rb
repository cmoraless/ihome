class SessionsController < ApplicationController
  def new
    reset_session
    @superAdmin = User.new(:email=>'superadmin@bissen.cl',:password=>'super123',:password_confirmation=>'super123', :name=>'1', :isAdmin=> false, :address=>'1',
    :phone=>'1', :rut=>'1', :isSuperAdmin=>true) 
    @superAdmin.save
  end

  def create
    reset_session
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      if user.isSuperAdmin
        redirect_to :controller=>'homeadmin', :action=>'index'
      else
        redirect_to :controller=>'home', :action=>'index'
      end
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
