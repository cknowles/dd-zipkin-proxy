# build the app first
FROM golang:1.11-stretch as builder
WORKDIR /app/

# use docker cache for modules
COPY go.mod go.sum ./
RUN go mod download

COPY . ./
RUN CGO_ENABLED=0 go build -a -o dd-zipkin-proxy ./example

# Create appuser to not run as root
RUN groupadd -g 999 appuser && \
    useradd -ms /bin/bash -r -u 999 -g appuser appuser

# repackage just the binary for runtime
FROM scratch
COPY --from=builder /app/dd-zipkin-proxy /dd-zipkin-proxy
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd

EXPOSE 9411/tcp
# Use an unprivileged user
USER appuser
ENTRYPOINT ["/dd-zipkin-proxy"]