sudo apt install update

sudo apt install wget openjdk-8-jdk screen -y

if [ -e ~/minecraft_server ]; then
    echo
    echo "$HOME/minecraft_server exists! Please delete it first!"
    exit
fi

mkdir ~/minecraft_server
cp setup.sh ~/minecraft_server
cp run.sh ~/minecraft_server
cd ~/minecraft_server
wget -O minecraft_server.jar https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar
chmod +x minecraft_server.jar
echo eula=true >> eula.txt
./run.sh

