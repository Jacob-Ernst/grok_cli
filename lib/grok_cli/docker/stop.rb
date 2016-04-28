module GrokCLI::Docker
  class Stop
    def initialize(config = Configuration.new)
      @config = config
    end

    def execute
      system <<~CMD

        docker-machine stop #{@config.machine_name}

      CMD
    end
  end
end

module GrokCLI
  definition = Proc.new do |c|

    c.desc "Stop the docker machine"

    c.command 'stop' do |c|
      c.action do
        GrokCLI::Docker::Stop.new.execute
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
