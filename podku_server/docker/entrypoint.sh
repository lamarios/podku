#!/bin/sh
set -e

echo "Starting serverpod"
./server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role --apply-migrations &
SERVER_PID=$!

sleep 1


echo "Starting Caddy"
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &
CADDY_PID=$!

wait -n $SERVER_PID $CADDY_PID
exit $?