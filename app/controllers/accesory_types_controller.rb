class AccesoryTypesController < ApplicationController
    layout "homeadmin"
  # GET /accesory_types
  # GET /accesory_types.json
  def index
    @accesory_types = AccesoryType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accesory_types }
    end
  end

  # GET /accesory_types/1
  # GET /accesory_types/1.json
  def show
    @accesory_type = AccesoryType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @accesory_type }
    end
  end

  # GET /accesory_types/new
  # GET /accesory_types/new.json
  def new
    @accesory_type = AccesoryType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @accesory_type }
    end
  end

  # GET /accesory_types/1/edit
  def edit
    @accesory_type = AccesoryType.find(params[:id])
  end

  # POST /accesory_types
  # POST /accesory_types.json
  def create
    @accesory_type = AccesoryType.new(params[:accesory_type])

    respond_to do |format|
      if @accesory_type.save
        format.html { redirect_to @accesory_type, notice: 'Accesory type was successfully created.' }
        format.json { render json: @accesory_type, status: :created, location: @accesory_type }
      else
        format.html { render action: "new" }
        format.json { render json: @accesory_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /accesory_types/1
  # PUT /accesory_types/1.json
  def update
    @accesory_type = AccesoryType.find(params[:id])

    respond_to do |format|
      if @accesory_type.update_attributes(params[:accesory_type])
        format.html { redirect_to @accesory_type, notice: 'Accesory type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @accesory_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accesory_types/1
  # DELETE /accesory_types/1.json
  def destroy
    @accesory_type = AccesoryType.find(params[:id])
    @accesory_type.destroy

    respond_to do |format|
      format.html { redirect_to accesory_types_url }
      format.json { head :no_content }
    end
  end
end
