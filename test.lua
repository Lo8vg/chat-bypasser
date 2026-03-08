-- Chat Bypass Hub (Compact 150x150)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Bypass methods
local bypassMethods = {
    UNICODE = {name = "Unicode", enabled = false, map = {
        a = {"а", "ɑ", "α"}, b = {"Ь", "ḇ"}, c = {"с", "ϲ"}, d = {"ԁ", "ḍ"}, e = {"е", "ҽ"},
        f = {"ſ"}, g = {"ɡ", "ǥ"}, h = {"һ"}, i = {"і", "ɩ"}, j = {"ϳ"}, k = {"κ", "ķ"},
        l = {"ⅼ"}, m = {"м"}, n = {"ո", "η"}, o = {"о", "ο"}, p = {"ρ"}, q = {"ԛ"},
        r = {"г"}, s = {"ѕ", "ʂ"}, t = {"τ"}, u = {"υ"}, v = {"ν"}, w = {"ԝ"},
        x = {"χ"}, y = {"у", "γ"}, z = {"ζ"}, A = {"А", "Α"}, B = {"В"}, C = {"С"},
        D = {"Ḏ"}, E = {"Ε"}, F = {"ℱ"}, G = {"⅁"}, H = {"Η"}, I = {"Ι"}, J = {"Ј"},
        K = {"Κ"}, L = {"Ⅼ"}, M = {"Μ"}, N = {"Ν"}, O = {"Ο"}, P = {"Ρ"}, Q = {"Қ"},
        R = {"Ṙ"}, S = {"Ѕ"}, T = {"Τ"}, U = {"⋃"}, V = {"∨"}, W = {"Ԝ"}, X = {"Χ"},
        Y = {"Υ"}, Z = {"Ζ"}
    }},
    ZALGO = {name = "Zalgo", enabled = false, marks = {"̵", "̶", "̷", "̻", "̹", "̬", "̥", "̩", "̪", "̫", "͇", "͈", "͉", "͐", "͑", "͒"}},
    INVISIBLE = {name = "Invisible", enabled = false, chars = {"​", "‌", "‍", "⁠", ""}},
    SPACING = {name = "Spacing", enabled = false, zw = "​"},
    VERTICAL = {name = "Vertical", enabled = false},
    UPSIDEDOWN = {name = "UpsideDown", enabled = false, map = {
        a = "ɐ", b = "q", c = "ɔ", d = "p", e = "ǝ", f = "ɟ", g = "ƃ", h = "ɥ", i = "ᴉ",
        j = "ɾ", k = "ʞ", m = "ɯ", n = "u", p = "d", q = "b", r = "ɹ", t = "ʇ", u = "n",
        v = "ʌ", w = "ʍ", y = "ʎ", A = "∀", B = "q", C = "Ɔ", D = "p", E = "Ǝ", F = "Ⅎ",
        G = "⅁", J = "ſ", L = "˥", M = "W", P = "Ԁ", T = "⊥", U = "∩", V = "Λ", W = "M",
        Y = "⅄", ["1"] = "Ɩ", ["2"] = "ᄅ", ["3"] = "Ɛ", ["5"] = "ϛ", ["6"] = "9", ["7"] = "ㄥ",
        ["!"] = "¡", ["?"] = "¿", ["."] = "˙", [","] = "‘"
    }},
    FANCY = {name = "Fancy", enabled = false, style = 1, fonts = {
        {a = "ⓐ", b = "ⓑ", c = "ⓒ", d = "ⓓ", e = "ⓔ", f = "ⓕ", g = "ⓖ", h = "ⓗ", i = "ⓘ", j = "ⓙ", k = "ⓚ", l = "ⓛ", m = "ⓜ", n = "ⓝ", o = "ⓞ", p = "ⓟ", q = "ⓠ", r = "ⓡ", s = "ⓢ", t = "ⓣ", u = "ⓤ", v = "ⓥ", w = "ⓦ", x = "ⓧ", y = "ⓨ", z = "ⓩ"},
        {a = "𝐚", b = "𝐛", c = "𝐜", d = "𝐝", e = "𝐞", f = "𝐟", g = "𝐠", h = "𝐡", i = "𝐢", j = "𝐣", k = "𝐤", l = "𝐥", m = "𝐦", n = "𝐧", o = "𝐨", p = "𝐩", q = "𝐪", r = "𝐫", s = "𝐬", t = "𝐭", u = "𝐮", v = "𝐯", w = "𝐰", x = "𝐱", y = "𝐲", z = "𝐳", A = "𝐀", B = "𝐁", C = "𝐂", D = "𝐃", E = "𝐄", F = "𝐅", G = "𝐆", H = "𝐇", I = "𝐈", J = "𝐉", K = "𝐊", L = "𝐋", M = "𝐌", N = "𝐍", O = "𝐎", P = "𝐏", Q = "𝐐", R = "𝐑", S = "𝐒", T = "𝐓", U = "𝐔", V = "𝐕", W = "𝐖", X = "𝐗", Y = "𝐘", Z = "𝐙"}
    }},
    EMOTICON = {name = "Emoticon", enabled = false, emojis = {"☆", "★", "♦", "♠", "♣", "♥", "✧", "✦", "◆", "❀", "✿", "❁", "✾", "❃", "❋", "✱", "✲", "✻", "✼", "❈", "❉", "❊", "✫", "✬", "✭", "✮", "✯", "✰"}},
    LEETSPEAK = {name = "Leet", enabled = false, map = {a = "4", b = "8", e = "3", g = "6", i = "1", o = "0", s = "5", t = "7", l = "1", z = "2"}},
    CASETOGGLE = {name = "CaseRandom", enabled = false},
    SPOILER = {name = "Spoiler", enabled = false, char = "||"}
}

