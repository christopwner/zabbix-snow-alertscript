#!/bin/bash

# Copyright (C) 2017 Christopher Towner
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Zabbix alertscript for ServiceNow

# params from zabbix
url=$1
user=$2
pass=$3
summary=$4
details=$5

#remove carriage returns
details=$(echo $details | tr -d '\015')

# hardcoded for convenience
category='Software/Application'
affected_ci='8b50e76c1304e2809165f8fed144b03b'
division='Corporate'
assign_group='85b10cf00a0a3c87017fb2c2d689f690'
orig_group='85b10c080a0a3c8701846af226e693c5'

#directory to store id/user for events
dir="/tmp"

#get event.id and trigger.nseverity from tokenized summary
tokens=( $summary )
severity=${tokens[1]}
id=${tokens[3]}
let "priority = 6 - $severity"

# determine if new problem or resolution
if [[ "$summary" = "Resolved"* ]]; then
    # parse stored event_id->sys_id and event_id->sys_user
    sys_id=$(cat ${dir}/${id}.id)
    sys_user=$(cat ${dir}/${id}.user)
    json='{
        "state": "6",
        "close_code": "Resolved by Requester",
        "close_notes": "Resolved",
        "closed_by": {
            "link": "'${url}'/api/now/table/sys_user/'${sys_user}'",
            "value": "'${sys_user}'"
        }
    }'

    # post resolution and remove stored values
    curl -s -X PUT -u "${user}:${pass}" -H "Content-Type: application/json" "${url}/api/now/table/incident/${sys_id}" -d "${json}" > /dev/null
    rm ${dir}/${id}.id
    rm ${dir}/${id}.user
elif [[ "$summary" = "Problem"* ]]; then
    #setup json payload
    json='{
        "category":"'${category}'",
        "cmdb_ci":"'${affected_ci}'",
        "u_division":"'${division}'",
        "u_originating_group":"'${orig_group}'",
        "assignment_group":"'${assign_group}'",
        "short_description":"'${summary}'",
        "description":"'${details}'",
        "priority":"'${priority}'"
    }'

    #post payload and store event's sys_id and sys_user in response
    response=$(curl -s -u "${user}:${pass}" -H "Content-Type: application/json" "${url}/api/now/table/incident" -d "${json}")
    echo ${response} | jq -r '.[] | .sys_id' >> ${dir}/${id}.id
    echo ${response} | jq -r '.[] | .opened_by["value"]' >> ${dir}/${id}.user
fi
