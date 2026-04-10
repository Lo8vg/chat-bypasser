-- Combined Hub: 5 Tabs (Fling + TP Kill + Ultimate + Combo + Anti-AFK)
-- Fixed logic integration for Combo Destroyer

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Colors
local COLORS = {
    background = Color3.fromRGB(245, 245, 245),
    header = Color3.fromRGB(255, 255, 255),
    buttonPrimary = Color3.fromRGB(0, 120, 215),
    buttonDanger = Color3.fromRGB(220, 53, 69),
    buttonSuccess = Color3.fromRGB(40, 167, 69),
    buttonWarning = Color3.fromRGB(255, 193, 7),
    textDark = Color3.fromRGB(33, 37, 41),
    textLight = Color3.fromRGB(255, 255, 255),
    textMuted = Color3.fromRGB(134, 142, 150),
    inputBg = Color3.fromRGB(255, 255, 255),
    border = Color3.fromRGB(222, 226, 230),
    cardBg = Color3.fromRGB(255, 255, 255),
    tabActive = Color3.fromRGB(0, 120, 215),
    tabInactive = Color3.fromRGB(230, 230, 230)
}

-- ========== SCREEN GUI ==========

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombinedHub_5Tabs"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========== HUB BUTTON ==========

local hubButton = Instance.new("TextButton")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 55, 0, 55)
hubButton.Position = UDim2.new(0, 15, 0.5, -27)
hubButton.BackgroundColor3 = COLORS.cardBg
hubButton.Text = "⚔️"
hubButton.Font = Enum.Font.GothamBold
hubButton.TextSize = 24
hubButton.TextColor3 = COLORS.textDark
hubButton.BorderSizePixel = 0
hubButton.Visible = true
hubButton.Parent = screenGui

local hubButtonCorner = Instance.new("UICorner")
hubButtonCorner.CornerRadius = UDim.new(0, 12)
hubButtonCorner.Parent = hubButton

local hubButtonShadow = Instance.new("UIStroke")
hubButtonShadow.Color = COLORS.border
hubButtonShadow.Thickness = 1
hubButtonShadow.Parent = hubButton

-- ========== MAIN FRAME ==========

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 480, 0, 350)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -175)
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
titleBar.Size = UDim2.new(1, 0, 0, 40)
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
titleLabel.Size = UDim2.new(1, -90, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = COLORS.textDark
titleLabel.Text = "⚔️ Ultimate 5-Tab Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 32, 0, 26)
collapseButton.Position = UDim2.new(1, -40, 0.5, -13)
collapseButton.BackgroundColor3 = COLORS.buttonDanger
collapseButton.TextColor3 = COLORS.textLight
collapseButton.Text = "✕"
collapseButton.Font = Enum.Font.GothamBold
collapseButton.TextSize = 12
collapseButton.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseButton

-- ========== TAB BUTTONS (5 TABS) ==========

local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Size = UDim2.new(1, -20, 0, 32)
tabButtonsFrame.Position = UDim2.new(0, 10, 0, 44)
tabButtonsFrame.BackgroundTransparency = 1
tabButtonsFrame.Parent = mainFrame

local tabNames = {"Original", "TP Kill", "Ultimate", "Combo", "Anti-AFK"}
local tabButtons = {}
local tabContents = {}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/5, -4, 1, 0)
    btn.Position = UDim2.new((i-1)/5 + (i-1)*0.004, 2, 0, 0)
    btn.BackgroundColor3 = COLORS.tabInactive
    btn.TextColor3 = COLORS.textDark
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = tabButtonsFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    tabButtons[i] = btn
end

-- Set Tab 1 as active initially
tabButtons[1].BackgroundColor3 = COLORS.tabActive
tabButtons[1].TextColor3 = COLORS.textLight

-- ========== TAB CONTENT FRAMES ==========

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -82)
contentContainer.Position = UDim2.new(0, 10, 0, 80)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- Initialize 5 content frames
for i = 1, 5 do
    local frame = Instance.new("Frame")
    frame.Name = "Tab" .. i .. "Content"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = (i == 1) -- Only Tab 1 visible
    frame.Parent = contentContainer
    tabContents[i] = frame
end

-- ========== TAB 1: ORIGINAL FLING ==========

local leftFrame1 = Instance.new("Frame")
leftFrame1.Size = UDim2.new(0.5, -8, 1, 0)
leftFrame1.Position = UDim2.new(0, 0, 0, 0)
leftFrame1.BackgroundTransparency = 1
leftFrame1.Parent = tabContents[1]

-- Toggle Button
local toggleButton1 = Instance.new("TextButton")
toggleButton1.Size = UDim2.new(1, 0, 0, 32)
toggleButton1.Position = UDim2.new(0, 0, 0, 0)
toggleButton1.BackgroundColor3 = COLORS.buttonDanger
toggleButton1.TextColor3 = COLORS.textLight
toggleButton1.Text = "FLING: OFF"
toggleButton1.Font = Enum.Font.GothamBold
toggleButton1.TextSize = 13
toggleButton1.Parent = leftFrame1

local toggleCorner1 = Instance.new("UICorner")
toggleCorner1.CornerRadius = UDim.new(0, 6)
toggleCorner1.Parent = toggleButton1

-- Fling Counter
local flingCounter1 = Instance.new("TextLabel")
flingCounter1.Size = UDim2.new(1, 0, 0, 16)
flingCounter1.Position = UDim2.new(0, 0, 0, 36)
flingCounter1.BackgroundTransparency = 1
flingCounter1.TextColor3 = COLORS.buttonSuccess
flingCounter1.Text = "Flings: 0"
flingCounter1.Font = Enum.Font.GothamBold
flingCounter1.TextSize = 11
flingCounter1.Parent = leftFrame1

-- Target Label
local targetLabel1 = Instance.new("TextLabel")
targetLabel1.Size = UDim2.new(1, 0, 0, 14)
targetLabel1.Position = UDim2.new(0, 0, 0, 54)
targetLabel1.BackgroundTransparency = 1
targetLabel1.TextColor3 = COLORS.textDark
targetLabel1.Text = "Select Target:"
targetLabel1.Font = Enum.Font.GothamBold
targetLabel1.TextSize = 10
targetLabel1.TextXAlignment = Enum.TextXAlignment.Left
targetLabel1.Parent = leftFrame1

-- Player List
local playerScroll1 = Instance.new("ScrollingFrame")
playerScroll1.Size = UDim2.new(1, 0, 0, 100)
playerScroll1.Position = UDim2.new(0, 0, 0, 70)
playerScroll1.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerScroll1.ScrollBarThickness = 4
playerScroll1.Parent = leftFrame1

local playerScrollCorner1 = Instance.new("UICorner")
playerScrollCorner1.CornerRadius = UDim.new(0, 6)
playerScrollCorner1.Parent = playerScroll1

local playerLayout1 = Instance.new("UIListLayout")
playerLayout1.Padding = UDim.new(0, 2)
playerLayout1.Parent = playerScroll1

-- Status Label
local statusLabel1 = Instance.new("TextLabel")
statusLabel1.Size = UDim2.new(1, 0, 0, 16)
statusLabel1.Position = UDim2.new(0, 0, 0, 172)
statusLabel1.BackgroundTransparency = 1
statusLabel1.TextColor3 = COLORS.textMuted
statusLabel1.Text = "No target selected"
statusLabel1.Font = Enum.Font.Gotham
statusLabel1.TextSize = 9
statusLabel1.TextWrapped = true
statusLabel1.Parent = leftFrame1

-- Right Frame (Fling)
local rightFrame1 = Instance.new("Frame")
rightFrame1.Size = UDim2.new(0.5, -8, 1, 0)
rightFrame1.Position = UDim2.new(0.5, 8, 0, 0)
rightFrame1.BackgroundTransparency = 1
rightFrame1.Parent = tabContents[1]

-- Spin Power
local spinLabel = Instance.new("TextLabel")
spinLabel.Size = UDim2.new(1, 0, 0, 14)
spinLabel.Position = UDim2.new(0, 0, 0, 0)
spinLabel.BackgroundTransparency = 1
spinLabel.TextColor3 = COLORS.textDark
spinLabel.Text = "Spin Power:"
spinLabel.Font = Enum.Font.GothamBold
spinLabel.TextSize = 10
spinLabel.TextXAlignment = Enum.TextXAlignment.Left
spinLabel.Parent = rightFrame1

local spinInput = Instance.new("TextBox")
spinInput.Size = UDim2.new(1, 0, 0, 24)
spinInput.Position = UDim2.new(0, 0, 0, 16)
spinInput.BackgroundColor3 = COLORS.inputBg
spinInput.TextColor3 = COLORS.textDark
spinInput.Text = "999999"
spinInput.Font = Enum.Font.Gotham
spinInput.TextSize = 10
spinInput.ClearTextOnFocus = false
spinInput.Parent = rightFrame1

local spinCorner = Instance.new("UICorner")
spinCorner.CornerRadius = UDim.new(0, 5)
spinCorner.Parent = spinInput

local spinStroke = Instance.new("UIStroke")
spinStroke.Color = COLORS.border
spinStroke.Thickness = 1
spinStroke.Parent = spinInput

-- Launch Power
local launchLabel = Instance.new("TextLabel")
launchLabel.Size = UDim2.new(1, 0, 0, 14)
launchLabel.Position = UDim2.new(0, 0, 0, 44)
launchLabel.BackgroundTransparency = 1
launchLabel.TextColor3 = COLORS.textDark
launchLabel.Text = "Launch Power:"
launchLabel.Font = Enum.Font.GothamBold
launchLabel.TextSize = 10
launchLabel.TextXAlignment = Enum.TextXAlignment.Left
launchLabel.Parent = rightFrame1

local launchInput = Instance.new("TextBox")
launchInput.Size = UDim2.new(1, 0, 0, 24)
launchInput.Position = UDim2.new(0, 0, 0, 60)
launchInput.BackgroundColor3 = COLORS.inputBg
launchInput.TextColor3 = COLORS.textDark
launchInput.Text = "999999"
launchInput.Font = Enum.Font.Gotham
launchInput.TextSize = 10
launchInput.ClearTextOnFocus = false
launchInput.Parent = rightFrame1

local launchCorner = Instance.new("UICorner")
launchCorner.CornerRadius = UDim.new(0, 5)
launchCorner.Parent = launchInput

