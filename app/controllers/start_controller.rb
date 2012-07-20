class StartController < ApplicationController
  def index
  
  end
  
  def login
    redirect_to :controller => "home", :action => "index"
  end
  
  
end
