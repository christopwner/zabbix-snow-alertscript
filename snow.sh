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

# hardcoded for convenience
category='Software/Application'
affected_ci='NetSuite - Enterprise BI'
division='Corporate'
orig_group='iHM-IT Monitoring and Reporting (SNC)'

json='{
    "category":"'${category}'",
    "cmdb_ci":"'${affected_ci}'",
    "u_division":"'${division}'",
    "u_originating_group":"'${orig_group}'",
    "short_description":"'${summary}'",
    "description":"'${details}'"
}'

curl -u "${user}:${pass}" -H "Content-Type: application/json" "${url}/api/now/table/incident" -d "${json}"
