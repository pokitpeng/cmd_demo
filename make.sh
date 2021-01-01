#!/usr/bin/env bash

# exit when err
set -e
# open debug
# set -x

# var
PROJECT_NAME="cmd_demo"

# operating system to run binary program
export GOOS=linux
export CGO_ENABLED=0
# go module
# export GO111MODULE=on
export GOPROXY=https://goproxy.io

BASE_DIR=$(cd $(dirname $0); pwd -P)
commitVersion=$(git rev-parse --short HEAD)
commitCount=$(git log --oneline|wc -l)

# golang build args
GO_LDFLAGS="-w -s "


FuncCheckCommand(){
    # $1: command  , eg: git
    if ! type $1 >/dev/null 2>&1; then
        echo "-bash: $1: command not found"
        exit 1
    fi
}

FuncLog() {
    if [ "$1"x = "red"x ]; then
        echo -e "\033[1;31m"$2"\033[0m"
        elif [ "$1" = "green" ]; then
        echo -e "\033[1;32m"$2"\033[0m"
        elif [ "$1" = "yellow" ]; then
        echo -e "\033[1;33m"$2"\033[0m"
        elif [ "$1" = "blue" ]; then
        echo -e "\033[1;34m"$2"\033[0m"
    else
        echo -e $*
    fi
}

FuncPrepare(){
    ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_IP}
}

FuncScp(){
    FuncLog blue "start scp ..."
    scp -r ${BASE_DIR} ${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR}
}

FuncRunCommand(){
    cmd="rm -rf ${REMOTE_DIR}"
    FuncLog blue "start rm command ${cmd}"
    ssh ${REMOTE_USER}@${REMOTE_IP} ${cmd}
}

FuncRScp(){
    FuncRunCommand
    scp -r ${BASE_DIR} ${REMOTE_USER}@${REMOTE_IP}:${REMOTE_DIR}
}

FuncBuild(){
    go build -ldflags "${GO_LDFLAGS} -X ${PROJECT_NAME}/main.commitVersion=${commitVersion} -X ${PROJECT_NAME}/main.commitCount=${commitCount}" -o ${PROJECT_NAME}
}

FuncRun(){
    FuncBuild
    ./${PROJECT_NAME}
}

FuncTest(){
    if [ $1 == "-h" ]; then
        echo "-v: preview verbose"
        echo "generate coverprofile and open it: go test ./... -coverprofile=c.out && go tool cover -html=c.out"
    else
        go test ./... $1
    fi
}


# The command line help
FuncDisplayHelp() {
    echo "Usage: $0 [option...]" >&2
    echo
    echo "   test               test all project"
    echo "   build              build executable file"
    echo "   help               display help"
    echo
}

# Check if parameters options are given on the commandline
case "$1" in
    test)
        FuncTest $2
    ;;
    build)
        FuncBuild
    ;;
    -h | --help | help)
        FuncDisplayHelp
    ;;
    *)  # No more options
        FuncDisplayHelp
        exit 1
    ;;
esac
