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
#   Note the device in the docker run command is set 
#   device=1. You will have to change this to the 
#   device that you want or all the GPUs.
# ---------------------------------------------------

# Load the NGC_API_KEY from the .env file
if [ -f .env ] && [ -s .env ]; then
    export $(xargs < .env)
fi

# ---------------------------------------------------------------------------------
# CHANGE Parameters ==== 
# ---------------------------------------------------------------------------------
PARAMS_DEBUG_FLAG=1                       # Set to 1 to double check the parameters, no NIM will be launched
SPECIFIC_GPU=1                            # Set to the GPU number you see from nvidia-smi otherwise use all. -1 uses all GPUs
CONTAINER_NAME=Llama3-1-8B-Instruct       # Name of the docker container running NIM
Repository=nim/meta/llama-3.1-8b-instruct # Use repository from querying models on NGC
Latest_Tag=1.3                            # Use tag from querying models on NGC           
NIM_SERVED_MODEL_NAME=custom_name_1       # Name of the model used in API request
LOCAL_NIM_CACHE=~/.cache/nim              # Directory where NIM downloads model files
MODEL_PROFILE_QUERY_OUTPUT=./outputs/model_profiles.txt           # Stores a list of available optimized models for a specific model
MODELS_AVAILABLE_CSV=./outputs/ngc_registry_image_list.csv  # Stores a csv of all downloadable models with tags

# Choose a LLM NIM Image from NGC
export IMG_NAME="nvcr.io/${Repository}:${Latest_Tag}"
export LOCAL_NIM_CACHE
export NIM_SERVED_MODEL_NAME
export MODEL_PROFILE_QUERY_OUTPUT
export MODELS_AVAILABLE_CSV
export SPECIFIC_GPU

mkdir -p "$LOCAL_NIM_CACHE" 

# Look up the model-profiles (optimized engines) for the model you are interested in deploying
docker run --rm -e NGC_API_KEY=$NGC_API_KEY $IMG_NAME list-model-profiles > $MODEL_PROFILE_QUERY_OUTPUT

# List all the models available and output as a csv
ngc registry image list --format_type csv nvcr.io/nim/* > $MODELS_AVAILABLE_CSV

echo "Parameter Checklist ----------------------"
echo "The model files are stored in $LOCAL_NIM_CACHE"
echo "The image name is $IMG_NAME"
echo "The container name is $CONTAINER_NAME"
echo "The name of the model to use in the API is $NIM_SERVED_MODEL_NAME"

if [ "$PARAMS_DEBUG_FLAG" -eq 0 ]; then
    echo -e "Debugging is disabled and NIM will be launched.\n"

    if [ "$SPECIFIC_GPU" -eq -1 ]; then
        echo -e "Running on all GPUs\n"

      # Start the LLM NIM. Running on DEVICE=1
      docker run -it --rm --name=$CONTAINER_NAME \
        --runtime=nvidia \
        --gpus all \
        --shm-size=16GB \
        -e NGC_API_KEY=$NGC_API_KEY \
        -v "$LOCAL_NIM_CACHE:/opt/nim/.cache" \
        -e NIM_SERVED_MODEL_NAME=$NIM_SERVED_MODEL_NAME \
        -u $(id -u) \
        -p 8000:8000 \
        $IMG_NAME
    else
        echo -e "Running on GPU $SPECIFIC_GPU\n"
        
        # Start the LLM NIM on a specific GPU
        docker run -it --rm --name=$CONTAINER_NAME \
          --runtime=nvidia \
          --gpus '"device='"$SPECIFIC_GPU"'"' \
          --shm-size=16GB \
          -e NGC_API_KEY=$NGC_API_KEY \
          -v "$LOCAL_NIM_CACHE:/opt/nim/.cache" \
          -e NIM_SERVED_MODEL_NAME=$NIM_SERVED_MODEL_NAME \
          -u $(id -u) \
          -p 8000:8000 \
          $IMG_NAME

    fi # End of if [ "$SPECIFIC_GPU" -eq -1 ]; then
else
    echo -e "Debugging is enabled so NIM won't be launched.\n"
fi # End of if [ "$PARAMS_DEBUG_FLAG" -eq 0 ]; then





