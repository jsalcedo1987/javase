#!/bin/bash

# Copyright 2016 Produban Servicios InformÃ¡ticos Generales S.L.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function vcap_exists(){
  if [ "x" == "x${VCAP_SERVICES}" ] ; then
    # does not exist
    return 1
  else
    # exists
    return 0
  fi
}

function write_vcap() {

  echo "$date [INFO] Export VCAP_SERVICES=$vcap" >> $LOG_FILE
  export VCAP_SERVICES="$vcap"

}

function read_vcap_url() {

  vcap="{}"

  if [ "x" == "x${APP_NAME}" ] ; then
    echo "$date [WARN] Impossible to get the VCAP_SERVICES environment variable. APP_NAME env is not defined." >> $LOG_FILE
    echo "$date [WARN] Impossible to get the VCAP_SERVICES environment variable. APP_NAME env is not defined."
    return
  fi

  if [ "x" == "x${SERVICE_MANAGER_URL}" ] ; then
    echo "$date [WARN] Impossible to get the VCAP_SERVICES environment variable. SERVICE_MANAGER_URL env is not defined." >> $LOG_FILE
    echo "$date [WARN] Impossible to get the VCAP_SERVICES environment variable. SERVICE_MANAGER_URL env is not defined."
    return
  fi

  parameters="appId=${APP_NAME}"

  URL="${SERVICE_MANAGER_URL}?${parameters}"

  vcap=`curl -f -s -X GET $URL`
  rc=$?

  if [ $rc -ne 0 ]; then
    echo "$date [ERROR] Impossible to get the VCAP_SERVICES environment variable. Return code: $rc" >> $LOG_FILE
    echo "$date [ERROR] Impossible to get the VCAP_SERVICES environment variable. Return code: $rc"

    vcap="{}"
  fi

}


LOG_DIR=$HOME/logs/
mkdir -p $LOG_DIR
LOG_FILE=${LOG_DIR}service_manager_binder.log

date=`date`

# if VCAP_SERVICES is defined by user don't set it
if ! vcap_exists ; then

  read_vcap_url
  write_vcap

fi
