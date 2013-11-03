#!/bin/bash

if [[ $# -ne 3 ]]
then
    echo "incorrect usage: $0 <slot-label> <counter value for previous page> <role>"
    echo "           e.g.: $0 ifa_egypt000038_zbk08 244 m"
    echo "           e.g.: $0 ifa_egypt000038_afr01 0 m"  # 0 for first page, m for master
    echo "                 emits file element for ifa_egypt000038_zbk08_m.tif"
    echo " "
    echo "   this script is typically called by a parent script:"
    echo "           e.g.: let i=0; while read line; do ./gen-filegrp-m.sh $line $i ; let i=$i+1; done < slot-list.txt > master-fgrp.xml"
    exit 1
fi

# get slot number, counter value (file number), and role
slot=$1
let fnum=$2
role=$3

# increment BEFORE generating zero-padded label
let fnum=$fnum+1

# generate padded counter value
fnumpad=`printf '%08d' $fnum`

cat <<EOF
            <file ID="f-${slot}_${role}" MIMETYPE="image/tiff">
                <FLocat LOCTYPE="URL" xlink:type="simple" xlink:href="./${slot}_${role}.tif"/>
            </file>
EOF

exit 0


# cat <<EOF
#             <file ID="f-${fnumpad}${role}" MIMETYPE="image/tiff">
#                 <FLocat LOCTYPE="URL" xlink:type="simple" xlink:href="./${slot}_${role}.tif"/>
#             </file>
# EOF

