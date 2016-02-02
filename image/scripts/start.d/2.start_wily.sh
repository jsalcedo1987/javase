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

PROFILE_FILE="${WILY_HOME}/wilyAgent/core/config/IntroscopeAgent.profile.docker"

### Only wily is activated if WILY_MOM1_FQDN variable is defined

echo "Evaluating if I have to activate WILY agent"

if [ -n "$WILY_MOM_FQDN" ]
then

  if [ ! -f "${WILY_HOME}/wilyAgent/Agent.jar" ]; then
    echo "[ERROR] The ${WILY_HOME}/wilyAgent/Agent.jar does not exits."
    return 1
  fi

   ### I have to merge differents wily properties into IntroscopeAgent.properties

   cp -R "$WILY_HOME/wilyAgent/examples/SOAPerformanceManagement/ext" "$WILY_HOME/core/ext"

   #sed "s/\[WILY_MOM_FQDN\]/${WILY_MOM_FQDN}/" "${WILY_HOME}/wilyAgent/IntroscopeAgent.profile" > "${WILY_HOME}/wilyAgent/IntroscopeAgent.profile.tmp"
   #sed -i "s/\[WILY_MOM_PORT\]/${WILY_MOM_PORT}/" "${WILY_HOME}/wilyAgent/IntroscopeAgent.profile.tmp"

   if [ -n "${PROJECT_NAME}" ]
   then
   	WILY_JAVA_OPTS="${WILY_JAVA_OPTS} -Dintroscope.agent.hostName=${PROJECT_NAME}"
   fi
   if [ -n "${APP_NAME}" ]
   then
   	WILY_JAVA_OPTS="${WILY_JAVA_OPTS} -Dcom.wily.introscope.agent.agentName=${APP_NAME}"
   fi
   WILY_JAVA_OPTS="${WILY_JAVA_OPTS} -Dintroscope.agent.enterprisemanager.transport.tcp.host.DEFAULT=${WILY_MOM_FQDN}"
   if [ -n "${WILY_MOM_PORT}" ]
   then
   	WILY_JAVA_OPTS="${WILY_JAVA_OPTS} -Dintroscope.agent.enterprisemanager.transport.tcp.port.DEFAULT=${WILY_MOM_PORT}"
   fi

   WILY_JAVA_OPTS="${WILY_JAVA_OPTS} -javaagent:${WILY_HOME}/wilyAgent/Agent.jar"
   WILY_JAVA_OPTS="${WILY_JAVA_OPTS} -Dcom.wily.introscope.agentProfile=${PROFILE_FILE}"

   cat "${WILY_HOME}/wilyAgent/core/config/IntroscopeAgent.profile" > "${WILY_HOME}/wilyAgent/core/config/IntroscopeAgent.profile.docker"
   cat "${WILY_HOME}/wilyAgent/IntroscopeAgent.profile" >> "${WILY_HOME}/wilyAgent/core/config/IntroscopeAgent.profile.docker"

   #cat "${WILY_HOME}/wilyAgent/core/config/IntroscopeAgent.profile.ori" > "${WILY_HOME}/wilyAgent/core/config/IntroscopeAgent.profile"
   #cat "${WILY_HOME}/wilyAgent/IntroscopeAgent.profile.tmp" >> "${WILY_HOME}/wilyAgent/core/config/IntroscopeAgent.profile"

   export JAVA_OPTS_EXT="${JAVA_OPTS_EXT} ${WILY_JAVA_OPTS}"
fi
