#!/bin/bash

check_docker=$(which docker)
check_dagger=$(which dagger)

function test_docker() {
    if [ ! -z "$check_docker" ]
    then
        echo "Docker found..."
    else
        echo "Docker Not found..."
        exit 1
    fi
}

function test_dagger() {
    if [ ! -z "$check_dagger" ]
    then
        echo "Dagger found..."
    else
        echo "Dagger Not found..."
        echo "Installing Dagger..."
        curl -L https://dl.dagger.io/dagger/install.sh | BIN_DIR=$HOME/.local/bin sh
        export PATH="$HOME/.local/bin:$PATH"
    fi
}

function run_linux() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        current_dir=$(pwd)
        CHECK=$(systemctl | grep docker.service | grep running)
        if [ ! -z "$CHECK" ]
        then
            echo "Docker is running..."
            /sbin/modprobe iptable-nat
            systemctl stop docker
            systemctl start docker
            dagger call linux --src=../ export --path="$(dirname $(pwd))/out/smdc_portal"
            dagger call windows --src=../ export --path="$(dirname $(pwd))/out/smdc_portal.exe"
        else
            echo "Starting Docker..."
            /sbin/modprobe iptable-nat
            systemctl start docker
            sleep 3
            dagger call linux --src=../ export --path="$(dirname $(pwd))/out/smdc_portal"
            dagger call windows --src=../ export --path="$(dirname $(pwd))/out/smdc_portal.exe"
        fi
    fi
}

function run_macos() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        CHECK=$(docker images)
        if [ ! -z "$CHECK" ]
        then
            echo "Docker is running..."
            dagger call linux --src=../ export --path="$(dirname $(pwd))/out/smdc_portal"
            dagger call windows --src=../ export --path="$(dirname $(pwd))/out/smdc_portal.exe"
        else
            echo "Docker is not running..."
            exit 1
        fi
    fi
}

test_docker
test_dagger

result=${PWD##*/}
if [[ "$result" == "scripts" ]]
then 
    cd ..
fi

run_linux
run_macos
