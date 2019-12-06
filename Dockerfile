ARG BASE_CONTAINER=jupyter/all-spark-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Adam Jordan <adamyordan@gmail.com>"

USER root

RUN apt-get update && \
    apt-get install -y software-properties-common

RUN add-apt-repository ppa:longsleep/golang-backports && \
    apt-get update && \
    apt-get install -y golang-go libzmq3-dev

USER $NB_UID

RUN GO111MODULE=off go get -d -u github.com/gopherdata/gophernotes

RUN cd "$(go env GOPATH)"/src/github.com/gopherdata/gophernotes && \
    env GO111MODULE=on go install

RUN cd "$(go env GOPATH)"/src/github.com/gopherdata/gophernotes && \
    mkdir -p ~/.local/share/jupyter/kernels/gophernotes && \
    cp -r ./kernel/* ~/.local/share/jupyter/kernels/gophernotes && \
    cd ~/.local/share/jupyter/kernels/gophernotes && \
    sed "s|gophernotes|$(go env GOPATH)/bin/gophernotes|" < kernel.json.in > kernel.json
