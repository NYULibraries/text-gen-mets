require 'test_helper'
module Meta
  # test class for BookSlot
  class DpmdTest < MiniTest::Test

    ALL_FILES_DIR = 'test/fixtures/texts/valid'
    NO_EOC_DIR    = 'test/fixtures/texts/valid-no-eoc'
    NO_TARGET_DIR = 'test/fixtures/texts/valid-no-target'

    def test_valid_directory
      sut = Meta::Dpmd.new(ALL_FILES_DIR)
      assert sut.valid?
    end

    def test_valid_no_eoc_directory
      sut = Meta::Dpmd.new(NO_EOC_DIR, no_eoc: true)
      assert sut.valid?
    end

    # should fail if missing EOC file if not passed :no_eoc option.
    def test_valid_no_eoc_directory_no_option
      sut = Meta::Dpmd.new(NO_EOC_DIR)
      refute sut.valid?
    end

    def test_valid_no_target_directory
      sut = Meta::Dpmd.new(NO_TARGET_DIR, no_target: true)
      assert sut.valid?
    end

    def test_valid_no_target_directory_no_option
      sut = Meta::Dpmd.new(NO_TARGET_DIR)
      refute sut.valid?
    end

    def test_with_no_eoc_option_with_eoc_file
      sut = Meta::Dpmd.new(ALL_FILES_DIR, no_eoc: true)
      refute sut.valid?
      assert_match(/EOC FILE DETECTED./, sut.errors.to_s)
    end

    def test_with_no_target_option_with_target_file
      sut = Meta::Dpmd.new(ALL_FILES_DIR, no_target: true)
      refute sut.valid?
      assert_match(/TARGET FILE DETECTED./, sut.errors.to_s)
    end

    def test_with_no_target_no_eoc_option_with_target_file_eoc_file
      sut = Meta::Dpmd.new(ALL_FILES_DIR, no_target: true, no_eoc: true)
      refute sut.valid?
      assert_match(/EOC FILE DETECTED./,    sut.errors.to_s)
      assert_match(/TARGET FILE DETECTED./, sut.errors.to_s)
    end

    def test_ids_with_all_files
      sut = Meta::Dpmd.new(ALL_FILES_DIR)
      assert_equal('dpmd-00000001 dpmd-00000002', sut.ids)
    end

    def test_ids_with_no_eoc_file
      sut = Meta::Dpmd.new(NO_EOC_DIR, no_eoc: true)
      assert_equal('dpmd-00000001', sut.ids)
    end

    def test_ids_with_no_target_file
      sut = Meta::Dpmd.new(NO_TARGET_DIR, no_target: true)
      assert_equal('dpmd-00000001', sut.ids)
    end

  end
end
