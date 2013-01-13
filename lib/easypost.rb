require 'typhoeus'
require 'json'

module EasyPost
  @@api_key = "..."
  @@api_base = 'http://www.easypostapi.com/api/'

  def self.api_url(args={})
    raise ArgumentError unless args.keys.eql?([:type, :action])
    return "#{@@api_base}#{args[:type]}/#{args[:action]}"
  end

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.api_key
    @@api_key
  end

  def self.symbolize_keys(hash={})
    hash.keys.each do |key|
      hash[(key.to_sym rescue key) || key] = hash.delete(key)
    end
    return hash
  end

  def self.symbolize_keys_recursive(hash={})
    hash.keys.each do |key|
      keysym = (key.to_sym rescue key) || key
      hash[keysym] = hash.delete(key)
      if hash[keysym].is_a?(Hash)
        hash[keysym] = symbolize_keys_recursive(hash[keysym])
      end
    end
    return hash
  end

  def self.get(url, params={})
    params = {:userpwd => @@api_key, :params => params}
    @response = Typhoeus::Request.get(url, params)
    return EasyPost.symbolize_keys_recursive(JSON.parse(@response.body))
  end

  def self.post(url, params={})
    params = {:userpwd => @@api_key, :params => params}
    @response = Typhoeus::Request.post(url, params)
    return EasyPost.symbolize_keys_recursive(JSON.parse(@response.body))
  end

end

require 'easypost/address'
require 'easypost/postage'
require 'easypost/errors/easypost_error'
require 'easypost/errors/authentication_error'

