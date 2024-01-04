#!/bin/bash

if [ ! "$#" -eq 1 ]; then
    echo "Usage: $0 <llama_cpp_python_version>"
    exit 1
fi

SERVER_VERSION=$1

docker build --build-arg SERVER_VERSION=$SERVER_VERSION -t cuda_simple .
docker tag cuda_simple:latest jmformenti/llama-cpp-python-cuda:v$SERVER_VERSION
docker push jmformenti/llama-cpp-python-cuda:v$SERVER_VERSION
