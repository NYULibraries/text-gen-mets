# deals with DLTS filename idiosyncracies
class Filename

  # messages:
  #  name                nyu_aco000123_n000987_m.tif
  #  extension           .tif
  #  rootname            nyu_aco000123_n000987_m
  #  rootname_minus_role nyu_aco000123_n000987
  #  path                ./foo/bar/baz/quux/nyu_aco000123_n000987_m.tif
  #  role                :master

  # TODO : probably an abstraction here: RoleIdentifier
  MASTER_ROLE_REGEXP = /(_m)\z/.freeze
  DMAKER_ROLE_REGEXP = /(_d)\z/.freeze

  def self.strip_role_string(rn)
    case rn
    when MASTER_ROLE_REGEXP then rn.sub(MASTER_ROLE_REGEXP, '')
    when DMAKER_ROLE_REGEXP then rn.sub(DMAKER_ROLE_REGEXP, '')
    else rn
    end
  end

  def self.role(rn)
    case rn
    when MASTER_ROLE_REGEXP then :master
    when DMAKER_ROLE_REGEXP then :dmaker
    else :unknown
    end
  end

  attr_reader :path, :extension, :rootname, :name, :role, :rootname_minus_role
  def initialize(path)
    @path      = path
    @extension = File.extname(path)
    @name      = File.basename(path)
    @rootname  = name.sub(/#{extension}\z/, '')
    @role      = self.class.role(rootname)
    @rootname_minus_role = self.class.strip_role_string(rootname)
  end

  def <=>(other)
    name <=> other.name
  end
end
