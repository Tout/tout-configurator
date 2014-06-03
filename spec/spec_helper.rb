require 'bundler/setup'
Bundler.setup

require 'configurator'

Configurator.configure do |config|
  config.config_selector = 'development'
  config.quiet_loading = true
  config.test_environment = true
end

RSpec.configure do |config|
end

def configuration_equals_hash? configuration, hash
  hash.keys.each do |key|
    return false unless hash[key] == configuration[key]
  end
  hash.keys.sort == configuration.keys.sort
end