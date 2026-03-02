-- GLM Hub - Multi-Feature GUI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GLMHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Colors
local COLORS = {
    bg = Color3.fromRGB(20, 20, 25),
    header = Color3.fromRGB(30, 30, 40),
    card = Color3.fromRGB(35, 35, 45),
    accent = Color3.fromRGB(100, 80, 200),
    accent2 = Color3.fromRGB(200, 80, 150),
    text = Color3.fromRGB(255, 255, 255),
    textMuted = Color3.fromRGB(150, 150, 160),
    success = Color3.fromRGB(80, 200, 120),
    danger = Color3.fromRGB(200, 80, 80)
}

-- ========== HUB BUTTON ==========
local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 50, 0, 50)
hubButton.Position = UDim2.new(0, 15, 0.5, -25)
hubButton.BackgroundColor3 = COLORS.accent
hubButton.Visible = true
hubButton.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 12)
hubCorner.Parent = hubButton

local hubGradient = Instance.new("UIGradient")
hubGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, COLORS.accent), ColorSequenceKeypoint.new(1, COLORS.accent2)})
hubGradient.Rotation = 45
hubGradient.Parent = hubButton

local hubIcon = Instance.new("TextLabel")
hubIcon.Size = UDim2.new(1, 0, 1, 0)
hubIcon.BackgroundTransparency = 1
hubIcon.TextColor3 = COLORS.text
hubIcon.Text = "G"
hubIcon.Font = Enum.Font.GothamBold
hubIcon.TextSize = 22
hubIcon.Parent = hubButton

-- ========== MAIN FRAME (WIDE) ==========
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 480, 0, 280)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -140)
mainFrame.BackgroundColor3 = COLORS.bg
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(50, 50, 60)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = COLORS.header
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 12)
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = COLORS.header
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleGradient = Instance.new("Frame")
titleGradient.Size = UDim2.new(1, 0, 0, 3)
titleGradient.Position = UDim2.new(0, 0, 1, -3)
titleGradient.BackgroundColor3 = COLORS.accent
titleGradient.BorderSizePixel = 0
titleGradient.Parent = titleBar

local titleGradientCorner = Instance.new("UICorner")
titleGradientCorner.Parent = titleGradient

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = COLORS.text
titleLabel.Text = "GLM Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- FPS Counter in title
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 50, 1, 0)
fpsLabel.Position = UDim2.new(1, -115, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = COLORS.accent
fpsLabel.Text = "60 FPS"
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 10
fpsLabel.Parent = titleBar

local collapseBtn = Instance.new("TextButton")
collapseBtn.Size = UDim2.new(0, 28, 0, 22)
collapseBtn.Position = UDim2.new(1, -35, 0.5, -11)
collapseBtn.BackgroundColor3 = COLORS.danger
collapseBtn.TextColor3 = COLORS.text
collapseBtn.Text = "×"
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.TextSize = 12
collapseBtn.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseBtn

-- ========== TAB BUTTONS ==========
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 30)
tabFrame.Position = UDim2.new(0, 10, 0, 42)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabs = {"Fun", "Visual", "Stats", "Tools", "Chat"}
local tabButtons = {}
local currentTab = "Fun"

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1/#tabs, -4, 1, 0)
    tabBtn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    tabBtn.BackgroundColor3 = i == 1 and COLORS.accent or COLORS.card
    tabBtn.TextColor3 = COLORS.text
    tabBtn.Text = tabName
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 10
    tabBtn.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn
    
    tabButtons[tabName] = tabBtn
end

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -82)
contentFrame.Position = UDim2.new(0, 10, 0, 78)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ========== FUN TAB ==========
local funSection = Instance.new("Frame")
funSection.Size = UDim2.new(1, 0, 1, 0)
funSection.BackgroundTransparency = 1
funSection.Visible = true
funSection.Parent = contentFrame

-- Left Column
local funLeft = Instance.new("Frame")
funLeft.Size = UDim2.new(0.5, -5, 1, 0)
funLeft.BackgroundTransparency = 1
funLeft.Parent = funSection

-- Rainbow Button
local rainbowBtn = Instance.new("TextButton")
rainbowBtn.Size = UDim2.new(1, 0, 0, 35)
rainbowBtn.BackgroundColor3 = COLORS.card
rainbowBtn.TextColor3 = COLORS.text
rainbowBtn.Text = "🌈 Rainbow Character"
rainbowBtn.Font = Enum.Font.GothamBold
rainbowBtn.TextSize = 11
rainbowBtn.Parent = funLeft

local rainbowCorner = Instance.new("UICorner")
rainbowCorner.CornerRadius = UDim.new(0, 8)
rainbowCorner.Parent = rainbowBtn

-- Disco Button
local discoBtn = Instance.new("TextButton")
discoBtn.Size = UDim2.new(1, 0, 0, 35)
discoBtn.Position = UDim2.new(0, 0, 0, 40)
discoBtn.BackgroundColor3 = COLORS.card
discoBtn.TextColor3 = COLORS.text
discoBtn.Text = "🪩 Disco Mode"
discoBtn.Font = Enum.Font.GothamBold
discoBtn.TextSize = 11
discoBtn.Parent = funLeft

local discoCorner = Instance.new("UICorner")
discoCorner.CornerRadius = UDim.new(0, 8)
discoCorner.Parent = discoBtn

