#/bin/bash
headsha=$(git rev-parse --verify HEAD)
MODE=$1

echo $MODE
docker build --build-arg MODE=$MODE -t pxp-runtime-builder:$headsha --build-arg CACHEBUST=$(date +%s) .  

