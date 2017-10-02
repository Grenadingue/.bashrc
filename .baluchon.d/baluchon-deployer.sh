#!/bin/sh

tmp_dir="/tmp/baluchon-deployer"

repo_name="baluchon"
repo_branch="master"
repo_url="github.com/Grenadingue/${repo_name}"
git_https_url="https://${repo_url}.git"
git_ssh_url="ssh://git@${repo_url}.git"
zip_archive="${repo_branch}.zip"
zip_url="https://${repo_url}/archive/${zip_archive}"
extracted_zip="${repo_name}-${repo_branch}"

declare -A colors=(
    ["blue"]="\e[34m"
    ["yellow"]="\e[33m"
    ["red"]="\e[31m"
    ["green"]="\e[32m"
    ["white"]="\e[97m"
    ["magenta"]="\e[35m"
    ["reverse"]="\e[7m"
)

declare -A style=(
    ["bold"]="\e[1m"
    ["underline"]="\e[4m"
    ["blink"]="\e[5m"
    ["reset"]="\e[0m"
)

action()
{
    echo -e "\n${style[bold]}${colors[blue]}# $@...${style[reset]}"
}

info()
{
    echo -e "${style[bold]}${colors[white]}-> ${style[reset]}$@"
}

success()
{
    echo -e "${style[bold]}${colors[green]}-> ${style[reset]}$@"
}

warning()
{
    echo -e "${style[bold]}${colors[yellow]}-> ${style[reset]}$@"
}

error()
{
    echo -e "${style[bold]}${colors[red]}-> ${style[reset]}$@"
}

command_exists()
{
    command -v $1 >/dev/null 2>&1
}

ask_yes_no()
{
    answer=""
    while true; do
	echo -en "${style[bold]}${colors[blue]}-> ${style[reset]}$@ [y/n] "
	read -p "" answer
	if [ "${answer}" == "" ]; then
	    answer="y";
	fi
	case $answer in
            [Yy]* ) return 0;;
	    [Nn]* ) return 1;;
            * ) echo "say what?";;
	esac
    done

}

command_availability()
{
    if command_exists "$1"; then
	success "$1 found"
    else
	error "$1 not found"
    fi
}

download_tools_overview()
{
    action "Checking download tools availability"
    command_availability git
    command_availability ssh
    command_availability curl
    command_availability wget
}

download_repository()
{
    if command_exists git; then
    	if git clone "${git_https_url}"; then
    	    repository_path="${PWD}/${repo_name}"
    	    return 0;
	fi
	if command_exists ssh; then
    	    if git clone "${git_ssh_url}"; then
    		repository_path="${PWD}/${repo_name}"
    		return 0;
    	    fi
	else
    	    error "ssh not found"
	fi
    else
    	error "git not found"
    	warning "if you continue no baluchon updates and submodules will be available"
    	if ! ask_yes_no "Continue?"; then
    	    success "aborting"
    	    exit 0
    	fi
    fi
    if command_exists curl && curl -LO "${zip_url}"; then
	repository_path="${PWD}/${zip_archive}"
	return 0;
    elif command_exists wget && wget "${zip_url}"; then
	repository_path="${PWD}/${zip_archive}"
	return 0;
    fi
    return 1;
}

extraction_tools_overview()
{
    action "Checking extraction tools (.zip) availability"
    command_availability unzip
    command_availability 7z
    command_availability jar
}

extract_repository()
{
    REPOSITORY_EXT=`basename ${repository_path} | cut -d'.' -f2`
    if [ "${REPOSITORY_EXT}" == "zip" ]; then
	if command_exists unzip && unzip "${zip_archive}"; then
	    repository_path="`dirname ${repository_path}`/${extracted_zip}"
	    return 0;
	elif command_exists 7z && 7z x "${zip_archive}"; then
	    repository_path="`dirname ${repository_path}`/${extracted_zip}"
	    return 0;
	elif command_exists jar && jar xfv "${zip_archive}"; then
	    repository_path="`dirname ${repository_path}`/${extracted_zip}"
	    return 0;
	fi
    fi
    return 1;
}

if [ -d "${tmp_dir}" ]; then
    echo
    info "${tmp_dir}"
    if ask_yes_no "Temporary deployment directory already exists. Override?"; then
	action "Erasing previous directory"
	if ! rm -rf "${tmp_dir}/"*; then
	    error "unable to erase directory"
	    exit 1
	fi
	success "directory erased"
    fi
else
    action "Creating temporary deployment directory"
    info "${tmp_dir}"
    if ! mkdir -p "${tmp_dir}"; then
	error "unable to create or access directory"
	exit 1;
    fi
    success "directory created/found"

fi

