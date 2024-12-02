#!/bin/bash

# ---------------------------------------------------
# Author: mmoyou@nvidia.com
# Date: 12-01-24
# Usage:
#   This script sends some sample curl commands to a 
#   NIM running on port 8000
# ---------------------------------------------------

# Check to see which models are available.
echo -e "Current models loaded as NIMs\n"

curl -X GET 'http://0.0.0.0:8000/v1/models'

# Sending simple message with the custom_name_1
echo -e "\n\n>>>> Simple message to llama 3.1\ with custom_name_1 \n"

curl -X 'POST' \
    'http://0.0.0.0:8000/v1/completions' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
"model": "custom_name_1",
"prompt": "Once upon a time",
"max_tokens": 64
}'


# Using the prompt template
echo -e "\n\n>>>> Simple message using system prompt template\n"

curl -X 'POST' \
'http://0.0.0.0:8000/v1/chat/completions' \
   -H 'accept: application/json' \
   -H 'Content-Type: application/json' \
   -d '{
"model": "custom_name_1",
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



