require 'spec_helper'

describe Viki::APIObject do
  def load_json
    json = ""
    File::open('spec/sample_response.json', 'r') do |f|
      json << f.readline()
      f.close()
    end
    json
  end

  let(:json) { load_json }
  let(:apio) { Viki::APIObject.new(json) }


  describe ".next" do
    it "should return another APIObject if next url exists" do
      next_object = apio.next
      next_object.should be_instance_of(Viki::APIObject)
    end

    it "should return nil if next url doesn't exist'"
  end

end
