class HomeadminController < ApplicationController
  def index
    @iboxes = Ibox.all
    @accessory_types = AccessoryType.all;
    @users = User.all
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @houses }
    end
  end
  
  def view
   
  end
    
end
