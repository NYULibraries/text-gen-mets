
# assert that exactly one of each of the files are present
#  eoc
#  mods
#  marcxml
#  metsrights
#  ztarget_m.tif 
#  
#  open mets root 
#  open metsHdr
#    - using header template,
#    + search and replace template strings
#    + (be sure template includes R* identifier)
#  close metsHdr 
#  open dmdSec
#    
#  open amdSec
#    emit rightsMD
#    emit digiprovMD with calibration target
#    emit digiprovMD with eoc file
#   
def emit_xml_header
  puts <<'HERE_DOC_EOF' 
<?xml version="1.0" encoding="UTF-8"?> 
HERE_DOC_EOF
end


def emit_mets_open_tag(obj_id)
  puts <<-'HERE_DOC_EOF'
    <mets xmlns="http://www.loc.gov/METS/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/version191/mets.xsd" xmlns:xlink="http://www.w3.org/1999/xlink"
  HERE_DOC_EOF

  puts %{    xmlns:mods="http://www.loc.gov/mods/v3" OBJID="#{obj_id}">}
end


def emit_mets_hdr(create  = Time.now.utc.strftime("%FT%TZ"), 
                  lastmod = Time.now.utc.strftime("%FT%TZ"),
                  status  = "DRAFT")
  puts %{  <metsHdr CREATEDATE="#{create}" LASTMODDATE="#{lastmod}" RECORDSTATUS="#{status}">}
  puts <<-HERE_DOC_EOF
        <agent ROLE="DISSEMINATOR" TYPE="ORGANIZATION">
            <name>New York University Libraries</name>
        </agent>
        <agent ROLE="CREATOR" TYPE="INDIVIDUAL">
            <name>Joseph G. Pawletko</name>
        </agent>
    </metsHdr>
  HERE_DOC_EOF
end

def emit_dmd_marcxml(fname)
  puts %{    <dmdSec ID="dmd-00000001">}
  puts %{        <mdRef LOCTYPE="URL" MDTYPE="OTHER" OTHERMDTYPE="MARCXML" xlink:type="simple" xlink:href="#{fname}"/>}
  puts %{    </dmdSec>}
end

def emit_dmd_mods(fname)
  puts %{    <dmdSec ID="dmd-00000002">}
  puts %{        <mdRef LOCTYPE="URL" MDTYPE="OTHER" OTHERMDTYPE="MARCXML" xlink:type="simple" xlink:href="#{fname}"/>}
  puts %{    </dmdSec>}
end

def emit_amd_sec_open
  puts "    <amdSec>"
end

def emit_rights_md(fname)
  puts %{        <rightsMD ID="rmd-00000001">}
  puts %{           <mdRef LOCTYPE="URL" MDTYPE="METSRIGHTS" xlink:type="simple" xlink:href="#{fname}"/>}
  puts %{        </rightsMD>}
end

def emit_digiprov_target(fname)
  puts %{        <digiprovMD ID="dpmd-00000001">}
  puts %{              <mdRef LOCTYPE="URL" MDTYPE="OTHER" OTHERMDTYPE="CALIBRATION-TARGET-IMAGE" xlink:type="simple" xlink:href="#{fname}"/>}
  puts %{        </digiprovMD>}
end

def emit_digiprov_eoc(fname)
  puts %{        <digiprovMD ID="dpmd-00000002">}
  puts %{              <mdRef LOCTYPE="URL" MDTYPE="OTHER" OTHERMDTYPE="NYU-DLTS-EOC" xlink:type="simple" xlink:href="#{fname}"/>}
  puts %{        </digiprovMD>}
end

def emit_amd_sec_close
  puts "    </amdSec>"
end

def emit_file_sec_open
  puts "    <fileSec>"
end

def emit_file_sec_close
  puts "    </fileSec>"
end

def emit_file_grp_master_open
  puts %{        <fileGrp ID="fg-master" USE="MASTER" ADMID="dpmd-00000001 dmd-00000002">}
end

def emit_file_grp_dmaker_open
  puts %{        <fileGrp ID="fg-dmaker" USE="DMAKER">}
end

def emit_file(fname)
  match = /(.+)\.tif\z/.match(fname)
  raise "badly formed filename #{fname}" unless match
  id = match[1]
  puts %{            <file ID="f-#{id}" MIMETYPE="image/tiff">}
  puts %{                <FLocat LOCTYPE="URL" xlink:type="simple" xlink:href="#{fname}"/>}
  puts %{            </file>}
end

def emit_files(dir, pattern)
  file_list = Dir.glob(File.join(dir, pattern))
  file_list.sort!
  file_list.each do |f|
    next if /.+_ztarget_m.tif/.match(f)
    emit_file(File.basename(f))
  end
end

def emit_file_grp_close
  puts %{        </fileGrp>}
