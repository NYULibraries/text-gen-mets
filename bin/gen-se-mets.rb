
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
  puts <<'HERE_DOGGY' 
<?xml version="1.0" encoding="UTF-8"?> 
HERE_DOGGY
end

# def emit_mets_open_tag(objid)
#   puts<<HERE_DOC_EOF
#     \<mets xmlns="http://www.loc.gov/METS/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
#     xsi:schemaLocation="http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/version191/mets.xsd" xmlns:xlink="http://www.w3.org/1999/xlink"
#   xmlns:mods="http://www.loc.gov/mods/v3" OBJID="#{objid}"\>
# HERE_DOC_EOF
# end

# def emit_mets_hdr(create  = Time.now.utc.strftime("%FT%TZ"), 
#                   lastmod = Time.now.utc.strftime("%FT%TZ"),
#                   status  = "DRAFT")
#   puts<<HERE_DOC_EOF
#   <metsHdr CREATEDATE="#{create}" LASTMODDATE="#{lastmod}" RECORDSTATUS="#{status}">
#         <agent ROLE="DISSEMINATOR" TYPE="ORGANIZATION">
#             <name>New York University Libraries</name>
#         </agent>
#         <agent ROLE="CREATOR" TYPE="INDIVIDUAL">
#             <name>Joseph G. Pawletko</name>
#         </agent>
#     </metsHdr>
# HERE_DOC_EOF
# end

def assert_file_inventory(dir)
  errors = []
  %w(_mods.xml _marcxml.xml _metsrights.xml _eoc.csv _ztarget_m.tif).each do |f|
    errors << "missing or too many files ending in #{f}\n" unless 
      Dir.glob(File.join(dir, "*#{f}")).length == 1
  end
  raise errors.to_s unless errors.empty?
end
  

#-------------------------------------------------------------------------------
src_dir = ARGV[0]
tgt_dir = ARGV[1] || src_dir

puts "src_dir = #{src_dir}"
puts "tgt_dir = #{tgt_dir}"

assert_file_inventory(src_dir)
emit_xml_header

exit
emit_mets_open_tag
emit_mets_hdr

exit 0

