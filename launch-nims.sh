#!/bin/bash

# ---------------------------------------------------
# Author: mmoyou@nvidia.com
# Date: 12-01-24
# Usage:
#   This script launces a simple NIM example using 
#   your NGC_API_KEY. Make sure to place your 
#   NGC_API_KEY inside a .env file on the same level
#   as this file. 
#
#   Note the devide in the docker run command is set 
#   device=1. You will have to change this to the 
#   device that you want or all the GPUs.
# ---------------------------------------------------

# Load the NGC_API_KEY from the .env file
if [ -f .env ] && [ -s .env ]; then
    export $(xargs < .env)
fi

# CHANGE ==== Choose a container name for bookkeeping
export CONTAINER_NAME=Llama3-1-8B-Instruct

# CHANGE ==== The container name from the previous ngc registgry image list command
Repository=nim/meta/llama-3.1-8b-instruct
Latest_Tag=1.3

# Choose a LLM NIM Image from NGC
export IMG_NAME="nvcr.io/${Repository}:${Latest_Tag}"

# Choose a path on your system to cache the downloaded models
export LOCAL_NIM_CACHE=~/.cache/nim
mkdir -p "$LOCAL_NIM_CACHE"

echo "Parameter Checklist ----------------------"
echo "The container name is $LOCAL_NIM_CACHE"
echo "The image name is $IMG_NAME"
echo "The container name is $CONTAINER_NAME"
# echo "The NGC Key is $NGC_API_KEY"

# Start the LLM NIM. Running on DEVICE=1
docker run -it --rm --name=$CONTAINER_NAME \
  --runtime=nvidia \
  --gpus '"device=1"' \
  --shm-size=16GB \
  -e NGC_API_KEY=$NGC_API_KEY \
  -v "$LOCAL_NIM_CACHE:/opt/nim/.cache" \
  -e NIM_SERVED_MODEL_NAME=mark_test, mark_test_2
  -u $(id -u) \
  -p 8000:8000 \
  $IMG_NAME


# ----------------------------------------------------
# UNCOMMENT FOR RUNNING ON ALL AVAILABLE GPUS
# ----------------------------------------------------


# # Start the LLM NIM with ALL GPUS
# docker run -it --rm --name=$CONTAINER_NAME \
#   --runtime=nvidia \
#   --gpus all \
#   --shm-size=16GB \
#   -e NGC_API_KEY=$NGC_API_KEY \
#   -v "$LOCAL_NIM_CACHE:/opt/nim/.cache" \
#   -u $(id -u) \
#   -p 8000:8000 \
#   $IMG_NAME



