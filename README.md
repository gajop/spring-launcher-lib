# spring-wrapper-connector
Handles Lua communication with the local wrapper program

# Features
- Simple JSON based communication protocol with spring-launcher

## Dependencies
- [spring-launcher](https://github.com/gajop/spring-launcher/)
- [json.lua](https://github.com/Spring-SpringBoard/SpringBoard-Core/blob/master/libs_sb/json.lua)

## Usage
```lua

-- Send command
WG.Connector.Send(commandName, data)
-- Example:
WG.Connector.Send("OpenFile", {
    path = "/home/myuser/some_file"
})

-- Register command handler
WG.Connector.Register(commandName, callback)
-- Example:
WG.Connector.Register("FileOpened", function(command)
    Spring.Echo("File opened: " .. tostring(command.path))
end)
```