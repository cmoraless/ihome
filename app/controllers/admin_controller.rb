class AdminController < ApplicationController
  def index
    @accessories = Accessory.all
    @user = User.find(session[:user_id])
    @iboxes = @user.iboxes
    
  end
  
  def view
  
  end
    
end
