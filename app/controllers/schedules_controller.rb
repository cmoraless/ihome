class SchedulesController < ApplicationController
  layout "home"
  
  def updateMultiple
    flash[:notice] = "Products updated"
    #redirect_to products_url
    respond_to do |format|
      format.js
    end
  end
  
end