local launchStroke = Instance.new("UIStroke")
launchStroke.Color = COLORS.border
launchStroke.Thickness = 1
launchStroke.Parent = launchInput

-- Info
local infoLabel1 = Instance.new("TextLabel")
infoLabel1.Size = UDim2.new(1, 0, 0, 70)
infoLabel1.Position = UDim2.new(0, 0, 0, 90)
infoLabel1.BackgroundTransparency = 1
infoLabel1.TextColor3 = COLORS.textMuted
infoLabel1.Text = "Uses BodyAngularVelocity +\nBodyVelocity (real physics).\nYou will SPIN visibly.\nAnti-cheat kills you = target flung."
infoLabel1.Font = Enum.Font.Gotham
infoLabel1.TextSize = 9
infoLabel1.TextWrapped = true
infoLabel1.TextXAlignment = Enum.TextXAlignment.Left
infoLabel1.Parent = rightFrame1

-- ========== TAB 2: TP KILL ==========

local toggleButton2 = Instance.new("TextButton")
toggleButton2.Size = UDim2.new(1, 0, 0, 36)
toggleButton2.Position = UDim2.new(0, 0, 0, 0)
toggleButton2.BackgroundColor3 = COLORS.buttonDanger
toggleButton2.TextColor3 = COLORS.textLight
toggleButton2.Text = "KILL AURA: OFF"
toggleButton2.Font = Enum.Font.GothamBold
toggleButton2.TextSize = 14
toggleButton2.Parent = tabContents[2]

local toggleCorner2 = Instance.new("UICorner")
toggleCorner2.CornerRadius = UDim.new(0, 6)
toggleCorner2.Parent = toggleButton2

-- Protection Status
local protectionLabel = Instance.new("TextLabel")
protectionLabel.Size = UDim2.new(1, 0, 0, 16)
protectionLabel.Position = UDim2.new(0, 0, 0, 42)
protectionLabel.BackgroundTransparency = 1
protectionLabel.TextColor3 = COLORS.textMuted
protectionLabel.Text = "Protection: Waiting..."
protectionLabel.Font = Enum.Font.Gotham
protectionLabel.TextSize = 10
protectionLabel.Parent = tabContents[2]

-- Target Label
local targetLabel2 = Instance.new("TextLabel")
targetLabel2.Size = UDim2.new(1, 0, 0, 14)
targetLabel2.Position = UDim2.new(0, 0, 0, 60)
targetLabel2.BackgroundTransparency = 1
targetLabel2.TextColor3 = COLORS.textDark
targetLabel2.Text = "Select Target:"
targetLabel2.Font = Enum.Font.GothamBold
targetLabel2.TextSize = 10
targetLabel2.TextXAlignment = Enum.TextXAlignment.Left
targetLabel2.Parent = tabContents[2]

-- Player List
local playerScroll2 = Instance.new("ScrollingFrame")
playerScroll2.Size = UDim2.new(1, 0, 0, 80)
playerScroll2.Position = UDim2.new(0, 0, 0, 76)
playerScroll2.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerScroll2.ScrollBarThickness = 4
playerScroll2.Parent = tabContents[2]

local playerScrollCorner2 = Instance.new("UICorner")
playerScrollCorner2.CornerRadius = UDim.new(0, 6)
playerScrollCorner2.Parent = playerScroll2

local playerLayout2 = Instance.new("UIListLayout")
playerLayout2.Padding = UDim.new(0, 2)
playerLayout2.Parent = playerScroll2

-- Status Label
local statusLabel2 = Instance.new("TextLabel")
statusLabel2.Size = UDim2.new(1, 0, 0, 16)
statusLabel2.Position = UDim2.new(0, 0, 0, 160)
statusLabel2.BackgroundTransparency = 1
statusLabel2.TextColor3 = COLORS.textMuted
statusLabel2.Text = "No target selected"
statusLabel2.Font = Enum.Font.Gotham
statusLabel2.TextSize = 9
statusLabel2.TextWrapped = true
statusLabel2.Parent = tabContents[2]

-- Delay Input
local delayRow = Instance.new("Frame")
delayRow.Size = UDim2.new(1, 0, 0, 24)
delayRow.Position = UDim2.new(0, 0, 0, 180)
delayRow.BackgroundTransparency = 1
delayRow.Parent = tabContents[2]

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 80, 1, 0)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = COLORS.textDark
delayLabel.Text = "Attack Delay:"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 10
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = delayRow

local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0, 50, 1, 0)
delayInput.Position = UDim2.new(0, 85, 0, 0)
delayInput.BackgroundColor3 = COLORS.inputBg
delayInput.TextColor3 = COLORS.textDark
delayInput.Text = "0.05"
delayInput.Font = Enum.Font.Gotham
delayInput.TextSize = 10
delayInput.ClearTextOnFocus = false
delayInput.Parent = delayRow

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 5)
delayCorner.Parent = delayInput

local delayStroke = Instance.new("UIStroke")
delayStroke.Color = COLORS.border
delayStroke.Thickness = 1
delayStroke.Parent = delayInput

local delayHint = Instance.new("TextLabel")
delayHint.Size = UDim2.new(0, 50, 1, 0)
delayHint.Position = UDim2.new(0, 140, 0, 0)
delayHint.BackgroundTransparency = 1
delayHint.TextColor3 = COLORS.textMuted
delayHint.Text = "seconds"
delayHint.Font = Enum.Font.Gotham
delayHint.TextSize = 9
delayHint.TextXAlignment = Enum.TextXAlignment.Left
delayHint.Parent = delayRow

-- Swings Input
local swingsRow = Instance.new("Frame")
swingsRow.Size = UDim2.new(1, 0, 0, 24)
swingsRow.Position = UDim2.new(0, 0, 0, 208)
swingsRow.BackgroundTransparency = 1
swingsRow.Parent = tabContents[2]

local swingsLabel = Instance.new("TextLabel")
swingsLabel.Size = UDim2.new(0, 80, 1, 0)
swingsLabel.BackgroundTransparency = 1
swingsLabel.TextColor3 = COLORS.textDark
swingsLabel.Text = "Swings/Hit:"
swingsLabel.Font = Enum.Font.Gotham
swingsLabel.TextSize = 10
swingsLabel.TextXAlignment = Enum.TextXAlignment.Left
swingsLabel.Parent = swingsRow

local swingsInput = Instance.new("TextBox")
swingsInput.Size = UDim2.new(0, 50, 1, 0)
swingsInput.Position = UDim2.new(0, 85, 0, 0)
swingsInput.BackgroundColor3 = COLORS.inputBg
swingsInput.TextColor3 = COLORS.textDark
swingsInput.Text = "3"
swingsInput.Font = Enum.Font.Gotham
swingsInput.TextSize = 10
swingsInput.ClearTextOnFocus = false
swingsInput.Parent = swingsRow

local swingsCorner = Instance.new("UICorner")
swingsCorner.CornerRadius = UDim.new(0, 5)
swingsCorner.Parent = swingsInput

local swingsStroke = Instance.new("UIStroke")
swingsStroke.Color = COLORS.border
swingsStroke.Thickness = 1
swingsStroke.Parent = swingsInput

-- Check Rate Input
local checkRow = Instance.new("Frame")
checkRow.Size = UDim2.new(1, 0, 0, 24)
checkRow.Position = UDim2.new(0, 0, 0, 236)
checkRow.BackgroundTransparency = 1
checkRow.Parent = tabContents[2]

local checkLabel = Instance.new("TextLabel")
checkLabel.Size = UDim2.new(0, 80, 1, 0)
checkLabel.BackgroundTransparency = 1
checkLabel.TextColor3 = COLORS.textDark
checkLabel.Text = "Check Rate:"
checkLabel.Font = Enum.Font.Gotham
checkLabel.TextSize = 10
checkLabel.TextXAlignment = Enum.TextXAlignment.Left
checkLabel.Parent = checkRow

local checkInput = Instance.new("TextBox")
checkInput.Size = UDim2.new(0, 50, 1, 0)
checkInput.Position = UDim2.new(0, 85, 0, 0)
checkInput.BackgroundColor3 = COLORS.inputBg
checkInput.TextColor3 = COLORS.textDark
checkInput.Text = "0.1"
checkInput.Font = Enum.Font.Gotham
checkInput.TextSize = 10
checkInput.ClearTextOnFocus = false
checkInput.Parent = checkRow

local checkCorner = Instance.new("UICorner")
checkCorner.CornerRadius = UDim.new(0, 5)
checkCorner.Parent = checkInput

local checkStroke = Instance.new("UIStroke")
checkStroke.Color = COLORS.border
checkStroke.Thickness = 1
checkStroke.Parent = checkInput

-- ========== TAB 3: ULTIMATE COLLISION FLING ==========

local leftFrame3 = Instance.new("Frame")
leftFrame3.Size = UDim2.new(0.5, -8, 1, 0)
leftFrame3.Position = UDim2.new(0, 0, 0, 0)
leftFrame3.BackgroundTransparency = 1
leftFrame3.Parent = tabContents[3]

-- Toggle Button
local toggleButton3 = Instance.new("TextButton")
toggleButton3.Size = UDim2.new(1, 0, 0, 32)
toggleButton3.Position = UDim2.new(0, 0, 0, 0)
toggleButton3.BackgroundColor3 = COLORS.buttonDanger
toggleButton3.TextColor3 = COLORS.textLight
toggleButton3.Text = "FLING: OFF"
toggleButton3.Font = Enum.Font.GothamBold
toggleButton3.TextSize = 13
toggleButton3.Parent = leftFrame3

local toggleCorner3 = Instance.new("UICorner")
toggleCorner3.CornerRadius = UDim.new(0, 6)
toggleCorner3.Parent = toggleButton3

-- Fling Counter 3
local flingCounter3 = Instance.new("TextLabel")
flingCounter3.Size = UDim2.new(1, 0, 0, 14)
flingCounter3.Position = UDim2.new(0, 0, 0, 36)
flingCounter3.BackgroundTransparency = 1
flingCounter3.TextColor3 = COLORS.buttonSuccess
flingCounter3.Text = "Flings: 0"
flingCounter3.Font = Enum.Font.GothamBold
flingCounter3.TextSize = 10
flingCounter3.Parent = leftFrame3

