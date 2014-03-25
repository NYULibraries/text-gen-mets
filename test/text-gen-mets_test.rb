require 'test/unit'
require 'open3'

class TestTextGenMets < Test::Unit::TestCase

  def test_exit_status_with_valid_invocation
    o, e, s = Open3.capture3("ruby bin/text-gen-mets.rb 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'VERTICAL' 'LEFT_TO_RIGHT' 'RIGHT_TO_LEFT' test/text")
    assert(s == 0, "incorrect exit status")
    assert_match(/<mets xmlns/, o, "no mets output detected")
  end

  def test_exit_status_with_incorrect_argument_count
    o, e, s = Open3.capture3("ruby bin/text-gen-mets.rb")
    assert(s != 0, "incorrect argument count")
    assert(o == '')
    assert_match(/incorrect number of arguments/, e, 'unexpected error message')
  end

  def test_exit_status_with_invalid_dir
    o, e, s = Open3.capture3("ruby bin/text-gen-mets.rb 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'VERTICAL' 'LEFT_TO_RIGHT' 'RIGHT_TO_LEFT' invalid-dir-path")
    assert(s != 0, "incorrect exit status")
    assert(o == '')
    assert_match(/directory does not exist/, e, 'unexpected error message')
  end

  def test_invalid_se_type
    o, e, s = Open3.capture3("ruby bin/text-gen-mets.rb 'nyu_aco000003' 'INVALID' 'VERTICAL' 'LEFT_TO_RIGHT' 'RIGHT_TO_LEFT' test/text")
    assert(s != 0)
    assert(o == '')
    assert_match(/incorrect se type/, e, 'unexpected error message')
  end

end
