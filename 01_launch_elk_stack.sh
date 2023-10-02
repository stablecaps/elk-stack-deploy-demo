#!/bin/bash

NORMAL="\033[0;39m"
BLUE="\033[34m"

#----------------------------------------------------------------------
# Download Settings
# Edit $LOG_GZ_FILE_LIST to add log files
#----------------------------------------------------------------------

BASE_URL="https://github.com/mintel/sre-interview-assets/raw/master/challenges/challenge_01_docker_elk_apache_logs/"
LOG_GZ_FILE_LIST="WEB_access_log.log.gz"

#----------------------------------------------------------------------
# Download and decompress log files
#----------------------------------------------------------------------

for LOG_GZ_FILE in $LOG_GZ_FILE_LIST; do

  LOGFILE=${LOG_GZ_FILE//.gz/}
  LOGFILE_LOC="docker-elk/logstash/incoming_csvs/${LOGFILE}"

  if [ ! -f "${LOGFILE_LOC}"  ]; then
    echo -e "\n${BLUE}Downloading & extracting file...${NORMAL}"

    wget --no-clobber ${BASE_URL}${LOG_GZ_FILE}

    gunzip -c ${LOG_GZ_FILE} > "docker-elk/logstash/incoming_csvs/${LOGFILE}"
  fi
done


#----------------------------------------------------------------------
# Launch ELK stack via dicker-compose
#----------------------------------------------------------------------

cd docker-elk || exit 1

docker-compose up -d

echo -e "\n\n${BLUE}ELK stack launched${NORMAL}\n\n"

docker ps

echo -e "\n${BLUE}Please wait for a few moments till new logs are ingested ${NORMAL} \n"
docker stats --no-stream

echo -e "\n${BLUE}Kibana can be accessed from your browser at http://localhost:5601 ${NORMAL} \n"

exit 0
