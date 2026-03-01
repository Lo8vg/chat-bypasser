-- Hybrid Kill Script (Auto-Switch: Fling + Aura)
-- Detects movement and switches modes automatically

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local killEnabled = false
local targetPlayer = nil
local autoSwitchEnabled = true
local velocityThreshold = 5 -- studs/sec

-- Fling settings
local flingSpinPower = 999999
local flingLaunchPower = 999999

-- Aura settings
local teleportDistance = 2
local teleportDelay = 0.1
local swingDelay = 0.01
local smartMode = true
local spawnWaitTime = 5

-- Tracking
local currentMode = "NONE" -- "FLING" or "AURA"
local flingCount = 0
local killCount = 0

-- Body movers for fling
local bodyAngularVel = nil
local bodyVel = nil

-- Colors
local COLORS = {
    background = Color3.fromRGB(245, 245, 245),
    header = Color3.fromRGB(255, 255, 255),
    buttonPrimary = Color3.fromRGB(0, 120, 215),
    buttonDanger = Color3.fromRGB(220, 53, 69),
    buttonSuccess = Color3.fromRGB(40, 167, 69),
    buttonWarning = Color3.fromRGB(255, 193, 7),
    buttonPurple = Color3.fromRGB(111, 66, 193),
    textDark = Color3.fromRGB(33, 37, 41),
    textLight = Color3.fromRGB(255, 255, 255),
    textMuted = Color3.fromRGB(134, 142, 150),
    inputBg = Color3.fromRGB(255, 255, 255),
    border = Color3.fromRGB(222, 226, 230),
    cardBg = Color3.fromRGB(255, 255, 255)
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HybridKillGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========== HUB BUTTON ==========

local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 50, 0, 50)
hubButton.Position = UDim2.new(0, 20, 0.5, -25)
hubButton.BackgroundColor3 = COLORS.cardBg
hubButton.BorderSizePixel = 0
hubButton.Visible = true
hubButton.Parent = screenGui

local hubButtonCorner = Instance.new("UICorner")
hubButtonCorner.CornerRadius = UDim.new(0, 10)
hubButtonCorner.Parent = hubButton

local hubButtonShadow = Instance.new("UIStroke")
hubButtonShadow.Color = COLORS.border
hubButtonShadow.Thickness = 1
hubButtonShadow.Parent = hubButton

local hubButtonIcon = Instance.new("TextLabel")
hubButtonIcon.Size = UDim2.new(1, 0, 1, 0)
hubButtonIcon.BackgroundTransparency = 1
hubButtonIcon.TextColor3 = COLORS.textDark
hubButtonIcon.Text = "⚔️"
hubButtonIcon.Font = Enum.Font.GothamBold
hubButtonIcon.TextSize = 22
hubButtonIcon.Parent = hubButton

-- ========== MAIN FRAME ==========

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 320)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
mainFrame.BackgroundColor3 = COLORS.background
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 14)
mainFrameCorner.Parent = mainFrame

local mainFrameShadow = Instance.new("UIStroke")
mainFrameShadow.Color = Color3.fromRGB(180, 180, 180)
mainFrameShadow.Thickness = 1
mainFrameShadow.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = COLORS.header
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 14)
titleBarCorner.Parent = titleBar

local titleBarFix = Instance.new("Frame")
titleBarFix.Size = UDim2.new(1, 0, 0, 14)
titleBarFix.Position = UDim2.new(0, 0, 1, -14)
titleBarFix.BackgroundColor3 = COLORS.header
titleBarFix.BorderSizePixel = 0
titleBarFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = COLORS.textDark
titleLabel.Text = "⚔️ Hybrid Kill Script"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 28, 0, 22)
collapseButton.Position = UDim2.new(1, -35, 0.5, -11)
collapseButton.BackgroundColor3 = COLORS.buttonDanger
collapseButton.TextColor3 = COLORS.textLight
collapseButton.Text = "✕"
collapseButton.Font = Enum.Font.GothamBold
collapseButton.TextSize = 11
collapseButton.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseButton

-- ========== LEFT FRAME ==========

