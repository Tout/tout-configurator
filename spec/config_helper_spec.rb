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
  end

  context "a optional environment variable is present" do
    it "should load a specified required environment variable" do
      expect(ConfigHelper.optional_env_variable('some_environment_variable')).to be_eql('some_value')
    end

    it "should load a specified required environment variable and convert it into a hash" do
      ENV['some_environment_variable'] = 'one:1,two:2,three:3,four:4'
      expect(ConfigHelper.optional_env_variable_hash('some_environment_variable')).to be_eql({one:'1', two:'2', three:'3', four:'4'})
    end
  end

  context "a required environment variable is not present" do
    it "should raise an error" do
      ENV.delete('some_environment_variable')
      expect {ConfigHelper.required_env_variable('some_environment_variable')}.to raise_error(ConfigHelper::ConfigurationException)
    end

    it "should raise an error" do
      ENV.delete('some_environment_variable')
      expect {ConfigHelper.required_env_variable_hash('some_environment_variable')}.to raise_error(ConfigHelper::ConfigurationException)
    end
  end 

  context "an optional environment variable is not present" do
    before do 
      allow_any_instance_of(IO).to receive(:puts).and_return nil
    end

    it "should raise an error" do
      ENV.delete('some_environment_variable')
      expect(ConfigHelper.optional_env_variable('some_environment_variable')).to be_nil
    end

    it "should raise an error" do
      ENV.delete('some_environment_variable')
      expect(ConfigHelper.optional_env_variable_hash('some_environment_variable')).to be_nil
    end
  end

end