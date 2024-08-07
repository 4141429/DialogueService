--!strict

--[[

Remotes, feel free to edit their names and locations. Shouldn't bother you unless you have other workflows

i.e Knit, Flamework, etc..

]]


local StartDialogue =  game:GetService("ReplicatedStorage"):FindFirstChild("DialogueServiceRemotes"):FindFirstChild("StartDialogue")
local UpdateDialogue = game:GetService("ReplicatedStorage"):FindFirstChild("DialogueServiceRemotes"):FindFirstChild("UpdateDialogue")
local EndDialogue =    game:GetService("ReplicatedStorage"):FindFirstChild("DialogueServiceRemotes"):FindFirstChild("EndDialogue")

local SavingService =  require(script.SavingService)
local Config =         require(game:GetService("ServerStorage").DialogueService.DialogueHandler)

local DialogueService = {}


--[[

Runs a table / singular functions, passing player as their arguments.

]]
local function runFunctions(player : Player, func : {(player : Player) -> ()} | (player : Player) -> ())
	-- Checking what type of functions are being passed..
	if func and type(func) == "table" then
		-- If it's a table, it'll run every function with parameter "player".
		for _, tablefunction in func do
			if type(tablefunction) == "function" then
				tablefunction(player)
			end
		end
	elseif func then
		func(player)
	end
end

--[[

Error-handler.
Used for when the scenario's requirements arent met, or when the scenario isnt found.
When lacking permissions, it'll send an update to the client to update their dialogue.
Otherwise, ends the dialogue.

]]
local function lackingPermissions(player : Player, scenario : any)
	-- If theres a scenario, and a lacking permissions pop-up, the client will be updated to see the "lacking permissions" dialogue/scenario.
	if scenario and scenario.lackingPermissions then
		runFunctions(player, scenario.functions)
		UpdateDialogue:FireClient(player, scenario.lackingPermissions)
	else
	-- Otherwise, end it.
		EndDialogue:FireClient(player)
	end
end

--[[

Runs the requirement functions of a scenario and NPC, then returns a bool if it was successful.

]]
local function checkValid(player: Player, scenario: string, npc : string): boolean
	local profile = SavingService.return_profile(player)
	local npc_table = Config.returnNPC(npc)
	if npc_table then
		local saved_track_number = profile.Data.Dialogues[npc].Track

		-- Values that aren't guaranteed. If the script can't find npc_track (the player's saved track inside the npc) then it'll return false/run "lackingpermissions"

		local npc_track = npc_table.Scenarios[tonumber(saved_track_number)]

		if npc_track and npc_track[scenario] then
			local requested_scenario = npc_table.Scenarios[saved_track_number][scenario]

			local requirement_function = requested_scenario.Requirements
			local npc_requirement_function = npc_table.Requirements

			if not requirement_function(player) or not npc_requirement_function(player) then
				return false
			end
			return true
		end
	end
	return false
end

--[[

Response to the remote event "UpdateDialogue"
Checks whether they're allowed to access the next dialogue, runs all required functions, then updates them.

]]
local function continueDialogue(player : Player, npc_name : string, requested_scenario : string, previous_scenario : string, response_index : number)
	local profile = SavingService.return_profile(player)
	local npc = Config.returnNPC(npc_name)
	local saved_track_number = profile.Data.Dialogues[npc_name].Track

	local new_scenario = npc.Scenarios[saved_track_number][requested_scenario]
	
	local previous_scenario_response_functions = npc.Scenarios[saved_track_number][previous_scenario].Responses[response_index].functions

	-- Runs the previous scenario's response function.

	runFunctions(player, previous_scenario_response_functions or nil)

	if checkValid(player, requested_scenario, npc_name) then
		UpdateDialogue:FireClient(player, new_scenario, npc_name, new_scenario.Name)
		return
	end

	lackingPermissions(player, npc.Scenarios[saved_track_number][requested_scenario])
end
--[[

Initializes a dialogue with the player.

]]
function DialogueService.startDialogue(player : Player, npc_name : string, view_point_folder : Folder, prompt : ProximityPrompt)
	if checkValid(player, "starting_dialogue", npc_name ) and view_point_folder.Parent and view_point_folder.Parent:FindFirstChild("ProximityPrompt") then
		local dialogue = Config.returnNPC(npc_name)
		local saved_track_number = SavingService.returnTrack(player, npc_name)
		StartDialogue:FireClient(player, dialogue.Scenarios[saved_track_number]["starting_dialogue"], dialogue.Name, view_point_folder, prompt)
	end
end

UpdateDialogue.OnServerEvent:Connect(function(...)
	continueDialogue(...)
end)

return DialogueService