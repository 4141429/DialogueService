local Scenario = require(game:GetService("ServerStorage").Dialogues.ServerClasses.Scenario)
local SavingService = require(game:GetService("ServerStorage").DialogueService.SavingService)

local scenario_arguments = {
    Name = "starting_dialogue",
    ClientSettings = {
        -- All textbox / textwriting settings.
        DialogueTextSettings = {
            Text = {"I'm a brick wall!", "There's many things you can do with this service.", 'Like <font color="rgb(255,125,0)">rich</font> text, <font color="rgb(0,255,125)">saving</font>, and <font color="rgb(125,0,255)">setting custom skins!</font>'},
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
                Text = "That's great!",
                FontFace = "Comic Neue Angular",
                TextColor3 = Color3.fromRGB(97, 73, 39),
                Skin = "default"
            },
            response = "cool_name",
            functions = {function(player : Player)
                SavingService.changeTrack(player, "Wall", 1)
            end}
        },
    },
}

local scenario = Scenario.New(scenario_arguments)
    
return scenario