headsha=$(git rev-parse --verify HEAD)

CONTAINER=$headsha-build-lambda

mkdir -p output
rm -r output/*

docker run --rm -dit \
	--mount type=bind,source="$(pwd)"/output,target=/tmp/ \
	--name $CONTAINER \
	pxp-runtime-builder:$headsha bash

docker cp src/ $CONTAINER:/src
if [[ $1 == polyscripted ]]; then
        if ! docker exec $CONTAINER /polyscript-src/s_php /polyscript-src/tok-php-transformer.php -p /src --replace
        then    
                echo "FAILED: Polyscripting not enabled on runtime builder. Rebuild builder with polyscripting enabled"
                exit 1
        fi  
fi
docker exec $CONTAINER  zip -r /tmp/src.zip /src

docker stop $CONTAINER
