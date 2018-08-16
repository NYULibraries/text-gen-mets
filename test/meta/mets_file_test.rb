require 'test_helper'
module Meta
  # test class for BookSlot
  class METSFileTest < MiniTest::Test
    ARGS = {
      path:   'a/b/c/d.xml', 
      id:     'dpmd-00000001',
      mdtype: 'OTHER'
    }
             
    def test_invalid_args_missing_path
      assert_raises(ArgumentError) { Meta::METSFile.new(ARGS.merge(path: nil)) }
    end
  end
end