-- Target Label 3
local targetLabel3 = Instance.new("TextLabel")
targetLabel3.Size = UDim2.new(1, 0, 0, 14)
targetLabel3.Position = UDim2.new(0, 0, 0, 52)
targetLabel3.BackgroundTransparency = 1
targetLabel3.TextColor3 = COLORS.textDark
targetLabel3.Text = "Select Target:"
targetLabel3.Font = Enum.Font.GothamBold
targetLabel3.TextSize = 10
targetLabel3.TextXAlignment = Enum.TextXAlignment.Left
targetLabel3.Parent = leftFrame3

-- Player List 3
local playerScroll3 = Instance.new("ScrollingFrame")
playerScroll3.Size = UDim2.new(1, 0, 0, 70)
playerScroll3.Position = UDim2.new(0, 0, 0, 68)
playerScroll3.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerScroll3.ScrollBarThickness = 4
playerScroll3.Parent = leftFrame3

local playerScrollCorner3 = Instance.new("UICorner")
playerScrollCorner3.CornerRadius = UDim.new(0, 6)
playerScrollCorner3.Parent = playerScroll3

local playerLayout3 = Instance.new("UIListLayout")
playerLayout3.Padding = UDim.new(0, 2)
playerLayout3.Parent = playerScroll3

-- Status Label 3
local statusLabel3 = Instance.new("TextLabel")
statusLabel3.Size = UDim2.new(1, 0, 0, 14)
statusLabel3.Position = UDim2.new(0, 0, 0, 142)
statusLabel3.BackgroundTransparency = 1
statusLabel3.TextColor3 = COLORS.textMuted
statusLabel3.Text = "No target selected"
statusLabel3.Font = Enum.Font.Gotham
statusLabel3.TextSize = 9
statusLabel3.TextWrapped = true
statusLabel3.Parent = leftFrame3

-- Mode Buttons
local modeLabel3 = Instance.new("TextLabel")
modeLabel3.Size = UDim2.new(1, 0, 0, 14)
modeLabel3.Position = UDim2.new(0, 0, 0, 158)
modeLabel3.BackgroundTransparency = 1
modeLabel3.TextColor3 = COLORS.textDark
modeLabel3.Text = "Fling Mode:"
modeLabel3.Font = Enum.Font.GothamBold
modeLabel3.TextSize = 9
modeLabel3.TextXAlignment = Enum.TextXAlignment.Left
modeLabel3.Parent = leftFrame3

local devastateModeBtn = Instance.new("TextButton")
devastateModeBtn.Size = UDim2.new(1, 0, 0, 20)
devastateModeBtn.Position = UDim2.new(0, 0, 0, 174)
devastateModeBtn.BackgroundColor3 = COLORS.buttonSuccess
devastateModeBtn.TextColor3 = COLORS.textLight
devastateModeBtn.Text = "✓ DEVASTATE"
devastateModeBtn.Font = Enum.Font.GothamBold
devastateModeBtn.TextSize = 9
devastateModeBtn.Parent = leftFrame3

local devastateCorner3 = Instance.new("UICorner")
devastateCorner3.CornerRadius = UDim.new(0, 4)
devastateCorner3.Parent = devastateModeBtn

local orbitalModeBtn = Instance.new("TextButton")
orbitalModeBtn.Size = UDim2.new(1, 0, 0, 20)
orbitalModeBtn.Position = UDim2.new(0, 0, 0, 196)
orbitalModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
orbitalModeBtn.TextColor3 = COLORS.textDark
orbitalModeBtn.Text = "Orbital"
orbitalModeBtn.Font = Enum.Font.Gotham
orbitalModeBtn.TextSize = 9
orbitalModeBtn.Parent = leftFrame3

local orbitalCorner3 = Instance.new("UICorner")
orbitalCorner3.CornerRadius = UDim.new(0, 4)
orbitalCorner3.Parent = orbitalModeBtn

local chaosModeBtn = Instance.new("TextButton")
chaosModeBtn.Size = UDim2.new(1, 0, 0, 20)
chaosModeBtn.Position = UDim2.new(0, 0, 0, 218)
chaosModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
chaosModeBtn.TextColor3 = COLORS.textDark
chaosModeBtn.Text = "Chaos"
chaosModeBtn.Font = Enum.Font.Gotham
chaosModeBtn.TextSize = 9
chaosModeBtn.Parent = leftFrame3

local chaosCorner3 = Instance.new("UICorner")
chaosCorner3.CornerRadius = UDim.new(0, 4)
chaosCorner3.Parent = chaosModeBtn

-- Right Frame
local rightFrame3 = Instance.new("Frame")
rightFrame3.Size = UDim2.new(0.5, -8, 1, 0)
rightFrame3.Position = UDim2.new(0.5, 8, 0, 0)
rightFrame3.BackgroundTransparency = 1
rightFrame3.Parent = tabContents[3]

-- Velocity Power
local velocityLabel3 = Instance.new("TextLabel")
velocityLabel3.Size = UDim2.new(1, 0, 0, 14)
velocityLabel3.Position = UDim2.new(0, 0, 0, 0)
velocityLabel3.BackgroundTransparency = 1
velocityLabel3.TextColor3 = COLORS.textDark
velocityLabel3.Text = "Velocity Power:"
velocityLabel3.Font = Enum.Font.GothamBold
velocityLabel3.TextSize = 9
velocityLabel3.TextXAlignment = Enum.TextXAlignment.Left
velocityLabel3.Parent = rightFrame3

local velocityInput3 = Instance.new("TextBox")
velocityInput3.Size = UDim2.new(1, 0, 0, 20)
velocityInput3.Position = UDim2.new(0, 0, 0, 14)
velocityInput3.BackgroundColor3 = COLORS.inputBg
velocityInput3.TextColor3 = COLORS.textDark
velocityInput3.Text = "999999"
velocityInput3.Font = Enum.Font.Gotham
velocityInput3.TextSize = 9
velocityInput3.ClearTextOnFocus = false
velocityInput3.Parent = rightFrame3

local velocityCorner3 = Instance.new("UICorner")
velocityCorner3.CornerRadius = UDim.new(0, 4)
velocityCorner3.Parent = velocityInput3

local velocityStroke3 = Instance.new("UIStroke")
velocityStroke3.Color = COLORS.border
velocityStroke3.Thickness = 1
velocityStroke3.Parent = velocityInput3

-- Angular Power
local angularLabel3 = Instance.new("TextLabel")
angularLabel3.Size = UDim2.new(1, 0, 0, 14)
angularLabel3.Position = UDim2.new(0, 0, 0, 36)
angularLabel3.BackgroundTransparency = 1
angularLabel3.TextColor3 = COLORS.textDark
angularLabel3.Text = "Angular Power:"
angularLabel3.Font = Enum.Font.GothamBold
angularLabel3.TextSize = 9
angularLabel3.TextXAlignment = Enum.TextXAlignment.Left
angularLabel3.Parent = rightFrame3

local angularInput3 = Instance.new("TextBox")
angularInput3.Size = UDim2.new(1, 0, 0, 20)
angularInput3.Position = UDim2.new(0, 0, 0, 50)
angularInput3.BackgroundColor3 = COLORS.inputBg
angularInput3.TextColor3 = COLORS.textDark
angularInput3.Text = "999999"
angularInput3.Font = Enum.Font.Gotham
angularInput3.TextSize = 9
angularInput3.ClearTextOnFocus = false
angularInput3.Parent = rightFrame3

local angularCorner3 = Instance.new("UICorner")
angularCorner3.CornerRadius = UDim.new(0, 4)
angularCorner3.Parent = angularInput3

local angularStroke3 = Instance.new("UIStroke")
angularStroke3.Color = COLORS.border
angularStroke3.Thickness = 1
angularStroke3.Parent = angularInput3

-- Teleport Speed
local teleportLabel3 = Instance.new("TextLabel")
teleportLabel3.Size = UDim2.new(1, 0, 0, 14)
teleportLabel3.Position = UDim2.new(0, 0, 0, 72)
teleportLabel3.BackgroundTransparency = 1
teleportLabel3.TextColor3 = COLORS.textDark
teleportLabel3.Text = "Teleport Speed:"
teleportLabel3.Font = Enum.Font.GothamBold
teleportLabel3.TextSize = 9
teleportLabel3.TextXAlignment = Enum.TextXAlignment.Left
teleportLabel3.Parent = rightFrame3

local teleportInput3 = Instance.new("TextBox")
teleportInput3.Size = UDim2.new(1, 0, 0, 20)
teleportInput3.Position = UDim2.new(0, 0, 0, 86)
teleportInput3.BackgroundColor3 = COLORS.inputBg
teleportInput3.TextColor3 = COLORS.textDark
teleportInput3.Text = "500"
teleportInput3.Font = Enum.Font.Gotham
teleportInput3.TextSize = 9
teleportInput3.ClearTextOnFocus = false
teleportInput3.Parent = rightFrame3

local teleportCorner3 = Instance.new("UICorner")
teleportCorner3.CornerRadius = UDim.new(0, 4)
teleportCorner3.Parent = teleportInput3

local teleportStroke3 = Instance.new("UIStroke")
teleportStroke3.Color = COLORS.border
teleportStroke3.Thickness = 1
teleportStroke3.Parent = teleportInput3

-- Layer Toggles
local layersLabel3 = Instance.new("TextLabel")
layersLabel3.Size = UDim2.new(1, 0, 0, 14)
layersLabel3.Position = UDim2.new(0, 0, 0, 110)
layersLabel3.BackgroundTransparency = 1
layersLabel3.TextColor3 = COLORS.textDark
layersLabel3.Text = "Collision Layers:"
layersLabel3.Font = Enum.Font.GothamBold
layersLabel3.TextSize = 9
layersLabel3.TextXAlignment = Enum.TextXAlignment.Left
layersLabel3.Parent = rightFrame3

local velocityToggle3 = Instance.new("TextButton")
velocityToggle3.Size = UDim2.new(1, 0, 0, 18)
velocityToggle3.Position = UDim2.new(0, 0, 0, 124)
velocityToggle3.BackgroundColor3 = COLORS.buttonSuccess
velocityToggle3.TextColor3 = COLORS.textLight
velocityToggle3.Text = "✓ Velocity Burst"
velocityToggle3.Font = Enum.Font.Gotham
velocityToggle3.TextSize = 8
velocityToggle3.Parent = rightFrame3

local velocityTogCorner3 = Instance.new("UICorner")
velocityTogCorner3.CornerRadius = UDim.new(0, 4)
velocityTogCorner3.Parent = velocityToggle3

