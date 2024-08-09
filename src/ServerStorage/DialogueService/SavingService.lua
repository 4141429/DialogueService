--! strict

local Players =        game:GetService("Players") 
local ProfileService = require(game:GetService("ServerStorage").DialogueService.ProfileService)

local saving = {}

saving.template = {

    Dialogues = {
    }

}

local ProfileStore =   ProfileService.GetProfileStore(
    "PlayerData",
    saving.template
)

local Profiles = {} 

type scenario = {
    shown : boolean
}

type npc_base = {
    scenario : scenario
}

type player_storage = {
    Npcs : npc_base
}

function saving.return_profile(player : Player)
    return Profiles[player]
end

--[[

Simply changes the saved track of the player

]]
function saving.changeTrack(player : Player, npc : string, track : string | number)
    local profile = Profiles[player]

    if profile then
        if profile.Data.Dialogues[npc] and profile.Data.Dialogues[npc].Track then
            profile.Data.Dialogues[npc].Track = tostring(track)
        else
            warn("Could not find npc", npc .. "!")
        end
    end
end

--[[

Allows for saving more options than the predefined ones, supports future additions to the template

]]
function saving.save_options(player : Player, npc_name : string, option : string, value : any)
    local profile = Profiles[player]

    if profile then
        if profile.Data.Dialogues[npc_name] and profile.Dialogues[npc_name][option] then
            profile.Dialogues[npc_name][option] = value
        end
    end
end

--[[

Returns the saved track number a player has- useful for non-profile-service people.

]]
function saving.returnTrack(player : Player, npc : string)
    if Profiles[player] and Profiles[player].Data.Dialogues[npc] then
        return tostring(Profiles[player].Data.Dialogues[npc].Track)
    else
        return nil
    end
end


--[[

Default profile service code- just fills in empty spaces of the template and updates them.

]]
Players.PlayerAdded:Connect(function(player : Player)
    local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
    if profile ~= nil then
        profile:AddUserId(player.UserId)
        profile:Reconcile()

        profile:ListenToRelease(function()
            Profiles[player] = nil
            player:Kick()
        end)
        
        if player:IsDescendantOf(Players) == true then
            Profiles[player] = profile
        else
            profile:Release()
        end
    else
        player:Kick() 
    end
end)

return saving