class AccessoriesController < ApplicationController
  before_filter :check_auth_admin
  skip_before_filter :check_auth_admin, :only=>[:back, :control]
  
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
        if accessory.kind == 'MultiLevelSwitch'
          req = Net::HTTP::Get.new(url.path + '/cgi-bin/Switch.cgi?VALUE=' + params[:value] + '&ZID=' + accessory.zid)
        end
        if accessory.kind == 'BinarySwitch'
          req = Net::HTTP::Get.new(url.path + '/cgi-bin/Switch.cgi?OP=' + params[:value] + '&ZID=' + accessory.zid)
        end
        req.basic_auth 'root', ''
        res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
        accessory.update_attribute(:value, params[:value].to_i)
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
        Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
        flash[:notice] = "Lo sentimos, el servicio no se encuentra disponible actualmente."
      end
      format.js
    end
  end
  
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
