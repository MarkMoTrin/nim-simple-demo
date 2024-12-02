#!/bin/bash

# Specify the path to the outputs folder
outputs_folder="./outputs"

# Check if the outputs folder exists
if [ -d "$outputs_folder" ]; then
    # Clear the files in the outputs folder
    rm -f "$outputs_folder"/*
    echo "Files in the outputs folder have been cleared."
else
    echo "The outputs folder does not exist."
fi