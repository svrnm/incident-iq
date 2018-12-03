#!/bin/bash
# Use this scrip to create fake events.
APPLICATIONS=("Fake-ECommerce" "Fake-Fulfillment")
APPLICATION=${APPLICATIONS[$RANDOM % ${#APPLICATIONS[@]} ]}

TIERS=("frontend" "processing" "inventory")
TIER=${TIERS[$RANDOM % ${#TIERS[@]} ]}

NODE="${TIER}-${RANDOM:0:1}"

echo "$APPLICATION;$TIER;$NODE"

source ../env.sh
ID=${RANDOM}
DATE="`date +%s`000"

TIMEOUT_1=$1
TIMEOUT_2=$2

./sendEvent.sh $ID "start" "POLICY_OPEN_WARNING" "New Warning Health Rule Violation" "Sample Summary Message" \
"https://mycustomer.saas.appdynamics.com/#location=APP_EVENT_VIEWER_MODAL&eventSummary=${ID}&application=42" \
"${DATE}" \
"${APPLICATION}" \
"${TIER}" \
"${NODE}" \
"" \
"ERROR" \
"1" \
"30"

declare -i DATE

sleep $TIMEOUT_1

DATE="`date +%s`000"

./sendEvent.sh $ID "end" "POLICY_CLOSE_WARNING" "Health Rule Close" "Sample Summary Message" \
"https://mycustomer.saas.appdynamics.com/#location=APP_EVENT_VIEWER_MODAL&eventSummary=${ID}&application=42" \
"${DATE}" \
"${APPLICATION}" \
"${TIER}" \
"${NODE}" \
"" \
"ERROR" \
"1" \
"30"

sleep $TIMEOUT_2
