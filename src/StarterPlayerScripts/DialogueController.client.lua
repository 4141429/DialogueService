--!strict

local Scenario = require(game:GetService("ReplicatedStorage").ClientClasses.Scenario)

--[[

TODO
IMPLEMENT ALL FEATURES:

                allow_manual_skipping = false

                SAVE_DIALOGUES


]]

type DialogueTextHolder = {

    DialogueText : TextLabel,
    MouseButton1Click : any,
    Image : string
}

type DialogueParent = {

    DialogueTextHolder : DialogueTextHolder,
    DialogueText : TextLabel,
    Image : string
}

type DialogueName = {

    NpcName : TextLabel,
    Image : string

}

type Dialogue = {

    DialogueParent : DialogueParent,
    DialogueName : DialogueName

}

type ResponseFrame = {

    ResponseHolder : Instance

}

type Canvas = {

    Dialogue : Dialogue,
    ResponseFrame : ResponseFrame

}

type DialogueServiceGui = {

    Canvas : Canvas

}

-- Skins

local skins = {
	dialogue = {
		["default"] = {
			Name = "rbxassetid://18385717292",
			DialogueParent = "rbxassetid://18385717545",
			DialogueTextHolder = "rbxassetid://18385717818"
		},
		["angry"] = {
			Name = "rbxassetid://18304395211",
			DialogueParent = "rbxassetid://18304395429",
			DialogueTextHolder = "rbxassetid://18304395049"
		},
		["love"] = {
			Name = "rbxassetid://18304386923",
			DialogueParent = "rbxassetid://18304387137",
			DialogueTextHolder = "rbxassetid://18304386681"
		},
		["sad"] = {
			Name = "rbxassetid://18304379419",
			DialogueParent = "rbxassetid://18304380042",
			DialogueTextHolder = "rbxassetid://18304379669"
		}
	},
	response = {
		["happy"] = {
			ResponseBox = "rbxassetid://18304367747"
		},
		["sad"] = {
			ResponseBox = "rbxassetid://18304367991"
		},
		["angry"] = {
			ResponseBox = "rbxassetid://18304368491"
		},
		["love"] = {
			ResponseBox = "rbxassetid://18304367564"
		},
		["default"] = {
			ResponseBox = "rbxassetid://18385717083"
		}
	}
}

-- Core Imports

local StartDialogue =    game:GetService("ReplicatedStorage"):WaitForChild("DialogueServiceRemotes"):WaitForChild("StartDialogue")
local UpdateDialogue =   game:GetService("ReplicatedStorage"):WaitForChild("DialogueServiceRemotes"):WaitForChild("UpdateDialogue")
local EndDialogue =      game:GetService("ReplicatedStorage"):WaitForChild("DialogueServiceRemotes"):WaitForChild("EndDialogue")
local local_player =     game:GetService("Players").LocalPlayer
local TweenService =     game:GetService("TweenService")

-- Instances
local DialogueServiceGui : DialogueServiceGui = local_player.PlayerGui:WaitForChild("DialogueServiceGui")
local Canvas             : Canvas = DialogueServiceGui.Canvas

-- // Dialogue

local Dialogue           : any = Canvas.Dialogue

-- DialogueParent

local DialogueParent     : DialogueParent = Dialogue.DialogueParent
local DialogueTextHolder : DialogueTextHolder = DialogueParent.DialogueTextHolder
local DialogueText =     DialogueTextHolder.DialogueText

-- DialogueName

local Name               : DialogueName = Dialogue.DialogueName
local NpcName =          Name.NpcName

--// ResponseFrame

local ResponseFrame      : ResponseFrame = Canvas.ResponseFrame
local ResponseHolder     : any = ResponseFrame.ResponseHolder

local ResponseHolderOrigin = ResponseHolder.Position
local DialogueOrigin = Dialogue.Position

-- Dynamic Values (Subject to change)

local prompt : ProximityPrompt?
local scenario
local view_point_folder : any
-- Runtime

--[[

Sets a dialogue-box/response's skin based off the skin name.

]]
local function setEmotion(type : string, skin : string, response : ImageButton?)
    if type == "dialogue" and skins[type][skin] then
        DialogueParent.Image = skins[type][skin].DialogueParent
        DialogueTextHolder.Image = skins[type][skin].DialogueTextHolder
        Name.Image = skins[type][skin].Name
    elseif response and type == "response" and skins[type][skin] then
        response.Image = skins[type][skin].ResponseBox
    end
