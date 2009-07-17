require 'rubygems'
require 'spec'
require 'dm-core'
require File.expand_path(File.dirname(__FILE__)) + '/../lib/dm-fql-adapter.rb'

class User
  include DataMapper::Resource

  property :uid, Integer, :key => true # !important
  property :name, String
  property :sex, String
  property :pic_big, String
end

class Stream
  include DataMapper::Resource
  
  property :source_id, Integer
  property :post_id, Integer, :key => true
  property :message, String
end

describe DataMapper::Adapters::FqlAdapter do
  before :all do
    Facemask.stub!(:new).and_return(@f = mock('Facemask'))                                      

    @adapter = DataMapper.setup(:default, :adapter   => 'fql',
                                          :api_key  => 'api',
                                          :secret_key      => 'secret')
  end

  it "should generate the correct FQL" do
    @f.should_receive(:find_by_fql).with("SELECT uid, name, sex, pic_big FROM user WHERE uid = \"12345\"").and_return('[{"name":"Cyndy Glucksman","pic_big":"http:\/\/profile.ak.fbcdn.net\/v227\/1454\/108\/n500409376_1710.jpg","sex":"female","uid":500409376}]')
    User.get(12345)
  end

  it "should package up the objects correctly even if there are multiple entries returned" do
    @f.stub!(:find_by_fql).and_return('[{"post_id":"103592400571_124417260882","source_id":103592400571,"message":"This is another post."},{"post_id":"103592400571_126720720199","source_id":103592400571,"message":"Check it out!"}]')
    result = Stream.all( :source_id => 103592400571)
    result.collect{|s| s.message}.should include("This is another post.")
    result.collect{|s| s.message}.should include("Check it out!")

  end

end