-- Spin Button
local spinBtn = Instance.new("TextButton")
spinBtn.Size = UDim2.new(1, 0, 0, 35)
spinBtn.Position = UDim2.new(0, 0, 0, 80)
spinBtn.BackgroundColor3 = COLORS.card
spinBtn.TextColor3 = COLORS.text
spinBtn.Text = "🔄 Spin Character"
spinBtn.Font = Enum.Font.GothamBold
spinBtn.TextSize = 11
spinBtn.Parent = funLeft

local spinCorner = Instance.new("UICorner")
spinCorner.CornerRadius = UDim.new(0, 8)
spinCorner.Parent = spinBtn

-- Fake Lag Button
local fakeLagBtn = Instance.new("TextButton")
fakeLagBtn.Size = UDim2.new(1, 0, 0, 35)
fakeLagBtn.Position = UDim2.new(0, 0, 0, 120)
fakeLagBtn.BackgroundColor3 = COLORS.card
fakeLagBtn.TextColor3 = COLORS.text
fakeLagBtn.Text = "📶 Fake Lag: OFF"
fakeLagBtn.Font = Enum.Font.GothamBold
fakeLagBtn.TextSize = 11
fakeLagBtn.Parent = funLeft

local fakeLagCorner = Instance.new("UICorner")
fakeLagCorner.CornerRadius = UDim.new(0, 8)
fakeLagCorner.Parent = fakeLagBtn

-- Right Column
local funRight = Instance.new("Frame")
funRight.Size = UDim2.new(0.5, -5, 1, 0)
funRight.Position = UDim2.new(0.5, 5, 0, 0)
funRight.BackgroundTransparency = 1
funRight.Parent = funSection

-- Big Head
local bigHeadBtn = Instance.new("TextButton")
bigHeadBtn.Size = UDim2.new(1, 0, 0, 35)
bigHeadBtn.BackgroundColor3 = COLORS.card
bigHeadBtn.TextColor3 = COLORS.text
bigHeadBtn.Text = "🗣️ Big Head"
bigHeadBtn.Font = Enum.Font.GothamBold
bigHeadBtn.TextSize = 11
bigHeadBtn.Parent = funRight

local bigHeadCorner = Instance.new("UICorner")
bigHeadCorner.CornerRadius = UDim.new(0, 8)
bigHeadCorner.Parent = bigHeadBtn

-- Tiny Body
local tinyBodyBtn = Instance.new("TextButton")
tinyBodyBtn.Size = UDim2.new(1, 0, 0, 35)
tinyBodyBtn.Position = UDim2.new(0, 0, 0, 40)
tinyBodyBtn.BackgroundColor3 = COLORS.card
tinyBodyBtn.TextColor3 = COLORS.text
tinyBodyBtn.Text = "🧸 Tiny Body"
tinyBodyBtn.Font = Enum.Font.GothamBold
tinyBodyBtn.TextSize = 11
tinyBodyBtn.Parent = funRight

local tinyBodyCorner = Instance.new("UICorner")
tinyBodyCorner.CornerRadius = UDim.new(0, 8)
tinyBodyCorner.Parent = tinyBodyBtn

-- Float
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(1, 0, 0, 35)
floatBtn.Position = UDim2.new(0, 0, 0, 80)
floatBtn.BackgroundColor3 = COLORS.card
floatBtn.TextColor3 = COLORS.text
floatBtn.Text = "☁️ Float: OFF"
floatBtn.Font = Enum.Font.GothamBold
floatBtn.TextSize = 11
floatBtn.Parent = funRight

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(0, 8)
floatCorner.Parent = floatBtn

-- Reset Character
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(1, 0, 0, 35)
resetBtn.Position = UDim2.new(0, 0, 0, 120)
resetBtn.BackgroundColor3 = COLORS.danger
resetBtn.TextColor3 = COLORS.text
resetBtn.Text = "🔄 Reset Character"
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 11
resetBtn.Parent = funRight

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 8)
resetCorner.Parent = resetBtn

-- ========== VISUAL TAB ==========
local visualSection = Instance.new("Frame")
visualSection.Size = UDim2.new(1, 0, 1, 0)
visualSection.BackgroundTransparency = 1
visualSection.Visible = false
visualSection.Parent = contentFrame

-- Left Column
local visualLeft = Instance.new("Frame")
visualLeft.Size = UDim2.new(0.5, -5, 1, 0)
visualLeft.BackgroundTransparency = 1
visualLeft.Parent = visualSection

-- Fullbright
local fullbrightBtn = Instance.new("TextButton")
fullbrightBtn.Size = UDim2.new(1, 0, 0, 35)
fullbrightBtn.BackgroundColor3 = COLORS.card
fullbrightBtn.TextColor3 = COLORS.text
fullbrightBtn.Text = "💡 Fullbright: OFF"
fullbrightBtn.Font = Enum.Font.GothamBold
fullbrightBtn.TextSize = 11
fullbrightBtn.Parent = visualLeft

local fullbrightCorner = Instance.new("UICorner")
fullbrightCorner.CornerRadius = UDim.new(0, 8)
fullbrightCorner.Parent = fullbrightBtn

-- No Fog
local noFogBtn = Instance.new("TextButton")
noFogBtn.Size = UDim2.new(1, 0, 0, 35)
noFogBtn.Position = UDim2.new(0, 0, 0, 40)
noFogBtn.BackgroundColor3 = COLORS.card
noFogBtn.TextColor3 = COLORS.text
noFogBtn.Text = "🌫️ No Fog: OFF"
noFogBtn.Font = Enum.Font.GothamBold
noFogBtn.TextSize = 11
noFogBtn.Parent = visualLeft

