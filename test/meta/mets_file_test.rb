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
  end
end
