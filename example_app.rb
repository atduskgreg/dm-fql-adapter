require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-fql-adapter'

class User
  include DataMapper::Resource
  
  # NB: If you don't pick a key DM will act weird
  property :uid, Integer, :key => true 
  property :name, String
  property :sex, String
  property :pic_big, String
end

post "/" do
  adapter = DataMapper.setup(:default, 
    {:adapter => 'fql', 
     :api_key => "YOUR API KEY", 
     :secret_key => "YOUR SECRET KEY", 
     :session_key => params[:fb_sig_session_key]
      }
    )

  user = User.get(546502145)
  "#{user.name} - #{user.sex} <img src=\"#{user.pic_big}\" />"
end