local angularToggle3 = Instance.new("TextButton")
angularToggle3.Size = UDim2.new(1, 0, 0, 18)
angularToggle3.Position = UDim2.new(0, 0, 0, 144)
angularToggle3.BackgroundColor3 = COLORS.buttonSuccess
angularToggle3.TextColor3 = COLORS.textLight
angularToggle3.Text = "✓ Angular Force"
angularToggle3.Font = Enum.Font.Gotham
angularToggle3.TextSize = 8
angularToggle3.Parent = rightFrame3

local angularTogCorner3 = Instance.new("UICorner")
angularTogCorner3.CornerRadius = UDim.new(0, 4)
angularTogCorner3.Parent = angularToggle3

local teleportToggle3 = Instance.new("TextButton")
teleportToggle3.Size = UDim2.new(1, 0, 0, 18)
teleportToggle3.Position = UDim2.new(0, 0, 0, 164)
teleportToggle3.BackgroundColor3 = COLORS.buttonSuccess
teleportToggle3.TextColor3 = COLORS.textLight
teleportToggle3.Text = "✓ Rapid Teleport"
teleToggle3.Font = Enum.Font.Gotham
teleportToggle3.TextSize = 8
teleportToggle3.Parent = rightFrame3

local teleportTogCorner3 = Instance.new("UICorner")
teleportTogCorner3.CornerRadius = UDim.new(0, 4)
teleportTogCorner3.Parent = teleportToggle3

local massToggle3 = Instance.new("TextButton")
massToggle3.Size = UDim2.new(1, 0, 0, 18)
massToggle3.Position = UDim2.new(0, 0, 0, 184)
massToggle3.BackgroundColor3 = COLORS.buttonSuccess
massToggle3.TextColor3 = COLORS.textLight
massToggle3.Text = "✓ Mass Boost"
massToggle3.Font = Enum.Font.Gotham
massToggle3.TextSize = 8
massToggle3.Parent = rightFrame3

local massTogCorner3 = Instance.new("UICorner")
massTogCorner3.CornerRadius = UDim.new(0, 4)
massTogCorner3.Parent = massToggle3

-- ========== TAB 4: COMBO DESTROYER ==========

local col4_C1 = Instance.new("Frame")
col4_C1.Size = UDim2.new(0.34, 0, 1, 0)
col4_C1.BackgroundTransparency = 1
col4_C1.Parent = tabContents[4]

local toggleButton4 = Instance.new("TextButton")
toggleButton4.Size = UDim2.new(1, 0, 0, 32)
toggleButton4.BackgroundColor3 = COLORS.buttonDanger
toggleButton4.TextColor3 = COLORS.textLight
toggleButton4.Text = "DESTROY: OFF"
toggleButton4.Font = Enum.Font.GothamBold
toggleButton4.TextSize = 12
toggleButton4.Parent = col4_C1
local togCorner4 = Instance.new("UICorner")
togCorner4.CornerRadius = UDim.new(0, 6)
togCorner4.Parent = toggleButton4

local statusLbl4 = Instance.new("TextLabel")
statusLbl4.Size = UDim2.new(1, 0, 0, 18)
statusLbl4.Position = UDim2.new(0, 0, 0, 36)
statusLbl4.BackgroundTransparency = 1
statusLbl4.TextColor3 = COLORS.textMuted
statusLbl4.Text = "No target"
statusLbl4.Font = Enum.Font.Gotham
statusLbl4.TextSize = 10
statusLbl4.Parent = col4_C1

local targetLbl4 = Instance.new("TextLabel")
targetLbl4.Size = UDim2.new(1, 0, 0, 16)
targetLbl4.Position = UDim2.new(0, 0, 0, 58)
targetLbl4.BackgroundTransparency = 1
targetLbl4.TextColor3 = COLORS.textDark
targetLbl4.Text = "Target:"
targetLbl4.Font = Enum.Font.GothamBold
targetLbl4.TextSize = 10
targetLbl4.TextXAlignment = Enum.TextXAlignment.Left
targetLbl4.Parent = col4_C1

local playerScroll4 = Instance.new("ScrollingFrame")
playerScroll4.Size = UDim2.new(1, 0, 0, 130)
playerScroll4.Position = UDim2.new(0, 0, 0, 78)
playerScroll4.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerScroll4.ScrollBarThickness = 4
playerScroll4.Parent = col4_C1
local plCorner4 = Instance.new("UICorner")
plCorner4.CornerRadius = UDim.new(0, 6)
plCorner4.Parent = playerScroll4
local plLayout4 = Instance.new("UIListLayout")
plLayout4.Padding = UDim.new(0, 2)
plLayout4.Parent = playerScroll4

-- Col 2
local col4_C2 = Instance.new("Frame")
col4_C2.Size = UDim2.new(0.34, -4, 1, 0)
col4_C2.Position = UDim2.new(0.34, 2, 0, 0)
col4_C2.BackgroundTransparency = 1
col4_C2.Parent = tabContents[4]

local modeLbl4 = Instance.new("TextLabel")
modeLbl4.Size = UDim2.new(1, 0, 0, 16)
modeLbl4.BackgroundTransparency = 1
modeLbl4.TextColor3 = COLORS.textDark
modeLbl4.Text = "Mode:"
modeLbl4.Font = Enum.Font.GothamBold
modeLbl4.TextSize = 10
modeLbl4.TextXAlignment = Enum.TextXAlignment.Left
modeLbl4.Parent = col4_C2

local devBtn4 = Instance.new("TextButton")
devBtn4.Size = UDim2.new(0.33, -1, 0, 22)
devBtn4.BackgroundColor3 = COLORS.buttonSuccess
devBtn4.TextColor3 = COLORS.textLight
devBtn4.Text = "✓ DEV"
devBtn4.Font = Enum.Font.GothamBold
devBtn4.TextSize = 9
devBtn4.Parent = col4_C2
local devCorner4 = Instance.new("UICorner")
devCorner4.CornerRadius = UDim.new(0, 4)
devCorner4.Parent = devBtn4

local orbBtn4 = Instance.new("TextButton")
orbBtn4.Size = UDim2.new(0.33, -1, 0, 22)
orbBtn4.Position = UDim2.new(0.33, 1, 0, 0)
orbBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
orbBtn4.TextColor3 = COLORS.textDark
orbBtn4.Text = "ORB"
orbBtn4.Font = Enum.Font.Gotham
orbBtn4.TextSize = 9
orbBtn4.Parent = col4_C2
local orbCorner4 = Instance.new("UICorner")
orbCorner4.CornerRadius = UDim.new(0, 4)
orbCorner4.Parent = orbBtn4

local chaosBtn4 = Instance.new("TextButton")
chaosBtn4.Size = UDim2.new(0.34, -1, 0, 22)
chaosBtn4.Position = UDim2.new(0.66, 2, 0, 0)
chaosBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
chaosBtn4.TextColor3 = COLORS.textDark
chaosBtn4.Text = "CHAOS"
chaosBtn4.Font = Enum.Font.Gotham
chaosBtn4.TextSize = 9
chaosBtn4.Parent = col4_C2
local chaosCorner4 = Instance.new("UICorner")
chaosCorner4.CornerRadius = UDim.new(0, 4)
chaosCorner4.Parent = chaosBtn4

local swordTog4 = Instance.new("TextButton")
swordTog4.Size = UDim2.new(0.5, -1, 0, 20)
swordTog4.Position = UDim2.new(0, 0, 0, 26)
swordTog4.BackgroundColor3 = COLORS.buttonSuccess
swordTog4.TextColor3 = COLORS.textLight
swordTog4.Text = "✓ Sword"
swordTog4.Font = Enum.Font.Gotham
swordTog4.TextSize = 9
swordTog4.Parent = col4_C2
local stCorner4 = Instance.new("UICorner")
stCorner4.CornerRadius = UDim.new(0, 4)
stCorner4.Parent = swordTog4

local velTog4 = Instance.new("TextButton")
velTog4.Size = UDim2.new(0.5, -1, 0, 20)
velTog4.Position = UDim2.new(0.5, 1, 0, 26)
velTog4.BackgroundColor3 = COLORS.buttonSuccess
velTog4.TextColor3 = COLORS.textLight
velTog4.Text = "✓ Velocity"
velTog4.Font = Enum.Font.Gotham
velTog4.TextSize = 9
velTog4.Parent = col4_C2
local vtCorner4 = Instance.new("UICorner")
vtCorner4.CornerRadius = UDim.new(0, 4)
vtCorner4.Parent = velTog4

local angTog4 = Instance.new("TextButton")
angTog4.Size = UDim2.new(0.5, -1, 0, 20)
angTog4.Position = UDim2.new(0, 0, 0, 50)
angTog4.BackgroundColor3 = COLORS.buttonSuccess
angTog4.TextColor3 = COLORS.textLight
angTog4.Text = "✓ Angular"
angTog4.Font = Enum.Font.Gotham
angTog4.TextSize = 9
angTog4.Parent = col4_C2
local atCorner4 = Instance.new("UICorner")
atCorner4.CornerRadius = UDim.new(0, 4)
atCorner4.Parent = angTog4

local tpTog4 = Instance.new("TextButton")
tpTog4.Size = UDim2.new(0.5, -1, 0, 20)
tpTog4.Position = UDim2.new(0.5, 1, 0, 50)
tpTog4.BackgroundColor3 = COLORS.buttonSuccess
tpTog4.TextColor3 = COLORS.textLight
tpTog4.Text = "✓ Teleport"
tpTog4.Font = Enum.Font.Gotham
tpTog4.TextSize = 9
tpTog4.Parent = col4_C2
local tpCorner4 = Instance.new("UICorner")
tpCorner4.CornerRadius = UDim.new(0, 4)
tpCorner4.Parent = tpTog4

local massTog4 = Instance.new("TextButton")
massTog4.Size = UDim2.new(1, 0, 0, 20)
massTog4.Position = UDim2.new(0, 0, 0, 74)
massTog4.BackgroundColor3 = COLORS.buttonSuccess
massTog4.TextColor3 = COLORS.textLight
massTog4.Text = "✓ Mass Boost"
massTog4.Font = Enum.Font.Gotham
massTog4.TextSize = 9
massTog4.Parent = col4_C2
local mtCorner4 = Instance.new("UICorner")
mtCorner4.CornerRadius = UDim.new(0, 4)
mtCorner4.Parent = massTog4

