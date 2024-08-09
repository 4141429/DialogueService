local Npc = require(game:GetService("ServerStorage").Dialogues.ServerClasses.NPC)

--[[

Create your NPC with the following arguments.

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

local npc_arguments = {

    Name = "Wall",

    Requirements = function() 
        return true
    end,
    SavingOptions = {

        Track = "Start"

    },
    Scenarios = {},
    Path = script

}

local npc = Npc.New(npc_arguments)
npc:GetScenarios()

return npc
