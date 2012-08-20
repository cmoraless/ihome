class AdminController < ApplicationController
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
        logger.debug "############### #{container.accessories[0][:name]}"
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
