-- Chat Bypass Hub (Mobile Friendly 150x150)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Bypass methods
local bypassMethods = {
    UNICODE = {name = "Unicode", enabled = false, map = {
        a = {"а", "ɑ"}, b = {"Ь"}, c = {"с"}, d = {"ԁ"}, e = {"е"}, f = {"ſ"}, g = {"ɡ"},
        h = {"һ"}, i = {"і"}, j = {"ϳ"}, k = {"κ"}, l = {"ⅼ"}, m = {"м"}, n = {"ո"},
        o = {"о"}, p = {"ρ"}, q = {"ԛ"}, r = {"г"}, s = {"ѕ"}, t = {"τ"}, u = {"υ"},
        v = {"ν"}, w = {"ԝ"}, x = {"χ"}, y = {"у"}, z = {"ζ"}, A = {"А"}, B = {"В"},
        C = {"С"}, D = {"Ḏ"}, E = {"Ε"}, F = {"ℱ"}, G = {"⅁"}, H = {"Η"}, I = {"Ι"},
        J = {"Ј"}, K = {"Κ"}, L = {"Ⅼ"}, M = {"Μ"}, N = {"Ν"}, O = {"Ο"}, P = {"Ρ"},
        Q = {"Қ"}, R = {"Ṙ"}, S = {"Ѕ"}, T = {"Τ"}, U = {"⋃"}, V = {"∨"}, W = {"Ԝ"},
        X = {"Χ"}, Y = {"Υ"}, Z = {"Ζ"}
    }},
    ZALGO = {name = "Zalgo", enabled = false, marks = {"̵", "̶", "̷", "̻", "̹", "̬", "̥", "̩", "̪", "̫", "͇", "͈", "͐", "͑"}},
    INVISIBLE = {name = "Invis", enabled = false, chars = {"​", "‌", "‍", "⁠", ""}},
    SPACING = {name = "Spacing", enabled = false, zw = "​"},
    UPSIDEDOWN = {name = "Flip", enabled = false, map = {
        a = "ɐ", b = "q", c = "ɔ", d = "p", e = "ǝ", f = "ɟ", g = "ƃ", h = "ɥ", i = "ᴉ",
        j = "ɾ", k = "ʞ", m = "ɯ", n = "u", p = "d", q = "b", r = "ɹ", t = "ʇ", u = "n",
        v = "ʌ", w = "ʍ", y = "ʎ", A = "∀", C = "Ɔ", D = "p", E = "Ǝ", F = "Ⅎ", G = "⅁",
        J = "ſ", L = "˥", M = "W", P = "Ԁ", T = "⊥", U = "∩", V = "Λ", W = "M", Y = "⅄"
    }},
    FANCY = {name = "Fancy", enabled = false, font = {a = "ⓐ", b = "ⓑ", c = "ⓒ", d = "ⓓ", e = "ⓔ", f = "ⓕ", g = "ⓖ", h = "ⓗ", i = "ⓘ", j = "ⓙ", k = "ⓚ", l = "ⓛ", m = "ⓜ", n = "ⓝ", o = "ⓞ", p = "ⓟ", q = "ⓠ", r = "ⓡ", s = "ⓢ", t = "ⓣ", u = "ⓤ", v = "ⓥ", w = "ⓦ", x = "ⓧ", y = "ⓨ", z = "ⓩ"}},
    EMOTICON = {name = "Emoji", enabled = false, emojis = {"☆", "★", "♦", "♠", "♣", "♥", "✧", "✦", "◆", "❀", "✿", "❁"}},
    LEETSPEAK = {name = "Leet", enabled = false, map = {a = "4", b = "8", e = "3", g = "6", i = "1", o = "0", s = "5", t = "7", l = "1"}},
    CASETOGGLE = {name = "Mixed", enabled = false}
}

local activeBypasses = {}
local bypassEnabled = false
local expandedPanel = nil

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

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -25, 0, 20)
title.Position = UDim2.new(0, 5, 0, 3)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(200, 150, 255)
title.Text = "🔮 BYPASS HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.Parent = hub

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 18, 0, 18)
closeBtn.Position = UDim2.new(1, -22, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Parent = hub

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 4)
closeBtnCorner.Parent = closeBtn

-- Main Toggle
local mainToggle = Instance.new("TextButton")
mainToggle.Size = UDim2.new(1, -10, 0, 24)
mainToggle.Position = UDim2.new(0, 5, 0, 25)
mainToggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
mainToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
mainToggle.Text = "BYPASS: OFF"
mainToggle.Font = Enum.Font.GothamBold
mainToggle.TextSize = 10
mainToggle.Parent = hub

local mainToggleCorner = Instance.new("UICorner")
mainToggleCorner.CornerRadius = UDim.new(0, 6)
mainToggleCorner.Parent = mainToggle

