#!/bin/bash

readonly CURRENT_VERSION="1.1.1"
readonly THIS_NAME=$(basename "$0")

#===========================
# customize yours tags here
readonly MARK_CHAR="\033[1;32m▶\033[0m"
readonly SCRIPT_INDICATOR="\033[0m[\033[1;33mSCRIPT\033[0m]"
readonly OPTION_STARTED="...\033[2m"
readonly OPTION_WARNING="[\033[0;33mWARNING\033[0m]"
readonly OPTION_FINISHED_S="[\033[1;32mFINISHED SUCCESS\033[0m]"
readonly OPTION_FINISHED_E="[\033[1;31mFINISHED ERROR\033[0m]"
#===========================

declare -a OPTIONS
declare LAST_MSG

function init()
{
	for i in {0..8}; do
		OPTIONS[$i]=" "
	done

	# check for auto update
	update_script --check-only
}

function print_menu()
{
	local MESSAGE=(
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

function log()
{
	echo -e "$SCRIPT_INDICATOR ${1}\033[0;36m"${2:-""}"\033[2m\n"
}

function print_marked_msg()
{
	local SUFFIX

	case ${1} in
		"--started")
		SUFFIX=$OPTION_STARTED
		;;
		"--warning")
		SUFFIX=$OPTION_WARNING
		;;
		"--finished-success")
		SUFFIX=$OPTION_FINISHED_S
		;;
		"--finished-error")
		SUFFIX=$OPTION_FINISHED_E
		;;
	esac
			
	echo -e "$SCRIPT_INDICATOR ${2}$SUFFIX\n"
}

function print_progress()
{
	echo -e "$SCRIPT_INDICATOR Tasks progress: ${PROGRESS:-0}/${SELECTED_CNT:-0}\n"
	(( PROGRESS++ ))
}

