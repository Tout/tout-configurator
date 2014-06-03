require_relative './config_loader'

class Hash
  def with_indifferent_access
    HashWithIndifferentAccess.new_from_hash_copying_default(self)
  end

  alias_method :nested_under_indifferent_access, :with_indifferent_access unless method_defined?(:nested_under_indifferent_access)
end  

class Configuration < HashWithIndifferentAccess
  attr_accessor :options
  include ConfigLoader

  REQUIRED_CONFIGURATION_OPTIONS = [
    :file,
  ]

  def self.set_configuration_constants
    class_obj = Configurator.configuration.class_to_set_config_constants_on
    @@all_configurations.each do |configuration|
      err_msg = "#{configuration.constant_name} already exists, please provide an override constant_name in the loading hash"
      if class_obj.const_defined?(configuration.constant_name.to_sym)
        raise Configurator::ConfigurationError, err_msg
      else
        class_obj.const_set configuration.constant_name, configuration 
      end
    end
  end

  def validate_config_hash hash 
    missing_values = REQUIRED_CONFIGURATION_OPTIONS - options.keys.map(&:to_sym)
    unless missing_values.empty?
      error_message = "A new configuration is being created without the proper initialization values: #{missing_values}"
      Configurator.logger.error error_message unless Configurator.configuration.test_environment
      raise Configurator::ConfigurationError, error_message 
    end
  end

  def initialize options={}
    self.options = options.with_indifferent_access
    validate_config_hash options
    self.class.all_configurations << self
    path_to_load = (self.options[:path] || ConfigLoader.get_path(self.options[:file]))
    super(ConfigLoader.load(path_to_load))
  end

  def constant_name
    ext = options[:file] =~ /.*\.yml/ ? '.yml' : ''
    default_name = options[:file].split('/').last[0..-(ext.length + 1)].upcase + '_CONFIG'
    options.has_key?(:constant_name) ? options[:constant_name] : default_name
  end

  private  

    def self.all_configurations
      @@all_configurations ||= []
    end

end