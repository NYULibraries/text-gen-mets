require 'test/unit'
class TestHello < Test::Unit::TestCase

  def test_exit_status
    `ruby bin/text-gen-mets.rb 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'VERTICAL' 'LEFT_TO_RIGHT' 'RIGHT_TO_LEFT' test/text > /dev/null`
    assert($? == 0, "incorrect exit status")
  end

end
