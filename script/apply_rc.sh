#!/bin/bash
# this script applies the configuration
# if some configuration file already exists, it makes a backup
#

SCRIPTDIR=`dirname $0`
#echo "script dir: $SCRIPTDIR"
# make sure the script is always running from the same directory
pushd $SCRIPTDIR > /dev/null

DOT_CONFIGURATION=`find ../ -iname ".*rc"`
echo "DOT_CONFIGURATION: ${DOT_CONFIGURATION}"
for config in ${DOT_CONFIGURATION};
do
	echo "configuration: ${config}"
done

popd > /dev/null
exit 0