action "Entering temporary deployment directory"
if ! cd "${tmp_dir}"; then
    error "unable to enter in directory"
    exit 1;
fi
success "inside directory"

ask_for_download_conservation()
{
    info "$1 found"
    if ask_yes_no "Erase and download again?"; then
	if ! rm -rf "$2"; then
	    error "unable to erase previous $1"
	    return 1
	fi
	sucess "previous $1 erased"
    else
	repository_path="$2"
	download=0
	success "$1 will be used"
    fi
    return 0
}

check_for_previous_download()
{
    download=1
    if [ -d "${tmp_dir}/${repo_name}" ] && [ -d "${tmp_dir}/${repo_name}/.git" ]; then
	if ! ask_for_download_conservation "git repository" "${tmp_dir}/${repo_name}"; then
	    return 1
	fi
    elif [ -e "${tmp_dir}/${zip_archive}" ]; then
	if ! ask_for_download_conservation "zip archive" "${tmp_dir}/${zip_archive}"; then
	    return 1
	fi
    fi
    return 0
}

action "Checking for previous download"
if ! check_for_previous_download; then
    exit 1
fi

if [ $download -eq 1 ]; then
    download_tools_overview
    action "Downloading baluchon"
    if ! download_repository; then
	error "unable to download repository"
	exit 1;
    fi
    info "${repository_path}"
    success "baluchon downloaded"
fi

if [ ! -d "${repository_path}" ]; then
    extraction_tools_overview
    action "Extracting baluchon"
    if ! extract_repository; then
	error "unable to extract repository"
	exit 1;
    fi
    info "${repository_path}"
    success "baluchon extracted"
fi

repository_path="$tmp_dir/baluchon"

retrieve_user_home_path()
{
    if [ "${HOME}" == "" ]; then
	if [ "${USER}" != "" ] && [ -d "/home/${USER}" ]; then
	    HOME="/home/${USER}"
	    return 0;
	elif [ "${USERNAME}" != "" ] && [ -d "/home/${USERNAME}" ]; then
	    HOME="/home/${USERNAME}"
	    return 0;
	elif command_exists whoami; then
	    USER=`whoami`
	    if [ "${USER}" != "" ] && [ -d "/home/${USER}" ]; then
		HOME="/home/${USER}"
		return 0;
	    fi
	fi
    elif [ -d "${HOME}" ]; then
	return 0
    fi
    return 1
}

action "Retrieving user home path"
if ! retrieve_user_home_path; then
    error "unable to retrieve user home path"
    exit 1
fi
info "${HOME}"
success "user home path retrieved"

save_home_file()
{
    filepath="$1"
    filename=`basename ${filepath}`
    if [ "${filename}" != "." ] && [ "${filename}" != ".." ]; then
	file_to_save="${HOME}/${filename}"
	if [ -e "${file_to_save}" ] || [ -d "${file_to_save}" ]; then
	    # echo "${file_to_save} -> ${home_save}/${filename}"
	    if ! mv "${file_to_save}" "${home_save}/${filename}"; then
		error "unable to move file"
		home_save_error=1
	    fi
	    ls -l "${home_save}"
	fi
    fi
}

save_current_home()
{
    if ! mkdir -p "${home_save}"; then
	error "unable to create home configuration save directory"
	return 1
    fi
    home_save_error=0
    for filepath in "${repository_path}/"*; do
	save_home_file "$filepath"
    done
    for filepath in "${repository_path}/."*; do
	save_home_file "$filepath"
    done
    return $home_save_error
}

action "Saving current home configuration"
home_save="${HOME}/.home.save"
save=0
if [ -d "${home_save}" ]; then
    info "home configuration save directory already exists"
    if ! ask_yes_no "Redo home save operation? Not recommended."; then
	save=1
	success "aborted"
    fi
fi
if [ $save -eq 0 ]; then
    if ! save_current_home; then
	error "unable to save current home configuration"
	exit 1
    fi
    info "${home_save}"
    success "previous home configuration saved"
fi

action "Deploy baluchon in user home directory"
# if ! ls -a "${repository_path}/"; then
if ! cp -r "${repository_path}/." "${HOME}"; then
    error "unable to deploy baluchon in user home"
    exit 1
fi
success "baluchon deployed"

action "Performing full repository update"
if [ ! -x "${HOME}/bin/baluchon-updater" ]; then
  error "unable to find updater script"
  exit 1
elif ! "${HOME}/bin/baluchon-updater"; then
  error "unable to perform repository update"
  exit 1
fi
success "repository updated"

action "Informing user"
success "baluchon successfully deployed"
info "in order to activate it"
info "execute #   source ${HOME}/.bashrc"
info "or just start a new shell"

exit 0
