headsha=$(git rev-parse --verify HEAD)

docker build --build-arg headsha=$headsha   -t lambda-php-test . && docker run lambda-php-test vuln.goodbye '{"payload":"phpinfo();"}'


