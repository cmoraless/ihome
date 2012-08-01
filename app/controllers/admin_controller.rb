class AdminController < ApplicationController
  def index
    @user = User.find(session[:user_id])
    @iboxes = @user.iboxes.all
    
  end
  
  def view
  end
    
end
