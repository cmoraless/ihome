class AccessoryTypesController < ApplicationController
    layout "homeadmin"
  # GET /accessory_types
  # GET /accessory_types.json
  def index
    @accessory_types = AccessoryType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accessory_types }
    end
  end

  # GET /accessory_types/1
  # GET /accessory_types/1.json
  def show
    @accessory_type = AccessoryType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @accessory_type }
    end
  end

  # GET /accessory_types/new
  # GET /accessory_types/new.json
  def new
    @accessory_type = AccessoryType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @accessory_type }
    end
  end

  # GET /accessory_types/1/edit
  def edit
    @accessory_type = AccessoryType.find(params[:id])
  end

  # POST /accessory_types
  # POST /accessory_types.json
  def create
    @accessory_type = AccessoryType.new(params[:accessory_type])

    respond_to do |format|
      if @accessory_type.save
        format.html { redirect_to @accessory_type, notice: 'Accessory type was successfully created.' }
        format.json { render json: @accessory_type, status: :created, location: @accessory_type }
      else
        format.html { render action: "new" }
        format.json { render json: @accessory_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /accessory_types/1
  # PUT /accessory_types/1.json
  def update
    @accessory_type = AccessoryType.find(params[:id])

    respond_to do |format|
      if @accessory_type.update_attributes(params[:accessory_type])
        format.html { redirect_to @accessory_type, notice: 'Accessory type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @accessory_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accessory_types/1
  # DELETE /accessory_types/1.json
  def destroy
    @accessory_type = AccessoryType.find(params[:id])
    @accessory_type.destroy

    respond_to do |format|
      format.html { redirect_to accessory_types_url }
      format.json { head :no_content }
    end
  end
end
