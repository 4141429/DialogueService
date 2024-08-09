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

	--[[
	
	Accepts both a table of functions and a singular function.

	Every function is ran with the player as the first param-
	-eter. No, you cannot specify which parameter to request.

	Only player. (ddlc reference??)
	
	I'm running each function in a seperate thread because
	computation time **might** take too long for the server
	to update the client. It'd probably be better to
	just task.spawn this whole function but, who cares right?

	]]

	if func and type(func) == "table" then
		for _, tablefunction in func do
			if type(tablefunction) == "function" then
				task.spawn(function()
					tablefunction(player)
				end)
			end
		end
	elseif func then
		task.spawn(function()
			func(player)
		end)
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
		local npc_track

		npc_track = npc_table.Scenarios[tostring(saved_track_number)]

		if npc_track and npc_track[scenario] then
			local requested_scenario = npc_track[scenario]

			--[[
			
			There are two "requirement" functions inside of an NPC. The first is the
			requirement for the npc itself. The second is the requirement for the
			scenario. If you don't meet the NPC requirements then you're going
			to be locked out / have the dialogue foricbly ended.

			Every time a dialogue is continued, the NPC requirement function is ran.
			Same goes for scenarios.

			]]

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
	local npc = Config.returnNPC(npc_name)

	local saved_track = tostring(SavingService.returnTrack(player, npc_name))

	--[[
	
	Note that the reason why I'm forcibly setting each track name to a string
	is because the folder inside of the game is *always* a string.
	
	No exceptions- unless you count nil.
	
	]]

	local new_scenario = npc.Scenarios[tostring(saved_track)][requested_scenario]
	local previous_scenario_response_functions = npc.Scenarios[saved_track][previous_scenario].Responses[response_index].functions

	--[[
	
	No, I am NOT running the next scenario's functions.
	I am running the previous scenario's functions- 
	the ones you set inside the "Responses" section
	of your Scenario script.

	]]
	
	runFunctions(player, previous_scenario_response_functions or nil)

	if checkValid(player, requested_scenario, npc_name) then
		UpdateDialogue:FireClient(player, new_scenario, npc_name, new_scenario.Name)
		runFunctions(player, new_scenario.functions)
		return
	end

	lackingPermissions(player, npc.Scenarios[saved_track][requested_scenario])
end

--[[

Initializes a dialogue with the player.

]]
function DialogueService.startDialogue(player : Player, npc_name : string, view_point_folder : Folder, prompt : ProximityPrompt)

	if checkValid(player, "starting_dialogue", npc_name ) then
		local dialogue = Config.returnNPC(npc_name)
		local saved_track_number = SavingService.returnTrack(player, npc_name)

		StartDialogue:FireClient(player, dialogue.Scenarios[tostring(saved_track_number)]["starting_dialogue"], dialogue.Name, view_point_folder, prompt)
	end
end

UpdateDialogue.OnServerEvent:Connect(function(...)
	continueDialogue(...)
end)

return DialogueService