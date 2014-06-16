require_relative '../configurator'

module ConfigHelper

  MESSAGES = {
    :format_hash => "%s is an improperly formatted hash string.",
    :required => "ERROR: %s is required, but not specified.",
    :optional => "WARNING: %s does not have a value assigned to it.",
    :format => "ERROR: %s has been improperly formatted - %s"
  }

  def self.required_env_variable env_var
    validate_required env_var
  end

  def self.optional_env_variable env_var
    warn_optional(env_var) 
    ENV[env_var]
  end

  def self.required_env_variable_hash env_var
    validate_required env_var
    convert_env_string_wrapper(env_var) { |string| convert_hash_string_to_hash(string) } 
  end

  def self.optional_env_variable_hash env_var
    warn_optional(env_var) 
    convert_env_string_wrapper(env_var) { |string| convert_hash_string_to_hash(string) } 
  end

  def self.required_env_variable_list env_var
    validate_required env_var
    convert_env_string_wrapper(env_var) { |string| convert_string_to_list(string) } 
  end


  def self.optional_env_variable_list env_var
    warn_optional(env_var) 
    convert_env_string_wrapper(env_var) { |string| convert_string_to_list(string) } 
  end

###########################s

  private

  def self.convert_string_to_list string
    string.split(',').compact if string
  end

  def self.convert_hash_string_to_hash string 
    string.split(',').map {|p| p.split(':')}.inject({}) do |h, p| 
      msg = MESSAGES[:format_hash] % [string]
      raise Configurator::ConfigFormatError, msg unless valid_hash_pair?(p)
      h.merge({p[0].to_sym =>  p[1]})
    end 
  end

  def self.valid_hash_pair? hash_pair
    !(hash_pair[0].empty? || hash_pair[1].nil? || hash_pair[1].empty?)
  end

  def self.validate_required env_var
    msg = MESSAGES[:required] % [env_var]
    ENV[env_var] || raise(Configurator::ConfigurationError, msg)
  end

  def self.warn_optional env_var
    unless (ENV[env_var] || Configurator.configuration.test_environment)
      warn_msg = MESSAGES[:optional] % env_var
      Configurator.logger.warn warn_msg
    end
  end

  def self.convert_env_string_wrapper env_var, &block
    return nil unless ENV[env_var]
    begin
      block.call(ENV[env_var])
    rescue Configurator::ConfigFormatError => e 
      msg = MESSAGES[:format] % [env_var, e.message]
      raise Configurator::ConfigFormatError, msg
    end
  end
end
