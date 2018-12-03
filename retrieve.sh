#!/bin/bash
source ./env.sh
curl -X GET "${ENDPOINT}/events/schema/synth_session_records" -H"X-Events-API-AccountName:${ACCOUNT_NAME}" -H"X-Events-API-Key:${API_KEY}"
