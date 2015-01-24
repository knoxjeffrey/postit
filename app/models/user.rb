class User < ActiveRecord::Base
  include Sluggable
  
  has_many :posts
  has_many :comments
  has_many :votes
  
  has_secure_password validations: false
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}
  
  sluggable_column :username
  
  def two_factor_auth?
    !self.phone.blank?
  end
  
  def generate_pin!
    self.update_column(:pin, rand(10 ** 6)) # random 6 digit number
  end
  
  def remove_pin!
    self.update_column(:pin, nil) # remove the pin
  end
  
  def send_pin_to_twilio
    # put your own credentials here 
    account_sid = 'ACccc96b6d4653d3158c5186d40d460269' 
    auth_token = '118b44457de00c91a7a5d09cb16d21f8' 
 
    # set up a client to talk to the Twilio REST API 
    client = Twilio::REST::Client.new account_sid, auth_token 
 
    msg = "Hi, please input the pin to continue login: #{self.pin}"
 
    client.account.messages.create({
    	:from => '+442033229411', 
    	:to => self.phone, 
    	:body => msg,  
    })
  end
  
  def admin?
    self.role == 'admin'
  end
  
  def moderator?
    self.role == 'moderator'
  end
end