local setLbl4 = Instance.new("TextLabel")
setLbl4.Size = UDim2.new(1, 0, 0, 16)
setLbl4.Position = UDim2.new(0, 0, 0, 98)
setLbl4.BackgroundTransparency = 1
setLbl4.TextColor3 = COLORS.textDark
setLbl4.Text = "Power:"
setLbl4.Font = Enum.Font.GothamBold
setLbl4.TextSize = 10
setLbl4.TextXAlignment = Enum.TextXAlignment.Left
setLbl4.Parent = col4_C2

local velInput4 = Instance.new("TextBox")
velInput4.Size = UDim2.new(0.5, -1, 0, 20)
velInput4.Position = UDim2.new(0, 0, 0, 116)
velInput4.BackgroundColor3 = COLORS.inputBg
velInput4.TextColor3 = COLORS.textDark
velInput4.Text = "999999"
velInput4.Font = Enum.Font.Gotham
velInput4.TextSize = 9
velInput4.PlaceholderText = "Vel"
velInput4.Parent = col4_C2
local viCorner4 = Instance.new("UICorner")
viCorner4.CornerRadius = UDim.new(0, 4)
viCorner4.Parent = velInput4

local angInput4 = Instance.new("TextBox")
angInput4.Size = UDim2.new(0.5, -1, 0, 20)
angInput4.Position = UDim2.new(0.5, 1, 0, 116)
angInput4.BackgroundColor3 = COLORS.inputBg
angInput4.TextColor3 = COLORS.textDark
angInput4.Text = "999999"
angInput4.Font = Enum.Font.Gotham
angInput4.TextSize = 9
angInput4.PlaceholderText = "Ang"
angInput4.Parent = col4_C2
local aiCorner4 = Instance.new("UICorner")
aiCorner4.CornerRadius = UDim.new(0, 4)
aiCorner4.Parent = angInput4

local swingInput4 = Instance.new("TextBox")
swingInput4.Size = UDim2.new(0.5, -1, 0, 20)
swingInput4.Position = UDim2.new(0, 0, 0, 140)
swingInput4.BackgroundColor3 = COLORS.inputBg
swingInput4.TextColor3 = COLORS.textDark
swingInput4.Text = "3"
swingInput4.Font = Enum.Font.Gotham
swingInput4.TextSize = 9
swingInput4.PlaceholderText = "Swings"
swingInput4.Parent = col4_C2
local siCorner4 = Instance.new("UICorner")
siCorner4.CornerRadius = UDim.new(0, 4)
siCorner4.Parent = swingInput4

local reachInput4 = Instance.new("TextBox")
reachInput4.Size = UDim2.new(0.5, -1, 0, 20)
reachInput4.Position = UDim2.new(0.5, 1, 0, 140)
reachInput4.BackgroundColor3 = COLORS.inputBg
reachInput4.TextColor3 = COLORS.textDark
reachInput4.Text = "15"
reachInput4.Font = Enum.Font.Gotham
reachInput4.TextSize = 9
reachInput4.PlaceholderText = "Reach"
reachInput4.Parent = col4_C2
local riCorner4 = Instance.new("UICorner")
riCorner4.CornerRadius = UDim.new(0, 4)
riCorner4.Parent = reachInput4

-- Col 3
local col4_C3 = Instance.new("Frame")
col4_C3.Size = UDim2.new(0.32, -4, 1, 0)
col4_C3.Position = UDim2.new(0.68, 2, 0, 0)
col4_C3.BackgroundTransparency = 1
col4_C3.Parent = tabContents[4]

local howLbl4 = Instance.new("TextLabel")
howLbl4.Size = UDim2.new(1, 0, 0, 16)
howLbl4.BackgroundTransparency = 1
howLbl4.TextColor3 = COLORS.textDark
howLbl4.Text = "How to use:"
howLbl4.Font = Enum.Font.GothamBold
howLbl4.TextSize = 10
howLbl4.TextXAlignment = Enum.TextXAlignment.Left
howLbl4.Parent = col4_C3

local info1_4 = Instance.new("TextLabel")
info1_4.Size = UDim2.new(1, 0, 0, 45)
info1_4.Position = UDim2.new(0, 0, 0, 18)
info1_4.BackgroundTransparency = 1
info1_4.TextColor3 = COLORS.textMuted
info1_4.Text = "1. Select target\n2. Toggle DESTROY ON\n3. Combo activates"
info1_4.Font = Enum.Font.Gotham
info1_4.TextSize = 9
info1_4.TextXAlignment = Enum.TextXAlignment.Left
info1_4.Parent = col4_C3

local comboLbl4 = Instance.new("TextLabel")
comboLbl4.Size = UDim2.new(1, 0, 0, 16)
comboLbl4.Position = UDim2.new(0, 0, 0, 68)
comboLbl4.BackgroundTransparency = 1
comboLbl4.TextColor3 = COLORS.buttonPrimary
comboLbl4.Text = "COMBO EFFECTS:"
comboLbl4.Font = Enum.Font.GothamBold
comboLbl4.TextSize = 10
comboLbl4.TextXAlignment = Enum.TextXAlignment.Left
comboLbl4.Parent = col4_C3

local comboInfo4 = Instance.new("TextLabel")
comboInfo4.Size = UDim2.new(1, 0, 0, 45)
comboInfo4.Position = UDim2.new(0, 0, 0, 86)
comboInfo4.BackgroundTransparency = 1
comboInfo4.TextColor3 = COLORS.textMuted
comboInfo4.Text = "• Fling into target\n• Auto-sword swing\n• Unavoidable combo"
comboInfo4.Font = Enum.Font.Gotham
comboInfo4.TextSize = 9
comboInfo4.TextXAlignment = Enum.TextXAlignment.Left
comboInfo4.Parent = col4_C3

local dangerZone4 = Instance.new("Frame")
dangerZone4.Size = UDim2.new(1, 0, 0, 55)
dangerZone4.Position = UDim2.new(0, 0, 1, -57)
dangerZone4.BackgroundColor3 = Color3.fromRGB(255, 235, 235)
dangerZone4.Parent = col4_C3
local dzCorner4 = Instance.new("UICorner")
dzCorner4.CornerRadius = UDim.new(0, 6)
dzCorner4.Parent = dangerZone4

local dangerLbl4 = Instance.new("TextLabel")
dangerLbl4.Size = UDim2.new(1, 0, 0, 16)
dangerLbl4.Position = UDim2.new(0, 0, 0, 4)
dangerLbl4.BackgroundTransparency = 1
dangerLbl4.TextColor3 = COLORS.buttonDanger
dangerLbl4.Text = "⚠ DANGER ZONE"
dangerLbl4.Font = Enum.Font.GothamBold
dangerLbl4.TextSize = 10
dangerLbl4.Parent = dangerZone4

local killGuiBtn4 = Instance.new("TextButton")
killGuiBtn4.Size = UDim2.new(1, -8, 0, 28)
killGuiBtn4.Position = UDim2.new(0, 4, 0, 23)
killGuiBtn4.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
killGuiBtn4.TextColor3 = COLORS.textLight
killGuiBtn4.Text = "☠ KILL GUI"
killGuiBtn4.Font = Enum.Font.GothamBold
killGuiBtn4.TextSize = 11
killGuiBtn4.Parent = dangerZone4
local killCorner4 = Instance.new("UICorner")
killCorner4.CornerRadius = UDim.new(0, 5)
killCorner4.Parent = killGuiBtn4

-- ========== TAB 5: ANTI-AFK ==========

local afkTitle = Instance.new("TextLabel")
afkTitle.Size = UDim2.new(1, 0, 0, 28)
afkTitle.Position = UDim2.new(0, 0, 0, 10)
afkTitle.BackgroundTransparency = 1
afkTitle.TextColor3 = COLORS.textDark
afkTitle.Text = "Anti-AFK Protection"
afkTitle.Font = Enum.Font.GothamBold
afkTitle.TextSize = 16
afkTitle.Parent = tabContents[5]

local afkToggle = Instance.new("TextButton")
afkToggle.Size = UDim2.new(0.7, 0, 0, 50)
afkToggle.Position = UDim2.new(0.15, 0, 0, 55)
afkToggle.BackgroundColor3 = COLORS.buttonDanger
afkToggle.TextColor3 = COLORS.textLight
afkToggle.Text = "ANTI-AFK: OFF"
afkToggle.Font = Enum.Font.GothamBold
afkToggle.TextSize = 15
afkToggle.Parent = tabContents[5]
local afkCorner = Instance.new("UICorner")
afkCorner.CornerRadius = UDim.new(0, 10)
afkCorner.Parent = afkToggle

local afkInfo = Instance.new("TextLabel")
afkInfo.Size = UDim2.new(0.85, 0, 0, 70)
afkInfo.Position = UDim2.new(0.075, 0, 0, 120)
afkInfo.BackgroundTransparency = 1
afkInfo.TextColor3 = COLORS.textMuted
afkInfo.Text = "Prevents getting kicked for inactivity.\n\nWorks in any game.\nSimulates activity every 60 seconds."
afkInfo.Font = Enum.Font.Gotham
afkInfo.TextSize = 12
afkInfo.TextWrapped = true
afkInfo.Parent = tabContents[5]

local afkStatus = Instance.new("TextLabel")
afkStatus.Size = UDim2.new(1, 0, 0, 22)
afkStatus.Position = UDim2.new(0, 0, 1, -25)
afkStatus.BackgroundTransparency = 1
afkStatus.TextColor3 = COLORS.buttonPrimary
afkStatus.Text = "Status: Inactive"
afkStatus.Font = Enum.Font.Gotham
afkStatus.TextSize = 11
afkStatus.Parent = tabContents[5]

-- ========== DRAGGING ==========

local dragging = false
local dragInput, dragStart, startPos

hubButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = hubButton.Position
    end
end)

hubButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            hubButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
end)

hubButton.MouseButton1Click:Connect(function()
    hubButton.Visible = false
    mainFrame.Visible = true
end)

collapseButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

local hubDragging = false
local hubDragInput, hubDragStart, hubDragPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        hubDragging = true
        hubDragStart = input.Position
        hubDragPos = mainFrame.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        hubDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if hubDragging then
            local delta = input.Position - hubDragStart
            mainFrame.Position = UDim2.new(hubDragPos.X.Scale, hubDragPos.X.Offset + delta.X, hubDragPos.Y.Scale, hubDragPos.Y.Offset + delta.Y)
        end
    end
