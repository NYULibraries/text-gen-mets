#==============================================================================
# Time-stamp: <2013-11-03 01:13:16 jgp>
#------------------------------------------------------------------------------
supported case:
one to one

input:

directory containing:
= properly named text image files
= dmd files with ie_n_UUID_marcxml.xml
= rmd files with ie_n_UUID_metsrights.xml
= ie_n_boundaries.xml



emit header
emit dmdSec
emit amdSec
emit fileSec
  emit fileGrp USE = MASTER
  emit fileGrp USE = DMAKER
emit structMap

