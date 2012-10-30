#encoding: utf-8
class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all
    respond_to do |format|
      format.html  
    end
  end

  def new
    @activities = Activity.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @activities = Activity.find(params[:id])
    respond_to do |format|
      @ibox = Ibox.find(session[:ibox_id])
      format.js
    end
  end

  def create
    @activities = Activity.new(params[:accessory])

    respond_to do |format|
      if @activities.save
        format.html { redirect_to @activities, notice: 'Accessory was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end


end
