require 'test_helper'
require 'open3'

class TestTextGenMetsOriginalsJP2OnlyNoEocNoTarget < MiniTest::Test

  COMMAND = 'ruby bin/text-gen-mets-originals-jp2-only-no-eoc-no-target.rb'

  VALID_TEXT          = 'test/fixtures/texts/original-jp2-only-no-eoc-no-target'
  EMPTY_TEXT          = 'test/fixtures/texts/empty-dir'
  DMAKER_ONLY_TEXT    = 'test/fixtures/texts/original-jp2-only-no-eoc-no-target'
  CANONICAL_DMAKER_ONLY_XML = 'test/fixtures/canonical/valid_mets-original-jp2-only-no-eoc-no-target.xml'
  TOO_MANY_MASTERS    = 'test/fixtures/texts/dmaker-only-too-many-masters'

  def test_exit_status_with_valid_text
    o, _, s = Open3.capture3("#{COMMAND} 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'VERTICAL' 'LEFT_TO_RIGHT' 'LEFT_TO_RIGHT' #{VALID_TEXT}")
    assert(s.exitstatus == 0, "incorrect exit status")
    assert_match(/<mets xmlns/, o, "no mets output detected")
  end

  def test_with_incorrect_argument_count
    o, e, s = Open3.capture3("#{COMMAND}")
    assert(s.exitstatus != 0, "incorrect argument count")
    assert(o == '')
    assert_match(/incorrect number of arguments/, e, 'unexpected error message')
  end

  def test_with_invalid_dir
    o, e, s = Open3.capture3("#{COMMAND} 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'VERTICAL' 'LEFT_TO_RIGHT' 'LEFT_TO_RIGHT' invalid-dir-path")
    assert(s.exitstatus != 0, "incorrect exit status")
    assert(o == '')
    assert_match(/directory does not exist/, e, 'unexpected error message')
  end

  def test_invalid_se_type
    o, e, s = Open3.capture3("#{COMMAND} 'nyu_aco000003' 'INVALID' 'VERTICAL' 'LEFT_TO_RIGHT' 'LEFT_TO_RIGHT' #{VALID_TEXT}")
    assert(s.exitstatus != 0)
    assert(o == '')
    assert_match(/incorrect se type/, e, 'unexpected error message')
  end

  def test_invalid_binding_orientation
    o, e, s = Open3.capture3("#{COMMAND} 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'INVALID' 'LEFT_TO_RIGHT' 'LEFT_TO_RIGHT' #{VALID_TEXT}")
    assert(s.exitstatus != 0)
    assert(o == '')
    assert_match(/incorrect binding orientation/, e, 'unexpected error message')
  end

  def test_invalid_scan_order
    o, e, s = Open3.capture3("#{COMMAND} 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'HORIZONTAL' 'INVALID' 'RIGHT_TO_LEFT' #{VALID_TEXT}")
    assert(s.exitstatus != 0)
    assert(o == '')
    assert_match(/incorrect scan order/, e, 'unexpected error message')
  end

  def test_invalid_read_order
    o, e, s = Open3.capture3("#{COMMAND} 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'HORIZONTAL' 'RIGHT_TO_LEFT' 'INVALID' #{VALID_TEXT}")
    assert(s.exitstatus != 0)
    assert(o == '')
    assert_match(/incorrect read order/, e, 'unexpected error message')
  end

  def test_too_many_eoc_files
    o, e, s = Open3.capture3("#{COMMAND} 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'HORIZONTAL' 'RIGHT_TO_LEFT' 'RIGHT_TO_LEFT' #{TOO_MANY_MASTERS}")
    assert(s.exitstatus != 0, 'incorrect exit status')
    assert(o == '')
    assert_match(/EOC FILE DETECTED. THIS SCRIPT IS FOR DIRS W\/O EOC FILES/, e, 'unexpected error message')
  end

  def test_too_many_target_files
    o, e, s = Open3.capture3("#{COMMAND} 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'HORIZONTAL' 'RIGHT_TO_LEFT' 'RIGHT_TO_LEFT' #{TOO_MANY_MASTERS}")
    assert(s.exitstatus != 0, 'incorrect exit status')
    assert(o == '')
    assert_match(/TARGET FILE DETECTED. THIS SCRIPT IS FOR DIRS W\/O TARGET FILES/, e, 'unexpected error message')
  end

  def test_output_with_dmaker_only_text
    new_xml, e, s = Open3.capture3("#{COMMAND} 'aub_aco000093' 'SOURCE_ENTITY:TEXT' 'VERTICAL' 'LEFT_TO_RIGHT' 'LEFT_TO_RIGHT' #{DMAKER_ONLY_TEXT}")
    assert(s.exitstatus == 0, 'invalid exit status')
    old_xml, e, s = Open3.capture3("cat #{CANONICAL_DMAKER_ONLY_XML}")
    new_xml_a = new_xml.split("\n")
    old_xml_a = old_xml.split("\n")

    new_xml_a.each_index do |i|
      new = new_xml_a[i].strip
      old = old_xml_a[i].strip

      # replace dates
      if /metsHdr/.match(new)
        timestamp_regex = /[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z/
        new.gsub!(timestamp_regex,'')
        old.gsub!(timestamp_regex,'')
      end
      assert(new == old, "xml mismatch: #{new} #{old}")
    end
  end
end
