#!/bin/sh

echo "[cinnamon-design-system] building in background..."

cd /cds
npm run build:esm:watch &> /dev/null