local noFogCorner = Instance.new("UICorner")
noFogCorner.CornerRadius = UDim.new(0, 8)
noFogCorner.Parent = noFogBtn

-- Skybox
local skyboxBtn = Instance.new("TextButton")
skyboxBtn.Size = UDim2.new(1, 0, 0, 35)
skyboxBtn.Position = UDim2.new(0, 0, 0, 80)
skyboxBtn.BackgroundColor3 = COLORS.card
skyboxBtn.TextColor3 = COLORS.text
skyboxBtn.Text = "🌌 Night Sky: OFF"
skyboxBtn.Font = Enum.Font.GothamBold
skyboxBtn.TextSize = 11
skyboxBtn.Parent = visualLeft

local skyboxCorner = Instance.new("UICorner")
skyboxCorner.CornerRadius = UDim.new(0, 8)
skyboxCorner.Parent = skyboxBtn

-- Right Column
local visualRight = Instance.new("Frame")
visualRight.Size = UDim2.new(0.5, -5, 1, 0)
visualRight.Position = UDim2.new(0.5, 5, 0, 0)
visualRight.BackgroundTransparency = 1
visualRight.Parent = visualSection

-- ESP
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(1, 0, 0, 35)
espBtn.BackgroundColor3 = COLORS.card
espBtn.TextColor3 = COLORS.text
espBtn.Text = "👁️ Player ESP: OFF"
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 11
espBtn.Parent = visualRight

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 8)
espCorner.Parent = espBtn

-- Tracers
local tracerBtn = Instance.new("TextButton")
tracerBtn.Size = UDim2.new(1, 0, 0, 35)
tracerBtn.Position = UDim2.new(0, 0, 0, 40)
tracerBtn.BackgroundColor3 = COLORS.card
tracerBtn.TextColor3 = COLORS.text
tracerBtn.Text = "📍 Tracers: OFF"
tracerBtn.Font = Enum.Font.GothamBold
tracerBtn.TextSize = 11
tracerBtn.Parent = visualRight

local tracerCorner = Instance.new("UICorner")
tracerCorner.CornerRadius = UDim.new(0, 8)
tracerCorner.Parent = tracerBtn

-- Reset Visuals
local resetVisualBtn = Instance.new("TextButton")
resetVisualBtn.Size = UDim2.new(1, 0, 0, 35)
resetVisualBtn.Position = UDim2.new(0, 0, 0, 80)
resetVisualBtn.BackgroundColor3 = COLORS.danger
resetVisualBtn.TextColor3 = COLORS.text
resetVisualBtn.Text = "🔄 Reset Visuals"
resetVisualBtn.Font = Enum.Font.GothamBold
resetVisualBtn.TextSize = 11
resetVisualBtn.Parent = visualRight

local resetVisualCorner = Instance.new("UICorner")
resetVisualCorner.CornerRadius = UDim.new(0, 8)
resetVisualCorner.Parent = resetVisualBtn

-- ========== STATS TAB ==========
local statsSection = Instance.new("Frame")
statsSection.Size = UDim2.new(1, 0, 1, 0)
statsSection.BackgroundTransparency = 1
statsSection.Visible = false
statsSection.Parent = contentFrame

-- Stats Display
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, 0, 1, 0)
statsFrame.BackgroundColor3 = COLORS.card
statsFrame.Parent = statsSection

local statsFrameCorner = Instance.new("UICorner")
statsFrameCorner.CornerRadius = UDim.new(0, 8)
statsFrameCorner.Parent = statsFrame

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(1, -20, 1, -20)
statsLabel.Position = UDim2.new(0, 10, 0, 10)
statsLabel.BackgroundTransparency = 1
statsLabel.TextColor3 = COLORS.text
statsLabel.Text = "Loading stats..."
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextSize = 11
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.TextYAlignment = Enum.TextYAlignment.Top
statsLabel.Parent = statsFrame

-- ========== TOOLS TAB ==========
local toolsSection = Instance.new("Frame")
toolsSection.Size = UDim2.new(1, 0, 1, 0)
toolsSection.BackgroundTransparency = 1
toolsSection.Visible = false
toolsSection.Parent = contentFrame

-- Left Column
local toolsLeft = Instance.new("Frame")
toolsLeft.Size = UDim2.new(0.5, -5, 1, 0)
toolsLeft.BackgroundTransparency = 1
toolsLeft.Parent = toolsSection

-- TP to Mouse
local tpMouseBtn = Instance.new("TextButton")
tpMouseBtn.Size = UDim2.new(1, 0, 0, 35)
tpMouseBtn.BackgroundColor3 = COLORS.card
tpMouseBtn.TextColor3 = COLORS.text
tpMouseBtn.Text = "🎯 TP to Mouse"
tpMouseBtn.Font = Enum.Font.GothamBold
tpMouseBtn.TextSize = 11
tpMouseBtn.Parent = toolsLeft

local tpMouseCorner = Instance.new("UICorner")
tpMouseCorner.CornerRadius = UDim.new(0, 8)
tpMouseCorner.Parent = tpMouseBtn

