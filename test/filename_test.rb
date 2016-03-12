require 'test_helper'

class FilenameTest < MiniTest::Unit::TestCase

  attr_accessor :filename, :filename_no_ext
  
  def setup
    @filename        = Filename.new('a/b/c/foo_d.tif')
    @filename_no_ext = Filename.new('d/e/f/bar_d')
  end

  def test_path
    expected = 'a/b/c/foo_d.tif'
    assert_equal expected, filename.path
  end
  
  def test_extension
    expected = '.tif'
    assert_equal expected, filename.extension
  end
    
  def test_extension_no_extension
    expected = ''
    assert_equal expected, filename_no_ext.extension
  end

  def test_rootname
    expected = 'foo_d'
    assert_equal expected, filename.rootname
  end

  def test_rootname_no_extension
    expected = 'bar_d'
    assert_equal expected, filename_no_ext.rootname
  end

  def test_name
    expected = 'foo_d.tif'
    assert_equal expected, filename.name
  end

  def test_name_no_extension
    expected = 'bar_d'
    assert_equal expected, filename_no_ext.name
  end

end
