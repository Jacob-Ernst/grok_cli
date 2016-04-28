module GrokCLI::Docker::Rails
  class RSpec
    def initialize(config = GrokCLI::Docker::Configuration.new)
      @config = config
    end

    def execute(test_options = "")
      GrokCLI::Docker::Boot.new.execute
      GrokCLI::Docker::UpdateEtcHosts.new.execute

      system <<~CMD

        eval "$(docker-machine env #{@config.machine_name})"

        docker-compose run --rm web bundle exec rspec #{test_options}

      CMD
    end
  end
end

module GrokCLI
  command 'docker:rails' do |c|

    c.desc "Run rspec tests"
    c.long_desc <<-DESC
      Run rspec tests

      Boots the docker machine and configures /etc/hosts if necessary,
      then effectively runs `docker-compose run --rm web bundle exec rspec ?`
    DESC

    c.arg :rspec_options, [:optional, :multiple]

    c.command 'rspec' do |c|
      c.action do |global_options,options,arguments|
        GrokCLI::Docker::Rails::RSpec.new.execute(arguments.join(' '))
      end
    end

  end
end
