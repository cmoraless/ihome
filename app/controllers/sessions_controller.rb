class SessionsController < ApplicationController
  def new
    reset_session
    @users = User.all
    if @users.length == 0
      @superAdmin = User.new(:email=>'superadmin@bissen.cl',:password=>'super123',:password_confirmation=>'super123', :name=>'1', :isAdmin=> false, :address=>'1',
      :phone=>'1', :rut=>'1', :isSuperAdmin=>true) 
      @superAdmin.save
    end
  end

  def create
    reset_session
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      if user.isSuperAdmin
        redirect_to :controller=>'homeadmin', :action=>'index'
      else
        redirect_to :controller=>'home', :action=>'index'
      end
    else
      flash[:error] = "Email o contrasena invalida"
      render "new"
    end
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => "Logged out!"
  end
  
  def recover
    flash[:notice] = ""
    flash[:error] = ""
  end
  
  def recover_pass    
    respond_to do |format|
      if User.find_by_email(params[:email])
        #enviar correo
        caracteres = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n',
          'o','p','q','r','s','t','u','x','y','z','0','1','2','3','4','5','6','7','8','9']
        @nueva_pass = ''
        random = Random.new(10)
        for i in 0..12
          @nueva_pass = @nueva_pass + caracteres[random.rand(0..caracteres.length-1)]
        end
        @user = User.find_by_email(params[:email])
        flash[:error] = ""
        flash[:notice] = "Le hemos enviado un correo con una contrasena momentanea. Cambiela lo antes posible."
        format.js
      else
        flash[:error] = "No hemos encontrado usuario con el correo especificado."
        flash[:notice] = ""
        format.js
      end
    end
  end
  
  def recover_pass_end
    
    
  end
  
end
