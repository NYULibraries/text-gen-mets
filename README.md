# text-gen-mets

#### NYU DLTS Text Entity METS file generator

## Current Status

### *UNDER DEVELOPMENT*
#### WARNING: this code may be merged with [nyudl-text](https://github.com/NYULibraries/nyudl-text) at some point in the future.

## Usage

#### preconditions:
     
- text in directory must adhere to DLTS Text naming conventions
  this is typically accomplished by using the ccg toolset to
  normalize the filenames in a text object.
  see ccg toolset : https://github.com/NYULibraries/ccg

- exactly one of each of the files must be present
  - eoc  : "Environment of Creation" data in a file with suffix ```_eoc.csv```
  - mods : [MODS](http://www.loc.gov/standards/mods/) descriptive metadata in a file with suffix ```_mods.xml```
  - marcxml : [MARCXML](http://www.loc.gov/standards/marcxml/) descriptive metadata in a file with suffix ```_marcxml.xml```
  - metsrights : [METSRIGHTS](http://www.loc.gov/standards/rights/METSRights.xsd) rights metadata file with suffix ```metsrights.xml```
  - target : digitization session calibration target file with suffix ```_ztarget_m.tif```

#### input:
- object identifier
- source entity type 
  - not hard coded because this tool could be used for ```ONE_TO_ONE_ENTITY:TEXT```s as well
- binding orientation
- scan order
- read order
- a directory that conforms to the preconditions

#### output:
- [METS](http://www.loc.gov/standards/mets/) XML for the specified DLTS TEXT object
- output is directed to ```$stdout```


#### Example:
```
ruby text-gen-mets.rb 'one-awesome-text' 'SOURCE_ENTITY:TEXT' 'VERTICAL' 'LEFT_TO_RIGHT' \
 'RIGHT_TO_LEFT' one-awesome-text/data | tee one-awesome-text/data/one-awesome-text_mets.xml
```