local activeBypasses = {}
local bypassEnabled = false
local currentTab = "main"

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BypassHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Hub Frame (150x150)
local hub = Instance.new("Frame")
hub.Name = "Hub"
hub.Size = UDim2.new(0, 150, 0, 150)
hub.Position = UDim2.new(0.5, -75, 0.5, -75)
hub.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
hub.BorderSizePixel = 0
hub.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 10)
hubCorner.Parent = hub

local hubStroke = Instance.new("UIStroke")
hubStroke.Color = Color3.fromRGB(100, 70, 150)
hubStroke.Thickness = 2
hubStroke.Parent = hub

-- Hub Title
local hubTitle = Instance.new("TextLabel")
hubTitle.Size = UDim2.new(1, 0, 0, 25)
hubTitle.BackgroundTransparency = 1
hubTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
hubTitle.Text = "🔮 BYPASS HUB"
hubTitle.Font = Enum.Font.GothamBold
hubTitle.TextSize = 12
hubTitle.Parent = hub

-- Main Toggle Button
local mainToggle = Instance.new("TextButton")
mainToggle.Size = UDim2.new(1, -20, 0, 28)
mainToggle.Position = UDim2.new(0, 10, 0, 30)
mainToggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
mainToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
mainToggle.Text = "BYPASS: OFF"
mainToggle.Font = Enum.Font.GothamBold
mainToggle.TextSize = 11
mainToggle.Parent = hub

local mainToggleCorner = Instance.new("UICorner")
mainToggleCorner.CornerRadius = UDim.new(0, 6)
mainToggleCorner.Parent = mainToggle

-- Navigation Buttons
local navButtons = {"Methods", "Input", "Output"}
local navBtns = {}

for i, name in ipairs(navButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 22)
    btn.Position = UDim2.new(0, 10, 0, 62 + ((i - 1) * 26))
    btn.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = hub
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    navBtns[name:lower()] = btn
end

-- Close/Minimize Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = hub

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 5)
closeBtnCorner.Parent = closeBtn

-- ========== METHODS PANEL ==========

