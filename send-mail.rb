require 'pony'

def send_mail(recipient, subject, body)
    Pony.mail({
        #:to => '3175083275@vtext.com',
        :to => recipient,
        :via => :smtp,
        :subject => subject, :body => body,
        :via_options => {
          :address              => 'smtp.gmail.com',
          :port                 => '587',
          :enable_starttls_auto => true,
          :user_name            => 'holmekj2@gmail.com',
          :password             => 'jiuziedwjlanfiqy',
          :authentication       => :plain,
          :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
          
        }
      })    
end

# Pony.mail({
#     #:to => '3175083275@vtext.com',
#     :to => 'holmekj2@gmail.com',
#     :via => :smtp,
#     :subject => "test1subject", :body => 'test1body',
#     :via_options => {
#       :address              => 'smtp.gmail.com',
#       :port                 => '587',
#       :enable_starttls_auto => true,
#       :user_name            => 'holmekj2@gmail.com',
#       :password             => 'jiuziedwjlanfiqy',
#       :authentication       => :plain,
#       :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
      
#     }
#   })

send_mail('holmekj2@gmail.com', "", "test2")
#send_mail('3175083275@vtext.com', "", "test2")