-- Speed
local speedRow = Instance.new("Frame")
speedRow.Size = UDim2.new(1, 0, 0, 35)
speedRow.Position = UDim2.new(0, 0, 0, 40)
speedRow.BackgroundTransparency = 1
speedRow.Parent = toolsLeft

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 60, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = COLORS.text
speedLabel.Text = "Speed:"
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 11
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedRow

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 50, 1, 0)
speedInput.Position = UDim2.new(0, 60, 0, 0)
speedInput.BackgroundColor3 = COLORS.card
speedInput.TextColor3 = COLORS.text
speedInput.Text = "16"
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 11
speedInput.Parent = speedRow

local speedInputCorner = Instance.new("UICorner")
speedInputCorner.CornerRadius = UDim.new(0, 6)
speedInputCorner.Parent = speedInput

local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0, 70, 1, 0)
speedBtn.Position = UDim2.new(1, -70, 0, 0)
speedBtn.BackgroundColor3 = COLORS.accent
speedBtn.TextColor3 = COLORS.text
speedBtn.Text = "Set"
speedBtn.Font = Enum.Font.GothamBold
speedBtn.TextSize = 11
speedBtn.Parent = speedRow

local speedBtnCorner = Instance.new("UICorner")
speedBtnCorner.CornerRadius = UDim.new(0, 6)
speedBtnCorner.Parent = speedBtn

-- Jump Power
local jumpRow = Instance.new("Frame")
jumpRow.Size = UDim2.new(1, 0, 0, 35)
jumpRow.Position = UDim2.new(0, 0, 0, 80)
jumpRow.BackgroundTransparency = 1
jumpRow.Parent = toolsLeft

local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0, 60, 1, 0)
jumpLabel.BackgroundTransparency = 1
jumpLabel.TextColor3 = COLORS.text
jumpLabel.Text = "Jump:"
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.TextSize = 11
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpLabel.Parent = jumpRow

local jumpInput = Instance.new("TextBox")
jumpInput.Size = UDim2.new(0, 50, 1, 0)
jumpInput.Position = UDim2.new(0, 60, 0, 0)
jumpInput.BackgroundColor3 = COLORS.card
jumpInput.TextColor3 = COLORS.text
jumpInput.Text = "50"
jumpInput.Font = Enum.Font.Gotham
jumpInput.TextSize = 11
jumpInput.Parent = jumpRow

local jumpInputCorner = Instance.new("UICorner")
jumpInputCorner.CornerRadius = UDim.new(0, 6)
jumpInputCorner.Parent = jumpInput

local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0, 70, 1, 0)
jumpBtn.Position = UDim2.new(1, -70, 0, 0)
jumpBtn.BackgroundColor3 = COLORS.accent
jumpBtn.TextColor3 = COLORS.text
jumpBtn.Text = "Set"
jumpBtn.Font = Enum.Font.GothamBold
jumpBtn.TextSize = 11
jumpBtn.Parent = jumpRow

local jumpBtnCorner = Instance.new("UICorner")
jumpBtnCorner.CornerRadius = UDim.new(0, 6)
jumpBtnCorner.Parent = jumpBtn

-- Right Column
local toolsRight = Instance.new("Frame")
toolsRight.Size = UDim2.new(0.5, -5, 1, 0)
toolsRight.Position = UDim2.new(0.5, 5, 0, 0)
toolsRight.BackgroundTransparency = 1
toolsRight.Parent = toolsSection

-- Noclip
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(1, 0, 0, 35)
noclipBtn.BackgroundColor3 = COLORS.card
noclipBtn.TextColor3 = COLORS.text
noclipBtn.Text = "👻 Noclip: OFF"
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 11
noclipBtn.Parent = toolsRight

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 8)
noclipCorner.Parent = noclipBtn

-- Fly
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(1, 0, 0, 35)
flyBtn.Position = UDim2.new(0, 0, 0, 40)
flyBtn.BackgroundColor3 = COLORS.card
flyBtn.TextColor3 = COLORS.text
flyBtn.Text = "🦅 Fly: OFF (V)"
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 11
flyBtn.Parent = toolsRight

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyBtn

-- Reset Tools
local resetToolsBtn = Instance.new("TextButton")
resetToolsBtn.Size = UDim2.new(1, 0, 0, 35)
resetToolsBtn.Position = UDim2.new(0, 0, 0, 80)
resetToolsBtn.BackgroundColor3 = COLORS.danger
resetToolsBtn.TextColor3 = COLORS.text
resetToolsBtn.Text = "🔄 Reset Tools"
resetToolsBtn.Font = Enum.Font.GothamBold
resetToolsBtn.TextSize = 11
resetToolsBtn.Parent = toolsRight

local resetToolsCorner = Instance.new("UICorner")
resetToolsCorner.CornerRadius = UDim.new(0, 8)
resetToolsCorner.Parent = resetToolsBtn

-- ========== CHAT TAB ==========
local chatSection = Instance.new("Frame")
chatSection.Size = UDim2.new(1, 0, 1, 0)
chatSection.BackgroundTransparency = 1
chatSection.Visible = false
chatSection.Parent = contentFrame

-- Chat Input
local chatInput = Instance.new("TextBox")
chatInput.Size = UDim2.new(1, 0, 0, 50)
chatInput.BackgroundColor3 = COLORS.card
chatInput.TextColor3 = COLORS.text
chatInput.Text = ""
chatInput.PlaceholderText = "Type message here..."
chatInput.PlaceholderColor3 = COLORS.textMuted
chatInput.Font = Enum.Font.Gotham
chatInput.TextSize = 12
chatInput.TextXAlignment = Enum.TextXAlignment.Left
chatInput.TextYAlignment = Enum.TextYAlignment.Top
chatInput.MultiLine = true
chatInput.TextWrapped = true
chatInput.Parent = chatSection