local methodsPanel = Instance.new("Frame")
methodsPanel.Size = UDim2.new(0, 150, 0, 280)
methodsPanel.Position = UDim2.new(0, 160, 0, 0)
methodsPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
methodsPanel.BorderSizePixel = 0
methodsPanel.Visible = false
methodsPanel.Parent = hub

local methodsPanelCorner = Instance.new("UICorner")
methodsPanelCorner.CornerRadius = UDim.new(0, 10)
methodsPanelCorner.Parent = methodsPanel

local methodsPanelStroke = Instance.new("UIStroke")
methodsPanelStroke.Color = Color3.fromRGB(100, 70, 150)
methodsPanelStroke.Thickness = 2
methodsPanelStroke.Parent = methodsPanel

local methodsTitle = Instance.new("TextLabel")
methodsTitle.Size = UDim2.new(1, 0, 0, 22)
methodsTitle.BackgroundTransparency = 1
methodsTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
methodsTitle.Text = "⚙️ METHODS"
methodsTitle.Font = Enum.Font.GothamBold
methodsTitle.TextSize = 11
methodsTitle.Parent = methodsPanel

local methodsScroll = Instance.new("ScrollingFrame")
methodsScroll.Size = UDim2.new(1, -10, 1, -27)
methodsScroll.Position = UDim2.new(0, 5, 0, 24)
methodsScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
methodsScroll.ScrollBarThickness = 3
methodsScroll.ScrollBarImageColor3 = Color3.fromRGB(150, 100, 200)
methodsScroll.Parent = methodsPanel

local methodsScrollCorner = Instance.new("UICorner")
methodsScrollCorner.CornerRadius = UDim.new(0, 6)
methodsScrollCorner.Parent = methodsScroll

local methodsLayout = Instance.new("UIListLayout")
methodsLayout.Padding = UDim.new(0, 3)
methodsLayout.Parent = methodsScroll

local methodsPadding = Instance.new("UIPadding")
methodsPadding.PaddingTop = UDim.new(0, 4)
methodsPadding.PaddingLeft = UDim.new(0, 3)
methodsPadding.PaddingRight = UDim.new(0, 3)
methodsPadding.Parent = methodsScroll

-- Create method toggles
for methodKey, data in pairs(bypassMethods) do
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -6, 0, 24)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    toggleFrame.Parent = methodsScroll
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -45, 1, 0)
    nameLabel.Position = UDim2.new(0, 5, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    nameLabel.Text = data.name
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 10
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = toggleFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 38, 0, 18)
    toggleBtn.Position = UDim2.new(1, -42, 0.5, -9)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 50)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Text = "OFF"
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 8
    toggleBtn.Parent = toggleFrame
    
    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(0, 4)
    toggleBtnCorner.Parent = toggleBtn
    
    toggleBtn.MouseButton1Click:Connect(function()
        data.enabled = not data.enabled
        if data.enabled then
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 140, 70)
            if not table.find(activeBypasses, methodKey) then
                table.insert(activeBypasses, methodKey)
            end
        else
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 50)
            local idx = table.find(activeBypasses, methodKey)
            if idx then
                table.remove(activeBypasses, idx)
            end
        end
    end)
end

methodsScroll.CanvasSize = UDim2.new(0, 0, 0, methodsLayout.AbsoluteContentSize.Y + 8)

-- ========== INPUT PANEL ==========

local inputPanel = Instance.new("Frame")
inputPanel.Size = UDim2.new(0, 200, 0, 150)
inputPanel.Position = UDim2.new(0, 160, 0, 0)
inputPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
inputPanel.BorderSizePixel = 0
inputPanel.Visible = false
inputPanel.Parent = hub

local inputPanelCorner = Instance.new("UICorner")
inputPanelCorner.CornerRadius = UDim.new(0, 10)
inputPanelCorner.Parent = inputPanel

local inputPanelStroke = Instance.new("UIStroke")
inputPanelStroke.Color = Color3.fromRGB(100, 70, 150)
inputPanelStroke.Thickness = 2
inputPanelStroke.Parent = inputPanel

