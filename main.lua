--[[
    ██╗░░██╗██████╗░██╗░░░░░
    ██║░██╔╝██╔══██╗██║░░░░░
    █████═╝░██████╦╝██║░░░░░
    ██╔═██╗░██╔══██╗██║░░░░░
    ██║░╚██╗██████╦╝███████╗
    ╚═╝░░╚═╝╚═════╝░╚══════╝
    
    KBL Bypasser v4.0
    Advanced Chat Bypass System
]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Settings
local Settings = {
    Enabled = true,
    AutoBypass = true,
    Method = "Aggressive",
    Strength = 85,
    UseLeetspeak = true,
    UseInvisibles = true,
    UseCombining = true,
    UsePhonetic = true,
    SplitWords = true,
    AutoResetFilter = false
}

-- Extended Homoglyphs
local Homoglyphs = {
    ["a"] = {"а", "ạ", "ά", "ä", "ȃ", "ǎ", "ᵃ", "ᴀ", "α", "ⓐ", "ａ"},
    ["b"] = {"ḅ", "ƅ", "ḃ", "ᵇ", "ɓ", "ʙ", "β", "ⓑ", "ｂ"},
    ["c"] = {"с", "ç", "ċ", "ć", "ᶜ", "ƈ", "ᴄ", "ⓒ", "ｃ"},
    ["d"] = {"ḍ", "đ", "ḋ", "ᵈ", "ɗ", "ᴅ", "ⓓ", "ｄ"},
    ["e"] = {"е", "ẹ", "ė", "ё", "ə", "ᵉ", "ɛ", "ᴇ", "ε", "ⓔ", "ｅ"},
    ["f"] = {"ḟ", "ƒ", "ᶠ", "ꜰ", "ⓕ", "ｆ"},
    ["g"] = {"ġ", "ğ", "ǵ", "ᵍ", "ɠ", "ɢ", "ⓖ", "ｇ"},
    ["h"] = {"һ", "ḥ", "ḣ", "ʰ", "ɦ", "ʜ", "ⓗ", "ｈ"},
    ["i"] = {"і", "ị", "ï", "ı", "ᵢ", "ɪ", "ι", "ⓘ", "ｉ"},
    ["j"] = {"ј", "ĵ", "ʲ", "ɉ", "ᴊ", "ⓙ", "ｊ"},
    ["k"] = {"κ", "ķ", "ḳ", "ᵏ", "ƙ", "ᴋ", "ⓚ", "ｋ"},
    ["l"] = {"ḷ", "ļ", "ł", "ˡ", "ɫ", "ʟ", "ⓛ", "ｌ"},
    ["m"] = {"ṃ", "ṁ", "ᵐ", "ɱ", "ᴍ", "ⓜ", "ｍ"},
    ["n"] = {"ṅ", "ñ", "ń", "ⁿ", "ɲ", "ɴ", "η", "ⓝ", "ｎ"},
    ["o"] = {"о", "ọ", "ö", "ȯ", "ᵒ", "ɵ", "ᴏ", "σ", "ο", "ⓞ", "ｏ"},
    ["p"] = {"р", "ṗ", "ᵖ", "ƥ", "ᴘ", "ρ", "ⓟ", "ｐ"},
    ["q"] = {"ԛ", "ɋ", "ᑫ", "ⓠ", "ｑ"},
    ["r"] = {"ṛ", "ŕ", "ṙ", "ʳ", "ɾ", "ʀ", "ⓡ", "ｒ"},
    ["s"] = {"ѕ", "ṡ", "ś", "ˢ", "ʂ", "ꜱ", "ς", "ⓢ", "ｓ"},
    ["t"] = {"ṭ", "ţ", "ṫ", "ᵗ", "ƭ", "ᴛ", "τ", "ⓣ", "ｔ"},
    ["u"] = {"ụ", "ü", "ů", "ᵘ", "ʉ", "ᴜ", "υ", "ⓤ", "ｕ"},
    ["v"] = {"ṿ", "ᵛ", "ⱱ", "ᴠ", "ν", "ⓥ", "ｖ"},
    ["w"] = {"ẃ", "ẅ", "ʷ", "ɯ", "ᴡ", "ω", "ⓦ", "ｗ"},
    ["x"] = {"х", "ẋ", "ˣ", "χ", "ⓧ", "ｘ"},
    ["y"] = {"у", "ý", "ÿ", "ʸ", "ɏ", "ʏ", "γ", "ⓨ", "ｙ"},
    ["z"] = {"ẓ", "ż", "ź", "ᶻ", "ƶ", "ᴢ", "ⓩ", "ｚ"}
}

-- Leetspeak Map
local Leetspeak = {
    ["a"] = {"4", "@", "/-\\"},
    ["e"] = {"3", "€", "£"},
    ["i"] = {"1", "!", "|"},
    ["o"] = {"0", "()", "[]"},
    ["s"] = {"5", "$", "z"},
    ["t"] = {"7", "+", "†"},
    ["b"] = {"8", "ß", "|3"},
    ["g"] = {"9", "6", "&"},
    ["l"] = {"1", "|", "£"}
}

-- Phonetic Replacements
local Phonetics = {
    ["ck"] = {"cc", "kk", "k", "c"},
    ["ph"] = {"f", "ff"},
    ["f"] = {"ph", "ff"},
    ["x"] = {"ks", "cks", "cs"},
    ["qu"] = {"kw", "qw", "kv"},
    ["oo"] = {"uu", "u", "øø"},
    ["ee"] = {"ii", "i", "ea"},
    ["ss"] = {"zz", "s", "sz"},
    ["tt"] = {"dd", "t", "dt"},
    ["ck"] = {"k", "cc", "kc"},
    ["th"] = {"d", "t", "z"},
    ["wh"] = {"w", "hw"}
}

-- Invisible Characters
local Invisibles = {
    "\226\128\139",  -- Zero-width space
    "\226\128\140",  -- Zero-width non-joiner
    "\226\128\141",  -- Zero-width joiner
    "\226\129\160",  -- Word joiner
    "\194\173",      -- Soft hyphen
    "\239\187\191"   -- Zero-width no-break space
}

-- Combining Marks
local CombiningMarks = {
    "\204\129",  -- Acute
    "\204\128",  -- Grave
    "\204\132",  -- Macron
    "\204\135",  -- Dot above
    "\204\163",  -- Dot below
    "\204\134",  -- Breve
    "\204\136"   -- Diaeresis
}

-- Filter Reset Function
local function ResetFilter()
    pcall(function()
        -- Method 1: Spam empty messages to reset cache
        for i = 1, 5 do
            pcall(function()
                local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                if channel then
                    channel:SendAsync("\226\128\139")
                end
            end)
            task.wait(0.1)
        end
    end)
    
    pcall(function()
        -- Method 2: Reset through legacy chat
        local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvents then
            local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
            if sayMessage then
                for i = 1, 3 do
                    sayMessage:FireServer("\226\128\139", "All")
                    task.wait(0.1)
                end
            end
        end
    end)
end

-- Bypass Helper Functions
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
    local result = text:lower()
    for pattern, replacements in pairs(Phonetics) do
        if string.find(result, pattern) then
            if math.random(1, 100) <= Settings.Strength then
                local replacement = replacements[math.random(1, #replacements)]
                result = result:gsub(pattern, replacement)
            end
        end
    end
    return result
end

-- Light Bypass
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

-- Aggressive Bypass
local function AggressiveBypass(text)
    if Settings.UsePhonetic then
        text = ApplyPhonetics(text)
    end
    
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        
        if char == " " then
            result = result .. " "
        else
            if Settings.SplitWords then
                result = result .. AddInvisible()
            end
            
            local roll = math.random(1, 100)
            if roll <= Settings.Strength then
                if Settings.UseLeetspeak and math.random() > 0.6 then
                    char = GetLeet(char)
                else
                    char = GetHomoglyph(char)
                end
            end
            
            result = result .. char
            
            if Settings.UseCombining and math.random(1, 100) <= 35 then
                result = result .. AddCombining()
            end
            
            if Settings.UseInvisibles and math.random(1, 100) <= 45 then
                result = result .. AddInvisible()
            end
        end
    end
    return result
end

-- Maximum Bypass
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
            -- Always invisible before
            result = result .. AddInvisible()
            
            -- Always homoglyph
            char = GetHomoglyph(char)
            
            -- Sometimes also leetspeak
            if Settings.UseLeetspeak and math.random(1, 100) <= 40 then
                local lower = string.lower(char)
                if Leetspeak[lower] then
                    char = GetLeet(lower)
                end
            end
            
            result = result .. char
            
            -- Combining mark
            if math.random(1, 100) <= 50 then
                result = result .. AddCombining()
            end
            
            -- Always invisible after
            result = result .. AddInvisible()
        end
    end
    return result
end

-- Main Bypass Function
local function BypassText(text)
    if not Settings.Enabled or text == "" then return text end
    
    -- Auto reset filter if enabled
    if Settings.AutoResetFilter then
        ResetFilter()
        task.wait(0.2)
    end
    
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
    Name = "KBL Bypasser v4.0",
    LoadingTitle = "KBL Bypasser",
    LoadingSubtitle = "Loading...",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("⚠️ Language Setup")

MainTab:CreateParagraph({
    Title = "IMPORTANT",
    Content = "For best results, change your Roblox language to:\n• Қазақ тілі (Kazakh)\n• Shqipe (Albanian)\n\nGo to: Roblox Settings → Language"
})

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

MainTab:CreateSection("Filter Reset")

MainTab:CreateToggle({
    Name = "Auto Reset Filter",
    CurrentValue = false,
    Flag = "AutoResetToggle",
    Callback = function(Value)
        Settings.AutoResetFilter = Value
    end
})

MainTab:CreateButton({
    Name = "Reset Filter Now",
    Callback = function()
        ResetFilter()
        Rayfield:Notify({
            Title = "Filter Reset",
            Content = "Filter cache cleared",
            Duration = 2
        })
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSection("Bypass Strength")

SettingsTab:CreateSlider({
    Name = "Strength %",
    Range = {10, 100},
    Increment = 5,
    CurrentValue = 85,
    Flag = "StrengthSlider",
    Callback = function(Value)
        Settings.Strength = Value
    end
})

SettingsTab:CreateSection("Bypass Methods")

SettingsTab:CreateToggle({
    Name = "Leetspeak (a→4, e→3)",
    CurrentValue = true,
    Flag = "LeetToggle",
    Callback = function(Value)
        Settings.UseLeetspeak = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Invisible Characters",
    CurrentValue = true,
    Flag = "InvisToggle",
    Callback = function(Value)
        Settings.UseInvisibles = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Combining Marks",
    CurrentValue = true,
    Flag = "CombineToggle",
    Callback = function(Value)
        Settings.UseCombining = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Phonetic Swaps (f→ph)",
    CurrentValue = true,
    Flag = "PhoneticToggle",
    Callback = function(Value)
        Settings.UsePhonetic = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Split Words",
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
    PlaceholderText = "Type to preview...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        LastPreview = BypassText(Text)
        print("═══════════════════════════")
        print("Original: " .. Text)
        print("Bypassed: " .. LastPreview)
        print("═══════════════════════════")
        Rayfield:Notify({
            Title = "Preview Ready",
            Content = "Check console (F9)",
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
                Content = "Preview sent",
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
                Content = "Text copied to clipboard",
                Duration = 2
            })
        end
    end
})

-- Hook Chat for Auto-Bypass
pcall(function()
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
end)

-- Hook TextChatService
pcall(function()
    local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    if channel then
        local oldSend = channel.SendAsync
        channel.SendAsync = function(self, message, ...)
            if Settings.Enabled and Settings.AutoBypass and message ~= "\226\128\139" then
                message = BypassText(message)
            end
            return oldSend(self, message, ...)
        end
    end
end)

-- Startup Notification
Rayfield:Notify({
    Title = "KBL Bypasser v4.0",
    Content = "Loaded! Set language to Kazakh or Albanian for best results.",
    Duration = 6
})

print("═══════════════════════════")
print("KBL Bypasser v4.0 Loaded")
print("Tip: Use Kazakh or Albanian language")
print("═══════════════════════════")
