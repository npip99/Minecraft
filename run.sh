if ! screen -list | grep -q minecraft; then
  screen -S minecraft -dm java -Xmx6144M -Xms1024M -jar minecraft_server.jar nogui
fi
screen -r minecraft

