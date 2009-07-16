require 'md5'
require 'json'
require 'rubygems'
require 'rest_client'

class Facemask
  class FaceFail < StandardError; end
  
  attr_accessor :session_key, :api_key, :secret_key
  
  def initialize opts={}
    @api_key = opts[:api_key]
    @secret_key = opts[:secret_key]
    @session_key = opts[:session_key]
  end
  
  def post(method, params)
    params.merge! generate_params(method)
    params.merge! :sig => signature_for(params)
    Facemask.execute(params)
  end
  
  # Sends a templatized feed for the given bundle_id with the given data hash.
  def publish_user_feed(bundle_id, data)
    post("facebook.feed.publishUserAction", {:template_bundle_id=> bundle_id, 
                                             :template_data => data.to_json} )
  end
  
  def find_by_fql(query)
    post('facebook.fql.query', :query => query, :format => "json")
  end
  
  def publish_page_feed(data)
    data[:title_template] ||= "{actor} Item"
    post("facebook.feed.publishTemplatizedAction", data)
  end
  
  def self.execute(params)
    begin
      puts "[FBOOK REQUEST] #{params.inspect}"
      result = RestClient.post("http://api.facebook.com/restserver.php", params)
    rescue Errno::ECONNRESET, EOFError
      if attempt == 0
        attempt += 1
        puts "Failed once, retrying..."
        retry
      end
    rescue Exception => e
      raise FaceFail.new(e)
    end        
  end
  
  def signature_for(params)
    raw_string = params.inject([]) do |collection, pair|
      collection << pair.join("=")
      collection
    end.sort.join
    puts "ABOUT TO HEX"
    puts raw_string
    puts self.secret_key
    Digest::MD5.hexdigest([raw_string, self.secret_key].join)
  end
  
  def generate_params(method)
    result = {}
    if session_key
      result[:session_key] = session_key    
    end
    
    result[:method] = method
    result[:api_key] = api_key
    result[:call_id] = Time.now.to_f.to_s
    result[:v] = "1.0"
    
    result
  end
end