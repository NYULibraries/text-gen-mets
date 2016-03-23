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
  INDEX_REGEXP = /(_z?\d{2})\z/.freeze
  
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

  # this tests whether a filename may have an index, as in the case
  # of masters for oversized pages. These files end in _NN or _zNN,
  # e.g., partner_abc000123_n000456_z02_m.tif
  #       partner_abc000123_000456_02_m.tif
  def has_index?
    INDEX_REGEXP =~ rootname_minus_role
  end

  def rootname_minus_index_and_role
    rootname_minus_role.gsub(INDEX_REGEXP, '')
  end
end
