--!strict

--[[

A class meant for creating an NPC class inside of a modulescript.

]]

--[[

NPC takes exactly 5 arguments (6 if you call saving options and track two seperate arguments),

Name : The name that you **must** refer to the NPC. No exceptions unless you set the name to be script.Name.

Requirements : A function ran whenever a dialogue is continued / started, always accepting player as the only argument.

SavingOptions : A generic table holding most saving options. More than one is planning to be added- Track is the only one for now.
    Track : The default folder containing all of your NPC dialogues.


-- DO NOT TOUCH ZONE

Scenarios : Handled by script
Path : Handled by script.

]]

local NPC = {}
NPC.Defaults = {
    Name = "MISSING",
    SavingOptions = {
        Track = "1"
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
                if not scenarios[track.Name] then
                    scenarios[track.Name] = {}
                end

                scenarios[track.Name][scenario.Name] = scenario
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