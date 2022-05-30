# Cotton

Cotton is a framework for Pulp-like experiences in Lua. It will allow you to use most of the features Pulp has to offer, but instead of being limited by Pulp, this framework is extendible, has LDtk build-in for easy level editing, and more!

<p align="center">
    <img
    src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/environment.png" />
</p>

## Features

Some of the key features you will not see in Pulp but are already available here.

* Easy preconfigured compile functions
* Automatic code formatting on saving to keep your code clean and organised.
* 30 frames per second
* LDtk build-in
* Optionable version control on your project
* FPS Counter
* Different player types (grid, topdown, platformer)
* Caching levels
* Smooth movement

<p align="center">
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/player_grid.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/player_platformer.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/player_topdown.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/movement_smooth.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/camera_follow.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/dialogs.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/bigger_maps.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/big_player.gif" />
</p>

## WIP

Hi! This project is not yet finished, it's still missing some features from Pulp, BUT it's pretty stable and useable!

## Requirements

Make sure you have the following applications installed:

* [Playdate SDK](https://play.date/dev/) 
* [Visual studio code](https://code.visualstudio.com/)
* [LDtk](https://ldtk.io/)

## CottonScript

CottonScript is a scripting library that contains most Pulp features.
Documentation for CottonScript can be found here: [CottonScript](https://github.com/unbelievableflavour/Cotton/blob/master/Docs/CottonScript.md).

## Setting up Cotton

1. Download and install the requirements above.
2. Download [the latest version of Cotton](https://github.com/unbelievableflavour/Cotton/releases) `zip` file.
3. Extract it in the projects folder your choosing.
4. Open the `simple.code-workspace` file. When it asks "do you want to install recommended plugins?" you say yes and do so. ( This will give acces to to features like compile tasks, automatic Lua formatting, etc.)
5. You are now ready to work in the project!

### IMPORTANT FOR WINDOWS

If you are on Windows, some environment vars need to be set before you can compile your games.
Follow [SquidGodDevs video](https://www.youtube.com/watch?v=J0ufxinp7No) TILL 2:04 to set environment vars for Windows.

## Working in Cotton

## Updating Cotton

You can update Cotton in your project at any time IF you did not edit any code in the `core` folder.

1. Download [the latest version of Cotton](https://github.com/unbelievableflavour/Cotton/releases) `zip` file.
2. Extract it somewhere.
3. Replace your `core` folder with the `core` folder from the download.
4. Replace your `main.lua` with the on from the download. BUT keep the old file as reference.
5. Make sure to readd any code you added to `main.lua` yourself.

### Scripting

Open the `simple.code-workspace` to open the scrips of the project in Visual Studio Code.
(Best to start with `simple` workspace. The other workspace just shows you everything.)

Docs can be found in `Docs`. Press the preview button in the topRight corner of your scripting window to have a nicer reading view.

### Creating levels

Open the `map.ldtk` file to open map in LDtk.

### Compile & play

1. Open `VS Code`.
2. Click `Task Runner` from the sidebar.
3. Click `Playdate:Build and Run`

OR (if you didn't install the recommended Task Runner extension)

1. Open `VS Code`.
1. Click `Terminal` from the toolbar.
1. Click `Run task` from the dropdown.
1. Click `Playdate:Build and Run`

## Caching levels

Loading the LDtk levels json files can be a bit slow. However Nic Magnier provided us with a nice little solution to cache your games!
Due to development being easier without cache this setting is disabled by default.

### how to cache

Levels will automatically be cached when the cache is not being used. 

1. Set `useFastLoader` to `false` in `config.lua`.
2. Run the game in the simulator.
3. Cached cached levels are created in your PlayDate game's data directory(`<playdate_sdk_location>/Disk/Data/<yourgame>/LDtk_lua_levels`)

### how to run cached levels

The cached files are saved in in your PlayDate game's data directory. You will have to manually copy it over.

1. Move `<playdate_sdk_location>/Disk/Data/<yourgame>/LDtk_lua_levels` to `<this_project>/Source/levels/LDtk_lua_levels`
2. finally enable the cache by changing `useFastLoader = true` in `config.lua`

## Player type specific settings

Docs are WIP, but works

### Smooth movement

Docs are WIP, but works

## #Diagonal movement

Docs are WIP, but works

## FAQ

**Q: Collider is covering the whole screen after I build cached levels. (also can't move or player is not shown) Whats up?`**

**A:** Better not mix different tile sizes in tile layers! (entities is fine)

## Credit

* [Nic Magnier](https://github.com/NicMagnier) for offering the LDtk library
* Guv_Bubbs for helping out with the docs
