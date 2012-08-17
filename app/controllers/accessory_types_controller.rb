class AccessoryTypesController < ApplicationController
  layout "homeadmin"
  def index
    @accessory_types = AccessoryType.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accessory_types }
      format.js #added
    end
  end

  def show
    @accessory_type = AccessoryType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  def new
    @accessory_type = AccessoryType.new

    respond_to do |format|
      format.js
    end
  end

  def edit
    @accessory_type = AccessoryType.find(params[:id])
  end

  def create
    @accessory_type = AccessoryType.new(params[:accessory_type])
    respond_to do |format|
      if @accessory_type.save
        @accessory_types = AccessoryType.all
        format.js
      else
        format.js
      end
    end
  end

  def update
    @accessory_type = AccessoryType.find(params[:id])

    respond_to do |format|
      if @accessory_type.update_attributes(params[:accessory_type])
        @accessory_types = AccessoryType.all
        format.js 
      else
        format.js
      end
    end
  end

 def destroy
    @accessory_type = AccessoryType.find(params[:id])
    @accessory_type.destroy
    @accessory_types = AccessoryType.all                                                                           
    respond_to do |format|
      format.js 
    end
  end
end
