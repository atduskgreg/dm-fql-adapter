require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-fql-adapter'

class User
  include DataMapper::Resource

  property :uid, Serial # !important
  property :name, String
  property :sex, String
  property :pic_big, String
end

post "/" do
  adapter = DataMapper.setup(:default, 
    {:adapter => 'fql', 
     :api_key => "a8b912453d364ae459df95fea72b95a8", 
     :secret_key => "7401713381e2d6a8092806a4b0c1eee1", 
     :session_key => params[:fb_sig_session_key]
      }
    )
  adapter.resource_naming_convention = DataMapper::NamingConventions::Resource::Underscored

  user = User.get(500409376)
  "#{user.name} - #{user.sex} <img src=\"#{user.pic_big}\" />"
end