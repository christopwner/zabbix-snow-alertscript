# Zabbix ServiceNow Alertscript
Script for allowing a Zabbix server to create incidents in ServiceNow with alerts.

## Setup
Requires the following parameters (config in Zabbix during custom media type setup):
* {ALERT.SENDTO} (snow url)
* user
* pass
* {ALERT.SUBJECT}
* {ALERT.MESSAGE}
* {EVENT.ID}

Must modify default subject in action to include {TRIGGER.NSEVERITY} as this macro is unavailable through media type. Should look like the following:
> Problem {TRIGGER.NSEVERITY} : {TRIGGER.NAME}

## Requirements
* [jq](https://stedolan.github.io/jq/)