local inputTitle = Instance.new("TextLabel")
inputTitle.Size = UDim2.new(1, 0, 0, 22)
inputTitle.BackgroundTransparency = 1
inputTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
inputTitle.Text = "📝 INPUT"
inputTitle.Font = Enum.Font.GothamBold
inputTitle.TextSize = 11
inputTitle.Parent = inputPanel

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -15, 0, 85)
inputBox.Position = UDim2.new(0, 8, 0, 26)
inputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.Text = ""
inputBox.PlaceholderText = "Type message..."
inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 12
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.TextYAlignment = Enum.TextYAlignment.Top
inputBox.ClearTextOnFocus = false
inputBox.MultiLine = true
inputBox.TextWrapped = true
inputBox.Parent = inputPanel

local inputBoxCorner = Instance.new("UICorner")
inputBoxCorner.CornerRadius = UDim.new(0, 6)
inputBoxCorner.Parent = inputBox

local bypassBtn = Instance.new("TextButton")
bypassBtn.Size = UDim2.new(0.5, -6, 0, 26)
bypassBtn.Position = UDim2.new(0, 8, 1, -34)
bypassBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 180)
bypassBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bypassBtn.Text = "🔮 BYPASS"
bypassBtn.Font = Enum.Font.GothamBold
bypassBtn.TextSize = 11
bypassBtn.Parent = inputPanel

local bypassBtnCorner = Instance.new("UICorner")
bypassBtnCorner.CornerRadius = UDim.new(0, 6)
bypassBtnCorner.Parent = bypassBtn

local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0.5, -6, 0, 26)
sendBtn.Position = UDim2.new(0.5, 2, 1, -34)
sendBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendBtn.Text = "📤 SEND"
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 11
sendBtn.Parent = inputPanel

local sendBtnCorner = Instance.new("UICorner")
sendBtnCorner.CornerRadius = UDim.new(0, 6)
sendBtnCorner.Parent = sendBtn

-- ========== OUTPUT PANEL ==========

local outputPanel = Instance.new("Frame")
outputPanel.Size = UDim2.new(0, 200, 0, 150)
outputPanel.Position = UDim2.new(0, 160, 0, 0)
outputPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
outputPanel.BorderSizePixel = 0
outputPanel.Visible = false
outputPanel.Parent = hub

local outputPanelCorner = Instance.new("UICorner")
outputPanelCorner.CornerRadius = UDim.new(0, 10)
outputPanelCorner.Parent = outputPanel

local outputPanelStroke = Instance.new("UIStroke")
outputPanelStroke.Color = Color3.fromRGB(100, 70, 150)
outputPanelStroke.Thickness = 2
outputPanelStroke.Parent = outputPanel

local outputTitle = Instance.new("TextLabel")
outputTitle.Size = UDim2.new(1, 0, 0, 22)
outputTitle.BackgroundTransparency = 1
outputTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
outputTitle.Text = "📤 OUTPUT"
outputTitle.Font = Enum.Font.GothamBold
outputTitle.TextSize = 11
outputTitle.Parent = outputPanel

local outputBox = Instance.new("TextBox")
outputBox.Size = UDim2.new(1, -15, 0, 85)
outputBox.Position = UDim2.new(0, 8, 0, 26)
outputBox.BackgroundColor3 = Color3.fromRGB(30, 45, 35)
outputBox.TextColor3 = Color3.fromRGB(150, 255, 150)
outputBox.Text = ""
outputBox.PlaceholderText = "Bypassed text..."
outputBox.PlaceholderColor3 = Color3.fromRGB(80, 120, 80)
outputBox.Font = Enum.Font.Gotham
outputBox.TextSize = 12
outputBox.TextXAlignment = Enum.TextXAlignment.Left
outputBox.TextYAlignment = Enum.TextYAlignment.Top
outputBox.ClearTextOnFocus = false
outputBox.MultiLine = true
outputBox.TextWrapped = true
outputBox.ReadOnly = true
outputBox.Parent = outputPanel

