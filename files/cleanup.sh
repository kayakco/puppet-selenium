#!/bin/bash

if [[ $# -ge 1 ]]; then
  HOURS_OLD=$1
else
  HOURS_OLD=$(( 24 * 7 )) # Default to 7 days
fi

if [[ -z $CLEANUP_NOOP ]]; then
  SIGNAL=15 # TERM
  ACTION="-exec rm -rf {} ;"
else
  set -x
  SIGNAL=0 # NOOP
  ACTION="-print"
fi

killall --verbose \
  --signal $SIGNAL \
  --older-than "${HOURS_OLD}h" \
  chromedriver firefox chrome "/opt/google/chrome/chrome"

MINS_OLD=$(( $HOURS_OLD * 60 ))

for regex in \
  "/tmp/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}" \
  "/tmp/\.org\.chromium\.Chromium\.[a-z0-9A-Z]{6}" \
  "/tmp/\.com\.google\.Chrome\.[a-z0-9A-Z]{6}" \
  "/tmp/anonymous[0-9]{10,}webdriver-profile" \
  "/tmp/webdriver[0-9]{10,}duplicated"; do

  find /tmp -maxdepth 1 \
            -regextype posix-egrep \
            -regex "${regex}" \
            -type d \
            -mmin "+${MINS_OLD}" \
            $ACTION
done
