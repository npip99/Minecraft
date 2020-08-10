#!/bin/bash
# Stop script if an error occurs
set -e

# Setup tmp directory
tmp_dir=`mktemp -d`
function cleanup {
    rm -rf "$tmp_dir"
    echo "Deleted temp working directory $tmp_dir"
}

trap cleanup EXIT

function print_usage {
    echo "Usage: $0 -d \$SERVER_DIRECTORY [-m \$MODPACK]"
}

while getopts "hm:d:" opt; do
  case ${opt} in
    m )
      MODPACK_PATH=${OPTARG}
      MODPACK_PATH="$(cd "$(dirname "$MODPACK_PATH")"; pwd)/$(basename "$MODPACK_PATH")"
      echo "Using modpack located at $MODPACK_PATH"
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
      print_usage
      exit 1
      ;;
  esac
done

if [ -z $SERVER_PATH ]; then
    echo "Server directory -d must be provided!"
    print_usage
    exit 1
fi

if [ -e $SERVER_PATH ]; then
    echo
    echo "$SERVER_PATH exists! Please delete it first!"
    exit 1
fi

FORGE_VERSION=https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.12.2-14.23.5.2854/forge-1.12.2-14.23.5.2854-installer.jar

if [ ! -z $MODPACK_PATH ]; then
    IS_USING_MODPACK=true
    if [ ! -e $MODPACK_PATH ]; then
        echo "Modpack file $MODPACK_PATH does not exist!"
	exit 1
    elif [ -f $MODPACK_PATH ]; then
	if unzip -T $MODPACK_PATH; then
	    prev_dir=$(pwd)
	    ln -s $MODPACK_PATH $tmp_dir
	    modpack_basename=$(basename $MODPACK_PATH)
	    cd $tmp_dir
	    unzip $modpack_basename
	    rm $modpack_basename
	    MODPACK_PATH=$tmp_dir
	    cd $prev_dir

	    function cleanup {      
                rm -rf "$tmp_dir"
		echo "Deleted temp working directory $tmp_dir"
	    }

	    trap cleanup EXIT
	else
	    echo "Could not extract file $MODPACK_PATH!"
	    exit 1
	fi
    fi
else
    IS_USING_MODPACK=false
fi

if $IS_USING_MODPACK; then
    if [ ! -f $MODPACK_PATH/modpack.conf ]; then
        echo "modpack.conf does not exist!"
	exit 1
    fi
    export $(cat $MODPACK_PATH/modpack.conf | xargs)
fi

sudo apt update
sudo apt install wget openjdk-8-jdk screen jq -y

mkdir $SERVER_PATH
cp forge-run.sh $SERVER_PATH/run.sh
cd $SERVER_PATH
wget -O forge_installer.jar $FORGE_VERSION
chmod +x forge_installer.jar
echo eula=true >> eula.txt
java -Xmx6144M -Xms1024M -jar forge_installer.jar nogui --installServer
rm forge_installer.jar
mv forge*.jar forge_server.jar

# Copy configuration
if $IS_USING_MODPACK && [ -f $MODPACK_PATH/server.properties ]; then
    echo "Copying server.properties..."
    cp $MODPACK_PATH/server.properties .
fi
if $IS_USING_MODPACK && [ -d $MODPACK_PATH/config ]; then
    echo "Copying config folder..."
    cp -r $MODPACK_PATH/config .
fi

# Downloads all mods
if $IS_USING_MODPACK && [ -e $MODPACK_PATH/mods.json ]; then
    mkdir mods
    cd mods
    for row in $(cat $MODPACK_PATH/mods.json | jq -r '.[] | @base64'); do
        _jq() {
            echo ${row} | base64 --decode | jq -r ${1}
        }
	echo "Installing $(_jq '.name')"
        wget $(_jq '.url')
    done
    cd ..
fi

echo stop | java -Xmx6144M -Xms1024M -jar forge_server.jar nogui
rm -rf world

cleanup()
