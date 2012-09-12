class IboxesController < ApplicationController
  layout "homeadmin"
  before_filter :check_auth_superAdmin, :only => [:new, :create, :destroy]
  before_filter :check_auth_admin
  
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
 
  def new
    @ibox = Ibox.new
    @create = true
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ibox }
      format.js #added
    end
  end

  def edit
    @ibox = Ibox.find(params[:id])
    @currentUser = User.find(session[:user_id])
    if @currentUser.isAdmin == true
      @iboxes = @currentUser.iboxes
      autorizado = false
      for i in 0..@iboxes.length-1
        if @iboxes[i].id == @ibox.id
          autorizado = true
        end
      end
    end    
    respond_to do |format|
      if @currentUser.isSuperAdmin == true or (autorizado and @currentUser.isAdmin)
        format.js #added
      else
        format.js {render :js => "window.location.replace('#{url_for(:controller => 'home', :action => 'index')}');"}
      end        
    end
  end

  def create
    @ibox = Ibox.new(params[:ibox])
    @create = true
    respond_to do |format|
      if @ibox.save
        @iboxes = Ibox.all
        @usersAdmin = User.where(:isAdmin => true)
        flash[:notice] = "Se ha creado correctamente el Ibox."
        flash[:error] = ""
        format.js
      else
        format.js {render :action => 'new'}
      end
    end
  end

  def update
    @ibox = Ibox.find(params[:id])
    @currentUser = User.find(session[:user_id])
    if @currentUser.isAdmin == true
      @iboxes = @currentUser.iboxes
      autorizado = false
      for i in 0..@iboxes.length-1
        if @iboxes[i].id == @ibox.id
          autorizado = true
        end
      end
    end     
    respond_to do |format|
      if @currentUser.isSuperAdmin == true or (autorizado and @currentUser.isAdmin)
        if @ibox.update_attributes(params[:ibox])
          @user = User.find(session[:user_id])
          @usersAdmin = User.where(:isAdmin => true)  
          if @user.isSuperAdmin == true and @user.isAdmin == false
            @iboxes = Ibox.all
          elsif @user.isSuperAdmin == false and @user.isAdmin == true
            @iboxes = @user.iboxes
          end
          flash[:notice] = "Se ha actualizado correctamente el Ibox."
          flash[:error] = ""
          format.js 
        else
          format.js {render :action => 'edit'}
        end
      else
          format.js {render :js => "window.location.replace('#{url_for(:controller => 'home', :action => 'index')}');"}
      end
    end
  end
  
  def get_content_to_display
    #Place code here
    render :update do |page|
      page.replace_html "display_ajax", :partial => 'waiting'
    end
  end

  def destroy #elimina el ibox y todos sus usuarios no administrativos
    @ibox = Ibox.find(params[:id])
    @usersIbox = @ibox.users
    for i in 0..@usersIbox.length-1
      if @usersIbox[i].isAdmin == false
        @usersIbox[i].destroy
      end
    end
    @ibox.destroy
    @iboxes = Ibox.all
    @usersAdmin = User.where(:isAdmin => true)
    flash[:notice] = "Se ha eliminado correctamente el Ibox."
    flash[:error] = ""    
    respond_to do |format|
     format.js 
    end
  end

  def destroyAccessory
    @accessory = Accessory.find(params[:id])
    @ibox = Ibox.find(session[:ibox_id])
    res = Ibox.iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?OP=3&ZID=' + @accessory.zid, @ibox.user, @ibox.password)
    if (res[0] == 'Success')
       @accessory.destroy
       flash[:error] = ""
       flash[:notice] = "Se ha eliminado el accesorio"
    else
       flash[:error] = "No se pudo eliminar el accesorio. Recuerda desenchufarlo y luego eliminarlo!"
       flash[:notice] = ""
    end
    
    respond_to do |format|
      format.js
    end
  end

  def enable
    respond_to do |format|
      if Ibox.find_by_mac(params[:ibox_mac])
        @ibox = Ibox.find_by_mac(params[:ibox_mac])
        @user = User.find(session[:user_id])        
        if @ibox.isActive == true
          flash[:error] = "El ibox seleccionado ya esta activo."
          flash[:notice] = ""
          format.js
        else
          session[:ibox_id] = @ibox.id
          @ibox.update_attribute(:isActive, true)
          @ibox.users << @user
          iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/setEmail.cgi?Email='+@user.email,@ibox.user,@ibox.password)
          format.js {redirect_to :action => 'addDefaultAccessories', :id => @ibox.id}
        end
      else  
        flash[:error] = "No hemos encontrado el Ibox especificado."
        flash[:notice] = ""
        format.js
      end
    end
  end
  
  def showEnable
    respond_to do |format|
      format.js
    end
  end
  
  def addDefaultAccessories
    @ibox = Ibox.find(session[:ibox_id])
    respond_to do |format|
    if addAccessories(@ibox.id) 
      flash[:notice] = "Hemos habilitado exitosamente el Ibox y agregado tus nuevos accesorios."
      flash[:error] = ""
      format.js {render :js => "window.location.replace('#{url_for(:controller => 'home', :action => 'index')}');"}
    else
      flash[:notice] = "Hemos habilitado exitosamente el Ibox, pero no hemos encontrado nuevos accesorios."
      flash[:error] = ""
      format.js {render :js => "window.location.replace('#{url_for(:controller => 'home', :action => 'index')}');"}
    end
    end
  end

  def listenToAddAccessory
    @ibox = Ibox.find(session[:ibox_id])
    res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Mode.cgi?MODE=A',@ibox.user,@ibox.password)
    if res[0] == "Success"
      begin
        res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?ZG=MODE',@ibox.user,@ibox.password)
        sleep 2
      end while (res[0] == 'MODE=READY')
      sleep 4
      if addAccessories(@ibox.id)
        @containers = IboxAccessoriesContainer.where("ibox_id = ?", @ibox.id)
        @accessories = []
        @containers.each do |container|
          @accessories << container.accessories
        end 
        flash[:notice] = "Se ha agregado el nuevo accesorio."
        flash[:error] = ""
      else
        res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?ZG=MODE',@ibox.user,@ibox.password)
        @containers = IboxAccessoriesContainer.where("ibox_id = ?", @ibox.id)
        @accessories = []
        @containers.each do |container|
          @accessories << container.accessories
        end 
        flash[:error] = "No se pudo agregar el nuevo accesorio."
        flash[:notice] = ""
      end
    else
        @containers = IboxAccessoriesContainer.where("ibox_id = ?", @ibox.id)
        @accessories = []
        @containers.each do |container|
          @accessories << container.accessories
        end 
      flash[:error] = "ERROR"
      flash[:notice] = ""
    end 
    respond_to do |format|
      format.js
    end
  end

  def listenToRemoveAccessory
    @ibox = Ibox.find(session[:ibox_id])
    res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Mode.cgi?MODE=R',@ibox.user,@ibox.password)
    if res[0] == "Success"
      begin
        res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?ZG=MODE',@ibox.user,@ibox.password)
        sleep 2
      end while (res[0] == 'MODE=READY')
      sleep 4
       
      if removeAccessories(@ibox.id)
        @containers = IboxAccessoriesContainer.where("ibox_id = ?", @ibox.id)
        @accessories = []
        @containers.each do |container|
          @accessories << container.accessories
        end 
        flash[:notice] = "Se pudo eliminar el nuevo accesorio."
        flash[:error] = ""
      else
        res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?ZG=MODE',@ibox.user,@ibox.password)
        @containers = IboxAccessoriesContainer.where("ibox_id = ?", @ibox.id)
        @accessories = []
        @containers.each do |container|
          @accessories << container.accessories
        end 
        flash[:error] = "No se ha eliminado el nuevo accesorio"
        flash[:notice] = ""
      end

    else
      @containers = IboxAccessoriesContainer.where("ibox_id = ?", @ibox.id)
      @accessories = []
      @containers.each do |container|
        @accessories << container.accessories
      end 
      flash[:error] = "ERROR"
      flash[:notice] = ""
    end
 
    respond_to do |format|
      format.js
    end
  end
  
  # Función 
  # Entrada: 
  # Salida: 
  def removeAccessories(ibox_id)
    ret = false
    @ibox = Ibox.find(ibox_id)
    @containers = @ibox.ibox_accessories_containers.all
    @containers.each do |container|
      container.accessories.each do |accessory|
        if (!isConectedAccessory(ibox_id, accessory.zid) )
          accessory.destroy
          ret = true
        end
      end
    end
    ret
  end

  def destroyAccessory
    @accessory = Accessory.find(params[:id])
    @ibox = Ibox.find(session[:ibox_id])
    res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?OP=3&ZID=' + @accessory.zid, @ibox.user, @ibox.password)
    if (res[0] == 'Success')
       @accessory.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to accessories_url }
      format.json { head :no_content }
    end
  end

  # Función 
  # Entrada: 
  # Salida: 
  def addAccessories(ibox_id)
    ret = false
    @ibox = Ibox.find(ibox_id)
    res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Get.cgi?get=SET',@ibox.user,@ibox.password)
    for i in 0..res.length/12-1
      #Si no esta asociado el accesorio al Ibox
      if (!isSavedAccessory(ibox_id, res[0+12*i].to_s.split('=')[1])) 
        #Se crea el accessorio 
        @accessory = Accessory.new
        @accessory.update_attribute(:zid, res[0+12*i].to_s.split('=')[1])
        @accessory.update_attribute(:kind, res[1+12*i].to_s.split('=')[1])
        @accessory.update_attribute(:cmdclass, res[10+12*i].to_s.split('=')[1])
        
        resacc = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?ZID=' + @accessory.zid,@ibox.user,@ibox.password)
      
        @accessory.update_attribute(:value, resacc[2].to_s.split('=')[1])
        #has no owner => is public
        @accessory.update_attribute(:isPublic, true)
        @accessory.update_attribute(:isScheduled, false)
       
        #Se determina el tipo de accesorio del accesorio
        if (@accessory.kind == "BinarySwitch")
          if (res[3+12*i].to_s.split('=')[1].to_i <= 100)
            @accessory_type = AccessoryType.find_by_name("Luces")
            @accessory.update_attribute(:name, "luces 0"+i.to_s)
          else
            @accessory_type = AccessoryType.find_by_name("Riego")
            @accessory.update_attribute(:name, "aspersor 0"+i.to_s)                        
          end
        end
        if (@accessory.kind == "MultiLevelSwitch")
          if (@accessory.cmdclass == "AllOnOff,Configuration")
            @accessory_type = AccessoryType.find_by_name("Dimmers")
            @accessory.update_attribute(:name, "dimmer 0"+i.to_s)
          else
            @accessory_type = AccessoryType.find_by_name("Cortinas")
            @accessory.update_attribute(:name, "cortina 0"+i.to_s)
          end
        end
        if (@accessory.kind == "BinarySensor")
          @accessory_type = AccessoryType.find_by_name("Sensores")
          @accessory.update_attribute(:name, "sensor 0"+i.to_s)
        end
        
        #Si no existe se crea el contenedor del tipo de accesorio en el Ibox
        if (!@ibox.accessory_types.find_by_name(@accessory_type.name))
          @ibox.accessory_types << @accessory_type
        end
      
        #Se asgina el tipo de accesorio al accesorio y se guarda
        @accessory.accessory_type = @accessory_type
        @accessory.save
        #Se busca el contenedor del Ibox y tipo
        @container = IboxAccessoriesContainer.find_by_ibox_id_and_accessory_type_id(@ibox.id, @accessory_type.id)
        #se le cambia el nombre al contenedor
        @container.update_attribute(:name, @accessory_type.name)
        #Se agrega el accesorio determinado
        @container.accessories << @accessory
        ret = true
      end
    end
    ret 
  end
 
  # Descripción: Función que busca si el accesorio conectado al ibox está en la base de datos
  # Entrada: 
  # Salida: True si lo encontró, False si no.
  def isSavedAccessory(ibox_id, zid)
    ret = false
    @ibox = Ibox.find(ibox_id)
    @ibox.ibox_accessories_containers.each do |container|
      if (container.accessories.find_by_zid(zid))
        ret = true
      end
    end
    ret
  end  
  
  # Descripción: Función que busca si el accesorio conectado al ibox está en la base de datos
  # Entrada: 
  # Salida: True si lo encontró, False si no.
  def isConectedAccessory(ibox_id, zid)
    ret = true
    @ibox = Ibox.find(ibox_id)
    res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?ZID=' + zid,@ibox.user,@ibox.password)
    if (res[0] == 'Fail:501') 
      ret = false
    end
    ret
  end  

  # Descripción: Función que ejecuta comandos para un determinado Ibox
  # Entrada: 
  # Salida: Arreglo con la salida del comando
  def iboxExecute(ibox_ip, ibox_port, instruction, user, password)
    require 'net/http'
    require 'uri'
    ws = 'http://' + ibox_ip + ':' + ibox_port
    url = URI.parse(ws)
    begin
      req = Net::HTTP::Get.new(url.path + instruction )
      req.basic_auth user, password
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
      #escribo archivo de texto con la salida del web service
      path = Rails.root + 'tmp/server.txt'
      f_out = File.new(path,'w')
      f_out.puts res.body
      f_out.close
      res = Array.new
      f_in = File.open(path,'r') do |f|
        while line = f.gets
          res << line.to_s.chomp
        end
      end
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
    end
    res
  end   
  
  def back
    respond_to do |format|
      @currentUser = User.find(session[:user_id])
      if @currentUser.isAdmin == true and @currentUser.isSuperAdmin == false
        @iboxes = @currentUser.iboxes
      elsif @currentUser.isAdmin == false and @currentUser.isSuperAdmin == true
        @usersAdmin = User.where(:isAdmin => true)
        @iboxes = Ibox.all
      end
      format.js
    end
  end
  
  
end
