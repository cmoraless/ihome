class AdminController < ApplicationController
  layout "admin"
  def index
    @users = User.all
    @iboxes = Ibox.all
    respond_to do |format|
      format.html 
      format.json { render :json => @houses }
    end
  end
  
  def view
    @houses = House.all 
    respond_to do |format|
      format.html { } # show.html.erb
      format.json  { render :json => @house }
    end
  end
    
end