end

--[[

Takes text in a string / table bytes, and your scenario's client_settings.
Displays text and skips it when the text button is clicked.

]]
local function displayText(text: string | {string}, client_settings_dialogue: any)
    local writing_text_coroutine: thread
    local currentblock: string
    local goodtogo = false
    local connection

    local function setTextProperties()
        print(client_settings_dialogue)
        DialogueText.FontFace = client_settings_dialogue.DialogueTextSettings.FontFace
        DialogueText.TextColor3 = client_settings_dialogue.DialogueTextSettings.TextColor3
        DialogueText.TextSize = client_settings_dialogue.DialogueTextSettings.TextSize
    end

    setTextProperties()

    local function writeText(block: string, waitTime: number)
        writing_text_coroutine = coroutine.create(function()
            DialogueText.Text = ""
            local length = string.len(block)

            for i = 1, length do
                DialogueText.Text = block
                DialogueText.MaxVisibleGraphemes = i
                task.wait(waitTime)
            end
            goodtogo = true
        end)
        coroutine.resume(writing_text_coroutine)
    end

    local function skipText()
        if writing_text_coroutine then
            coroutine.close(writing_text_coroutine)
        end
        if DialogueText.MaxVisibleGraphemes == #currentblock then
            goodtogo = true
            return
        end
        DialogueText.MaxVisibleGraphemes = #currentblock
    end

    connection = DialogueTextHolder.MouseButton1Click:Connect(function()
        if client_settings_dialogue.AutoSkipSettings.allow_manual_skipping then
            skipText()
        end
    end)

    if type(text) == "table" then
        for _, textblock in text do
            goodtogo = false
            currentblock = textblock
            writeText(textblock, client_settings_dialogue.DialogueTextSettings.TypeSpeed)
            
            while not goodtogo do
                task.wait()
            end
        end
        connection:Disconnect()
    else
        currentblock = text 
        writeText(text, client_settings_dialogue.DialogueTextSettings.TypeSpeed)
        
        while DialogueText.MaxVisibleGraphemes ~= #text do
            task.wait()
        end
        
    end
end


--[[

Takes your responses from your scenario. Shows each responses skin and text.

]]
local function changeResponses(responses : {any})
    for _, response in ResponseHolder:GetChildren() do
        if response:IsA("ImageButton") then
            -- Grabbing the index from the name because the roblox-set index is unreliable and is messed up due to me using a ui grid layout.
            local response_index = tonumber(string.match(response.Name, "%d+"))

            if response_index and responses[response_index] and response:FindFirstChild("ResponseText") then
                local ResponseSettings = responses[response_index].ResponseTextSettings :: any
                local textlabel = response:WaitForChild("ResponseText") :: TextLabel


                textlabel.FontFace = ResponseSettings.FontFace
                textlabel.TextColor3 = ResponseSettings.TextColor3
                response.Visible = true
                textlabel.Text = ResponseSettings.Text
            else
                response.Visible = false
            end
        end
    end
end

--[[

Sets an object's position to outside the screen, then tweens them back to their original position.

]]
local function tweenObjectIn(object : any, original_object_position : UDim2)
    local tweeninfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tweenobjectin = TweenService:Create(object, tweeninfo, { Position = original_object_position })
    object.Position = UDim2.new(0.5, 0, 1.5, 0)
    object.Visible = true

    tweenobjectin:Play()

    local connection = object:GetPropertyChangedSignal("Visible"):Connect(function()
        if object.Visible == false then
            object.Visible = true
        end
    end)

    tweenobjectin.Completed:Wait()

    connection:Disconnect()
end

--[[

Sets all gui object skins to the provided scenario object

]]
local function setAllSkins()
    changeResponses(scenario.Responses)
    setEmotion("dialogue", scenario.ClientSettings.DialogueTextSettings.Skin)

    tweenObjectIn(ResponseHolder, ResponseHolderOrigin)
    ResponseHolder.Visible = true
end

--[[

Tweens an object's position to outside the screen, then sets them back to their original position.

]]
local function tweenObjectOut(object : any, original_object_position : UDim2)
    object.Visible = true
    local tweeninfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tweenobjectout = TweenService:Create(object, tweeninfo, { Position =  UDim2.new(0.5, 0, 1.5, 0) })
    tweenobjectout:Play()

    tweenobjectout.Completed:Wait()

    object.Visible = false
    object.Position = original_object_position