function update_script()
{
	local OPTION=${1}

	local TEMP_FILE=$(mktemp "/tmp/$THIS_NAME_version".XXXXX)
	wget -O "$TEMP_FILE" https://raw.githubusercontent.com/Lechnio/LinuxEasyManager/master/VERSION > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		LAST_MSG="Error when downloading file."
		
		# reset output for check only case
		[ "$OPTION" == "--check-only" ] && LAST_MSG=""

		return 1
	fi

	local UPSTREAM_VERSION=$(cat $TEMP_FILE)

	LAST_MSG="Current script version is '$CURRENT_VERSION'.\n"

	local C_VER_R="${CURRENT_VERSION//.}"
	local U_VER_R="${UPSTREAM_VERSION//.}"

	if [ $U_VER_R -gt $C_VER_R ]; then
		if [ "$OPTION" == "--check-only" ]; then
			LAST_MSG="HEY! New tool update is available, run `--update` to get the latest version :)"
			rm "$TEMP_FILE"
		else
			mv "$TEMP_FILE" "$THIS_NAME"
			LAST_MSG+="Script updated to version '$UPSTREAM_VERSION'."
		fi
	else
		rm "$TEMP_FILE"
		LAST_MSG+="You are up to date."

		[ "$OPTION" == "--check-only" ] && LAST_MSG=""
	fi

	return 0
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

function run_selected_options()
{
	local SELECTED_CNT=0
	local PROGRESS=1
	local FAILED_CNT=0
	local WARNING_CNT=0

	for i in "${OPTIONS[@]}"; do
		[ "$i" != " " ] && (( SELECTED_CNT++ ))
	done
	
# update sources list
if [ "${OPTIONS[1]}" == "$MARK_CHAR" ]; then
	print_progress
	print_marked_msg --started "Updating sources list"

	SOURCES_LIST=(
	"deb http://http.kali.org/kali kali-rolling main contrib non-free\n"
	"# For source package access, uncomment the following line\n"
	"# deb-src http://http.kali.org/kali kali-rolling main contrib non-free\n"
	"\n"
	"# For tlp\n"
	"deb http://repo.linrunner.de/debian wheezy main"
	)

	sudo echo -e "${SOURCES_LIST[@]}" > /etc/apt/sources.list
	if [ $? ]; then
		(( FAILED_CNT++ ))
		print_marked_msg --finished-error "Updating sources list"
	else
		log "Sources list updated:\n" "${SOURCES_LIST[*]}"
		print_marked_msg --finished-success "Updating sources list"
	fi
fi

# now add the KEY and fingerprint to use update
# NOTE THIS ->>> You have to be root to have privilidge run an export
if [ "${OPTIONS[2]}" == "$MARK_CHAR" ]; then
	print_progress
	print_marked_msg --started "Updating KEYs and fingerprints"

	if [ "$(whoami)" != "root" ]; then
		(( WARNING_CNT++ ))
		print_marked_msg --warning "You are not root user! Skipping..."
	else
		gpg --keyserver hkp://keys.gnupg.net --recv-key 7D8D0BF6
		gpg --fingerprint 7D8D0BF6
		gpg -a --export 7D8D0BF6 | apt-key add -

		# key for tlp
		gpg --keyserver hkp://keys.gnupg.net --recv-key 641EED65CD4E8809
		gpg --fingerprint 641EED65CD4E8809
		gpg -a --export 641EED65CD4E8809 | apt-key add -

		print_marked_msg --finished-success "Updating KEYs and fingerprints"
	fi
fi

# now run apt-get update and so one
if [ "${OPTIONS[3]}" == "$MARK_CHAR" ]; then
	print_progress
	print_marked_msg --started "Starting apt-get update"

	sudo apt-get clean
	sudo apt-get update
	sudo apt-get upgrade -y
	sudo apt-get dist-upgrade -y
	sudo apt autoremove -y

	print_marked_msg --finished-success "Starting apt-get update"
fi

# things to install by apt-get
if [ "${OPTIONS[4]}" == "$MARK_CHAR" ]; then
	print_progress
	print_marked_msg --started "Installing custom apps"

	sudo apt-get update

	local LIST_TO_INSTALL=(
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
	
	log "Installed/updated applications:\n" "${LIST_TO_INSTALL[*]}"

	log "Installing flashplayer for mozilla..."
	wget https://raw.githubusercontent.com/cybernova/fireflashupdate/master/fireflashupdate.sh
	if [ $? ]; then
		chmod +x fireflashupdate.sh
		./fireflashupdate.sh
		rm fireflashupdate.sh
	else
		(( WARNING_CNT++ ))
		print_marked_msg --warning "Could not fetch flashplayer from upstream"
	fi

	print_marked_msg --finished-success "Installing custom apps"
fi

# install development tools
if [ "${OPTIONS[5]}" == "$MARK_CHAR" ]; then
	print_progress
	print_marked_msg --started "Installing development tools"

	# adding 32 bit architecture
	sudo dpkg --add-architecture i386
	
	sudo apt-get update

	local DEVELOPMENT_TO_INSTALL=(	
	"qtcreator"
	"libqtcore4"
	"libqtcore4:i386"
	"libqtgui4"
	"libqtgui4:i386"
	"build-essential"
	"libgl1-mesa-dev"		#for QTCreator
	"libgl1-mesa-dev:i386"		#for QTCreator
	"kdesvn"			#svn graphic interface
	"pkg-config"
	"bison"
	"flex"
	
	# yocto
	"chrpath"
	"diffstat"
	"textinfo"
	)

	sudo apt-get install -y "${DEVELOPMENT_TO_INSTALL[@]}"
	log "Installed/updated applications:\n" "${DEVELOPMENT_TO_INSTALL[*]}"

	print_marked_msg --finished-success "Installing development tools"
fi

# configure VIMnm
if [ "${OPTIONS[6]}" == "$MARK_CHAR" ]; then
	print_progress
	print_marked_msg --started "Configuring VIM for $(whoami)"

	local TEMP_DIR=$(mktemp -d "/tmp/$THIS_NAME".XXXXX)
	local REQUIRMENTS=("vim-gnome" "vim-gtk3" "libreadline-dev") #vim-gnome can be obsolete

	log "Checking requirments for Clewn:\n" "${REQUIRMENTS[*]}"
	sudo apt-get install -y "${REQUIRMENTS[@]}"

	log "Removing old plugins\n"
	sudo rm -rf ~/.vim

	log "Configuring new plugins\n"
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	git clone https://github.com/Lechnio/VIM-settings.git "$TEMP_DIR"/
	mv "$TEMP_DIR"/.vimrc ~/
	mv "$TEMP_DIR"/.ycm_extra_conf.py ~/.vim/
	VIM_VER=$(ls /usr/share/vim/ | grep -E "^vim[0-9]+$")
	sudo mv "$TEMP_DIR"/kali.vim /usr/share/vim/$VIM_VER/colors/
	vim +PluginInstall +qall
	sudo python3 ~/.vim/bundle/YouCompleteMe/install.py --clang-completer # use --all instead to use with all lenguages

	log "Configuring Clewn debuger\n"
	tar -xvzf "$TEMP_DIR"/clewn-1.15.tar.gz -C "$TEMP_DIR"
	(cd "$TEMP_DIR"/clewn-1.15/ && ./configure)
	(cd "$TEMP_DIR"/clewn-1.15/ && make)
	(cd "$TEMP_DIR"/clewn-1.15/ && sudo make install)
	mkdir -p ~/.vim/plugin/ && cp /usr/local/share/vim/vimfiles/clewn.vim ~/.vim/plugin/
	mkdir -p ~/.vim/doc/ && cp /usr/local/share/vim/vimfiles/doc/clewn.txt ~/.vim/doc/
	mkdir -p ~/.vim/macros/ && cp /usr/local/share/vim/vimfiles/macros/clewn_mappings.vim  ~/.vim/macros/
	mkdir -p ~/.vim/syntax/ && cp /usr/local/share/vim/vimfiles/syntax/gdbvar.vim ~/.vim/syntax/

	log "Removing temp files\n"
	rm -rf "$TEMP_DIR"

	print_marked_msg --finished-success "Configuring VIM for $(whoami)"
fi

# install Spotify client
if [ "${OPTIONS[7]}" == "$MARK_CHAR" ]; then
	print_progress
	print_marked_msg --started "Installing Spotify"

	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 4773BD5E130D1D45
	sudo echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list
	if [ ! $? ]; then
		(( FAILED_CNT++ ))
		print_marked_msg --finished-error "Installing Spotify"
	else
		sudo apt-get update
		sudo apt-get install spotify-client

		print_marked_msg --finished-success "Installing Spotify"
	fi
fi

# install extra hacking tools
if [ "${OPTIONS[8]}" == "$MARK_CHAR" ]; then
	print_progress
	print_marked_msg --started "Installing hacking tools"

	if [ "$(whoami)" != "root" ]; then
		(( WARNING_CNT++ ))
		print_marked_msg --warning "You are not root user! Skipping..."
	else
		local CUR_DIR=$(pwd)
		cd
		git clone https://github.com/arismelachroinos/lscript.git
		cd lscript
		chmod +x install.sh
		./install.sh
		
		pip install --upgrade google-auth-oauthlib # for wifi-pumpkin
		cd $CUR_DIR	
	
		print_marked_msg --finished-success "Installing hacking tools"
	fi
fi

echo "*************************"
echo "  All options proceeded  "
echo "*************************"
echo "$FAILED_CNT from $SELECTED_CNT tasks failed."
echo "$WARNING_CNT from $SELECTED_CNT tasks finished with warning." 

return 0
}

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
				" -u, --update    Updates script against git repository.\n"
				" -V, --version   Show script version."
				)
				echo -e "${HELP_MSG[@]}"
				;;
			"-u" | "--update")
				update_script
				echo -e "$LAST_MSG"
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
	run_selected_options
}

main ${@}

exit 0