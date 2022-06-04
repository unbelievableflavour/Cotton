# Cotton

Cotton is a framework for Pulp-like experiences in Lua. It will allow you to use most of the features Pulp has to offer, but instead of being limited by Pulp, this framework is extendible, has LDtk build-in for easy level editing, and more!

<p align="center">
    <img
    src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/environment.png" />
</p>

## Features

Some of the key features you find in Cotton.

* A library containing most features that Pulp has to offer ([CottonScript](https://github.com/unbelievableflavour/Cotton/wiki/CottonScript))
* Preconfigured level editor ([LDtk](https://ldtk.io/))
* Runs at 30 frames per second.
* Toggleable FPS counter.
* A versionable project structure for easy git use.
* Custom folder structuring allows for better organizing your project.
* Toggleable player types (grid, topdown, platformer)
* Toggleable smooth movement.
* Preconfigured compile & play buttons in VS code.
* Resizeable levels.
* Easy level caching for fast level loading.
* Automatic code formatting on save to keep your code clean and organised.
* Multi-tile player support.

<p align="center">
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/player_grid.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/player_platformer.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/player_topdown.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/movement_smooth.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/camera_follow.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/camera_follow_locked.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/dialogs.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/bigger_maps.gif" />
    <img src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/big_player.gif" />
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
Documentation for CottonScript can be found here: [CottonScript](https://github.com/unbelievableflavour/Cotton/wiki/CottonScript).

## Setting up Cotton

1. Download and install the requirements above.
2. Download [the latest version of Cotton](https://github.com/unbelievableflavour/Cotton/releases) `zip` file.
3. Extract it in the projects folder your choosing.
4. Open the folder in VS Code, 
5. When it asks you which `workspace` you want to open? Choose `simple.code-workspace`. 
6. When it asks "do you want to install recommended plugins?" You say yes and do so. ( This will give acces to to features like compile tasks, automatic Lua formatting, etc.)
7. You are now ready to work in the project!

### IMPORTANT FOR WINDOWS

If you are on Windows, some environment vars need to be set before you can compile your games.
Follow the [Environment Variables Guide](https://github.com/unbelievableflavour/Cotton/wiki/Environment-Variables-On-Windows) to set the environment variables for Windows.

## Working in Cotton

### Scripting

Make sure `VS Code` with a `Cotton` workspace is open. (`simple` or `advanced` are both fine)

Docs can be found in `Docs`. Press the preview button in the topRight corner of your scripting window to have a nicer reading view.

### Creating levels

Make sure `VS Code` with a `Cotton` workspace is open. (`simple` or `advanced` are both fine)

1. Click `Task Runner` from the sidebar.
2. Click `Playdate: Level Editor`

OR (if you didn't install the recommended Task Runner extension)

1. Click `Terminal` from the toolbar.
2. Click `Run task` from the dropdown.
3. Click `Playdate: Level Editor`

### Compile & play

Make sure `VS Code` with a `Cotton` workspace is open. (`simple` or `advanced` are both fine)

1. Click `Task Runner` from the sidebar.
2. Click `Playdate: Build and Run`

OR (if you didn't install the recommended Task Runner extension)

1. Click `Terminal` from the toolbar.
2. Click `Run task` from the dropdown.
3. Click `Playdate: Build and Run`

## Updating Cotton

You can update Cotton in your project at any time IF you did not edit any code in the `core` folder.

1. Download [the latest version of Cotton](https://github.com/unbelievableflavour/Cotton/releases) `zip` file.
2. Extract it somewhere.
3. Replace your `core` folder with the `core` folder from the download.
4. Replace your `main.lua` with the on from the download. BUT keep the old file as reference.
5. Make sure to readd any code you added to `main.lua` yourself.

### Optional updates

Updating tasks?
1. Replace your `.vscode` folder with the `.vscode` folder from the download.

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

A player type has different options like "smooth movement", "diagonal movement", "player speed", etc. 
Learn more about them here: [Player Types](https://github.com/unbelievableflavour/Cotton/wiki/Player-Types)

## FAQ

**Q: Im getting the following error during compiling. What do I do?**
```bash
> Executing task: Playdate: Build <

Command failed: pdc "c:\Playdate Dev\Cotton-master\source" "c:\Playdate Dev\Cotton-master\Cotton"
'pdc' is not recognized as an internal or external command,
operable program or batch file.

The terminal process failed to launch (exit code: 1).
```
**A:** This means the environment variables have not been set OR the SDK has not been installed correctly.

**Q: Why is my map rendered very big or small when I didn't set the `renderScale`? ?**
**A:** Make sure you didn't name the tilesets the same but with different size. They are cached in the `.pdx` file.
Example:
If you have a tileset `bw_table-16-16.png`, then DONT add a `bw_table-8-8.png`.

To fix:
1. Rename the image 
2. Correct the image paths in `LDtk`,
3. Throw away the `.pdx` file.
4. Build again.

## Credit

* [Nic Magnier](https://github.com/NicMagnier) for offering the LDtk library
* Guv_Bubbs for helping out with the docs
