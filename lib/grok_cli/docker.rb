require 'pathname'
require 'yaml'

module GrokCLI
  module Docker
    class Configuration
      attr_reader :machine_name, :hostname

      def initialize(config = YAML.load_file('.grok-cli.yml'))
        @machine_name = config.fetch('machine_name')
        @hostname = config.fetch('hostname')
      end
    end
  end
end