local leftFrame = Instance.new("Frame")
leftFrame.Size = UDim2.new(0.4, -15, 1, -50)
leftFrame.Position = UDim2.new(0, 10, 0, 40)
leftFrame.BackgroundTransparency = 1
leftFrame.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 0, 35)
toggleButton.Position = UDim2.new(0, 0, 0, 0)
toggleButton.BackgroundColor3 = COLORS.buttonDanger
toggleButton.TextColor3 = COLORS.textLight
toggleButton.Text = "AUTO KILL: OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = leftFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Auto Switch Toggle
local autoSwitchToggle = Instance.new("TextButton")
autoSwitchToggle.Size = UDim2.new(1, 0, 0, 28)
autoSwitchToggle.Position = UDim2.new(0, 0, 0, 40)
autoSwitchToggle.BackgroundColor3 = COLORS.buttonSuccess
autoSwitchToggle.TextColor3 = COLORS.textLight
autoSwitchToggle.Text = "AUTO SWITCH: ON"
autoSwitchToggle.Font = Enum.Font.GothamBold
autoSwitchToggle.TextSize = 10
autoSwitchToggle.Parent = leftFrame

local autoSwitchCorner = Instance.new("UICorner")
autoSwitchCorner.CornerRadius = UDim.new(0, 6)
autoSwitchCorner.Parent = autoSwitchToggle

-- Stats Row
local statsRow = Instance.new("Frame")
statsRow.Size = UDim2.new(1, 0, 0, 18)
statsRow.Position = UDim2.new(0, 0, 0, 73)
statsRow.BackgroundTransparency = 1
statsRow.Parent = leftFrame

local flingCounter = Instance.new("TextLabel")
flingCounter.Size = UDim2.new(0.5, 0, 1, 0)
flingCounter.BackgroundTransparency = 1
flingCounter.TextColor3 = COLORS.buttonPurple
flingCounter.Text = "Flings: 0"
flingCounter.Font = Enum.Font.GothamBold
flingCounter.TextSize = 10
flingCounter.Parent = statsRow

local killCounter = Instance.new("TextLabel")
killCounter.Size = UDim2.new(0.5, 0, 1, 0)
killCounter.Position = UDim2.new(0.5, 0, 0, 0)
killCounter.BackgroundTransparency = 1
killCounter.TextColor3 = COLORS.buttonSuccess
killCounter.Text = "Kills: 0"
killCounter.Font = Enum.Font.GothamBold
killCounter.TextSize = 10
killCounter.Parent = statsRow

-- Current Mode Display
local modeDisplay = Instance.new("TextLabel")
modeDisplay.Size = UDim2.new(1, 0, 0, 22)
modeDisplay.Position = UDim2.new(0, 0, 0, 94)
modeDisplay.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
modeDisplay.TextColor3 = COLORS.textDark
modeDisplay.Text = "MODE: NONE"
modeDisplay.Font = Enum.Font.GothamBold
modeDisplay.TextSize = 11
modeDisplay.Parent = leftFrame

local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 5)
modeCorner.Parent = modeDisplay

-- Target Label
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, 0, 0, 16)
targetLabel.Position = UDim2.new(0, 0, 0, 121)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = COLORS.textDark
targetLabel.Text = "Select Target:"
targetLabel.Font = Enum.Font.GothamBold
targetLabel.TextSize = 10
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = leftFrame

-- Player List
local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1, 0, 0, 80)
playerScroll.Position = UDim2.new(0, 0, 0, 139)
playerScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerScroll.ScrollBarThickness = 4
playerScroll.Parent = leftFrame

local playerScrollCorner = Instance.new("UICorner")
playerScrollCorner.CornerRadius = UDim.new(0, 6)
playerScrollCorner.Parent = playerScroll

local playerLayout = Instance.new("UIListLayout")
playerLayout.Padding = UDim.new(0, 2)
playerLayout.Parent = playerScroll

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.Position = UDim2.new(0, 0, 0, 222)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = COLORS.textMuted
statusLabel.Text = "No target selected"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 9
statusLabel.TextWrapped = true
statusLabel.Parent = leftFrame

-- ========== MIDDLE FRAME (Aura Settings) ==========

local middleFrame = Instance.new("Frame")
middleFrame.Size = UDim2.new(0.3, -10, 1, -50)
middleFrame.Position = UDim2.new(0.4, 5, 0, 40)
middleFrame.BackgroundTransparency = 1
middleFrame.Parent = mainFrame

