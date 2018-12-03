#!/bin/bash

source ./env.sh

function _cleanexit() {
  rm -f act.sh # actiontemplate.local.json
  exit
}

function _step0() {
  echo -en "Downloading act.sh... "
  curl -O -s 'https://raw.githubusercontent.com/Appdynamics/api-commandline-tool/master/act.sh'
  if [ -f 'act.sh' ]
  then
  echo 'succeeded.'
  else
  echo 'failed.'
  _cleanexit
  fi
  chmod +x act.sh
}

function _step1() {
  echo -en "Installing schema ${SCHEMA_NAME}... ";
  RESULT_STEP_1=`./schema.sh`
  if [ "$RESULT_STEP_1" != "" ]
  then
  echo "failed:"
  echo ${RESULT_STEP_1}
  _cleanexit
  else
  echo "succeeded."
  fi
}

function _step2() {
  echo -en "Installing http action template... ";
  sed -e "s#\${ENDPOINT}#${ENDPOINT}#" -e "s#\${API_KEY}#${API_KEY}#" -e "s#\${ACCOUNT_NAME}#${ACCOUNT_NAME}#" actiontemplate.json > actiontemplate.local.json
  RESULT_STEP_2_PRE=`./act.sh -E local actiontemplate createmediatype -n 'application/vnd.appd.events+json'`
  RESULT_STEP_2=`./act.sh actiontemplate import -t httprequest actiontemplate.local.json`
  if [[ "${RESULT_STEP_2}" == *'"success":true'* ]]
  then
    echo "succeeded."
  else
    echo "failed:"
    echo ${RESULT_STEP_2_PRE} ${RESULT_STEP_2}
    _cleanexit
  fi
}


_step0
#_step1
_step2


#echo -en "Installing action template... ";
#echo "$(<actiontemplate.json)"
#RESULT_STEP_2=`./act.sh actiontemplate import actiontemplate.json`
#echo $RESULT_STEP_2

_cleanexit
