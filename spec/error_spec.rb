require 'spec_helper'

describe Viki::Error do
  before { @error = Viki::Error.new(404, "Resource 'blah' not found.")}

  subject { @error }

  it { should respond_to(:status) }
  it { should respond_to(:message) }

  it { subject.to_s.should == "404: Resource 'blah' not found."}
end
