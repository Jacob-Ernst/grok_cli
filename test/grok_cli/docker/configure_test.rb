require 'test_helper'

class GrokCLI::Docker::ConfigureTest < Minitest::Test

  def teardown
    File.delete('.grok-cli.yml') if File.exists?('.grok-cli.yml')
  end

  def test_executing_creates_a_yml_file
    subject = GrokCLI::Docker::Configure.new

    subject.execute('test-machine', 'test.dev')

    assert_equal(YAML.load_file('.grok-cli.yml')['machine_name'], 'test-machine')
    assert_equal(YAML.load_file('.grok-cli.yml')['hostname'], 'test.dev')
  end
end
