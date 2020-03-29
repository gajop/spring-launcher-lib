local LOG_SECTION = "spring-launcher"

local Connector = WG.Connector
Connector.__asyncCommandMap = {}
Connector.__cmdIDCounter = 0

local origConnectorSend = Connector.Send

function Connector.Send(name, command, opt)
	opt = opt or {}
	if not opt.waitForResult then
		origConnectorSend(name, command, opt)
		return
	end

	local promise = Promise()
    Connector.__cmdIDCounter = Connector.__cmdIDCounter + 1
    local cmdID = Connector.__cmdIDCounter
	Connector.__asyncCommandMap[cmdID] = promise
	command.id = cmdID

	origConnectorSend(name, command)

	return promise
end

Connector.Register("CommandFinished", function(command)
	local id = command.id
	if id == nil then
		Spring.Log(LOG_SECTION, LOG.ERROR, "No command ID for event CommandFinished")
		return
	end
	local promise = Connector.__asyncCommandMap[id]
	if promise == nil then
		Spring.Log(LOG_SECTION, LOG.WARNING, "No registered object for event CommandFinished: " .. tostring(id))
		return
	end

	Connector.__asyncCommandMap[id] = nil
	promise:resolve()
end)

Connector.Register("CommandFailed", function(command)
	local id = command.id
	if id == nil then
		Spring.Log(LOG_SECTION, LOG.ERROR, "No command ID for event CommandFailed")
		return
	end
	local error = command.error
	local promise = Connector.__asyncCommandMap[id]
	if promise == nil then
		Spring.Log(LOG_SECTION, LOG.WARNING, "No registered object for event CommandFailed: " .. tostring(id))
		return
	end

	Connector.__asyncCommandMap[id] = nil
	promise:reject(error)
end)