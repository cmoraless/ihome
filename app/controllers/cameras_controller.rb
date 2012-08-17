class CamerasController < ApplicationController
  before_filter :check_auth
  def check_auth
    if User.exists?(session[:user_id])
      @user = User.find(session[:user_id])
      if @user.isAdmin == false 
        redirect_to(home_index_path)
      end  
    else
      redirect_to(root_path)
    end    
  end
  # GET /cameras
  # GET /cameras.json
  def index
    if session[:ibox_id]
      @ibox = Ibox.find(session[:ibox_id])
      @cameras = @ibox.cameras
    else
      flash[:notice] = "Debe habilitar su Ibox."
    end
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
      @ibox = Ibox.find(session[:ibox_id])
      @cameras = @ibox.cameras
      format.js
    end
  end

  # GET /cameras/1/edit
  def edit
    @camera = Camera.find(params[:id])
    respond_to do |format|
      @ibox = Ibox.find(session[:ibox_id])
      @cameras = @ibox.cameras
      format.js
    end
  end

  # POST /cameras
  # POST /cameras.json
  def create
    @camera = Camera.new(params[:camera])
    respond_to do |format|
      if @camera.save
        @ibox = Ibox.find(session[:ibox_id])
        @ibox.cameras << @camera
        @cameras = @ibox.cameras
        format.js
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
        @ibox = Ibox.find(session[:ibox_id])
        @cameras = @ibox.cameras
        format.js
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
      @ibox = Ibox.find(session[:ibox_id])
      @cameras = @ibox.cameras
      format.js
    end
  end
end