end

--[[

Self explanatory; pauses / unpauses a player

]]
local function pausePlayer(boolean : boolean)
    if boolean then
        local_player.Character.Humanoid.WalkSpeed = 0
        local_player.Character.Humanoid.JumpPower = 0
    else
        local_player.Character.Humanoid.WalkSpeed = 16
        local_player.Character.Humanoid.JumpPower = 50
    end
end

--[[

Self explanatory; views / unviews the specified part.

]]
local function viewNPC(viewpoint : Folder?, viewsetting : any?)
    local current_camera = game:GetService("Workspace").CurrentCamera
    if viewpoint and viewsetting and viewsetting.enabled and viewpoint:FindFirstChild(tostring(viewsetting.position)) then
        local position = viewpoint:WaitForChild(tostring(viewsetting.position)) :: BasePart
        local USEDtweeninfo = TweenInfo.new(viewsetting.tweeninfo.time, viewsetting.tweeninfo.style, viewsetting.tweeninfo.direction)
        current_camera.CameraType = Enum.CameraType.Scriptable
        TweenService:Create(current_camera, USEDtweeninfo, { CFrame = position.CFrame }):Play()
    else
        current_camera.CameraType = Enum.CameraType.Custom
    end
end

--[[

Resets GUIs and their locations, and prepares for another dialogue

]]
local function endDialogue()
    viewNPC()
    tweenObjectOut(Dialogue, DialogueOrigin)

    if ResponseHolder.Visible == true then
        tweenObjectOut(ResponseHolder, ResponseHolderOrigin)
    end
    
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt.Enabled = true
        prompt = nil
    end
end


--[[

Displays the provided scenario's text and responses

]]
local function continueDialogue(provided_scenario : any?, npc_name : string?, provided_scenario_name : string?)
    if provided_scenario and npc_name and provided_scenario_name then
        pausePlayer(provided_scenario.ClientSettings.PausePlayer)
        viewNPC(view_point_folder, provided_scenario.ClientSettings.ViewNpcSettings)
        scenario = provided_scenario



        displayText(scenario.ClientSettings.DialogueTextSettings.Text, scenario.ClientSettings)
        setAllSkins()
    else
        endDialogue()
    end
end


--[[

Starts dialogue with scenario sent from server

]]
local function startDialogue(scen : any, npc_name : string, viewpointfolder : Folder, new_prompt : ProximityPrompt)
    -- Setting prototype because of remote-events not serializing metatables/indexes
    local prototype = Scenario.New()
    if not prompt then
        if new_prompt:IsA("ProximityPrompt") then
            prompt = new_prompt
            new_prompt.Enabled = false

        end
        local provided_scenario = setmetatable(scen, { __index = prototype })
        view_point_folder = viewpointfolder
        DialogueText.Text = ""
        scenario = provided_scenario
        NpcName.Text = npc_name
        viewNPC(viewpointfolder, provided_scenario.ClientSettings.ViewNpcSettings)
        pausePlayer(provided_scenario.ClientSettings.PausePlayer)
        tweenObjectIn(Dialogue, DialogueOrigin)
        continueDialogue(scenario, npc_name, "starting_dialogue")

    end
end

--[[

Boilerplate, shows args required in order to be sent.

]]
local function updateDialogue(npc_name: string,  provided_scenario: string, response_index : number)
    UpdateDialogue:FireServer(npc_name, provided_scenario, scenario.Name, response_index)
end

--[[

Handles a response-click.

]]
local function responseClick(response_index : number)
    if scenario.Responses[response_index] then
        coroutine.wrap(function()
            tweenObjectOut(ResponseHolder, ResponseHolderOrigin)
        end)()
        updateDialogue(NpcName.Text, scenario.Responses[response_index].response, response_index)
    end
end

UpdateDialogue.OnClientEvent:Connect(continueDialogue)
StartDialogue.OnClientEvent:Connect(startDialogue)
EndDialogue.OnClientEvent:Connect(endDialogue)

for _, response in ResponseHolder:GetChildren() do
    local response_index = tonumber(string.match(response.Name, "%d+"))
    if response_index and response:IsA("ImageButton") then
        response.MouseButton1Click:Connect(function()
            responseClick(response_index)
        end)
    end
end