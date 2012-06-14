require 'spec_helper'

describe "Viki" do
  describe "#auth_request" do

    it "should retrieve an access token when the Viki object is configured and initialized" do
      VCR.use_cassette "auth" do
        client_id = 'dc363b39f32aebbccbd5c80278e171d1e2a95a2582cef9ddad1c690a2cb4c652'
        client_secret = '4a1d38d8a1afbc12167e8471e0874c68f893d416f4aee623cb280f18fd0c072e'
        client = Viki::Client.new(client_id, client_secret)
        client.access_token.should == '798f57820d04a6e1368b82cf9f97f3c0ab376d7686723420eacc133efdd8b2ff'
      end
    end

    it "should return an error when the client_secret or client_id is incorrect" do
      VCR.use_cassette "auth_error" do
        client_id = '12345'
        client_secret = '54321'
        lambda { Viki::Client.new(client_id, client_secret) }.should raise_error(Viki::Error,
                                                                                 "Client authentication failed due to unknown client, no client authentication included, or unsupported authentication method.")
      end
    end
  end
end
