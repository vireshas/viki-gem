require 'spec_helper'

describe "Viki::Request" do
  describe "#auth_request" do

    it "should return an access token with the client_id and client_secret", :vcr do
      client_id = 'dc363b39f32aebbccbd5c80278e171d1e2a95a2582cef9ddad1c690a2cb4c652'
      client_secret = '4a1d38d8a1afbc12167e8471e0874c68f893d416f4aee623cb280f18fd0c072e'
      response = auth_request(client_id,client_secret)
      response.should == '798f57820d04a6e1368b82cf9f97f3c0ab376d7686723420eacc133efdd8b2ff'
    end

    it "should return an error when the client_secret or client_id is incorrect"
      #client_id = '12345'
      #client_secret = '67890'


    it "should return an error when the client_secret or client_id is empty"
  end
end
