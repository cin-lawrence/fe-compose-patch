#!/bin/sh

echo "[cinnamon-design-system] building in background..."

cd /$DEPENDENCY_DIR
# npm run build:esm:watch &> /dev/null
npm run build:esm:watch
