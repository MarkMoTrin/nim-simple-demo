#!/bin/bash



curl -X 'POST' \
    'http://0.0.0.0:8000/v1/completions' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
"model": "meta/llama-3.1-8b-instruct",
"prompt": "Once upon a time",
"max_tokens": 64
}'


# Launch a container with a specified name
docker run -it --rm --name=$CONTAINER_NAME \
  --runtime=nvidia \
  --gpus '"device=1"' \
  --shm-size=16GB \
  -e NGC_API_KEY=$NGC_API_KEY \
  -e NIM_SERVED_MODEL_NAME=mark_test \
  -v "$LOCAL_NIM_CACHE:/opt/nim/.cache" \
  -u $(id -u) \
  -p 8000:8000 \
  $IMG_NAME

curl -X 'POST' \
    'http://0.0.0.0:8000/v1/completions' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
"model": "mark_test",
"prompt": "Once upon a time",
"max_tokens": 64
}'


# -----------------
# Gen ai Perf

export RELEASE="24.10" # recommend using latest releases in yy.mm format
export WORKDIR="/home/mmoyou/Documents/code/nim-demo/perf-results"

docker run -it --net=host --gpus=all -v $WORKDIR:/workdir nvcr.io/nvidia/tritonserver:${RELEASE}-py3-sdk

docker run -it --net=host --gpus='"device=2"' -v $WORKDIR:/workdir nvcr.io/nvidia/tritonserver:${RELEASE}-py3-sdk

--gpus '"device=1"'


export INPUT_SEQUENCE_LENGTH=200
export INPUT_SEQUENCE_STD=10
export OUTPUT_SEQUENCE_LENGTH=200
export CONCURRENCY=50
export MODEL=mark_test

cd /workdir
genai-perf profile \
    -m $MODEL \
    --endpoint-type chat \
    --service-kind openai \
    --streaming \
    -u localhost:8000 \
    --synthetic-input-tokens-mean $INPUT_SEQUENCE_LENGTH \
    --synthetic-input-tokens-stddev $INPUT_SEQUENCE_STD \
    --concurrency $CONCURRENCY \
    --output-tokens-mean $OUTPUT_SEQUENCE_LENGTH \
    --extra-inputs max_tokens:$OUTPUT_SEQUENCE_LENGTH \
    --extra-inputs min_tokens:$OUTPUT_SEQUENCE_LENGTH \
    --extra-inputs ignore_eos:true



curl -X 'POST' \
'http://0.0.0.0:8000/v1/chat/completions' \
   -H 'accept: application/json' \
   -H 'Content-Type: application/json' \
   -d '{
"model": "meta/llama-3.1-8b-instruct",
"messages": [
{
"role": "system",
"content": "You are a helpful assistant."
},
{
"role": "user",
"content": "Who won the world series in 2020?"
}
],
"top_p": 1,
"n": 1,
"max_tokens": 50,
"stream": false,
"frequency_penalty": 1.0,
"stop": ["hello"]
}'