Devise.setup do |config|
  config.secret_key = 'bcc80ea13e0d73c9cdfb423b93f703123287a3a60aaaa9721cdbc402d28cea1fa66288ac1cc2bc5033e5442059815e95e896b7500cfe9f24906e9ef5f8780e20'
  config.authentication_keys = [:email]
  config.navigational_formats = [ :json ]
end