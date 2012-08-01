class AdminController < ApplicationController
  def index
    @user = User.find(session[:user_id])
    @iboxes = @user.iboxes.all
    
  end
  
  def view
<<<<<<< HEAD
    respond_to do |format|
      format.html { } # show.html.erb
      format.json  { render :json => @house }
    end
=======
    
>>>>>>> 40a53e2ffcda23487e5220208c9d3976727a380e
  end
    
end
