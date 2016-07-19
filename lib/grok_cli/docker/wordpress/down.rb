module GrokCLI::Docker::WordPress
  class Down
    def initialize(config = GrokCLI::Docker::Configuration.new)
      @config = config
    end

    def execute
      system <<~CMD

        docker-machine create #{@config.machine_name} --driver virtualbox

        eval "$(docker-machine env #{@config.machine_name})"

        docker-compose down
      CMD
    end
  end
end

module GrokCLI
  command 'docker:wordpress' do |c|

    c.desc 'Stop and remove all docker containers'

    c.command 'down' do |c|
      c.action do
        GrokCLI::Docker::WordPress::Down.new.execute
      end
    end
  end
end
