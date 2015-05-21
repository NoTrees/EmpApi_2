class User < ActiveRecord::Base
	before_create :set_auth_token
	validates_presence_of :id, :name, :password
	validates :id, uniqueness: true
	validates :password, length: { minimum: 7 }

	private
	  	def set_auth_token
	  		return if auth_token.present?
	  		self.auth_token = generate_auth_token
	  	end

	  	def generate_auth_token
	  		loop do
	  			token = SecureRandom.hex
	  			break token unless self.class.exists?(auth_token: token)
	  		end
	  	end
end
