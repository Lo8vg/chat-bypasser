--[[
    ██╗░░██╗██████╗░██╗░░░░░
    ██║░██╔╝██╔══██╗██║░░░░░
    █████═╝░██████╦╝██║░░░░░
    ██╔═██╗░██╔══██╗██║░░░░░
    ██║░╚██╗██████╦╝███████╗
    ╚═╝░░╚═╝╚═════╝░╚══════╝
    
    KBL Bypasser v5.0
    Simple & Effective Chat Bypass
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

-- Main Bypass Function
local function BypassText(text)
    if not Settings.Enabled or text == "" then return text end

    -- Auto reset filter if enabled
    if Settings.AutoResetFilter then
        ResetFilter()
        task.wait(0.2)
    end

    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)

        if char == " " then
            result = result .. " "
        else
            -- Always invisible before
            result = result .. AddInvisible()

            -- Always homoglyph
            char = GetHomoglyph(char)

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
    Name = "KBL Bypasser v5.0",
    LoadingTitle = "KBL Bypasser",
    LoadingSubtitle = "Loading...",
    ConfigurationSaving = {
        Enabled = false
    },
    CustomTheme = {
        Background = Color3.fromRGB(30, 30, 30),
        Titlebar = Color3.fromRGB(128, 0, 128),
        Tab = Color3.fromRGB(75, 0, 130),
        Accent = Color3.fromRGB(128, 0, 128),
        TextColor = Color3.fromRGB(255, 255, 255)
    }
})

-- Custom Icon
local Icon = [[
█████████████████████████████████████████████████
█▄─▄▄─█▄─▄▄─██▀▄─██▄─▄▄▀█▄─▄███▄─▄▄─█─▄▄▄▄█─▄▄▄▄█
██─▄████─▄█▀██─▀─███─▄─▄██─██▀██─▄█▀█▄▄▄▄─█▄▄▄▄─█
▀▄▄▄▀▀▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀
█████████████████████████████████████████████████
█─▄▄▄─█─█─██▀▄─██─▄─▄─█
█─███▀█─▄─██─▀─████─███
▀▄▄▄▄▄▀▄▀▄▀▄▄▀▄▄▀▀▄▄▄▀▀
█████████████████████████████████████████████████
█▄─▄─▀█▄─█─▄█▄─▄▄─██▀▄─██─▄▄▄▄█─▄▄▄▄█▄─▄▄─█▄─▄▄▀█
██─▄─▀██▄─▄███─▄▄▄██─▀─██▄▄▄▄─█▄▄▄▄─██─▄█▀██─▄─▄█
▀▄▄▄▄▀▀▀▄▄▄▀▀▄▄▄▀▀▀▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀
]]

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("⚠️ Language Setup")

MainTab:CreateParagraph({
    Title = "IMPORTANT",
    Content = "For best results, change your Roblox language to:\n• Қазақ тілі (Kazakh)\n• Shqipe (Albanian)\n\nGo to: Roblox Settings → Language"
})

MainTab:CreateSection("Auto Bypass")

MainTab:CreateToggle({
    Name = "Auto Bypass",
    CurrentValue = true,
    Flag = "AutoToggle",
    Callback = function(Value)
        Settings.AutoBypass = Value
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
    Title = "KBL Bypasser v5.0",
    Content = "Loaded! Set language to Kazakh or Albanian for best results.",
    Duration = 6
})

print("═══════════════════════════")
print("KBL Bypasser v5.0 Loaded")
print("Tip: Use Kazakh or Albanian language")
print("═══════════════════════════")
