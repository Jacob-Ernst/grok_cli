module GrokCLI::Docker::Rails
  class Test
    def initialize(config = GrokCLI::Docker::Configuration.new)
      @config = config
    end

    def execute(test_options = "")
      GrokCLI::Docker::Boot.new.execute
      GrokCLI::Docker::UpdateEtcHosts.new.execute

      system <<~CMD

        eval "$(docker-machine env #{@config.machine_name})"

        docker-compose run --rm web bundle exec rake test #{test_options}

      CMD
    end
  end
end

module GrokCLI
  command 'docker:rails' do |c|

    c.desc "Run tests"
    c.long_desc <<-DESC
      Run tests

      Boots the docker machine and configures /etc/hosts if necessary,
      then runs `docker-compose run --rm web bundle exec rake test ?`
    DESC

    c.arg :test_options, [:optional, :multiple]

    c.command 'test' do |c|
      c.action do |global_options,options,arguments|
        GrokCLI::Docker::Rails::Test.new.execute(arguments.join(' '))
      end
    end
  end
end
