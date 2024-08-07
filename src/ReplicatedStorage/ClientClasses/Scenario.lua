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
            -- Response box text-options.
            --TODO #NOTIMPLEMENTS
            ResponseTextSettings = {
                Text = "",
                FontFace = "Comic Neue Angular",
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
                FontFace = "Comic Neue Angular",
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
                position = "1"
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