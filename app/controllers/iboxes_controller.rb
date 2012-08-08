class IboxesController < ApplicationController
  # GET /iboxes
  # GET /iboxes.json
    layout "homeadmin"
  def index
    @iboxes = Ibox.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @iboxes }
    end
  end

  # GET /iboxes/1
  # GET /iboxes/1.json
  def show
    @ibox = Ibox.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ibox }
      format.js #added
    end
  end

  # GET /iboxes/new
  # GET /iboxes/new.json
  def new
    @ibox = Ibox.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ibox }
      format.js #added
    end
  end

  # GET /iboxes/1/edit
  def edit
    @ibox = Ibox.find(params[:id])
    respond_to do |format|
      format.js #added
    end
  end

  # POST /iboxes
  # POST /iboxes.json
  def create
    @ibox = Ibox.new(params[:ibox])

    respond_to do |format|
      if @ibox.save
        format.html { redirect_to @ibox, notice: 'Ibox was successfully created.' }
        format.json { render json: @ibox, status: :created, location: @ibox }
        format.js #added

      else
        format.html { render action: "new" }
        format.json { render json: @ibox.errors, status: :unprocessable_entity }
        format.js #added
      end
    end
  end

  # PUT /iboxes/1
  # PUT /iboxes/1.json
  def update
    @ibox = Ibox.find(params[:id])

    respond_to do |format|
      if @ibox.update_attributes(params[:ibox])
        format.html { redirect_to @ibox, notice: 'Ibox was successfully updated.' }
        format.json { head :no_content }
        format.js 
      else
        format.html { render action: "edit" }
        format.json { render json: @ibox.errors, status: :unprocessable_entity }
        format.js 
      end
    end
  end

  # DELETE /iboxes/1
  # DELETE /iboxes/1.json
  def destroy
    @ibox = Ibox.find(params[:id])
    @ibox.destroy

    respond_to do |format|
      format.html { redirect_to iboxes_url }
      format.json { head :no_content }
      format.js 
    end
  end
  

  def enable
    respond_to do |format|
      if Ibox.exists?(params[:ibox_id])
        @ibox = Ibox.find(params[:ibox_id])
        @user = User.find(session[:user_id])
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
  
  
  def addDefaultAccessories
    require 'net/http'
    require 'uri'
    ip = '200.28.166.104'
    port = 1166
    ws = 'http://' + ip + ':' + port.to_s
    url = URI.parse(ws)
    begin
      req = Net::HTTP::Get.new(url.path + '/cgi-bin/Get.cgi?get=SET')
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
      @ibox = Ibox.find(params[:id])
      session[:ibox_id] = @ibox.id
      #Se dividen obtiene los 12 parametros por accesorio
      for i in 0..res.length/12-1
        #Se crea el accessorio 
        @accessory = Accessory.new
        @accessory.update_attribute(:zid, res[0+12*i].to_s.split('=')[1])
        @accessory.update_attribute(:kind, res[1+12*i].to_s.split('=')[1])
        @accessory.update_attribute(:name, res[2+12*i].to_s.split('=')[1])
        @accessory.update_attribute(:cmdclass, res[10+12*i].to_s.split('=')[1])
        
        #Se determina el tipo de accesorio del accesorio
        if (@accessory.kind == "BinarySwitch")
          @accessory_type = AccessoryType.find_by_name("Luces")
        end
        if (@accessory.kind == "MultiLevelSwitch")
          if (@accessory.cmdclass == "AllOnOff,Configuration")
            @accessory_type = AccessoryType.find_by_name("Dimmers")
          else
            @accessory_type = AccessoryType.find_by_name("Cortinas")
          end
        end
        if (@accessory.kind == "BinarySensor")
          @accessory_type = AccessoryType.find_by_name("Sensores")
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
      end
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
      flash[:error] = "Lo sentimos, el servicio no se encuentra disponible actualmente."
    end
    flash[:notice] = "Hemos habilitado exitosamente el Ibox!"
    respond_to do |format|
      format.js
    end 
  end  
  
end
