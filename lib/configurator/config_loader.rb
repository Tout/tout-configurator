require 'yaml'
require 'erb'
require_relative '../configurator'

module ConfigLoader

  def self.load path
    puts "Loading: '#{path}'" unless Configurator.configuration.quiet_loading
    config = YAML.load(ERB.new(File.read(path)).result)[Configurator.configuration.rails_env]
    config.with_indifferent_access
  end

end