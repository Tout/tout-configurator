# Configurator

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'configurator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install configurator

## Non-Rails Configuration

In order for this gem to be used in non-rails projects, it must be configured. For example:

      require 'configurator'
      Configurator.configure do |config|
        config.config_selector = Rails.env
        config.quiet_loading = false
        config.test_environment = false
      end  

This gem has several configuration options:

    config_selector: 
        This is how the configuration values are selected from the yaml, in rails this defaults to Rails.env 
    quiet_loading: 
        This toggles on off loading messages, defaults to false in Rails
    class_to_set_config_constants_on: 
        This is the object that the global constants are stored on and defaults to Object for all projects
    test_environment: 
        Used to turn off some warning and error messages during rspec tests, defaults to false for all projects
    search_path: 
        The path to the directory containing all of the configuration yaml files, defaults to config for Rails and must be set in other projects


## Loading Configurations from YAMLs embedded with ERB

To use this gem, create a list (also works with single hash) of hashes containing the loading options listed below and call the command:

    Configurator.load_and_set(list_of_loading_hashes)

This will load the values in the yamls specified in the loading hashes and set them to constants which can be accessed later.

## Loading Options

Each of the option hashes can have the following loading options specified:

    file: Required - 
        the name of the .yml file (with or without the .yml extension)
    path: Optional - 
        the absolute path of the file for when it does live in the specified search_path
    constant_name: Optional - 
        this constant name (must follow the standard ruby convention for constants) will override the default constant name which is generated from the extension-free file name upcased and appended with '_CONFIG'


## Within YAML Config Files

This gem also gives you some options in terms of loading up environment variables within ERB embedded YAML files. They give you access to the following 4 methods:

    Configurator::ConfigHelper.required_env_variable("ENV_VAR_NAME")
        - Raises a ConfigError if ENV["ENV_VAR_NAME"] if not present
    Configurator::ConfigHelper.optional_env_variable("ENV_VAR_NAME")
        - Does not raise a ConfigError if ENV["ENV_VAR_NAME"] if not present
    Configurator::ConfigHelper.required_env_variable_hash("ENV_VAR_NAME")
        - Raises a ConfigError if ENV["ENV_VAR_NAME"] if not present
        - Converts a string formatted like: "attr_name_1:val_1,attr_name_2:val_2,attr_name_3:val_3"
            into a hash. Allows you to easily add hashes to env variables on the command line
        - Raises an error if the string is improperly formatted
    Configurator::ConfigHelper.optional_env_variable_hash("ENV_VAR_NAME")
        - Does not raise a ConfigError if ENV["ENV_VAR_NAME"] if not present
        - Converts a string formatted like: "attr_name_1:val_1,attr_name_2:val_2,attr_name_3:val_3"
            into a hash. Allows you to easily add hashes to env variables on the command line
        - Raises an error if the string is improperly formatted



## Contributing

1. Fork it ( https://github.com/[my-github-username]/configurator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
