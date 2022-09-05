<p align="center">
    <img
    src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/banner.png" 
    alt="Cotton" 
    />
    <img width="190" src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/player_grid.gif" />
    <img width="190" src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/player_platformer.gif" />
    <img width="190" src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/player_topdown.gif" />
    <img width="190" src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/movement_smooth.gif" />
    <img width="190" src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/camera_follow.gif" />
    <img width="190" src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/camera_follow_locked.gif" />
    <img width="190" src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/dialogs.gif" />
    <img width="190" src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/bigger_maps.gif" />
    <img width="190" src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/showcase/big_player.gif" />
</p>

Cotton is a framework for Pulp-like experiences in Lua. It will allow you to use most of the features Pulp has to offer, but instead of being limited by Pulp, this framework is extendible, has LDtk build-in for easy level editing, and more!

<p align="center">
    <img
    src="https://raw.githubusercontent.com/unbelievableflavour/cotton/master/Docs/images/environment.png" 
    alt="environment" 
    />
</p>

## Features

Some of the key features you find in Cotton.

* A library containing most features that Pulp has to offer ([CottonScript](https://github.com/unbelievableflavour/Cotton/wiki/CottonScript))
* Preconfigured level editor ([LDtk](https://ldtk.io/))
* Runs at 30 frames per second.
* Integrated scene management for easy switching out of the game into a cutscene and back.
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
* Panels library support.

## Requirements

Make sure you have the following applications installed:

* [Playdate SDK](https://play.date/dev/) 
* [Visual studio code](https://code.visualstudio.com/)
* [LDtk](https://ldtk.io/)

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
Follow the [Environment Variables Guide](https://github.com/unbelievableflavour/Cotton/wiki/How-to:-Setup-environment-variables) to set the environment variables for Windows.

## Working in Cotton

### Scripting

Make sure `VS Code` with a `Cotton` workspace is open. (`simple` or `advanced` are both fine)

Docs can be found in `Docs`. Press the preview button in the topRight corner of your scripting window to have a nicer reading view.

### Creating levels

Make sure `VS Code` with a `Cotton` workspace is open. (`simple` or `advanced` are both fine)

1. Click `Task Runner` from the sidebar.
2. Click `Playdate: Level Editor`
3. Click the `Load` button
4. Open the `<your-project-folder>/Source/levels/world.ldtk`

### Compile & play

Make sure `VS Code` with a `Cotton` workspace is open. (`simple` or `advanced` are both fine)

1. Click `Task Runner` from the sidebar.
2. Click `Playdate: Build and Run`

### Working in Cotton without the recommended Task Runner Extension?

Want to use the native tasks function of VS code? Also possible just check the tutorial here:
[without task runner extension](https://github.com/unbelievableflavour/Cotton/wiki/Working-in-Cotton-without-the-Task-Runner-Extension)

## Wiki

Since Cotton has a pretty extensive feature list. We created a official wiki for all documentation.
You can find it here: [Wiki](https://github.com/unbelievableflavour/Cotton/wiki).

## FAQ

The FAQ can be found here: [FAQ](https://github.com/unbelievableflavour/Cotton/wiki/FAQ).

## CottonScript

CottonScript is a scripting library that contains most Pulp features.
Documentation for CottonScript can be found here: [CottonScript](https://github.com/unbelievableflavour/Cotton/wiki/CottonScript).

## Credit

* [Nic Magnier](https://github.com/NicMagnier) for offering the LDtk library
* Guv_Bubbs for helping out with the docs
