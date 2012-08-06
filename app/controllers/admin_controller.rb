class AdminController < ApplicationController
  before_filter :check_auth
  def check_auth
    if User.exists?(session[:user_id])
      @user = User.find(session[:user_id])
      if @user.isAdmin == false 
        redirect_to(home_index_path)
      end  
    else
      redirect_to(root_path)
    end    
  end
  
  def index
    @user = User.find(session[:user_id])
    @iboxes = @user.iboxes
    if session[:ibox_id]
      @ibox = Ibox.find(session[:ibox_id])
      @users = @ibox.users  
    end
  end
  
  def view
  
  end
    
end
