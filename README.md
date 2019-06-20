# AWS Lambda PXP Example setup 

## Notes

1. This method relies on [Docker][1] & [img2lambda][2]
2. The build script in this directory will build all functions and push the runtime to aws using the command 
`build.sh -a -p`
3. You can create a non-polyscripted runtime using the command 
`build.sh --polyscript-off`
4. build.sh includes the name and region of the lambda runtime layer, change those as necessary. 
5. After generating the runtime arn & zip.src, it is possible to use the AWS console to create your lambda function.


## Create a function
1. Within the lambda-func directory add your lambda function to the src directory. 
2. Use the ./build.sh -a -p command to build the runtime, publish the runtime, and setup the pxp functions. (See below for more info on the build script)
3. For more information on the pxp-runtime-builder see the [README][3]
4. img2lambda creates an output directory that contains a json and yaml file with the arn of the new runtime.
5. The scrambled lambda function will exist with the directory of the function: lambda-func/output/src.zip
6. Use aws lambda create-function command to push your function to lambda, using the provided runtime created, see the example below -- these steps should be familiar:

```
aws lambda create-function \
    --function-name pxp-example \
    --handler handler.hello \
    --role arn:aws:XXXXXXXX{IAM ROLE}XXXXXXX \
    --zip-file fileb://./lambda-func/output/src.zip \
    --runtime provided \
    --region us-west-2 \
    --layers arn:aws:lambda:XXXXXXXXXXXXXXXXXXXX {PXP RUNTIME}
```

To invoke the function locally:

```
aws lambda invoke \
    --function-name pxp-example \
    --region us-west-2 \
    --log-type Tail \
    --query 'LogResult' \
    --output text \
    --payload '{"name": "World"}' hello-output.txt | base64 --decode
```



## Testing locally

Using Docker gives us the ability to also test our functions locally. Each example lambda function directory includes a Dockerfile and a test.sh script. To test your image locally you can either run the test script as is or reference these scripts for an example on how to run your funciton locally.



### Build Scripts
Each directory contains a build script that will build the necessary components with those directoires.
The root build script, will by default build only the final lambci/lambda docker image.
The following arguments are available for the root build script:



##### OPTIONS
```
-a or --all
	Runs all build scripts for all directories, to add or removed directories from this list, 
	edit the build script to include any additional directies in the $lambda array.

--polyscript-off
	Builds pxp-runtime-builder without polyscripting

-p or --publish
	Publishes lambda-pxp-runtime to aws using img2lambda
```


[1]: docker.com
[2]: https://github.com/awslabs/aws-lambda-container-image-converter 
[3]: https://github.com/polyverse/pxp-lambda/blob/master/pxp-runtime-builder/README.md
