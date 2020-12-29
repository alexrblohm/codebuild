FROM python:3.7.7-slim-buster
RUN echo 'Pulling base image.'

RUN echo 'Installing dependencies.'
RUN apt-get update && apt-get -y install \
    gcc \
    g++

RUN pip install --upgrade pip

RUN echo 'Installing Python packages.'
ADD requirements.txt /
RUN pip install --requirement /requirements.txt

RUN echo 'Adding everything in the current directory to /workspace.'
COPY . /workspace

RUN echo 'Setting /workspace as WORKDIR.'
WORKDIR /workspace

RUN echo 'Installing the pipeline.'
RUN pip install .

RUN echo 'Setting ENTRYPOINT to /workspace/docker-entrypoint.sh.'
ENTRYPOINT ["/workspace/docker-entrypoint.sh"]
