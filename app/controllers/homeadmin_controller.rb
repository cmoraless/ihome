class HomeadminController < ApplicationController
  def index
    @iboxes = Ibox.all
    @accessory_types = AccessoryType.all
    #logger.debug "####################ACCESSORY TYPES   #{@accessory_types.length}"
    if @accessory_types.length == 0
      @accessory = AccessoryType.new(:name=>"Cortinas")
      @accessory.save
      @accessory = AccessoryType.new(:name=>'Luces')
      @accessory.save
      @accessory = AccessoryType.new(:name=>'Dimmers')
      @accessory.save
      @accessory = AccessoryType.new(:name=>'Sensores')
      @accessory.save
      @accessory = AccessoryType.new(:name=>'Riego')
      @accessory.save  
    end
    @accessory_types = AccessoryType.all
    @users = User.all
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { }
    end
  end
  
  def view
   
  end
    
end
