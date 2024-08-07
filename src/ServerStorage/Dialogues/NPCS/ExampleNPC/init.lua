local Npc = require(game:GetService("ServerStorage").Dialogues.ServerClasses.NPC)

--[[

Create your NPC with the following arguments.

]]

local npc_arguments = {

    Name = "Wall",
    Requirements = function() 
        return true
    end,

    Scenarios = {},
    Path = script

}

local npc = Npc.New(npc_arguments)
npc:GetScenarios()

return npc
