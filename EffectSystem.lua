--[[
	Effect System v1.0
	
	DEPENDENCIES:
	ClockSync (https://github.com/Kenji-Shore/Roblox-Client-Server-Time-Sync-Module)
	
	7/17/2021 gaby
--]]

--[[ DOCUMENTATION ]]-------------------------------------------------------------------------------------------------
--[[

local effectModule = {}

function effectModule.effect(delta)
	
end

local effect = effectSystem.new(
	name (string)
	maxDistance (number)
	maxDelayTime (number)
	effectModule (instance[module])
	effectModuleKey (string)
)

effect:cast(
	position (vector3[positional])
	ignore (array[player])
	args...
)

]]
----------------------------------------------------------------------------------------------------------------------
local module = {}

--[[ SERVICES ]]------------------------------------------------------------------------------------------------------
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
----------------------------------------------------------------------------------------------------------------------

--[[ MODULES ]]-------------------------------------------------------------------------------------------------------
local clockSync = require(script.Parent:WaitForChild("ClockSync"))
clockSync:Initialize()
----------------------------------------------------------------------------------------------------------------------

--[[ VARIABLES ]]-----------------------------------------------------------------------------------------------------
local isClient = runService:IsClient()
----------------------------------------------------------------------------------------------------------------------

--[[ CODE ]]----------------------------------------------------------------------------------------------------------
if isClient then
	
	local effectSystemRemote = replicatedStorage:WaitForChild("EffectSystemRemote")
	
	function module:onClientEvent(t, effect, position, ignore, ...)
		local distance = (self.camera.CFrame.Position - position).Magnitude
		if distance <= effect.maxDistance then
			local delta = clockSync:GetTime() - t 
			if delta <= effect.maxDelayTime then
				require(effect.effectModule)[effect.effectModuleKey](delta, ...)
			else
				warn(string.format("Effect: <%s>. Cant cast with a delay of %.2f", effect.name, delta))
			end
		else
			warn(string.format("Effect: <%s>. Cant cast with a distance of %.1f", effect.name, distance))
		end
	end
	
	function module.init()
		
		module.camera = workspace.CurrentCamera
		
		effectSystemRemote.OnClientEvent:Connect(function(t, effect, position, ignore, ...)
			module:onClientEvent(t, effect, position, ignore, ...)
		end)
		
	end
else
	local effectSystemRemote = Instance.new("RemoteEvent")
	effectSystemRemote.Name = "EffectSystemRemote"
	effectSystemRemote.Parent = replicatedStorage
	
	local system = {}
	system.__index = system
	
	function system:cast(position, ignore, ...)
		
		effectSystemRemote:FireAllClients(clockSync:GetTime(), self, position, ignore, ...)
	end
	
	function module.new(name, maxDistance, maxDelayTime, effectModule, effectModuleKey)
		local self = setmetatable({}, system)
		
		self.name = name
		self.maxDistance = maxDistance
		self.maxDelayTime = maxDelayTime
		self.effectModule = effectModule
		self.effectModuleKey = effectModuleKey
		
		return self
	end
end
----------------------------------------------------------------------------------------------------------------------

return module