local chatInputCorner = Instance.new("UICorner")
chatInputCorner.CornerRadius = UDim.new(0, 8)
chatInputCorner.Parent = chatInput

-- Send Button
local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0.5, -5, 0, 30)
sendBtn.Position = UDim2.new(0, 0, 0, 55)
sendBtn.BackgroundColor3 = COLORS.accent
sendBtn.TextColor3 = COLORS.text
sendBtn.Text = "📤 Send"
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 11
sendBtn.Parent = chatSection

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 6)
sendCorner.Parent = sendBtn

-- Spam Button
local spamBtn = Instance.new("TextButton")
spamBtn.Size = UDim2.new(0.5, -5, 0, 30)
spamBtn.Position = UDim2.new(0.5, 5, 0, 55)
spamBtn.BackgroundColor3 = COLORS.card
spamBtn.TextColor3 = COLORS.text
spamBtn.Text = "🔁 Spam: OFF"
spamBtn.Font = Enum.Font.GothamBold
spamBtn.TextSize = 11
spamBtn.Parent = chatSection

local spamCorner = Instance.new("UICorner")
spamCorner.CornerRadius = UDim.new(0, 6)
spamCorner.Parent = spamBtn

-- Spam Delay
local spamDelayRow = Instance.new("Frame")
spamDelayRow.Size = UDim2.new(1, 0, 0, 25)
spamDelayRow.Position = UDim2.new(0, 0, 0, 90)
spamDelayRow.BackgroundTransparency = 1
spamDelayRow.Parent = chatSection

local spamDelayLabel = Instance.new("TextLabel")
spamDelayLabel.Size = UDim2.new(0, 80, 1, 0)
spamDelayLabel.BackgroundTransparency = 1
spamDelayLabel.TextColor3 = COLORS.text
spamDelayLabel.Text = "Spam Delay:"
spamDelayLabel.Font = Enum.Font.Gotham
spamDelayLabel.TextSize = 10
spamDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
spamDelayLabel.Parent = spamDelayRow

local spamDelayInput = Instance.new("TextBox")
spamDelayInput.Size = UDim2.new(0, 40, 1, 0)
spamDelayInput.Position = UDim2.new(0, 85, 0, 0)
spamDelayInput.BackgroundColor3 = COLORS.card
spamDelayInput.TextColor3 = COLORS.text
spamDelayInput.Text = "1"
spamDelayInput.Font = Enum.Font.Gotham
spamDelayInput.TextSize = 10
spamDelayInput.Parent = spamDelayRow

local spamDelayCorner = Instance.new("UICorner")
spamDelayCorner.CornerRadius = UDim.new(0, 4)
spamDelayCorner.Parent = spamDelayInput

local spamDelaySec = Instance.new("TextLabel")
spamDelaySec.Size = UDim2.new(0, 30, 1, 0)
spamDelaySec.Position = UDim2.new(0, 130, 0, 0)
spamDelaySec.BackgroundTransparency = 1
spamDelaySec.TextColor3 = COLORS.textMuted
spamDelaySec.Text = "sec"
spamDelaySec.Font = Enum.Font.Gotham
spamDelaySec.TextSize = 10
spamDelaySec.TextXAlignment = Enum.TextXAlignment.Left
spamDelaySec.Parent = spamDelayRow

-- Quick Messages
local quickLabel = Instance.new("TextLabel")
quickLabel.Size = UDim2.new(1, 0, 0, 20)
quickLabel.Position = UDim2.new(0, 0, 0, 120)
quickLabel.BackgroundTransparency = 1
quickLabel.TextColor3 = COLORS.textMuted
quickLabel.Text = "Quick Messages:"
quickLabel.Font = Enum.Font.GothamBold
quickLabel.TextSize = 10
quickLabel.TextXAlignment = Enum.TextXAlignment.Left
quickLabel.Parent = chatSection

local quickMsgs = {"GG", "Hello!", "Nice!", "LOL", "WTF", "Bye"}
for i, msg in ipairs(quickMsgs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/3 - 3, 0, 0, 22)
    btn.Position = UDim2.new(((i-1)%3)/3, ((i-1)%3) * 3, 0, 140 + math.floor((i-1)/3) * 26)
    btn.BackgroundColor3 = COLORS.card
    btn.TextColor3 = COLORS.text
    btn.Text = msg
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 9
    btn.Parent = chatSection
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if chatRemote then
                local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
                if sayMessage then
                    sayMessage:FireServer(msg, "All")
                end
            end
        end
    end)
end

-- ========== DRAGGING ==========
local dragging = false
local dragInput, dragStart, startPos

hubButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = hubButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

hubButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        hubButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local mainDragging = false
local mainDragInput, mainDragStart, mainDragPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mainDragging = true
        mainDragStart = input.Position
        mainDragPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                mainDragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        mainDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == mainDragInput and mainDragging then
        local delta = input.Position - mainDragStart
        mainFrame.Position = UDim2.new(mainDragPos.X.Scale, mainDragPos.X.Offset + delta.X, mainDragPos.Y.Scale, mainDragPos.Y.Offset + delta.Y)
    end
end)

-- ========== TOGGLE ==========
hubButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        wait(0.1)
        if not dragging then
            hubButton.Visible = false
            mainFrame.Visible = true
        end
    end
end)

collapseBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

