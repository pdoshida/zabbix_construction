#!/bin/bash -x

# Slack incoming web-hook URL
SLACK_WEBHOOKSURL='https://hooks.slack.com/services/xxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

# Slack UserName
SLACK_USERNAME='Zabbix'


# "Send to" for Zabbix User Media Setting
NOTIFY_CHANNEL="$1"

# "Default subject" for Action Operations Setting
ALERT_SUBJECT="$2"

# "Default message" for Action Operations Setting
ALERT_MESSAGE="$3"

OK_STR="Resolved"
NG_STR="Problem"

if [[ "${ALERT_SUBJECT}" =~ ^${OK_STR}.*  ]]; then
        ICON=':smile:'
        COLOR="good"
elif [[ "${ALERT_SUBJECT}" =~ ^${NG_STR}.* ]]; then
        ICON=':skull:'
        COLOR="danger"
else
        #ICON=':innocent:'
        ICON=':sushi:'
        COLOR="#439FE0"
fi

# Create JSON payload
PAYLOAD="payload={
    \"channel\": \"${NOTIFY_CHANNEL//\"/\\\"}\",
    \"username\": \"${SLACK_USERNAME//\"/\\\"}\",
    \"icon_emoji\": \"${ICON}\",
    \"attachments\": [
        {
            \"color\": \"${COLOR}\",
            \"text\": \"${ALERT_SUBJECT//\"/\\\"}\"
        }
    ]
}"

# Send it as a POST request to the Slack incoming webhooks URL
curl -m 5 --data-urlencode "${PAYLOAD}" $SLACK_WEBHOOKSURL
