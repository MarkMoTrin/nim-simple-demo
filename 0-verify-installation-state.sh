#!/bin/bash

# Check if nvidia-smi output contains 'CUDA'
if nvidia-smi | grep -q "CUDA"; then
    echo -e "CUDA is installed\n"
    echo -e "Printing GPU Info\n"
    nvidia-smi
    echo -e "\n"
else
    echo -e "CUDA is not installed, please install cuda \n https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html"
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "Docker is not installed. Please install Docker and try again.\n"
    exit 1
fi

echo -e "Docker is installed.\n"

# Test Docker functionality
echo -e "Testing Docker functionality with 'hello-world' container..."
if docker run --rm hello-world &> /dev/null; then
    echo -e "Docker is installed and functioning correctly.\n"
else
    echo -e "Docker is installed, but there was an issue running a container.\n"
    exit 1
fi

