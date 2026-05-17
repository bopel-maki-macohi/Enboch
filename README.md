# Enboch

Watching Minecraft mobs and making sure they dont kill you, and getting payed for it!

## Links

- [Gamejolt](https://gamejolt.com/games/enboch/1070390)

## Compiling

This tutorial is assuming you got the code downloaded already.

1. Install [Haxe](https://haxe.org/download/)
1. Run `haxelib --global install hmm`
1. Run `haxelib --global run hmm setup` (This just lets you do `hmm` and not `haxelib run hmm`)
1. Run `hmm install`
1. Run `haxelib run lime setup` (This just lets you do `lime` and not `haxelib run lime`)
1. ADDITIONAL PLATFORM STUFF:
    - Windows
        - Download the [Visual Studio Build Tools](https://aka.ms/vs/17/release/vs_BuildTools.exe)
            - When prompted, select "Individual Components" and make sure to download the following:
            - MSVC v143 VS 2022 C++ x64/x86 build tools
            - Windows 10/11 SDK

    - MacOS
        - [Extra setup stuff](https://lime.openfl.org/docs/advanced-setup/macos/)
        
    - Linux
        - [Extra setup stuff](https://lime.openfl.org/docs/advanced-setup/linux/)
        - [hxvlc setup stuff](https://github.com/MAJigsaw77/hxvlc#dependencies)

    - HTML5 / Web : Nothing exta needed
1. Run `lime test <your platform`>
