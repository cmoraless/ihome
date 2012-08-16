class CamerasController < ApplicationController
  # GET /cameras
  # GET /cameras.json
  def index
    @cameras = Camera.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cameras }
    end
  end

  # GET /cameras/1
  # GET /cameras/1.json
  def show
    @camera = Camera.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @camera }
    end
  end

  # GET /cameras/new
  # GET /cameras/new.json
  def new
    @camera = Camera.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @camera }
    end
  end

  # GET /cameras/1/edit
  def edit
    @camera = Camera.find(params[:id])
  end

  # POST /cameras
  # POST /cameras.json
  def create
    @camera = Camera.new(params[:camera])

    respond_to do |format|
      if @camera.save
        format.html { redirect_to @camera, notice: 'Camera was successfully created.' }
        format.json { render json: @camera, status: :created, location: @camera }
      else
        format.html { render action: "new" }
        format.json { render json: @camera.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cameras/1
  # PUT /cameras/1.json
  def update
    @camera = Camera.find(params[:id])

    respond_to do |format|
      if @camera.update_attributes(params[:camera])
        format.html { redirect_to @camera, notice: 'Camera was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @camera.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cameras/1
  # DELETE /cameras/1.json
  def destroy
    @camera = Camera.find(params[:id])
    @camera.destroy

    respond_to do |format|
      format.html { redirect_to cameras_url }
      format.json { head :no_content }
    end
  end
end
