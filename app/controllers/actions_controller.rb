class ActionsController < ApplicationController

  def back
    @schedule = Schedule.find(params[:id])
    @profile = @schedule.profile
    @user = User.find(session[:user_id])
    respond_to do |format|
      
      format.js
    end
  end  
  
end
