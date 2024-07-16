# OpenZone

## Overview

OpenZone is a Roblox module designed to manage zones within a game environment. It supports functionalities such as player detection within zones, zone creation, object planting within zones, and more.

## Installation

To install OpenZone, follow these steps:

1. Download the `OpenZone` module.
2. Insert the module into your Roblox project.

## Usage

### Creating a Zone

To create a new zone, you need to call the `OpenZone.new` function and pass a `BasePart` that represents the zone. 

```lua
local zonePart = -- Your BasePart here
local newZone = OpenZone.new(zonePart)
```

### Player Detection

The module can detect when players enter or leave the zone. Bind functions to these events to handle player entry and exit.

```lua
newZone.onPlayerEnter:Connect(function(player)
    print(player.Name .. " has entered the zone")
end)

newZone.onPlayerLeave:Connect(function(player)
    print(player.Name .. " has left the zone")
end)
```

### Getting Players Inside a Zone

You can get a list of players currently inside a zone using the `GetPlayers` method.

```lua
local playersInside, count = newZone:GetPlayers()
print("Players inside the zone:", playersInside)
print("Number of players inside the zone:", count)
```

### Planting Objects in a Zone

To plant objects within a zone, use the `Plant` method. The dataset should include the model to plant, the amount, whether it's stackable, and optional rotation offsets.

```lua
local dataset = {
    Model = -- Your model here,
    Amount = 10,
    Stackable = true,
    MinRotationOffset = 0,
    MaxRotationOffset = 360
}
newZone:Plant(dataset)
```

### Removing Plants

To remove all plants from a zone, use the `RemovePlants` method.

```lua
newZone:RemovePlants()
```

### Generating a Zone Grid

To generate a grid within the zone, use the `Generate` method with the specified size and optional part and grid attributes.

```lua
local datatable = {
    size = Vector3.new(10, 10, 10),
    Part = -- Optional part,
    GridParts = -- Optional grid attributes
}
local objects, gridSize = newZone:Generate(datatable)
```

### Destroying a Zone

To destroy a zone and clean up its resources, use the `Destroy` method.

```lua
newZone:Destroy()
```

## API

### `OpenZone.new(zone: BasePart)`

Creates a new zone.

### `OpenZone:GetPlayers()`

Returns a list of players inside the zone and the count of players.

### `OpenZone:Plant(dataset)`

Plants objects within the zone based on the dataset provided.

### `OpenZone:RemovePlants()`

Removes all planted objects from the zone.

### `OpenZone:Generate(datatable)`

Generates a grid within the zone.

### `OpenZone:Destroy()`

Destroys the zone and cleans up its resources.

## Example

```lua
local HttpService = game:GetService('HttpService')
local RunService = game:GetService('RunService')
local OpenZone = require(game.ServerScriptService.OpenZone)

local zonePart = -- Your BasePart here
local newZone = OpenZone.new(zonePart)

newZone.onPlayerEnter:Connect(function(player)
    print(player.Name .. " has entered the zone")
end)

newZone.onPlayerLeave:Connect(function(player)
    print(player.Name .. " has left the zone")
end)

local playersInside, count = newZone:GetPlayers()
print("Players inside the zone:", playersInside)
print("Number of players inside the zone:", count)

local dataset = {
    Model = -- Your model here,
    Amount = 10,
    Stackable = true,
    MinRotationOffset = 0,
    MaxRotationOffset = 360
}
newZone:Plant(dataset)

newZone:RemovePlants()

local datatable = {
    size = Vector3.new(10, 10, 10),
    Part = -- Optional part,
    GridParts = -- Optional grid attributes
}
local objects, gridSize = newZone:Generate(datatable)

newZone:Destroy()
```

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.


## Video Example
Code: 
```lua
local ServerStorage = game:GetService('ServerStorage')
local OpenZone = require(ServerStorage.OpenZone)

local Zone: OpenZone.Zone = OpenZone.new(workspace.radius)
local fakeZone: OpenZone.Zone = OpenZone.new(workspace.fakezone)

Zone.onPlayerEnter:Connect(function(player)
	fakeZone:Generate({Size = Vector3.new(5,3,5)})
	fakeZone:Plant(
		{
			Model = workspace.Book, 
			Amount = 100, 
			Stackable = true, 
			MinRotationOffset = 0, 
			MaxRotationOffset = 250
		}
	)
end)

Zone.onPlayerLeave:Connect(function(player)
	fakeZone:RemoveFilling()
	fakeZone:RemovePlants()
end)
```

https://github.com/user-attachments/assets/715b7a12-216e-43cb-a236-8ee8d228d1f9

