--[[
	Keypoint Tween v1.0
	
	7/17/2021 gaby
]]
--[[ EXAMPLES ]]------------------------------------------------------------------------------------------------------
--[[

local tween = keypointTween.property(
	instance (instance)
	property (string)
	points (array of dictionaries{
		time = timePosition,
		value = value
	})
	easing (function)
)

]]
----------------------------------------------------------------------------------------------------------------------

local module = {}

--[[ SERVICES ]]------------------------------------------------------------------------------------------------------
local runService = game:GetService("RunService")
----------------------------------------------------------------------------------------------------------------------

--[[ CODE ]]----------------------------------------------------------------------------------------------------------
local tween = {}
tween.__index = tween

function tween:setEasing(callback)
	self.easing = callback
end

function lerp(x, y, t)
	if type(x) == "number" or typeof(x) == "Vector3" then
		return x + (y - x) * t
	elseif typeof(x) == "CFrame" then
		return x:Lerp(y, t)
	elseif type(x) == "string" then
		return y:sub(1, math.floor(#x + (#y - #x) * t))
	end
end

function module.sineIn(t)
	return math.clamp(t * t, 0, 1)
end

function module.property(instance, property, points, easing)

	local self = setmetatable({}, tween)

	self.instance = instance
	self.t = 0
	self.duration = points[#points].time
	self.points = points

	self.easing = easing or function(t)
		return math.clamp(t, 0, 1)
	end

	local startingPoint = false
	for _, point in pairs(self.points) do
		if point.time <= 0 then
			startingPoint = true
			break
		end
	end
	if not startingPoint then
		table.insert(self.points, 1, {time = 0, value = self.instance[property]})
	end
	
	function self:play()
		local conn
		conn = runService.RenderStepped:Connect(function(deltaTime)
			self.t += deltaTime
			
			if not self.instance then
				conn:Disconnect()
				return
			end
			
			for i, point in pairs(self.points) do
				if point.time <= self.t and self.points[i+1] and self.t <= self.points[i+1].time then
					local x = point.value
					local y = self.points[i+1].value
					local goal = (lerp(x, y, self.easing((self.t - point.time) / (self.points[i+1].time - point.time))))
					self.instance[property] = goal
					break
				end
			end

			if self.t >= self.duration then
				self.instance[property] = self.points[#points].value
				conn:Disconnect()
			end
		end)
	end
	
	self.Play = self.play

	return self
end
----------------------------------------------------------------------------------------------------------------------

return module
