ARG headsha
FROM pxp-runtime-builder:${headsha} as builder

FROM lambci/lambda:provided as runtime
COPY src /var/task/src
USER root
COPY --from=builder /polyscript-src /polyscript-src
WORKDIR /polyscript-src/

COPY --from=builder /runtime /opt/
RUN /polyscript-src/s_php /polyscript-src/tok-php-transformer.php -p /var/task/src --replace

