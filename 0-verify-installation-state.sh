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





# ---------------------------------------------------
# Check if NGC is installed
# ---------------------------------------------------

# Capture the output of the command
output=$(ngc user who 2>&1)

# Check if the output contains any data
if [[ -z "$output" ]]; then
    echo "The command returned empty output."
elif echo "$output" | grep -q "User Id"----

# Capture "The output contains user information whihc means NGC is setup correctly."
c user who 2>&1)

# Check if the output contains any data
if [[ -z "$output" ]]; then
    echo "The command returned empty output."
elif echo "$output" | grep -q "User Id"; then
    echo "The output contains user information whihc means NGC is setup correctly."
else
    echo e co command ran, but no user information was found inforNGC authentication is not set up correctly."fi