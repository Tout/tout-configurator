require_relative '../configurator'

module ConfigHelper

  def self.required_env_variable env_var
    ENV[env_var] || raise(Configurator::ConfigurationError, "ERROR: #{env_var} is required, but not specified.")
  end

  def self.optional_env_variable env_var
    warn_msg = "WARNING: #{env_var} does not have a value assigned to it."
    Configurator.logger.warn warn_msg unless ENV[env_var] || Configurator.configuration.test_environment
    ENV[env_var]
  end

  def self.required_env_variable_hash env_var
    ENV[env_var] || raise(Configurator::ConfigurationError, "ERROR: #{env_var} is required, but not specified.")
    begin
      convert_hash_string_to_hash(ENV[env_var])
    rescue Configurator::ConfigFormatError => e 
      raise Configurator::ConfigFormatError, "#{env_var} has been improperly formatted: #{e.message}\n#{e.backtrace.inspect}"
    end
  end

  def self.optional_env_variable_hash env_var
    unless ENV[env_var]
      warn_msg = "WARNING: #{env_var} does not have a value assigned to it."
      Configurator.logger.warn warn_msg unless Configurator.configuration.test_environment
      return nil
    end 
    begin
      convert_hash_string_to_hash(ENV[env_var])
    rescue Configurator::ConfigFormatError => e 
      raise Configurator::ConfigFormatError, "#{env_var} has been improperly formatted: #{e.message}"
    end
  end

  private

  def self.convert_hash_string_to_hash string 
    string.split(',').map {|p| p.split(':')}.inject({}) do |h, p| 
      err_msg = "#{string} is an improperly formatted hash string"
      raise Configurator::ConfigFormatError, err_msg unless valid_hash_pair? p
      h.merge({p[0].to_sym =>  p[1]})
    end
  end

  def self.valid_hash_pair? hash_pair
    !(hash_pair[0].empty? || hash_pair[1].nil? || hash_pair[1].empty?)
  end
end