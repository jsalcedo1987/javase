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

echo "Starting heap dump utility"

#pushd "/usr/local/tomcat" > /dev/null


PID=`ps auxww | grep " java " | grep -v grep | awk '{print $2}'`

if [ -n "$PID" ]
then
   #### I have to validate if it has more than one line

   if [ `echo $PID | wc -l` -gt 1 ]
   then
      echo "There are several java processes"
      exit
   fi
   jmap -dump:format=b,file=/tmp/jvm.hprof $PID
   echo "Heap dump was create in /tmp/jvm.hprof"
else
   echo "No java process running"
fi
