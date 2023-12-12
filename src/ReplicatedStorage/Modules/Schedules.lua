-- Schedules
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Globals = require(ReplicatedStorage.Shared.Globals)
local Sandwich = require(Globals.Packages.Sandwich)

local Schedules = {}

Schedules.boot = Sandwich.schedule()
Schedules.heartbeat = Sandwich.schedule()
Schedules.gameTick = Sandwich.schedule()

Schedules.tick = Sandwich.tick

return Schedules
