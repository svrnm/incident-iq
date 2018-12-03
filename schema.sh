#!/bin/bash
# Use this script to create the incidents_events schema from schema.json
source ./env.sh
curl -s -X POST "${ENDPOINT}/events/schema/${SCHEMA_NAME}5" -H"X-Events-API-AccountName:${ACCOUNT_NAME}" -H"X-Events-API-Key:${API_KEY}" -H"Content-type: application/vnd.appd.events+json;v=2" -d @schema.json
