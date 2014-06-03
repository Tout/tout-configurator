require 'spec_helper'
require_relative '../lib/configurator/config_loader'

describe ConfigLoader do

  before do
    @configured_environment = Configurator.configuration.rails_env
    @example_hash = {@configured_environment => {entry_1: 1, 
                                                 entry_2: 2, 
                                                 entry_3: {entry_4: 4}
                                                },
                    }.with_indifferent_access
    allow_any_instance_of(File).to receive(:read).and_return YAML.dump(@example_hash)
    allow_any_instance_of(ERB).to receive(:result).and_return YAML.dump(@example_hash)
  end

  it "should load and return the yaml entry for the configured environment" do
    file = File.expand_path(File.join(File.dirname(__FILE__), '..', 'LICENSE.txt'))
    expect(ConfigLoader.load(file)).to be_eql(@example_hash[@configured_environment])
  end
end