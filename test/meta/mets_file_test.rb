require 'test_helper'
module Meta
  # test class for BookSlot
  class METSFileTest < MiniTest::Test
    ARGS = {
      path:   'a/b/c/d.xml', 
      id:     'dpmd-00000001',
      mdtype: 'MARCXML'
    }
             
    def test_invalid_args_missing_path
      assert_raises(ArgumentError) { Meta::METSFile.new(ARGS.merge(path: nil)) }
      assert_raises(ArgumentError) { Meta::METSFile.new(ARGS.merge(path: '')) }
    end

    def test_invalid_args_missing_id
      assert_raises(ArgumentError) { Meta::METSFile.new(ARGS.merge(id: nil)) }
      assert_raises(ArgumentError) { Meta::METSFile.new(ARGS.merge(id: '')) }
    end

    def test_invalid_args_missing_mdtype
      assert_raises(ArgumentError) { Meta::METSFile.new(ARGS.merge(mdtype: nil)) }
      assert_raises(ArgumentError) { Meta::METSFile.new(ARGS.merge(mdtype: '')) }
    end

    def test_invalid_args_missing_othermdtype
      assert_raises(ArgumentError) { Meta::METSFile.new(ARGS.merge(mdtype: 'OTHER', othermdtype: nil)) }
      assert_raises(ArgumentError) { Meta::METSFile.new(ARGS.merge(mdtype: 'OTHER', othermdtype: '')) }
    end

    def test_path_method
      assert_equal(ARGS[:path], Meta::METSFile.new(ARGS).path)
    end

    def test_filename_method
      assert_equal('d.xml', Meta::METSFile.new(ARGS).filename)
    end

    def test_mdtype_method
      assert_equal('MARCXML', Meta::METSFile.new(ARGS).mdtype)
    end

    def test_othermdtype_method
      sut = Meta::METSFile.new(
        ARGS.merge(mdtype:      'OTHER', 
                   othermdtype: 'CALIBRATION-TARGET-IMAGE')
      )
      assert_equal('CALIBRATION-TARGET-IMAGE', sut.othermdtype)
    end

    def test_id_method
      assert_equal('dpmd-00000001', Meta::METSFile.new(ARGS).id)
    end
  end
end
