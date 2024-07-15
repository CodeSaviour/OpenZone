# OpenZoneFill Documentation

## Overview

OpenZoneFill is a module that allows you to manage and manipulate zones in Roblox. It enables you to create, generate, and manage objects within a defined zone, making it easier to handle complex spatial data within your game.

## Services Used

```lua
local HttpService = game:GetService('HttpService')
local RunService = game:GetService('RunService')
```

## OpenZone Module

### Zone Type Definition

```lua
export type Zone = {
    _x: number;
    _y: number;
    _z: number;
    set: boolean;
    level: number;
    Objects: {};
    _sizeX: number;
    _sizeY: number;
    _sizeZ: number;
    gen_size: number;
}
```

### OpenZone.new

Creates a new zone.

```lua
function OpenZone.new(zone: BasePart)
    assert(zone, "No zone specified")

    local BillboardsFolder = Instance.new('Folder')
    BillboardsFolder.Name = "OpenZoneID:_"..HttpService:GenerateGUID(false)
    BillboardsFolder.Parent = workspace

    local Plants = Instance.new('Folder')
    Plants.Name = "Planted"
    Plants.Parent = BillboardsFolder

    if zone then
        local _zone: Zone = setmetatable({
            _x = zone.Position.X;
            _y = zone.Position.Y;
            _z = zone.Position.Z;
            set = false;
            level = 0;
            Objects = {};
            _sizeX = zone.Size.X;
            _sizeY = zone.Size.Y;
            _sizeZ = zone.Size.Z;
            zonefolder = BillboardsFolder;
            zoneplants = Plants
        }, OpenZone)

        return _zone
    end
end
```

### OpenZone:GetTopLayer

Gets the top layer coordinates of the zone.

```lua
function OpenZone:GetTopLayer()
    local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge

    local function scan(coords)
        for index, value in pairs(coords) do
            local num = tonumber(index:sub(2))
            if index:sub(1,1) == "X" and num > maxX then
                maxX = num
            elseif index:sub(1,1) == "Y" and num > maxY then
                maxY = num
            elseif index:sub(1,1) == "Z" and num > maxZ then
                maxZ = num
            end

            if typeof(value) == "table" then
                scan(value)
            end
        end
    end

    scan(self.Objects)
    return maxX, maxY, maxZ
end
```

### OpenZone:Plant

Plants objects within the zone.

```lua
function OpenZone:Plant(object: Model | BasePart, amount: number, offset)
    local x,y,z = self:GetTopLayer()
    if not offset then offset = 0 end
    
    for count = 1, amount do
        local _obj = self.Objects["X"..math.random(0, x)]["Y"..y]["Z"..math.random(0, z)]
        if not _obj:FindFirstChild('Planted') then
            local size = object:GetExtentsSize()
            local planted = Instance.new('ObjectValue')
            
            object = object:Clone()
            object.Parent = self.zoneplants
            
            planted.Value = object
            planted.Parent = _obj
            planted.Name = "Planted"
            object:PivotTo(_obj.CFrame + Vector3.new(1, (size.Y/2) + (_obj.Size.Y/2), 1) + Vector3.new(0, 0, -offset, offset))
        end    
    end
end
```

### OpenZone:RemoveFilling

Removes all objects from the zone.

```lua
function OpenZone:RemoveFilling()
    local function action(obj)
        for _, Another in pairs(obj) do
            if typeof(Another) == "table" then
                action(Another)
            else
                Another:Destroy()
            end
        end
    end

    action(self.Objects)
    self.Objects = {}
end
```

### OpenZone:Generate

Generates the zone with parts.

```lua
function OpenZone:Generate(size: number, Part: BasePart)
    local Zone: Zone = self
    if Zone then
        Zone.gen_size = size

        local highestx = math.floor(Zone._sizeX / Zone.gen_size)
        local highesty = math.floor(Zone._sizeY / Zone.gen_size)
        local highestz = math.floor(Zone._sizeZ / Zone.gen_size)

        local success, fail = pcall(function()
            for x = 0, highestx - 1 do
                Zone.Objects["X"..x] = {}
                for y = 0, highesty - 1 do
                    Zone.Objects["X"..x]["Y"..y] = {}
                    for z = 0, highestz - 1 do
                        local part
                        
                        if Part then 
                            part = Part:Clone()
                        else
                            part = Instance.new('Part')
                        end
                        
                        part.Size = Vector3.new(Zone.gen_size, Zone.gen_size, Zone.gen_size)
                        part.Position = Vector3.new(
                            Zone._x - (Zone._sizeX / 2) + (x * Zone.gen_size) + (Zone.gen_size / 2),
                            Zone._y - (Zone._sizeY / 2) + (y * Zone.gen_size) + (Zone.gen_size / 2),
                            Zone._z - (Zone._sizeZ / 2) + (z * Zone.gen_size) + (Zone.gen_size / 2)
                        )
                        part.Name = "X"..x.."Y"..y.."Z"..z
                        part.Parent = self.zonefolder
                        part.Anchored = true
                        Zone.Objects["X"..x]["Y"..y]["Z"..z] = part
                    end
                end
                RunService.Heartbeat:Wait()
            end
        end)

        if success then
            return Zone.Objects, Vector3.new(highestx, highesty, highestz)
        elseif fail then
            return false
        end
    end
end
```

## Usage

1. **Create a new zone:**

    ```lua
    local myZone = OpenZone.new(someBasePart)
    ```

2. **Generate the zone:**

    ```lua
    myZone:Generate(10, nil) -- Generates a grid with part size of 10
    ```

3. **Plant objects in the zone:**

    ```lua
    myZone:Plant(someModel, 5, 2) -- Plants 5 instances of `someModel` with an offset of 2
    ```

4. **Remove all objects from the zone:**

    ```lua
    myZone:RemoveFilling()
    ```

5. **Get the top layer coordinates:**

    ```lua
    local maxX, maxY, maxZ = myZone:GetTopLayer()
    ```

## Return

The `OpenZone` module allows for efficient management of spatial data, making it easier to handle complex object placement and manipulation within a Roblox game environment.
