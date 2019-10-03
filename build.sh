#!/bin/bash
set -e

region=us-west-2 #Runtime Region 
name=pxp-lambda #Runtime Name
MODE="polyscripted"
headsha=$(git rev-parse --verify HEAD)

###add any additional directories include a build.sh within the directory.
lambdas=(lambda-func vuln-func)


for var in "$@"
do
	if [[ $var == "--all" ]] || [[ $var == "-a" ]] 
	then
		ALL=true
	fi
	if [[ $var == "--publish" ]] || [[ $var == "-p" ]]
	then
		PUB=true
	fi
	if [[ $var == "--polyscript-off" ]]
	then 
		MODE=""
	fi
done

echo "building pxp-runtime-builder"
cd pxp-runtime-builder
./build.sh $MODE

if [ $ALL ] 
then
	echo "building lambda functions"
	for i in "${lambdas[@]}"
	do
		echo "building ${i}"	
		cd ../$i
		./build.sh $MODE
	done
	cd ..
fi

### TO BUILD & PUBLISH RUNTIME WITHOUT THIS SCRIPT:
### 1. Run pxp-runtime-builder/build.sh
### 2. docker build --build-arg headsha=$headsha -t lambda-pxp-runtime:$headsha .
### 3. img2lambda -i lambda-pxp-runtime:$headsha -r $region -n $name

echo "building lambda-pxp-runtime"
docker build --build-arg headsha=$headsha -t lambda-pxp-runtime:$headsha .

if [ $PUB ]
then
	echo "pushing runtime to aws" 
	img2lambda -i lambda-pxp-runtime:$headsha -r $region -n $name

	arn=$(cat output/layers.json)
	echo "Created $arn -- saved to output"
fi
