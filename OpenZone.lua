local HttpService = game:GetService('HttpService')
local RunService = game:GetService('RunService')

local OpenZone = {Zones = {}, Plants = {}}
OpenZone.__index = OpenZone

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
	gen_size: Vector3;
	onPlayerEnter: RBXScriptSignal;
	onPlayerLeave: RBXScriptSignal;
	PlayersInside: {};
}

function OpenZone.new(zone: BasePart)
	assert(zone, "No zone specified")

	local BillboardsFolder = Instance.new('Folder')
	BillboardsFolder.Name = "OpenZoneID:_"..HttpService:GenerateGUID(false)
	BillboardsFolder.Parent = workspace

	local Plants = Instance.new('Folder')
	Plants.Name = "Planted"
	Plants.Parent = BillboardsFolder

	local onPlayerEnterEvent = Instance.new('BindableEvent')
	onPlayerEnterEvent.Name = "OpenZone_onPlayerEnter"

	local onPlayerLeaveEvent = Instance.new('BindableEvent')
	onPlayerLeaveEvent.Name = "OpenZone_onPlayerLEave"
	
	if zone then
		local _zone: Zone = setmetatable({
			_x = zone.Position.X;
			_y = zone.Position.Y;
			_z = zone.Position.Z;
			_sizeX = zone.Size.X;
			_sizeY = zone.Size.Y;
			_sizeZ = zone.Size.Z;
			zonefolder = BillboardsFolder;
			zoneplants = Plants;
			onPlayerEnter = onPlayerEnterEvent.Event;
			onPlayerLeave = onPlayerLeaveEvent.Event;
			PlayersInside = {};
			Objects = {};
			set = false;
			level = 0;
			LastTouch = {};
		}, OpenZone)
		OpenZone.Zones[BillboardsFolder.Name] = _zone
		
		_zone:connectEnterEvent(onPlayerEnterEvent, onPlayerLeaveEvent)
		
		return _zone
	end
end

function OpenZone:GetPlayers()
	return self.PlayersInside, #self.PlayersInside
end

function OpenZone:connectEnterEvent(binded_enter_event, binded_leave_event)
	local region = Region3.new(
		Vector3.new(self._x - self._sizeX / 2, self._y - self._sizeY / 2, self._z - self._sizeZ / 2),
		Vector3.new(self._x + self._sizeX / 2, self._y + self._sizeY / 2, self._z + self._sizeZ / 2)
	)

	RunService.Heartbeat:Connect(function()
		local partsInRegion = workspace:FindPartsInRegion3(region, nil, math.huge)
		local playersInRegion = {}

		for _, part in pairs(partsInRegion) do
			local character = part.Parent
			if character and character:IsA("Model") and character:FindFirstChild("Humanoid") then
				local player = game.Players:GetPlayerFromCharacter(character)
				if player then
					
					if not self.LastTouch[player] or self.LastTouch[player] + 0.5 < tick() then
						self.LastTouch[player] = tick()
					else
						return false
					end
					
					if not table.find(self.PlayersInside, player.Name) then
						binded_enter_event:Fire(player)
						table.insert(self.PlayersInside, player.Name)
					end
					table.insert(playersInRegion, player.Name)
				end
			end
		end

		for i = #self.PlayersInside, 1, -1 do
			local playerName = self.PlayersInside[i]
			if not table.find(playersInRegion, playerName) then
				local player = game.Players:FindFirstChild(playerName)
				if player then
					binded_leave_event:Fire(player)
				end
				table.remove(self.PlayersInside, i)
			end
		end
	end)
end



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

function OpenZone:Destroy()
	OpenZone.Zones[self.zonefolder.Name] = nil
	self.zonefolder:Destroy()
	self = nil
end

function OpenZone:RemovePlants()
	for plant_index, plant in pairs(self.Plants) do
		self.Plants[plant_index] = nil
		plant:Destroy()
	end
end

function OpenZone:Plant(dataset)
	print(dataset)
	local object = dataset.Model
	local amount = dataset.Amount
	local stackable = dataset.Stackable
	local minoffsetr = dataset.MinRotationOffset
	local maxoffsetr = dataset.MaxRotationOffset
	
	self.dsForRR = dataset
	
	local x,y,z = self:GetTopLayer()
	if not minoffsetr then minoffsetr = 0 end
	if not maxoffsetr then maxoffsetr = 0 end
	
	for count = 1,amount do
		local _obj = self.Objects["X"..math.random(0,x)]["Y"..y]["Z"..math.random(0,z)]
		if not _obj:FindFirstChild('Planted') or stackable then
			local size = object:GetExtentsSize()
			local planted = Instance.new('ObjectValue')
			object = object:Clone()
			object.Parent = self.zoneplants

			planted.Value = object
			planted.Parent = _obj
			planted.Name = "Planted"
			table.insert(self.Plants, object)
			object:PivotTo(_obj.CFrame * CFrame.fromEulerAnglesXYZ(0,math.rad(math.random(minoffsetr, maxoffsetr)),0) + Vector3.new(0,(size.Y/2)+(_obj.Size.Y/2), 0))
			if stackable then
				object:MoveTo(_obj.Position)
			end	
		end	
	end
end

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
	self.Objects = {};
end

function OpenZone:Generate(datatable:{Size:Vector3, Part:BasePart?, GridParts: {Attributes: any?}})
	assert(datatable, "No datatable")
	assert(datatable.Size, "No size specified")
	local Zone: Zone = self
	local size: Vector3 = datatable.Size
	local Part
	
	if datatable.Part then
		Part = datatable.Part
		self.lastgenpart = datatable.Part
	end
	
	self.lastgensize = size
	
	if Zone then
		Zone.gen_size = size
		local highestx = math.floor(Zone._sizeX / Zone.gen_size.X)
		local highesty = math.floor(Zone._sizeY / Zone.gen_size.Y)
		local highestz = math.floor(Zone._sizeZ / Zone.gen_size.Z)

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

						part.Size = Zone.gen_size
						part.Position = Vector3.new(
							Zone._x - (Zone._sizeX / 2) + (x * Zone.gen_size.X) + (Zone.gen_size.X / 2),
							Zone._y - (Zone._sizeY / 2) + (y * Zone.gen_size.Y) + (Zone.gen_size.Y / 2),
							Zone._z - (Zone._sizeZ / 2) + (z * Zone.gen_size.Z) + (Zone.gen_size.Z / 2)
						)
						part.Name = "X"..x.."Y"..y.."Z"..z
						part.Parent = self.zonefolder
						part.Anchored = true
						Zone.Objects["X"..x]["Y"..y]["Z"..z] = part
						
						if datatable.GridParts then
							for attribute, value in pairs(datatable.GridParts) do
								part[attribute] = value
							end
						end
					end
				end
			end
		end)

		if success then
			return Zone.Objects, Vector3.new(highestx, highesty, highestz)
		elseif fail then
			return false
		end
	end
end

return OpenZone
