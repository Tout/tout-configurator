require 'spec_helper'
require_relative '../lib/configurator/config_helper'

describe ConfigHelper do

  before do
    ENV['some_environment_variable'] = 'some_value'
  end

  context "a required environment variable is present" do
    it "should load a specified required environment variable" do
      expect(ConfigHelper.required_env_variable('some_environment_variable')).to be_eql('some_value')
    end

    it "should load a specified required environment variable and convert it into a hash" do
      ENV['some_environment_variable'] = 'one:1,two:2,three:3,four:4'
      expect(ConfigHelper.required_env_variable_hash('some_environment_variable')).to be_eql({one:'1', two:'2', three:'3', four:'4'})
    end

    it "should load a specified required environment variable and convert it into a list" do
      ENV['some_environment_variable'] = 'one,two,three,four'
      expect(ConfigHelper.required_env_variable_list('some_environment_variable')).to be_eql(['one','two','three','four'])
    end
  end

  context "a optional environment variable is present" do
    it "should load a specified required environment variable" do
      expect(ConfigHelper.optional_env_variable('some_environment_variable')).to be_eql('some_value')
    end

    it "should load a specified required environment variable and convert it into a hash" do
      ENV['some_environment_variable'] = 'one:1,two:2,three:3,four:4'
      expect(ConfigHelper.optional_env_variable_hash('some_environment_variable')).to be_eql({one:'1', two:'2', three:'3', four:'4'})
    end

    it "should load a specified optional environment variable and convert it into a list" do
      ENV['some_environment_variable'] = 'one,two,three,four'
      expect(ConfigHelper.required_env_variable_list('some_environment_variable')).to be_eql(['one','two','three','four'])
    end
  end

  context "a required environment variable is not present" do
    it "should raise an error" do
      ENV.delete('some_environment_variable')
      expect {ConfigHelper.required_env_variable('some_environment_variable')}.to raise_error(Configurator::ConfigurationError)
    end

    it "should raise an error" do
      ENV.delete('some_environment_variable')
      expect {ConfigHelper.required_env_variable_hash('some_environment_variable')}.to raise_error(Configurator::ConfigurationError)
    end

    it "should raise an error" do
      ENV.delete('some_environment_variable')
      expect {ConfigHelper.required_env_variable_list('some_environment_variable')}.to raise_error(Configurator::ConfigurationError)
    end
  end 

  context "an optional environment variable is not present" do
    before do 
      allow_any_instance_of(IO).to receive(:puts).and_return nil
    end

    it "should not raise an error" do
      ENV.delete('some_environment_variable')
      expect(ConfigHelper.optional_env_variable('some_environment_variable')).to be_nil
    end

    it "should not raise an error" do
      ENV.delete('some_environment_variable')
      expect(ConfigHelper.optional_env_variable_hash('some_environment_variable')).to be_nil
    end

    it "should not raise an error" do
      ENV.delete('some_environment_variable')
      expect(ConfigHelper.optional_env_variable_list('some_environment_variable')).to be_nil
    end
  end

  context "a hash string environment variable that is improperly formatted" do
    before do
      ENV['some_environment_variable'] = '1,2,3,4'
    end

    it "should raise an error" do
      expect {ConfigHelper.optional_env_variable_hash('some_environment_variable')}.to raise_error(Configurator::ConfigFormatError)
      expect {ConfigHelper.required_env_variable_hash('some_environment_variable')}.to raise_error(Configurator::ConfigFormatError)
    end
  end
end