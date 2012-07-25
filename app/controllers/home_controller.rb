class HomeController < ApplicationController
  def index
    @accessory_types = AccessoryType.all
  end
  
 def signout
    redirect_to :controller=>"start", :action=>"index"
  end
  
end
