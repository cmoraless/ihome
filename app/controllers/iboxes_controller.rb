class IboxesController < ApplicationController
  # GET /iboxes
  # GET /iboxes.json
  layout "admin"
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
    end
  end

  # GET /iboxes/new
  # GET /iboxes/new.json
  def new
    @ibox = Ibox.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ibox }
    end
  end

  # GET /iboxes/1/edit
  def edit
    @ibox = Ibox.find(params[:id])
  end

  # POST /iboxes
  # POST /iboxes.json
  def create
    @ibox = Ibox.new(params[:ibox])

    respond_to do |format|
      if @ibox.save
        format.html { redirect_to @ibox, notice: 'Ibox was successfully created.' }
        format.json { render json: @ibox, status: :created, location: @ibox }
      else
        format.html { render action: "new" }
        format.json { render json: @ibox.errors, status: :unprocessable_entity }
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
      else
        format.html { render action: "edit" }
        format.json { render json: @ibox.errors, status: :unprocessable_entity }
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
    end
  end
  

  def enable
    @ibox = Ibox.find(params[:ibox_id])
    @ibox.update_attribute(:isActive, true)

    respond_to do |format|
      format.html { redirect_to @ibox }
      format.json { head :no_content }
    end
  end
  
  def enabled
    respond_to do |format|
      if @ibox.update_attributes(params[:ibox])

      format.html { redirect_to :action => "index" }
      format.json { head :no_content }
      end
    end
  end
  
  def listenAccessories
    #@accessory_types = AccessoryType.all
    #leer la caja
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
      @accessories = [] #conoce todos los accesorios
      for i in 0..res.length/12-1 #divido en 12 ya que son 12 parametros por accesorios 
        #guardo en accessories con los parametros que se usaran
        @accessories << {:zid => res[0+12*i].to_s.split('=')[1], 
          :kind => res[1+12*i].to_s.split('=')[1], 
          :alias => res[2+12*i].to_s.split('=')[1], 
          :cmdclass => res[10+12*i].to_s.split('=')[1]
          }
        
      end
      @body = @accessories
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,SocketError => e
      flash[:notice] = "Lo sentimos, el servicio no se encuentra disponible actualmente."
    end
  end
  
end
