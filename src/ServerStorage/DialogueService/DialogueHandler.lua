--!strict
local NPCS = game:GetService("ServerStorage").Dialogues.NPCS
local SavingService = require(game:GetService("ServerStorage").DialogueService.SavingService)

local DialogueHandler = {

    NPC = {}

}

--[[

Sets the template for SavingService
Initializing all dialogues in order to prevent npc from being nill.

]]
do
    for _, NPC in NPCS:GetChildren() do
        local npc = require(NPC) :: any
        DialogueHandler.NPC[npc.Name] = npc
    end
    for npc, value : any in DialogueHandler.NPC do
        SavingService.template.Dialogues[npc] = value.SavingOptions
    end    
end

--[[

Returns a dialogue based off their CODE name. The instance name is purely for organization.

]]

function DialogueHandler.returnScenario(npc_name : string, track : any, scenario : string)
    local npc_table = DialogueHandler.returnNPC(npc_name)
    if npc_table and npc_table.Scenarios[track] then
        local npc_track = npc_table.Scenarios[track]
        if npc_track[scenario] then
            return npc_track[scenario]
        end
    end
    return
end

function DialogueHandler.returnNPC(npc_name : string)
    for _, NPCScript : ModuleScript in NPCS:GetChildren() do
        local npc = require(NPCScript) :: any
        if npc.Name == npc_name then
            return npc
        end
    end
    warn("Couldn't find", npc_name, "in NPCS. Are you sure its located in game.ServerStorage.Dialogues.NPCS?")
    return
end

return DialogueHandler