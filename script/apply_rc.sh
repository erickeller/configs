#!/bin/bash
# this script applies the configuration
# if some configuration file already exists, it makes a backup
#
source /etc/os-release
SCRIPTDIR=`cd $(dirname $0); pwd`
CONFIG_DIR=${SCRIPTDIR}/..

install_packages()
{
sudo apt-get update -q > /dev/null
sudo apt-get --yes --no-install-recommends install vim-nox git gitk git-gui tig tmux autojump zsh firefox vlc network-manager-openvpn-gnome network-manager-openvpn python3-pip htop scrot xautolock flameshot
sudo snap install slack --classic
}

install_i3()
{
KEYRING=$(curl --fail -sL https://i3wm.org/docs/repositories.html | grep apt-helper | cut -d' ' -f2- | tr -d '\r')
echo "install latest keyring: '${KEYRING}'"
eval ${KEYRING}
sudo dpkg -i ./keyring.deb
rm -f ./keyring.deb
echo "deb [arch=amd64] http://debian.sur5r.net/i3/ ${UBUNTU_CODENAME} universe" | sudo tee /etc/apt/sources.list.d/i3-wm.list
sudo apt-get update
sudo apt-get install i3 arandr feh acpi pavucontrol -y
# i3 notify when battery is low
sudo ln -sf ${SCRIPTDIR}/low_battery.sh /usr/local/bin/low_battery.sh
sudo sh -c "cat << EOF > /etc/cron.d/low_battery
*/5 * * * * ${USER} /usr/local/bin/low_battery.sh
EOF"
}

install_ohmyzsh()
{
echo "install ohmyzsh"
wget --no-check-certificate http://install.ohmyz.sh -O - | sh
cd ~/.oh-my-zsh/custom/plugins && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git && cd -
}

#echo "script dir: $SCRIPTDIR"
link_configuration()
{
# make sure the script is always running from the same directory
pushd $SCRIPTDIR > /dev/null
echo "CONFIG_DIR: ${CONFIG_DIR}"
DOT_CONFIGURATION=`find ${CONFIG_DIR} -type f \( -iname ".*rc" -o -iname ".*conf" -o -iname "*aliases" -o -iname ".*config" \)`
echo "DOT_CONFIGURATION: ${DOT_CONFIGURATION}"
for config in ${DOT_CONFIGURATION};
do
	CONFIG_NAME=`basename ${config}`
	echo "configuration: ${config}"
	echo "forcing linking configuration..."
	ln -sf ${config} ~/${CONFIG_NAME}
done
ln -sf ${CONFIG_DIR}/i3 ~/.i3
vim +PluginInstall +qall <<< "


"
popd > /dev/null
}

you_complete_me()
{
    # required for building clang for python3
    export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:/usr/include/python2.7/"
    sudo apt-get install -y build-essential cmake python3-dev
    sudo pip3 install jedi
    cd ~/.vim/bundle/YouCompleteMe
    python3 ./install.py --clang-completer
    cd -
}

pimp_gnome-terminal()
{
    sudo sh -c "sed -i 's#^Exec=gnome-terminal.*#Exec=gnome-terminal -x /bin/zsh#g' /usr/share/applications/gnome-terminal.desktop"
    # install hackfont
    sudo apt-get update && sudo apt-get install -y fonts-hack-ttf
    # get all configurable parameters `gsettings list-keys org.gnome.Terminal.Legacy.Profile:/`
    cat << EOF > /tmp/dconf-custom.dump
[legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
visible-name='hack'
audible-bell=false
use-custom-command=true
use-theme-transparency=false
scrollback-unlimited=true
use-system-font=false
custom-command='/bin/zsh'
font='Hack 12'

[legacy]
schema-version=uint32 3
EOF
    dconf load /org/gnome/terminal/ < /tmp/dconf-custom.dump
}

install_docker()
{
    sudo sh -c 'apt-get install -y -qq apt-transport-https ca-certificates curl >/dev/null'
    sudo sh -c 'sudo apt-get remove docker docker-engine docker.io containerd runc'
    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo sh -c "apt-get update -qq >/dev/null"
    sudo apt-get install -qq -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null
}

install_lxd()
{
    sudo apt-get purge lxd -y
    sudo apt-get install snapd -y
    sudo snap install lxd
}

install_packages
install_ohmyzsh
install_docker
install_lxd
pimp_gnome-terminal
install_i3
link_configuration
you_complete_me

exit 0