-- Aura Header
local auraHeader = Instance.new("TextLabel")
auraHeader.Size = UDim2.new(1, 0, 0, 18)
auraHeader.Position = UDim2.new(0, 0, 0, 0)
auraHeader.BackgroundTransparency = 1
auraHeader.TextColor3 = COLORS.buttonSuccess
auraHeader.Text = "⚔️ AURA MODE"
auraHeader.Font = Enum.Font.GothamBold
auraHeader.TextSize = 11
auraHeader.TextXAlignment = Enum.TextXAlignment.Left
auraHeader.Parent = middleFrame

-- Teleport Distance
local distRow = Instance.new("Frame")
distRow.Size = UDim2.new(1, 0, 0, 22)
distRow.Position = UDim2.new(0, 0, 0, 22)
distRow.BackgroundTransparency = 1
distRow.Parent = middleFrame

local distLabel = Instance.new("TextLabel")
distLabel.Size = UDim2.new(0, 60, 1, 0)
distLabel.BackgroundTransparency = 1
distLabel.TextColor3 = COLORS.textDark
distLabel.Text = "Distance:"
distLabel.Font = Enum.Font.Gotham
distLabel.TextSize = 9
distLabel.TextXAlignment = Enum.TextXAlignment.Left
distLabel.Parent = distRow

local distInput = Instance.new("TextBox")
distInput.Size = UDim2.new(0, 50, 1, 0)
distInput.Position = UDim2.new(0, 65, 0, 0)
distInput.BackgroundColor3 = COLORS.inputBg
distInput.TextColor3 = COLORS.textDark
distInput.Text = "2"
distInput.Font = Enum.Font.Gotham
distInput.TextSize = 9
distInput.ClearTextOnFocus = false
distInput.Parent = distRow

local distCorner = Instance.new("UICorner")
distCorner.CornerRadius = UDim.new(0, 4)
distCorner.Parent = distInput

local distStroke = Instance.new("UIStroke")
distStroke.Color = COLORS.border
distStroke.Thickness = 1
distStroke.Parent = distInput

-- Swing Speed
local swingRow = Instance.new("Frame")
swingRow.Size = UDim2.new(1, 0, 0, 22)
swingRow.Position = UDim2.new(0, 0, 0, 46)
swingRow.BackgroundTransparency = 1
swingRow.Parent = middleFrame

local swingLabel = Instance.new("TextLabel")
swingLabel.Size = UDim2.new(0, 60, 1, 0)
swingLabel.BackgroundTransparency = 1
swingLabel.TextColor3 = COLORS.textDark
swingLabel.Text = "Swing:"
swingLabel.Font = Enum.Font.Gotham
swingLabel.TextSize = 9
swingLabel.TextXAlignment = Enum.TextXAlignment.Left
swingLabel.Parent = swingRow

local swingInput = Instance.new("TextBox")
swingInput.Size = UDim2.new(0, 50, 1, 0)
swingInput.Position = UDim2.new(0, 65, 0, 0)
swingInput.BackgroundColor3 = COLORS.inputBg
swingInput.TextColor3 = COLORS.textDark
swingInput.Text = "0.01"
swingInput.Font = Enum.Font.Gotham
swingInput.TextSize = 9
swingInput.ClearTextOnFocus = false
swingInput.Parent = swingRow

local swingCorner = Instance.new("UICorner")
swingCorner.CornerRadius = UDim.new(0, 4)
swingCorner.Parent = swingInput

local swingStroke = Instance.new("UIStroke")
swingStroke.Color = COLORS.border
swingStroke.Thickness = 1
swingStroke.Parent = swingInput

-- TP Delay
local tpRow = Instance.new("Frame")
tpRow.Size = UDim2.new(1, 0, 0, 22)
tpRow.Position = UDim2.new(0, 0, 0, 70)
tpRow.BackgroundTransparency = 1
tpRow.Parent = middleFrame

local tpLabel = Instance.new("TextLabel")
tpLabel.Size = UDim2.new(0, 60, 1, 0)
tpLabel.BackgroundTransparency = 1
tpLabel.TextColor3 = COLORS.textDark
tpLabel.Text = "TP Delay:"
tpLabel.Font = Enum.Font.Gotham
tpLabel.TextSize = 9
tpLabel.TextXAlignment = Enum.TextXAlignment.Left
tpLabel.Parent = tpRow

