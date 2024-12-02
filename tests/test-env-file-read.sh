#!/bin/bash

# Load environment variables from .env if it exists and is not empty
if [ -f .env ] && [ -s .env ]; then
    export $(xargs < .env)
fi

# Access and use the variable
echo "Your API key is: $NGC_API_KEY"


result=$(./load_env.sh)
echo "Output from load_env.sh: $result"
