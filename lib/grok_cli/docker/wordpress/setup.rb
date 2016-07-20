module GrokCLI::Docker::WordPress
  class Setup
    def initialize(config = GrokCLI::Docker::Configuration.new)
      @config = config
    end

    def execute
      system <<~CMD
        docker-machine create #{@config.machine_name} --driver virtualbox

        eval "$(docker-machine env #{@config.machine_name})"

        docker-compose run --rm web sleep 1
      CMD
    end
  end
end

module GrokCLI
  command 'docker:wordpress' do |c|

    c.desc 'Setup the WordPress environment'

    c.command 'setup' do |c|
      c.action do |global_options, options, arguments|
        GrokCLI::Docker::WordPress::Setup.new.execute
      end
    end
  end
end
