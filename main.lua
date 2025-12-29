--[[
    Advanced Chat Bypasser v2.0
    Multiple bypass methods + Direct send
]]

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer

-- Advanced Settings
local Settings = {
    Enabled = true,
    Method = "Mixed",
    Strength = 70,
    AutoBypass = true,
    InvisibleChars = true,
    CombiningMarks = true,
    FontSwap = false
}

-- Extended Homoglyph Dictionary
local Homoglyphs = {
    ["a"] = {"а", "ạ", "à", "á", "ȧ", "ӑ", "ä", "ã", "å", "ā", "ą"},
    ["b"] = {"ḅ", "ƅ", "ḃ", "ɓ", "Ꮟ", "ᖯ"},
    ["c"] = {"с", "ç", "ċ", "ć", "č", "ĉ", "ƈ", "ꮯ"},
    ["d"] = {"ḍ", "đ", "ḋ", "ɗ", "ď", "ԁ"},
    ["e"] = {"е", "ẹ", "è", "é", "ė", "ë", "ē", "ę", "ě", "ɛ"},
    ["f"] = {"ḟ", "ƒ", "ꬵ"},
    ["g"] = {"ġ", "ğ", "ǵ", "ģ", "ĝ", "ɡ", "ᶃ"},
    ["h"] = {"һ", "ḥ", "ḣ", "ĥ", "ħ", "ⱨ"},
    ["i"] = {"і", "ì", "í", "ị", "ī", "ï", "î", "ĩ", "ɨ", "ı"},
    ["j"] = {"ј", "ĵ", "ʝ", "ɉ"},
    ["k"] = {"κ", "ķ", "ḳ", "ƙ", "ᶄ", "ꝁ"},
    ["l"] = {"ḷ", "ļ", "ł", "ĺ", "ľ", "ŀ", "ɫ", "ӏ"},
    ["m"] = {"ṃ", "ṁ", "ᵯ", "ɱ", "ꮇ"},
    ["n"] = {"ṅ", "ñ", "ń", "ņ", "ň", "ŋ", "ɲ", "ṇ"},
    ["o"] = {"о", "ọ", "ò", "ó", "ȯ", "ö", "ô", "õ", "ø", "ō", "ɵ"},
    ["p"] = {"р", "ṗ", "ƥ", "ᵽ", "ꝑ"},
    ["q"] = {"ԛ", "ɋ", "ꝗ"},
    ["r"] = {"ṛ", "ŕ", "ṙ", "ř", "ɍ", "ɾ", "ꝛ"},
    ["s"] = {"ѕ", "ṡ", "ś", "ș", "š", "ŝ", "ʂ", "ꜱ"},
    ["t"] = {"ṭ", "ţ", "ṫ", "ť", "ŧ", "ƭ", "ʈ"},
    ["u"] = {"ụ", "ù", "ú", "ū", "ü", "û", "ũ", "ů", "ű", "ʉ"},
    ["v"] = {"ṿ", "ν", "ᵥ", "ⱱ", "ꝟ"},
    ["w"] = {"ẁ", "ẃ", "ẅ", "ŵ", "ꮃ", "ɯ"},
    ["x"] = {"х", "×", "ẋ", "ꭓ"},
    ["y"] = {"у", "ý", "ỵ", "ÿ", "ŷ", "ɏ", "ƴ"},
    ["z"] = {"ẓ", "ż", "ź", "ž", "ƶ", "ȥ"}
}

-- Zero-width and Invisible Characters
local Invisibles = {
    "\226\128\139", -- Zero-width space
    "\226\128\140", -- Zero-width non-joiner
    "\226\128\141", -- Zero-width joiner
    "\226\129\160", -- Word joiner
    "\239\187\191", -- Zero-width no-break space
    "\194\173"      -- Soft hyphen
}

-- Combining Diacritical Marks
local CombiningMarks = {
    "\204\129", -- Combining acute accent
    "\204\128", -- Combining grave accent
    "\204\130", -- Combining circumflex
    "\204\131", -- Combining tilde
    "\204\132", -- Combining macron
    "\204\134", -- Combining breve
    "\204\135", -- Combining dot above
    "\204\136", -- Combining diaeresis
    "\204\163"  -- Combining dot below
}

