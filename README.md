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
* {TRIGGER.NSEVERITY}

## Requirements
* [jq](https://stedolan.github.io/jq/)
