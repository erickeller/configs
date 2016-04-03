#!/bin/bash
# this script applies the configuration
# if some configuration file already exists, it makes a backup
#
SCRIPTDIR=`dirname $0`

install_packages()
{
sudo apt-get update
sudo apt-get -y install vim git gitk git-gui tmux autojump zsh
}

install_i3()
{
sudo sh -c "cat << EOF > /etc/apt/sources.list.d/i3-wm.list
deb http://debian.sur5r.net/i3/ trusty universe
EOF"
# we've returned to our user account
sudo apt-get update
sudo apt-get --allow-unauthenticated install sur5r-keyring
sudo apt-get update
sudo apt-get install i3 arandr feh acpi -y
# i3 notify when battery is low
sudo ln -sf ${SCRIPTDIR}/low_battery.sh /usr/local/bin/low_battery.sh
sudo sh -c "cat << EOF > /var/spool/cron/crontabs/low_battery
*/15 * * * * /usr/local/bin/low_battery.sh
EOF"
}

install_ohmyzsh()
{
echo "install ohmyzsh"
wget --no-check-certificate http://install.ohmyz.sh -O - | sh
cd ~/.oh-my-zsh/custom/plugins && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
}

#echo "script dir: $SCRIPTDIR"
link_configuration()
{
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
ln -sf ${CONFIG_DIR}/../i3 ~/.i3
vim +PluginInstall +qall <<< "


"
popd > /dev/null
}

you_complete_me()
{
    sudo apt-get install -y build-essential cmake python-dev
    cd ~/.vim/bundle/YouCompleteMe
    python ./install.py --clang-completer
    cd -
}

install_packages
install_ohmyzsh
#install_i3
link_configuration
you_complete_me

exit 0

