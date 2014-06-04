require 'yaml'
require 'erb'
require 'find'
require_relative '../configurator'

module ConfigLoader

  def self.load path
    Configurator.logger.info "Loading: '#{path}'" unless Configurator.configuration.quiet_loading
    config = YAML.load(ERB.new(File.read(path)).result)[Configurator.configuration.config_selector]
    config.with_indifferent_access
  end

  def self.get_path file_name
    file = prepare_file_name file_name
    path = yaml_files_in_search_path.select {|f| f =~ /#{file}/ }
    dne_err_msg = "Error loading #{file_name}, file does not exist"
    multiple_file_err_msg = "Error loading #{file_name}, multiple paths found to file: #{path}"
    raise Configurator::ConfigLoadError, dne_err_msg if path.empty? && !Configurator.configuration.test_environment
    raise Configurator::ConfigLoadError, multiple_file_err_msg if path.count > 1 && !Configurator.configuration.test_environment
    path[0]
  end

  def self.prepare_file_name file_name
    file_name = file_name + '.yml' unless file_name =~ /.*\.yml/
    file_name = "\/" + file_name unless file_name =~ /\/.*\.yml/
    file_name
  end

  def self.yaml_files_in_search_path
    yaml_file_paths = []
    Find.find(Configurator.configuration.search_path.to_s) do |path|
      yaml_file_paths << path if path =~ /.*\.yml$/
    end
    yaml_file_paths
  end

end