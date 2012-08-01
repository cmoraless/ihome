class HomeadminController < ApplicationController
  def index
    @accessory_types = AccessoryType.all;
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @houses }
    end
  end
  
  def view
   
  end
    
end
