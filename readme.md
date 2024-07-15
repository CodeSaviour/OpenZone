# OpenZoneFill

OpenZoneFill is a Roblox module that allows you to manage and manipulate zones in your game. With this module, you can create, generate, and manage objects within a defined zone, making it easier to handle complex spatial data.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Creating a New Zone](#creating-a-new-zone)
  - [Generating the Zone](#generating-the-zone)
  - [Planting Objects in the Zone](#planting-objects-in-the-zone)
  - [Removing All Objects from the Zone](#removing-all-objects-from-the-zone)
  - [Getting the Top Layer Coordinates](#getting-the-top-layer-coordinates)
- [API Reference](#api-reference)
  - [OpenZone.new](#openzonenew)
  - [OpenZone:GetTopLayer](#openzonegettoplayer)
  - [OpenZone:Plant](#openzoneplant)
  - [OpenZone:RemoveFilling](#openzoneremovefilling)
  - [OpenZone:Generate](#openzonegenerate)
- [License](#license)

## Installation

To use the OpenZoneFill module in your Roblox game, you can insert it as a ModuleScript in your game or require it from a GitHub repository.

## Usage

### Creating a New Zone

```lua
local OpenZone = require(path_to_OpenZone_module)

local someBasePart = -- your BasePart here
local myZone = OpenZone.new(someBasePart)
```

### Generating the Zone

```lua
myZone:Generate(10, nil) -- Generates a grid with part size of 10
```

### Planting Objects in the Zone

```lua
local someModel = -- your Model or BasePart here
myZone:Plant(someModel, 5, 2) -- Plants 5 instances of `someModel` with an offset of 2
```

### Removing All Objects from the Zone

```lua
myZone:RemoveFilling()
```

### Getting the Top Layer Coordinates

```lua
local maxX, maxY, maxZ = myZone:GetTopLayer()
```

## API Reference

### OpenZone.new

Creates a new zone.

#### Parameters

- `zone` (BasePart): The base part defining the zone.

#### Returns

- `Zone`: A new zone object.

### OpenZone:GetTopLayer

Gets the top layer coordinates of the zone.

#### Returns

- `number, number, number`: The maximum X, Y, and Z coordinates in the zone.

### OpenZone:Plant

Plants objects within the zone.

#### Parameters

- `object` (Model | BasePart): The object to be planted.
- `amount` (number): The number of objects to plant.
- `offset` (number, optional): The offset for the placement of objects.

### OpenZone:RemoveFilling

Removes all objects from the zone.

### OpenZone:Generate

Generates the zone with parts.

#### Parameters

- `size` (number): The size of each generated part.
- `Part` (BasePart, optional): The template part to use for generation. If not provided, a new Part will be created.

#### Returns

- `table, Vector3`: A table of generated objects and their highest coordinates or `false` on failure.
