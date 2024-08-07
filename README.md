# Dialogue Service 

DialogueService: A strictly typed, fully customizeable dialogue system.

## Features

There are a variety of features, including but not limited to

* Camera-Animation/Switches
* Automatic Track Saving
* Rich Text Implementation
* Abstracted Scenarios (anti scraping protection)
* Functions on Dialogue Start / Response click
* Customizable text, fonts, and size.
* Support for dialogue skins
* Easy to visualize dialogue trees
* Exploit Protection
* Builtin requirements

# Installation

To get started, first head over to either the "Releases" tab to get a prebuilt version, my [DevForum]() post to get the roblox model, or build it yourself with [Rojo.](https://github.com/rojo-rbx/rojo)

## Roblox Model / RBXM

Place all the items in each folder corresponding to your game's folders.
For example, the items in "ServerStorage" should go into your actual ServerStorage folder.

## Rojo

If you prefer building the project from the source, first download the source file from github. 
Extract it, then open powershell / a vscode terminal.
Then, type
```
rojo build -o "DialogueService.rbxm"
```
Once you've built it, follow the previous instructions.
# Usage

Creating comprehensive Dialogues takes time and will require some level of effort.

## NPCS

In order to make an NPC, first create a module script under the folder "Dialogues\Npcs" in ServerStorage. Then, follow the template given to you in the examples provided / the following text.

Each NPC contains the following parameters:

Name : string (required)
SavingOptions : { Track : number }
Requirement
Scenarios (automatically handled)
Path (required)

Failing to set one of the required parameters will result in an error. Please make sure the follow the guidelines set in the "ServerClasses" folder in ServerStorage\Dialogues\ServerClasses.

An example npc would look like this:

```lua
local Npc = require(game:GetService("ServerStorage").Dialogues.ServerClasses.NPC)

  

--[[
Create your NPC with the following arguments.
]]

  

local npc_arguments = {

    Name = "Wall",

    Requirements = function()

        return true

    end,
    SavingOptions = {
		-- Default Track
        Track = 1

    },

    Scenarios = {},

    Path = script

}

  
--[[

Creates a new npc class with your arguments

]]
local npc = Npc.New(npc_arguments)

--[[

Grabs all scenarios, required for all NPCs.

]]
npc:GetScenarios()

  

return npc
```

Using this script, you have a base framework for an NPC. In order to create dialogues, follow the next steps.

## Tracks

Under each NPC, there are several "tracks". A track is a folder containing dialogues, which are meant to separate and organize dialogue trees. The main benefit to these trees is the fact that you can save which track a player is on. 

For example, if you'd like to give a player an apple, and you wouldn't want them to get several by just rejoining to reclaim it- you can instead just change their track 
upon a click to prevent them from exploiting the dialogue.

A great example of this used in a scenario would be like this:

```lua

local Scenario = require(game:GetService("ServerStorage").Dialogues.ServerClasses.Scenario)

local scenario_arguments = {
    Name = "cool_name",
    ClientSettings = {
        -- All textbox / textwriting settings.
        DialogueTextSettings = {
            Text = {"Saving is actually implemented- try talking to me after this dialogue."},
            FontFace = Font.fromName("ComicNeueAngular"),
            TextColor3 = Color3.fromRGB(97, 73, 39),
            TextSize = 30,
            TypeSpeed = 0.1,
            Skin = "default"
        },
        -- Autoskip related settings.
        AutoSkipSettings = {
            speed = 0.5,
            allow_manual_skipping = true
        },
        -- Settings regarding the viewpoint to be viewed, and the tween used.
        ViewNpcSettings = {
            enabled = true,
            tweeninfo = {time = 2, style = Enum.EasingStyle.Exponential, direction = Enum.EasingDirection.Out},
            position = "1"
        },
        -- Pauses player if true
        PausePlayer = false,
        
    },
    Responses = {
        {
            ResponseTextSettings = {
                Text = "Save me, please!",
                FontFace = "Comic Neue Angular",
                TextColor3 = Color3.fromRGB(97, 73, 39),
                Skin = "default"
            },
            response = nil,
            functions = {function(player : Player)
            --[[
            
            Saving Service has many built-in functions to help you with saving.
            changeTrack changes the player's Track for a certain NPC, and saves automatically.

            The arguments for this function would be:

            player : Player
            npc_name : string
            Track : number

            ]]
                SavingService.changeTrack(player, "NPC", 2)
            end}
        },
}

local scenario = Scenario.New(scenario_arguments)
    
return scenario

```

## Scenarios

Each scenario has four main tables that are not required, though leaving arguments blank would result in them being replaced with the default template values.

The following are the arguments:

Name
Requirements
ClientSettings
Responses
lackingPermissions (deprecated, being updated in later verisons)
All of these should be filled out to your liking.


Note that for Responses, you must specify a response scenario, or leave it as nil to end the dialogue.

Creating a Scenario should look like this.

```lua
local Scenario = require(game:GetService("ServerStorage").Dialogues.ServerClasses.Scenario)
local SavingService = require(game:GetService("ServerStorage").DialogueService.SavingService)

local scenario_arguments = {
    Name = "cool_name",
    ClientSettings = {
        -- All textbox / textwriting settings.
        DialogueTextSettings = {
            Text = {"I hope you can make good use of this."},
            FontFace = Font.fromName("ComicNeueAngular"),
            TextColor3 = Color3.fromRGB(97, 73, 39),
            TextSize = 30,
            TypeSpeed = 0.1,
            Skin = "default"
        },
        -- Autoskip related settings.
        AutoSkipSettings = {
            speed = 0.5,
            allow_manual_skipping = true
        },
        -- Settings regarding the viewpoint to be viewed, and the tween used.
        ViewNpcSettings = {
            enabled = true,
            tweeninfo = {time = 2, style = Enum.EasingStyle.Exponential, direction = Enum.EasingDirection.Out},
            position = "1"
        },
        -- Pauses player if true
        PausePlayer = false,
        
    },
    Responses = {
        {
            ResponseTextSettings = {
                Text = "Thanks.",
                FontFace = "Comic Neue Angular",
                TextColor3 = Color3.fromRGB(97, 73, 39),
                Skin = "default"
            },
            response = nil,
            functions = {function(player : Player)
                SavingService.changeTrack(player, "Wall", 1)
            end}
        },
    },
}

local scenario = Scenario.New(scenario_arguments)
    
return scenario
```

Make sure to set your NPC's tracks, and parent it to this.

## Dialogues / Scenarios / NPCs

Scenarios and Dialogues are used interchangeably, and have several feature meant to make your life easier, as a developer.
First of all, a module script's name does not dictate the script's scenario / npc name. 
You must clearly define it as an argument, otherwise you will throw an error.


Although this was an odd design choice, it was a choice deliberately made to allow for people to name their dialogues seperately from the Instance's actual name.
This also goes for NPC module scripts.

### Responses and Functions

Responses are the buttons that show up after a dialogue-text finishes. All functions are handled server-side, and cannot be scraped by the user. 

Functions can be ran once dialogues start, or when a response is clicked. All functions can only receive "player" as an argument, as of now.

## Prompts

An example prompt is provided for you. All you need to do is edit the position of the prompts, and name of the NPC. Note that you need to specify the name of the npc that is set in the module script, not the script name.

If you'd like to create your own, follow this guide.

Create a part you'd like to have the prompt. Create a proximity prompt and a folder named whatever you'd like.
The folder should have viewpoints with a name as a number, if you're going to be viewing the npc. Correctly orient and position them, and you're set.

Lastly, fill in the provided fields and you're good to go.

```lua
local npcname = "YOUR NPC NAME"

local viewpointfolder
local DialoguePrompt = script.Parent
local Part = DialoguePrompt.Parent
local DialogueService = require(game:GetService("ServerStorage"):WaitForChild("DialogueService")
)

if Part:FindFirstChild("YOUR VIEW POINT FOLDER NAME") then
	viewpointfolder = Part:FindFirstChild("YOUR VIEW POINT FOLDER NAME")
	for _, child in viewpointfolder:GetChildren() do
		if child:IsA("BasePart") then
			child.Transparency = 1
		end
	end
	Part.Transparency = 1
end

script.Parent.Triggered:Connect(function(player)
	DialogueService.startDialogue(player, npcname, viewpointfolder, DialoguePrompt)
end)
```

# Credits

[4141429](https://github.com/4141429/DialogueService) 

* Sole and only creator of DialogueService

[MadStudioRoblox](https://github.com/MadStudioRoblox)

* DialogueService makes use of their saving module, [ProfileService](https://github.com/MadStudioRoblox/ProfileService/)