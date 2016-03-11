require 'test_helper'

class FilenameTest < MiniTest::Unit::TestCase

  attr_accessor :filename
  
  def setup
    @filename = Filename.new('a/b/c/foo_d.tif')
  end

  def test_path
    expected = 'a/b/c/foo_d.tif'
    assert_equal expected, filename.path
  end
  
    
  
end