end)

-- ========== TAB SWITCHING ==========

for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        -- Update Styles
        for j, otherBtn in ipairs(tabButtons) do
            otherBtn.BackgroundColor3 = COLORS.tabInactive
            otherBtn.TextColor3 = COLORS.textDark
        end
        btn.BackgroundColor3 = COLORS.tabActive
        btn.TextColor3 = COLORS.textLight
        
        -- Toggle Visibility
        for k, frame in ipairs(tabContents) do
            frame.Visible = (k == i)
        end
    end)
end

-- ========== GLOBAL HELPERS ==========
local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

-- ========== LOGIC: TAB 1 (ORIGINAL FLING) ==========

local flingEnabled1 = false
local targetPlayer1 = nil
local flingLoop1 = nil
local flingCount1 = 0
local bodyAngularVel1 = nil
local bodyVel1 = nil
local playerButtons1 = {}

local function updatePlayerList1()
    for _, btn in pairs(playerButtons1) do btn:Destroy() end
    playerButtons1 = {}
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 20)
            btn.BackgroundColor3 = targetPlayer1 == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn.TextColor3 = targetPlayer1 == plr and COLORS.textLight or COLORS.textDark
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 10
            btn.Parent = playerScroll1
            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 5)
            bCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                targetPlayer1 = plr
                statusLabel1.Text = "Target: " .. plr.Name
                updatePlayerList1()
            end)
            table.insert(playerButtons1, btn)
        end
    end
    playerScroll1.CanvasSize = UDim2.new(0, 0, 0, playerLayout1.AbsoluteContentSize.Y)
end

local function stopFling1()
    if flingLoop1 then flingLoop1:Disconnect() flingLoop1 = nil end
    if bodyAngularVel1 then bodyAngularVel1:Destroy() bodyAngularVel1 = nil end
    if bodyVel1 then bodyVel1:Destroy() bodyVel1 = nil end
    
    local myChar = player.Character
    if myChar then
        local myRoot = getRoot(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        if myRoot then myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0) myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end
        if myHumanoid then myHumanoid.PlatformStand = false end
    end
end

local function startFling1()
    if flingLoop1 then flingLoop1:Disconnect() end
    local myChar = player.Character if not myChar then return end
    local myRoot = getRoot(myChar) if not myRoot then return end
    local myHumanoid = myChar:FindFirstChild("Humanoid")
    local spinPower = tonumber(spinInput.Text) or 999999
    local launchPower = tonumber(launchInput.Text) or 999999
    
    if bodyAngularVel1 then bodyAngularVel1:Destroy() end
    bodyAngularVel1 = Instance.new("BodyAngularVelocity")
    bodyAngularVel1.Name = "FlingSpin1"
    bodyAngularVel1.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyAngularVel1.AngularVelocity = Vector3.new(spinPower, spinPower, spinPower)
    bodyAngularVel1.P = math.huge
    bodyAngularVel1.Parent = myRoot
    
    if bodyVel1 then bodyVel1:Destroy() end
    bodyVel1 = Instance.new("BodyVelocity")
    bodyVel1.Name = "FlingLaunch1"
    bodyVel1.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel1.Velocity = Vector3.new(0, launchPower, 0)
    bodyVel1.P = math.huge
    bodyVel1.Parent = myRoot
    
    if myHumanoid then myHumanoid.PlatformStand = true end
    
    flingLoop1 = RunService.Heartbeat:Connect(function()
        if not flingEnabled1 then return end
        local char = player.Character if not char then return end
        local root = getRoot(char) if not root then return end
        if not targetPlayer1 or not targetPlayer1.Character then return end
        local targetRoot = getRoot(targetPlayer1.Character) if not targetRoot then return end
        
        root.CFrame = targetRoot.CFrame
        
        if not root:FindFirstChild("FlingSpin1") then
            local bv = Instance.new("BodyAngularVelocity")
            bv.Name = "FlingSpin1"
            bv.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bv.AngularVelocity = Vector3.new(spinPower, spinPower, spinPower)
            bv.P = math.huge
            bv.Parent = root
        end
        
        if not root:FindFirstChild("FlingLaunch1") then
            local bvel = Instance.new("BodyVelocity")
            bvel.Name = "FlingLaunch1"
            bvel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bvel.Velocity = Vector3.new(0, launchPower, 0)
            bvel.P = math.huge
            bvel.Parent = root
        end
    end)
end

toggleButton1.MouseButton1Click:Connect(function()
    flingEnabled1 = not flingEnabled1
    if flingEnabled1 then
        toggleButton1.Text = "FLING: ON"
        toggleButton1.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel1.Text = targetPlayer1 and ("Flinging: " .. targetPlayer1.Name) or "No target"
        startFling1()
    else
        toggleButton1.Text = "FLING: OFF"
        toggleButton1.BackgroundColor3 = COLORS.buttonDanger
        statusLabel1.Text = targetPlayer1 and ("Target: " .. targetPlayer1.Name) or "No target"
        stopFling1()
    end
end)

player.CharacterAdded:Connect(function()
    wait(0.3)
    if flingEnabled1 then flingCount1 = flingCount1 + 1 flingCounter1.Text = "Flings: " .. flingCount1 startFling1() end
end)
player.CharacterRemoving:Connect(stopFling1)
Players.PlayerAdded:Connect(updatePlayerList1)
Players.PlayerRemoving:Connect(function() wait(0.5) updatePlayerList1() end)
updatePlayerList1()


-- ========== LOGIC: TAB 2 (TP KILL) ==========

local killEnabled2 = false
local targetPlayer2 = nil
local playerButtons2 = {}

local function updatePlayerList2()
    for _, btn in pairs(playerButtons2) do btn:Destroy() end
    playerButtons2 = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 20)
            btn.BackgroundColor3 = targetPlayer2 == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn.TextColor3 = targetPlayer2 == plr and COLORS.textLight or COLORS.textDark
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 10
            btn.Parent = playerScroll2
            local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 5) c.Parent = btn
            btn.MouseButton1Click:Connect(function()
                targetPlayer2 = plr
                statusLabel2.Text = "Target: " .. plr.Name
                updatePlayerList2()
            end)
            table.insert(playerButtons2, btn)
        end
    end
    playerScroll2.CanvasSize = UDim2.new(0, 0, 0, playerLayout2.AbsoluteContentSize.Y)
end

local function getSword()
    local char = player.Character if not char then return nil end
    for _, item in pairs(char:GetChildren()) do if item:IsA("Tool") then return item end end
    return nil
end

local function equipSword()
    local char = player.Character local backpack = player:FindFirstChild("Backpack")
    if not char or not backpack then return nil end
    local tool = getSword() if tool then return tool end
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then char.Humanoid:EquipTool(item) wait(0.1) return item end
    end
    return nil
end

local function hasProtection(targetPlr)
    if not targetPlr or not targetPlr.Character then return false end
    return targetPlr.Character:FindFirstChild("ForceField") ~= nil
end

local function attackTarget()
    if not targetPlayer2 then return end
    local myChar = player.Character local myHum = myChar and getRoot(myChar)
    local myHumanoid = myChar and myChar:FindFirstChild("Humanoid")
    local targetChar = targetPlayer2.Character local targetHum = targetChar and getRoot(targetChar)
    local targetHumanoid = targetChar and targetChar:FindFirstChild("Humanoid")
    
    if not myHum or not myHumanoid or not targetHum or not targetHumanoid then return end
    if targetHumanoid.Health <= 0 then return end
    
    local sword = getSword() if not sword then sword = equipSword() end
    myHum.CFrame = targetHum.CFrame * CFrame.new(0, 0, 2)
    
    if sword then
        local swings = tonumber(swingsInput.Text) or 3
        for i = 1, swings do sword:Activate() wait(0.01) end
    end
end

toggleButton2.MouseButton1Click:Connect(function()
    killEnabled2 = not killEnabled2
    if killEnabled2 then
        toggleButton2.Text = "KILL AURA: ON"
        toggleButton2.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel2.Text = targetPlayer2 and ("Hunting: " .. targetPlayer2.Name) or "No target"
        equipSword()
        spawn(function()
            while killEnabled2 do
                if targetPlayer2 and targetPlayer2.Character then
                    local tHum = targetPlayer2.Character:FindFirstChild("Humanoid")
                    if tHum then
                        if tHum.Health > 0 then
                            if hasProtection(targetPlayer2) then
                                protectionLabel.Text = "Protection: TARGET PROTECTED"
                                protectionLabel.TextColor3 = COLORS.buttonWarning
                                statusLabel2.Text = "Waiting..."
                            else
                                protectionLabel.Text = "Protection: TARGET VULNERABLE"
                                protectionLabel.TextColor3 = COLORS.buttonSuccess
                                statusLabel2.Text = "ATTACKING!"
                                attackTarget()
                                wait(tonumber(delayInput.Text) or 0.05)
                            end
                        else
                            protectionLabel.Text = "Target dead"
                            protectionLabel.TextColor3 = COLORS.textMuted
                        end
                    end
                end
                wait(tonumber(checkInput.Text) or 0.1)
            end
        end)
    else
        toggleButton2.Text = "KILL AURA: OFF"
        toggleButton2.BackgroundColor3 = COLORS.buttonDanger
        statusLabel2.Text = targetPlayer2 and ("Target: " .. targetPlayer2.Name) or "No target"
        protectionLabel.Text = "Protection: Waiting..."
        protectionLabel.TextColor3 = COLORS.textMuted
    end
end)

player.CharacterAdded:Connect(function() wait(1) if killEnabled2 then equipSword() end end)
Players.PlayerAdded:Connect(updatePlayerList2)
Players.PlayerRemoving:Connect(function() wait(0.5) updatePlayerList2() end)
updatePlayerList2()

-- ========== LOGIC: TAB 3 (ULTIMATE COLLISION) ==========

local flingEnabled3 = false
local targetPlayer3 = nil
local flingLoop3 = nil
local flingCount3 = 0
local velocityPower3 = 999999
local angularPower3 = 999999
local teleportSpeed3 = 500
local collisionMode3 = "devastate"
local velocityEnabled3 = true
local angularEnabled3 = true
local teleportEnabled3 = true
local massEnabled3 = true
local bodyVel3 = nil
local bodyAngVel3 = nil
local angle3 = 0
local playerButtons3 = {}

