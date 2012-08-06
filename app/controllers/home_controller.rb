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
      session[:ibox_id] = @ibox.id
    else
      @ibox = @user.iboxes.first
<<<<<<< HEAD
    end  
    session[:ibox_id] = @ibox.id
=======
    end

>>>>>>> 3749b998f0f72b660a8de4facc140577b0af2d4d
    # Toma todos los contenedores del ibox
    @containers = IboxAccessoriesContainer.where("ibox_id = ?", @ibox.id)
    
  end
  
 def signout
    redirect_to :controller=>"start", :action=>"index"
  end
  
end
