#!/bin/bash

readonly CURRENT_VERSION="1.0"
readonly THIS_NAME=$(basename "$0")

#===========================
# customize yours tags here
readonly MARK_CHAR="\033[1;32m▶\033[0m"
readonly SCRIPT_INDICATOR="\033[0m[\033[1;33mSCRIPT\033[0m]"
readonly OPTION_STARTED="...\033[2m"
readonly OPTION_FINISHED="[\033[1;32mFINISHED\033[0m]"
#===========================

declare -a OPTIONS
declare LAST_MSG

function init()
{
	for i in {0..8}; do
		OPTIONS[$i]=" "
	done

	# check for auto update
	update_script 1
}

function print_menu()
{
	MESSAGE=(
	"\n"
	"*****************************************************\n"
	"             Hello in Linux Easy Manager             \n"
	"*****************************************************\n"
	"\n\033[2m"
	"Beware, some of the options requires you to be the root user,\n" 
	"and some would be installed just for user who run this script.\n"
	"You can simply change the user to root by typing \"sudo\"\n"
	"along with running the script. Or what is more convenient,\n"
	"if you want to chose user for who install application,\n"
	"type \"sudo -u \033[3muser\033[2m ./"$THIS_NAME"\",\n"
	"\033[7mYou are logged in as $(whoami).\033[0m\n"
	"\n"
	"Select yours options:\n"
	"1. [${OPTIONS[0]}] --- Sellect all options\n"
	"2. [${OPTIONS[1]}] --- Add sources to /etc/apt/sources.list (overrides current)\n"
	"3. [${OPTIONS[2]}] --* Add keyserver and fingerprint for apt-get update\n"
	"4. [${OPTIONS[3]}] --- Use apt-get (clean,update,upgrade,dist-upgrade,autoremove)\n"
	"5. [${OPTIONS[4]}] --- Use apt-get and install started packages\n"
	"6. [${OPTIONS[5]}] --- Install development tools (Qt, i386 arch)\n"
	"7. [${OPTIONS[6]}] --+ Configure VIM editor (vimrc, plugins, clewn compiler, custom color)\n"
	"8. [${OPTIONS[7]}] --- Install Spotify (add required source list, update apt)\n"
	"9. [${OPTIONS[8]}] --* Install extra hacking tools (lazy script)\n"
	"\n"
	"* \033[2m- Means that you need to be the root user to make that option work.\033[0m\n"
	"+ \033[2m- Install only for current user.\033[0m\n"
	"\n"
	"99. RUN\n"
	"U or u. UPDATE\n"
	"Q or q. QUIT\n"
	)

	clear
	echo -e "${MESSAGE[@]}"
	if [ ! -z "$LAST_MSG" ]; then
		echo -e "$LAST_MSG\n"
	fi

	LAST_MSG=""
}

function update_script()
{
	local CHECK_ONLY=${1}

	local TEMP_FILE=$(mktemp "/tmp/$THIS_NAME_version".XXXXX)
	wget -O "$TEMP_FILE" https://raw.githubusercontent.com/Lechnio/LinuxEasyManager/master/VERSION > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		LAST_MSG="Error when downloading file."
		
		# rest output for check only case
		[ $CHECK_ONLY -eq 1 ] && LAST_MSG=""

		return 1
	fi

	local UPSTREAM_VERSION=$(cat $TEMP_FILE)

	LAST_MSG="Current script version is '$CURRENT_VERSION'.\n"

	local C_VER_R="${CURRENT_VERSION//.}"
	local U_VER_R="${UPSTREAM_VERSION//.}"

	if [ $U_VER_R -gt $C_VER_R ]; then
		if [ $CHECK_ONLY -eq 1 ]; then
			LAST_MSG="HEY! New tool update is available, run `--update` to get the latest version :)"
			rm "$TEMP_FILE"
		else
			mv "$TEMP_FILE" "$THIS_NAME"
			LAST_MSG+="Script updated to version '$UPSTREAM_VERSION'."
		fi
	else
		rm "$TEMP_FILE"
		LAST_MSG+="Script is up to date."

		[ $CHECK_ONLY -eq 1 ] && LAST_MSG=""
	fi
}

