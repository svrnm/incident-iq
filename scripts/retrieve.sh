#!/bin/bash
source ../env.sh
curl -X GET "${ENDPOINT}/events/schema/${SCHEMA_NAME}" -H"X-Events-API-AccountName:${ACCOUNT_NAME}" -H"X-Events-API-Key:${API_KEY}"
