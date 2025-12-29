--[[
    Advanced Chat Bypasser v3.0
    Stronger bypass methods for filtered words
]]

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local Player = Players.LocalPlayer

-- Settings
local Settings = {
    Enabled = true,
    AutoBypass = true,
    Method = "Aggressive",
    Strength = 80,
    UseLeetspeak = true,
    UseInvisibles = true,
    UseCombining = true,
    UsePhonetic = true,
    SplitWords = true
}

-- Extended Homoglyphs (more options = harder to detect)
local Homoglyphs = {
    ["a"] = {"а", "ạ", "ά", "ä", "ȃ", "ǎ", "ᵃ", "ᴀ", "α"},
    ["b"] = {"ḅ", "ƅ", "ḃ", "ᵇ", "ɓ", "ʙ", "β"},
    ["c"] = {"с", "ç", "ċ", "ć", "ᶜ", "ƈ", "ᴄ"},
    ["d"] = {"ḍ", "đ", "ḋ", "ᵈ", "ɗ", "ᴅ"},
    ["e"] = {"е", "ẹ", "ė", "ё", "ə", "ᵉ", "ɛ", "ᴇ", "ε"},
    ["f"] = {"ḟ", "ƒ", "ᶠ", "ꜰ"},
    ["g"] = {"ġ", "ğ", "ǵ", "ᵍ", "ɠ", "ɢ"},
    ["h"] = {"һ", "ḥ", "ḣ", "ʰ", "ɦ", "ʜ"},
    ["i"] = {"і", "ị", "ï", "ı", "ᵢ", "ɪ", "ι"},
    ["j"] = {"ј", "ĵ", "ʲ", "ɉ", "ᴊ"},
    ["k"] = {"κ", "ķ", "ḳ", "ᵏ", "ƙ", "ᴋ"},
    ["l"] = {"ḷ", "ļ", "ł", "ˡ", "ɫ", "ʟ", "ι"},
    ["m"] = {"ṃ", "ṁ", "ᵐ", "ɱ", "ᴍ"},
    ["n"] = {"ṅ", "ñ", "ń", "ⁿ", "ɲ", "ɴ", "η"},
    ["o"] = {"о", "ọ", "ö", "ȯ", "ᵒ", "ɵ", "ᴏ", "σ", "ο"},
    ["p"] = {"р", "ṗ", "ᵖ", "ƥ", "ᴘ", "ρ"},
    ["q"] = {"ԛ", "ɋ", "ᑫ"},
    ["r"] = {"ṛ", "ŕ", "ṙ", "ʳ", "ɾ", "ʀ"},
    ["s"] = {"ѕ", "ṡ", "ś", "ˢ", "ʂ", "ꜱ", "ς"},
    ["t"] = {"ṭ", "ţ", "ṫ", "ᵗ", "ƭ", "ᴛ", "τ"},
    ["u"] = {"ụ", "ü", "ů", "ᵘ", "ʉ", "ᴜ", "υ"},
    ["v"] = {"ṿ", "ᵛ", "ⱱ", "ᴠ", "ν"},
    ["w"] = {"ẃ", "ẅ", "ʷ", "ɯ", "ᴡ", "ω"},
    ["x"] = {"х", "ẋ", "ˣ", "χ"},
    ["y"] = {"у", "ý", "ÿ", "ʸ", "ɏ", "ʏ", "γ"},
    ["z"] = {"ẓ", "ż", "ź", "ᶻ", "ƶ", "ᴢ"}
}

-- Leetspeak Map
local Leetspeak = {
    ["a"] = {"4", "@", "^^"},
    ["e"] = {"3", "€"},
    ["i"] = {"1", "!", "|"},
    ["o"] = {"0", "()", "°"},
    ["s"] = {"5", "$"},
    ["t"] = {"7", "+"},
    ["b"] = {"8", "ß"},
    ["g"] = {"9", "6"},
    ["l"] = {"1", "|"}
}

-- Phonetic Replacements
local Phonetics = {
    ["ck"] = {"cc", "kk", "c"},
    ["ph"] = {"f"},
    ["f"] = {"ph"},
    ["x"] = {"ks", "cks"},
    ["qu"] = {"kw", "qw"},
    ["oo"] = {"uu", "u"},
    ["ee"] = {"ii", "i"},
    ["ss"] = {"zz", "s"},
    ["tt"] = {"dd", "t"}
}

-- Invisible Characters
local Invisibles = {
    "\226\128\139",  -- Zero-width space
    "\226\128\140",  -- Zero-width non-joiner
    "\226\128\141",  -- Zero-width joiner
    "\226\129\160",  -- Word joiner
    "\194\173"       -- Soft hyphen
}

