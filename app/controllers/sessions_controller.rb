class SessionsController < ApplicationController
  #funcion que genera codigo para la recuperacion de contraseña
  def get_code
    caracteres = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n',
    'o','p','q','r','s','t','u','x','y','z','0','1','2','3','4','5','6','7','8','9']
    code = ''
    random = Random.new
    for i in 0..14
      code = code + caracteres[random.rand(0..caracteres.length-1)]
    end
    code
  end
  
  #funcion que inicia
  def new
    reset_session
    @users = User.all
    code = get_code
    code += get_code
    no_existe_superadmin = true
    @users.each do |user|
      if user.isSuperAdmin == true
        no_existe_superadmin = false
        break
      end
    end
    if no_existe_superadmin
      @superAdmin = User.new(:email=>'superadmin@bissen.cl',:password=>'super123',:password_confirmation=>'super123', :name=>'1', :isAdmin=> false, :address=>'1',
      :phone=>'1', :rut=>'1', :isSuperAdmin=>true, :code=>code) 
      @superAdmin.save
    end
  end

  #funcion que hace el login y crea la session de usuario
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

  #funcion que hace el logout de la session de usuario
  def destroy
    reset_session
    redirect_to root_url, :notice => "Logged out!"
  end
  
  #funcion que se llama al inciio para recuperar la contraseña
  def recover
    flash[:notice] = ""
    flash[:error] = ""
  end
  
  #funcion que envia el codigo al correo del usuario para recuperar la contraseña
  def recieve_code    
    respond_to do |format|
      if User.find_by_email(params[:email])
        code = get_code
        flash[:error] = ""
        flash[:notice] = "NOTICE"
        @user = User.find_by_email(params[:email])
        @user.update_attribute(:code,code)
        @correo = params[:email]
        UserMailer.recovery_pass(@user).deliver
        format.js
      else
        flash[:error] = "ERROR"
        flash[:notice] = ""
        format.js
      end
    end
  end
  
  #funcion que actualiza la contraseña si el codigo pasado es correcto
  def recover_pass
    code = get_code
    flash[:notice] = ""
    flash[:error] = ""
    respond_to do |format|    
      if User.find_by_email(params[:email])
        @user = User.find_by_email(params[:email])
        if params[:password] == params[:password_confirmation]
          if params[:code].to_s == @user.code
            @user.update_attributes(:password=> params[:password], :password_confirmation => params[:password_confirmation],:code=>code)
            flash[:notice] = "Se actualizo correctamente."
            format.js
          else
            flash[:error] = "El codigo no es valido."
            format.js
          end
        else
          flash[:error] = "Las contrasenas no coinciden"
          format.js
        end        
      else
        flash[:error] = "No hemos encontrado un usuario con el correo especificado."
        format.js
      end
    end 
  end
  
end
