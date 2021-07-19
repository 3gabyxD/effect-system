# Effect System
Roblox Effect System

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

Create a new effect (make sure `effectModule` is visible to players)
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
