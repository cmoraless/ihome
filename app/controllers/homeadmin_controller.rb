class HomeadminController < ApplicationController
  layout "homeadmin"
  def index
    @houses = House.all
    @accesory_types = AccesoryType.all
    respond_to do |format|
      format.html 
      format.json { render :json => @houses }
    end
  end
end
