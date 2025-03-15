--Services
local Players = game:GetService("Players")

--Imports/Vars/CONST
local controllers = script.Parent
local InputController = require(controllers.InputController)

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character.Humanoid

--Funcitons
local Local = {}
local Shared = {}

function Shared.onStart()
	InputController.Input:Connect(Local.onInput)
	InputController.InputEnded:Connect(Local.onInputEnded)
	
end

function Local.onInput(input : InputObject, isTyping)
	if isTyping then return end
	print("Down", input.KeyCode.Name)
end

function Local.onInputEnded(input : InputObject, isTyping)
	if isTyping then return end
	print("Up", input.KeyCode.Name)
end

return Shared