end


def get_md_file_inventory(dir)
  inventory = { mods:        '_mods.xml', 
    marcxml:     '_marcxml.xml',
    metsrights:  '_metsrights.xml',
    eoc:         '_eoc.csv',
    target:      '_ztarget_m.tif'
  }
  
  fhash  = {}
  errors = []
  inventory.each_pair do |k,f| 
    result = Dir.glob(File.join(dir, "*#{f}"))
    if result.length == 1
      fhash[k] = File.basename(result[0])
    else
      errors << "missing or too many files ending in #{f}\n"
    end
  end

  raise errors.to_s unless errors.empty?
  fhash
end


def print_usage
  $stderr.puts "#{$0} <object id> <source entity type> " +
    "<binding orientation> <scan order> <read order> " +
    "<path-to-text dir>"
end  

#------------------------------------------------------------------------------
# obj_id     = ARGV[0]
# se_type    = ARGV[1]
# binding    = ARGV[2]
# scan_order = ARGV[3]
# read_order = ARGV[4]
# src_dir    = ARGV[5]
#..............................................................................
def validate_and_extract_args(args_in)
  valid_se_types    = %w(SOURCE_ENTITY:TEXT)
  valid_bindings    = %w(VERTICAL HORIZONTAL)
  valid_scan_orders = %w(LEFT_TO_RIGHT RIGHT_TO_LEFT TOP_TO_BOTTOM BOTTOM_TO_TOP)
  valid_read_orders = %w(LEFT_TO_RIGHT RIGHT_TO_LEFT TOP_TO_BOTTOM BOTTOM_TO_TOP)
  
  args_out = {}
  errors   = []

  # argument count correct?
  unless args_in.length == 6
    $stderr.puts "incorrect number of arguments" 
    print_usage
    exit 1
  end

  # assume object identifier present b/c arg count correct
  args_out[:obj_id]  = args_in[0]

  # construct array to validate arguments with controlled vocabularies
  # idx:    index for value in args_in
  # key:    key   for          args_out hash
  # values: controlled vocabulary against which to validate
  # msg:    text for error message
  [{idx: 1, key: :se_type,    values: valid_se_types,    msg: "se type"},
   {idx: 2, key: :binding,    values: valid_bindings,    msg: "binding orientation"},
   {idx: 3, key: :scan_order, values: valid_scan_orders, msg: "scan order"},
   {idx: 4, key: :read_order, values: valid_read_orders, msg: "read order"}].each do |x|
    
    # extract the candidate value
    candidate = args_in[x[:idx]]
    
    if x[:values].include?(candidate)
      args_out[x[:key]] = candidate
    else
      errors << "incorrect #{x[:msg]} : #{candidate}"
    end
  end
  
  candidate = args_in[5]
  if Dir.exists?(candidate)
    args_out[:dir] = candidate
  else
    errors << "directory does not exist: #{candidate}"
  end

  
  # assemble file lists
  master_files = get_master_files(args_out[:dir])
  dmaker_files = get_dmaker_files(args_out[:dir])
  slot_list    = gen_slot_list(args_out[:dir])
  begin
    assert_master_dmaker_match!(master_files, dmaker_files)
  rescue Exception => e 
    errors << "master / dmaker file mismatch! #{e.message}"
  end
  
  args_out[:master_files] = master_files
  args_out[:dmaker_files] = dmaker_files
  args_out[:slot_list]    = slot_list
  
  unless errors.empty?
    estr = errors.join("\n")
    $stderr.puts "ERROR:\n #{estr}"
    print_usage
    exit 1
  end
  
  args_out
end


def get_master_files(dir)
end

def get_dmaker_files(dir)
end

def gen_slot_list(dir)
end

def assert_master_dmaker_match(m, d)
end

#------------------------------------------------------------------------------
validate_and_extract_args(ARGV)

obj_id     = ARGV[0]
se_type    = ARGV[1]
binding    = ARGV[2]
scan_order = ARGV[3]
read_order = ARGV[4]
src_dir    = ARGV[5]


puts "src_dir = #{src_dir}"

files = get_md_file_inventory(src_dir)
emit_xml_header
emit_mets_open_tag(obj_id)
emit_mets_hdr
emit_dmd_marcxml(files[:marcxml])
emit_dmd_mods(files[:mods])
emit_amd_sec_open
emit_rights_md(files[:metsrights])
emit_digiprov_target(files[:target])
emit_digiprov_eoc(files[:eoc])
emit_amd_sec_close
emit_file_sec_open
emit_file_grp_master_open
emit_files(src_dir, '*_m.tif')
emit_file_grp_close
emit_file_grp_dmaker_open
emit_files(src_dir, '*_d.tif')
emit_file_grp_close
emit_file_sec_close
#emit_struct_map_open(

exit 0
