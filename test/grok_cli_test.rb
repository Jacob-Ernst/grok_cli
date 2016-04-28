require 'test_helper'

class GrokCLITest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::GrokCLI::VERSION
  end
end
