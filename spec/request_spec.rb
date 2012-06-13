require 'spec_helper'

describe "Viki" do
  describe "#auth_request" do
    let(:client_id) {'dc363b39f32aebbccbd5c80278e171d1e2a95a2582cef9ddad1c690a2cb4c652' }
    let(:client_secret) { '4a1d38d8a1afbc12167e8471e0874c68f893d416f4aee623cb280f18fd0c072e' }

    it "should retrieve an access token with a valid client_id and client_secret" do
      VCR.use_cassette "auth" do
        Viki.configure(client_id, client_secret)
        # response = auth_request(client_id,client_secret)
        Viki.access_token.should == '798f57820d04a6e1368b82cf9f97f3c0ab376d7686723420eacc133efdd8b2ff'
      end
    end

    it "should return an error when the client_secret or client_id is incorrect"


    it "should return an error when the client_secret or client_id is empty"
  end
end
