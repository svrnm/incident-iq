#!/bin/bash

APPLICATIONS=("Fake-ECommerce" "Fake-Fulfillment")
APPLICATION=${APPLICATIONS[$RANDOM % ${#APPLICATIONS[@]} ]}

TIERS=("frontend" "processing" "inventory")
TIER=${TIERS[$RANDOM % ${#TIERS[@]} ]}

NODE="${TIER}-${RANDOM:0:1}"

echo "$APPLICATION;$TIER;$NODE"

source ./env.sh
ID=${RANDOM}
DATE="`date +%s`000"
curl -X POST "${ENDPOINT}/events/publish/incident_events" -H"X-Events-API-AccountName:${ACCOUNT_NAME}" -H"X-Events-API-Key:${API_KEY}" -H"Content-type: application/vnd.appd.events+json;v=2" -d "[{
\"id\": ${ID},
\"milestone\": \"start\",
\"eventType\": \"POLICY_OPEN_WARNING\",
\"displayName\": \"New Warning Health Rule Violation\",
\"summary\": \"Sample Summary Message\",
\"deepLink\": \"https://mycustomer.saas.appdynamics.com/#location=APP_EVENT_VIEWER_MODAL&eventSummary=${ID}&application=42\",
\"dateTime\": ${DATE},
\"timestamp\": ${DATE},
\"application\": \"${APPLICATION}\",
\"tier\": \"${TIER}\",
\"node\": \"${NODE}\",
\"db\": \"\",
\"severity\": \"ERROR\",
\"severityLevel\": 1,
\"daysInMonth\": 30
}]"

declare -i DATE

sleep $1

DATE="`date +%s`000"

curl -X POST "${ENDPOINT}/events/publish/incident_events" -H"X-Events-API-AccountName:${ACCOUNT_NAME}" -H"X-Events-API-Key:${API_KEY}" -H"Content-type: application/vnd.appd.events+json;v=2" -d "[{
\"id\": ${ID},
\"milestone\": \"end\",
\"eventType\": \"POLICY_CLOSE_WARNING\",
\"displayName\": \"Health Rule Close\",
\"summary\": \"Sample Summary Message\",
\"deepLink\": \"https://mycustomer.saas.appdynamics.com/#location=APP_EVENT_VIEWER_MODAL&eventSummary=${ID}&application=42\",
\"dateTime\": ${DATE},
\"timestamp\": ${DATE},
\"application\": \"${APPLICATION}\",
\"tier\": \"${TIER}\",
\"node\": \"${NODE}\",
\"db\": \"\",
\"severity\": \"ERROR\",
\"severityLevel\": 1,
\"daysInMonth\": 30
}]"

sleep $2
