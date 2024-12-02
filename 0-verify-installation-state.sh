#!/bin/bash

# ---------------------------------------------------
# Check if NVIDIA Drivers are installed
# ---------------------------------------------------
# Check if nvidia-smi output contains 'CUDA'
if nvidia-smi | grep -q "CUDA"; then
    echo -e ">>>> CUDA is installed\n"
    echo -e "Printing GPU Info\n"
    nvidia-smi
    echo -e "\n"
else
    echo -e "CUDA is not installed, please install cuda \n https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html"
fi


# ---------------------------------------------------
# Check if Docker is installed
# ---------------------------------------------------
if ! command -v docker &> /dev/null; then
    echo -e "Docker is not installed. Please install Docker and try again.\n"
    exit 1
fi

echo -e ">>>> Docker is installed.\n"

# Test Docker functionality
echo -e "Testing Docker functionality with 'hello-world' container..."
if docker run --rm hello-world &> /dev/null; then
    echo -e "Docker is installed and functioning correctly.\n"
else
    echo -e "Docker is installed, but there was an issue running a container.\n"
    exit 1
fi

# ---------------------------------------------------
# Check if GPU Docker is installed
# ---------------------------------------------------
# Run the Docker command and capture the output
output=$(docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi 2>&1)

# Check if the output contains "Driver Version"
if echo "$output" | grep -q "Driver Version"; then
    echo ">>>> GPU Docker works: Driver version detected."
else
    echo "GPU Docker does not work: Driver version not found."
    echo "Output of the command:"
    echo "$output"
fi


# ---------------------------------------------------
# Check if NGC is installed
# ---------------------------------------------------

# Capture the output of the command
output=$(ngc user who 2>&1)

# Check if the output contains any data
if [[ -z "$output" ]]; then
    echo "The command returned empty output."
elif echo "$output" | grep -q "User Id"; then
    echo ">>>> The output contains user information which means NGC auth is setup"
else
    echo "The command ran, but no user information was found, so NGC auth is not setup"
fi