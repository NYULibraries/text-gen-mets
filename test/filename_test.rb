require 'test_helper'

# test class for Filename
class FilenameTest < MiniTest::Unit::TestCase

  attr_accessor :filename, :filename_no_ext, :filename_unknown_role,
                :dmaker, :dmaker2, :master_oversized, :dmaker_front_matter,
                :master_oversized_normalized, :dmaker_front_matter_oversized

  def setup
    @filename         = Filename.new('a/b/c/foo_m.tif')
    @filename_no_ext  = Filename.new('d/e/f/bar_d')
    @filename_unknown_role = Filename.new('x/y/z/baz')

    @dmaker_front_matter = Filename.new('nyu_aco000003_afr01_d.tif')
    @dmaker  = Filename.new('x/y/z/a_d.tif')
    @dmaker2 = Filename.new('d/e/f/b_d.tif')
    @dmaker_front_matter_oversized = Filename.new('nyu_aco000004_afr01_z01_d.tif')

    @master_oversized = Filename.new('d/e/f/q_01_m.tif')
    @master_oversized_normalized = Filename.new('d/e/f/q_z01_m.tif')
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

  def test_spaceship_operator
    expected = [dmaker, dmaker2]
    assert_equal expected, [dmaker2, dmaker].sort
  end

  def test_has_index?
    assert master_oversized.has_index?
  end

  def test_rootname_minus_index_and_role
    expected = 'q'
    assert_equal expected, master_oversized.rootname_minus_index_and_role
  end

  def test_rootname_minus_index_and_role_filename_normalized
    expected = 'q'
    assert_equal expected, master_oversized_normalized.rootname_minus_index_and_role
  end

  def test_rootname_minus_index_and_role_filename_has_no_index
    expected = 'a'
    assert_equal expected, dmaker.rootname_minus_index_and_role
  end

  def test_rootname_minus_role_front_matter
    expected = 'nyu_aco000003_afr01'
    assert_equal expected, dmaker_front_matter.rootname_minus_role
  end

  def test_rootname_minus_index_and_role_front_matter
    expected = 'nyu_aco000003_afr01'
    assert_equal expected, dmaker_front_matter.rootname_minus_index_and_role
  end

  def test_rootname_minus_index_and_role_front_matter_oversized
    expected = 'nyu_aco000004_afr01'
    assert_equal expected, dmaker_front_matter_oversized.rootname_minus_index_and_role
  end
end
