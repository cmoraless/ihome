class UsersController < ApplicationController
  layout 'homeadmin', :only => [:newAdmin]
  layout 'admin', :only => [:newNoAdmin]
  #ACA HACER LOS BEFORE FILTERS !!
  
  # GET /users/new
  # GET /users/new.json
  def newAdmin
    flash[:notice] = ""
    @user = User.new
    #logger.debug "######## ENTRE A NEW ADMIN #######"
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
      format.js
    end
  end
  
  def newNoAdmin
    #logger.debug "######## ENTRE A NEW NO ADMIN #######"
    #@remoto = false
    flash[:notice] = ""
    @user = User.new
    respond_to do |format|
      #format.html # new.html.erb
      #format.json { render json: @user }
      format.js
    end
  end

  # GET /users/1/edit
  def edit
    #@remoto = true
    @user = User.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        if @user.isAdmin == false
          @ibox = Ibox.find(session[:ibox_id])
          @ibox.users << @user
          @users = @ibox.users
          flash[:notice] = "Se ha creado correctamente el usuario."
          flash[:error] = ""
          #format.html { redirect_to :controller=>'admin', :action=>'index'}
          format.js
        else 
          #format.html { redirect_to :controller=>'homeadmin', :action=>'index'}
          @usersAdmin = User.where(:isAdmin => true)
          @iboxes = Ibox.all
          flash[:error] = ""
          flash[:notice] = "Se ha creado correctamente el usuario."
          format.js
        end
      else
        if @user.isAdmin
          format.js {render :action => 'newAdmin'}        
        else
          format.js {render :action => 'newNoAdmin'}
        end        
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user.isAdmin == false
      @ibox = Ibox.find(session[:ibox_id])
      @users = @ibox.users
    end
    respond_to do |format|
      if params[:user][:password] != "" and params[:user][:password_confirmation] != ""
        if @user.update_attributes(params[:user])
          flash[:notice] = "El usuario se ha actualizado correctamente."
          flash[:error] = ""
          @usersAdmin = User.where(:isAdmin => true)
          format.js         
        else
          format.js {render :action=> 'edit'}        
        end
      else
        @error_contrasena = true
        format.js {render :action=> 'edit'}     
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    isAdmin = true
    @user = User.find(params[:id])
    if @user.isAdmin == false
      isAdmin = false
    end
    @user.destroy
    if isAdmin == false
      @ibox = Ibox.find(session[:ibox_id])
      @users = @ibox.users
    end
    respond_to do |format|
      @usersAdmin = User.where(:isAdmin => true)
      format.js
    end
  end
  
end