local function boostMass3(char)
    if not massEnabled3 then return end
    local root = getRoot(char) if root then root.CustomPhysicalProperties = PhysicalProperties.new(100, 0.5, 0.5) end end
end

local function resetMass3(char)
    local root = getRoot(char) if root then root.CustomPhysicalProperties = nil end end
end

local function updatePlayerList3()
    for _, btn in pairs(playerButtons3) do btn:Destroy() end
    playerButtons3 = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 18)
            btn.BackgroundColor3 = targetPlayer3 == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn.TextColor3 = targetPlayer3 == plr and COLORS.textLight or COLORS.textDark
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 9
            btn.Parent = playerScroll3
            local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = btn
            btn.MouseButton1Click:Connect(function()
                targetPlayer3 = plr
                statusLabel3.Text = "Target: " .. plr.Name
                updatePlayerList3()
            end)
            table.insert(playerButtons3, btn)
        end
    end
    playerScroll3.CanvasSize = UDim2.new(0, 0, 0, playerLayout3.AbsoluteContentSize.Y)
end

local function stopFling3()
    if flingLoop3 then flingLoop3:Disconnect() flingLoop3 = nil end
    if bodyVel3 then bodyVel3:Destroy() bodyVel3 = nil end
    if bodyAngVel3 then bodyAngVel3:Destroy() bodyAngVel3 = nil end
    
    local myChar = player.Character
    if myChar then
        local myRoot = getRoot(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        if myRoot then myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0) myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end
        if myHumanoid then myHumanoid.PlatformStand = false end
        resetMass3(myChar)
    end
end

local function startFling3()
    if flingLoop3 then flingLoop3:Disconnect() end
    
    flingLoop3 = RunService.Heartbeat:Connect(function()
        if not flingEnabled3 then return end
        local myChar = player.Character if not myChar then return end
        local myRoot = getRoot(myChar) if not myRoot then return end
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        if not targetPlayer3 or not targetPlayer3.Character then return end
        local targetRoot = getRoot(targetPlayer3.Character) if not targetRoot then return end
        
        velocityPower3 = tonumber(velocityInput3.Text) or 999999
        angularPower3 = tonumber(angularInput3.Text) or 999999
        teleportSpeed3 = tonumber(teleportInput3.Text) or 500
        
        boostMass3(player.Character)
        
        if teleportEnabled3 then
            if collisionMode3 == "orbital" then
                angle3 = angle3 + (math.pi * 2 / teleportSpeed3)
                local offset = Vector3.new(math.cos(angle3)*2, 1, math.sin(angle3)*2)
                myRoot.CFrame = targetRoot.CFrame * CFrame.new(offset)
            else
                myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
            end
        end
        
        if velocityEnabled3 then
            if bodyVel3 then bodyVel3:Destroy() end
            bodyVel3 = Instance.new("BodyVelocity")
            bodyVel3.Name = "UltVel"
            bodyVel3.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            
            if collisionMode3 == "orbital" then
                bodyVel3.Velocity = (targetRoot.Position - myRoot.Position).Unit * velocityPower3
            else
                bodyVel3.Velocity = Vector3.new(math.random(-1, 1)*velocityPower3, velocityPower3, math.random(-1, 1)*velocityPower3)
            end
            bodyVel3.P = math.huge
            bodyVel3.Parent = myRoot
        end
        
        if angularEnabled3 then
            if bodyAngVel3 then bodyAngVel3:Destroy() end
            bodyAngVel3 = Instance.new("BodyAngularVelocity")
            bodyAngVel3.Name = "UltAng"
            bodyAngVel3.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyAngVel3.AngularVelocity = Vector3.new(angularPower3, angularPower3, angularPower3)
            bodyAngVel3.P = math.huge
            bodyAngVel3.Parent = myRoot
        end
        
        if myHumanoid then myHumanoid.PlatformStand = true end
    end)
end

toggleButton3.MouseButton1Click:Connect(function()
    flingEnabled3 = not flingEnabled3
    if flingEnabled3 then
        if not targetPlayer3 then statusLabel3.Text = "Select a target first!" flingEnabled3 = false return end
        toggleButton3.Text = "FLING: ON"
        toggleButton3.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel3.Text = "Flinging: " .. targetPlayer3.Name .. " (" .. collisionMode3:upper() .. ")"
        startFling3()
    else
        toggleButton3.Text = "FLING: OFF"
        toggleButton3.BackgroundColor3 = COLORS.buttonDanger
        statusLabel3.Text = targetPlayer3 and ("Target: " .. targetPlayer3.Name) or "No target"
        stopFling3()
    end
end)

-- Tab 3 UI Hooks
devastateModeBtn.MouseButton1Click:Connect(function()
    collisionMode3 = "devastate"
    devastateModeBtn.Text = "✓ DEVASTATE" devastateModeBtn.BackgroundColor3 = COLORS.buttonSuccess devastateModeBtn.TextColor3 = COLORS.textLight
    orbitalModeBtn.Text = "Orbital" orbitalModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200) orbitalModeBtn.TextColor3 = COLORS.textDark
    chaosModeBtn.Text = "Chaos" chaosModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200) chaosModeBtn.TextColor3 = COLORS.textDark
end)
orbitalModeBtn.MouseButton1Click:Connect(function()
    collisionMode3 = "orbital"
    orbitalModeBtn.Text = "✓ Orbital" orbitalModeBtn.BackgroundColor3 = COLORS.buttonSuccess orbitalModeBtn.TextColor3 = COLORS.textLight
    devastateModeBtn.Text = "DEVASTATE" devastateModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200) devastateModeBtn.TextColor3 = COLORS.textDark
    chaosModeBtn.Text = "Chaos" chaosModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200) chaosModeBtn.TextColor3 = COLORS.textDark
end)
chaosModeBtn.MouseButton1Click:Connect(function()
    collisionMode3 = "chaos"
    chaosModeBtn.Text = "✓ Chaos" chaosModeBtn.BackgroundColor3 = COLORS.buttonSuccess chaosModeBtn.TextColor3 = COLORS.textLight
    devastateModeBtn.Text = "DEVASTATE" devastateModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200) devastateModeBtn.TextColor3 = COLORS.textDark
    orbitalModeBtn.Text = "Orbital" orbitalModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200) orbitalModeBtn.TextColor3 = COLORS.textDark
end)

velocityToggle3.MouseButton1Click:Connect(function()
    velocityEnabled3 = not velocityEnabled3
    velocityToggle3.Text = velocityEnabled3 and "✓ Velocity Burst" or "✗ Velocity Burst"
    velocityToggle3.BackgroundColor3 = velocityEnabled3 and COLORS.buttonSuccess or COLORS.buttonDanger
end)
angularToggle3.MouseButton1Click:Connect(function()
    angularEnabled3 = not angularEnabled3
    angularToggle3.Text = angularEnabled3 and "✓ Angular Force" or "✗ Angular Force"
    angularToggle3.BackgroundColor3 = angularEnabled3 and COLORS.buttonSuccess or COLORS.buttonDanger
end)
teleportToggle3.MouseButton1Click:Connect(function()
    teleportEnabled3 = not teleportEnabled3
    teleportToggle3.Text = teleportEnabled3 and "✓ Rapid Teleport" or "✗ Rapid Teleport"
    teleportToggle3.BackgroundColor3 = teleportEnabled3 and COLORS.buttonSuccess or COLORS.buttonDanger
end)
massToggle3.MouseButton1Click:Connect(function()
    massEnabled3 = not massEnabled3
    massToggle3.Text = massEnabled3 and "✓ Mass Boost" or "✗ Mass Boost"
    massToggle3.BackgroundColor3 = massEnabled3 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

player.CharacterAdded:Connect(function() wait(0.3) if flingEnabled3 then flingCount3 = flingCount3 + 1 flingCounter3.Text = "Flings: " .. flingCount3 startFling3() end end)
player.CharacterRemoving:Connect(stopFling3)
Players.PlayerAdded:Connect(updatePlayerList3)
Players.PlayerRemoving:Connect(function() wait(0.5) updatePlayerList3() end)
updatePlayerList3()

-- ========== LOGIC: TAB 4 (COMBO DESTROYER) ==========

-- Variables for Combo
local destroyEnabled4 = false
local targetPlayer4 = nil
local flingCount4 = 0
local velocityPower4 = 999999
local angularPower4 = 999999
local collisionMode4 = "devastate"
local swordSwings4 = 3
local swingDelay4 = 0.01
local swordReach4 = 15
local velocityEnabled4 = true
local angularEnabled4 = true
local teleportEnabled4 = true
local massEnabled4 = true
local swordEnabled4 = true
local flingLoop4 = nil
local bodyVel4 = nil
local bodyAngVel4 = nil
local angle4 = 0
local playerButtons4 = {}

-- Shared helper functions for Combo (using mobile-friendly logic)
local function devastateFling4(targetRoot, myRoot, myHumanoid)
    velocityPower4 = tonumber(velInput4.Text) or 999999
    angularPower4 = tonumber(angInput4.Text) or 999999
    
    if massEnabled4 then boostMass3(player.Character) end -- Reuse boostMass from Tab 3 logic
    if teleportEnabled4 then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
    end
    if velocityEnabled4 then
        if bodyVel4 then bodyVel4:Destroy() end
        bodyVel4 = Instance.new("BodyVelocity")
        bodyVel4.Name = "CollisionBurst4"
        bodyVel4.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel4.Velocity = Vector3.new(math.random(-1, 1) * velocityPower4, velocityPower4, math.random(-1, 1) * velocityPower4)
        bodyVel4.P = math.huge
        bodyVel4.Parent = myRoot
    end
    if angularEnabled4 then
        if bodyAngVel4 then bodyAngVel4:Destroy() end
        bodyAngVel4 = Instance.new("BodyAngularVelocity")
        bodyAngVel4.Name = "CollisionSpin4"
        bodyAngVel4.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel4.AngularVelocity = Vector3.new(angularPower4, angularPower4, angularPower4)
        bodyAngVel4.P = math.huge
        bodyAngVel4.Parent = myRoot
    end
    if myHumanoid then myHumanoid.PlatformStand = true end
end

local function orbitalFling4(targetRoot, myRoot, myHumanoid)
    velocityPower4 = tonumber(velInput4.Text) or 999999
    angularPower4 = tonumber(angInput4.Text) or 999999
    
    angle4 = angle4 + (math.pi * 2 / 500)
    local offsetX = math.cos(angle4) * 2
    local offsetZ = math.sin(angle4) * 2
    
    if massEnabled4 then boostMass3(player.Character) end
    if teleportEnabled4 then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(offsetX, 1, offsetZ)
    end
    if velocityEnabled4 then
        local direction = (targetRoot.Position - myRoot.Position).Unit
        if bodyVel4 then bodyVel4:Destroy() end
        bodyVel4 = Instance.new("BodyVelocity")
        bodyVel4.Name = "CollisionBurst4"
        bodyVel4.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel4.Velocity = direction * velocityPower4
        bodyVel4.P = math.huge
        bodyVel4.Parent = myRoot
    end
    if angularEnabled4 then
        if bodyAngVel4 then bodyAngVel4:Destroy() end
        bodyAngVel4 = Instance.new("BodyAngularVelocity")
        bodyAngVel4.Name = "CollisionSpin4"
        bodyAngVel4.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel4.AngularVelocity = Vector3.new(angularPower4, angularPower4, angularPower4)
        bodyAngVel4.P = math.huge
        bodyAngVel4.Parent = myRoot
    end
    if myHumanoid then myHumanoid.PlatformStand = true end
end

local function chaosFling4(targetRoot, myRoot, myHumanoid)
    velocityPower4 = tonumber(velInput4.Text) or 999999
    angularPower4 = tonumber(angInput4.Text) or 999999
    
    if massEnabled4 then boostMass3(player.Character) end
    if teleportEnabled4 then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-3, 3), math.random(-2, 2), math.random(-3, 3))
    end
    if velocityEnabled4 then
        if bodyVel4 then bodyVel4:Destroy() end
        bodyVel4 = Instance.new("BodyVelocity")
        bodyVel4.Name = "CollisionBurst4"
        bodyVel4.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel4.Velocity = Vector3.new(math.random(-1, 1) * velocityPower4, math.random(-1, 1) * velocityPower4, math.random(-1, 1) * velocityPower4)
        bodyVel4.P = math.huge
        bodyVel4.Parent = myRoot
    end
    if angularEnabled4 then
        if bodyAngVel4 then bodyAngVel4:Destroy() end
        bodyAngVel4 = Instance.new("BodyAngularVelocity")
        bodyAngVel4.Name = "CollisionSpin4"
        bodyAngVel4.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel4.AngularVelocity = Vector3.new(math.random(-1, 1) * angularPower4, math.random(-1, 1) * angularPower4, math.random(-1, 1) * angularPower4)
        bodyAngVel4.P = math.huge
        bodyAngVel4.Parent = myRoot
    end
    if myHumanoid then myHumanoid.PlatformStand = true end
