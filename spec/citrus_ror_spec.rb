#require 'spec_helper'
require File.expand_path("../../lib/citrus_ror", __FILE__)
describe CitrusRor do 

  context "CitrusSandboxLib" do
    let(:digest)            {OpenSSL::Digest::Digest.new('sha1')}
    let(:apiKey)            {"0699ac0d49c40f5d46996769b0adc93b003454bd"}
    let(:data)              {"Santu"}
    let(:data_encr)         {OpenSSL::HMAC.hexdigest(digest, apiKey, data)}
    let(:citrus_sand_obj)   {CitrusRor::CitrusSandboxLib.new apiKey}
    let(:x)                 {citrus_sand_obj.validate({})}
    subject(:citrus_sand_class) {CitrusRor::CitrusSandboxLib}
    
    it "costructor should work" do
      expect(citrus_sand_obj).to be_truthy
    end

    it "should respond with TS08ZVS7QK13RG0E9TNY for class attribute apiKey" do
      expect(citrus_sand_class.class_variable_get(:@@apiKey)).to eql(apiKey)
    end

    it "should respond with 'https://sandboxadmin.citruspay.com/api/v1/txn/' for getApiUrl" do
      expect(citrus_sand_obj.getApiUrl).to eql('https://sandboxadmin.citruspay.com/api/v1/txn/')
    end


    it "should respond with encrypted data for getHmac" do
      expect(citrus_sand_obj.getHmac(data)).to eql(data_encr)
    end

     it "should raise ArgumentError" do
       expect{citrus_sand_obj.validate({})}.to raise_error Exception
     end
  end
  
end