local tpInput = Instance.new("TextBox")
tpInput.Size = UDim2.new(0, 50, 1, 0)
tpInput.Position = UDim2.new(0, 65, 0, 0)
tpInput.BackgroundColor3 = COLORS.inputBg
tpInput.TextColor3 = COLORS.textDark
tpInput.Text = "0.1"
tpInput.Font = Enum.Font.Gotham
tpInput.TextSize = 9
tpInput.ClearTextOnFocus = false
tpInput.Parent = tpRow

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 4)
tpCorner.Parent = tpInput

local tpStroke = Instance.new("UIStroke")
tpStroke.Color = COLORS.border
tpStroke.Thickness = 1
tpStroke.Parent = tpInput

-- Smart Mode Toggle
local smartToggle = Instance.new("TextButton")
smartToggle.Size = UDim2.new(1, 0, 0, 24)
smartToggle.Position = UDim2.new(0, 0, 0, 96)
smartToggle.BackgroundColor3 = COLORS.buttonSuccess
smartToggle.TextColor3 = COLORS.textLight
smartToggle.Text = "SMART: ON"
smartToggle.Font = Enum.Font.GothamBold
smartToggle.TextSize = 9
smartToggle.Parent = middleFrame

local smartCorner = Instance.new("UICorner")
smartCorner.CornerRadius = UDim.new(0, 5)
smartCorner.Parent = smartToggle

-- Spawn Wait
local spawnRow = Instance.new("Frame")
spawnRow.Size = UDim2.new(1, 0, 0, 22)
spawnRow.Position = UDim2.new(0, 0, 0, 124)
spawnRow.BackgroundTransparency = 1
spawnRow.Parent = middleFrame

local spawnLabel = Instance.new("TextLabel")
spawnLabel.Size = UDim2.new(0, 60, 1, 0)
spawnLabel.BackgroundTransparency = 1
spawnLabel.TextColor3 = COLORS.textDark
spawnLabel.Text = "Spawn Wait:"
spawnLabel.Font = Enum.Font.Gotham
spawnLabel.TextSize = 9
spawnLabel.TextXAlignment = Enum.TextXAlignment.Left
spawnLabel.Parent = spawnRow

local spawnInput = Instance.new("TextBox")
spawnInput.Size = UDim2.new(0, 50, 1, 0)
spawnInput.Position = UDim2.new(0, 65, 0, 0)
spawnInput.BackgroundColor3 = COLORS.inputBg
spawnInput.TextColor3 = COLORS.textDark
spawnInput.Text = "5"
spawnInput.Font = Enum.Font.Gotham
spawnInput.TextSize = 9
spawnInput.ClearTextOnFocus = false
spawnInput.Parent = spawnRow

local spawnCorner = Instance.new("UICorner")
spawnCorner.CornerRadius = UDim.new(0, 4)
spawnCorner.Parent = spawnInput

local spawnStroke = Instance.new("UIStroke")
spawnStroke.Color = COLORS.border
spawnStroke.Thickness = 1
spawnStroke.Parent = spawnInput

-- ========== RIGHT FRAME (Fling Settings) ==========

local rightFrame = Instance.new("Frame")
rightFrame.Size = UDim2.new(0.3, -10, 1, -50)
rightFrame.Position = UDim2.new(0.7, 5, 0, 40)
rightFrame.BackgroundTransparency = 1
rightFrame.Parent = mainFrame

-- Fling Header
local flingHeader = Instance.new("TextLabel")
flingHeader.Size = UDim2.new(1, 0, 0, 18)
flingHeader.Position = UDim2.new(0, 0, 0, 0)
flingHeader.BackgroundTransparency = 1
flingHeader.TextColor3 = COLORS.buttonPurple
flingHeader.Text = "🌀 FLING MODE"
flingHeader.Font = Enum.Font.GothamBold
flingHeader.TextSize = 11
flingHeader.TextXAlignment = Enum.TextXAlignment.Left
flingHeader.Parent = rightFrame

-- Spin Power
local spinRow = Instance.new("Frame")
spinRow.Size = UDim2.new(1, 0, 0, 22)
spinRow.Position = UDim2.new(0, 0, 0, 22)
spinRow.BackgroundTransparency = 1
spinRow.Parent = rightFrame

local spinLabel = Instance.new("TextLabel")
spinLabel.Size = UDim2.new(0, 60, 1, 0)
spinLabel.BackgroundTransparency = 1
spinLabel.TextColor3 = COLORS.textDark
spinLabel.Text = "Spin:"
spinLabel.Font = Enum.Font.Gotham
spinLabel.TextSize = 9
spinLabel.TextXAlignment = Enum.TextXAlignment.Left
spinLabel.Parent = spinRow