end

local function swordAttack4(targetRoot, myRoot)
    if not swordEnabled4 then return end
    swordReach4 = tonumber(reachInput4.Text) or 15
    swordSwings4 = tonumber(swingInput4.Text) or 3
    local sword = getSword()
    if not sword then sword = equipSword() if not sword then return end end
    local distance = (targetRoot.Position - myRoot.Position).Magnitude
    if distance <= swordReach4 then
        for i = 1, swordSwings4 do
            sword:Activate()
            wait(swingDelay4)
        end
    end
end

local function updatePlayerList4()
    for _, btn in pairs(playerButtons4) do btn:Destroy() end
    playerButtons4 = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 20)
            btn.BackgroundColor3 = targetPlayer4 == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn.TextColor3 = targetPlayer4 == plr and COLORS.textLight or COLORS.textDark
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 9
            btn.Parent = playerScroll4
            local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = btn
            btn.MouseButton1Click:Connect(function()
                targetPlayer4 = plr
                statusLbl4.Text = "Target: " .. plr.Name
                updatePlayerList4()
            end)
            table.insert(playerButtons4, btn)
        end
    end
    playerScroll4.CanvasSize = UDim2.new(0, 0, 0, plLayout4.AbsoluteContentSize.Y)
end

local function stopAll4()
    if flingLoop4 then flingLoop4:Disconnect() flingLoop4 = nil end
    if bodyVel4 then bodyVel4:Destroy() bodyVel4 = nil end
    if bodyAngVel4 then bodyAngVel4:Destroy() bodyAngVel4 = nil end
    local myChar = player.Character
    if myChar then
        local myRoot = getRoot(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        if myRoot then myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0) myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end
        if myHumanoid then myHumanoid.PlatformStand = false end
        resetMass3(myChar)
    end
end

local function startDestroy4()
    if flingLoop4 then flingLoop4:Disconnect() end
    flingLoop4 = RunService.Heartbeat:Connect(function()
        if not destroyEnabled4 then return end
        local myChar = player.Character if not myChar then return end
        local myRoot = getRoot(myChar) if not myRoot then return end
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        if not targetPlayer4 or not targetPlayer4.Character then return end
        local targetRoot = getRoot(targetPlayer4.Character) if not targetRoot then return end
        
        if collisionMode4 == "devastate" then
            devastateFling4(targetRoot, myRoot, myHumanoid)
        elseif collisionMode4 == "orbital" then
            orbitalFling4(targetRoot, myRoot, myHumanoid)
        else
            chaosFling4(targetRoot, myRoot, myHumanoid)
        end
        swordAttack4(targetRoot, myRoot)
    end)
end

-- UI Hooks for Tab 4
toggleButton4.MouseButton1Click:Connect(function()
    destroyEnabled4 = not destroyEnabled4
    if destroyEnabled4 then
        if not targetPlayer4 then statusLbl4.Text = "Select target!" destroyEnabled4 = false return end
        toggleButton4.Text = "DESTROY: ON"
        toggleButton4.BackgroundColor3 = COLORS.buttonSuccess
        statusLbl4.Text = "Destroying: " .. targetPlayer4.Name
        equipSword()
        startDestroy4()
    else
        toggleButton4.Text = "DESTROY: OFF"
        toggleButton4.BackgroundColor3 = COLORS.buttonDanger
        statusLbl4.Text = targetPlayer4 and ("Target: " .. targetPlayer4.Name) or "No target"
        stopAll4()
    end
end)

devBtn4.MouseButton1Click:Connect(function()
    collisionMode4 = "devastate"
    devBtn4.Text = "✓ DEV" devBtn4.BackgroundColor3 = COLORS.buttonSuccess devBtn4.TextColor3 = COLORS.textLight
    orbBtn4.Text = "ORB" orbBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200) orbBtn4.TextColor3 = COLORS.textDark
    chaosBtn4.Text = "CHAOS" chaosBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200) chaosBtn4.TextColor3 = COLORS.textDark
end)
orbBtn4.MouseButton1Click:Connect(function()
    collisionMode4 = "orbital"
    orbBtn4.Text = "✓ ORB" orbBtn4.BackgroundColor3 = COLORS.buttonSuccess orbBtn4.TextColor3 = COLORS.textLight
    devBtn4.Text = "DEV" devBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200) devBtn4.TextColor3 = COLORS.textDark
    chaosBtn4.Text = "CHAOS" chaosBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200) chaosBtn4.TextColor3 = COLORS.textDark
end)
chaosBtn4.MouseButton1Click:Connect(function()
    collisionMode4 = "chaos"
    chaosBtn4.Text = "✓ CHAOS" chaosBtn4.BackgroundColor3 = COLORS.buttonSuccess chaosBtn4.TextColor3 = COLORS.textLight
    devBtn4.Text = "DEV" devBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200) devBtn4.TextColor3 = COLORS.textDark
    orbBtn4.Text = "ORB" orbBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200) orbBtn4.TextColor3 = COLORS.textDark
end)

swordTog4.MouseButton1Click:Connect(function()
    swordEnabled4 = not swordEnabled4
    swordTog4.Text = swordEnabled4 and "✓ Sword" or "✗ Sword"
    swordTog4.BackgroundColor3 = swordEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)
velTog4.MouseButton1Click:Connect(function()
    velocityEnabled4 = not velocityEnabled4
    velTog4.Text = velocityEnabled4 and "✓ Velocity" or "✗ Velocity"
    velTog4.BackgroundColor3 = velocityEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)
angTog4.MouseButton1Click:Connect(function()
    angularEnabled4 = not angularEnabled4
    angTog4.Text = angularEnabled4 and "✓ Angular" or "✗ Angular"
    angTog4.BackgroundColor3 = angularEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)
tpTog4.MouseButton1Click:Connect(function()
    teleportEnabled4 = not teleportEnabled4
    tpTog4.Text = teleportEnabled4 and "✓ Teleport" or "✗ Teleport"
    tpTog4.BackgroundColor3 = teleportEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)
massTog4.MouseButton1Click:Connect(function()
    massEnabled4 = not massEnabled4
    massTog4.Text = massEnabled4 and "✓ Mass Boost" or "✗ Mass Boost"
    massTog4.BackgroundColor3 = massEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

killGuiBtn4.MouseButton1Click:Connect(function()
    destroyEnabled4 = false
    stopAll4()
    screenGui:Destroy()
end)

player.CharacterAdded:Connect(function()
    wait(0.3)
    if destroyEnabled4 then flingCount4 = flingCount4 + 1 equipSword() startDestroy4() end
end)
player.CharacterRemoving:Connect(stopAll4)
Players.PlayerAdded:Connect(updatePlayerList4)
Players.PlayerRemoving:Connect(function() wait(0.5) updatePlayerList4() end)
updatePlayerList4()

-- ========== LOGIC: TAB 5 (ANTI-AFK) ==========

local antiAfkEnabled5 = false

afkToggle.MouseButton1Click:Connect(function()
    antiAfkEnabled5 = not antiAfkEnabled5
    if antiAfkEnabled5 then
        afkToggle.Text = "ANTI-AFK: ON"
        afkToggle.BackgroundColor3 = COLORS.buttonSuccess
        afkStatus.Text = "Status: Active - Protecting"
    else
        afkToggle.Text = "ANTI-AFK: OFF"
        afkToggle.BackgroundColor3 = COLORS.buttonDanger
        afkStatus.Text = "Status: Inactive"
    end
end)

spawn(function()
    while true do
        wait(60)
        if antiAfkEnabled5 then
            local vu = game:GetService("VirtualUser")
            vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            wait(0.1)
            vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end
    end
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

print("✅ 5-Tab Ultimate Hub Loaded Successfully")
