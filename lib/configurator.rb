require "configurator/version"
require "configurator/hash_ext"
require "configurator/configuration"

module Configurator

  class ConfiguratorConfig
    attr_accessor :rails_env, :quiet_loading, :class_to_set_config_constants_on

    def initialize
      self.class_to_set_config_constants_on = Object
      self.rails_env = nil
      self.quiet_loading = true
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||=  ConfiguratorConfig.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  def self.load configuration_hashes
    configuration_hashes.each do |configuration_hash|
      Configuration.new(configuration_hash)
    end
  end

  def self.set
    Configuration.set_configuration_constants
  end

end

