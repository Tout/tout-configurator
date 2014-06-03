require_relative "./configurator/version"
require_relative "./configurator/hash_ext" unless defined?(::Rails::Railtie)
require_relative "./configurator/configuration"
require_relative "./configurator/config_loader"
require_relative "./configurator/config_helper"

module Configurator

  
  class ConfiguratorConfig
    attr_accessor :config_selector, :quiet_loading, :class_to_set_config_constants_on, :test_environment, :search_path

    def initialize
      self.class_to_set_config_constants_on = Object
      self.config_selector = nil
      self.quiet_loading = true
      self.test_environment = false
      self.search_path = File.expand_path File.dirname(__FILE__)
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

  def self.load_and_set_configurations configuration_hashes
    load(configuration_hashes)
    set
  end

  def self.load configuration_hashes
    configuration_hashes = [configuration_hashes] if configuration_hashes.is_a?(Hash)
    configuration_hashes.each do |configuration_hash|
      Configuration.new(configuration_hash)
    end
  end

  def self.set
    Configuration.set_configuration_constants
  end

##################
  # Improper configuration error
  class ConfigurationError < RuntimeError; end
  # Improperly formatted configuration entry
  class ConfigFormatError < ConfigurationError; end
  # Improper configuration loading
  class ConfigLoadError < RuntimeError; end

  def self.logger
    @logger ||= (rails_logger || default_logger)
  end

  def self.rails_logger
    (defined?(Rails) && Rails.respond_to?(:logger) && Rails.logger) ||
    (defined?(RAILS_DEFAULT_LOGGER) && RAILS_DEFAULT_LOGGER.respond_to?(:debug) && RAILS_DEFAULT_LOGGER)
  end

  def self.default_logger
    require 'logger'
    l = Logger.new(STDOUT)
    l.level = Logger::INFO
    l
  end

  def self.logger=(logger)
    @logger = logger
  end

end


require_relative './configurator/railtie' if defined?(::Rails::Railtie)