require 'openssl'
require "citrus_ror/version"

module CitrusRor
  $required_fields = [:merchantAccessKey,:merchantTxnId,:orderAmount,:currency,:returnUrl,:secSignature]
  class CitrusSandboxLib
    
    @@apiKey=''
    
    def initialize( key )
      @@apiKey = key
    end 
    
    def getApiUrl
      'https://sandboxadmin.citruspay.com/api/v1/txn/'
    end
    
    def getCpUrl()
      'https://sandbox.citruspay.com/'
    end
    
    def getHmac(data)
      digest = OpenSSL::Digest::Digest.new('sha1')
      sig=OpenSSL::HMAC.hexdigest(digest, @@apiKey, data)
      return sig
    end

    def makeTransaction(data_hash)
      data="1kuce0gpcc"+data_hash[:orderAmount]+data_hash[:merchantTxnId]+data_hash[:currency]
      data_hash[:merchantAccessKey] = "TS08ZVS7QK13RG0E9TNY"
      data_hash[:returnUrl]         = "http://localhost:3000/test/callback"
      data_hash[:secSignature]      = getHmac(data)
      validate(data_hash)

      uri = URI.parse("#{getCpUrl}1kuce0gpcc")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(data)   
      response = http.request(request)
    end

        
    def validate(data_hash)
      
      _absent_keys  = []
      _absent_value = []
      $required_fields.each do |field|
        if data_hash.has_key?field
          _absent_value << field if data_hash[field].empty?
        else
          _absent_keys  << field #unless data_hash.has_key?field
        end
      end

      raise ArgumentError.new(_absent_keys.join(",")+" must be present") unless _absent_keys.empty?
      raise ArgumentError.new(_absent_keys.join(",")+" must have value") unless _absent_value.empty?
    end
  end

  
   class CitrusStagingLib
    
    @@apiKey=''
    
    def intialize(key)
      @@apiKey = key
    end 
    
    def getApiUrl
      'https://stgadmin.citruspay.com/api/v1/txn/'
    end
    
    def getCpUrl()
      'https://stgadmin.citruspay.com/'
    end
    
    def getHmac(data)
      digest = OpenSSL::Digest::Digest.new('sha1')
      sig=OpenSSL::HMAC.hexdigest(digest, @@apiKey, data)
      return sig
    end
    
  end

  class CitrusProductionLib
    @@apiKey=''
    
    def initialize(key)
      @@apiKey = key
    end 
    
    def getApiUrl
      'https://admin.citruspay.com/api/v1/txn/'
    end
    
    def getCpUrl()
      'https://www.citruspay.com/'
    end
    
    def getHmac(data)
      digest = OpenSSL::Digest::Digest.new('sha1')
      sig=OpenSSL::HMAC.hexdigest(digest, @@apiKey, data)
      return sig
    end
  end
 
end
