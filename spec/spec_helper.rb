$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'viki'
require 'vcr'
require 'webmock/rspec'
require 'secrets.rb'
include WebMock::API
include WebMock::Matchers

Dir["#{File.dirname(__FILE__)}/support/vcr.rb"].each { |f| require f }

RSpec.configure do |config|
end
