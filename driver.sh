#!/bin/bash

set -euo pipefail

# This is a variable for the container name.
CONTAINER_TAG=codebuild_test

# This is a variable for the AWS Elastic Container Registry (ECR) repository.
ECR_REPOSITORY=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/

# This is a variable for the AWS CloudFormation stack name.
STACK_NAME=CodebuildTest

COMMAND=${1:-}
if [[ -z "$COMMAND" ]] &&
  [[ $COMMAND != "docker-clean-unused" ]] &&
  [[ $COMMAND != "-c" ]] &&
  [[ $COMMAND != "docker-clean-all" ]] &&
  [[ $COMMAND != "build" ]] &&
  [[ $COMMAND != "-b" ]] &&
  [[ $COMMAND != "push" ]] &&
  [[ $COMMAND != "create_stack" ]] &&
  [[ $COMMAND != "-cs" ]] &&
  [[ $COMMAND != "shell" ]] &&
  [[ $COMMAND != "-sh" ]] &&
  [[ $COMMAND != 'query' ]] &&
  [[ $COMMAND != '-q' ]] &&
  [[ $COMMAND != 'process' ]] &&
  [[ $COMMAND != '-p' ]] &&
  [[ $COMMAND != "stop" ]] &&
  [[ $COMMAND != "-s" ]] &&
  [[ $COMMAND != "venv" ]]; then
  echo
  printf "The usage pattern is

  ./driver.sh \033[36m[COMMAND]\033[0m

  COMMANDS:
  \033[36mdocker-clean-unused,-c\033[0m:  Delete unused Docker containers.
  \033[36mdocker-clean-all\033[0m:        Delete *ALL* Docker containers.
  \033[36mbuild,-b\033[0m:                Build the Docker container.
  \033[36mpush\033[0m:                    Push the Docker container to AWS Elastic Container Registry (ECR).
  \033[36mvenv\033[0m:                    Create a Python virtual environment called ia_forecasting_env using venv.
  \033[36mcreate_stack, -cs\033[0m:       Create the AWS CloudFormation stack.
  \033[36mquery,-q\033[0m:                Run query module.
  \033[36mprocess,-p\033[0m:              Run process module.
  \033[36mstop,-s\033[0m:                 Stop the container.
  \033[36mshell,-sh\033[0m:               Open a shell in the container.
"
  exit 1
fi

case $COMMAND in

docker-clean-unused | -c)

  echo
  echo "Deleting all unused Docker containers."
  docker system prune --all --force --volumes
  ;;

docker-clean-all)

  echo
  echo "Deleting *ALL* Docker containers!"
  docker container stop $(docker container ls --all --quiet) && docker system prune --all --force --volumes
  ;;

build | -b)

  echo
  echo "Building the container and tagging it $CONTAINER_TAG."
  docker build --tag $CONTAINER_TAG .
  ;;

push)

  echo
  echo "Building the container and tagging it $CONTAINER_TAG."
  docker build --tag $CONTAINER_TAG .

  echo "Pushing $CONTAINER_TAG container to AWS ECR."
  aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login \
    --username AWS \
    --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
  docker tag $CONTAINER_TAG:latest $ECR_REPOSITORY$CONTAINER_TAG:latest
  docker push $ECR_REPOSITORY$CONTAINER_TAG:latest
  ;;

venv)

  echo
  echo "Creating a Python virtual environment called ia_forecasting_env using venv."
  python3 -m venv ia_forecasting_env
  # source ia_forecasting_env/bin/activate # This didn't work here.  Move it.
  pip install --requirement requirements_ia_forecasting_env.txt
  ;;

create_stack | -cs)

  echo
  echo "Creating CloudFormation stack $STACK_NAME."
  aws cloudformation deploy --template-file ./cloudformation.yaml --stack-name $STACK_NAME \
    --capabilities CAPABILITY_NAMED_IAM --region $AWS_DEFAULT_REGION \
    --parameter-overrides ECRRepository=$ECR_REPOSITORY ContainerTag=$CONTAINER_TAG
  ;;

query | -q)
  echo
  echo "Running query."
  docker run --rm $CONTAINER_TAG pipelinectl query
  ;;

process | -p)
  echo
  echo "Running process."
  docker run --rm $CONTAINER_TAG pipelinectl process
  ;;

shell | -sh)
  echo
  echo "Running shell."

  echo "Opening shell in $CONTAINER_TAG."
  docker run --interactive --tty -v "$(pwd)":/workspace\
    $CONTAINER_TAG /bin/sh
  ;;

stop | -s)

  echo
  echo "Stopping the $CONTAINER_TAG container."
  docker container stop $(docker ps -q --filter ancestor=$CONTAINER_TAG)
  ;;
esac
