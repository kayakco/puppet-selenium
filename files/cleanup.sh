#!/bin/bash

# Array magic courtesy of:
# http://unix.stackexchange.com/questions/29509/transform-an-array-into-arguments-of-a-command

if [[ $# -ge 1 ]]; then
  HOURS_OLD=$1
else
  HOURS_OLD=$(( 24 * 7 )) # Default to 7 days
fi

if [[ -z $CLEANUP_NOOP ]]; then
  SIGNAL=15 # TERM
  ACTION="-print -a -exec rm -rf {} ;"
else
  set -x
  SIGNAL=0 # NOOP
  ACTION="-print"
fi

to_kill=( chromedriver firefox chrome )

for killfile in "/opt/google/chrome/chrome"; do
  if [[ -f "${killfile}" ]]; then
    to_kill=( "${to_kill[@]}" "${killfile}" )
  fi
done

if which killall >/dev/null && \
  killall --help 2>&1 | grep "\-\-older\-than" >/dev/null; then

  killall --verbose \
    --signal $SIGNAL \
    --older-than "${HOURS_OLD}h" \
    "${to_kill[@]}"
else
  echo "killall is missing or too outdated to use, please upgrade!" >&2
fi

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
