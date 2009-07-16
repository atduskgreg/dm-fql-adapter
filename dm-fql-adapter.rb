require DataMapper.root / 'lib' / 'dm-core' / 'adapters' / 'abstract_adapter'
require DataMapper.root / 'lib' / 'dm-core' / 'adapters' / 'data_objects_adapter'
require 'facemask'
require 'json'

module DataMapper
  module Adapters
    
    class DataObjectsAdapter
      module SQL
        def quote_name(name)
          name
        end
      end
    end
    
    class FqlAdapter < AbstractAdapter

      include DataMapper::Adapters::DataObjectsAdapter::SQL

      def initialize(name, options={})
        super
        
        @facebook = Facemask.new :api_key     => options[:api_key],
                                 :secret_key  => options[:secret_key],
                                 :session_key => options[:session_key]
      end
      
      def read(query)        
        q = select_statement(query).to_s
      
        # hack around the mysterious '?'
        q = q.gsub(/\?(\w*)/){"\"#{$1}\""}

        results = @facebook.find_by_fql(q)
        results = JSON.parse(results)
        query.filter_records(results)
      end
      

    end # class FqlAdapter
  end
end