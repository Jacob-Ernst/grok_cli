module GrokCLI::Docker
  class Run
    def initialize(config = Configuration.new)
      @config = config
    end

    def execute(command)
      Boot.new.execute
      UpdateEtcHosts.new.execute

      system <<~CMD

        eval "$(docker-machine env #{@config.machine_name})"

        docker-compose run --rm web #{command}

      CMD
    end
  end
end

module GrokCLI
  definition = Proc.new do |c|

    c.desc "Run a command within the container"

    c.arg :command, :multiple

    c.command 'run' do |c|
      c.action do |global_options,options,arguments|
        GrokCLI::Docker::Run.new.execute(arguments.join(' '))
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
