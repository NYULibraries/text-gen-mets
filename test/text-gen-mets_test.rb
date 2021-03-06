require 'test_helper'
require 'open3'

class TestTextGenMets < MiniTest::Test

  COMMAND = 'ruby bin/text-gen-mets.rb'

  VALID_TEXT          = 'test/fixtures/texts/valid'
  EMPTY_TEXT          = 'test/fixtures/texts/empty-dir'
  BAD_M_D_COUNT_TEXT  = 'test/fixtures/texts/bad-m-d-file-count'
  BAD_M_D_PREFIX_TEXT = 'test/fixtures/texts/bad-m-d-prefix'
  CANONICAL_XML       = 'test/fixtures/canonical/valid_mets.xml'

  VALID_TEXT_DIFF_SCAN_READ    = 'test/fixtures/texts/valid-diff-scan-read-order'
  CANONICAL_XML_DIFF_SCAN_READ = 'test/fixtures/canonical/valid_mets-diff-scan-read-order.xml'

  VALID_TEXT_OVERSIZED    = 'test/fixtures/texts/oversized'
  CANONICAL_XML_OVERSIZED = 'test/fixtures/canonical/valid_mets-oversized.xml'

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

  def test_missing_md_files
    o, e, s = Open3.capture3("#{COMMAND} 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'HORIZONTAL' 'LEFT_TO_RIGHT' 'LEFT_TO_RIGHT' #{EMPTY_TEXT}")
    assert(s.exitstatus != 0)
    assert(o == '')
    assert_match(/missing or too many files ending in _mods\.xml/, e)
    assert_match(/missing or too many files ending in _marcxml\.xml/, e)
    assert_match(/missing or too many files ending in _metsrights\.xml/, e)
    assert_match(/missing or too many files ending in _eoc\.csv/, e)
    assert_match(/missing or too many files ending in _ztarget_m\.tif/, e)
  end

  def test_mismatched_master_dmaker_file_count
    o, e, s = Open3.capture3("#{COMMAND} 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'HORIZONTAL' 'LEFT_TO_RIGHT' 'LEFT_TO_RIGHT' #{BAD_M_D_COUNT_TEXT}")
    assert(s.exitstatus != 0)
    assert(o == '')
    assert_match(/invalid slot list/, e)
  end

  def test_mismatched_master_dmaker_file_prefixes
    o, e, s = Open3.capture3("#{COMMAND} 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'HORIZONTAL' 'LEFT_TO_RIGHT' 'LEFT_TO_RIGHT' #{BAD_M_D_PREFIX_TEXT}")
    assert(s.exitstatus != 0)
    assert(o == '')
    assert_match(/missing slot/, e)
  end

  def test_output_with_valid_text
    new_xml, e, s = Open3.capture3("#{COMMAND} 'nyu_aco000003' 'SOURCE_ENTITY:TEXT' 'VERTICAL' 'LEFT_TO_RIGHT' 'LEFT_TO_RIGHT' #{VALID_TEXT}")
    assert(s.exitstatus == 0, 'invalid exit status')
    old_xml, e, s = Open3.capture3("cat #{CANONICAL_XML}")
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

  def test_output_with_valid_text_with_different_scan_and_read_order
    new_xml, e, s = Open3.capture3("#{COMMAND} 'foo_aco000045' 'SOURCE_ENTITY:TEXT' 'VERTICAL' 'RIGHT_TO_LEFT' 'LEFT_TO_RIGHT' #{VALID_TEXT_DIFF_SCAN_READ}")
    assert(s.exitstatus == 0)
    old_xml, e, s = Open3.capture3("cat #{CANONICAL_XML_DIFF_SCAN_READ}")
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

  def test_output_with_valid_oversized_text
    new_xml, e, s = Open3.capture3("#{COMMAND} 'ifa_egypt000061' 'SOURCE_ENTITY:TEXT' 'VERTICAL' 'LEFT_TO_RIGHT' 'LEFT_TO_RIGHT' #{VALID_TEXT_OVERSIZED}")
    assert(s.exitstatus == 0, "incorrect exit status. Errors: #{e}")
    old_xml, e, s = Open3.capture3("cat #{CANONICAL_XML_OVERSIZED}")
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