-- Input Box
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -10, 0, 35)
inputBox.Position = UDim2.new(0, 5, 0, 52)
inputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.Text = ""
inputBox.PlaceholderText = "Message..."
inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 11
inputBox.ClearTextOnFocus = false
inputBox.Parent = hub

local inputBoxCorner = Instance.new("UICorner")
inputBoxCorner.CornerRadius = UDim.new(0, 6)
inputBoxCorner.Parent = inputBox

-- Button Row
local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, -10, 0, 22)
btnRow.Position = UDim2.new(0, 5, 0, 90)
btnRow.BackgroundTransparency = 1
btnRow.Parent = hub

local bypassBtn = Instance.new("TextButton")
bypassBtn.Size = UDim2.new(0.33, -2, 1, 0)
bypassBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 180)
bypassBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bypassBtn.Text = "🔮"
bypassBtn.Font = Enum.Font.GothamBold
bypassBtn.TextSize = 12
bypassBtn.Parent = btnRow

local bypassBtnCorner = Instance.new("UICorner")
bypassBtnCorner.CornerRadius = UDim.new(0, 5)
bypassBtnCorner.Parent = bypassBtn

local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0.33, -2, 1, 0)
sendBtn.Position = UDim2.new(0.33, 1, 0, 0)
sendBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendBtn.Text = "📤"
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 12
sendBtn.Parent = btnRow

local sendBtnCorner = Instance.new("UICorner")
sendBtnCorner.CornerRadius = UDim.new(0, 5)
sendBtnCorner.Parent = sendBtn

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.34, -2, 1, 0)
copyBtn.Position = UDim2.new(0.66, 2, 0, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 160)
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Text = "📋"
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 12
copyBtn.Parent = btnRow

local copyBtnCorner = Instance.new("UICorner")
copyBtnCorner.CornerRadius = UDim.new(0, 5)
copyBtnCorner.Parent = copyBtn

-- Methods Button
local methodsBtn = Instance.new("TextButton")
methodsBtn.Size = UDim2.new(1, -10, 0, 22)
methodsBtn.Position = UDim2.new(0, 5, 0, 115)
methodsBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
methodsBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
methodsBtn.Text = "⚙️ Methods ▼"
methodsBtn.Font = Enum.Font.GothamBold
methodsBtn.TextSize = 10
methodsBtn.Parent = hub

local methodsBtnCorner = Instance.new("UICorner")
methodsBtnCorner.CornerRadius = UDim.new(0, 5)
methodsBtnCorner.Parent = methodsBtn

-- Output Display (small)
local outputBox = Instance.new("TextLabel")
outputBox.Size = UDim2.new(1, -10, 0, 0)
outputBox.Position = UDim2.new(0, 5, 1, -2)
outputBox.BackgroundColor3 = Color3.fromRGB(30, 45, 35)
outputBox.TextColor3 = Color3.fromRGB(150, 255, 150)
outputBox.Text = ""
outputBox.Font = Enum.Font.Gotham
outputBox.TextSize = 9
outputBox.TextWrapped = true
outputBox.TextTruncate = Enum.TextTruncate.AtEnd
outputBox.Visible = false
outputBox.Parent = hub

local outputBoxCorner = Instance.new("UICorner")
outputBoxCorner.CornerRadius = UDim.new(0, 5)
outputBoxCorner.Parent = outputBox

-- Methods Dropdown (expands DOWN from hub)
local methodsPanel = Instance.new("Frame")
methodsPanel.Size = UDim2.new(0, 150, 0, 0)
methodsPanel.Position = UDim2.new(0, 0, 1, 5)
methodsPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
methodsPanel.BorderSizePixel = 0
methodsPanel.ClipsDescendants = true
methodsPanel.Parent = hub

local methodsPanelCorner = Instance.new("UICorner")
methodsPanelCorner.CornerRadius = UDim.new(0, 8)
methodsPanelCorner.Parent = methodsPanel

local methodsPanelStroke = Instance.new("UIStroke")
methodsPanelStroke.Color = Color3.fromRGB(100, 70, 150)
methodsPanelStroke.Thickness = 1
methodsPanelStroke.Parent = methodsPanel

local methodsScroll = Instance.new("ScrollingFrame")
methodsScroll.Size = UDim2.new(1, -6, 1, -6)
methodsScroll.Position = UDim2.new(0, 3, 0, 3)
methodsScroll.BackgroundTransparency = 1
methodsScroll.ScrollBarThickness = 2
methodsScroll.ScrollBarImageColor3 = Color3.fromRGB(150, 100, 200)
methodsScroll.Parent = methodsPanel

local methodsLayout = Instance.new("UIListLayout")
methodsLayout.Padding = UDim.new(0, 2)
methodsLayout.Parent = methodsScroll

-- Store last output for copying
local lastOutput = ""

