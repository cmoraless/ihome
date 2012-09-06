class AccessoryTypesController < ApplicationController
  layout "homeadmin"
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
  
  def new
    @accessory_type = AccessoryType.new
    @create = true
    respond_to do |format|
      format.js
    end
  end

  def edit
    @accessory_type = AccessoryType.find(params[:id])
  end

  def create
    @create = true
    @accessory_type = AccessoryType.new(params[:accessory_type])
    respond_to do |format|
      if @accessory_type.save
        @accessory_types = AccessoryType.all
        format.js
      else
        format.js {render :action=>'new'}
      end
    end
  end

  def update
    @accessory_type = AccessoryType.find(params[:id])

    respond_to do |format|
      if @accessory_type.update_attributes(params[:accessory_type])
        @accessory_types = AccessoryType.all
        format.js 
      else
        format.js {render :action=>'edit'}
      end
    end
  end

  def destroy
    @accessory_type = AccessoryType.find(params[:id])
    @accessory_type.destroy
    @accessory_types = AccessoryType.all                                                                           
    respond_to do |format|
      format.js 
    end
  end
  
  def back
    @accessory_types = AccessoryType.all    
    respond_to do |format|
      format.js
    end

  end
end
