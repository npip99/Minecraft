sudo apt install update

sudo apt install wget openjdk-8-jdk screen -y

filedir=$HOME/forge_server

if [ -e $filedir ]; then
    echo
    echo "$filedir exists! Please delete it first!"
    exit
fi

mkdir $filedir
cp forge-run.sh $filedir/run.sh
cd $filedir
wget -O forge_installer.jar https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.12.2-14.23.5.2854/forge-1.12.2-14.23.5.2854-installer.jar
chmod +x forge_installer.jar
echo eula=true >> eula.txt
java -Xmx6144M -Xms1024M -jar forge_installer.jar nogui --installServer
rm forge_installer.jar
mv forge*.jar forge_server.jar
echo stop | java -Xmx6144M -Xms1024M -jar forge_server.jar nogui
rm -rf world

./run.sh