local outputBoxCorner = Instance.new("UICorner")
outputBoxCorner.CornerRadius = UDim.new(0, 6)
outputBoxCorner.Parent = outputBox

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(1, -15, 0, 26)
copyBtn.Position = UDim2.new(0, 8, 1, -34)
copyBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 160)
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Text = "📋 COPY TO CLIPBOARD"
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 11
copyBtn.Parent = outputPanel

local copyBtnCorner = Instance.new("UICorner")
copyBtnCorner.CornerRadius = UDim.new(0, 6)
copyBtnCorner.Parent = copyBtn

-- ========== BYPASS FUNCTIONS ==========

local function applyUnicode(text)
    local result = ""
    for char in text:gmatch(".") do
        local lowerChar = char:lower()
        if bypassMethods.UNICODE.map[lowerChar] then
            local alternatives = bypassMethods.UNICODE.map[lowerChar]
            result = result .. alternatives[math.random(1, #alternatives)]
        else
            result = result .. char
        end
    end
    return result
end

local function applyZalgo(text)
    local result = ""
    local marks = bypassMethods.ZALGO.marks
    for char in text:gmatch(".") do
        result = result .. char
        if char:match("%a") then
            for _ = 1, math.random(1, 2) do
                result = result .. marks[math.random(1, #marks)]
            end
        end
    end
    return result
end

local function applyInvisible(text)
    local result = ""
    local chars = bypassMethods.INVISIBLE.chars
    for char in text:gmatch(".") do
        result = result .. char
        if char ~= " " and math.random() < 0.4 then
            result = result .. chars[math.random(1, #chars)]
        end
    end
    return result
end

local function applySpacing(text)
    local result = ""
    local zw = bypassMethods.SPACING.zw
    for char in text:gmatch(".") do
        result = result .. char .. zw
    end
    return result
end

local function applyVertical(text)
    local result = ""
    for i, char in ipairs(text:gmatch(".")) do
        if i > 1 then result = result .. "\n" end
        result = result .. char
    end
    return result
end

local function applyUpsideDown(text)
    local result = ""
    local map = bypassMethods.UPSIDEDOWN.map
    for i = #text, 1, -1 do
        local char = text:sub(i, i)
        result = result .. (map[char] or char)
    end
    return result
end

local function applyFancy(text)
    local result = ""
    local font = bypassMethods.FANCY.fonts[bypassMethods.FANCY.style]
    for char in text:gmatch(".") do
        result = result .. (font[char] or font[char:lower()] or char)
    end
    return result
end

local function applyEmoticon(text)
    local emojis = bypassMethods.EMOTICON.emojis
    local emote = emojis[math.random(1, #emojis)]
    return emote .. " " .. text .. " " .. emojis[math.random(1, #emojis)]
end

local function applyLeet(text)
    local result = ""
    local map = bypassMethods.LEETSPEAK.map
    for char in text:gmatch(".") do
        local lowerChar = char:lower()
        if map[lowerChar] and math.random() < 0.6 then
            result = result .. map[lowerChar]
        else
            result = result .. char
        end
    end
    return result
end

local function applyCaseToggle(text)
    local result = ""
    for char in text:gmatch(".") do
        if math.random() < 0.5 then
            result = result .. char:upper()
        else
            result = result .. char:lower()
        end
    end
    return result
end

local function applySpoiler(text)
    return bypassMethods.SPOILER.char .. text .. bypassMethods.SPOILER.char
end

local function applyBypass(text)
    if not bypassEnabled or text == "" then return text end
    
    local result = text
    for _, method in ipairs(activeBypasses) do
        if method == "UNICODE" and bypassMethods.UNICODE.enabled then
            result = applyUnicode(result)
        elseif method == "ZALGO" and bypassMethods.ZALGO.enabled then
            result = applyZalgo(result)
        elseif method == "INVISIBLE" and bypassMethods.INVISIBLE.enabled then
            result = applyInvisible(result)
        elseif method == "SPACING" and bypassMethods.SPACING.enabled then
            result = applySpacing(result)
        elseif method == "VERTICAL" and bypassMethods.VERTICAL.enabled then
            result = applyVertical(result)
        elseif method == "UPSIDEDOWN" and bypassMethods.UPSIDEDOWN.enabled then
            result = applyUpsideDown(result)
        elseif method == "FANCY" and bypassMethods.FANCY.enabled then
            result = applyFancy(result)
        elseif method == "EMOTICON" and bypassMethods.EMOTICON.enabled then
            result = applyEmoticon(result)
        elseif method == "LEETSPEAK" and bypassMethods.LEETSPEAK.enabled then
            result = applyLeet(result)
        elseif method == "CASETOGGLE" and bypassMethods.CASETOGGLE.enabled then
            result = applyCaseToggle(result)
        elseif method == "SPOILER" and bypassMethods.SPOILER.enabled then
            result = applySpoiler(result)
        end
    end
    return result
end

-- ========== SEND MESSAGE ==========

local function sendMessage(msg)
    local message = msg or outputBox.Text
    message = message:gsub("^%s+", ""):gsub("%s+$", "")
    if message == "" then return false end
    
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(message, "All")
            return true
        end
    end
    
    if TextChatService then
        local channel = TextChatService:FindFirstChild("TextChannels")
        if channel then
            local rbxGeneral = channel:FindFirstChild("RBXGeneral")
            if rbxGeneral then
                rbxGeneral:SendAsync(message)
                return true
            end
        end
    end
    return false
end

-- ========== EVENT HANDLERS ==========

mainToggle.MouseButton1Click:Connect(function()
    bypassEnabled = not bypassEnabled
    if bypassEnabled then
        mainToggle.Text = "BYPASS: ON"
        mainToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 70)
    else
        mainToggle.Text = "BYPASS: OFF"
        mainToggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

local function showPanel(panel)
    methodsPanel.Visible = false
    inputPanel.Visible = false
    outputPanel.Visible = false
    
    if panel then
        panel.Visible = true
    end
end

navBtns.methods.MouseButton1Click:Connect(function()
    showPanel(methodsPanel)
end)

navBtns.input.MouseButton1Click:Connect(function()
    showPanel(inputPanel)
end)

navBtns.output.MouseButton1Click:Connect(function()
    showPanel(outputPanel)
end)

closeBtn.MouseButton1Click:Connect(function()
    showPanel(nil)
end)

bypassBtn.MouseButton1Click:Connect(function()
    if inputBox.Text ~= "" then
        local bypassed = applyBypass(inputBox.Text)
        outputBox.Text = bypassed
        showPanel(outputPanel)
    end
end)

sendBtn.MouseButton1Click:Connect(function()
    if inputBox.Text ~= "" then
        local bypassed = applyBypass(inputBox.Text)
        outputBox.Text = bypassed
        sendMessage(bypassed)
    end
end)

copyBtn.MouseButton1Click:Connect(function()
    if outputBox.Text ~= "" then
        if setclipboard then
            setclipboard(outputBox.Text)
        end
        copyBtn.Text = "✓ COPIED!"
        copyBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        wait(0.5)
        copyBtn.Text = "📋 COPY TO CLIPBOARD"
        copyBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 160)
    end
end)

-- Auto-update output
inputBox:GetPropertyChangedSignal("Text"):Connect(function()
    if bypassEnabled then
        outputBox.Text = applyBypass(inputBox.Text)
    end
end)

-- ========== DRAGGING ==========

local dragging = false
local dragInput, dragStart, startPos

hub.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = hub.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

hub.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        hub.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle with RightControl
local guiVisible = true
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        hub.Visible = guiVisible
    end
end)

print("🔮 Bypass Hub Loaded - Press RightControl to toggle")
print("Size: 150x150 | Click Methods/Input/Output to expand panels")
