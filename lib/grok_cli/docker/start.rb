module GrokCLI::Docker
  class Start
    def initialize(config = Configuration.new)
      @config = config
    end

    def execute
      Boot.new.execute
      UpdateEtcHosts.new.execute

      system <<~CMD

        eval "$(docker-machine env #{@config.machine_name})"

        docker-compose run --service-ports --rm web

      CMD
    end
  end
end

module GrokCLI
  definition = Proc.new do |c|

    c.desc "Start the application"
    c.long_desc <<-DESC
      Start the application

      Boots the docker machine and configures /etc/hosts if necessary,
      then starts the application
    DESC

    c.command 'start' do |c|
      c.action do
        GrokCLI::Docker::Start.new.execute
      end
    end
  end

  command 'docker' do |c|
    definition.call(c)
  end

  command 'docker:node' do |c|
    definition.call(c)
  end

  command 'docker:rails' do |c|
    definition.call(c)
  end
end
