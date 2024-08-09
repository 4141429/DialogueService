--!strict

local SavingService = require(game:GetService("ServerStorage").DialogueService.SavingService)

--[[

A class meant for creating an NPC class inside of a track.
(A track is a timeline / dialogue tree accessible by their track number.)

Name : Follows the same rules. Always call this scenario by the name you set in ARGS, not the scripts actual name.

Requirements : Follows the same rules as NPC.

functions : Functions (a table or a singular function) that are ran with the argument being player.



Client Settings : Self explanatory mostly. Smaller explanations for less obscure features incoming!



DialogueTextSettings : All dialogue-related settings

Type Speed : The amount of seconds the type writer effect will wait for inbetween each character.

Skin : A feature that can be edited in DialogueController. Sets the desired object to a skin, which calls back to an image in DialogueController.




AutoSkip Settings : Handles all automatic/controlled skipping values

waittime : The amount of seconds it'll wait before going to the next dialogue for the player

allow_manual_skipping : If the player is allowed to skip said scenario's dialogue by clicking



View Npc Settings : Handles all camera related movement

enabled : Enables this feature

tweeninfo : Dumbway of inputting tweeninfo - doesn't fare well when being transferred over remotes

viewpointname : Name of the part you're using to represent the camera / move the camera towards



Pause Player : Set's player's walkspeed and jumppower to 0


Responses : Holds up to four tables of responses.

ResponseTable : (a table)

ResponseTextSettings : Same as dialogue text settings without a type-writer feature or text size

response : A string containing the next scenario's ARGUMENT name. Not the script's instance name.

functions : Functions ran upon the response being clicked.



]]

local scenario = {}
scenario.__index = scenario

scenario.Defaults = {
    Name = "MISSING",
    Requirements = function(player : Player)
        return true
    end,
    functions = {
        function(player : Player)
            print("Example function!")
        end
    },
    ClientSettings = {
        -- All textbox / textwriting settings.
        DialogueTextSettings = {
            Text = {"This dialogue text has not been filled in!"},
            FontFace = Font.fromName("ComicNeueAngular"),
            TextColor3 = Color3.fromRGB(97, 73, 39),
            TextSize = 30,
            TypeSpeed = 0.1,
            Skin = "default"
        },
        -- Autoskip related settings.
        AutoSkipSettings = {
            waittime = 0.5,
            allow_manual_skipping = true
        },
        -- Settings regarding the viewpoint to be viewed, and the tween used.
        ViewNpcSettings = {
            enabled = true,
            tweeninfo = {time = 2, style = Enum.EasingStyle.Exponential, direction = Enum.EasingDirection.Out},
            viewpointname = "1"
        },
        -- Pauses player if true
        PausePlayer = false,
        
    },
    Responses = {
        {
            ResponseTextSettings = {
                Text = "",
                FontFace = Font.fromName("ComicNeueAngular"),
                TextColor3 = Color3.fromRGB(97, 73, 39),
                Skin = "default"
            },
            response = nil,
            functions = {function(player : Player)
                SavingService.changeTrack(player, "NPC", 2)
            end}
        }
    },
    LackingPermissions = {
        Name = "MISSING",
        Requirements = function()
            return true
        end,
        ClientSettings = {
            DialogueTextSettings = {
                Text = {"Hi!", "You didnt fill this in!"},
                FontFace = Font.fromName("ComicNeueAngular"),
                TextColor3 = Color3.fromRGB(97, 73, 39),
                TextSize = 30,
                TypeSpeed = 0.1,
                Skin = "default"
            },
            AutoSkipSettings = {
    
                speed = 0.5,
                allow_manual_skipping = false
    
            },
            ViewNpcSettings = {
                enabled = true,
                tweeninfo = {time = 2, style = Enum.EasingStyle.Quint, direction = Enum.EasingDirection.Out},
                viewpointname = "1"
            },
            PausePlayer = false,
        }
    }
}

function scenario.New(arguments)
    local self = setmetatable(arguments or {}, {__index = scenario.Defaults})

    return self
end 

return scenario