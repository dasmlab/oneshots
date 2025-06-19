#!/bin/bash
#
# A Simple script to install / setup circle-ci cli and setup CircleCI docker based runner.
#   
# This follows the steps outlined here, where we take the base CircleCI runner3 image and extend it, in our case, we install docker on it :)
#
# NOTE - Make sure you have done an "export CIRCLECI_DOCKER_TOKEN" that represents the Token for the Resource Class you are targetting
#
#  
#

IMAGE_NAME="circleci-dasmlab"

# Build image from Dockerfile
docker build -t ${IMAGE_NAME} --file ./Dockerfile .

# Set the environment variables for our container (they are passed in --env)
CIRCLECI_RUNNER_NAME="dasmlab-circleci-docker-runner"
CIRCLECI_RUNNER_API_AUTH_TOKEN="${CIRCLECI_DOCKER_TOKEN}"


# Run up the runner overall.
#
docker stop circleci-runner-instance
docker rm circleci-runner-instance
docker run -d --name circleci-runner-instance \
	-e CIRCLECI_RUNNER_NAME="${CIRCLECI_RUNNER_NAME}" \
	-e CIRCLECI_RUNNER_API_AUTH_TOKEN="${CIRCLECI_RUNNER_API_AUTH_TOKEN}" \
	-e CIRCLECI_RESOURCE_CLASS="dasmlab/Docker" \
	-e CIRCLECI_API_TOKEN="${CIRCLECI_DOCKER_TOKEN}" \
	-v /var/run/docker.sock:/var/run/docker.sock \
	--privileged \
	${IMAGE_NAME}