-- Unicode Font Variations (Bold, Italic, etc.)
local FontMaps = {
    bold = {
        a = "𝗮", b = "𝗯", c = "𝗰", d = "𝗱", e = "𝗲", f = "𝗳", g = "𝗴",
        h = "𝗵", i = "𝗶", j = "𝗷", k = "𝗸", l = "𝗹", m = "𝗺", n = "𝗻",
        o = "𝗼", p = "𝗽", q = "𝗾", r = "𝗿", s = "𝘀", t = "𝘁", u = "𝘂",
        v = "𝘃", w = "𝘄", x = "𝘅", y = "𝘆", z = "𝘇"
    },
    italic = {
        a = "𝘢", b = "𝘣", c = "𝘤", d = "𝘥", e = "𝘦", f = "𝘧", g = "𝘨",
        h = "𝘩", i = "𝘪", j = "𝘫", k = "𝘬", l = "𝘭", m = "𝘮", n = "𝘯",
        o = "𝘰", p = "𝘱", q = "𝘲", r = "𝘳", s = "𝘴", t = "𝘵", u = "𝘶",
        v = "𝘷", w = "𝘸", x = "𝘹", y = "𝘺", z = "𝘻"
    }
}

-- Bypass Methods
local BypassMethods = {}

function BypassMethods.Homoglyph(text)
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        local lower = string.lower(char)
        if char ~= " " and Homoglyphs[lower] and math.random(1, 100) <= Settings.Strength then
            local options = Homoglyphs[lower]
            result = result .. options[math.random(1, #options)]
        else
            result = result .. char
        end
    end
    return result
end

function BypassMethods.Invisible(text)
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        result = result .. char
        if char ~= " " and math.random(1, 100) <= Settings.Strength then
            result = result .. Invisibles[math.random(1, #Invisibles)]
        end
    end
    return result
end

function BypassMethods.Combining(text)
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        result = result .. char
        if char:match("%a") and math.random(1, 100) <= Settings.Strength then
            result = result .. CombiningMarks[math.random(1, #CombiningMarks)]
        end
    end
    return result
end

function BypassMethods.Font(text)
    local fontType = math.random() > 0.5 and "bold" or "italic"
    local font = FontMaps[fontType]
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        local lower = string.lower(char)
        if font[lower] and math.random(1, 100) <= Settings.Strength then
            result = result .. font[lower]
        else
            result = result .. char
        end
    end
    return result
end

function BypassMethods.Mixed(text)
    local result = text
    
    -- Apply homoglyphs
    result = BypassMethods.Homoglyph(result)
    
    -- Apply invisible characters
    if Settings.InvisibleChars then
        local temp = ""
        for i = 1, #result do
            local char = result:sub(i, i)
            temp = temp .. char
            if char ~= " " and math.random(1, 100) <= 30 then
                temp = temp .. Invisibles[math.random(1, #Invisibles)]
            end
        end
        result = temp
    end
    
    -- Apply combining marks
    if Settings.CombiningMarks then
        local temp = ""
        for i = 1, #result do
            local char = result:sub(i, i)
            temp = temp .. char
            if char:match("%a") and math.random(1, 100) <= 20 then
                temp = temp .. CombiningMarks[math.random(1, #CombiningMarks)]
            end
        end
        result = temp
    end
    
    return result
end

-- Main Bypass Function
local function BypassText(text)
    if not Settings.Enabled then return text end
    
    local method = BypassMethods[Settings.Method]
    if method then
        return method(text)
    end
    return text
end

-- Send Message Function
local function SendMessage(text)
    local bypassedText = BypassText(text)
    
    -- Try new TextChatService first
    local success = pcall(function()
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then
            channel:SendAsync(bypassedText)
            return
        end
    end)
    
    if not success then
        -- Try legacy chat system
        pcall(function()
            local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if chatEvents then
                local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
                if sayMessage then
                    sayMessage:FireServer(bypassedText, "All")
                end
            end
        end)
    end
end

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "Advanced Chat Bypasser",
    LoadingTitle = "Loading Bypasser",
    LoadingSubtitle = "v2.0",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Send Message")

MainTab:CreateInput({
    Name = "Type & Send",
    PlaceholderText = "Type your message here...",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        if Text ~= "" then
            SendMessage(Text)
            Rayfield:Notify({
                Title = "Sent!",
                Content = "Message sent with bypass",
                Duration = 2
            })
        end
    end
})

MainTab:CreateSection("Settings")

MainTab:CreateToggle({
    Name = "Enable Bypasser",
    CurrentValue = true,
    Flag = "EnableToggle",
    Callback = function(Value)
        Settings.Enabled = Value
    end
})

MainTab:CreateToggle({
    Name = "Auto-Bypass Chat",
    CurrentValue = true,
    Flag = "AutoToggle",
    Callback = function(Value)
        Settings.AutoBypass = Value
    end
})

MainTab:CreateDropdown({
    Name = "Bypass Method",
    Options = {"Mixed", "Homoglyph", "Invisible", "Combining", "Font"},
    CurrentOption = {"Mixed"},
    Flag = "MethodDropdown",
    Callback = function(Option)
        Settings.Method = Option[1]
    end
})

MainTab:CreateSlider({
    Name = "Bypass Strength",
    Range = {10, 100},
    Increment = 5,
    CurrentValue = 70,
    Flag = "StrengthSlider",
    Callback = function(Value)
        Settings.Strength = Value
    end
})

-- Advanced Tab
local AdvancedTab = Window:CreateTab("Advanced", 4483362458)

AdvancedTab:CreateSection("Extra Methods")

AdvancedTab:CreateToggle({
    Name = "Invisible Characters",
    CurrentValue = true,
    Flag = "InvisibleToggle",
    Callback = function(Value)
        Settings.InvisibleChars = Value
    end
})

AdvancedTab:CreateToggle({
    Name = "Combining Marks",
    CurrentValue = true,
    Flag = "CombiningToggle",
    Callback = function(Value)
        Settings.CombiningMarks = Value
    end
})

AdvancedTab:CreateToggle({
    Name = "Font Swap (Experimental)",
    CurrentValue = false,
    Flag = "FontToggle",
    Callback = function(Value)
        Settings.FontSwap = Value
    end
})

-- Test Tab
local TestTab = Window:CreateTab("Test", 4483362458)

TestTab:CreateSection("Preview Bypass")

local PreviewText = ""
TestTab:CreateInput({
    Name = "Test Input",
    PlaceholderText = "Type to preview bypass...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        PreviewText = BypassText(Text)
        print("=== BYPASS PREVIEW ===")
        print("Original: " .. Text)
        print("Bypassed: " .. PreviewText)
        print("======================")
    end
})

TestTab:CreateButton({
    Name = "Send Preview to Chat",
    Callback = function()
        if PreviewText ~= "" then
            SendMessage(PreviewText)
        end
    end
})

-- Hook Chat System for Auto-Bypass
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Settings.Enabled and Settings.AutoBypass and method == "FireServer" then
        local name = self.Name:lower()
        if name == "saymessagerequest" or 
           name == "defaultchatmessageevent" or
           name == "onmessagedonefiltering" or
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

-- Also hook TextChatService
pcall(function()
    local oldSendAsync
    oldSendAsync = hookfunction(TextChatService.TextChannels.RBXGeneral.SendAsync, function(self, message, ...)
        if Settings.Enabled and Settings.AutoBypass then
            message = BypassText(message)
        end
        return oldSendAsync(self, message, ...)
    end)
end)

-- Notify Loaded
Rayfield:Notify({
    Title = "Advanced Bypasser",
    Content = "Loaded! Type in the GUI or chat normally.",
    Duration = 5
})

print("Advanced Chat Bypasser v2.0 Loaded")
