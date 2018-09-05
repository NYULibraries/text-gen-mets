require 'test_helper'
module Meta
  # test class for BookSlot
  class DmdTest < MiniTest::Test

    ALL_FILES_DIR  = 'test/fixtures/texts/valid'
    NO_MODS_DIR    = 'test/fixtures/texts/valid-no-mods'
    NO_MARCXML_DIR = 'test/fixtures/texts/valid-no-marcxml'

    def test_valid_directory
      sut = Meta::Dmd.new(ALL_FILES_DIR)
      assert sut.valid?
    end

    # test that the no_mods option works
    def test_valid_no_mods_directory
      sut = Meta::Dmd.new(NO_MODS_DIR, no_mods: true)
      assert sut.valid?
    end

    # test that a missing mods file is detected
    def test_valid_no_mods_directory_no_option
      err = assert_raises(RuntimeError) { Meta::Dmd.new(NO_MODS_DIR) }
      assert_match(/missing or too many files ending in _mods.xml/, err.message)
    end

    # test that an exception is raised if a mods file is found when no mods file is expected
    def test_with_no_mods_option_with_mods_file
      err = assert_raises(RuntimeError) { Meta::Dmd.new(ALL_FILES_DIR, no_mods: true) }
      assert_match(/MODS FILE DETECTED./, err.message)
    end

    # test that the no_marcxml option works
    def test_valid_no_marcxml_directory
      sut = Meta::Dmd.new(NO_MARCXML_DIR, no_marcxml: true)
      assert sut.valid?
    end

    # test that a missing marcxml file is detected
    def test_valid_no_marcxml_directory_no_option
      err = assert_raises(RuntimeError) { Meta::Dmd.new(NO_MARCXML_DIR) }
      assert_match(/missing or too many files ending in _marcxml.xml/, err.message)
    end

    # test that an exception is raised if a marcxml file is found when no marcxml file is expected
    def test_with_no_marcxml_option_with_marcxml_file
      err = assert_raises(RuntimeError) { Meta::Dmd.new(ALL_FILES_DIR, no_marcxml: true) }
      assert_match(/MARCXML FILE DETECTED./, err.message)
    end

    def test_with_no_mods_no_marcxml_option_with_mods_and_marcxml_files
      err = assert_raises(RuntimeError) do 
        Meta::Dmd.new(ALL_FILES_DIR, 
                       no_mods: true,
                       no_marcxml: true) 
      end
      assert_match(/MODS FILE DETECTED./,    err.message)
      assert_match(/MARCXML FILE DETECTED./, err.message)
    end

    def test_ids_with_all_files
      sut = Meta::Dmd.new(ALL_FILES_DIR)
      assert_equal('dmd-00000001 dmd-00000002', sut.ids)
    end

    def test_ids_with_no_mods_file
      sut = Meta::Dmd.new(NO_MODS_DIR, no_mods: true)
      assert_equal('dmd-00000001', sut.ids)
    end

    def test_ids_with_no_marcxml_file
      sut = Meta::Dmd.new(NO_MARCXML_DIR, no_marcxml: true)
      assert_equal('dmd-00000001', sut.ids)
    end

    def test_files_with_all_files
      sut = Meta::Dmd.new(ALL_FILES_DIR)
      assert_match(/_marcxml.xml$/, sut.files[0].filename)
      assert_match(/_mods.xml$/,    sut.files[1].filename)
      assert_equal(2, sut.files.length)
    end

    def test_files_with_no_mods_file
      sut = Meta::Dmd.new(NO_MODS_DIR, no_mods: true)
      assert_match(/_marcxml.xml$/, sut.files[0].filename)
      assert_equal(1, sut.files.length)
    end

    def test_ids_with_no_marcxml_file
      sut = Meta::Dmd.new(NO_MARCXML_DIR, no_marcxml: true)
      assert_match(/_mods.xml$/,    sut.files[0].filename)
      assert_equal(1, sut.files.length)
    end

  end
end
