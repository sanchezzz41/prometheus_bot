FROM golang:1.10.3-alpine3.7 as builder
RUN \
    cd / && \
    apk update && \
    apk add --no-cache git ca-certificates make tzdata && \
    git clone https://github.com/sanchezzz41/prometheus_bot && \
    cd prometheus_bot && \
    go get -d -v && \
    CGO_ENABLED=0 GOOS=linux go build -v -a -installsuffix cgo -o prometheus_bot 

FROM alpine:3.9
COPY --from=builder /prometheus_bot/prometheus_bot /
RUN apk add --no-cache ca-certificates tzdata tini
USER nobody
EXPOSE 9087
ENV Proxy_Url=none
ENV Proxy_Username=none
ENV Proxy_Password=none
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/prometheus_bot"]
