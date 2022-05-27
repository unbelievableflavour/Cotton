# CottonScript <!-- omit in toc -->

CottonScript is a friendly scripting library that allows you to add Pulp-like interactivity to your Lua games. Its syntax is terse but powerful. A good rule of thumb when writing CottonScript is do less, less often.

## Table of Contents <!-- omit in toc -->

- [General](#general)
  - [Comments](#comments)
  - [Handling events](#handling-events)
  - [Variables](#variables)
  - [Math](#math)
  - [Control Flow](#control-flow)
    - [Conditionals](#conditionals)
    - [Loops](#loops)
    - [Returning](#returning)
  - [Persistent storage](#persistent-storage)
  - [event](#event)
  - [config](#config)
  - [datetime](#datetime)
  - [String formatting](#string-formatting)
- [Functions](#functions)
  - [log](#log)
  - [dump](#dump)
  - [say](#say)
  - [menu](#menu)
  - [fin](#fin)
  - [wait](#wait)
  - [tell](#tell)
  - [ignore/listen](#ignorelisten)
  - [act](#act)
  - [hide](#hide)
  - [show](#show)
  - [sound](#sound)
  - [store](#store)
  - [restore](#restore)
  - [toss](#toss)
- [Math functions](#math-functions)
  - [random](#random)
  - [floor](#floor)
  - [ceil](#ceil)
  - [round](#round)
  - [sine](#sine)
  - [cosine](#cosine)
  - [tangent](#tangent)
  - [radians](#radians)
  - [degrees](#degrees)
- [More functions](#more-functions)
  - [invert](#invert)
  - [isSolid](#issolid)

## General

### Comments

You can comment your Lua with two dashes:

```lua
-- this is a comment
```

Comments can appear on their own line or after a valid expression.

### Handling events

Event handlers are written like so:

```lua
function eventName()
    -- something
end
```
In addition to a handful of built-in events, you can also declare your own custom functions like so:

```lua
function self:aCustomFunctionName()
    -- something
end
```
and trigger them from the current entity with:

```lua
self:eventName()
```

or for all tiles that implement a particular event with:

```lua
-- emitting is currently not supported yet
```

These are the built-in events:

* `load`: called once on the game, each room, and each tile when all assets are first loaded
* `start`: called once on the game after all rooms and tiles have handled their load event
* `enter`: called on the game, the current room, and each tile in the current room every time the Player enters a new room
* `exit`: called on the game, the current room, and each tile in the current room every time the Player exits the current room
* `finish`: called once on the game when the game is completed
* `loop` : called on the game, 30 frames per second, before anything else is done that frame (except when a say text box or menu is on screen)
* `update`: called on the Player every time they move or interact with something
* `bump`: called on the Player every time they bump into a solid world tile
* `confirmPressed`: called on the Player when the A button is pressed
* `confirmReleased`: called on the Player when the A button is released
* `cancelPressed`: called on the Player when the B button is pressed
* `cancelReleased`: called on the Player when the B button is released
* `crank`: called on the Player when the crank is turned
* `dock`: called on the Player when the crank is docked
* `undock`: called on the Player when the crank is undocked
* `draw`: called on the Player 30 frames per second, before drawing
* `interact`: called on an entity when the Player bumps into or acts upon it
* `collect`: called on an entity when the Player steps onto or acts upon it
* `change`: NOT-YET-SUPPORTED called on the game when the cursor moves to a different option in a menu or ask menu and when the menu first appears
* `select`: NOT-YET-SUPPORTED called on the game when the player selects an option in a menu or ask menu
* `dismiss`: NOT-YET-SUPPORTED called on the game when the player dismisses a menu submenu
* `invalid`: NOT-YET-SUPPORTED called on the game when the player attempts to back out of an ask menu or selects an empty option

There is one more special catch-all event:

* `any`: NOT-YET-SUPPORTED called before any event the game or a tile may receive
This is useful with the `mimic` NOT-YET-SUPPORTED function to allow one tile to behave exactly like another without having to copy/paste behavior.

### Variables

All uninitialized variables have a default value of 0. Variables can hold a number or a string. 

Variables are initialized like so:

```lua
local varName = nil
```

And assigned like so:

```lua
varName = 0
```

Strings can be wrapped in double or single quotes. But for consistency I recommend using only on of the two: 

```lua
varName = "some string"
```
or
```lua
varName = 'some string'
```

### Math

Lua supports simple arithmetic operations.

Variables can be incremented or decremented like so:

```lua
varName = varName + 1 -- now equals 1
varName = varName - 1 -- equals 0 again
```

You can add to or subtract from a variable like so:

```lua
varName = varName + 4 -- now equals 4
varName = varName - 3 -- now equals 1
```

You can also multiply or divide a variable like so:

```lua
varName = varName * 6 -- now equals 6
varName = varName / 3 -- now equals 2
```

Compound expressions are also supported like so:
```lua
varName = varName + 1 * 2 -- now equals 2
varName = varName - 1 + 1 - 1 -- equals 0 again
```

### Control Flow

#### Conditionals

Conditionals in PulpScript take the following form:

```lua
if varName == 0 then
    -- handle 0
elseif varName == 1 then
    -- handle 1
else
    -- handle all other values
end
```

Both the `elseif [condition] then` and `else` are optional. The following boolean comparisons are available:

* `==`: equal to
* `~=`: not equal to
* `>`: greater than
* `<`: less than
* `>=`: greater than or equal to
* `<=`: less than or equal to

String comparisons are case-sensitive. This also applies to functions, room, and tile names when used as arguments for functions.

Compound expressions are supported like so:
```lua
if varName1 == 0 and varName2 == 0 then
    -- do something when varName1 and varName2 are both 0
end
```

#### Loops
CottonScript also includes a while loop which can be thought of as a repeating if:

```lua
while varName==0 do
    -- repeat until varName is set to another value
end
```

#### Returning
CottonScript does has user-defined functions and event handlers return values. They can be exited early with

```lua
while varName==0 do
    ticks = ticks + 1
    if ticks<interval then
        return -- return from the "while" loop 
    end

    ticks = ticks - interval

    -- do something at a regular interval
end
```

### Persistent storage

Variables can be persisted across launches using the `store` and `restore` functions. A game’s persistent storage file can be found in the following locations, for the Playdate Simulator:
`<SDKRoot>/Disk/Data/com.<author>.<name>/store.json`

and on the hardware:
`/Disk/Data/com.<author>.<name>/store.json`

### event

NOT-YET-SUPPORTED

### config

In Pulp there is a config variable which can be used to override some of Pulp’s default behaviors in the game script. For Cotton we have a file called `config.lua` where we configure all those variables.

```lua
config.autoAct = true
```
Controls whether the Player automatically interacts with sprites. The default value is `true`. When set to `false` you can use the act function to interact with the sprite or collect the item directly in front of the Player (usually from the Player’s confirm event handler).

```lua
config.inputRepeat = true
```
NOT-YET-SUPPORTED Controls whether button events fire repeatedly while held. The default value is `true`. When set to 0 button events only fire once when first pressed.

```lua
config.inputRepeatDelay = 0.4
```
NOT-YET-SUPPORTED Controls the time from the initial press to the first repeat.

```lua
config.inputRepeatBetween = 0.2
```
Controls the time between all subsequent repeats.

```lua
config.cameraFollow = false
```
Controls whether the camera follows the Player. The default value is `false`. When set to `true` the Player is drawn in the center of the screen and all other tiles are drawn relative to its centered position.

```lua
config.followCenterX = 12
config.followCenterY = 7
```
NOT-YET-SUPPORTED Controls where the “center” of the screen is located. The default coordinates are the middle of the screen, `12`,`7`.

```lua
config.cameraFollowOverflowColor = "black"
```
Controls which color is drawn beyond the room’s borders when the camera is following the Player. The default is `black`.

```lua
config.cameraFollowOverflowImage = nil
```
Controls if an image is drawn beyond the room’s borders when the camera is following the Player. The default is `nil`. But can be set to any image in the `Images` folder by adding `Images/<yourimagename>` as value.

The custom drawing functions are unaffected by the follow members (as they are primarily intended for stationary HUD elements). To offset the custom drawing functions subtract `event.px` and add `config.followCenterX` to the `x` coordinate and subtract `event.py` and add `config.followCenterY` to the `y` coordinate.

```lua
config.allowDismissRootMenu = `false`
```
Controls whether the menu at the bottom of a menu stack can be dismissed. The default value is `false`. When set to `true` the root menu can be dismissed by pressing the B button.

```lua
config.sayAdvanceDelay = 0.2
```
NOT-YET-SUPPORTED Controls the amount of time that must elapse before the player can advance or dismiss a text window. The default value is 0.2 seconds. This can help prevent the player from accidentally dismissing text before they have a chance to read it.

```lua
config.useFastLoader = false
```
Controls the usage of cached files. Levels will automatically be cached when tthe cache is not being used. The default value  is `false`. When set to `true` the cached levels will be used. This will increase performance on actual device. More information about the caching levels is found in the [https://github.com/unbelievableflavour/Cotton](Cotton Readme)

```lua
config.playerType = "grid"
```
Controls which type of player will spawn. The default value is `grid`. Options are: `grid`, `topdown`, `platformer`

```lua
config.font = "Pulp"
```
Controls the font being used throughout the game. Fonts are read from the `fonts` folder.

```lua
config.showFPS = "false
```
Controls if the FPS counter is enabled. The default value  is `true`. When set to `false` the FPS counter will not be rendered.

### datetime

```lua
datetime()
```

The `datetime` function has the following members reflecting the current time:
    
`year`: 1900-10,000
`month`: 1-12
`day`: 1-31
`weekday`: 0-6
`hour`: 0-23
`minute`: 0-59
`second`: 0-59
`millisecond`: 0-600

and 

```lua
timestamp()
```

return seconds since midnight (hour 0), January 1 2000 UTC

### String formatting

You can include variable values in a string by wrapping the variable name in curly braces:

```lua
log("count is now set to " .. count)
```

## Functions

### log

```lua
log("message")
```

Logs message to the console. You can include variable values in log.

### dump

```lua
dump()
```

Logs the current values contained in the `config`, and persistent storage.

### say

```lua
say("message")
```

and

```lua
say("message", function()
    -- do something after the text box is dismissed
end)
```

Displays `message` in a text box.

The text box can optionally be manually positioned and sized:
```lua
say("message", x, y)
```
or
```lua
say("message", x, y, w, h)
```

### menu

```lua
menu(x,y,w,h, {
    {
      name = "optionOne",
      callback = (function()
        -- do one thing
      end)
    },
    {
      name = "optionTwo",
      callback = (function()
        -- do another
      end)
    }
})
```

Presents a paginated menu with one or more options at `x`,`y`. `w` and `h` are optional and specify the width and height of the menu minus chrome tiles and cursor. Menu options are selected by pressing the A button. Submenus can be dismissed by pressing the B button. By default the root menu cannot be dismissed. Set `config.allowDismissRootMenu` to `true` to allow the root menu to be dismissed by pressing B.

### fin

```lua
fin("message")
```

Displays message in a text and marks the game as finished. Also triggers the finish event.

### wait

```lua
wait(duration, function()
    -- do something after duration seconds
end)
```

Note that this does not stop the run loop. If you do not want the player to be able to move during the pause you can call `ignore` before the `wait` call and `listen` at the end of its body.

### tell

```lua
local otherTile = tell("id-of-the-other-tile")
otherTile:eventName()
```

### ignore/listen

```lua
ignore()
```  
and
```lua
listen()
```

Toggle whether the game should accept user input or not. Does not affect advancing or dismissing text.

### act

```lua
act()
```

Make the player interact with the sprite or collect the item one tile in front of them based on their last movement direction. Note that this function is only really useful if you’ve set config.autoAct to `false`.

### hide

```lua
hidePlayer()
```

Prevents the Player from being drawn. Can only be called from the `Player` entity.

### show

```lua
showPlayer()
```

Makes sure the Player is being drawn. Can only be called from the `Player` entity.

### sound

```lua
sound("audioFileName")
```

Plays the sound matching ```audioFileName.<extension>``` located in ```Source/sounds```.

You can also decrease the volume of the sound.
Do:
```lua
sound("audioFileName", 0.5)
```

### store

```lua
store()
```
Copies the current value of the global `save` variable into persistent storage.

### restore

```lua
restore()
```

Sets the global `save` variable to the `save` values from persistent storage.

### toss
```lua
toss()
```

Deletes the storage file.

## Math functions

### random
```lua
local varName = math.random (max)
```
or
```lua
local varName = math.random (min, max)
```
Returns an integer between the positive integers `min` (or 0) and `max` inclusive.

### floor
```lua
local varName = math.floor(num)
```
Returns the largest integer less than or equal to the given number.

### ceil
```lua
local varName = math.ceil(num)
```
Returns the next largest integer greater than or equal to the given number.

### round
```lua
Not supported
```
Round is not supported by the math library. Though you could use `ceil` and `floor` as alternatives.

### sine
```lua
local varName = math.sine(num)
```
Returns the sine of the given number (in radians).

### cosine
```lua
local varName = math.cos(num)
```
Returns the cosine of the given number (in radians).

### tangent
```lua
local varName = math.tan(num)
```
Returns the tangent of the given number (in radians).

### radians
```lua
local varName = math.rad(num)
```
Returns the given number (in degrees) converted to radians.

### degrees
```lua
local varName = math.deg(num)
```
Returns the given number (in radians) converted to degrees.

## More functions

### invert

```lua
invert()
```
or
```lua
local varName = invert()
```

Causes all drawing to be inverted (white displays as black and vice versa) until called again. Returns `true` when drawing is inverted and `false` when drawing is not inverted.

### isSolid
```lua
local varName = isSolid(entity)
```

Returns `true` if the entity identified by coordinates, id, or name is solid, otherwise returns `false`.
