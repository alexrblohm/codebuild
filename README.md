# Pipeline

The package exposes a CLI called with `pipelinectl`. All of the various
tools/commands can be run using this with Docker.

# Requirements

- Python 3
  - This was written using Python 3.7.6, installed on a Mac OS using homebrew.
- [Docker](https://www.docker.com/products/docker-desktop)
  - This was written using version 19.03.5, build 633a0ea.
- [bash](https://www.gnu.org/software/bash/)
  - This was written using GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin17).
- AWS Access 
#TODO 

##Usage of driver.sh

[driver.sh](./driver.sh) [COMMAND] performs specific commands.

For help run the following.
```
./driver.sh
```
```
COMMANDS:
  docker-clean-unused,-c:   Delete unused Docker containers.
  docker-clean-all:         Delete *ALL* Docker containers.
  build,-b:                 Build the Docker container.
  push:                     Push the Docker container to AWS Elastic Container Registry (ECR).
  venv:                     Create a Python virtual environment called ia_forecasting_env using venv.
  create_stack, -cs:        Create the AWS CloudFormation stack.
  query,-q:                 Run query module.
  process,-p:               Run process module.
  stop,-s:                  Stop the container.
  shell,-sh:                Open a shell in the container.
```

0. Build the container locally.  Any code changes will require the container to be rebuilt. 
```
 ./driver.sh build
```

1. Stop the running container. 
```
./driver.sh stop
```

2. query: Locally Run the query module from the pipeline.
```
./driver.sh query
```

3. process: Locally Run the process module from the pipeline.
```
./driver.sh process
```

4. shell: This allows total flexibility to run and test in the container.  For development. 
```
./driver.sh shell
```

5. clean is to clean up your local docker containers and make sure you aren’t taking up too much disk space.  A full clean and rebuild is recommended as often as every day. 
```
./driver.sh docker-clean-unused
./driver.sh docker-clean-all
```

# AWS Usage

## Background

[AWS CloudFormation](https://aws.amazon.com/cloudformation/) is used to create all of the resources (e.g., a CloudWatch log group, AWS Step functions etc.) required to run modules in AWS.

The `Resources` section of [cloudformation.yaml](./cloudformation.yaml) defines those resources.

**These resources should be created or changed only occasionally.  They should not be created every time a job is run.**

## Creating AWS Resources

0. Create a new Python virtual environment called `ia_forecasting_env` in which to run the AWS CLI commands.

```
python3 -m venv ia_forecasting_env
source ia_forecasting_env/bin/activate
pip install --requirement requirements_ia_forecasting_env.txt
```

1. Build the container.
```
./driver.sh -b
```

2. Push the built container to AWS ECR.
```
./driver.sh push
```

3. Create the CloudFormation stack.
```
./driver.sh -cs
```
While the stack has been created, you should see something like this at the command line
![CreateStack.png](./screenshots/CreateStack.png)

5. Once the stack builds, click on the [StateMachine resource](https://console.aws.amazon.com/states/home?region=us-west-1#/statemachines/view/arn:aws:states:us-west-1:644944822023:stateMachine:IApipeline-StateMachine), click "Start execution", and watch things happen.

Logs will be written to the [CloudWatch log group](https://console.aws.amazon.com/cloudwatch/home?region=us-west-1#logStream:group=IApipeline-LogGroup) defined in the stack.

