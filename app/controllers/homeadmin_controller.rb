#encoding: utf-8
class HomeadminController < ApplicationController
  before_filter :check_auth_superAdmin
  
  def check_auth_superAdmin
    if User.exists?(session[:user_id])
      @currentUser = User.find(session[:user_id])
        if @currentUser.isSuperAdmin == false
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
  
  
  def index
    flash[:notice] = ""
    flash[:error] = ""
    @iboxes = Ibox.all
    @accessory_types = AccessoryType.all
    #logger.debug "####################ACCESSORY TYPES   #{@accessory_types.length}"
    if @accessory_types.length == 0
      @accessory = AccessoryType.new(:name=>"Cortinas")
      @accessory.save    
      @accessory = AccessoryType.new(:name=>'Dimmers')
      @accessory.save
      @accessory = AccessoryType.new(:name=>'Enchufes')
      @accessory.save
      @accessory = AccessoryType.new(:name=>'Luces')
      @accessory.save      
      @accessory = AccessoryType.new(:name=>'Riegos')
      @accessory.save
      @accessory = AccessoryType.new(:name=>'Sensores')
      @accessory.save
       
    end
    @accessory_types = AccessoryType.all
    @usersAdmin = User.where(:isAdmin => true)
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { }
    end
  end
  
  #funcion para navegar con un usuario pasado por correo en la vista del superadmin
  def browseAs
    user = User.where(:email => params[:emails])
    @usersAdmin = User.where(:isAdmin => true)
    if user[0]      
      @user = User.find(user[0].id)
      respond_to do |format|
        session[:user_id] = user[0].id      
        format.js { render :js => "window.location.replace('#{url_for(:controller => 'home', :action => 'index')}');"  }       
      end
    else
      respond_to do |format|
        flash[:notice] = ""
        flash[:error] = "Hubo un error al intentar navegar con el usuario especificado."
        format.js
      end
    end
  end
  
  #funcion que busca un ibox por correo en la vista de superadmin
  def searchIboxes
    user = User.where(:email => params[:emailsIbox])
    @usersAdmin = User.where(:isAdmin => true)    
    respond_to do |format|
      if user[0]
        @user = user[0]
        @iboxes = user[0].iboxes
        if @iboxes.length == 0
          flash[:error] = "El usuario especificado no tiene Iboxes habilitados."
        end
        format.js  
      else
        flash[:notice] = ""
        flash[:error] = "Hubo un error al intentar buscar Iboxes con el usuario especificado."
        format.js
      end
    end
  end
  
  #funcion que busca un usuario por correo en la vista de super admin
  def searchUsers
    user = User.where(:email => params[:emailsUser])
    @usersAdmin = User.where(:isAdmin => true)
    respond_to do |format|
      if user[0]        
        if user[0].isAdmin
          @user = user[0]
          format.js
        else
          flash[:notice] = ""
          flash[:error] = "El usuario especificado no es un administrador."
          format.js
        end     
      else
        flash[:notice] = ""
        flash[:error] = "Hubo un error al intentar buscar el Usuario con el correo especificado."
        format.js
      end
    end
  end
   
end
