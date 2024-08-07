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
                if not scenarios[tonumber(track.Name)] then
                    scenarios[tonumber(track.Name)] = {}
                end

                scenarios[tonumber(track.Name)][scenario.Name] = scenario
            end
        end
    end
    self.Scenarios = scenarios
end

-- Constructor function
function NPC.New(arguments : any)
    local self = setmetatable(arguments, { __index = NPC.Defaults})

    return self
end

return NPC