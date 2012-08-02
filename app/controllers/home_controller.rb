class HomeController < ApplicationController
  before_filter :check_auth
  def check_auth
    if session[:user_id] == nil
      redirect_to(root_path)
    end
  end
  
  def index
    @accessories = Accessory.all
    @user = User.find(session[:user_id])
    @iboxes = @user.iboxes
    #leer la caja
=begin    
  
    require 'net/http'
    require 'uri'
    ip = '200.28.166.104'
    port = '1166'
    ws = 'http://' + ip + ':' + port
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
      for i in 0..res.length/12-1 #divido en 12 ya que son 12 parametros por accesorio
        #guardo en accessories los parametros que se usaran de los accesorios
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
=end
  end
  
 def signout
    redirect_to :controller=>"start", :action=>"index"
  end
  
end
