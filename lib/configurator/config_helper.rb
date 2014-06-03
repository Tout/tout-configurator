module ConfigHelper

  class ConfigurationException < Exception
  end

  def self.required_env_variable env_var
    ENV[env_var] || raise(ConfigurationException, "ERROR: #{env_var} is required, but not specified.")
  end

  def self.optional_env_variable env_var
    puts "WARNING: #{env_var} does not have a value assigned to it." unless ENV[env_var]
    ENV[env_var]
  end

  def self.required_env_variable_hash env_var
    ENV[env_var] || raise(ConfigurationException, "ERROR: #{env_var} is required, but not specified.")
    begin
      convert_hash_string_to_hash(ENV[env_var])
    rescue Exception => e 
      raise ConfigurationException, "#{env_var} has been improperly formatted: #{e.message}\n#{e.backtrace.inspect}"
    end
  end

  def self.optional_env_variable_hash env_var
    return puts "WARNING: #{env_var} does not have a value assigned to it." unless ENV[env_var]
    begin
      convert_hash_string_to_hash(ENV[env_var])
    rescue Exception => e 
      raise ConfigurationException, "#{env_var} has been improperly formatted: #{e.message}\n#{e.backtrace.inspect}"
    end
  end

  private

  def self.convert_hash_string_to_hash string 
    string.split(',').map {|p| p.split(':')}.inject({}) {|h, p| h.merge({p[0].to_sym =>  p[1]})}
  end
end