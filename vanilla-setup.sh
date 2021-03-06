#!/bin/bash
# Stop script if an error occurs
set -e

function print_usage {
    echo "Usage: $0 -v \$VERSION -d \$SERVER_DIRECTORY"
}

while getopts "hv:d:" opt; do
  case ${opt} in
    v )
      VERSION=${OPTARG}
      ;;
    d )
      SERVER_PATH=$OPTARG
      ;;
    h )
      print_usage
      exit 0
      ;;
    \? )
      echo "Invalid Option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done

if [ -z $VERSION ]; then
    echo "Version number -v must be provided!"
    print_usage
    exit 1
fi

if [ -z $SERVER_PATH ]; then
    echo "Server directory -d must be provided!"
    print_usage
    exit 1
fi

sudo apt update

sudo apt install curl wget openjdk-8-jdk screen -y

if [ -e $SERVER_PATH ]; then
    echo
    echo "$SERVER_PATH exists! Please delete it first!"
    exit 1
fi

mkdir $SERVER_PATH
cp run.sh $SERVER_PATH
cd $SERVER_PATH
jar_url=$(curl https://mcversions.net/download/$VERSION | sed -r 's/^.*(https:\/\/launcher\.mojang\.com[a-zA-Z0-9\/]*server\.jar).*$/\1/g')
if [[ ! $jar_url =~ ^https://launcher\.mojang\.com[a-zA-Z0-9\/]*server\.jar$ ]]; then
    echo "Jar Url was found to be in the wrong format! $jar_url"
    exit 1
fi
wget -O minecraft_server.jar $jar_url
chmod +x minecraft_server.jar
echo eula=true >> eula.txt

./run.sh

