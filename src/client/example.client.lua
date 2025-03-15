--Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Imports/Vars/CONST
local Signal = require(ReplicatedStorage.Shared.Signal)

local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Humanoid : Humanoid = Char:FindFirstChild("Humanoid")
local Mouse = Player:GetMouse()

local time_since_last_left_click = math.huge
local time_since_last_right_click = math.huge

local MAX_ACTION_MAP_ATTEMPTS = 120
--Functions
local Local = {}
local Shared = {}

function Shared.setup()
	Shared.ActionMap = {
		[Enum.KeyCode.E] = "Ability",
		[Enum.KeyCode.F] = "Swerve",
	}
	--Make signals for other scripts to connect to
	Shared.Input = Signal.new()
	Shared.InputEnded = Signal.new()
	
	Shared.LeftMouseClicked = Signal.new()
	Shared.MiddleMouseClicked = Signal.new()
	Shared.RightMouseClicked = Signal.new()
	
	Shared.ActionMapUpdated = Signal.new()
end

function Shared.onStart()
	UserInputService.InputBegan:Connect(Local.onInputBegan)
	UserInputService.InputEnded:Connect(Local.onInputEnded)
	
	Mouse.Button1Down:Connect(Local.onLeftMouseButtonClicked)
	Mouse.Button2Down:Connect(Local.onRightMouseButtonClicked)
end

function Shared.UpdateActionMap(newMap)
	Shared.ActionMap = newMap
	Shared.ActionMapUpdated:Fire(newMap)
end

function Shared.GetActionMap()
	local attempts = 0
	repeat task.wait() attempts += 1 until Shared.ActionMap or attempts >= MAX_ACTION_MAP_ATTEMPTS
	return Shared.ActionMap
end

function Shared.GetKeysDown()
	return UserInputService:GetKeysPressed()
end

function Local.onInputBegan(input : InputObject, isTyping)
	Shared.Input:Fire(input, isTyping)
end

function Local.onInputEnded(input : InputObject, isTyping)
	Shared.InputEnded:Fire(input, isTyping)
end

function Local.onLeftMouseButtonClicked()
	Shared.LeftMouseClicked:Fire(time_since_last_left_click)
	time_since_last_left_click = tick()
end

function Local.onRightMouseButtonClicked()
	Shared.RightMouseClicked:Fire(time_since_last_right_click)
	time_since_last_right_click = tick()
end

return Shared
