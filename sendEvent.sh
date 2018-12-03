#!/bin/bash

ID="$1"
MILESTONE="$2"
EVENT_TYPE="$3"
DISPLAY_NAME="$4"
SUMMARY="$5"
DEEP_LINK="$6"
DATE="$7"
APPLICATION="$8"
TIER="$9"
NODE="${10}"
DB="${11}"
SEVERITY=${12}
SEVERITY_LEVEL=${13}
DAYS_IN_MONTH=${14}

curl -X POST "${ENDPOINT}/events/publish/incident_events" -H"X-Events-API-AccountName:${ACCOUNT_NAME}" -H"X-Events-API-Key:${API_KEY}" -H"Content-type: application/vnd.appd.events+json;v=2" -d "[{
\"id\": ${ID},
\"milestone\": \"${MILESTONE}\",
\"eventType\": \"${EVENT_TYPE}\",
\"displayName\": \"${DISPLAY_NAME}\",
\"summary\": \"${SUMMARY}\",
\"deepLink\": \"${DEEP_LINK}\",
\"dateTime\": ${DATE},
\"timestamp\": ${DATE},
\"application\": \"${APPLICATION}\",
\"tier\": \"${TIER}\",
\"node\": \"${NODE}\",
\"db\": \"${DB}\",
\"severity\": \"${SEVERITY}\",
\"severityLevel\": ${SEVERITY_LEVEL},
\"daysInMonth\": ${DAYS_IN_MONTH}
}]"
