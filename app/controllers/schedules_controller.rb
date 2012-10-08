#encoding: utf-8
class SchedulesController < ApplicationController
  
  def actions
    @user = User.find(session[:user_id])
    @schedule = Schedule.find(params[:id])
    
    if (@schedule.actions.length ==0)
      flash[:error] = ""
      flash[:notice] = "Agrega nuevas acciones para programar tu accesorio."
    else
      flash[:error] = ""
      flash[:notice] = ""      
    end
    #redirect_to products_url
    respond_to do |format|
      format.js
    end
  end
  
  def newAction
    @schedule = Schedule.find(params[:id])
    @action = Action.new
    @schedule.actions << @action
    respond_to do |format|
      format.js
    end
  end
  
  def destroyAction
    @action = Action.find(params[:id])
    @schedule = @action.schedules.last
    @action.destroy
    respond_to do |format|
      format.js 
    end    
  end
  
  def update
    @schedule = Schedule.find(params[:id])
    @user = User.find(session[:user_id])
    respond_to do |format|
      if @schedule.update_attributes(params[:schedule])
        flash[:error] = ""
        flash[:notice] = "Las acciones del perfil se han actualizado correctamente."
        format.js   
      else
        flash[:error] = "Ha ocurrido un error al actualizar el perfil. Revise las acciones."
        flash[:notice] = ""
        #format.js {render :partial => "profile", :collection => @user.profiles}  
        format.js
      end
    end
  end  
  
  def back
    @user = User.find(session[:user_id])
    respond_to do |format|
      
      format.js
    end
  end  


end