-- Create method toggles
for methodKey, data in pairs(bypassMethods) do
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -2, 0, 22)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    toggleFrame.Parent = methodsScroll
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggleFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -42, 1, 0)
    nameLabel.Position = UDim2.new(0, 5, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    nameLabel.Text = data.name
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 9
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = toggleFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 36, 0, 16)
    toggleBtn.Position = UDim2.new(1, -39, 0.5, -8)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Text = "OFF"
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 7
    toggleBtn.Parent = toggleFrame
    
    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(0, 3)
    toggleBtnCorner.Parent = toggleBtn
    
    toggleBtn.MouseButton1Click:Connect(function()
        data.enabled = not data.enabled
        if data.enabled then
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 130, 70)
            if not table.find(activeBypasses, methodKey) then
                table.insert(activeBypasses, methodKey)
            end
        else
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
            local idx = table.find(activeBypasses, methodKey)
            if idx then
                table.remove(activeBypasses, idx)
            end
        end
        -- Auto-bypass if enabled
        if bypassEnabled and inputBox.Text ~= "" then
            lastOutput = applyBypass(inputBox.Text)
            outputBox.Text = lastOutput
        end
    end)
end

methodsScroll.CanvasSize = UDim2.new(0, 0, 0, methodsLayout.AbsoluteContentSize.Y + 4)

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
            result = result .. marks[math.random(1, #marks)]
        end
    end
    return result
end

local function applyInvisible(text)
    local result = ""
    local chars = bypassMethods.INVISIBLE.chars
    for char in text:gmatch(".") do
        result = result .. char
        if char ~= " " and math.random() < 0.3 then
            result = result .. chars[math.random(1, #chars)]
        end
    end
    return result
end

local function applySpacing(text)
    local result = ""
    for char in text:gmatch(".") do
        result = result .. char .. bypassMethods.SPACING.zw
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
    local font = bypassMethods.FANCY.font
    for char in text:gmatch(".") do
        result = result .. (font[char] or font[char:lower()] or char)
    end
    return result
end

local function applyEmoticon(text)
    local emojis = bypassMethods.EMOTICON.emojis
    return emojis[math.random(1, #emojis)] .. " " .. text .. " " .. emojis[math.random(1, #emojis)]
end

local function applyLeet(text)
    local result = ""
    local map = bypassMethods.LEETSPEAK.map
    for char in text:gmatch(".") do
        local lowerChar = char:lower()
        if map[lowerChar] and math.random() < 0.5 then
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
        end
    end
    return result
end

-- ========== SEND MESSAGE ==========

local function sendMessage(msg)
    local message = msg or lastOutput
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

-- ========== TOGGLE ANIMATION ==========

local function toggleMethods()
    if expandedPanel == "methods" then
        -- Collapse
        methodsPanel:TweenSize(UDim2.new(0, 150, 0, 0), "Out", "Quad", 0.2, true)
        methodsBtn.Text = "⚙️ Methods ▼"
        expandedPanel = nil
    else
        -- Expand
        local targetHeight = math.min(methodsLayout.AbsoluteContentSize.Y + 12, 200)
        methodsPanel:TweenSize(UDim2.new(0, 150, 0, targetHeight), "Out", "Quad", 0.2, true)
        methodsBtn.Text = "⚙️ Methods ▲"
        expandedPanel = "methods"
    end
end

-- ========== EVENTS ==========

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

closeBtn.MouseButton1Click:Connect(function()
    if expandedPanel then
        methodsPanel:TweenSize(UDim2.new(0, 150, 0, 0), "Out", "Quad", 0.2, true)
        methodsBtn.Text = "⚙️ Methods ▼"
        expandedPanel = nil
    end
end)

methodsBtn.MouseButton1Click:Connect(toggleMethods)

bypassBtn.MouseButton1Click:Connect(function()
    if inputBox.Text ~= "" then
        lastOutput = applyBypass(inputBox.Text)
        outputBox.Text = lastOutput
        -- Show output briefly
        outputBox.Size = UDim2.new(1, -10, 0, 30)
        outputBox.Visible = true
        hub.Size = UDim2.new(0, 150, 0, 185)
        wait(2)
        outputBox.Visible = false
        outputBox.Size = UDim2.new(1, -10, 0, 0)
        hub.Size = UDim2.new(0, 150, 0, 150)
    end
end)

sendBtn.MouseButton1Click:Connect(function()
    if inputBox.Text ~= "" then
        lastOutput = applyBypass(inputBox.Text)
        sendMessage(lastOutput)
    end
end)

copyBtn.MouseButton1Click:Connect(function()
    if lastOutput ~= "" then
        if setclipboard then
            setclipboard(lastOutput)
        end
        copyBtn.Text = "✓"
        wait(0.5)
        copyBtn.Text = "📋"
    end
end)

-- Auto-bypass on input
inputBox:GetPropertyChangedSignal("Text"):Connect(function()
    if bypassEnabled and inputBox.Text ~= "" then
        lastOutput = applyBypass(inputBox.Text)
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

print("🔮 Bypass Hub Loaded - 150x150 Mobile Friendly")
