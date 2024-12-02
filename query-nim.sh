#!/bin/bash

# ---------------------------------------------------
# Author: mmoyou@nvidia.com
# Date: 12-01-24
# Usage:
#   This script sends some sample curl commands to a 
#   NIM running on port 8000
# ---------------------------------------------------


echo -e "Simple message to llama 3.1\n"

curl -X 'POST' \
    'http://0.0.0.0:8000/v1/completions' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
"model": "meta/llama-3.1-8b-instruct",
"prompt": "Once upon a time",
"max_tokens": 64
}'

echo -e "\n\nSimple message using system prompt template\n"

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