#Building PXP Runtime Layer

You will need [Docker](docker.com) and [img2lambda](https://github.com/awslabs/aws-lambda-container-image-converter) 

The pxp-runtime-builder is a docker image that sets up a docker image that builds the necessary dependencies for boyour pxp lambda function and your matching pxp lambda runtime to ensure that the interpreter in your environment matches only the pxp scramble of your function (and vice versa). This will eliminate the threat of injected arbitray vanilla php from being run.

The build is in charge of:

1. Fetching polyscripting dependencies
2. Scrambling vanilla-php samantics
3. Recompiling vanilla-php with the new semantics into pxp
4. Building a scrambled dictionary


##After building the builder image:
 1. A lambci/lambda docker image can be created and using img2lambda can be push to aws to create a unique pxp lambda runtime. (see root directory of repo)
2. A lambda function can be created. 

Any lambda functions that are created using the same builder image will have a machine pxp instance.





