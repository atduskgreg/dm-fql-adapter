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

end