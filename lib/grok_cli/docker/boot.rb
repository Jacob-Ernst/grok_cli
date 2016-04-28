module GrokCLI::Docker
  class Boot
    def initialize(config = Configuration.new)
      @config = config
    end

    def execute
      system <<~CMD

        docker-machine ls | grep #{@config.machine_name} | grep -qi Running

        if [ $? -ne 0 ]
        then
          docker-machine start #{@config.machine_name}
          docker-machine regenerate-certs #{@config.machine_name}
        fi

      CMD
    end
  end
end

module GrokCLI

  definition = Proc.new do |c|
    c.desc "Boot the docker machine"

    c.command 'boot' do |c|
      c.action do
        GrokCLI::Docker::Boot.new.execute
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
