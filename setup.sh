sudo apt install update

sudo apt install wget openjdk-8-jdk screen -y

mkdir ~/minecraft_server
rm ~/minecraft_server/setup.sh
rm ~/minecraft_server/run.sh
cp setup.sh ~/minecraft_server
cp run.sh ~/minecraft_server
cd ~/minecraft_server
wget -O minecraft_server.jar https://s3.amazonaws.com/Minecraft.Download/versions/1.11.2/minecraft_server.1.11.2.jar
chmod +x minecraft_server.jar
echo eula=true >> eula.txt
./run.sh

