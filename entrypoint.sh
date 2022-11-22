#!/bin/sh

/build_link.sh &
/start.sh &
wait -n
exit $?