-- ========== TAB SWITCHING ==========
local function switchTab(tabName)
    currentTab = tabName
    
    -- Hide all sections
    funSection.Visible = false
    visualSection.Visible = false
    statsSection.Visible = false
    toolsSection.Visible = false
    chatSection.Visible = false
    
    -- Show selected section
    if tabName == "Fun" then funSection.Visible = true
    elseif tabName == "Visual" then visualSection.Visible = true
    elseif tabName == "Stats" then statsSection.Visible = true
    elseif tabName == "Tools" then toolsSection.Visible = true
    elseif tabName == "Chat" then chatSection.Visible = true
    end
    
    -- Update button colors
    for name, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = name == tabName and COLORS.accent or COLORS.card
    end
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- ========== TOGGLE KEY ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        if mainFrame.Visible then
            mainFrame.Visible = false
            hubButton.Visible = true
        else
            hubButton.Visible = not hubButton.Visible
        end
    end
end)

-- ========== STATES ==========
local states = {
    rainbow = false,
    disco = false,
    spin = false,
    fakeLag = false,
    bigHead = false,
    tinyBody = false,
    float = false,
    fullbright = false,
    noFog = false,
    nightSky = false,
    esp = false,
    tracers = false,
    noclip = false,
    fly = false,
    spam = false
}

local espHighlights = {}
local tracerLines = {}
local spinSpeed = 0
local floatHeight = 5

-- ========== HELPER FUNCTIONS ==========
local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChild("Humanoid")
end

local function getAllParts()
    local char = getCharacter()
    if not char then return {} end
    local parts = {}
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(parts, part)
        end
    end
    return parts
end

local function toggleButton(btn, state, onText, offText)
    btn.Text = state and onText or offText
    btn.BackgroundColor3 = state and COLORS.success or COLORS.card
end

-- ========== FUN FEATURES ==========

-- Rainbow Character
local rainbowConnection
rainbowBtn.MouseButton1Click:Connect(function()
    states.rainbow = not states.rainbow
    toggleButton(rainbowBtn, states.rainbow, "🌈 Rainbow: ON", "🌈 Rainbow Character")
    
    if states.rainbow then
        rainbowConnection = RunService.Heartbeat:Connect(function()
            local parts = getAllParts()
            local hue = tick() % 1
            for _, part in pairs(parts) do
                part.Color = Color3.fromHSV(hue, 1, 1)
                hue = (hue + 0.01) % 1
            end
        end)
    else
        if rainbowConnection then rainbowConnection:Disconnect() end
        -- Reset colors would require storing original - simplified
    end
end)

-- Disco Mode
local discoConnection
discoBtn.MouseButton1Click:Connect(function()
    states.disco = not states.disco
    toggleButton(discoBtn, states.disco, "🪩 Disco: ON", "🪩 Disco Mode")
    
    if states.disco then
        discoConnection = RunService.Heartbeat:Connect(function()
            local hue = tick() % 1
            Lighting.Ambient = Color3.fromHSV(hue, 1, 1)
            Lighting.ColorShift_Bottom = Color3.fromHSV((hue + 0.33) % 1, 1, 1)
            Lighting.ColorShift_Top = Color3.fromHSV((hue + 0.66) % 1, 1, 1)
        end)
    else
        if discoConnection then discoConnection:Disconnect() end
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
        Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    end
end)

-- Spin Character
local spinConnection
spinBtn.MouseButton1Click:Connect(function()
    states.spin = not states.spin
    toggleButton(spinBtn, states.spin, "🔄 Spinning: ON", "🔄 Spin Character")
    
    if states.spin then
        spinConnection = RunService.Heartbeat:Connect(function()
            local hrp = getHRP()
            if hrp then
                spinSpeed = spinSpeed + 5
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(5), 0)
            end
        end)
    else
        if spinConnection then spinConnection:Disconnect() end
        spinSpeed = 0
    end
end)

-- Fake Lag
local fakeLagConnection
fakeLagBtn.MouseButton1Click:Connect(function()
    states.fakeLag = not states.fakeLag
    toggleButton(fakeLagBtn, states.fakeLag, "📶 Fake Lag: ON", "📶 Fake Lag: OFF")
    
    if states.fakeLag then
        fakeLagConnection = RunService.Heartbeat:Connect(function()
            local hrp = getHRP()
            if hrp and math.random(1, 10) > 7 then
                hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + Vector3.new(
                    math.random(-5, 5),
                    math.random(-2, 2),
                    math.random(-5, 5)
                )
            end
        end)
    else
        if fakeLagConnection then fakeLagConnection:Disconnect() end
    end
end)

-- Big Head
bigHeadBtn.MouseButton1Click:Connect(function()
    states.bigHead = not states.bigHead
    toggleButton(bigHeadBtn, states.bigHead, "🗣️ Big Head: ON", "🗣️ Big Head")
    
    local char = getCharacter()
    local head = char and char:FindFirstChild("Head")
    if head then
        if states.bigHead then
            head.Size = Vector3.new(4, 4, 4)
        else
            head.Size = Vector3.new(2, 1, 1)
        end
    end
end)

-- Tiny Body
tinyBodyBtn.MouseButton1Click:Connect(function()
    states.tinyBody = not states.tinyBody
    toggleButton(tinyBodyBtn, states.tinyBody, "🧸 Tiny Body: ON", "🧒 Tiny Body")
    
    local char = getCharacter()
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "Head" then
                if states.tinyBody then
                    part.Size = part.Size * 0.5
                else
                    part.Size = part.Size * 2
                end
            end
        end
    end
end)

