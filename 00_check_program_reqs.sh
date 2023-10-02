#!/bin/bash

RED="\033[31m"
BLUE="\033[34m"
NORMAL="\033[0;39m"

#----------------------------------------------------------------------
# Check if requirements are present
#----------------------------------------------------------------------
requirements="docker docker-compose wget dpkg gunzip"

for req in $requirements; do
  if ! req_loc="$(type -p "$req")" || [[ -z $req_loc ]] || [[ ! -x $req_loc ]]; then

    echo -e "\n\n${RED}Please install ${req}"
    exit 0
  fi
done

#----------------------------------------------------------------------
# Check if versions are correct
#----------------------------------------------------------------------

curr_docker=$(docker -v | awk '{print $3}' | sed 's/-ce,//g')
curr_docker_compose=$(docker-compose -v | awk '{print $3}' | sed 's/,//g')

declare -A vers_curr=(["docker"]=${curr_docker} ["docker-compose"]=${curr_docker_compose})
declare -A vers_reqs=(["docker"]="17.05" ["docker-compose"]="1.6.0")

for key in "${!vers_reqs[@]}"; do
  echo -e "\n${NORMAL}Checking $key version...."

  dpkg --compare-versions "${vers_curr[$key]}" "gt" "${vers_reqs[$key]}"

  vers_pass=$?
  if [ "$vers_pass" -ne 0 ]; then
    echo -e "\n\n${RED}Please update $key! ${vers_curr[$key]} is less than ${vers_reqs[$key]}"
    exit 0
  else
    echo -e "${BLUE}Pass"
  fi

done

echo -e "\n\n${BLUE}All checks passed"


exit 0
