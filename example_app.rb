require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'lib/dm-fql-adapter'

class User
  include DataMapper::Resource
  
  # NB: If you don't pick a key DM will act weird
  property :uid, Integer, :key => true 
  property :name, String
  property :sex, String
  property :pic_big, String
end

class Stream
  include DataMapper::Resource
  
  property :source_id, Integer, :key => true
  property :post_id, String, :key => true
  property :message, String
  property :likes, String # i.e. give me back the hash without touching it
  property :comments, String
end

post "/" do
  adapter = DataMapper.setup(:default, 
    {:adapter => 'fql', 
     :api_key => "a8b912453d364ae459df95fea72b95a8", 
     :secret_key => "7401713381e2d6a8092806a4b0c1eee1", 
     :session_key => params[:fb_sig_session_key]
      }
    )
    
    f = Facemask.new :api_key => "a8b912453d364ae459df95fea72b95a8", 
                    :secret_key => "7401713381e2d6a8092806a4b0c1eee1", 
                    :session_key => params[:fb_sig_session_key]
                                 
    res = f.find_by_fql("SELECT source_id, post_id, message, likes, comments FROM stream WHERE post_id = \"103592400571_124417260882\"")
    puts
    puts "FMASK********"
    puts res
    puts
    puts
    puts "DM********"
    scg_stream = Stream.all( :post_id => "103592400571_124417260882")
    puts scg_stream.inspect
    puts
    puts "COMMENTS"
    puts scg_stream.last.comments.class
    puts scg_stream.last.comments.inspect
    puts
  "hi"
  # user = User.get(546502145)
  #"#{user.name} - #{user.sex} <img src=\"#{user.pic_big}\" />"
end