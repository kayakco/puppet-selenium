#!/bin/bash

if [[ $# -ge 1 ]]; then
  DAYS_OLD=$1
else
  DAYS_OLD=7
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
  --older-than "${DAYS_OLD}d" \
  chromedriver firefox chrome

for regex in \
  "/tmp/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}" \
  "/tmp/\.org\.chromium\.Chromium\.[a-z0-9A-Z]{6}" \
  "/tmp/\.com\.google\.Chrome\.[a-z0-9A-Z]{6}" \
  "/tmp/anonymous[0-9]{19}webdriver-profile" \
  "/tmp/webdriver[0-9]{19}duplicated"; do

  find /tmp -maxdepth 1 \
            -regextype posix-egrep \
            -regex "${regex}" \
            -type d \
            -mtime "+${DAYS_OLD}" \
            $ACTION
done
