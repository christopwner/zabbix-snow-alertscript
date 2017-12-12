# Zabbix ServiceNow Alertscript
Script for allowing a Zabbix server to create incidents in ServiceNow with alerts.

## Setup
Requires the following parameters (config in Zabbix during custom media type setup):
* {ALERT.SENDTO} (snow url)
* user
* pass
* {ALERT.SUBJECT}
* {ALERT.MESSAGE}

Must modify default subject in action to include {TRIGGER.NSEVERITY} and {EVENT.ID} as these macros are unavailable through media type. Should look like the following:
> Problem {TRIGGER.NSEVERITY} : {EVENT.ID} {TRIGGER.NAME}
> Resolved {TRIGGER.NSEVERITY} : {EVENT.ID} {TRIGGER.NAME}

Carriage returns are usually added to the default message but will be removed by this script. Consider adding semi-colons or another delimiter between fields.

## Requirements
* [jq](https://stedolan.github.io/jq/)
