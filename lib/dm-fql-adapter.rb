$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'dm-core'  
require DataMapper.root / 'lib' / 'dm-core' / 'adapters' / 'abstract_adapter'
require DataMapper.root / 'lib' / 'dm-core' / 'adapters' / 'data_objects_adapter'
require File.expand_path(File.dirname(__FILE__)) + '/dm-fql-adapter/facemask.rb'
require 'json'

module DataMapper
  module Adapters
  
    
    class FqlAdapter < AbstractAdapter

      include DataMapper::Adapters::DataObjectsAdapter::SQL

      # override DataObjectsAdapter::SQL#quote_name
      def quote_name(name)
        name
      end
      
      def quote_value(value)
        case value
        when Array
          "(#{value.map { |entry| quote_value(entry) }.join(', ')})"
        else
          "\"#{value}\""
        end
      end

      def initialize(name, options={})
        super
        
        self.resource_naming_convention = DataMapper::NamingConventions::Resource::Underscored        
        
        @facebook = Facemask.new :api_key => options[:api_key],
                                 :secret_key => options[:secret_key],
                                 :session_key => options[:session_key]        
      end
      
      def read(query)        
        statement, bind_values = select_statement(query)
    
        statement.gsub!(/\?/) { quote_value(bind_values.shift) }
    
        results = @facebook.find_by_fql(statement)
        
        results = JSON.parse(results)
        
        puts
        puts "DM JSON**********"
        puts results.inspect
        puts
        
        query.filter_records(results)
      end
      

    end # class FqlAdapter
  end
end