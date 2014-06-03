require_relative './config_loader'
require_relative './config_helper' 

class Configuration < HashWithIndifferentAccess
  attr_accessor :options
  include ConfigLoader

  REQUIRED_CONFIGURATION_OPTIONS = [
    :path,
  ]

  def self.set_configuration_constants
    class_obj = Configurator.configuration.class_to_set_config_constants_on
    @@all_configurations.each do |configuration|
      class_obj.const_set configuration.constant_name, configuration 
    end
  end

  def validate_config_hash hash 
    missing_values = REQUIRED_CONFIGURATION_OPTIONS - options.keys.map(&:to_sym)
    error_message = "A new configuration is being created without the proper initialization values: #{missing_values}"
    raise ConfigHelper::ConfigurationException, error_message unless missing_values.empty?
  end

  def initialize options={}
    self.options = options.with_indifferent_access
    validate_config_hash options
    self.class.all_configurations << self
    super(load(self.options[:path]))
  end

  def constant_name
    ext = options.has_key?(:file_ext) ? options[:file_ext] : '.yml'
    default_name = options[:path].split('/').last[0..-(ext.length + 1)].upcase + '_CONFIG'
    options.has_key?(:constant_name) ? options[:constant_name] : default_name
  end

  private  

    def self.all_configurations
      @@all_configurations ||= []
    end

end