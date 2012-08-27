class HomeadminController < ApplicationController
  before_filter :check_auth
  def check_auth
    if User.exists?(session[:user_id])
      @user = User.find(session[:user_id])
      if @user.isSuperAdmin == false 
        redirect_to(root_path)
      end  
    else
      redirect_to(root_path)
    end    
  end
  
  
  def index
    @iboxes = Ibox.all
    @accessory_types = AccessoryType.all
    #logger.debug "####################ACCESSORY TYPES   #{@accessory_types.length}"
    if @accessory_types.length == 0
      @accessory = AccessoryType.new(:name=>"Cortinas")
      @accessory.save
      @accessory = AccessoryType.new(:name=>'Luces')
      @accessory.save
      @accessory = AccessoryType.new(:name=>'Dimmers')
      @accessory.save
      @accessory = AccessoryType.new(:name=>'Sensores')
      @accessory.save
      @accessory = AccessoryType.new(:name=>'Riego')
      @accessory.save  
    end
    @accessory_types = AccessoryType.all
    @users = User.all
    @usersAdmin = User.where(:isAdmin => true)
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { }
    end
  end
  
  def view
   
  end
  
  def browseAs
    user = User.where(:email => params[:emails])
    #logger.debug "####### user = #{user[0].id}"
    #logger.debug "######## params[:emails] = #{params[:emails]}"
    #logger.debug "######## user.id = #{user[0].id}"
    if user[0]
      session[:user_id] = user[0].id
      respond_to do |format|
        format.js { render :js => "window.location.replace('#{url_for(:controller => 'home', :action => 'index')}');"  }
      end
    else
      respond_to do |format|
        @usersAdmin = User.where(:isAdmin => true)
        flash[:error] = "Hubo un error al intentar navegar con el usuario especificado."
        format.js
      end
    end
  end
    
end
