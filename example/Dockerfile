# build the app first
FROM golang:1.11-stretch

WORKDIR /app/

# use docker cache for modules
COPY go.mod go.sum ./
RUN go mod download

COPY . ./
# RUN CGO_ENABLED=0 GOOS=linux go build -o dd-zipkin-proxy ./example
RUN CGO_ENABLED=0 go build -a -o dd-zipkin-proxy ./example

# repackage just the binary for runtime
FROM scratch
COPY --from=0 /app/dd-zipkin-proxy /dd-zipkin-proxy
EXPOSE 9411/tcp
ENTRYPOINT ["/dd-zipkin-proxy"]