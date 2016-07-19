module GrokCLI::Docker::WordPress
  class Up
    def initialize(config = GrokCLI::Docker::Configuration.new)
      @config = config
    end

    def execute
      system <<~CMD

        docker-machine create #{@config.machine_name} --driver virtualbox

        eval "$(docker-machine env #{@config.machine_name})"

        docker-compose up
      CMD
    end
  end
end

module GrokCLI
  command 'docker:wordpress' do |c|

    c.desc 'Start the container services'

    c.command 'up' do |c|
      c.action do
        GrokCLI::Docker::WordPress::Up.new.execute
      end
    end
  end
end
