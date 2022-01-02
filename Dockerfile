ARG VERSION="v7.2.1"

FROM alpine:3.15.0 as builder

ARG VERSION

WORKDIR /work/
RUN apk --no-cache update && \
    apk --no-cache add curl=7.80.0-r0 && \
    curl -LO https://github.com/oauth2-proxy/oauth2-proxy/releases/download/${VERSION}/oauth2-proxy-${VERSION}.linux-amd64.tar.gz && \
    tar zxvf oauth2-proxy-${VERSION}.linux-amd64.tar.gz

FROM gcr.io/distroless/static-debian11 as runner

ARG VERSION

EXPOSE 4180
COPY --from=builder /work/oauth2-proxy-${VERSION}.linux-amd64/oauth2-proxy /app/
ENTRYPOINT ["/app/oauth2-proxy"]
