class CamerasController < ApplicationController
  before_filter :check_auth_admin  
  
  def check_auth_admin    
    if User.exists?(session[:user_id])
      @currentUser = User.find(session[:user_id])
      if @currentUser.isAdmin == false and @currentUser.isSuperAdmin == false      
        respond_to do |format|
          format.html {redirect_to(home_index_path)}
          format.js {render :js => "window.location.replace('#{url_for(:controller => 'home', :action => 'index')}');"}
        end
      end
    else
      respond_to do |format|
        format.html {redirect_to(root_path)}
        format.js {render :js => "window.location.replace('#{url_for(:controller => 'sessions', :action => 'new')}');"}    
      end
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
    @edit = true
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
    @repetido = false
    @currentIbox = Ibox.find(session[:ibox_id])
    @cameras = @currentIbox.cameras
    for i in 0..@cameras.length-1
      if @cameras[i][:ip] == @camera[:ip] and @cameras[i][:port] == @camera[:port]
        @repetido = true
      end
    end
    respond_to do |format|
      if @repetido == false #si la camara no esta repetida
        if @camera.save
          @ibox = Ibox.find(session[:ibox_id])
          @ibox.cameras << @camera
          @cameras = @ibox.cameras
          flash[:notice] = "Se ha creado correctamente la camara."
          flash[:error] = ""
          format.js
        else
          format.js {render :action => 'new'}        
        end
      else
        flash[:notice] = ""
        flash[:error] = "La camara ingresada ya existe."
        format.js {render :action=> 'new'}
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
        flash[:notice] = "Se ha actualizado correctamente la camara."
        flash[:error] = ""
        format.js
      else
        @edit = true
        format.js {render :action => 'edit'}
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
  
  def back
    respond_to do |format|
      @currentUser = User.find(session[:user_id])
      @ibox = Ibox.find(session[:ibox_id])
      @iboxes = @currentUser.iboxes
      @cameras = @ibox.cameras      
      format.js
    end
  end
end
