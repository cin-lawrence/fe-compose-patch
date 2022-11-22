#!/bin/sh

echo "[client project] waiting for @cinnamon/design-system"
while [ ! -f /cds/esm/index.js ]; do
    sleep 1
done
# Sleep 2 to make sure the index.js has finished writing
sleep 2
echo "[client project] starting..."
cd /ffg
npm start
