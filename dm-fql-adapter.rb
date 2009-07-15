require 'rubygems'
require 'dm-core'
require 'dm-core/adapters/abstract_adapter'
require 'facemask'

module DataMapper
  module Adapters
    class FqlAdapter < AbstractAdapter

      def initialize(name, options)
        super
        
        @facebook = Facemask.new :api_key    => options[:api_key],
                                 :secret_key => options[:secret_key]
      end

    end
  end
end