local spinInput = Instance.new("TextBox")
spinInput.Size = UDim2.new(0, 70, 1, 0)
spinInput.Position = UDim2.new(0, 65, 0, 0)
spinInput.BackgroundColor3 = COLORS.inputBg
spinInput.TextColor3 = COLORS.textDark
spinInput.Text = "999999"
spinInput.Font = Enum.Font.Gotham
spinInput.TextSize = 9
spinInput.ClearTextOnFocus = false
spinInput.Parent = spinRow

local spinCorner = Instance.new("UICorner")
spinCorner.CornerRadius = UDim.new(0, 4)
spinCorner.Parent = spinInput

local spinStroke = Instance.new("UIStroke")
spinStroke.Color = COLORS.border
spinStroke.Thickness = 1
spinStroke.Parent = spinInput

-- Launch Power
local launchRow = Instance.new("Frame")
launchRow.Size = UDim2.new(1, 0, 0, 22)
launchRow.Position = UDim2.new(0, 0, 0, 46)
launchRow.BackgroundTransparency = 1
launchRow.Parent = rightFrame

local launchLabel = Instance.new("TextLabel")
launchLabel.Size = UDim2.new(0, 60, 1, 0)
launchLabel.BackgroundTransparency = 1
launchLabel.TextColor3 = COLORS.textDark
launchLabel.Text = "Launch:"
launchLabel.Font = Enum.Font.Gotham
launchLabel.TextSize = 9
launchLabel.TextXAlignment = Enum.TextXAlignment.Left
launchLabel.Parent = launchRow

local launchInput = Instance.new("TextBox")
launchInput.Size = UDim2.new(0, 70, 1, 0)
launchInput.Position = UDim2.new(0, 65, 0, 0)
launchInput.BackgroundColor3 = COLORS.inputBg
launchInput.TextColor3 = COLORS.textDark
launchInput.Text = "999999"
launchInput.Font = Enum.Font.Gotham
launchInput.TextSize = 9
launchInput.ClearTextOnFocus = false
launchInput.Parent = launchRow

local launchCorner = Instance.new("UICorner")
launchCorner.CornerRadius = UDim.new(0, 4)
launchCorner.Parent = launchInput

local launchStroke = Instance.new("UIStroke")
launchStroke.Color = COLORS.border
launchStroke.Thickness = 1
launchStroke.Parent = launchInput

-- Velocity Threshold
local threshRow = Instance.new("Frame")
threshRow.Size = UDim2.new(1, 0, 0, 22)
threshRow.Position = UDim2.new(0, 0, 0, 70)
threshRow.BackgroundTransparency = 1
threshRow.Parent = rightFrame

local threshLabel = Instance.new("TextLabel")
threshLabel.Size = UDim2.new(0, 60, 1, 0)
threshLabel.BackgroundTransparency = 1
threshLabel.TextColor3 = COLORS.textDark
threshLabel.Text = "Threshold:"
threshLabel.Font = Enum.Font.Gotham
threshLabel.TextSize = 9
threshLabel.TextXAlignment = Enum.TextXAlignment.Left
threshLabel.Parent = threshRow

local threshInput = Instance.new("TextBox")
threshInput.Size = UDim2.new(0, 50, 1, 0)
threshInput.Position = UDim2.new(0, 65, 0, 0)
threshInput.BackgroundColor3 = COLORS.inputBg
threshInput.TextColor3 = COLORS.textDark
threshInput.Text = "5"
threshInput.Font = Enum.Font.Gotham
threshInput.TextSize = 9
threshInput.ClearTextOnFocus = false
threshInput.Parent = threshRow

local threshCorner = Instance.new("UICorner")
threshCorner.CornerRadius = UDim.new(0, 4)
threshCorner.Parent = threshInput

local threshStroke = Instance.new("UIStroke")
threshStroke.Color = COLORS.border
threshStroke.Thickness = 1
threshStroke.Parent = threshInput