-- Float
local floatConnection
floatBtn.MouseButton1Click:Connect(function()
    states.float = not states.float
    toggleButton(floatBtn, states.float, "☁️ Float: ON", "☁️ Float: OFF")
    
    if states.float then
        floatConnection = RunService.Heartbeat:Connect(function()
            local hrp = getHRP()
            if hrp then
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 0.1, 0)
            end
        end)
    else
        if floatConnection then floatConnection:Disconnect() end
    end
end)

-- Reset Character
resetBtn.MouseButton1Click:Connect(function()
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.Health = 0
    end
end)

-- ========== VISUAL FEATURES ==========

-- Fullbright
fullbrightBtn.MouseButton1Click:Connect(function()
    states.fullbright = not states.fullbright
    toggleButton(fullbrightBtn, states.fullbright, "💡 Fullbright: ON", "💡 Fullbright: OFF")
    
    if states.fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

-- No Fog
noFogBtn.MouseButton1Click:Connect(function()
    states.noFog = not states.noFog
    toggleButton(noFogBtn, states.noFog, "🌫️ No Fog: ON", "🌫️ No Fog: OFF")
    
    if states.noFog then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
    else
        Lighting.FogEnd = 1000
        Lighting.FogStart = 0
    end
end)

-- Night Sky
skyboxBtn.MouseButton1Click:Connect(function()
    states.nightSky = not states.nightSky
    toggleButton(skyboxBtn, states.nightSky, "🌌 Night Sky: ON", "🌌 Night Sky: OFF")
    
    if states.nightSky then
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.5
    else
        Lighting.ClockTime = 14
        Lighting.Brightness = 1
    end
end)

-- Player ESP
local espConnection
espBtn.MouseButton1Click:Connect(function()
    states.esp = not states.esp
    toggleButton(espBtn, states.esp, "👁️ Player ESP: ON", "👁️ Player ESP: OFF")
    
    if states.esp then
        espConnection = RunService.Heartbeat:Connect(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and not espHighlights[plr] then
                        local highlight = Instance.new("Highlight")
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.Parent = plr.Character
                        espHighlights[plr] = highlight
                    end
                end
            end
        end)
    else
        if espConnection then espConnection:Disconnect() end
        for _, highlight in pairs(espHighlights) do
            highlight:Destroy()
        end
        espHighlights = {}
    end
end)

-- Tracers
local tracerConnection
tracerBtn.MouseButton1Click:Connect(function()
    states.tracers = not states.tracers
    toggleButton(tracerBtn, states.tracers, "📍 Tracers: ON", "📍 Tracers: OFF")
    
    if states.tracers then
        tracerConnection = RunService.Heartbeat:Connect(function()
            local myHrp = getHRP()
            if not myHrp then return end
            
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        if not tracerLines[plr] then
                            local line = Instance.new("Frame")
                            line.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                            line.BorderSizePixel = 0
                            line.Parent = screenGui
                            tracerLines[plr] = line
                        end
                        
                        -- Simple tracer update
                        local line = tracerLines[plr]
                        local distance = (hrp.Position - myHrp.Position).Magnitude
                        line.Size = UDim2.new(0, 2, 0, distance)
                        line.Position = UDim2.new(0, 100, 0, 100)
                    end
                end
            end
        end)
    else
        if tracerConnection then tracerConnection:Disconnect() end
        for _, line in pairs(tracerLines) do
            line:Destroy()
        end
        tracerLines = {}
    end
end)

-- Reset Visuals
resetVisualBtn.MouseButton1Click:Connect(function()
    -- Reset lighting
    Lighting.Brightness = 1
    Lighting.ClockTime = 14
    Lighting.FogEnd = 1000
    Lighting.GlobalShadows = true
    Lighting.Ambient = Color3.fromRGB(128, 128, 128)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    
    -- Clear ESP
    for _, highlight in pairs(espHighlights) do
        highlight:Destroy()
    end
    espHighlights = {}
    
    -- Clear tracers
    for _, line in pairs(tracerLines) do
        line:Destroy()
    end
    tracerLines = {}
    
    states.fullbright = false
    states.noFog = false
    states.nightSky = false
    states.esp = false
    states.tracers = false
    
    fullbrightBtn.Text = "💡 Fullbright: OFF"
    fullbrightBtn.BackgroundColor3 = COLORS.card
    noFogBtn.Text = "🌫️ No Fog: OFF"
    noFogBtn.BackgroundColor3 = COLORS.card
    skyboxBtn.Text = "🌌 Night Sky: OFF"
    skyboxBtn.BackgroundColor3 = COLORS.card
    espBtn.Text = "👁️ Player ESP: OFF"
    espBtn.BackgroundColor3 = COLORS.card
    tracerBtn.Text = "📍 Tracers: OFF"
    tracerBtn.BackgroundColor3 = COLORS.card
end)

-- ========== STATS ==========
local function updateStats()
    local char = getCharacter()
    local hrp = getHRP()
    local humanoid = getHumanoid()
    
    local stats = {}
    
    -- Position
    if hrp then
        stats[#stats + 1] = "📍 Position: X=" .. string.format("%.1f", hrp.Position.X) .. " Y=" .. string.format("%.1f", hrp.Position.Y) .. " Z=" .. string.format("%.1f", hrp.Position.Z)
    end
    
    -- Health
    if humanoid then
        stats[#stats + 1] = "❤️ Health: " .. string.format("%.0f", humanoid.Health) .. "/" .. string.format("%.0f", humanoid.MaxHealth)
        stats[#stats + 1] = "🏃 WalkSpeed: " .. humanoid.WalkSpeed
        stats[#stats + 1] = "🦘 JumpPower: " .. humanoid.JumpPower
    end
    
    -- Game Info
    stats[#stats + 1] = ""
    stats[#stats + 1] = "🎮 Game: " .. game.Name
    stats[#stats + 1] = "👥 Players: " .. #Players:GetPlayers()
    stats[#stats + 1] = "🕐 Time: " .. os.date("%H:%M:%S")
    
    statsLabel.Text = table.concat(stats, "\n")
end

RunService.Heartbeat:Connect(updateStats)

-- ========== TOOLS FEATURES ==========

-- TP to Mouse
tpMouseBtn.MouseButton1Click:Connect(function()
    local hrp = getHRP()
    local mouse = player:GetMouse()
    if hrp and mouse.Hit then
        hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
    end
end)

-- Speed
speedBtn.MouseButton1Click:Connect(function()
    local humanoid = getHumanoid()
    if humanoid then
        local speed = tonumber(speedInput.Text) or 16
        humanoid.WalkSpeed = speed
    end
end)

-- Jump
jumpBtn.MouseButton1Click:Connect(function()
    local humanoid = getHumanoid()
    if humanoid then
        local jump = tonumber(jumpInput.Text) or 50
        humanoid.JumpPower = jump
    end
end)

-- Noclip
local noclipConnection
noclipBtn.MouseButton1Click:Connect(function()
    states.noclip = not states.noclip
    toggleButton(noclipBtn, states.noclip, "👻 Noclip: ON", "👻 Noclip: OFF")
    
    if states.noclip then
        noclipConnection = RunService.Heartbeat:Connect(function()
            local char = getCharacter()
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
        local char = getCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- Fly
local flyConnection
local flySpeed = 50
flyBtn.MouseButton1Click:Connect(function()
    states.fly = not states.fly
    toggleButton(flyBtn, states.fly, "🦅 Fly: ON (V)", "🦅 Fly: OFF (V)")
    
    if states.fly then
        local bodyGyro = Instance.new("BodyGyro")
        local bodyVel = Instance.new("BodyVelocity")
        
        local hrp = getHRP()
        if hrp then
            bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyGyro.P = 9e4
            bodyGyro.Parent = hrp
            
            bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVel.Parent = hrp
            
            flyConnection = RunService.Heartbeat:Connect(function()
                local camera = workspace.CurrentCamera
                local moveDir = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end
                
                bodyGyro.CFrame = camera.CFrame
                bodyVel.Velocity = moveDir * flySpeed
            end)
        end
        
        -- Store for cleanup
        hrp:SetAttribute("FlyGyro", bodyGyro)
        hrp:SetAttribute("FlyVel", bodyVel)
    else
        if flyConnection then flyConnection:Disconnect() end
        local hrp = getHRP()
        if hrp then
            for _, child in pairs(hrp:GetChildren()) do
                if child:IsA("BodyGyro") or child:IsA("BodyVelocity") then
                    child:Destroy()
                end
            end
        end
    end
end)

-- V key toggle for fly
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.V then
        flyBtn.MouseButton1Click:Fire()
    end
end)

-- Reset Tools
resetToolsBtn.MouseButton1Click:Connect(function()
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
    
    -- Disable noclip
    if states.noclip then
        noclipBtn.MouseButton1Click:Fire()
    end
    
    -- Disable fly
    if states.fly then
        flyBtn.MouseButton1Click:Fire()
    end
    
    states.noclip = false
    states.fly = false
    noclipBtn.Text = "👻 Noclip: OFF"
    noclipBtn.BackgroundColor3 = COLORS.card
    flyBtn.Text = "🦅 Fly: OFF (V)"
    flyBtn.BackgroundColor3 = COLORS.card
end)

-- ========== CHAT FEATURES ==========

-- Send Message
sendBtn.MouseButton1Click:Connect(function()
    local message = chatInput.Text
    if message ~= "" then
        local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatRemote then
            local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
            if sayMessage then
                sayMessage:FireServer(message, "All")
            end
        end
        chatInput.Text = ""
    end
end)

-- Spam
local spamConnection
spamBtn.MouseButton1Click:Connect(function()
    states.spam = not states.spam
    toggleButton(spamBtn, states.spam, "🔁 Spam: ON", "🔁 Spam: OFF")
    
    if states.spam then
        local delay = tonumber(spamDelayInput.Text) or 1
        spamConnection = RunService.Heartbeat:Connect(function()
            wait(delay)
            local message = chatInput.Text
            if message ~= "" then
                local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                if chatRemote then
                    local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
                    if sayMessage then
                        sayMessage:FireServer(message, "All")
                    end
                end
            end
        end)
    else
        if spamConnection then spamConnection:Disconnect() end
    end
end)

-- ========== FPS COUNTER ==========
local fpsUpdate = 0
RunService.Heartbeat:Connect(function()
    fpsUpdate = fpsUpdate + 1
    if fpsUpdate >= 30 then
        fpsLabel.Text = tostring(math.floor(1 / RunService.Heartbeat:Wait())) .. " FPS"
        fpsUpdate = 0
    end
end)

print("✅ GLM Hub Loaded - Press RightControl to toggle")
