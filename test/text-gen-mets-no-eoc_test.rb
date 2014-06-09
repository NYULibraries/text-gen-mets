require 'test_helper'
require 'open3'

class TestTextGenMets < MiniTest::Unit::TestCase

  COMMAND = 'ruby bin/text-gen-mets.rb'

  VALID_TEXT          = 'test/texts/valid'
  EMPTY_TEXT          = 'test/texts/empty-dir'
  BAD_M_D_COUNT_TEXT  = 'test/texts/bad-m-d-file-count'
  BAD_M_D_PREFIX_TEXT = 'test/texts/bad-m-d-prefix'
  CANONICAL_XML       = 'test/canonical/valid_mets.xml'

  def test_exit_status_with_valid_text
    o, e, s = Open3.capture3("#{COMMAND} 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'VERTICAL' 'LEFT_TO_RIGHT' 'RIGHT_TO_LEFT' #{VALID_TEXT}")
    assert(s.exitstatus == 1, "incorrect exit status")
  end

end
