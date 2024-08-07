local Scenario = require(game:GetService("ServerStorage").Dialogues.ServerClasses.Scenario)

local scenario_arguments = {
    Name = "cool_name",
    ClientSettings = {
        -- All textbox / textwriting settings.
        DialogueTextSettings = {
            Text = {"Saving is actually implemented- try talking to me after this dialogue.", "Before that-, are you interested in seeing my son?"},
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
                Text = "Yes.",
                FontFace = Font.fromName("ComicNeueAngular"),
                TextColor3 = Color3.fromRGB(97, 73, 39),
                Skin = "default"
            },
            response = "son",
        },
        {
            ResponseTextSettings = {
                Text = "YES!!!!!!",
                FontFace = Font.fromName("ComicNeueAngular"),
                TextColor3 = Color3.fromRGB(97, 73, 39),
                Skin = "default"
            },
            response = "son",
        },
    },
}

local scenario = Scenario.New(scenario_arguments)
    
return scenario