-- Combining Marks
local CombiningMarks = {
    "\204\129",  -- Acute
    "\204\128",  -- Grave
    "\204\132",  -- Macron
    "\204\135",  -- Dot above
    "\204\163"   -- Dot below
}

-- Bypass Functions

local function AddInvisible()
    return Invisibles[math.random(1, #Invisibles)]
end

local function AddCombining()
    return CombiningMarks[math.random(1, #CombiningMarks)]
end

local function GetHomoglyph(char)
    local lower = string.lower(char)
    if Homoglyphs[lower] then
        local options = Homoglyphs[lower]
        return options[math.random(1, #options)]
    end
    return char
end

local function GetLeet(char)
    local lower = string.lower(char)
    if Leetspeak[lower] then
        local options = Leetspeak[lower]
        return options[math.random(1, #options)]
    end
    return char
end

-- Apply Phonetic Replacements
local function ApplyPhonetics(text)
    local result = text
    for pattern, replacements in pairs(Phonetics) do
        if string.find(result:lower(), pattern) then
            if math.random(1, 100) <= Settings.Strength then
                local replacement = replacements[math.random(1, #replacements)]
                result = result:gsub(pattern, replacement)
                result = result:gsub(pattern:upper(), replacement:upper())
            end
        end
    end
    return result
end

-- Light Bypass (minimal changes)
local function LightBypass(text)
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        if char ~= " " and math.random(1, 100) <= 30 then
            result = result .. GetHomoglyph(char)
        else
            result = result .. char
        end
        if char ~= " " and math.random(1, 100) <= 15 then
            result = result .. AddInvisible()
        end
    end
    return result
end

-- Medium Bypass
local function MediumBypass(text)
    local result = ""
    if Settings.UsePhonetic then
        text = ApplyPhonetics(text)
    end
    for i = 1, #text do
        local char = text:sub(i, i)
        if char ~= " " then
            if math.random(1, 100) <= Settings.Strength then
                char = GetHomoglyph(char)
            end
            result = result .. char
            if Settings.UseInvisibles and math.random(1, 100) <= 25 then
                result = result .. AddInvisible()
            end
            if Settings.UseCombining and math.random(1, 100) <= 15 then
                result = result .. AddCombining()
            end
        else
            result = result .. char
        end
    end
    return result
end

-- Aggressive Bypass (for bad words)
local function AggressiveBypass(text)
    -- First apply phonetics
    if Settings.UsePhonetic then
        text = ApplyPhonetics(text)
    end
    
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        
        if char == " " then
            result = result .. " "
        else
            -- Always add invisible before
            if Settings.SplitWords then
                result = result .. AddInvisible()
            end
            
            -- Randomly choose: homoglyph OR leetspeak
            local roll = math.random(1, 100)
            if roll <= Settings.Strength then
                if Settings.UseLeetspeak and math.random() > 0.5 then
                    char = GetLeet(char)
                else
                    char = GetHomoglyph(char)
                end
            end
            
            result = result .. char
            
            -- Add combining mark
            if Settings.UseCombining and math.random(1, 100) <= 30 then
                result = result .. AddCombining()
            end
            
            -- Add invisible after
            if Settings.UseInvisibles and math.random(1, 100) <= 40 then
                result = result .. AddInvisible()
            end
        end
    end
    return result
end

-- Maximum Bypass (every technique)
local function MaxBypass(text)
    if Settings.UsePhonetic then
        text = ApplyPhonetics(text)
    end
    
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        
        if char == " " then
            result = result .. AddInvisible() .. " " .. AddInvisible()
        else
            -- Invisible before
            result = result .. AddInvisible()
            
            -- Apply homoglyph
            char = GetHomoglyph(char)
            
            -- Maybe also leetspeak
            if Settings.UseLeetspeak and math.random(1, 100) <= 30 then
                char = GetLeet(char)
            end
            
            result = result .. char
            
            -- Combining mark
            if math.random(1, 100) <= 40 then
                result = result .. AddCombining()
            end
            
            -- Invisible after
            result = result .. AddInvisible()
        end
    end
    return result
end

-- Main Bypass Function
local function BypassText(text)
    if not Settings.Enabled or text == "" then return text end
    
    if Settings.Method == "Light" then
        return LightBypass(text)
    elseif Settings.Method == "Medium" then
        return MediumBypass(text)
    elseif Settings.Method == "Aggressive" then
        return AggressiveBypass(text)
    elseif Settings.Method == "Maximum" then
        return MaxBypass(text)
    end
    
    return AggressiveBypass(text)
end

-- Send Message Function
local function SendMessage(text)
    local bypassedText = BypassText(text)
    
    -- Try TextChatService (new chat)
    pcall(function()
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then
            channel:SendAsync(bypassedText)
        end
    end)
    
    -- Try legacy chat
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

-- Create UI
local Window = Rayfield:CreateWindow({
    Name = "Chat Bypasser v3.0",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Advanced Bypass",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- Main Tab
local MainTab = Window:CreateTab("Send", 4483362458)

MainTab:CreateSection("Type & Send")

MainTab:CreateInput({
    Name = "Message",
    PlaceholderText = "Type here and press enter...",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        if Text ~= "" then
            SendMessage(Text)
            Rayfield:Notify({
                Title = "Sent!",
                Content = "Message bypassed and sent",
                Duration = 2
            })
        end
    end
})

MainTab:CreateSection("Quick Settings")

MainTab:CreateToggle({
    Name = "Enable Bypasser",
    CurrentValue = true,
    Flag = "EnableToggle",
    Callback = function(Value)
        Settings.Enabled = Value
    end
})

MainTab:CreateToggle({
    Name = "Auto-Bypass Normal Chat",
    CurrentValue = true,
    Flag = "AutoToggle",
    Callback = function(Value)
        Settings.AutoBypass = Value
    end
})

MainTab:CreateDropdown({
    Name = "Bypass Strength",
    Options = {"Light", "Medium", "Aggressive", "Maximum"},
    CurrentOption = {"Aggressive"},
    Flag = "MethodDropdown",
    Callback = function(Option)
        Settings.Method = Option[1]
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSection("Bypass Methods")

SettingsTab:CreateSlider({
    Name = "Strength %",
    Range = {10, 100},
    Increment = 5,
    CurrentValue = 80,
    Flag = "StrengthSlider",
    Callback = function(Value)
        Settings.Strength = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Use Leetspeak (a→4, e→3)",
    CurrentValue = true,
    Flag = "LeetToggle",
    Callback = function(Value)
        Settings.UseLeetspeak = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Use Invisible Characters",
    CurrentValue = true,
    Flag = "InvisToggle",
    Callback = function(Value)
        Settings.UseInvisibles = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Use Combining Marks",
    CurrentValue = true,
    Flag = "CombineToggle",
    Callback = function(Value)
        Settings.UseCombining = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Use Phonetic Swaps",
    CurrentValue = true,
    Flag = "PhoneticToggle",
    Callback = function(Value)
        Settings.UsePhonetic = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Split Words (Invisible Chars)",
    CurrentValue = true,
    Flag = "SplitToggle",
    Callback = function(Value)
        Settings.SplitWords = Value
    end
})

-- Test Tab
local TestTab = Window:CreateTab("Test", 4483362458)

TestTab:CreateSection("Preview Bypass")

local LastPreview = ""

TestTab:CreateInput({
    Name = "Test Input",
    PlaceholderText = "Type to see bypass preview...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        LastPreview = BypassText(Text)
        print("══════════════════════")
        print("Original: " .. Text)
        print("Bypassed: " .. LastPreview)
        print("══════════════════════")
        Rayfield:Notify({
            Title = "Preview Ready",
            Content = "Check console (F9) to see result",
            Duration = 3
        })
    end
})

TestTab:CreateButton({
    Name = "Send Preview to Chat",
    Callback = function()
        if LastPreview ~= "" then
            SendMessage(LastPreview)
            Rayfield:Notify({
                Title = "Sent!",
                Content = "Preview sent to chat",
                Duration = 2
            })
        end
    end
})

TestTab:CreateButton({
    Name = "Copy Bypassed Text",
    Callback = function()
        if LastPreview ~= "" then
            setclipboard(LastPreview)
            Rayfield:Notify({
                Title = "Copied!",
                Content = "Bypassed text copied",
                Duration = 2
            })
        end
    end
})

-- Hook Chat for Auto-Bypass
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Settings.Enabled and Settings.AutoBypass and method == "FireServer" then
        local name = self.Name:lower()
        if string.find(name, "say") or 
           string.find(name, "chat") or 
           string.find(name, "message") then
            if type(args[1]) == "string" and args[1] ~= "" then
                args[1] = BypassText(args[1])
                return oldNamecall(self, unpack(args))
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

-- Hook TextChatService
pcall(function()
    local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    if channel then
        local oldSend = channel.SendAsync
        channel.SendAsync = function(self, message, ...)
            if Settings.Enabled and Settings.AutoBypass then
                message = BypassText(message)
            end
            return oldSend(self, message, ...)
        end
    end
end)

-- Loaded
Rayfield:Notify({
    Title = "Bypasser v3.0",
    Content = "Loaded! Use Aggressive or Maximum for bad words.",
    Duration = 5
})

print("Chat Bypasser v3.0 Loaded")
print("Methods: Light, Medium, Aggressive, Maximum")
