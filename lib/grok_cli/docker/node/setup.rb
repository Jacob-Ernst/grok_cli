module GrokCLI::Docker::Node
  class Setup
    def initialize(config = GrokCLI::Docker::Configuration.new)
      @config = config
    end

    def execute
      system <<~CMD

        docker-machine create #{@config.machine_name} --driver virtualbox

        eval "$(docker-machine env #{@config.machine_name})"

        docker-compose build

        docker-compose run --rm web npm -g install webpack
        docker-compose run --rm web npm install

        cp .env.example .env

      CMD
    end
  end
end

module GrokCLI
  command 'docker:node' do |c|

    c.desc "Create a docker machine and setup the node application"

    c.command 'setup' do |c|
      c.action do
        GrokCLI::Docker::Node::Setup.new.execute
      end
    end
  end
end
