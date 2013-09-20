#!/bin/bash
# this script applies the configuration
# if some configuration file already exists, it makes a backup
#

SCRIPTDIR=`dirname $0`
#echo "script dir: $SCRIPTDIR"
# make sure the script is always running from the same directory
pushd $SCRIPTDIR > /dev/null

CONFIG_DIR=`dirname $(pwd)`
echo "CONFIG_DIR: ${CONFIG_DIR}"
DOT_CONFIGURATION=`find ${CONFIG_DIR} -type f \( -iname ".*rc" -o -iname ".*conf" -o -iname "*aliases" -o -iname ".*config" \)`
echo "DOT_CONFIGURATION: ${DOT_CONFIGURATION}"
for config in ${DOT_CONFIGURATION};
do
	CONFIG_NAME=`basename ${config}`
	echo "configuration: ${config}"
	if [ -f ${HOME}/${CONFIG_NAME} ] 
	then
		echo "configuration already exists..."
	else
		echo "linking configuration..."
		ln -sf ${config} ~/${CONFIG_NAME}
	fi
done

popd > /dev/null
exit 0

