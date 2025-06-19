# CircleCI Self-Hosted Docker in Docker Runner.

Assumes you are running on a machine with Docker and internet connection.

Assumes you have a Resource Class and a Token for that Class available (export CIRCLECI_DOCKER_TOKEN is the var used in the scripts for your token, edit the resource_class line in the Dockerfile to match your installation

# What does it do?

- This will build a container extending from the Circle CI Machine Runner 3 (https://circleci.com/docs/install-machine-runner-3-on-docker/) and then add in the necessary Docker bits into the container via the Dockerfile. 
- it then starts the container, binding up /var/run/docker.sock and starts a container instance called "circleci-runner-instance"

# How to use 

1 - Setup your Vars and Edit the Dockerfile to match your Configuration in CircleCI
2 - Run ./install-circleci-dind-runner.sh 
3 - Check that things are ok - e.g "docker ps -a", "docker logs -f circleci-runner-instance"
4 - Check your CircleCI Self-hosted Runner page to see that things are well and connected.
