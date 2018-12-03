#!/bin/bash
# Use this script do delete an existing version of the schema.
# Use with care: All data will be lost!
source ./env.sh
curl -X DELETE "${ENDPOINT}/events/schema/incident_events3" -H"X-Events-API-AccountName:${ACCOUNT_NAME}" -H"X-Events-API-Key:${API_KEY}"
