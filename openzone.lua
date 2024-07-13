local RunService = game:GetService('RunService')

local OpenZone = {}
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
	gen_size: number;
}

function OpenZone.new(zone: BasePart, gensize)
	assert(zone, "No zone specified")
	if not workspace:FindFirstChild('Miningfolder') then
		local BillboardsFolder = Instance.new('Folder')
		BillboardsFolder.Name = "Miningfolder"
		BillboardsFolder.Parent = workspace
	end

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
			gen_size = gensize or 1
		}, OpenZone)

		return _zone
	end
end

function OpenZone:Generate()
	local Zone: Zone = self
	if Zone then
		local success, fail = pcall(function()
			for x = 0, math.floor(Zone._sizeX / Zone.gen_size) - 1 do
				Zone.Objects["X"..x] = {}
				for y = 0, math.floor(Zone._sizeY / Zone.gen_size) - 1 do
					Zone.Objects["X"..x]["Y"..y] = {}
					for z = 0, math.floor(Zone._sizeZ / Zone.gen_size) - 1 do
						Zone.Objects["X"..x]["Y"..y]["Z"..z] = {}
						local part = Instance.new('Part')
						part.Size = Vector3.new(Zone.gen_size, Zone.gen_size, Zone.gen_size)
						part.Position = Vector3.new(
							Zone._x - (Zone._sizeX / 2) + (x * Zone.gen_size) + (Zone.gen_size / 2),
							Zone._y - (Zone._sizeY / 2) + (y * Zone.gen_size) + (Zone.gen_size / 2),
							Zone._z - (Zone._sizeZ / 2) + (z * Zone.gen_size) + (Zone.gen_size / 2)
						)
						part.Parent = workspace
						part.Anchored = true

					end
				end
				RunService.Heartbeat:Wait()
			end
		end)
		
		if success then
			return Zone.Objects
		elseif fail then
			return false
		end
	end
end

return OpenZone
