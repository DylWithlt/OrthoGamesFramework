local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Globals = require(ReplicatedStorage.Shared.Globals)

local Schedules = require(Globals.Shared.Modules.Schedules)
local Profiles = require(Globals.Server.Modules.Profiles)

local PlayerComponent = require("PlayerComponent")
local ClicksComponent = require(Globals.Components.ClicksComponent)
local ProfileComponent = require(Globals.Components.ProfileComponent)
local MoneyComponent = require(Globals.Components.MoneyComponent)

local World = require(ReplicatedStorage.Shared.Modules.World)

local PlayerProfileStore

local function replicateEntityComponents(player)
	for entity, components in World.query({}) do
		for factory, component in components do
			if factory.addedSignal then
				factory.addedSignal:Fire(entity, component, player)
			end
		end
	end
end

local function newUser(player)
	-- here?
	-- before the user entity can be added we must first send ALL entities to the player.
	replicateEntityComponents(player)

	assert(PlayerProfileStore, "Player Profile Didn't Load")
	local entity = World.entity()
	local player = PlayerComponent.add(entity, player)
	local profile = ProfileComponent.add(entity, player, PlayerProfileStore)
	ClicksComponent.add(entity, profile)
	MoneyComponent.add(entity, profile)

	-- replicate?
end

local function onBoot()
	PlayerProfileStore = Profiles.createProfileTemplate()

	Players.PlayerAdded:Connect(Schedules.userAdded.start)
	for _, player in Players:GetPlayers() do
		newUser(player)
	end
end

return Schedules.boot.job(onBoot)
