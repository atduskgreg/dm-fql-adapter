require 'rubygems'
require 'spec'
require 'dm-fql-adapter'
require 'dm-core'
require 'dm-core/spec/adapter_shared_spec'

describe DataMapper::Adapters::FqlAdapter do
  before :all do
    @adapter = DataMapper.setup(:default, :adapter   => 'fql',
                                          :api_key  => 'api',
                                          :secret_key      => 'secret')
  end

  it_should_behave_like 'An Adapter'
end