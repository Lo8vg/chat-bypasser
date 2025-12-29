--[[
    Chat Bypasser v1.0
    Made with Rayfield UI
]]

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Bypasser Settings
local Settings = {
    Enabled = true,
    HomoglyphRate = 50,
    InvisibleRate = 20,
    SpaceMethod = false
}

-- Homoglyph Dictionary
local Homoglyphs = {
    ["a"] = {"а", "ạ", "à", "á", "ȧ"},
    ["b"] = {"ḅ", "ƅ", "ḃ"},
    ["c"] = {"с", "ç", "ċ", "ć"},
    ["d"] = {"ḍ", "đ", "ḋ"},
    ["e"] = {"е", "ẹ", "è", "é", "ė"},
    ["f"] = {"ḟ", "ƒ"},
    ["g"] = {"ġ", "ğ", "ǵ"},
    ["h"] = {"һ", "ḥ", "ḣ"},
    ["i"] = {"і", "ì", "í", "ị", "ī"},
    ["j"] = {"ј", "ĵ"},
    ["k"] = {"κ", "ķ", "ḳ"},
    ["l"] = {"ḷ", "ļ", "ł", "ĺ"},
    ["m"] = {"ṃ", "ṁ"},
    ["n"] = {"ṅ", "ñ", "ń", "ņ"},
    ["o"] = {"о", "ọ", "ò", "ó", "ȯ"},
    ["p"] = {"р", "ṗ"},
    ["q"] = {"ԛ"},
    ["r"] = {"ṛ", "ŕ", "ṙ"},
    ["s"] = {"ѕ", "ṡ", "ś", "ș"},
    ["t"] = {"ṭ", "ţ", "ṫ"},
    ["u"] = {"ụ", "ù", "ú", "ū"},
    ["v"] = {"ṿ", "ν"},
    ["w"] = {"ẁ", "ẃ", "ẅ"},
    ["x"] = {"х", "×"},
    ["y"] = {"у", "ý", "ỵ"},
    ["z"] = {"ẓ", "ż", "ź"}
}

-- Zero-width Characters
local Invisibles = {
    "\226\128\139",
    "\226\128\140",
    "\226\128\141"
}

-- Bypass Function
local function BypassText(text)
    if not Settings.Enabled then return text end
    
    local result = ""
    
    for i = 1, #text do
        local char = text:sub(i, i)
        local lower = string.lower(char)
        
        -- Apply homoglyph replacement
        if char ~= " " and Homoglyphs[lower] and math.random(1, 100) <= Settings.HomoglyphRate then
            local options = Homoglyphs[lower]
            char = options[math.random(1, #options)]
        end
        
        result = result .. char
        
        -- Add invisible character
        if char ~= " " and math.random(1, 100) <= Settings.InvisibleRate then
            result = result .. Invisibles[math.random(1, #Invisibles)]
        end
        
        -- Add space method
        if Settings.SpaceMethod and char ~= " " and i < #text then
            result = result .. "\226\128\139"
        end
    end
    
    return result
end

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "Chat Bypasser",
    LoadingTitle = "Loading Bypasser",
    LoadingSubtitle = "by You",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- Enable Toggle
MainTab:CreateToggle({
    Name = "Enable Bypasser",
    CurrentValue = true,
    Flag = "EnableToggle",
    Callback = function(Value)
        Settings.Enabled = Value
    end
})

-- Homoglyph Rate Slider
MainTab:CreateSlider({
    Name = "Homoglyph Rate",
    Range = {0, 100},
    Increment = 5,
    CurrentValue = 50,
    Flag = "HomoglyphSlider",
    Callback = function(Value)
        Settings.HomoglyphRate = Value
    end
})

-- Invisible Rate Slider
MainTab:CreateSlider({
    Name = "Invisible Char Rate",
    Range = {0, 100},
    Increment = 5,
    CurrentValue = 20,
    Flag = "InvisibleSlider",
    Callback = function(Value)
        Settings.InvisibleRate = Value
    end
})

-- Space Method Toggle
MainTab:CreateToggle({
    Name = "Space Method",
    CurrentValue = false,
    Flag = "SpaceToggle",
    Callback = function(Value)
        Settings.SpaceMethod = Value
    end
})

-- Test Tab
local TestTab = Window:CreateTab("Test", 4483362458)

-- Manual Test Input
local TestOutput = ""
TestTab:CreateInput({
    Name = "Test Bypass",
    PlaceholderText = "Type text to test...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        TestOutput = BypassText(Text)
        print("Original: " .. Text)
        print("Bypassed: " .. TestOutput)
    end
})

TestTab:CreateButton({
    Name = "Copy Bypassed Text",
    Callback = function()
        if TestOutput ~= "" then
            setclipboard(TestOutput)
            Rayfield:Notify({
                Title = "Copied!",
                Content = "Bypassed text copied to clipboard",
                Duration = 3
            })
        end
    end
})

-- Hook Chat System
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Settings.Enabled and method == "FireServer" then
        local name = self.Name:lower()
        if name == "saymessagerequest" or 
           name == "defaultchatmessageevent" or
           string.find(name, "chat") or
           string.find(name, "message") then
            if type(args[1]) == "string" then
                args[1] = BypassText(args[1])
                return oldNamecall(self, unpack(args))
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

-- Notify Loaded
Rayfield:Notify({
    Title = "Chat Bypasser",
    Content = "Loaded successfully!",
    Duration = 5
})
