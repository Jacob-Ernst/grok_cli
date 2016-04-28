module GrokCLI::Docker::Rails
  class Rake
    def initialize(config = GrokCLI::Docker::Configuration.new)
      @config = config
    end

    def execute(rake_command = "")
      GrokCLI::Docker::Boot.new.execute
      GrokCLI::Docker::UpdateEtcHosts.new.execute

      system <<~CMD

        eval "$(docker-machine env #{@config.machine_name})"

        docker-compose run --rm web bundle exec rake #{rake_command}

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
      then runs `docker-compose run --rm web bundle exec rake ?`
    DESC

    c.arg :rake_command, [:optional, :multiple]

    c.command 'rake' do |c|
      c.action do |global_options,options,arguments|
        GrokCLI::Docker::Rails::Rake.new.execute(arguments.join(' '))
      end
    end
  end
end