function options_loop()
{
	# menu printing loop
	while true; do

		print_menu

		read -p ">" OPTION_NUMBER

		if [[ "$OPTION_NUMBER" =~ ^[q|Q]$ ]]; then
			exit 0

		elif [[ "$OPTION_NUMBER" =~ ^[u|U]$ ]]; then
			update_script

		elif [[ ! "$OPTION_NUMBER" =~ ^[0-9]+$ ]]; then
			LAST_MSG="Invalid option! ('$OPTION_NUMBER')"

		elif [[ $OPTION_NUMBER -le ${#OPTIONS[*]} && $OPTION_NUMBER -gt 1 ]]; then
			if [ "${OPTIONS[$OPTION_NUMBER-1]}" == " " ]; then
				OPTIONS[$OPTION_NUMBER-1]="$MARK_CHAR"
			else
				OPTIONS[$OPTION_NUMBER-1]=" "
				OPTIONS[0]=" "
		fi

		elif [ "$OPTION_NUMBER" == "1" ]; then
			if [ "${OPTIONS[0]}" == " " ]; then
				OPTIONS=("${OPTIONS[@]/*/"$MARK_CHAR"}")
			else
				OPTIONS=("${OPTIONS[@]/*/" "}")
			fi

		elif [ "$OPTION_NUMBER" == "99" ]; then
			break

		elif [[ "$OPTION_NUMBER" == "2111446" ]]; then
			echo -e "\n\033[96mYOU HAVE REALLY NOTHING TO DO..."
			echo -e "IS THERE ANYTHING INTERESTING IN THAT SCRIPT?\033[0m"

			local HIDDEN_MSG="\xba\xb0\xc5\xb9\x92\xb0\x8f\xc2\xbb\xb2\xb4\x94\xb6\xb0\xc8\x94\xac\x9c\x98"
			local FUN=$($(echo -e "\x77\x68\x6f\x61\x6d\x69"))

			local lets=0
			local fun=0
			while [ $lets -lt ${#HIDDEN_MSG} ]; do
				printf "\\$(printf '%o' "$(($(printf '%d' "'$(echo -e "${HIDDEN_MSG:lets:4}")")-$(printf '%d' "'$(echo -e "${FUN:fun:1}")")))")"

				((lets=lets + 4))
				((fun+=1))
				((fun=fun%${#FUN}))
			done

			read

		else
			LAST_MSG="Incorrect number range! ('$OPTION_NUMBER')"
		fi

	done
}

#
# START SCRIPT
#

# update sources list
if [ "${OPTIONS[1]}" == "$MARK_CHAR" ]; then
	echo -e "$SCRIPT_INDICATOR Updating sources list$OPTION_STARTED\n";

	SOURCES_LIST=(
	"deb http://http.kali.org/kali kali-rolling main contrib non-free\n"
	"# For source package access, uncomment the following line\n"
	"# deb-src http://http.kali.org/kali kali-rolling main contrib non-free\n"
	"\n"
	"# For tlp\n"
	"deb http://repo.linrunner.de/debian wheezy main"
	)
	sudo echo -e "${SOURCES_LIST[@]}" > /etc/apt/sources.list
	echo -e "$SCRIPT_INDICATOR Sources list updated:\n\033[0;36m"${SOURCES_LIST[@]}"\033[0m\n"

	echo -e "$SCRIPT_INDICATOR Updating sources list $OPTION_FINISHED\n";
fi

# now add the KEY and fingerprint to use update
# NOTE THIS ->>> You have to be root to have privilidge run an export
if [ "${OPTIONS[2]}" == "$MARK_CHAR" ]; then
	echo -e "$SCRIPT_INDICATOR Updating KEYs and fingerprints$OPTION_STARTED\n";

	if [ "$(whoami)" == "root" ]; then

		gpg --keyserver hkp://keys.gnupg.net --recv-key 7D8D0BF6
		gpg --fingerprint 7D8D0BF6
		gpg -a --export 7D8D0BF6 | apt-key add -

		# key for tlp
		gpg --keyserver hkp://keys.gnupg.net --recv-key 641EED65CD4E8809
		gpg --fingerprint 641EED65CD4E8809
		gpg -a --export 641EED65CD4E8809 | apt-key add -
	else
		echo -e "$SCRIPT_INDICATOR \033[1;31mYou are not root user!\033[0m"
		echo -e "$SCRIPT_INDICATOR \033[1;31mSkipping$OPTION_STARTED\033[0m\n"
	fi

	echo -e "$SCRIPT_INDICATOR Updating KEYs and fingerprints $OPTION_FINISHED\n";
fi

# now run apt-get update and so one
if [ "${OPTIONS[3]}" == "$MARK_CHAR" ]; then
	echo -e "$SCRIPT_INDICATOR Starting apt-get$OPTION_STARTED\n";

	sudo apt-get clean
	sudo apt-get update
	sudo apt-get upgrade -y
	sudo apt-get dist-upgrade -y
	sudo apt autoremove -y

	echo -e "$SCRIPT_INDICATOR Starting apt-get $OPTION_FINISHED\n";
fi

# things to install by apt-get
if [ "${OPTIONS[4]}" == "$MARK_CHAR" ]; then
	echo -e "$SCRIPT_INDICATOR Installing custom apps$OPTION_STARTED\n";

	sudo apt-get update

	LIST_TO_INSTALL=(
	"chromium"
	"tree"
	"htop"
	"lshw"
	"hwinfo"
	"acpi"
	"gimp"
	"libreoffice"
	"tlp"
	"tlp-rdw"
	"alsamixergui"
	"pavucontrol"
	"thunderbird"
	"transmission"
	"proxychains"
	"tor"
	"unp"
	)

	sudo apt-get install -y "${LIST_TO_INSTALL[@]}"
	sudo tlp start			# needed for the very first time
	
	# flashplayer for mozilla
	wget https://raw.githubusercontent.com/cybernova/fireflashupdate/master/fireflashupdate.sh
	chmod +x fireflashupdate.sh
	./fireflashupdate.sh
	rm fireflashupdate.sh

	echo -e "$SCRIPT_INDICATOR Installed/updated applications:\n\033[0;36m"${LIST_TO_INSTALL[@]}"\033[0m\n"

	echo -e "$SCRIPT_INDICATOR Installing custom apps $OPTION_FINISHED\n"
fi

# install development tools
if [ "${OPTIONS[5]}" == "$MARK_CHAR" ]; then
	echo -e "$SCRIPT_INDICATOR Installing development tools$OPTION_STARTED\n";

	# adding 32 bit architecture
	sudo dpkg --add-architecture i386
	
	sudo apt-get update

	DEVELOPMENT_TO_INSTALL=(	
	"qtcreator"
	"libqtcore4"
	"libqtcore4:i386"
	"libqtgui4"
	"libqtgui4:i386"
	"build-essential"
	"libgl1-mesa-dev"			#for QTCreator
	"libgl1-mesa-dev:i386"		#for QTCreator
	"kdesvn"					#svn graphic interface
	"pkg-config"
	"bison"
	"flex"
	
	# yocto
	"chrpath"
	"diffstat"
	"textinfo"
	)

	sudo apt-get install -y "${DEVELOPMENT_TO_INSTALL[@]}"
	echo -e "$SCRIPT_INDICATOR Installed/updated applications:\n\033[0;36m"${DEVELOPMENT_TO_INSTALL[@]}"\033[0m\n"

	echo -e "$SCRIPT_INDICATOR Installing development tools $OPTION_FINISHED\n";
fi

# configure VIM
if [ "${OPTIONS[6]}" == "$MARK_CHAR" ]; then
	echo -e "$SCRIPT_INDICATOR Configuring VIM for "$(whoami)"$OPTION_STARTED\n";

	TEMP_DIR=$(mktemp -d "$THIS_NAME".XXXXX)
	REQUIRMENTS=("vim-gnome" "libreadline-dev")

	echo -e "$SCRIPT_INDICATOR Checking requirments for Clewn$OPTION_STARTED"
	sudo apt-get install -y "${REQUIRMENTS[@]}"

	echo -e "$SCRIPT_INDICATOR Removing old plugins$OPTION_STARTED"
	sudo rm -rf ~/.vim

	echo -e "$SCRIPT_INDICATOR Configuring new plugins$OPTION_STARTED"
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	git clone https://github.com/Lechnio/VIM-settings.git "$TEMP_DIR"/
	mv "$TEMP_DIR"/.vimrc ~/
	mv "$TEMP_DIR"/.ycm_extra_conf.py ~/.vim/
	VIM_VER=$(ls /usr/share/vim/ | grep -E "^vim[0-9]+$")
	sudo mv "$TEMP_DIR"/kali.vim /usr/share/vim/$VIM_VER/colors/
	vim +PluginInstall +qall
	sudo python ~/.vim/bundle/YouCompleteMe/install.py --clang-completer

	echo -e "$SCRIPT_INDICATOR Configuring Clewn debuger$OPTION_STARTED"
	tar -xvzf "$TEMP_DIR"/clewn-1.15.tar.gz -C "$TEMP_DIR"
	(cd "$TEMP_DIR"/clewn-1.15/ && ./configure)
	(cd "$TEMP_DIR"/clewn-1.15/ && make)
	(cd "$TEMP_DIR"/clewn-1.15/ && sudo make install)
	mkdir -p ~/.vim/plugin/ && cp /usr/local/share/vim/vimfiles/clewn.vim ~/.vim/plugin/
	mkdir -p ~/.vim/doc/ && cp /usr/local/share/vim/vimfiles/doc/clewn.txt ~/.vim/doc/
	mkdir -p ~/.vim/macros/ && cp /usr/local/share/vim/vimfiles/macros/clewn_mappings.vim  ~/.vim/macros/
	mkdir -p ~/.vim/syntax/ && cp /usr/local/share/vim/vimfiles/syntax/gdbvar.vim ~/.vim/syntax/

	echo -e "$SCRIPT_INDICATOR Removing temp files$OPTION_STARTED"
	rm -rf "$TEMP_DIR"

	echo -e "$SCRIPT_INDICATOR Configuring VIM for "$(whoami)" $OPTION_FINISHED\n";
fi

# install Spotify client
if [ "${OPTIONS[7]}" == "$MARK_CHAR" ]; then
	echo -e "$SCRIPT_INDICATOR Installing Spotify$OPTION_STARTED\n";

	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 4773BD5E130D1D45
	sudo echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list
	sudo apt-get update
	sudo apt-get install spotify-client

	echo -e "$SCRIPT_INDICATOR Installing Spotify $OPTION_FINISHED\n";
fi

# install extra hacking tools
if [ "${OPTIONS[8]}" == "$MARK_CHAR" ]; then
	echo -e "$SCRIPT_INDICATOR Installing hacking tools$OPTION_STARTED\n";

	if [ "$(whoami)" == "root" ]; then
		cd
		git clone https://github.com/arismelachroinos/lscript.git
		cd lscript
		chmod +x install.sh
		./install.sh
		
		pip install --upgrade google-auth-oauthlib # for wifi-pumpkin
	else
		echo -e "$SCRIPT_INDICATOR \033[1;31mYou are not root user!\033[0m"
		echo -e "$SCRIPT_INDICATOR \033[1;31mSkipping$OPTION_STARTED\033[0m\n"
	fi

	echo -e "$SCRIPT_INDICATOR Installing hacking tools $OPTION_FINISHED\n";
fi

function main()
{
	init

	# args handing
	if [ $# -gt 0 ]; then

		case "$1" in
			"-h" | "--help")
				HELP_MSG=(
				"Usage: '$0 [option]'\n\n"
				" -h, --help      Show this help message.\n"
				" -V, --version   Show script version."
				)
				echo -e "${HELP_MSG[@]}"
				;;
			"-V" | "--version")
				echo -e "$CURRENT_VERSION"
				;;
			*)
				echo -e "Bad use. Try '$0 [-h|--help]' for details."
				exit 1
				;;
		esac

		exit 0
	fi

	options_loop
}

main ${@}

# exit message
echo ""
echo "*******************"
echo "  Script finished  "
echo "*******************"
echo ""

exit 0
