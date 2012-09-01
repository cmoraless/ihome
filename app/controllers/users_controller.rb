class UsersController < ApplicationController
  layout 'homeadmin', :only => [:newAdmin]
  layout 'admin', :only => [:newNoAdmin]
  #ACA HACER LOS BEFORE FILTERS !!
  before_filter :check_user
  
  def check_user
    if User.exists?(session[:user_id]) == false
      redirect_to(root_path)
    end
  end
  # GET /users/new
  # GET /users/new.json
  def newAdmin
    @currentUser = User.find(session[:user_id])
    flash[:notice] = ""
    respond_to do |format|
      if @currentUser.isSuperAdmin == true
        @user = User.new        
        format.js      
      else
        flash[:error] = "No tienes permisos."
        redirect_to(home_index_path)
        format.js
      end
    end
  end
  
  def newNoAdmin
    @currentUser = User.find(session[:user_id])
    flash[:notice] = ""
    respond_to do |format|
      if @currentUser.isAdmin == true                
        @user = User.new
        format.js      
      else        
        flash[:error] = "No tienes permisos"
        redirect_to(home_index_path)
        format.js
      end
    end  
  end

  # GET /users/1/edit
  def edit
    #@remoto = true
    @edit = true
    @currentUser = User.find(session[:user_id])
    @user = User.find(params[:id])    
    respond_to do |format|
      if @currentUser.id == @user.id or @currentUser.isSuperAdmin == true
        format.js
      else
        flash[:error] = "No tienes permisos."
        redirect_to(home_index_path)
        format.js
      end
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @currentUser = User.find(session[:user_id])
    respond_to do |format|
      if @currentUser.isSuperAdmin == true and @user.isAdmin == true
        if @user.save
          @usersAdmin = User.where(:isAdmin => true)
          @iboxes = Ibox.all
          flash[:error] = ""
          flash[:notice] = "Se ha creado correctamente el usuario."
          format.js          
        else
          format.js {render :action => 'newAdmin'}                                              
        end
      elsif @currentUser.isAdmin == true and @user.isAdmin == false
        if @user.save
          @ibox = Ibox.find(session[:ibox_id])
          @ibox.users << @user
          @users = @ibox.users
          flash[:notice] = "Se ha creado correctamente el usuario."
          flash[:error] = ""
          format.js
        else
          format.js {render :action => 'newNoAdmin'}
        end      
      else
        flash[:error] = "No tienes permisos"
        redirect_to(home_index_path)
        format.js          
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    @currentUser = User.find(session[:user_id])
    respond_to do |format|
      if @currentUser.isSuperAdmin == true or (@user.id == @currentUser.id)
        if @user.isAdmin == false
          @ibox = Ibox.find(session[:ibox_id])
          @users = @ibox.users
        end           
      else
        redirect_to(home_index_path)
      end
      
      if params[:user][:password] != "" and params[:user][:password_confirmation] != ""
        if @user.update_attributes(params[:user])
          flash[:notice] = "El usuario se ha actualizado correctamente."
          flash[:error] = ""
          @usersAdmin = User.where(:isAdmin => true)
          format.js         
        else
          @error = true
          flash[:error] = "Hubo un error al intentar actualizar el usuario."
          format.js {render :action=> 'edit'}        
        end
      else
        @error = true
        flash[:error] = "Hubo un error al intentar actualizar el usuario."
        format.js {render :action=> 'edit'}     
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @currentUser = User.find(session[:user_id])
    @user = User.find(params[:id])    
    respond_to do |format|
      if @currentUser.isSuperAdmin == true #puede eliminar usuarios admin y no admins
        if @user.isAdmin == true
          @user.destroy
          @usersAdmin = User.where(:isAdmin => true)
          format.js
        else
          @user.destroy
          @ibox = Ibox.find(session[:ibox_id])
          @users = @ibox.users
          format.js
        end
      elsif @currentUser.isAdmin == true and @user.isAdmin == false #puede eliminar usuarios no admin solamente
        @user.destroy
        @ibox = Ibox.find(session[:ibox_id])
        @users = @ibox.users
        format.js        
      else
        flash[:error] = "No tienes permisos"
        redirect_to(home_index_path)
      end
    end
  end
  
  def back
    respond_to do |format|
      @currentUser = User.find(session[:user_id])
      if @currentUser.isAdmin == true and @currentUser.isSuperAdmin == false
        #@iboxes = @currentUser.iboxes
        @ibox = Ibox.find(session[:ibox_id])
        @users = @ibox.users
      elsif @currentUser.isAdmin == false and @currentUser.isSuperAdmin == true
        @usersAdmin = User.where(:isAdmin => true)
      end
      format.js
    end
  end

end