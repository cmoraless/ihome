class UsersController < ApplicationController
  layout 'homeadmin', :only => [:newAdmin]
  layout 'admin', :only => [:newNoAdmin]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    #@usersAdmin = User.where()
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

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
    flash[:notice] = ""
    #logger.debug "######## ENTRE A NEW NO ADMIN #######"
    #@remoto = false
    @user = User.new
    respond_to do |format|
      #format.html # new.html.erb
      #format.json { render json: @user }
      format.js
    end
  end

  # GET /users/1/edit
  def edit
    flash[:notice] = ""
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
          flash[:error] = ""
          flash[:notice] = "Se ha creado correctamente el usuario."
          #format.html { redirect_to :controller=>'admin', :action=>'index'}
          format.js
        else 
          #format.html { redirect_to :controller=>'homeadmin', :action=>'index'}
          flash[:error] = ""
          flash[:notice] = "Se ha creado correctamente el usuario."
          format.js
        end
      else
        flash[:error] = "Ha ocurrido un error al guardar el usuario. Porfavor revise los atributos."
        flash[:notice] = ""
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
    #@remoto = true
    @user = User.find(params[:id])
    if @user.isAdmin == false
      @ibox = Ibox.find(session[:ibox_id])
      @users = @ibox.users
    end
    respond_to do |format|
      if params[:user][:password] != "" and params[:user][:password_confirmation] != ""
        if @user.update_attributes(params[:user])
          flash[:error] = ""
          flash[:notice] = "El usuario se ha actualizado correctamente."
          format.js         
        else
          flash[:error] = "Ha ocurrido un error al actualizar el usuario. Revise los campos."
          flash[:notice] = ""
          format.js {render :action=> 'edit'}        
        end
      else
        flash[:error] = "Tiene que ingresar la nueva contrasena"
        flash[:notice] = ""
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
      format.js
    end
  end
  
end
