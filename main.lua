--[[
    ██╗░░██╗██████╗░██╗░░░░░
    ██║░██╔╝██╔══██╗██║░░░░░
    █████═╝░██████╦╝██║░░░░░
    ██╔═██╗░██╔══██╗██║░░░░░
    ██║░╚██╗██████╦╝███████╗
    ╚═╝░░╚═╝╚═════╝░╚══════╝
    
    KBL Bypasser v6.0 — ADVANCED
    Ultimate Chat Bypass with Anti-Detection
]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Advanced Settings
local Settings = {
    Enabled = true,
    AutoBypass = true,
    AutoResetFilter = false,
    AutoSpam = false,
    SpamMessage = "",
    SpamSpeed = 1,
    PreserveCase = true,
    UseZalgo = false,
    UseLeet = false,
    UsePhonetic = false,
    RandomCase = false,
    AntiDetect = true,
    ZalgoIntensity = 3,
    BypassStrength = 85
}

-- EXTENDED Homoglyphs (including rare ones)
local Homoglyphs = {
    ["a"] = {"а", "ạ", "ά", "ä", "ȃ", "ǎ", "ᵃ", "ᴀ", "α", "ⓐ", "ａ", "А", "Ạ", "Ά", "Ä", "Ȃ", "Ǎ", "ᴬ", "ᴬ", "Α", "ⓐ", "ａ", "𝒶", "𝖆", "𝓪", "𝘢", "𝙖", "𝚊", "𝛼", "𝜶", "𝝰", "𝞪"},
    ["b"] = {"ḅ", "ƅ", "ḃ", "ᵇ", "ɓ", "ʙ", "β", "ⓑ", "ｂ", "Б", "Ḅ", "Ɓ", "Ḃ", "ᴮ", "Ɓ", "ʙ", "Β", "ⓑ", "ｂ", "𝒷", "𝖇", "𝓫", "𝘣", "𝙗", "𝚋", "𝛽", "𝜷", "𝝱", "𝞫"},
    ["c"] = {"с", "ç", "ċ", "ć", "ᶜ", "ƈ", "ᴄ", "ⓒ", "ｃ", "С", "Ç", "Ċ", "Ć", "ᶜ", "Ƈ", "ᴄ", "С", "ⓒ", "ｃ", "𝒸", "𝖈", "𝓬", "𝘤", "𝙘", "𝚌", "𝛾", "𝜸", "𝝲", "𝞬"},
    ["d"] = {"ḍ", "đ", "ḋ", "ᵈ", "ɗ", "ᴅ", "ⓓ", "ｄ", "Д", "Ḍ", "Đ", "Ḋ", "ᴰ", "Ɗ", "ᴅ", "Д", "ⓓ", "ｄ", "𝒹", "𝖉", "𝓭", "𝘥", "𝙙", "𝚍", "𝛿", "��", "𝝳", "𝞭"},
    ["e"] = {"е", "ẹ", "ė", "ё", "ə", "ᵉ", "ɛ", "ᴇ", "ε", "ⓔ", "ｅ", "Е", "Ẹ", "Ė", "Ё", "Ǝ", "ᴱ", "Ɇ", "ᴱ", "Ε", "ⓔ", "ｅ", "𝒺", "𝖊", "𝓮", "𝘦", "𝙚", "𝚎", "𝜖", "𝝚", "𝞮"},
    ["f"] = {"ḟ", "ƒ", "ᶠ", "ꜰ", "ⓕ", "ｆ", "Ф", "Ḟ", "Ƒ", "ᶠ", "ꜰ", "ⓕ", "ｆ", "𝒻", "𝖋", "𝓯", "𝘧", "𝙛", "𝚏", "𝟋"},
    ["g"] = {"ġ", "ğ", "ǵ", "ᵍ", "ɠ", "ɢ", "ⓖ", "ｇ", "Г", "Ġ", "Ğ", "Ǵ", "ᴳ", "Ɠ", "ɢ", "Г", "ⓖ", "ｇ", "𝑔", "𝖌", "𝓰", "𝘨", "𝙜", "𝚐", "𝛾", "𝜸", "��", "𝞬"},
    ["h"] = {"һ", "ḥ", "ḣ", "ʰ", "ɦ", "ʜ", "ⓗ", "ｈ", "Н", "Ḥ", "Ḣ", "ʰ", "ɦ", "ʜ", "Н", "ⓗ", "ｈ", "𝒽", "𝖍", "𝓱", "𝘩", "𝙝", "𝚑", "𝛩", "𝜣", "𝝥", "𝞣"},
    ["i"] = {"і", "ị", "ï", "ı", "ᵢ", "ɪ", "ι", "ⓘ", "ｉ", "І", "Ị", "Ï", "I", "ᵢ", "ɪ", "Ι", "ⓘ", "ｉ", "𝒾", "�", "𝓲", "𝘪", "𝙞", "𝚒", "𝜄", "𝝸", "��"},
    ["j"] = {"ј", "ĵ", "ʲ", "ɉ", "ᴊ", "ⓙ", "ｊ", "Ј", "Ĵ", "ʲ", "ɉ", "ᴊ", "Ј", "ⓙ", "ｊ", "𝒿", "𝖏", "𝓳", "𝘫", "𝙟", "𝚓", "𝚓"},
    ["k"] = {"κ", "ķ", "ḳ", "ᵏ", "ƙ", "ᴋ", "ⓚ", "ｋ", "К", "Ķ", "Ḱ", "ᴋ", "Ƙ", "ᴋ", "К", "ⓚ", "ｋ", "𝓀", "𝖐", "𝓴", "𝘬", "𝙠", "𝚔", "𝜅", "��", "𝞐"},
    ["l"] = {"ḷ", "ļ", "ł", "ˡ", "ɫ", "ʟ", "ⓛ", "ｌ", "Л", "Ḷ", "Ļ", "Ł", "ˡ", "ɫ", "ʟ", "Л", "ⓛ", "ｌ", "𝓁", "𝖑", "𝓵", "𝘭", "𝙡", "𝚕", "𝛬", "𝜦", "𝝞", "𝞜"},
    ["m"] = {"ṃ", "ṁ", "ᵐ", "ɱ", "ᴍ", "ⓜ", "ｍ", "М", "Ṃ", "Ṁ", "ᴹ", "ɱ", "ᴍ", "М", "ⓜ", "ｍ", "𝓂", "𝖒", "𝓶", "𝘮", "𝙢", "𝚖", "𝛭", "𝜧", "𝝟", "𝞝"},
    ["n"] = {"ṅ", "ñ", "ń", "ⁿ", "ɲ", "ɴ", "η", "ⓝ", "ｎ", "Н", "Ṇ", "Ñ", "Ń", "ⁿ", "ɲ", "ɴ", "Н", "ⓝ", "ｎ", "𝓃", "𝖓", "𝓷", "𝘯", "𝙣", "𝚗", "𝛮", "𝜨", "��", "𝞞"},
    ["o"] = {"о", "ọ", "ö", "ȯ", "ᵒ", "ɵ", "ᴏ", "σ", "ο", "ⓞ", "ｏ", "О", "Ọ", "Ö", "Ȯ", "ᵒ", "ɵ", "ᴏ", "Σ", "Ο", "ⓞ", "ｏ", "𝑜", "𝖔", "𝓸", "��", "��", "𝚘", "𝛰", "��", "𝝾", "𝞸"},
    ["p"] = {"р", "ṗ", "ᵖ", "ƥ", "ᴘ", "ρ", "ⓟ", "ｐ", "Р", "Ṗ", "ᵖ", "ƥ", "ᴘ", "ρ", "Р", "ⓟ", "ｐ", "𝓅", "𝖕", "𝓹", "𝘱", "��", "𝚙", "𝛲", "𝜌", "𝝦", "𝞺"},
    ["q"] = {"ԛ", "ɋ", "ᑫ", "ⓠ", "ｑ", "Ԛ", "Ƣ", "ᑭ", "ⓠ", "ｑ", "𝓆", "�", "𝓺", "𝘲", "𝙦", "𝚚", "𝛳", "𝝎", "𝞴"},
    ["r"] = {"ṛ", "ŕ", "ṙ", "ʳ", "ɾ", "ʀ", "ⓡ", "ｒ", "Р", "Ṛ", "Ŕ", "Ṙ", "ʳ", "ɾ", "ʀ", "Р", "ⓡ", "ｒ", "𝓇", "𝖗", "𝓻", "𝘳", "𝙧", "𝚛", "𝛱", "𝜌", "𝝆", "𝞀"},
    ["s"] = {"ѕ", "ṡ", "ś", "ˢ", "ʂ", "ꜱ", "ς", "ⓢ", "ｓ", "С", "Ṡ", "Ś", "ˢ", "ʂ", "ꜱ", "ς", "С", "ⓢ", "ｓ", "𝓈", "�", "𝓼", "𝘴", "𝙨", "𝚜", "𝛴", "𝜎", "𝝈", "𝞂"},
    ["t"] = {"ṭ", "ţ", "ṫ", "ᵗ", "ƭ", "ᴛ", "τ", "ⓣ", "ｔ", "Т", "Ṭ", "Ţ", "Ṫ", "ᵗ", "ƭ", "ᴛ", "τ", "Т", "ⓣ", "ｔ", "𝓉", "𝖙", "𝓽", "𝘵", "𝙩", "𝚝", "𝛵", "𝜏", "��", "𝞃"},
    ["u"] = {"ụ", "ü", "ů", "ᵘ", "ʉ", "ᴜ", "υ", "ⓤ", "ｕ", "У", "Ụ", "Ü", "Ů", "ᵘ", "ʉ", "ᴜ", "υ", "У", "ⓤ", "ｕ", "𝓊", "𝖚", "𝓾", "𝘶", "𝙪", "𝚞", "𝛾", "𝜐", "𝝾", "𝞾"},
    ["v"] = {"ṿ", "ᵛ", "ⱱ", "ᴠ", "ν", "ⓥ", "ｖ", "В", "Ṿ", "ᵛ", "ⱱ", "ᴠ", "ν", "В", "ⓥ", "ｖ", "𝓋", "𝖛", "𝓿", "𝘷", "𝙫", "𝚟", "𝛻", "𝜈", "𝝼", "𝞶"},
    ["w"] = {"ẃ", "ẅ", "ʷ", "ɯ", "ᴡ", "ω", "ⓦ", "ｗ", "В", "Ẃ", "Ẅ", "ʷ", "ɯ", "ᴡ", "ω", "В", "ⓦ", "ｗ", "𝓌", "�", "𝔀", "𝘸", "𝙬", "𝚠", "𝛷", "𝜔", "𝝎", "𝞸"},
    ["x"] = {"х", "ẋ", "ˣ", "χ", "ⓧ", "ｘ", "Х", "Ẋ", "ˣ", "χ", "Х", "ⓧ", "ｘ", "𝓍", "𝔁", "𝔁", "𝘹", "𝙭", "𝚡", "𝛸", "脸", "脸", "脸"},
    ["y"] = {"у", "ý", "ÿ", "ʸ", "ɏ", "ʏ", "γ", "ⓨ", "ｙ", "У", "Ỳ", "Ÿ", "ʸ", "ɏ", "ʏ", "γ", "У", "ⓨ", "ｙ", "𝓎", "𝖞", "𝔂", "𝘺", "𝙮", "𝚢", "𝛾", "𝜈", "𝝾", "𝞾"},
    ["z"] = {"ẓ", "ż", "ź", "ᶻ", "ƶ", "ᴢ", "ⓩ", "ｚ", "З", "Ẑ", "Ż", "Ẑ", "ᶻ", "Ƶ", "ᴢ", "З", "ⓩ", "ｚ", "𝓏", "𝖟", "𝓏", "𝘻", "𝙯", "𝚣", "𝛤", "𝜁", "𝝭", "𝞉"}
}

-- Advanced Invisible Characters (more variety)
local Invisibles = {
    "\226\128\139",  -- Zero-width space
    "\226\128\140",  -- Zero-width non-joiner
    "\226\128\141",  -- Zero-width joiner
    "\226\129\160",  -- Word joiner
    "\194\173",      -- Soft hyphen
    "\226\128\138",  -- Zero-width non-breaking space
    "\226\129\159",  -- Invisible separator
    "\226\128\132",  -- Zero-width non-joiner variant
    "\226\128\133",  -- Zero-width joiner variant
    "\226\128\134",  -- Zero-width joiner variant 2
    "\226\128\135",  -- Zero-width joiner variant 3
    "\226\128\136",  -- Zero-width joiner variant 4
    "\226\128\137",  -- Zero-width joiner variant 5
    "\226\129\161",  -- Function application
    "\226\129\162",  -- Invisible times
    "\226\129\163",  -- Invisible separator
    "\226\129\164",  -- Invisible plus
    "\226\129\165"   -- Invisible comma
}

-- Advanced Combining Marks (Zalgo)
local ZalgoMarks = {
    "\u0300", "\u0301", "\u0302", "\u0303", "\u0304", "\u0305", "\u0306", "\u0307",
    "\u0308", "\u0309", "\u030A", "\u030B", "\u030C", "\u030D", "\u030E", "\u030F",
    "\u0310", "\u0311", "\u0312", "\u0313", "\u0314", "\u0315", "\u0316", "\u0317",
    "\u0318", "\u0319", "\u031A", "\u031B", "\u031C", "\u031D", "\u031E", "\u031F",
    "\u0320", "\u0321", "\u0322", "\u0323", "\u0324", "\u0325", "\u0326", "\u0327",
    "\u0328", "\u0329", "\u032A", "\u032B", "\u032C", "\u032D", "\u032E", "\u032F",
    "\u0330", "\u0331", "\u0332", "\u0333", "\u0334", "\u0335", "\u0336", "\u0337",
    "\u0338", "\u0339", "\u033A", "\u033B", "\u033C", "\u033D", "\u033E", "\u033F",
    "\u0340", "\u0341", "\u0342", "\u0343", "\u0344", "\u0345", "\u0346", "\u0347",
    "\u0348", "\u0349", "\u034A", "\u034B", "\u034C", "\u034D", "\u034E", "\u034F",
    "\u0350", "\u0351", "\u0352", "\u0353", "\u0354", "\u0355", "\u0356", "\u0357",
    "\u0358", "\u0359", "\u035A", "\u035B", "\u035C", "\u035D", "\u035E", "\u035F",
    "\u0360", "\u0361", "\u0362", "\u0363", "\u0364", "\u0365", "\u0366", "\u0367",
    "\u0368", "\u0369", "\u036A", "\u036B", "\u036C", "\u036D", "\u036E", "\u036F"
}

-- Leet Speak Dictionary
local LeetDict = {
    ["a"] = "4", ["e"] = "3", ["g"] = "6", ["i"] = "1", ["o"] = "0",
    ["s"] = "5", ["t"] = "7", ["z"] = "2", ["b"] = "8", ["l"] = "1",
    ["A"] = "4", ["E"] = "3", ["G"] = "6", ["I"] = "1", ["O"] = "0",
    ["S"] = "5", ["T"] = "7", ["Z"] = "2", ["B"] = "8", ["L"] = "1"
}

-- Phonetic Swaps
local PhoneticDict = {
    ["ph"] = "f", ["th"] = "d", ["ck"] = "x", ["gh"] = "f",
    ["qu"] = "kw", ["x"] = "z", ["c"] = "k", ["y"] = "i",
    ["PH"] = "F", ["TH"] = "D", ["CK"] = "X", ["GH"] = "F",
    ["QU"] = "KW", ["X"] = "Z", ["C"] = "K", ["Y"] = "I"
}

-- Advanced Filter Reset Function
local function ResetFilter()
    pcall(function()
        -- Method 1: Multiple invisible chars
        for i = 1, 10 do
            pcall(function()
                local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                if channel then
                    local invis = Invisibles[math.random(1, #Invisibles)]
                    channel:SendAsync(invis)
                end
            end)
            task.wait(0.05)
        end
    end)

    pcall(function()
        -- Method 2: Legacy chat with variations
        local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvents then
            local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
            if sayMessage then
                for i = 1, 5 do
                    local invis = Invisibles[math.random(1, #Invisibles)]
                    sayMessage:FireServer(invis, "All")
                    task.wait(0.05)
                end
            end
        end
    end)
end

-- Advanced Bypass Helper Functions
local function AddInvisible()
    return Invisibles[math.random(1, #Invisibles)]
end

local function AddZalgo(char, intensity)
    if not Settings.UseZalgo or intensity <= 0 then return char end
    
    local result = char
    local numMarks = math.random(1, intensity)
    
    for i = 1, numMarks do
        local mark = ZalgoMarks[math.random(1, #ZalgoMarks)]
        result = result .. mark
    end
    
    return result
end

local function GetHomoglyph(char, preserveCase)
    local lower = string.lower(char)
    if Homoglyphs[lower] then
        local options = Homoglyphs[lower]
        local chosen = options[math.random(1, #options)]
        
        -- Preserve case if enabled
        if preserveCase and char == string.upper(char) then
            chosen = string.upper(chosen)
        end
        
        return chosen
    end
    return char
end

local function ApplyLeet(text)
    if not Settings.UseLeet then return text end
    
    local result = text
    for original, replacement in pairs(LeetDict) do
        result = result:gsub(original, replacement)
    end
    return result
end

local function ApplyPhonetic(text)
    if not Settings.UsePhonetic then return text end
    
    local result = text
    for original, replacement in pairs(PhoneticDict) do
        result = result:gsub(original, replacement)
    end
    return result
end

local function RandomCase(text)
    if not Settings.RandomCase then return text end
    
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        if math.random(1, 2) == 1 then
            result = result .. string.upper(char)
        else
            result = result .. string.lower(char)
        end
    end
    return result
end

local function AntiDetect(text)
    if not Settings.AntiDetect then return text end
    
    -- Add random patterns to avoid detection
    local patterns = {
        function(t) return t:gsub(" ", AddInvisible() .. " " .. AddInvisible()) end,
        function(t) return t:gsub("(%w)", function(c) return c .. AddInvisible() end) end,
        function(t) return t:gsub("(%w)", function(c) return AddInvisible() .. c end) end,
        function(t) return t:gsub("(%w)", function(c) return AddInvisible() .. c .. AddInvisible() end) end,
        function(t) return t:gsub("(%w)", function(c) return c .. ZalgoMarks[math.random(1, #ZalgoMarks)] end) end
    }
    
    local result = text
    for i = 1, math.random(1, 3) do
        local pattern = patterns[math.random(1, #patterns)]
        result = pattern(result)
    end
    
    return result
end

-- Main Advanced Bypass Function
local function BypassText(text)
    if not Settings.Enabled or text == "" then return text end
    
    -- Auto reset filter if enabled
    if Settings.AutoResetFilter then
        ResetFilter()
        task.wait(0.2)
    end
    
    -- Apply transformations
    local result = text
    result = ApplyLeet(result)
    result = ApplyPhonetic(result)
    result = RandomCase(result)
    
    -- Character-by-character processing
    local final = ""
    for i = 1, #result do
        local char = result:sub(i, i)
        
        if char == " " then
            final = final .. " "
        else
            -- Add invisible before
            if math.random(1, 100) <= Settings.BypassStrength then
                final = final .. AddInvisible()
            end
            
            -- Get homoglyph
            char = GetHomoglyph(char, Settings.PreserveCase)
            
            -- Add Zalgo
            char = AddZalgo(char, Settings.ZalgoIntensity)
            
            final = final .. char
            
            -- Add invisible after
            if math.random(1, 100) <= Settings.BypassStrength then
                final = final .. AddInvisible()
            end
        end
    end
    
    -- Apply anti-detection
    final = AntiDetect(final)
    
    return final
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

-- Advanced Auto Spam Function
local function AutoSpam()
    while Settings.AutoSpam do
        if Settings.SpamMessage ~= "" then
            -- Vary the spam message to avoid detection
            local message = Settings.SpamMessage
            
            -- Add random variations
            if math.random(1, 100) <= 50 then
                message = message .. " " .. AddInvisible()
            end
            
            if math.random(1, 100) <= 30 then
                message = AddInvisible() .. message
            end
            
            SendMessage(message)
            task.wait(Settings.SpamSpeed)
        end
    end
end

-- Create Advanced UI
local Window = Rayfield:CreateWindow({
    Name = "KBL Bypasser v6.0 — ADVANCED",
    LoadingTitle = "KBL Bypasser",
    LoadingSubtitle = "Loading Advanced Bypass...",
    ConfigurationSaving = {
        Enabled = false
    },
    CustomTheme = {
        Background = Color3.fromRGB(20, 20, 20),
        Titlebar = Color3.fromRGB(128, 0, 128),
        Tab = Color3.fromRGB(75, 0, 130),
        Accent = Color3.fromRGB(128, 0, 128),
        TextColor = Color3.fromRGB(255, 255, 255)
    }
})

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

MainTab:CreateToggle({
    Name = "Preserve Case (CAPS)",
    CurrentValue = true,
    Flag = "PreserveCaseToggle",
    Callback = function(Value)
        Settings.PreserveCase = Value
    end
})

MainTab:CreateSlider({
    Name = "Bypass Strength",
    Range = {1, 100},
    Increment = 1,
    CurrentValue = 85,
    Flag = "BypassStrengthSlider",
    Callback = function(Value)
        Settings.BypassStrength = Value
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

-- Advanced Tab
local AdvancedTab = Window:CreateTab("Advanced", 4483362458)

AdvancedTab:CreateSection("Advanced Techniques")

AdvancedTab:CreateToggle({
    Name = "Use Zalgo Text",
    CurrentValue = false,
    Flag = "UseZalgoToggle",
    Callback = function(Value)
        Settings.UseZalgo = Value
    end
})

AdvancedTab:CreateSlider({
    Name = "Zalgo Intensity",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 3,
    Flag = "ZalgoIntensitySlider",
    Callback = function(Value)
        Settings.ZalgoIntensity = Value
    end
})

AdvancedTab:CreateToggle({
    Name = "Use Leet Speak",
    CurrentValue = false,
    Flag = "UseLeetToggle",
    Callback = function(Value)
        Settings.UseLeet = Value
    end
})

AdvancedTab:CreateToggle({
    Name = "Use Phonetic Swaps",
    CurrentValue = false,
    Flag = "UsePhoneticToggle",
    Callback = function(Value)
        Settings.UsePhonetic = Value
    end
})

AdvancedTab:CreateToggle({
    Name = "Random Case",
    CurrentValue = false,
    Flag = "RandomCaseToggle",
    Callback = function(Value)
        Settings.RandomCase = Value
    end
})

AdvancedTab:CreateToggle({
    Name = "Anti-Detection",
    CurrentValue = true,
    Flag = "AntiDetectToggle",
    Callback = function(Value)
        Settings.AntiDetect = Value
    end
})

-- Auto Spam Tab
local SpamTab = Window:CreateTab("Auto Spam", 4483362458)

SpamTab:CreateSection("Auto Spam Settings")

SpamTab:CreateToggle({
    Name = "Enable Auto Spam",
    CurrentValue = false,
    Flag = "AutoSpamToggle",
    Callback = function(Value)
        Settings.AutoSpam = Value
        if Value then
            spawn(AutoSpam)
        end
    end
})

SpamTab:CreateInput({
    Name = "Spam Message",
    PlaceholderText = "Enter your spam message here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Settings.SpamMessage = Text
    end
})

SpamTab:CreateSlider({
    Name = "Spam Speed",
    Range = {0.1, 5},
    Increment = 0.1,
    CurrentValue = 1,
    Flag = "SpamSpeedSlider",
    Callback = function(Value)
        Settings.SpamSpeed = Value
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
    Title = "KBL Bypasser v6.0 — ADVANCED",
    Content = "Loaded! Set language to Kazakh or Albanian for best results.",
    Duration = 6
})

print("═══════════════════════════")
print("KBL Bypasser v6.0 — ADVANCED")
print("Tip: Use Kazakh or Albanian language")
print("═══════════════════════════")
