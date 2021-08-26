class ApplicationController < ActionController::API
  def encode_token(payload)
    JWT.encode(payload, 'my_s3cr3t') # obviously change this to a real gitignore secret
  end

  def decoded_token(token)
    JWT.decode(token, 'my_s3cr3t')[0] # again obviously this will change
  end
  
end
