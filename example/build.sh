#!/bin/sh

set -e

# format everything
go fmt *.go

# install dependencies and build file
cd ..
go build -a -o example/dd-zipkin-proxy ./example
