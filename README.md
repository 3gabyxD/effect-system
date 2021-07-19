# Effect System
Roblox Effect System

- Effect System
  * [Dependencies](#dependencies)
  * [Documentation](#documentation)
- Sub-Modules
  * [Keypoint Tween](#keypoint-tween)

## Dependencies
- [ClockSync](https://github.com/Kenji-Shore/Roblox-Client-Server-Time-Sync-Module)

## Documentation
Make ClockSync module a sibling of the EffectSystem

Example effect module
```lua
local effectModule = {}

function effectModule.effect(delta, arg1, arg2)
	print(delta, arg1, arg2)
end

return effectModule
```

Create a new effect (make sure `effectModule` is accessible from client)
```lua
local effect = effectSystem.new(
	name (string)
	maxDistance (number)
	maxDelayTime (number)
	effectModule (instance[module])
	effectModuleKey (string)
)
```

Initialize local effects
```lua
local effectSystem = require(...:WaitForChild("EffectSystem"))
effectSystem.init()
```

Cast effect
```lua
effect:cast(
	position (vector3[positional])
	ignore (array[player])
	arguments
)
```

## Keypoint Tween
Require Keypoint Tween
```lua
local keypointTween = requite(...:WaitForChild("KeypointTween"))
```

Tweening property
```lua
local tween = keypointTween.property(
	instance (instance)
	property (string)
	points (array)
	{
		point (dictionary)[time, value, easing(optional)]
	}
	easing (function)
)
```

Example
```lua
local function easeIn(t)
	return t*t
end

local tween = keypointTween.property(
	cylinder,
	"Size",
	{
		{time = 0.3, value = Vector3.new(50, 9, 9), easeIn}
	}
)

tween:play() -- or tween:Play()
```
