local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts

local isServer = RunService:IsServer()
local rootDirectory = if isServer then ServerScriptService else Players.LocalPlayer:WaitForChild("PlayerScripts")
local moduleDirectory = if isServer then rootDirectory.Services else rootDirectory:WaitForChild("Controllers")

local modules = {}

local function RequireModule(module: ModuleScript)
	if not module:IsA("ModuleScript") then return end

	local import = require(module)
	table.insert(modules, import)
end

return function()
	for _, descendant: ModuleScript in moduleDirectory:GetDescendants() do
		RequireModule(descendant)
	end

	for _, module in modules do
		if module.setup then
			module.setup()
		end
	end

	for _, module in modules do
		if module.onStart then
			task.spawn(module.onStart)
		end
	end

	if not isServer then
		moduleDirectory.DescendantAdded:Connect(function(descendant: ModuleScript)
			RequireModule(descendant)
		end)
	end
end
