# OpenZoneFill Module README

## Overview

The `OpenZone` module is a Lua module for Roblox that facilitates the creation and generation of mining zones. This module allows for the dynamic generation of 3D grids of parts within a defined zone in the Roblox game environment.

## Installation

To use the `OpenZone` module, you need to include it in your Roblox game scripts. Place the `OpenZoneFill` script in an appropriate directory within your game.

## Usage

Here’s how you can use the `OpenZone` module in your scripts:

### Creating a New Zone

To create a new mining zone, call the `OpenZone.new` function with the desired zone (a `BasePart` instance) and an optional `gensize` parameter, which determines the size of the generated parts.

```lua
local RunService = game:GetService('RunService')
local OpenZone = require(path.to.OpenZone)

local zonePart = workspace:WaitForChild('ZonePart') -- Replace 'ZonePart' with your zone part name
local gensize = 2 -- Optional, default is 1

local miningZone = OpenZoneFill.new(zonePart, gensize)
```

### Generating the Zone

Once you have created a mining zone, you can generate it by calling the `Generate` method on the zone instance.

```lua
if miningZone then
    miningZone:Generate()
end
```

## API

### `OpenZone.new(zone: BasePart, gensize: number) -> Zone`

Creates a new mining zone.

- `zone`: A `BasePart` instance representing the zone where parts will be generated.
- `gensize`: (Optional) A number specifying the size of each generated part. Default is 1.

Returns a `Zone` instance.

### `Zone:Generate()`

Generates parts within the zone. The parts are positioned and sized based on the zone's dimensions and the `gensize` parameter.

## Example

```lua
local RunService = game:GetService('RunService')
local OpenZone = require(path.to.OpenZone)

local zonePart = workspace:WaitForChild('ZonePart') -- Your zone part
local gensize = 2 -- Size of the generated parts

local miningZone = OpenZone.new(zonePart, gensize)

if miningZone then
    miningZone:Generate()
end
```

## Types

### `Zone`

A type representing a mining zone.

- `_x`: Number, the X position of the zone.
- `_y`: Number, the Y position of the zone.
- `_z`: Number, the Z position of the zone.
- `set`: Boolean, indicates whether the zone is set.
- `level`: Number, the level of the zone.
- `Objects`: Table, holds objects within the zone.
- `_sizeX`: Number, the X size of the zone.
- `_sizeY`: Number, the Y size of the zone.
- `_sizeZ`: Number, the Z size of the zone.
- `gen_size`: Number, the size of generated parts.

## Contributing

If you have suggestions or improvements, feel free to submit a pull request or open an issue on GitHub.

## License

This module is open-sourced under the MIT license. See the `LICENSE` file for details.

---

This README provides an overview of the `OpenZone` module usage, installation, and API. Adjust the paths and part names according to your game's structure and requirements.
