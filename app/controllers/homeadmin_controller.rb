class HomeadminController < ApplicationController
  layout "homeadmin"
  def index
    @houses = House.all
    @accessory_types = AccessoryType.all
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