local threshHint = Instance.new("TextLabel")
threshHint.Size = UDim2.new(0, 40, 1, 0)
threshHint.Position = UDim2.new(0, 120, 0, 0)
threshHint.BackgroundTransparency = 1
threshHint.TextColor3 = COLORS.textMuted
threshHint.Text = "studs"
threshHint.Font = Enum.Font.Gotham
threshHint.TextSize = 8
threshHint.TextXAlignment = Enum.TextXAlignment.Left
threshHint.Parent = threshRow

-- Info
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 60)
infoLabel.Position = UDim2.new(0, 0, 0, 100)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = COLORS.textMuted
infoLabel.Text = "AUTO SWITCH:\nMoving → Aura\nStill → Fling"
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 9
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = rightFrame

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

local hubDragging = false
local hubDragInput, hubDragStart, hubDragPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        hubDragging = true
        hubDragStart = input.Position
        hubDragPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                hubDragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        hubDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == hubDragInput and hubDragging then
        local delta = input.Position - hubDragStart
        mainFrame.Position = UDim2.new(hubDragPos.X.Scale, hubDragPos.X.Offset + delta.X, hubDragPos.Y.Scale, hubDragPos.Y.Offset + delta.Y)
    end
end)

-- ========== TOGGLE HUB ==========

hubButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        wait(0.1)
        if not dragging then
            hubButton.Visible = false
            mainFrame.Visible = true
        end
    end
end)

collapseButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

-- ========== PLAYER LIST ==========

local playerButtons = {}

local function updatePlayerList()
    for _, btn in pairs(playerButtons) do
        btn:Destroy()
    end
    playerButtons = {}
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 22)
            btn.BackgroundColor3 = targetPlayer == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn.TextColor3 = targetPlayer == plr and COLORS.textLight or COLORS.textDark
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 10
            btn.Parent = playerScroll
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                targetPlayer = plr
                statusLabel.Text = "Target: " .. plr.Name
                updatePlayerList()
            end)
            
            table.insert(playerButtons, btn)
        end
    end
    
    playerScroll.CanvasSize = UDim2.new(0, 0, 0, #playerButtons * 24)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerList()
end)

updatePlayerList()

-- ========== TOGGLES ==========

