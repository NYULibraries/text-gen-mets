require 'test_helper'

class FilenameTest < MiniTest::Unit::TestCase

  attr_accessor :filename, :filename_no_ext, :filename_unknown_role
  
  def setup
    @filename         = Filename.new('a/b/c/foo_m.tif')
    @filename_no_ext  = Filename.new('d/e/f/bar_d')
    @filename_unknown_role = Filename.new('x/y/z/baz')
  end

  def test_class_method_role_detect_master
    string   = 'baz_m'
    expected = :master

    assert_equal expected, Filename.role(string)
  end

  def test_class_method_role_detect_dmaker
    string   = 'baz_d'
    expected = :dmaker

    assert_equal expected, Filename.role(string)
  end

  def test_class_method_role_detect_unknown
    string   = 'baz_xyz'
    expected = :unknown

    assert_equal expected, Filename.role(string)
  end

  def test_path
    expected = 'a/b/c/foo_m.tif'
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
    expected = 'foo_m'
    assert_equal expected, filename.rootname
  end

  def test_rootname_no_extension
    expected = 'bar_d'
    assert_equal expected, filename_no_ext.rootname
  end

  def test_name
    expected = 'foo_m.tif'
    assert_equal expected, filename.name
  end

  def test_name_no_extension
    expected = 'bar_d'
    assert_equal expected, filename_no_ext.name
  end

  def test_role_master
    expected = :master
    assert_equal expected, filename.role
  end

  def test_role_dmaker
    expected = :dmaker
    assert_equal expected, filename_no_ext.role
  end

  def test_role_unknown
    expected = :unknown
    assert_equal expected, filename_unknown_role.role
  end

  def test_rootname_minus_role
    expected = 'foo'
    assert_equal expected, filename.rootname_minus_role
  end

  def test_rootname_minus_role_no_extension
    expected = 'bar'
    assert_equal expected, filename_no_ext.rootname_minus_role
  end
end
