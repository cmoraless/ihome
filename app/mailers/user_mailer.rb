class UserMailer < ActionMailer::Base
  default from: "ihome.bissen@gmail.com"
  
  def welcome_email(user,password)
    @user = user
    @password = password
    @url = 'http://www.bissen.cl/ihome'
    mail(:to => user.email, :subject => "Bienvenido a iHome.")
  end
  
  def recovery_pass(user)
    @user = user    
    mail(:to => user.email, :subject => "Recuperacion contrasena")
  end
  
end
