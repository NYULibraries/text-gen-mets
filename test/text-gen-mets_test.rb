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

  def test_invalid_binding_orientation
    o, e, s = Open3.capture3("ruby bin/text-gen-mets.rb 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'INVALID' 'LEFT_TO_RIGHT' 'RIGHT_TO_LEFT' test/text")
    assert(s != 0)
    assert(o == '')
    assert_match(/incorrect binding orientation/, e, 'unexpected error message')
  end

  def test_invalid_scan_order
    o, e, s = Open3.capture3("ruby bin/text-gen-mets.rb 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'HORIZONTAL' 'INVALID' 'RIGHT_TO_LEFT' test/text")
    assert(s != 0)
    assert(o == '')
    assert_match(/incorrect scan order/, e, 'unexpected error message')
  end

  def test_invalid_read_order
    o, e, s = Open3.capture3("ruby bin/text-gen-mets.rb 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'HORIZONTAL' 'RIGHT_TO_LEFT' 'INVALID' test/text")
    assert(s != 0)
    assert(o == '')
    assert_match(/incorrect read order/, e, 'unexpected error message')
  end

  def test_missing_md_files
    o, e, s = Open3.capture3("ruby bin/text-gen-mets.rb 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'HORIZONTAL' 'RIGHT_TO_LEFT' 'LEFT_TO_RIGHT' test/empty-dir")
    assert(s != 0)
    assert(o == '')
    assert_match(/missing or too many files ending in _mods\.xml/, e)
    assert_match(/missing or too many files ending in _marcxml\.xml/, e)
    assert_match(/missing or too many files ending in _metsrights\.xml/, e)
    assert_match(/missing or too many files ending in _eoc\.csv/, e)
    assert_match(/missing or too many files ending in _ztarget_m\.tif/, e)
  end

end
