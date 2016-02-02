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

### The time zone by default is Europe/Madrid
### If you want to get the full list of time zones availables in RHEL, you must execute this command timedatectl list-timezones
### In order to change the time zone you should confgiure an environment variable called TZ=Europe/Paris

if [ -n "$TZ" ]
then
   export TZ
else
   export TZ="Europe/Madrid"
fi

command=$1

shift 1

args=""

debug=""

for arg in $@ ; do
    if [ $arg == "-x" ]; then
      debug="-x"
    fi
    args="$args $arg"
done

case $command in
  info )
    source ./info $args ;;
  shell )
    source ./shell $args ;;
  start )
    source ./start $args ;;
  status )
    source ./status $args ;;
  test )
    source ./test $args ;;
  version)
    source ./version $args ;;
  heapdump)
    source ./heapdump $args ;;
  threaddump)
    source ./threaddump $args ;;

  * | help )
    source ./help ;;
esac
