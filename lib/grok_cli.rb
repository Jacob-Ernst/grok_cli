module GrokCLI
  require 'gli'
  include GLI::App
  extend self

  program_desc 'Command-Line Tools from Grok Interactive'
  subcommand_option_handling :normal
  arguments :strict

  Dir[File.dirname(__FILE__) + '/**/*.rb'].each { |file| require file }
end
