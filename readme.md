# OpenZoneFill

OpenZoneFill is a Roblox module designed to dynamically generate a 3D grid of parts within a specified zone. This module can be used for various purposes such as creating mining areas, building grids, or any other spatial partitioning tasks in your Roblox game.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [API Reference](#api-reference)
  - [OpenZone.new](#openzonenew)
  - [OpenZone:Generate](#openzonegenerate)
- [Contributing](#contributing)
- [License](#license)

## Installation

To use the OpenZoneFill module in your Roblox project, follow these steps:

1. Clone or download this repository.
2. Place the `OpenZoneFill` module script into your Roblox game's `ServerScriptService` or any other appropriate service.

## Usage

Here is a basic example of how to use the OpenZoneFill module:

```lua
local OpenZoneFill = require(game.ServerScriptService.OpenZoneFill)

local zonePart = workspace:WaitForChild("ZonePart") -- Replace with your zone BasePart
local zone = OpenZoneFill.new(zonePart, 2) -- Second parameter is the generation size (optional)

zone:Generate()
```

## API Reference

### `OpenZone.new(zone: BasePart, gensize: number) -> Zone`

Creates a new `Zone` object.

#### Parameters:

- `zone` (BasePart): The BasePart that defines the zone.
- `gensize` (number, optional): The size of each generated part in the grid. Default is 1.

#### Returns:

- `Zone`: A new Zone object.

#### Example:

```lua
local zonePart = workspace:WaitForChild("ZonePart")
local zone = OpenZoneFill.new(zonePart, 2)
```

### `OpenZone:Generate() -> table`

Generates the 3D grid of parts within the zone.

#### Returns:

- `table`: A nested table structure containing the generated parts.
- `false`: If the generation fails.

#### Example:

```lua
local zone = OpenZoneFill.new(zonePart, 2)
local objects = zone:Generate()
if objects then
    print("Zone generated successfully!")
else
    print("Zone generation failed.")
end
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.

---

For more detailed information, visit the [Wiki](#) or contact the repository owner.
