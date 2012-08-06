class HomeController < ApplicationController
  before_filter :check_auth
  def check_auth
    if session[:user_id] == nil
      redirect_to(root_path)
    end
  end
  
  def index
    @user = User.find(session[:user_id])
    @iboxes = @user.iboxes

    # Toma ibox seleccionado o por defecto el primero
    if (params[:id])
      @ibox = Ibox.find(params[:id])
    else
      @ibox = @user.iboxes.first
      
    session[:ibox_id] = @ibox.id

    # Toma todos los contenedores del ibox
    @containers = IboxAccessoriesContainer.find_by_ibox_id(@ibox.id)
  end
  
 def signout
    redirect_to :controller=>"start", :action=>"index"
  end
  
end
