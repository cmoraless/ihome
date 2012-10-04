#!/bin/env ruby
# encoding: utf-8

class AccessoriesController < ApplicationController
  before_filter :check_auth_admin, :except => [:back, :control]
  
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
  
  # GET /accessories/new
  # GET /accessories/new.json
  def new
    @accessory = Accessory.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @accessory }
    end
  end

  # GET /accessories/1/edit
  def edit
    @accessory = Accessory.find(params[:id])
    @ibox = Ibox.find(session[:ibox_id])
    @users = @ibox.users.where(:isAdmin => false)
    @accessoryTypes= AccessoryType.all
    @accessoryTypes.delete(AccessoryType.find_by_name("Sensores"))

  end

  # POST /accessories
  # POST /accessories.json
  def create
    @accessory = Accessory.new(params[:accessory])

    respond_to do |format|
      if @accessory.save
        format.html { redirect_to @accessory, notice: 'Accessory was successfully created.' }
        format.json { render json: @accessory, status: :created, location: @accessory }
      else
        format.html { render action: "new" }
        format.json { render json: @accessory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /accessories/1
  # PUT /accessories/1.json
  def update
    @accessory = Accessory.find(params[:id])
    @ibox = Ibox.find(session[:ibox_id])
    @containerOld = IboxAccessoriesContainer.find_by_ibox_id_and_accessory_type_id(@ibox.id, @accessory.accessory_type.id)
    @containerOld.accessories.destroy(@accessory)
       
    respond_to do |format|
      if @accessory.update_attributes(params[:accessory])
        #guardo el nombre del accesorio en el ibox
        name = @accessory.name #lo asigno para borrarle los espacios para pasarselo al webservice
        iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Set.cgi?ZID=' + @accessory.zid + '&ALIAS=' + name.delete(' ') + '&X=' + @accessory.x  + '&Y=' + @accessory.y + '&W=' + @accessory.w + '&H=' + @accessory.h + '&Layer=0',@ibox.user,@ibox.password)        
        # se agrega al nuevo containter
        if (!@ibox.accessory_types.find_by_name(@accessory.accessory_type.name))
          @ibox.accessory_types << @accessory.accessory_type
        end
        @container = IboxAccessoriesContainer.find_by_ibox_id_and_accessory_type_id(@ibox.id, @accessory.accessory_type.id)
               
        @container.update_attribute(:name, @accessory.accessory_type.name)
        @container.accessories << @accessory      

        @containers = IboxAccessoriesContainer.where("ibox_id = ?", @ibox.id)
        @accessories = []
        @containers.each do |container|
        @accessories << container.accessories
      end  
        format.js
      else
        format.js { render :action => "edit" }
      end
    end
  end

  # DELETE /accessories/1
  # DELETE /accessories/1.json
  def destroy
    @accessory = Accessory.find(params[:id])
    @ibox = Ibox.find(session[:ibox_id])
    res = Ibox.iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?OP=3&ZID=' + @accessory.zid, @ibox.user, @ibox.password)
    if (res[0] == 'Success')
       @accessory.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to accessories_url }
      format.json { head :no_content }
    end
  end
  
  #funcion que hace control de un accesorio en el ibox
  def control
    require 'net/http'
    require 'uri'
    ibox = Ibox.find(session[:ibox_id])
    accessory = Accessory.find(params[:id])
    ip = ibox.ip
    port = ibox.port
    ws = 'http://' + ip + ':' + port
    url = URI.parse(ws)
    respond_to do |format|
      begin
        res = iboxExecute(ip, port, '/cgi-bin/Status.cgi?ZID=' + accessory.zid, ibox.user, ibox.password)
        if (res[2] == 'STATUS=99')
          flash[:notice] = ""
          flash[:error] = "El Ibox no puede conectarse con el accesorio"
          #format.js {render :js => "window.location.replace('#{url_for(:controller => 'home', :action => 'index')}');"}
          format.js {render :js => "window.location.reload();"}
        else
          if accessory.kind == 'MultiLevelSwitch'
            #req = Net::HTTP::Get.new(url.path + '/cgi-bin/Switch.cgi?VALUE=' + params[:value] + '&ZID=' + accessory.zid)
            req = Net::HTTP::Get.new(url.path + '/cgi-bin/Switch.cgi?&ZID=' + accessory.zid + '&VALUE=' + params[:value] + '&DEALY=&TIMER=')
          end
          if accessory.kind == 'BinarySwitch'
            req = Net::HTTP::Get.new(url.path + '/cgi-bin/Switch.cgi?OP=' + params[:value] + '&ZID=' + accessory.zid)
          end
          req.basic_auth ibox.user, ibox.password
          res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
          accessory.update_attribute(:value, params[:value].to_i)
          
          
          ### FOR DEBUGING!
          time = Time.new
          currentDay = time.wday
          currentTime = time.strftime("%H:%M:00")  
          @user = User.find(session[:user_id])
          AccessoriesLogger.debug "El accesorio: #{accessory.name} se accionó con el valor: #{params[:value]} por el usuario #{@user.email} a las: #{currentTime} #{currentDay}"
        end              
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
        Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
        flash[:notice] = "Lo sentimos, el servicio no se encuentra disponible actualmente."
      end
      format.js
    end
  end
  
  
  #funcion que ejecuta un comando consumiendo un webservice en el ibox que es pasado por parametro (instruction)
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
      path = Rails.root.to_s + '/tmp/server' + session[:user_id].to_s + session[:ibox_id].to_s + '.txt'
      f_out = File.new(path,'w')
      f_out.puts res.body
      f_out.close
      res = Array.new
      f_in = File.open(path,'r') do |f|
        while line = f.gets
          res << line.to_s.chomp
        end
      end
      File.delete(path)
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
    end
    res
  end   
  
  #funcion para obtener el estado de los sensores
  def get_status
    @accessory = Accessory.find(params[:id])
    @ibox = Ibox.find(session[:ibox_id])
    res = iboxExecute(@ibox.ip, @ibox.port, '/cgi-bin/Status.cgi?ZID=' + @accessory.zid, @ibox.user, @ibox.password)  
    status = res[2].to_s.split('=')[1]
    render :text => status.to_s
  end
    
  #funcion que vuelve atras en la vista de accesorios en la vista admin
  def back
    respond_to do |format|
      @currentUser = User.find(session[:user_id])
      @iboxes = @currentUser.iboxes
      @ibox = Ibox.find(session[:ibox_id])
      @containers = IboxAccessoriesContainer.where("ibox_id = ?", @ibox.id)
      @accessories = []
      @containers.each do |container|
        @accessories << container.accessories
      end
      format.js  
    end
  end
  
end
