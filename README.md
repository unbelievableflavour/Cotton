## Cotton

Cotton is a project example of how a Pulp-like experiences could work in a Lua project. This will allow you to use all the features Pulp has to offer + not be limited by it.

## Requirments
Make sure you have the following applications installed.

1. Playdate SDK https://code.visualstudio.com/
2. Visual studio code https://code.visualstudio.com/
3. LDtk https://ldtk.io/

## Working on the project

### How to script and read the docs
Open the `simple.code-workspace` to open the scrips of the project in Visual Studio Code.
(Best to start with `simple` workspace. The other workspace just shows you everything.)

Docs can be found in `Docs`. Press the preview button in the topRight corner of your scripting window to have a nicer reading view.

### How to creating your map
Open the `map.idtk` file to open map in LDtk.

### How to font
I recommend using the official online Caps tool from Panic. `https://play.date/caps/`

## How to compile & play

1. Open `VS Code`.
1. Click `Terminal` from the toolbar.
1. Click `Run task` from the dropdown.
1. Click `Playdate:Build and Run`

## Features

Here's a little overview. See more details below.

* FPS Counter
* Different player types (grid, topdown, platformer)
* Caching levels
* Smooth movement

## FPS Counter

The FPS counter can be enabled by settings by `showFPS` to `true`

## Different player types

By defaul the application will use grid mode just like Pulp. BUT this framework also supports some other play types! Do know that these are still in WIP and will require a little more tinkering to get right. But the base is there.

```lua
playerType = "grid" -- options: grid, topdown, platformer
```

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

## Smooth movement

Docs are WIP, but works

## Diagonal movement

Docs are WIP, but works

### FAQ
Q: Collider is covering the whole screen after I build cached levels. (also can't move or player is not shown) Whats up?
A: Better not mix different tile sizes in tile layers! (entities is fine)