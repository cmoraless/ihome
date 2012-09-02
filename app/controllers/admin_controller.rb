class AdminController < ApplicationController
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
  
  def changeIbox
    session[:ibox_id] = params[:id]
    redirect_to :controller=> "admin", :action=>"index"
  end
  
  def index
    @user = User.find(session[:user_id])
    @iboxes = @user.iboxes
    
    if @iboxes.empty?
      flash[:notice] = "Debe tener por lo menos un IBox para agregar/editar usuarios."
    elsif session[:ibox_id]
      @ibox = Ibox.find(session[:ibox_id])
      @users = @ibox.users
      @cameras = @ibox.cameras
      @containers = IboxAccessoriesContainer.where("ibox_id = ?", @ibox.id)
      @accessories = []
      @containers.each do |container|
        @accessories << container.accessories
      end  
      #logger.debug "############### #{@accessories}"
    end
  #  if @iboxes.length == 0
  #    flash[:notice] = "Debe tener por lo menos un IBox para agregar/editar usuarios."
  #  end
  end
  
  def view
  
  end
    
end
