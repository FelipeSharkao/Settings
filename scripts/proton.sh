#!/bin/bash

# Author: brunoais (https://github.com/brunoais) and Tuncay (https://github.com/thingsiplay)
# Url: https://gist.github.com/brunoais/575db9912368124d3223784afe20158c
# All credits to the authors of the original script.

# Execute Windows programs with Proton from Steams installation folder, without
# starting Steam client.
#
# 1. Create a directory for Proton environment to run in.  As an example make a
#    folder "proton" in your home directory.  This folder must exist in order
#    to make Proton work.
#
# 2. Point the variable "env_dir" in this script to that folder or...
#
# 3. ... alternatively set the environmenal variable "$PROTONPREFIX" to this
#    folder before running the script.  It works similar to the "$WINEPREFIX"
#    from WINE and will have higher priority over "env_dir".
#
# 4. Look in your Steam installation folder at "steamapps/common/" folder for
#    available Proton versions.  Pick one and point the script variable
#    "proton_version" to this that folder name, in example "Proton 3.16".
#    Note: You have to download a Proton version from Steam first, if none is
#    there yet.
#
# 5. Or alternatively set the environmental variable "$PROTONVERSION" to that
#    folder name of Proton version before running the script.  It has higher
#    priority over script variable "proton_version".
#
# 6. Optionally install/copy this script in a directory that is in your $PATH,
#    so you can run it easily from any place.  Or set the default interpreter
#    for .exe files to this script.
#
# Usage:
#   proton program.exe
#
# or:
#   export PROTONPREFIX="$HOME/proton_316"
#   export PROTONVERSION="Proton 3.16"
#   proton program.exe

# Folder name possibilities for the Proton version found under "steamapps/common/".
possible_proton_versions=( "Proton - Experimental" "Proton 6.3" "Proton 5.0"  "Proton 3.16" )

# Path to installation directory of Steam.
# Contains the possibilities on where to find steam
possible_client_dirs=( "$HOME/.local/share/Steam" "$HOME/.steam/steam" "/var/.steam" "/var/steam" "/var/local/Steam" )


# Default data folder for Proton/WINE environment.  Folder must exist.
# If the environmental variable PROTONPREFIX is set, it will overwrite the value set here.
# If no directory is found, the last one is created and used
alternative_env_dirs=( "$HOME/proton"  "$HOME/.proton" )

# Proton logging.
# Uncomment to activate logging for proton
# export PROTON_LOG="+timestamp,+pid,+tid,+seh,+debugstr,+module"
# export PROTON_LOG_DIR="/dev/shm/proton"



# Proton modes to run
#   run = start target app
#   waitforexitandrun = wait for wineserver to shut down
#   getcompatpath = linux -> windows path
#   getnativepath = windows -> linux path
mode=run

echoerr() { echo "$@" 1>&2; }

discover_proton_version () {

	for possible_proton_version in "${possible_proton_versions[@]}"
	do
		for possible_client_dir in "${possible_client_dirs[@]}"
		do
			if [[ -f "$possible_client_dir/steamapps/common/$possible_proton_version/proton" ]]
			then
				client_dir="${client_dir:-$possible_client_dir}"
				proton_version="${proton_version:-$possible_proton_version}"
				echoerr "discover_proton_version:" "$possible_client_dir/steamapps/common/${possible_proton_version}/proton"
				return
			fi

		done
	done

}

discover_env_dir () {
	for alternative_env_dir in "${alternative_env_dirs[@]}"
	do

		if [[ -d "$alternative_env_dir" ]]
		then
			echoerr "alternative_env_dir:" "$alternative_env_dir"
			env_dir="$alternative_env_dir"
			return
		fi

	done

	env_dir=${$alternative_env_dir[-1]}
	echoerr "final fallback env dir:" "$env_dir"
}

client_dir=
env_dir=
proton_version=


if [[ "$1" =~ ((.*?)/steamapps/common/([^/]+)/) ]]
then

	app_dir="${BASH_REMATCH[1]}"
	client_dir="${BASH_REMATCH[2]}"
	app_dir_name="${BASH_REMATCH[3]}"

	# get the appid
	app_id=$(grep '"appid"' "$(grep -l "$app_dir_name" "$client_dir/steamapps/"*.acf)" |
			sed -Ee 's/.*?"([0-9]+)".*/\1/g')


	env_dir="$client_dir/steamapps/compatdata/$app_id/"

	echo "$env_dir"

	if [[ ! -d "$env_dir" ]]
	then
		env_dir="${alternative_env_dirs[0]}"
		echoerr "Env dir final fallback"
	fi


	echoerr "Env dir as:" " $env_dir"
else
	discover_proton_version

fi


# ENVIRONMENTAL VARIABLES
if [ -n "${PROTONPREFIX+1}" ]
then
    env_dir=$PROTONPREFIX
elif [ -z $env_dir ]
then
	discover_env_dir
fi

if [ -n "${PROTONVERSION+1}" ]
then
    proton_version=$PROTONVERSION
elif [ -z "$proton_version" ] || [ -z "$client_dir" ]
then
	discover_proton_version
fi


# EXECUTE
export STEAM_COMPAT_CLIENT_INSTALL_PATH=$client_dir
export STEAM_COMPAT_DATA_PATH=$env_dir


[[ ! -z "$PROTON_LOG" ]] && echo "$client_dir/steamapps/common/$proton_version/proton" $mode $*
[[ ! -z "$PROTON_LOG_DIR" ]] && mkdir -p "$PROTON_LOG_DIR"

# Make sure the directory exists
[ -d "$env_dir" ] || (mkdir -p "$env_dir" && echoerr "Proton directory created: $env_dir")

"$client_dir/steamapps/common/$proton_version/proton" run "$@"

