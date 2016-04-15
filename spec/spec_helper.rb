$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'

require 'xmpp_simple'
require 'ox'
require 'helper/test_logger'
require 'helper/test_client'
require 'helper/test_handler'
require 'helper/test_socket'
require 'helper/test_node'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.warnings = true
end