autoSwitchToggle.MouseButton1Click:Connect(function()
    autoSwitchEnabled = not autoSwitchEnabled
    
    if autoSwitchEnabled then
        autoSwitchToggle.Text = "AUTO SWITCH: ON"
        autoSwitchToggle.BackgroundColor3 = COLORS.buttonSuccess
    else
        autoSwitchToggle.Text = "AUTO SWITCH: OFF"
        autoSwitchToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

smartToggle.MouseButton1Click:Connect(function()
    smartMode = not smartMode
    
    if smartMode then
        smartToggle.Text = "SMART: ON"
        smartToggle.BackgroundColor3 = COLORS.buttonSuccess
    else
        smartToggle.Text = "SMART: OFF"
        smartToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

-- ========== HELPER FUNCTIONS ==========

local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart") or char and char:FindFirstChild("Torso") or char and char:FindFirstChild("UpperTorso")
end

local function getSword()
    local character = player.Character
    if not character then return nil end
    
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") then
            return item
        end
    end
    return nil
end

local function equipSword()
    local character = player.Character
    local backpack = player:FindFirstChild("Backpack")
    
    if not character or not backpack then return nil end
    
    local currentTool = getSword()
    if currentTool then return currentTool end
    
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            character.Humanoid:EquipTool(item)
            wait(0.1)
            return item
        end
    end
    
    return nil
end

local function hasSpawnProtection(targetPlr)
    if not targetPlr or not targetPlr.Character then return false end
    local forceField = targetPlr.Character:FindFirstChild("ForceField")
    return forceField ~= nil
end

local function getTargetVelocity()
    if not targetPlayer or not targetPlayer.Character then return 0 end
    local root = getRoot(targetPlayer.Character)
    if not root then return 0 end
    return root.Velocity.Magnitude
end

-- ========== FLING FUNCTIONS ==========

local function stopFling()
    if bodyAngularVel then
        bodyAngularVel:Destroy()
        bodyAngularVel = nil
    end
    
    if bodyVel then
        bodyVel:Destroy()
        bodyVel = nil
    end
    
    local myChar = player.Character
    if myChar then
        local myRoot = getRoot(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        
        if myRoot then
            myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
        
        if myHumanoid then
            myHumanoid.PlatformStand = false
        end
    end
end

local function startFlingMode()
    stopFling()
    
    local myChar = player.Character
    if not myChar then return end
    
    local myRoot = getRoot(myChar)
    local myHumanoid = myChar:FindFirstChild("Humanoid")
    
    if not myRoot then return end
    
    local spinPower = tonumber(spinInput.Text) or 999999
    local launchPower = tonumber(launchInput.Text) or 999999
    
    -- Create BodyAngularVelocity
    if bodyAngularVel then bodyAngularVel:Destroy() end
    bodyAngularVel = Instance.new("BodyAngularVelocity")
    bodyAngularVel.Name = "FlingSpin"
    bodyAngularVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyAngularVel.AngularVelocity = Vector3.new(spinPower, spinPower, spinPower)
    bodyAngularVel.P = math.huge
    bodyAngularVel.Parent = myRoot
    
    -- Create BodyVelocity
    if bodyVel then bodyVel:Destroy() end
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Name = "FlingLaunch"
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Velocity = Vector3.new(0, launchPower, 0)
    bodyVel.P = math.huge
    bodyVel.Parent = myRoot
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

-- ========== AURA FUNCTIONS ==========

local attackAngle = 0

local function teleportToTarget()
    if not targetPlayer then return end
    
    local myChar = player.Character
    local myHum = myChar and getRoot(myChar)
    
    local targetChar = targetPlayer.Character
    local targetHum = targetChar and getRoot(targetChar)
    local targetHumanoid = targetChar and targetChar:FindFirstChild("Humanoid")
    
    if not myHum or not targetHum or not targetHumanoid then return end
    if targetHumanoid.Health <= 0 then return end
    
    attackAngle = attackAngle + 60
    if attackAngle >= 360 then attackAngle = 0 end
    
    local angleRad = math.rad(attackAngle)
    local offsetX = math.cos(angleRad) * teleportDistance
    local offsetZ = math.sin(angleRad) * teleportDistance
    
    myHum.CFrame = targetHum.CFrame * CFrame.new(offsetX, 0, offsetZ)
    
    if myChar.HumanoidRootPart then
        myChar.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end
end

local function swingSword()
    local sword = getSword()
    if sword then
        sword:Activate()
    end
end

-- ========== MAIN LOOP ==========

local flingLoop = nil
local auraLoop = nil
local swingLoop = nil

local function stopAll()
    stopFling()
    if flingLoop then flingLoop:Disconnect(); flingLoop = nil end
    if auraLoop then auraLoop:Disconnect(); auraLoop = nil end
    if swingLoop then swingLoop:Disconnect(); swingLoop = nil end
end

local function startMainLoop()
    -- Read settings
    teleportDistance = tonumber(distInput.Text) or 2
    teleportDelay = tonumber(tpInput.Text) or 0.1
    swingDelay = tonumber(swingInput.Text) or 0.01
    spawnWaitTime = tonumber(spawnInput.Text) or 5
    velocityThreshold = tonumber(threshInput.Text) or 5
    
    equipSword()
    
    -- Swing loop (always active when enabled)
    swingLoop = RunService.Heartbeat:Connect(function()
        if not killEnabled then return end
        
        if targetPlayer and targetPlayer.Character then
            local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
            if targetHumanoid and targetHumanoid.Health > 0 then
                if smartMode and hasSpawnProtection(targetPlayer) then
                    -- Don't swing during spawn protection
                else
                    swingSword()
                end
            end
        end
    end)
    
    -- Main detection & switch loop
    flingLoop = RunService.Heartbeat:Connect(function()
        if not killEnabled then return end
        if not targetPlayer or not targetPlayer.Character then return end
        
        local targetRoot = getRoot(targetPlayer.Character)
        local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        
        if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then return end
        
        -- Check spawn protection
        if smartMode and hasSpawnProtection(targetPlayer) then
            modeDisplay.Text = "MODE: WAITING"
            modeDisplay.BackgroundColor3 = COLORS.buttonWarning
            statusLabel.Text = "Waiting for spawn protection..."
            return
        end
        
        -- Get target velocity
        local targetVel = targetRoot.Velocity.Magnitude
        
        -- Read threshold
        velocityThreshold = tonumber(threshInput.Text) or 5
        
        -- Auto-switch based on movement
        if autoSwitchEnabled then
            if targetVel > velocityThreshold then
                -- Target is MOVING → AURA MODE
                if currentMode ~= "AURA" then
                    currentMode = "AURA"
                    modeDisplay.Text = "MODE: AURA ⚔️"
                    modeDisplay.BackgroundColor3 = COLORS.buttonSuccess
                    statusLabel.Text = "Target moving → Aura mode"
                    stopFling()
                end
                
                -- Aura: teleport around target
                teleportToTarget()
                
            else
                -- Target is STILL → FLING MODE
                if currentMode ~= "FLING" then
                    currentMode = "FLING"
                    modeDisplay.Text = "MODE: FLING 🌀"
                    modeDisplay.BackgroundColor3 = COLORS.buttonPurple
                    statusLabel.Text = "Target still → Fling mode"
                    startFlingMode()
                end
                
                -- Fling: teleport inside target
                local myChar = player.Character
                if myChar then
                    local myRoot = getRoot(myChar)
                    if myRoot then
                        myRoot.CFrame = targetRoot.CFrame
                        
                        -- Re-apply body movers if needed
                        if not myRoot:FindFirstChild("FlingSpin") then
                            local spinPower = tonumber(spinInput.Text) or 999999
                            bodyAngularVel = Instance.new("BodyAngularVelocity")
                            bodyAngularVel.Name = "FlingSpin"
                            bodyAngularVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                            bodyAngularVel.AngularVelocity = Vector3.new(spinPower, spinPower, spinPower)
                            bodyAngularVel.P = math.huge
                            bodyAngularVel.Parent = myRoot
                        end
                        
                        if not myRoot:FindFirstChild("FlingLaunch") then
                            local launchPower = tonumber(launchInput.Text) or 999999
                            bodyVel = Instance.new("BodyVelocity")
                            bodyVel.Name = "FlingLaunch"
                            bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bodyVel.Velocity = Vector3.new(0, launchPower, 0)
                            bodyVel.P = math.huge
                            bodyVel.Parent = myRoot
                        end
                    end
                end
            end
        else
            -- Auto-switch OFF: Always use FLING
            if currentMode ~= "FLING" then
                currentMode = "FLING"
                modeDisplay.Text = "MODE: FLING 🌀"
                modeDisplay.BackgroundColor3 = COLORS.buttonPurple
                startFlingMode()
            end
            
            local myChar = player.Character
            if myChar then
                local myRoot = getRoot(myChar)
                if myRoot then
                    myRoot.CFrame = targetRoot.CFrame
                end
            end
        end
    end)
    
    -- Kill detection
    local lastHealth = 100
    spawn(function()
        while killEnabled do
            if targetPlayer and targetPlayer.Character then
                local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                if targetHumanoid then
                    if targetHumanoid.Health <= 0 and lastHealth > 0 then
                        killCount = killCount + 1
                        killCounter.Text = "Kills: " .. killCount
                        statusLabel.Text = "Killed " .. targetPlayer.Name .. "!"
                    end
                    lastHealth = targetHumanoid.Health
                end
            end
            wait(0.1)
        end
    end)
    
    -- Re-equip sword loop
    spawn(function()
        while killEnabled do
            local sword = getSword()
            if not sword then
                equipSword()
            end
            wait(0.5)
        end
    end)
end

-- ========== TOGGLE BUTTON ==========

toggleButton.MouseButton1Click:Connect(function()
    killEnabled = not killEnabled
    
    if killEnabled then
        toggleButton.Text = "AUTO KILL: ON"
        toggleButton.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel.Text = targetPlayer and ("Hunting: " .. targetPlayer.Name) or "No target selected"
        
        startMainLoop()
        
    else
        toggleButton.Text = "AUTO KILL: OFF"
        toggleButton.BackgroundColor3 = COLORS.buttonDanger
        statusLabel.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
        
        stopAll()
        currentMode = "NONE"
        modeDisplay.Text = "MODE: NONE"
        modeDisplay.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    end
end)

-- ========== RESPAWN HANDLER ==========

player.CharacterAdded:Connect(function(char)
    wait(0.5)
    
    if killEnabled then
        flingCount = flingCount + 1
        flingCounter.Text = "Flings: " .. flingCount
        startFlingMode()
    end
end)

player.CharacterRemoving:Connect(function()
    stopAll()
end)

-- ========== KEYBIND ==========

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

print("✅ Hybrid Kill Script Loaded")
print("   Auto-switches between AURA and FLING based on target movement")
