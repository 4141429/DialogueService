--!strict
--[[

A class meant for creating an NPC class inside of a track.
(A track is a timeline / dialogue tree accessible by their track number.)

]]

local scenario = {}
scenario.__index = scenario

scenario.Defaults = {
    Name = "MISSING",
    Requirements = function()
        return true
    end,
    ClientSettings = {

        DialogueTextSettings = {
            Text = {"This dialogue text has not been filled in!"},
            FontFace = Font.fromName("ComicNeueAngular"),
            TextColor3 = Color3.fromRGB(97, 73, 39),
            TextSize = 30,
            TypeSpeed = 0.1,
            Skin = "default"
        },

        AutoSkipSettings = {
            speed = 0.5,
            allow_manual_skipping = true
        },

        ViewNpcSettings = {
            enabled = true,
            tweeninfo = {time = 2, style = Enum.EasingStyle.Exponential, direction = Enum.EasingDirection.Out},
            viewpointname = "1"
        },

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

function scenario.New(arguments : any?)
    local self = setmetatable(arguments or {}, {__index = scenario.Defaults})

    return self
end 

return scenario