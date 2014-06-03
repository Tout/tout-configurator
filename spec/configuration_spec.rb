require 'spec_helper'
require_relative '../lib/configurator/configuration'

describe Configuration do

  before do 
    Configuration.class_variable_set(:@@all_configurations, [])
    @configured_environment = Configurator.configuration.config_selector
    @example_hash = {@configured_environment => {entry_1: 1, 
                                                 entry_2: 2, 
                                                 entry_3: {entry_4: 4}
                                                },
                    }.with_indifferent_access
    allow_any_instance_of(ConfigLoader).to receive(:load).with('something_arbitrary.yml').and_return @example_hash[@configured_environment]
  end

  context "with a configuration hash that only has :path defined" do
    before do
      Object.remove_const(:SOMETHING_ARBITRARY_CONFIG) if Object.const_defined?(:SOMETHING_ARBITRARY_CONFIG)
      @config_hash = {path: 'something_arbitrary.yml'}      
    end

    it "should return the hash loaded from the provided path" do
      expect(configuration_equals_hash?(Configuration.new(@config_hash), @example_hash[@configured_environment])).to be(true)
    end

    it "should set SOMETHING_ARBITRARY_CONFIG" do
      Configuration.new(@config_hash)
      Configuration.set_configuration_constants
      expect(configuration_equals_hash?(SOMETHING_ARBITRARY_CONFIG, @example_hash[@configured_environment])).to be(true)
    end
  end

  context "with a configuration hash that has :constant_name defined" do
    before do
      Object.remove_const(:SOMETHING_ELSE) if defined?(SOMETHING_ELSE)
      @config_hash = {path: 'something_arbitrary.yml', constant_name: 'SOMETHING_ELSE'}      
    end

    it "should return the hash loaded from the provided path" do
      expect(configuration_equals_hash?(Configuration.new(@config_hash), @example_hash[@configured_environment])).to be(true)
    end

    it "should set SOMETHING_ARBITRARY_CONFIG" do
      Configuration.new(@config_hash)
      Configuration.set_configuration_constants
      expect(configuration_equals_hash?(SOMETHING_ELSE, @example_hash[@configured_environment])).to be(true)
    end
  end

  context "with a configuration hash that does not have a required config option defined" do
    before do
      @config_hash = {}
    end

    it "should raise a configuration error" do 
      expect {Configuration.new(@config_hash)}.to raise_error(Configurator::ConfigurationError)
    end
  end

  context "with a default or provided constant name that is already defined" do
    before do
      Object.send(:remove_const, :SOMETHING_ARBITRARY_CONFIG) if Object.const_defined?(:SOMETHING_ARBITRARY_CONFIG)
      @config_hash = {path: 'something_arbitrary.yml'}
      Object.const_set(:SOMETHING_ARBITRARY_CONFIG, 'already_set')
    end

    it "should raise a configuration error" do
      Configuration.new(@config_hash)
      expect {Configuration.set_configuration_constants}.to raise_error(Configurator::ConfigurationError)
    end
  end


end