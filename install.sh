#!/bin/bash

source ./env.sh

function _parseurl() {
# http://stackoverflow.com/questions/6174220/parse-url-in-shell-script#6174447

proto="$(echo $1 | grep :// | sed -e's,^\(.*://\).*,\1,g')"
url="$(echo ${1/$proto/})"
host="$(echo ${url} | cut -d/ -f1)"
port="$(echo $host | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
hostname=$(echo ${host/":$port"/})

echo $proto $hostname ${port:-0}
}

function _cleanexit() {
  echo "Cleaning up..."
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
  PARSED_URL=(`_parseurl ${ENDPOINT}`)
  sed -e "s#\${ENDPOINT\[0\]}#${PARSED_URL[0]}#" -e "s#\${ENDPOINT\[1\]}#${PARSED_URL[1]}#" -e "s#\${ENDPOINT\[2\]}#${PARSED_URL[2]}#" -e "s#\${API_KEY}#${API_KEY}#" -e "s#\${ACCOUNT_NAME}#${ACCOUNT_NAME}#" actiontemplate.json > actiontemplate.local.json
  RESULT_STEP_2_PRE=`./act.sh -H ${APPD_CONTROLLER} -C ${APPD_CREDENTIALS} actiontemplate createmediatype -n 'application/vnd.appd.events+json'`
  RESULT_STEP_2=`./act.sh -H ${APPD_CONTROLLER} -C ${APPD_CREDENTIALS} actiontemplate import -t httprequest actiontemplate.local.json`
  if [[ "${RESULT_STEP_2}" == *'"success":true'* ]]
  then
    echo "succeeded."
  else
    echo "failed:"
    echo ${RESULT_STEP_2_PRE} ${RESULT_STEP_2}
    _cleanexit
  fi
}

function _step3() {
  echo -en "Installing business journey... ";
  RESULT_STEP_3_A=`./act.sh -H ${APPD_CONTROLLER} -C ${APPD_CREDENTIALS} bizjourney import journey.json`
  if [[ "${RESULT_STEP_3_A}" != *'errorMessage'* ]]
  then
    RESULT_STEP_3_B=`./act.sh -H ${APPD_CONTROLLER} -C ${APPD_CREDENTIALS} bizjourney enable ${RESULT_STEP_3_A}`
    if [[ "${RESULT_STEP_3_A}" != *'rootExceptionClass'* ]]
    then
      echo "succeeded."
    else
      echo "failed:"
      echo ${RESULT_STEP_3_B}
    fi
  else
    echo "failed:"
    echo ${RESULT_STEP_3_A}
    _cleanexit
  fi
}

cd scripts || exit;

_step0
_step1
_step2
_step3
_cleanexit
cd ..
