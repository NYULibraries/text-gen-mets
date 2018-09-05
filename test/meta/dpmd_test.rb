require 'test_helper'
module Meta
  # test class for BookSlot
  class DpmdTest < MiniTest::Test

    ALL_FILES_DIR = 'test/fixtures/texts/valid'
    NO_EOC_DIR    = 'test/fixtures/texts/valid-no-eoc'
    NO_TARGET_DIR = 'test/fixtures/texts/valid-no-target'

    def test_dir
      sut = Meta::Dpmd.new(ALL_FILES_DIR)
      assert_equal(ALL_FILES_DIR, sut.dir)
    end

    def test_valid_directory
      sut = Meta::Dpmd.new(ALL_FILES_DIR)
      assert sut.valid?
    end

    def test_valid_no_eoc_directory
      sut = Meta::Dpmd.new(NO_EOC_DIR, no_eoc: true)
      assert sut.valid?
    end

    def test_valid_no_eoc_directory_no_option
      err = assert_raises(RuntimeError) { Meta::Dpmd.new(NO_EOC_DIR) }
      assert_match(/missing or too many files ending in _eoc.csv/, err.message)
    end

    def test_valid_no_target_directory
      sut = Meta::Dpmd.new(NO_TARGET_DIR, no_target: true)
      assert sut.valid?
    end

    def test_valid_no_target_directory_no_option
      err = assert_raises(RuntimeError) { Meta::Dpmd.new(NO_TARGET_DIR) }
      assert_match(/missing or too many files ending in _ztarget_m.tif/, err.message)
    end

    def test_with_no_eoc_option_with_eoc_file
      err = assert_raises(RuntimeError) { Meta::Dpmd.new(ALL_FILES_DIR, no_eoc: true) }
      assert_match(/EOC FILE DETECTED./, err.message)
    end

    def test_with_no_target_option_with_target_file
      err = assert_raises(RuntimeError) { Meta::Dpmd.new(ALL_FILES_DIR, no_target: true) }
      assert_match(/TARGET FILE DETECTED./, err.message)
    end

    def test_with_no_target_no_eoc_option_with_target_file_eoc_file
      err = assert_raises(RuntimeError) do 
        Meta::Dpmd.new(ALL_FILES_DIR, 
                       no_target: true,
                       no_eoc: true) 
      end
      assert_match(/EOC FILE DETECTED./,    err.message)
      assert_match(/TARGET FILE DETECTED./, err.message)
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

    def test_files_with_all_files
      sut = Meta::Dpmd.new(ALL_FILES_DIR)
      assert_match(/_ztarget_m.tif$/, sut.files[0].filename)
      assert_match(/_eoc.csv$/,       sut.files[1].filename)
      assert_equal(2, sut.files.length)
    end

    def test_files_with_no_target_file
      sut = Meta::Dpmd.new(NO_TARGET_DIR, no_target: true)
      assert_match(/_eoc.csv$/, sut.files[0].filename)
      assert_equal(1, sut.files.length)
    end

    def test_ids_with_no_eoc_file
      sut = Meta::Dpmd.new(NO_EOC_DIR, no_eoc: true)
      assert_match(/_ztarget_m.tif$/, sut.files[0].filename)
      assert_equal(1, sut.files.length)
    end

  end
end
