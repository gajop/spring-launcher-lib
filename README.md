[![Build Status](https://travis-ci.org/gajop/spring-launcher-lib.svg?branch=master)](https://travis-ci.org/gajop/spring-launcher-lib)

# spring-launcher-lib
Lua library for spring-launcher

# Features
- Simple JSON based communication protocol with spring-launcher

## Dependencies
- [spring-launcher](https://github.com/gajop/spring-launcher/)
- [json.lua](https://github.com/Spring-SpringBoard/SpringBoard-Core/blob/master/libs_sb/json.lua)

Optional (promise support):
- [promise.lua](https://github.com/Spring-SpringBoard/SpringBoard-Core/blob/master/libs_sb/utils/promise.lua) with additional [LCS](https://github.com/gajop/Lua-Class-System) dependency 

## Install
1. Obtain the repository either by adding it as a git submodule or by copying the entire structure in to your Spring game folder. Put it anywhere (although `/libs` is suggested and used by default).
2. Copy the file `api_spring_launcher_loader.lua` to the `luaui/widgets folder` and modify the `SPRING_LAUNCHER_DIR` path as necessary.

## Usage
```lua

-- Send command
WG.Connector.Send(commandName, data)
-- Example:
WG.Connector.Send("OpenFile", {
    path = "/home/myuser/some_file"
})

-- Send command with promise
WG.Connector.Send(commandName, data)
-- Example:
local promise = WG.Connector.Send("TimeConsumingCommand", details, {
    waitForResult = true
})
promise:next(function()
    Spring.Echo("TimeConsumingCommand finished")
end)
promise:catch(function()
    Spring.Echo("TimeConsumingCommand failed")
end)

-- Register command handler
WG.Connector.Register(commandName, callback)
-- Example:
WG.Connector.Register("FileOpened", function(command)
    Spring.Echo("File opened: " .. tostring(command.path))
end)
```