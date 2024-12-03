# NVIDIA LLM NIM Demo and Documentation Walkthrough  
This repo shows code to get started using NVIDIA LLM NIM, understand how NIM works when you deploy, and how to navigate the [LLM NIM Documentation](https://docs.nvidia.com/nim/large-language-models/latest/introduction.html).

Watch the [video](https://www.loom.com/share/b74a97428c8643aeaf18710fa2a1c1a6?sid=983d0ec4-1b58-49a6-a527-5549c0627ee7) before getting started as it will help you to dive deeper much faster.

Chapters:
- 0:00 Introduction to LLM NIM Documentation
- 01:14 Reading through the Release Notes
- 02:30 Getting Started 
- 05:14 Deployment Guides and Tutorials
- 06:30 Configuring a NIM
- 08:42 Understanding Optimized Model Profiles
- 13:38 Benchmarking LLMs
- 14:30 NIM Hardware and Software Support Matrix
- 16:30 NIM System Role Prompts, API reference, Function Calling
- 17:34 Understanding the NIM model Cache and Parameter Efficient Finetuning
- 18:53 NIM Demo Walkthrough 

## Getting started with code in Repo
The code in this repo is an adaptation of the code found in the LLM NIM Documentation. You will need an $NGC_API_KEY to proceed, so start [here](https://docs.nvidia.com/nim/large-language-models/latest/getting-started.html). Once you complete this step, you can pull models, and the code in the repo should work. 

**Store NGC Key in .env file**

Once you get your NGC_API_KEY, pull the repo, create a `.env` file (just a file named .env) in the top level of the folder with the following `NGC_API_KEY=<Put key here, remove brackets>`. Save the file, and the code should work.

### Code Description
- 0-verify-installation-state.sh - hosts code to check installation of CUDA, Docker, NVIDIA Docker (using GPUs in a container) and NGC (NVIDIA GPU Cloud) where all the containers reside.
- 1-launch-nims.sh - hosts code to read in your NGC_API_KEY, specify the NIM model to deploy, configure the NIM, see which models work on your machine, query all available models on NGC, launch the NIM
- 2-query-nim.sh - hosts example curl requests from the documentation showing how to specify custom model names 
