class IboxesController < ApplicationController
  layout "homeadmin"
  def index
    @iboxes = Ibox.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @iboxes }
    end
  end

  def show
    @ibox = Ibox.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ibox }
      format.js #added
    end
  end

  def new
    @ibox = Ibox.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ibox }
      format.js #added
    end
  end

  def edit
    @ibox = Ibox.find(params[:id])
    respond_to do |format|
      @iboxes = Ibox.all
      format.js #added
    end
  end

  def create
    @ibox = Ibox.new(params[:ibox])

    respond_to do |format|
      if @ibox.save
        @iboxes = Ibox.all
        format.js
      else
        format.js
      end
    end
  end

  def update
    @ibox = Ibox.find(params[:id])

    respond_to do |format|
      if @ibox.update_attributes(params[:ibox])
        @iboxes = Ibox.all
        format.js 
      else
        format.js 
      end
    end
  end
  
  def get_content_to_display
    #Place code here
    render :update do |page|
      page.replace_html "display_ajax", :partial => 'waiting'
    end
  end

  def destroy
    @ibox = Ibox.find(params[:id])
    @ibox.destroy
    @iboxes = Ibox.all
    respond_to do |format|
     format.js 
    end
  end

  def enable
      respond_to do |format|
      if Ibox.exists?(params[:ibox_id])
        @ibox = Ibox.find(params[:ibox_id])
        @user = User.find(session[:user_id])
        session[:ibox_id] = @ibox.id
        if @ibox.isActive == true
          flash[:notice] = "El ibox seleccionado ya esta activo."
          format.js
        else
          @ibox.update_attribute(:isActive, true)
          @ibox.users << @user
          format.js {redirect_to :action => 'addDefaultAccessories', :id => @ibox.id}
        end
      else  
        flash[:notice] = "No hemos encontrado el ibox especificado"
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
    if addAccessories(@ibox.id) 
      flash[:notice] = "Hemos habilitado exitosamente el Ibox y agregado tus nuevos accesorios!"
    else
      flash[:error] = "Hemos habilitado exitosamente el Ibox, pero no hemos encontrado nuevos accesorios!"
    end
  end

  def listenToAddAccessory
    @ibox = Ibox.find(session[:ibox_id])
    res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Mode.cgi?MODE=A')
    if res[0] == "Success"
      begin
        res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?ZG=MODE')
        sleep 2
      end while (res[0] == 'MODE=READY')
      sleep 4
      if addAccessories(@ibox.id)
        flash[:notice] = "Se ha agregado el nuevo accesorio"
      else
        res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?ZG=MODE')
        flash[:error] = "No se pudo agregar el nuevo accesorio"
      end
    else
      flash[:error] = "ERROR"
    end 
    respond_to do |format|
      format.js
    end
  end

  def listenToRemoveAccessory
    @ibox = Ibox.find(session[:ibox_id])
    res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Mode.cgi?MODE=R')
    if res[0] == "Success"
      begin
        res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?ZG=MODE')
        sleep 2
      end while (res[0] == 'MODE=READY')
      sleep 4
      
      if removeAccessories(@ibox.id)
        flash[:notice] = "Se pudo eliminar el nuevo accesorio"
      else
        res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?ZG=MODE')
        flash[:error] = "No se ha eliminado el nuevo accesorio"
      end

    else
      flash[:error] = "ERROR"
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
        logger.debug "################# #{accessory.zid} " 
        logger.debug "################# #{ret} "
      end
    end
    ret
  end

  # Función 
  # Entrada: 
  # Salida: 
  def addAccessories(ibox_id)
    ret = false
    @ibox = Ibox.find(ibox_id)
    res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Get.cgi?get=SET')
    for i in 0..res.length/12-1
      #Si no esta asociado el accesorio al Ibox
      if (!isSavedAccessory(ibox_id, res[0+12*i].to_s.split('=')[1])) 
        #Se crea el accessorio 
        @accessory = Accessory.new
        @accessory.update_attribute(:zid, res[0+12*i].to_s.split('=')[1])
        @accessory.update_attribute(:kind, res[1+12*i].to_s.split('=')[1])
        @accessory.update_attribute(:cmdclass, res[10+12*i].to_s.split('=')[1])
        
        resacc = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?ZID=' + @accessory.zid)
      
        @accessory.update_attribute(:value, resacc[2].to_s.split('=')[1])
       
        #Se determina el tipo de accesorio del accesorio
        if (@accessory.kind == "BinarySwitch")
          if (res[3+12*i].to_s.split('=')[1] == "400")
            @accessory_type = AccessoryType.find_by_name("Riego")
            @accessory.update_attribute(:name, "aspersor 0"+i.to_s)
          else
            @accessory_type = AccessoryType.find_by_name("Luces")
            @accessory.update_attribute(:name, "luces 0"+i.to_s)
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
    res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?ZID=' + zid )
    logger.debug "################# #{res[0]} " 
    if (res[0] == 'Fail:501') 
      ret = false
    end
    ret
  end  

  # Descripción: Función que ejecuta comandos para un determinado Ibox
  # Entrada: 
  # Salida: Arreglo con la salida del comando
  def iboxExecute(ibox_ip, ibox_port, instruction)
    require 'net/http'
    require 'uri'
    ws = 'http://' + ibox_ip + ':' + ibox_port
    url = URI.parse(ws)
    begin
      req = Net::HTTP::Get.new(url.path + instruction )
      req.basic_auth 'root', ''
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
  
end
