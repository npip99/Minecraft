## Minecraft Server Scripts

This repo consists of several scripts that are aimed at automating the creation of Minecraft Servers. The intent is that these run on Ubuntu AWS Servers, and have been tested on such platforms. To begin using this repo, first clone it onto the desired server and then cd into the repo.

## Usage

To create a new vanilla minecraft server, simply run

```
./vanilla-setup.sh -v 1.12.2 -d ~/my_minecraft_server
```

This will create a server of the desired version in the given directory. It will presume that the directory does not exist yet and it will create the directory as needed.

## Forge modpacks

To create a new Forge minecraft server, you may run

```
./forge-setup.sh -d ~/my_modded_minecraft_server
```

And this will use the 1.12.2 forge installer to create the server. Then you may put any desired mods into the `./mods` directory.

If you would like to use versions other than 1.12.2, or if you would like to save custom modpacks for easy reuse, then you should create a .zip with the following directory structure and use the following command:

```
./forge-setup.sh -m my_modpack.zip -d ~/my_modded_minecraft_server
# Note - Only run in a container or using trusted or self-made modpack.zip, as this allows arbitrary execution from a third party
```

```
my_modpack.zip
│   modpack.conf   
|   mods.json
|   server.properties 
│
└───config
    │   forge.cfg
    |   IC2.ini
    |
    └───buildcraft
        | main.cfg
```

Where each of the files have the following representations:

#### modpack.conf

```
FORGE_VERSION=https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.12.2-14.23.5.2854/forge-1.12.2-14.23.5.2854-installer.jar
```

Download links for other versions can be found at http://files.minecraftforge.net/

#### mods.json

```
[
        {
                "name": "JEI",
                "url": "https://edge.forgecdn.net/files/2988/828/jei_1.12.2-4.15.0.296.jar"
        },
        {
                "name": "Buildcraft",
                "url": "https://edge.forgecdn.net/files/2914/534/buildcraft-all-7.99.24.6.jar"
        }
]
```

Download links for other mods can be found by going to [curse forge](https://www.curseforge.com/minecraft/mc-mods). Click a mod, go to `files`, then click `download` for a file of the desired version. Upon download, right click the file from your browser and copy the direct download link itself. `www.curseforge.com` is protected behind CloudFlare, but `edge.forgecdn.net` is not and is the correct download link after CloudFlare redirects you. Any third party direct download link can be used here.

### server.properties

A replacement of the default server.properties file. This file is optional.

### config/*

This will be used as the configuration directory before the server runs for the first time. This directory and any files within it are optional
