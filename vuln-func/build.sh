headsha=$(git rev-parse --verify HEAD)

#docker build --build-arg headsha=$headsha --mount source=src.zip,target=/src.zip -t pxp-func:$headsha . 

CONTAINER=$headsha-build-lambda-vuln

mkdir -p output
rm -r output/*

docker run --rm -dit \
	--mount type=bind,source="$(pwd)"/output,target=/tmp/ \
	--name $CONTAINER \
	pxp-runtime-builder:$headsha bash

docker cp src/ $CONTAINER:/src

docker exec $CONTAINER /polyscript-src/s_php /polyscript-src/tok-php-transformer.php -p /src --replace
docker exec $CONTAINER  zip -r /tmp/src.zip /src

docker stop $CONTAINER
