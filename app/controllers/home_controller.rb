class HomeController < ApplicationController
  def index
   
  end
  
 def signout
    redirect_to :controller=>"start", :action=>"index"
  end
  
end
