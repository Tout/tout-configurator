require 'rails'
require 'configurator'

module Configurator
  class Railtie < ::Rails::Railtie

    config.before_configuration do 
      Configurator.configure do |config|
        config.config_selector = Rails.env
        config.quiet_loading = true
        config.test_environment = false
      end
      config.configurator = Configurator.configuration 
    end

    config.before_eager_load do 
      Configurator.configure do |config|
        search_path = File.directory?(Rails.root.join('config')) ? Rails.root.join('config') : Rails.root
        config.search_path = search_path
      end
    end
  end
end