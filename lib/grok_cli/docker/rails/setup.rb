module GrokCLI::Docker::Rails
  class Setup
    def initialize(config = GrokCLI::Docker::Configuration.new)
      @config = config
    end

    def execute
      system <<~CMD

        docker-machine create #{@config.machine_name} --driver virtualbox

        eval "$(docker-machine env #{@config.machine_name})"

        docker-compose build
        docker-compose run --rm web bundle install --jobs 16
        docker-compose run --rm web bundle exec rake db:create db:migrate db:populate
        docker-compose run --rm web bundle exec rake db:create db:migrate db:populate RAILS_ENV=test

      CMD
    end
  end
end

module GrokCLI
  command 'docker:rails' do |c|

    c.desc "Create a docker machine and setup the rails application"

    c.command 'setup' do |c|
      c.action do
        GrokCLI::Docker::Rails::Setup.new.execute
      end
    end
  end
end
