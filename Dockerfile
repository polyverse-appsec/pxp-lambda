ARG headsha
FROM pxp-runtime-builder:${headsha} as builder

FROM lambci/lambda:provided as runtime

COPY --from=builder /runtime /opt/
