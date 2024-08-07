--!strict

--[[

A class meant for creating an NPC class inside of a modulescript.

]]

local NPC = {}
NPC.Defaults = {
    Name = "MISSING",
    SavingOptions = {
        
        Track = 1

    },
    Requirements = function()
        return true
    end,
    OneTimeInteraction = false,
    Scenarios = {},
    Path = nil
}

NPC.__index = NPC

--[[

Retrieves all NPC scenarios.

]]
function NPC.Defaults:GetScenarios()
    local scenarios = {}
    if self.Path then
        for _, track : Folder in self.Path:GetChildren() do
            for _, Scenario in track:GetChildren() do
                local scenario = require(Scenario :: ModuleScript) :: any
                scenarios[tonumber(track.Name)] = {}
                scenarios[tonumber(track.Name)][scenario.Name] = scenario
            end
        end
    end
    self.Scenarios = scenarios
end

-- Constructor function
function NPC.New(arguments : any)
    local self = setmetatable({}, { __index = NPC.Defaults})
    print(NPC.Defaults)
    self.Name = arguments.Name or NPC.Defaults.Name
    self.SavingOptions = arguments.SavingOptions or NPC.Defaults.SavingOptions
    self.Requirements = arguments.Requirements or NPC.Defaults.SavingOptions
    self.OneTimeInteraction = arguments.OneTimeInteraction or NPC.Defaults.OneTimeInteraction
    self.Scenarios = arguments.Scenarios or NPC.Defaults.Scenarios
    self.Path = arguments.Path or NPC.Defaults.Path

    return self
end

return NPC