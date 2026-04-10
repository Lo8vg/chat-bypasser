-- Combined Hub: Fling + TP Kill + Ultimate Collision + Destroyer + Anti-AFK (5 Tabs)
-- Five separate tabs, each works independently

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
screenGui.Name = "CombinedHub"
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
mainFrame.Size = UDim2.new(0, 500, 0, 380)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
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
titleLabel.Text = "⚔️ Ultimate Combat Hub"
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

-- ========== TAB BUTTONS ==========

local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Size = UDim2.new(1, -20, 0, 32)
tabButtonsFrame.Position = UDim2.new(0, 10, 0, 44)
tabButtonsFrame.BackgroundTransparency = 1
tabButtonsFrame.Parent = mainFrame

-- Create 5 tab buttons
local tabButtons = {}
for i = 1, 5 do
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0.2, -2, 1, 0)
    tabButton.Position = UDim2.new((i-1) * 0.2, (i-1) * 2, 0, 0)
    tabButton.BackgroundColor3 = i == 1 and COLORS.tabActive or COLORS.tabInactive
    tabButton.TextColor3 = i == 1 and COLORS.textLight or COLORS.textDark
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 10
    
    if i == 1 then
        tabButton.Text = "Original"
    elseif i == 2 then
        tabButton.Text = "TP Kill"
    elseif i == 3 then
        tabButton.Text = "Ultimate"
    elseif i == 4 then
        tabButton.Text = "Destroyer"
    else
        tabButton.Text = "Anti-AFK"
    end
    
    tabButton.Parent = tabButtonsFrame
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabButton
    tabButtons[i] = tabButton
end

-- ========== TAB 1: FLING (ORIGINAL SCRIPT) ==========

local tab1Content = Instance.new("Frame")
tab1Content.Size = UDim2.new(1, -20, 1, -82)
tab1Content.Position = UDim2.new(0, 10, 0, 80)
tab1Content.BackgroundTransparency = 1
tab1Content.Visible = true
tab1Content.Parent = mainFrame

-- Left Frame (Fling)
local leftFrame1 = Instance.new("Frame")
leftFrame1.Size = UDim2.new(0.5, -8, 1, 0)
leftFrame1.Position = UDim2.new(0, 0, 0, 0)
leftFrame1.BackgroundTransparency = 1
leftFrame1.Parent = tab1Content

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
local flingCounter = Instance.new("TextLabel")
flingCounter.Size = UDim2.new(1, 0, 0, 16)
flingCounter.Position = UDim2.new(0, 0, 0, 36)
flingCounter.BackgroundTransparency = 1
flingCounter.TextColor3 = COLORS.buttonSuccess
flingCounter.Text = "Flings: 0"
flingCounter.Font = Enum.Font.GothamBold
flingCounter.TextSize = 11
flingCounter.Parent = leftFrame1

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
rightFrame1.Parent = tab1Content

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

-- ========== TAB 2: TP KILL (ORIGINAL SCRIPT) ==========

local tab2Content = Instance.new("Frame")
tab2Content.Size = UDim2.new(1, -20, 1, -82)
tab2Content.Position = UDim2.new(0, 10, 0, 80)
tab2Content.BackgroundTransparency = 1
tab2Content.Visible = false
tab2Content.Parent = mainFrame

-- Toggle Button
local toggleButton2 = Instance.new("TextButton")
toggleButton2.Size = UDim2.new(1, 0, 0, 36)
toggleButton2.Position = UDim2.new(0, 0, 0, 0)
toggleButton2.BackgroundColor3 = COLORS.buttonDanger
toggleButton2.TextColor3 = COLORS.textLight
toggleButton2.Text = "KILL AURA: OFF"
toggleButton2.Font = Enum.Font.GothamBold
toggleButton2.TextSize = 14
toggleButton2.Parent = tab2Content

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
protectionLabel.Parent = tab2Content

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
targetLabel2.Parent = tab2Content

-- Player List
local playerScroll2 = Instance.new("ScrollingFrame")
playerScroll2.Size = UDim2.new(1, 0, 0, 80)
playerScroll2.Position = UDim2.new(0, 0, 0, 76)
playerScroll2.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerScroll2.ScrollBarThickness = 4
playerScroll2.Parent = tab2Content

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
statusLabel2.Parent = tab2Content

-- Delay Input
local delayRow = Instance.new("Frame")
delayRow.Size = UDim2.new(1, 0, 0, 24)
delayRow.Position = UDim2.new(0, 0, 0, 180)
delayRow.BackgroundTransparency = 1
delayRow.Parent = tab2Content

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
swingsRow.Parent = tab2Content

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
checkRow.Parent = tab2Content

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

-- ========== TAB 3: ULTIMATE COLLISION FLING (ORIGINAL SCRIPT) ==========

local tab3Content = Instance.new("Frame")
tab3Content.Size = UDim2.new(1, -20, 1, -82)
tab3Content.Position = UDim2.new(0, 10, 0, 80)
tab3Content.BackgroundTransparency = 1
tab3Content.Visible = false
tab3Content.Parent = mainFrame

-- Left Frame
local leftFrame3 = Instance.new("Frame")
leftFrame3.Size = UDim2.new(0.5, -8, 1, 0)
leftFrame3.Position = UDim2.new(0, 0, 0, 0)
leftFrame3.BackgroundTransparency = 1
leftFrame3.Parent = tab3Content

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
rightFrame3.Parent = tab3Content

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
teleportToggle3.Font = Enum.Font.Gotham
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

local tab4Content = Instance.new("Frame")
tab4Content.Size = UDim2.new(1, -20, 1, -82)
tab4Content.Position = UDim2.new(0, 10, 0, 80)
tab4Content.BackgroundTransparency = 1
tab4Content.Visible = false
tab4Content.Parent = mainFrame

-- Column 1 (Destroyer Left)
local destroyerLeft = Instance.new("Frame")
destroyerLeft.Size = UDim2.new(0.34, 0, 1, 0)
destroyerLeft.BackgroundTransparency = 1
destroyerLeft.Parent = tab4Content

local destroyerToggle = Instance.new("TextButton")
destroyerToggle.Size = UDim2.new(1, 0, 0, 32)
destroyerToggle.BackgroundColor3 = COLORS.buttonDanger
destroyerToggle.TextColor3 = COLORS.textLight
destroyerToggle.Text = "DESTROY: OFF"
destroyerToggle.Font = Enum.Font.GothamBold
destroyerToggle.TextSize = 12
destroyerToggle.Parent = destroyerLeft

local destroyerToggleCorner = Instance.new("UICorner")
destroyerToggleCorner.CornerRadius = UDim.new(0, 6)
destroyerToggleCorner.Parent = destroyerToggle

local destroyerStatus = Instance.new("TextLabel")
destroyerStatus.Size = UDim2.new(1, 0, 0, 18)
destroyerStatus.Position = UDim2.new(0, 0, 0, 36)
destroyerStatus.BackgroundTransparency = 1
destroyerStatus.TextColor3 = COLORS.textMuted
destroyerStatus.Text = "No target"
destroyerStatus.Font = Enum.Font.Gotham
destroyerStatus.TextSize = 10
destroyerStatus.Parent = destroyerLeft

local destroyerTargetLabel = Instance.new("TextLabel")
destroyerTargetLabel.Size = UDim2.new(1, 0, 0, 16)
destroyerTargetLabel.Position = UDim2.new(0, 0, 0, 58)
destroyerTargetLabel.BackgroundTransparency = 1
destroyerTargetLabel.TextColor3 = COLORS.textDark
destroyerTargetLabel.Text = "Target:"
destroyerTargetLabel.Font = Enum.Font.GothamBold
destroyerTargetLabel.TextSize = 10
destroyerTargetLabel.TextXAlignment = Enum.TextXAlignment.Left
destroyerTargetLabel.Parent = destroyerLeft

local destroyerPlayerScroll = Instance.new("ScrollingFrame")
destroyerPlayerScroll.Size = UDim2.new(1, 0, 0, 130)
destroyerPlayerScroll.Position = UDim2.new(0, 0, 0, 78)
destroyerPlayerScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
destroyerPlayerScroll.ScrollBarThickness = 4
destroyerPlayerScroll.Parent = destroyerLeft

local destroyerScrollCorner = Instance.new("UICorner")
destroyerScrollCorner.CornerRadius = UDim.new(0, 6)
destroyerScrollCorner.Parent = destroyerPlayerScroll

local destroyerPlayerLayout = Instance.new("UIListLayout")
destroyerPlayerLayout.Padding = UDim.new(0, 2)
destroyerPlayerLayout.Parent = destroyerPlayerScroll

-- Column 2 (Destroyer Middle)
local destroyerMiddle = Instance.new("Frame")
destroyerMiddle.Size = UDim2.new(0.34, -4, 1, 0)
destroyerMiddle.Position = UDim2.new(0.34, 2, 0, 0)
destroyerMiddle.BackgroundTransparency = 1
destroyerMiddle.Parent = tab4Content

local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, 0, 0, 16)
modeLabel.BackgroundTransparency = 1
modeLabel.TextColor3 = COLORS.textDark
modeLabel.Text = "Mode:"
modeLabel.Font = Enum.Font.GothamBold
modeLabel.TextSize = 10
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = destroyerMiddle

local destroyerDevBtn = Instance.new("TextButton")
destroyerDevBtn.Size = UDim2.new(0.33, -1, 0, 22)
destroyerDevBtn.BackgroundColor3 = COLORS.buttonSuccess
destroyerDevBtn.TextColor3 = COLORS.textLight
destroyerDevBtn.Text = "✓ DEV"
destroyerDevBtn.Font = Enum.Font.GothamBold
destroyerDevBtn.TextSize = 9
destroyerDevBtn.Parent = destroyerMiddle

local destroyerDevCorner = Instance.new("UICorner")
destroyerDevCorner.CornerRadius = UDim.new(0, 4)
destroyerDevCorner.Parent = destroyerDevBtn

local destroyerOrbBtn = Instance.new("TextButton")
destroyerOrbBtn.Size = UDim2.new(0.33, -1, 0, 22)
destroyerOrbBtn.Position = UDim2.new(0.33, 1, 0, 0)
destroyerOrbBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
destroyerOrbBtn.TextColor3 = COLORS.textDark
destroyerOrbBtn.Text = "ORB"
destroyerOrbBtn.Font = Enum.Font.Gotham
destroyerOrbBtn.TextSize = 9
destroyerOrbBtn.Parent = destroyerMiddle

local destroyerOrbCorner = Instance.new("UICorner")
destroyerOrbCorner.CornerRadius = UDim.new(0, 4)
destroyerOrbCorner.Parent = destroyerOrbBtn

local destroyerChaosBtn = Instance.new("TextButton")
destroyerChaosBtn.Size = UDim2.new(0.34, -1, 0, 22)
destroyerChaosBtn.Position = UDim2.new(0.66, 2, 0, 0)
destroyerChaosBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
destroyerChaosBtn.TextColor3 = COLORS.textDark
destroyerChaosBtn.Text = "CHAOS"
destroyerChaosBtn.Font = Enum.Font.Gotham
destroyerChaosBtn.TextSize = 9
destroyerChaosBtn.Parent = destroyerMiddle

local destroyerChaosCorner = Instance.new("UICorner")
destroyerChaosCorner.CornerRadius = UDim.new(0, 4)
destroyerChaosCorner.Parent = destroyerChaosBtn

local destroyerSwordToggle = Instance.new("TextButton")
destroyerSwordToggle.Size = UDim2.new(0.5, -1, 0, 20)
destroyerSwordToggle.Position = UDim2.new(0, 0, 0, 26)
destroyerSwordToggle.BackgroundColor3 = COLORS.buttonSuccess
destroyerSwordToggle.TextColor3 = COLORS.textLight
destroyerSwordToggle.Text = "✓ Sword"
destroyerSwordToggle.Font = Enum.Font.Gotham
destroyerSwordToggle.TextSize = 9
destroyerSwordToggle.Parent = destroyerMiddle

local destroyerSwordCorner = Instance.new("UICorner")
destroyerSwordCorner.CornerRadius = UDim.new(0, 4)
destroyerSwordCorner.Parent = destroyerSwordToggle

local destroyerVelToggle = Instance.new("TextButton")
destroyerVelToggle.Size = UDim2.new(0.5, -1, 0, 20)
destroyerVelToggle.Position = UDim2.new(0.5, 1, 0, 26)
destroyerVelToggle.BackgroundColor3 = COLORS.buttonSuccess
destroyerVelToggle.TextColor3 = COLORS.textLight
destroyerVelToggle.Text = "✓ Velocity"
destroyerVelToggle.Font = Enum.Font.Gotham
destroyerVelToggle.TextSize = 9
destroyerVelToggle.Parent = destroyerMiddle

local destroyerVelCorner = Instance.new("UICorner")
destroyerVelCorner.CornerRadius = UDim.new(0, 4)
destroyerVelCorner.Parent = destroyerVelToggle

local destroyerAngToggle = Instance.new("TextButton")
destroyerAngToggle.Size = UDim2.new(0.5, -1, 0, 20)
destroyerAngToggle.Position = UDim2.new(0, 0, 0, 50)
destroyerAngToggle.BackgroundColor3 = COLORS.buttonSuccess
destroyerAngToggle.TextColor3 = COLORS.textLight
destroyerAngToggle.Text = "✓ Angular"
destroyerAngToggle.Font = Enum.Font.Gotham
destroyerAngToggle.TextSize = 9
destroyerAngToggle.Parent = destroyerMiddle

local destroyerAngCorner = Instance.new("UICorner")
destroyerAngCorner.CornerRadius = UDim.new(0, 4)
destroyerAngCorner.Parent = destroyerAngToggle

local destroyerTpToggle = Instance.new("TextButton")
destroyerTpToggle.Size = UDim2.new(0.5, -1, 0, 20)
destroyerTpToggle.Position = UDim2.new(0.5, 1, 0, 50)
destroyerTpToggle.BackgroundColor3 = COLORS.buttonSuccess
destroyerTpToggle.TextColor3 = COLORS.textLight
destroyerTpToggle.Text = "✓ Teleport"
destroyerTpToggle.Font = Enum.Font.Gotham
destroyerTpToggle.TextSize = 9
destroyerTpToggle.Parent = destroyerMiddle

local destroyerTpCorner = Instance.new("UICorner")
destroyerTpCorner.CornerRadius = UDim.new(0, 4)
destroyerTpCorner.Parent = destroyerTpToggle

local destroyerMassToggle = Instance.new("TextButton")
destroyerMassToggle.Size = UDim2.new(1, 0, 0, 20)
destroyerMassToggle.Position = UDim2.new(0, 0, 0, 74)
destroyerMassToggle.BackgroundColor3 = COLORS.buttonSuccess
destroyerMassToggle.TextColor3 = COLORS.textLight
destroyerMassToggle.Text = "✓ Mass Boost"
destroyerMassToggle.Font = Enum.Font.Gotham
destroyerMassToggle.TextSize = 9
destroyerMassToggle.Parent = destroyerMiddle

local destroyerMassCorner = Instance.new("UICorner")
destroyerMassCorner.CornerRadius = UDim.new(0, 4)
destroyerMassCorner.Parent = destroyerMassToggle

local destroyerPowerLabel = Instance.new("TextLabel")
destroyerPowerLabel.Size = UDim2.new(1, 0, 0, 16)
destroyerPowerLabel.Position = UDim2.new(0, 0, 0, 98)
destroyerPowerLabel.BackgroundTransparency = 1
destroyerPowerLabel.TextColor3 = COLORS.textDark
destroyerPowerLabel.Text = "Power:"
destroyerPowerLabel.Font = Enum.Font.GothamBold
destroyerPowerLabel.TextSize = 10
destroyerPowerLabel.TextXAlignment = Enum.TextXAlignment.Left
destroyerPowerLabel.Parent = destroyerMiddle

local destroyerVelInput = Instance.new("TextBox")
destroyerVelInput.Size = UDim2.new(0.5, -1, 0, 20)
destroyerVelInput.Position = UDim2.new(0, 0, 0, 116)
destroyerVelInput.BackgroundColor3 = COLORS.inputBg
destroyerVelInput.TextColor3 = COLORS.textDark
destroyerVelInput.Text = "999999"
destroyerVelInput.Font = Enum.Font.Gotham
destroyerVelInput.TextSize = 9
destroyerVelInput.PlaceholderText = "Vel"
destroyerVelInput.Parent = destroyerMiddle

local destroyerVelInputCorner = Instance.new("UICorner")
destroyerVelInputCorner.CornerRadius = UDim.new(0, 4)
destroyerVelInputCorner.Parent = destroyerVelInput

local destroyerAngInput = Instance.new("TextBox")
destroyerAngInput.Size = UDim2.new(0.5, -1, 0, 20)
destroyerAngInput.Position = UDim2.new(0.5, 1, 0, 116)
destroyerAngInput.BackgroundColor3 = COLORS.inputBg
destroyerAngInput.TextColor3 = COLORS.textDark
destroyerAngInput.Text = "999999"
destroyerAngInput.Font = Enum.Font.Gotham
destroyerAngInput.TextSize = 9
destroyerAngInput.PlaceholderText = "Ang"
destroyerAngInput.Parent = destroyerMiddle

local destroyerAngInputCorner = Instance.new("UICorner")
destroyerAngInputCorner.CornerRadius = UDim.new(0, 4)
destroyerAngInputCorner.Parent = destroyerAngInput

local destroyerSwingInput = Instance.new("TextBox")
destroyerSwingInput.Size = UDim2.new(0.5, -1, 0, 20)
destroyerSwingInput.Position = UDim2.new(0, 0, 0, 140)
destroyerSwingInput.BackgroundColor3 = COLORS.inputBg
destroyerSwingInput.TextColor3 = COLORS.textDark
destroyerSwingInput.Text = "3"
destroyerSwingInput.Font = Enum.Font.Gotham
destroyerSwingInput.TextSize = 9
destroyerSwingInput.PlaceholderText = "Swings"
destroyerSwingInput.Parent = destroyerMiddle

local destroyerSwingCorner = Instance.new("UICorner")
destroyerSwingCorner.CornerRadius = UDim.new(0, 4)
destroyerSwingCorner.Parent = destroyerSwingInput

local destroyerReachInput = Instance.new("TextBox")
destroyerReachInput.Size = UDim2.new(0.5, -1, 0, 20)
destroyerReachInput.Position = UDim2.new(0.5, 1, 0, 140)
destroyerReachInput.BackgroundColor3 = COLORS.inputBg
destroyerReachInput.TextColor3 = COLORS.textDark
destroyerReachInput.Text = "15"
destroyerReachInput.Font = Enum.Font.Gotham
destroyerReachInput.TextSize = 9
destroyerReachInput.PlaceholderText = "Reach"
destroyerReachInput.Parent = destroyerMiddle

local destroyerReachCorner = Instance.new("UICorner")
destroyerReachCorner.CornerRadius = UDim.new(0, 4)
destroyerReachCorner.Parent = destroyerReachInput

-- Column 3 (Destroyer Right)
local destroyerRight = Instance.new("Frame")
destroyerRight.Size = UDim2.new(0.32, -4, 1, 0)
destroyerRight.Position = UDim2.new(0.68, 2, 0, 0)
destroyerRight.BackgroundTransparency = 1
destroyerRight.Parent = tab4Content

local destroyerHowLabel = Instance.new("TextLabel")
destroyerHowLabel.Size = UDim2.new(1, 0, 0, 16)
destroyerHowLabel.BackgroundTransparency = 1
destroyerHowLabel.TextColor3 = COLORS.textDark
destroyerHowLabel.Text = "How to use:"
destroyerHowLabel.Font = Enum.Font.GothamBold
destroyerHowLabel.TextSize = 10
destroyerHowLabel.TextXAlignment = Enum.TextXAlignment.Left
destroyerHowLabel.Parent = destroyerRight

local destroyerInfo1 = Instance.new("TextLabel")
destroyerInfo1.Size = UDim2.new(1, 0, 0, 45)
destroyerInfo1.Position = UDim2.new(0, 0, 0, 18)
destroyerInfo1.BackgroundTransparency = 1
destroyerInfo1.TextColor3 = COLORS.textMuted
destroyerInfo1.Text = "1. Select target\n2. Toggle DESTROY ON\n3. Combo activates"
destroyerInfo1.Font = Enum.Font.Gotham
destroyerInfo1.TextSize = 9
destroyerInfo1.TextXAlignment = Enum.TextXAlignment.Left
destroyerInfo1.Parent = destroyerRight

local destroyerComboLabel = Instance.new("TextLabel")
destroyerComboLabel.Size = UDim2.new(1, 0, 0, 16)
destroyerComboLabel.Position = UDim2.new(0, 0, 0, 68)
destroyerComboLabel.BackgroundTransparency = 1
destroyerComboLabel.TextColor3 = COLORS.buttonPrimary
destroyerComboLabel.Text = "COMBO EFFECTS:"
destroyerComboLabel.Font = Enum.Font.GothamBold
destroyerComboLabel.TextSize = 10
destroyerComboLabel.TextXAlignment = Enum.TextXAlignment.Left
destroyerComboLabel.Parent = destroyerRight

local destroyerComboInfo = Instance.new("TextLabel")
destroyerComboInfo.Size = UDim2.new(1, 0, 0, 45)
destroyerComboInfo.Position = UDim2.new(0, 0, 0, 86)
destroyerComboInfo.BackgroundTransparency = 1
destroyerComboInfo.TextColor3 = COLORS.textMuted
destroyerComboInfo.Text = "• Fling into target\n• Auto-sword swing\n• Unavoidable combo"
destroyerComboInfo.Font = Enum.Font.Gotham
destroyerComboInfo.TextSize = 9
destroyerComboInfo.TextXAlignment = Enum.TextXAlignment.Left
destroyerComboInfo.Parent = destroyerRight

local destroyerDangerZone = Instance.new("Frame")
destroyerDangerZone.Size = UDim2.new(1, 0, 0, 55)
destroyerDangerZone.Position = UDim2.new(0, 0, 1, -57)
destroyerDangerZone.BackgroundColor3 = Color3.fromRGB(255, 235, 235)
destroyerDangerZone.Parent = destroyerRight

local destroyerDangerCorner = Instance.new("UICorner")
destroyerDangerCorner.CornerRadius = UDim.new(0, 6)
destroyerDangerCorner.Parent = destroyerDangerZone

local destroyerDangerLabel = Instance.new("TextLabel")
destroyerDangerLabel.Size = UDim2.new(1, 0, 0, 16)
destroyerDangerLabel.Position = UDim2.new(0, 0, 0, 4)
destroyerDangerLabel.BackgroundTransparency = 1
destroyerDangerLabel.TextColor3 = COLORS.buttonDanger
destroyerDangerLabel.Text = "⚠ DANGER ZONE"
destroyerDangerLabel.Font = Enum.Font.GothamBold
destroyerDangerLabel.TextSize = 10
destroyerDangerLabel.Parent = destroyerDangerZone

local destroyerKillGuiBtn = Instance.new("TextButton")
destroyerKillGuiBtn.Size = UDim2.new(1, -8, 0, 28)
destroyerKillGuiBtn.Position = UDim2.new(0, 4, 0, 23)
destroyerKillGuiBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
destroyerKillGuiBtn.TextColor3 = COLORS.textLight
destroyerKillGuiBtn.Text = "☠ KILL GUI"
destroyerKillGuiBtn.Font = Enum.Font.GothamBold
destroyerKillGuiBtn.TextSize = 11
destroyerKillGuiBtn.Parent = destroyerDangerZone

local destroyerKillCorner = Instance.new("UICorner")
destroyerKillCorner.CornerRadius = UDim.new(0, 5)
destroyerKillCorner.Parent = destroyerKillGuiBtn

-- ========== TAB 5: ANTI-AFK ==========

local tab5Content = Instance.new("Frame")
tab5Content.Size = UDim2.new(1, -20, 1, -82)
tab5Content.Position = UDim2.new(0, 10, 0, 80)
tab5Content.BackgroundTransparency = 1
tab5Content.Visible = false
tab5Content.Parent = mainFrame

local afkTitle = Instance.new("TextLabel")
afkTitle.Size = UDim2.new(1, 0, 0, 28)
afkTitle.Position = UDim2.new(0, 0, 0, 10)
afkTitle.BackgroundTransparency = 1
afkTitle.TextColor3 = COLORS.textDark
afkTitle.Text = "Anti-AFK Protection"
afkTitle.Font = Enum.Font.GothamBold
afkTitle.TextSize = 16
afkTitle.Parent = tab5Content

local afkToggle = Instance.new("TextButton")
afkToggle.Size = UDim2.new(0.7, 0, 0, 50)
afkToggle.Position = UDim2.new(0.15, 0, 0, 55)
afkToggle.BackgroundColor3 = COLORS.buttonDanger
afkToggle.TextColor3 = COLORS.textLight
afkToggle.Text = "ANTI-AFK: OFF"
afkToggle.Font = Enum.Font.GothamBold
afkToggle.TextSize = 15
afkToggle.Parent = tab5Content

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
afkInfo.Parent = tab5Content

local afkStatus = Instance.new("TextLabel")
afkStatus.Size = UDim2.new(1, 0, 0, 22)
afkStatus.Position = UDim2.new(0, 0, 1, -25)
afkStatus.BackgroundTransparency = 1
afkStatus.TextColor3 = COLORS.buttonPrimary
afkStatus.Text = "Status: Inactive"
afkStatus.Font = Enum.Font.Gotham
afkStatus.TextSize = 11
afkStatus.Parent = tab5Content

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
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInput
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

hubButton.MouseButton1Click:Connect(function()
    wait(0.05)
    if not dragging then
        hubButton.Visible = false
        mainFrame.Visible = true
    end
end)

-- DRAGGING MAIN FRAME
local mfDragging = false
local mfDragInput, mfDragStart, mfDragPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mfDragging = true
        mfDragStart = input.Position
        mfDragPos = mainFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        mfDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == mfDragInput and mfDragging then
        local delta = input.Position - mfDragStart
        mainFrame.Position = UDim2.new(mfDragPos.X.Scale, mfDragPos.X.Offset + delta.X, mfDragPos.Y.Scale, mfDragPos.Y.Offset + delta.Y)
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mfDragging = false
    end
end)

collapseButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

-- ========== TAB SWITCHING ==========

local function switchTab(tabIndex)
    -- Hide all tabs
    tab1Content.Visible = false
    tab2Content.Visible = false
    tab3Content.Visible = false
    tab4Content.Visible = false
    tab5Content.Visible = false
    
    -- Reset all tab colors
    for i, tabBtn in ipairs(tabButtons) do
        tabBtn.BackgroundColor3 = COLORS.tabInactive
        tabBtn.TextColor3 = COLORS.textDark
    end
    
    -- Activate selected tab
    tabButtons[tabIndex].BackgroundColor3 = COLORS.tabActive
    tabButtons[tabIndex].TextColor3 = COLORS.textLight
    
    -- Show selected tab content
    if tabIndex == 1 then
        tab1Content.Visible = true
    elseif tabIndex == 2 then
        tab2Content.Visible = true
    elseif tabIndex == 3 then
        tab3Content.Visible = true
    elseif tabIndex == 4 then
        tab4Content.Visible = true
    else
        tab5Content.Visible = true
    end
end

-- Connect tab buttons
for i, tabBtn in ipairs(tabButtons) do
    tabBtn.MouseButton1Click:Connect(function()
        switchTab(i)
    end)
end

-- ========== FLING SCRIPT (TAB 1 - UNCHANGED LOGIC) ==========

local flingEnabled = false
local targetPlayer1 = nil
local flingLoop = nil
local flingCount = 0
local bodyAngularVel = nil
local bodyVel = nil
local playerButtons1 = {}

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function updatePlayerList1()
    for _, btn in pairs(playerButtons1) do
        btn:Destroy()
    end
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
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = btn
            
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
    if flingLoop then
        flingLoop:Disconnect()
        flingLoop = nil
    end
    
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

local function startFling1()
    if flingLoop then
        flingLoop:Disconnect()
    end
    
    local myChar = player.Character
    if not myChar then return end
    
    local myRoot = getRoot(myChar)
    local myHumanoid = myChar:FindFirstChild("Humanoid")
    
    if not myRoot then return end
    
    local spinPower = tonumber(spinInput.Text) or 999999
    local launchPower = tonumber(launchInput.Text) or 999999
    
    if bodyAngularVel then bodyAngularVel:Destroy() end
    bodyAngularVel = Instance.new("BodyAngularVelocity")
    bodyAngularVel.Name = "FlingSpin"
    bodyAngularVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyAngularVel.AngularVelocity = Vector3.new(spinPower, spinPower, spinPower)
    bodyAngularVel.P = math.huge
    bodyAngularVel.Parent = myRoot
    
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
    
    flingLoop = RunService.Heartbeat:Connect(function()
        if not flingEnabled then return end
        
        local char = player.Character
        if not char then return end
        
        local root = getRoot(char)
        if not root then return end
        
        if not targetPlayer1 or not targetPlayer1.Character then
            return
        end
        
        local targetRoot = getRoot(targetPlayer1.Character)
        if not targetRoot then return end
        
        root.CFrame = targetRoot.CFrame
        
        if not root:FindFirstChild("FlingSpin") then
            bodyAngularVel = Instance.new("BodyAngularVelocity")
            bodyAngularVel.Name = "FlingSpin"
            bodyAngularVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyAngularVel.AngularVelocity = Vector3.new(spinPower, spinPower, spinPower)
            bodyAngularVel.P = math.huge
            bodyAngularVel.Parent = root
        end
        
        if not root:FindFirstChild("FlingLaunch") then
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.Name = "FlingLaunch"
            bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVel.Velocity = Vector3.new(0, launchPower, 0)
            bodyVel.P = math.huge
            bodyVel.Parent = root
        end
    end)
end

toggleButton1.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    
    if flingEnabled then
        toggleButton1.Text = "FLING: ON"
        toggleButton1.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel1.Text = targetPlayer1 and ("Flinging: " .. targetPlayer1.Name) or "No target selected"
        
        startFling1()
    else
        toggleButton1.Text = "FLING: OFF"
        toggleButton1.BackgroundColor3 = COLORS.buttonDanger
        statusLabel1.Text = targetPlayer1 and ("Target: " .. targetPlayer1.Name) or "No target selected"
        
        stopFling1()
    end
end)

player.CharacterAdded:Connect(function(char)
    wait(0.3)
    
    if flingEnabled then
        flingCount = flingCount + 1
        flingCounter.Text = "Flings: " .. flingCount
        startFling1()
    end
end)

player.CharacterRemoving:Connect(function()
    stopFling1()
end)

Players.PlayerAdded:Connect(updatePlayerList1)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerList1()
end)

updatePlayerList1()

-- ========== TP KILL SCRIPT (TAB 2 - UNCHANGED LOGIC) ==========

local killEnabled = false
local targetPlayer2 = nil
local attackDelay = 0.05
local swingsPerAttack = 3
local checkRate = 0.1
local playerButtons2 = {}

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

local function hasProtection(targetPlr)
    if not targetPlr or not targetPlr.Character then return false end
    local forceField = targetPlr.Character:FindFirstChild("ForceField")
    return forceField ~= nil
end

local function updatePlayerList2()
    for _, btn in pairs(playerButtons2) do
        btn:Destroy()
    end
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
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = btn
            
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

local function attackTarget()
    if not targetPlayer2 then return end
    
    local myChar = player.Character
    local myHum = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar and myChar:FindFirstChild("Humanoid")
    
    local targetChar = targetPlayer2.Character
    local targetHum = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = targetChar and targetChar:FindFirstChild("Humanoid")
    
    if not myHum or not myHumanoid or not targetHum or not targetHumanoid then
        return
    end
    
    if targetHumanoid.Health <= 0 then
        return
    end
    
    local sword = getSword()
    if not sword then
        sword = equipSword()
    end
    
    myHum.CFrame = targetHum.CFrame * CFrame.new(0, 0, 2)
    
    if sword then
        for i = 1, swingsPerAttack do
            sword:Activate()
            wait(0.01)
        end
    end
end

toggleButton2.MouseButton1Click:Connect(function()
    killEnabled = not killEnabled
    attackDelay = tonumber(delayInput.Text) or 0.05
    if attackDelay < 0.01 then attackDelay = 0.01 end
    
    swingsPerAttack = tonumber(swingsInput.Text) or 3
    if swingsPerAttack < 1 then swingsPerAttack = 1 end
    if swingsPerAttack > 10 then swingsPerAttack = 10 end
    
    checkRate = tonumber(checkInput.Text) or 0.1
    if checkRate < 0.05 then checkRate = 0.05 end
    
    if killEnabled then
        toggleButton2.Text = "KILL AURA: ON"
        toggleButton2.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel2.Text = targetPlayer2 and ("Hunting: " .. targetPlayer2.Name) or "No target selected"
        
        equipSword()
        
        spawn(function()
            while killEnabled do
                if targetPlayer2 and targetPlayer2.Character then
                    local targetHumanoid = targetPlayer2.Character:FindFirstChild("Humanoid")
                    
                    if targetHumanoid then
                        if targetHumanoid.Health > 0 then
                            if hasProtection(targetPlayer2) then
                                protectionLabel.Text = "Protection: TARGET PROTECTED"
                                protectionLabel.TextColor3 = COLORS.buttonWarning
                                statusLabel2.Text = "Waiting for target protection to end..."
                            else
                                protectionLabel.Text = "Protection: TARGET VULNERABLE"
                                protectionLabel.TextColor3 = COLORS.buttonSuccess
                                statusLabel2.Text = "ATTACKING!"
                                
                                attackTarget()
                                wait(attackDelay)
                            end
                        else
                            protectionLabel.Text = "Protection: Target dead"
                            protectionLabel.TextColor3 = COLORS.textMuted
                            statusLabel2.Text = "Waiting for target respawn..."
                        end
                    else
                        protectionLabel.Text = "Protection: No humanoid"
                        protectionLabel.TextColor3 = COLORS.textMuted
                    end
                else
                    protectionLabel.Text = "Protection: No target"
                    protectionLabel.TextColor3 = COLORS.textMuted
                    statusLabel2.Text = "Target left or respawning..."
                end
                
                wait(checkRate)
            end
        end)
    else
        toggleButton2.Text = "KILL AURA: OFF"
        toggleButton2.BackgroundColor3 = COLORS.buttonDanger
        statusLabel2.Text = targetPlayer2 and ("Target: " .. targetPlayer2.Name) or "No target selected"
        protectionLabel.Text = "Protection: Waiting..."
        protectionLabel.TextColor3 = COLORS.textMuted
    end
end)

player.CharacterAdded:Connect(function()
    wait(1)
    if killEnabled then
        equipSword()
    end
end)

Players.PlayerAdded:Connect(updatePlayerList2)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerList2()
end)

updatePlayerList2()

-- ========== ULTIMATE COLLISION FLING (TAB 3 - UNCHANGED LOGIC) ==========

local flingEnabled3 = false
local targetPlayer3 = nil
local flingLoop3 = nil
local flingCount3 = 0
local playerButtons3 = {}

-- Power Settings
local teleportMultiplier = 1
local velocityPower3 = 999999
local angularPower3 = 999999
local collisionMode = "devastate"

-- Toggle states
local velocityEnabled3 = true
local angularEnabled3 = true
local teleportEnabled3 = true
local massEnabled3 = true

local bodyVel3 = nil
local bodyAngVel3 = nil
local angle = 0

local function getRoot3(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function boostMass3(char)
    if not massEnabled3 then return end
    
    local root = getRoot3(char)
    if not root then return end
    
    root.CustomPhysicalProperties = PhysicalProperties.new(100, 0.5, 0.5)
end

local function resetMass3(char)
    local root = getRoot3(char)
    if root then
        root.CustomPhysicalProperties = nil
    end
end

local function updatePlayerList3()
    for _, btn in pairs(playerButtons3) do
        btn:Destroy()
    end
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
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn
            
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
    if flingLoop3 then
        flingLoop3:Disconnect()
        flingLoop3 = nil
    end
    
    if bodyVel3 then
        bodyVel3:Destroy()
        bodyVel3 = nil
    end
    
    if bodyAngVel3 then
        bodyAngVel3:Destroy()
        bodyAngVel3 = nil
    end
    
    local myChar = player.Character
    if myChar then
        local myRoot = getRoot3(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        
        if myRoot then
            myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
        
        if myHumanoid then
            myHumanoid.PlatformStand = false
        end
        
        resetMass3(myChar)
    end
end

local function devastateFling(targetRoot, myRoot, myHumanoid)
    velocityPower3 = tonumber(velocityInput3.Text) or 999999
    angularPower3 = tonumber(angularInput3.Text) or 999999
    
    if massEnabled3 then
        boostMass3(player.Character)
    end
    
    if teleportEnabled3 then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
    end
    
    if velocityEnabled3 then
        if bodyVel3 then bodyVel3:Destroy() end
        bodyVel3 = Instance.new("BodyVelocity")
        bodyVel3.Name = "CollisionBurst"
        bodyVel3.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel3.Velocity = Vector3.new(math.random(-1, 1) * velocityPower3, velocityPower3, math.random(-1, 1) * velocityPower3)
        bodyVel3.P = math.huge
        bodyVel3.Parent = myRoot
    end
    
    if angularEnabled3 then
        if bodyAngVel3 then bodyAngVel3:Destroy() end
        bodyAngVel3 = Instance.new("BodyAngularVelocity")
        bodyAngVel3.Name = "CollisionSpin"
        bodyAngVel3.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel3.AngularVelocity = Vector3.new(angularPower3, angularPower3, angularPower3)
        bodyAngVel3.P = math.huge
        bodyAngVel3.Parent = myRoot
    end
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

local function orbitalFling(targetRoot, myRoot, myHumanoid)
    velocityPower3 = tonumber(velocityInput3.Text) or 999999
    angularPower3 = tonumber(angularInput3.Text) or 999999
    teleportMultiplier = tonumber(teleportInput3.Text) or 500
    
    angle = angle + (math.pi * 2 / teleportMultiplier)
    
    local offsetX = math.cos(angle) * 2
    local offsetZ = math.sin(angle) * 2
    
    if massEnabled3 then
        boostMass3(player.Character)
    end
    
    if teleportEnabled3 then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(offsetX, 1, offsetZ)
    end
    
    if velocityEnabled3 then
        local direction = (targetRoot.Position - myRoot.Position).Unit
        
        if bodyVel3 then bodyVel3:Destroy() end
        bodyVel3 = Instance.new("BodyVelocity")
        bodyVel3.Name = "CollisionBurst"
        bodyVel3.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel3.Velocity = direction * velocityPower3
        bodyVel3.P = math.huge
        bodyVel3.Parent = myRoot
    end
    
    if angularEnabled3 then
        if bodyAngVel3 then bodyAngVel3:Destroy() end
        bodyAngVel3 = Instance.new("BodyAngularVelocity")
        bodyAngVel3.Name = "CollisionSpin"
        bodyAngVel3.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel3.AngularVelocity = Vector3.new(angularPower3, angularPower3, angularPower3)
        bodyAngVel3.P = math.huge
        bodyAngVel3.Parent = myRoot
    end
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

local function chaosFling(targetRoot, myRoot, myHumanoid)
    velocityPower3 = tonumber(velocityInput3.Text) or 999999
    angularPower3 = tonumber(angularInput3.Text) or 999999
    
    if massEnabled3 then
        boostMass3(player.Character)
    end
    
    if teleportEnabled3 then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(
            math.random(-3, 3),
            math.random(-2, 2),
            math.random(-3, 3)
        )
    end
    
    if velocityEnabled3 then
        if bodyVel3 then bodyVel3:Destroy() end
        bodyVel3 = Instance.new("BodyVelocity")
        bodyVel3.Name = "CollisionBurst"
        bodyVel3.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel3.Velocity = Vector3.new(
            math.random(-1, 1) * velocityPower3,
            math.random(-1, 1) * velocityPower3,
            math.random(-1, 1) * velocityPower3
        )
        bodyVel3.P = math.huge
        bodyVel3.Parent = myRoot
    end
    
    if angularEnabled3 then
        if bodyAngVel3 then bodyAngVel3:Destroy() end
        bodyAngVel3 = Instance.new("BodyAngularVelocity")
        bodyAngVel3.Name = "CollisionSpin"
        bodyAngVel3.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel3.AngularVelocity = Vector3.new(
            math.random(-1, 1) * angularPower3,
            math.random(-1, 1) * angularPower3,
            math.random(-1, 1) * angularPower3
        )
        bodyAngVel3.P = math.huge
        bodyAngVel3.Parent = myRoot
    end
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

local function startFling3()
    if flingLoop3 then
        flingLoop3:Disconnect()
    end
    
    flingLoop3 = RunService.Heartbeat:Connect(function()
        if not flingEnabled3 then return end
        
        local myChar = player.Character
        if not myChar then return end
        
        local myRoot = getRoot3(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        
        if not myRoot then return end
        
        if not targetPlayer3 or not targetPlayer3.Character then
            return
        end
        
        local targetRoot = getRoot3(targetPlayer3.Character)
        if not targetRoot then return end
        
        if collisionMode == "devastate" then
            devastateFling(targetRoot, myRoot, myHumanoid)
        elseif collisionMode == "orbital" then
            orbitalFling(targetRoot, myRoot, myHumanoid)
        else
            chaosFling(targetRoot, myRoot, myHumanoid)
        end
    end)
end

-- Mode Buttons
devastateModeBtn.MouseButton1Click:Connect(function()
    collisionMode = "devastate"
    devastateModeBtn.Text = "✓ DEVASTATE"
    devastateModeBtn.BackgroundColor3 = COLORS.buttonSuccess
    devastateModeBtn.TextColor3 = COLORS.textLight
    orbitalModeBtn.Text = "Orbital"
    orbitalModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    orbitalModeBtn.TextColor3 = COLORS.textDark
    chaosModeBtn.Text = "Chaos"
    chaosModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    chaosModeBtn.TextColor3 = COLORS.textDark
end)

orbitalModeBtn.MouseButton1Click:Connect(function()
    collisionMode = "orbital"
    orbitalModeBtn.Text = "✓ Orbital"
    orbitalModeBtn.BackgroundColor3 = COLORS.buttonSuccess
    orbitalModeBtn.TextColor3 = COLORS.textLight
    devastateModeBtn.Text = "DEVASTATE"
    devastateModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    devastateModeBtn.TextColor3 = COLORS.textDark
    chaosModeBtn.Text = "Chaos"
    chaosModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    chaosModeBtn.TextColor3 = COLORS.textDark
end)

chaosModeBtn.MouseButton1Click:Connect(function()
    collisionMode = "chaos"
    chaosModeBtn.Text = "✓ Chaos"
    chaosModeBtn.BackgroundColor3 = COLORS.buttonSuccess
    chaosModeBtn.TextColor3 = COLORS.textLight
    devastateModeBtn.Text = "DEVASTATE"
    devastateModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    devastateModeBtn.TextColor3 = COLORS.textDark
    orbitalModeBtn.Text = "Orbital"
    orbitalModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    orbitalModeBtn.TextColor3 = COLORS.textDark
end)

-- Layer Toggles
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

-- Fling Toggle
toggleButton3.MouseButton1Click:Connect(function()
    flingEnabled3 = not flingEnabled3
    
    if flingEnabled3 then
        if not targetPlayer3 then
            statusLabel3.Text = "Select a target first!"
            flingEnabled3 = false
            return
        end
        
        toggleButton3.Text = "FLING: ON"
        toggleButton3.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel3.Text = "Flinging: " .. targetPlayer3.Name .. " (" .. collisionMode:upper() .. ")"
        
        startFling3()
    else
        toggleButton3.Text = "FLING: OFF"
        toggleButton3.BackgroundColor3 = COLORS.buttonDanger
        statusLabel3.Text = targetPlayer3 and ("Target: " .. targetPlayer3.Name) or "No target selected"
        
        stopFling3()
    end
end)

player.CharacterAdded:Connect(function()
    wait(0.3)
    
    if flingEnabled3 then
        flingCount3 = flingCount3 + 1
        flingCounter3.Text = "Flings: " .. flingCount3
        startFling3()
    end
end)

player.CharacterRemoving:Connect(function()
    stopFling3()
end)

Players.PlayerAdded:Connect(updatePlayerList3)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerList3()
end)

updatePlayerList3()

-- ========== TAB 4: COMBO DESTROYER LOGIC ==========

-- Variables for Tab 4
local destroyEnabled = false
local targetPlayer4 = nil
local flingCount4 = 0
local velocityPower4 = 999999
local angularPower4 = 999999
local collisionMode4 = "devastate"
local swordSwings = 3
local swingDelay = 0.01
local swordReach = 15
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

local function getRoot4(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function getSword4()
    local character = player.Character
    if not character then return nil end
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") then
            return item
        end
    end
    return nil
end

local function equipSword4()
    local character = player.Character
    local backpack = player:FindFirstChild("Backpack")
    if not character or not backpack then return nil end
    local currentTool = getSword4()
    if currentTool then return currentTool end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return nil end
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            humanoid:EquipTool(item)
            wait(0.05)
            return item
        end
    end
    return nil
end

local function boostMass4(char)
    if not massEnabled4 then return end
    local root = getRoot4(char)
    if root then
        root.CustomPhysicalProperties = PhysicalProperties.new(100, 0.5, 0.5)
    end
end

local function resetMass4(char)
    local root = getRoot4(char)
    if root then
        root.CustomPhysicalProperties = nil
    end
end

local function updatePlayerList4()
    for _, btn in pairs(playerButtons4) do
        btn:Destroy()
    end
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
            btn.Parent = destroyerPlayerScroll
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                targetPlayer4 = plr
                destroyerStatus.Text = "Target: " .. plr.Name
                updatePlayerList4()
            end)
            
            table.insert(playerButtons4, btn)
        end
    end
    
    destroyerPlayerScroll.CanvasSize = UDim2.new(0, 0, 0, #playerButtons4 * 22)
end

local function devastateFling4(targetRoot, myRoot, myHumanoid)
    velocityPower4 = tonumber(destroyerVelInput.Text) or 999999
    angularPower4 = tonumber(destroyerAngInput.Text) or 999999
    
    if massEnabled4 then boostMass4(player.Character) end
    if teleportEnabled4 then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
    end
    if velocityEnabled4 then
        if bodyVel4 then bodyVel4:Destroy() end
        bodyVel4 = Instance.new("BodyVelocity")
        bodyVel4.Name = "DestroyerBurst"
        bodyVel4.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel4.Velocity = Vector3.new(math.random(-1, 1) * velocityPower4, velocityPower4, math.random(-1, 1) * velocityPower4)
        bodyVel4.P = math.huge
        bodyVel4.Parent = myRoot
    end
    if angularEnabled4 then
        if bodyAngVel4 then bodyAngVel4:Destroy() end
        bodyAngVel4 = Instance.new("BodyAngularVelocity")
        bodyAngVel4.Name = "DestroyerSpin"
        bodyAngVel4.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel4.AngularVelocity = Vector3.new(angularPower4, angularPower4, angularPower4)
        bodyAngVel4.P = math.huge
        bodyAngVel4.Parent = myRoot
    end
    if myHumanoid then myHumanoid.PlatformStand = true end
end

local function orbitalFling4(targetRoot, myRoot, myHumanoid)
    velocityPower4 = tonumber(destroyerVelInput.Text) or 999999
    angularPower4 = tonumber(destroyerAngInput.Text) or 999999
    
    angle4 = angle4 + (math.pi * 2 / 500)
    local offsetX = math.cos(angle4) * 2
    local offsetZ = math.sin(angle4) * 2
    
    if massEnabled4 then boostMass4(player.Character) end
    if teleportEnabled4 then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(offsetX, 1, offsetZ)
    end
    if velocityEnabled4 then
        local direction = (targetRoot.Position - myRoot.Position).Unit
        if bodyVel4 then bodyVel4:Destroy() end
        bodyVel4 = Instance.new("BodyVelocity")
        bodyVel4.Name = "DestroyerBurst"
        bodyVel4.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel4.Velocity = direction * velocityPower4
        bodyVel4.P = math.huge
        bodyVel4.Parent = myRoot
    end
    if angularEnabled4 then
        if bodyAngVel4 then bodyAngVel4:Destroy() end
        bodyAngVel4 = Instance.new("BodyAngularVelocity")
        bodyAngVel4.Name = "DestroyerSpin"
        bodyAngVel4.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel4.AngularVelocity = Vector3.new(angularPower4, angularPower4, angularPower4)
        bodyAngVel4.P = math.huge
        bodyAngVel4.Parent = myRoot
    end
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

local function chaosFling4(targetRoot, myRoot, myHumanoid)
    velocityPower4 = tonumber(destroyerVelInput.Text) or 999999
    angularPower4 = tonumber(destroyerAngInput.Text) or 999999
    
    if massEnabled4 then
        boostMass4(player.Character)
    end
    
    if teleportEnabled4 then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(
            math.random(-3, 3),
            math.random(-2, 2),
            math.random(-3, 3)
        )
    end
    
    if velocityEnabled4 then
        if bodyVel4 then bodyVel4:Destroy() end
        bodyVel4 = Instance.new("BodyVelocity")
        bodyVel4.Name = "DestroyerBurst"
        bodyVel4.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel4.Velocity = Vector3.new(
            math.random(-1, 1) * velocityPower4,
            math.random(-1, 1) * velocityPower4,
            math.random(-1, 1) * velocityPower4
        )
        bodyVel4.P = math.huge
        bodyVel4.Parent = myRoot
    end
    
    if angularEnabled4 then
        if bodyAngVel4 then bodyAngVel4:Destroy() end
        bodyAngVel4 = Instance.new("BodyAngularVelocity")
        bodyAngVel4.Name = "DestroyerSpin"
        bodyAngVel4.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel4.AngularVelocity = Vector3.new(
            math.random(-1, 1) * angularPower4,
            math.random(-1, 1) * angularPower4,
            math.random(-1, 1) * angularPower4
        )
        bodyAngVel4.P = math.huge
        bodyAngVel4.Parent = myRoot
    end
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

local function performSwordAttack()
    if not swordEnabled4 then return end
    
    local sword = getSword4()
    if not sword then
        sword = equipSword4()
    end
    
    if sword then
        swordSwings = tonumber(destroyerSwingInput.Text) or 3
        if swordSwings < 1 then swordSwings = 1 end
        if swordSwings > 10 then swordSwings = 10 end
        
        swordReach = tonumber(destroyerReachInput.Text) or 15
        if swordReach < 1 then swordReach = 1 end
        if swordReach > 50 then swordReach = 50 end
        
        for i = 1, swordSwings do
            sword:Activate()
            wait(swingDelay)
        end
    end
end

local function startFling4()
    if flingLoop4 then
        flingLoop4:Disconnect()
    end
    
    flingLoop4 = RunService.Heartbeat:Connect(function()
        if not destroyEnabled then return end
        
        local myChar = player.Character
        if not myChar then return end
        
        local myRoot = getRoot4(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        
        if not myRoot then return end
        
        if not targetPlayer4 or not targetPlayer4.Character then
            return
        end
        
        local targetRoot = getRoot4(targetPlayer4.Character)
        if not targetRoot then return end
        
        if collisionMode4 == "devastate" then
            devastateFling4(targetRoot, myRoot, myHumanoid)
        elseif collisionMode4 == "orbital" then
            orbitalFling4(targetRoot, myRoot, myHumanoid)
        else
            chaosFling4(targetRoot, myRoot, myHumanoid)
        end
        
        performSwordAttack()
    end)
end

local function stopFling4()
    if flingLoop4 then
        flingLoop4:Disconnect()
        flingLoop4 = nil
    end
    
    if bodyVel4 then
        bodyVel4:Destroy()
        bodyVel4 = nil
    end
    
    if bodyAngVel4 then
        bodyAngVel4:Destroy()
        bodyAngVel4 = nil
    end
    
    local myChar = player.Character
    if myChar then
        local myRoot = getRoot4(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        
        if myRoot then
            myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
        
        if myHumanoid then
            myHumanoid.PlatformStand = false
        end
        
        resetMass4(myChar)
    end
end

-- Destroyer Mode Buttons
destroyerDevBtn.MouseButton1Click:Connect(function()
    collisionMode4 = "devastate"
    destroyerDevBtn.Text = "✓ DEV"
    destroyerDevBtn.BackgroundColor3 = COLORS.buttonSuccess
    destroyerDevBtn.TextColor3 = COLORS.textLight
    destroyerOrbBtn.Text = "ORB"
    destroyerOrbBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    destroyerOrbBtn.TextColor3 = COLORS.textDark
    destroyerChaosBtn.Text = "CHAOS"
    destroyerChaosBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    destroyerChaosBtn.TextColor3 = COLORS.textDark
end)

destroyerOrbBtn.MouseButton1Click:Connect(function()
    collisionMode4 = "orbital"
    destroyerOrbBtn.Text = "✓ ORB"
    destroyerOrbBtn.BackgroundColor3 = COLORS.buttonSuccess
    destroyerOrbBtn.TextColor3 = COLORS.textLight
    destroyerDevBtn.Text = "DEV"
    destroyerDevBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    destroyerDevBtn.TextColor3 = COLORS.textDark
    destroyerChaosBtn.Text = "CHAOS"
    destroyerChaosBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    destroyerChaosBtn.TextColor3 = COLORS.textDark
end)

destroyerChaosBtn.MouseButton1Click:Connect(function()
    collisionMode4 = "chaos"
    destroyerChaosBtn.Text = "✓ CHAOS"
    destroyerChaosBtn.BackgroundColor3 = COLORS.buttonSuccess
    destroyerChaosBtn.TextColor3 = COLORS.textLight
    destroyerDevBtn.Text = "DEV"
    destroyerDevBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    destroyerDevBtn.TextColor3 = COLORS.textDark
    destroyerOrbBtn.Text = "ORB"
    destroyerOrbBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    destroyerOrbBtn.TextColor3 = COLORS.textDark
end)

-- Destroyer Layer Toggles
destroyerSwordToggle.MouseButton1Click:Connect(function()
    swordEnabled4 = not swordEnabled4
    destroyerSwordToggle.Text = swordEnabled4 and "✓ Sword" or "✗ Sword"
    destroyerSwordToggle.BackgroundColor3 = swordEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

destroyerVelToggle.MouseButton1Click:Connect(function()
    velocityEnabled4 = not velocityEnabled4
    destroyerVelToggle.Text = velocityEnabled4 and "✓ Velocity" or "✗ Velocity"
    destroyerVelToggle.BackgroundColor3 = velocityEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

destroyerAngToggle.MouseButton1Click:Connect(function()
    angularEnabled4 = not angularEnabled4
    destroyerAngToggle.Text = angularEnabled4 and "✓ Angular" or "✗ Angular"
    destroyerAngToggle.BackgroundColor3 = angularEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

destroyerTpToggle.MouseButton1Click:Connect(function()
    teleportEnabled4 = not teleportEnabled4
    destroyerTpToggle.Text = teleportEnabled4 and "✓ Teleport" or "✗ Teleport"
    destroyerTpToggle.BackgroundColor3 = teleportEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

destroyerMassToggle.MouseButton1Click:Connect(function()
    massEnabled4 = not massEnabled4
    destroyerMassToggle.Text = massEnabled4 and "✓ Mass Boost" or "✗ Mass Boost"
    destroyerMassToggle.BackgroundColor3 = massEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

-- Destroyer Toggle
destroyerToggle.MouseButton1Click:Connect(function()
    destroyEnabled = not destroyEnabled
    
    if destroyEnabled then
        if not targetPlayer4 then
            destroyerStatus.Text = "Select a target first!"
            destroyEnabled = false
            return
        end
        
        destroyerToggle.Text = "DESTROY: ON"
        destroyerToggle.BackgroundColor3 = COLORS.buttonSuccess
        destroyerStatus.Text = "Destroying: " .. targetPlayer4.Name .. " (" .. collisionMode4:upper() .. ")"
        
        -- Ensure we have a sword if enabled
        if swordEnabled4 then
            equipSword4()
        end
        
        startFling4()
    else
        destroyerToggle.Text = "DESTROY: OFF"
        destroyerToggle.BackgroundColor3 = COLORS.buttonDanger
        destroyerStatus.Text = targetPlayer4 and ("Target: " .. targetPlayer4.Name) or "No target"
        
        stopFling4()
    end
end)

-- Kill GUI Button
destroyerKillGuiBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    script.Parent:Destroy()
end)

player.CharacterAdded:Connect(function()
    wait(0.3)
    
    if destroyEnabled then
        flingCount4 = flingCount4 + 1
        startFling4()
        if swordEnabled4 then
            equipSword4()
        end
    end
end)

player.CharacterRemoving:Connect(function()
    stopFling4()
end)

Players.PlayerAdded:Connect(updatePlayerList4)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerList4()
end)

updatePlayerList4()

-- ========== TAB 5: ANTI-AFK LOGIC ==========

local antiAFKEnabled = false
local antiAFKConnection = nil

local function simulateActivity()
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            -- Simulate movement
            humanoid:Move(Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)))
            
            -- Simulate camera movement
            local camera = workspace.CurrentCamera
            if camera then
                local currentCF = camera.CFrame
                camera.CFrame = currentCF * CFrame.Angles(math.rad(1), 0, 0)
                wait(0.01)
                camera.CFrame = currentCF
            end
        end
    end
end

afkToggle.MouseButton1Click:Connect(function()
    antiAFKEnabled = not antiAFKEnabled
    
    if antiAFKEnabled then
        afkToggle.Text = "ANTI-AFK: ON"
        afkToggle.BackgroundColor3 = COLORS.buttonSuccess
        afkStatus.Text = "Status: Active"
        
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
        end
        
        antiAFKConnection = RunService.Heartbeat:Connect(function()
            wait(60) -- Run every 60 seconds
            simulateActivity()
        end)
        
        -- Run immediately once
        simulateActivity()
    else
        afkToggle.Text = "ANTI-AFK: OFF"
        afkToggle.BackgroundColor3 = COLORS.buttonDanger
        afkStatus.Text = "Status: Inactive"
        
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
            antiAFKConnection = nil
        end
    end
end)

-- ========== INITIALIZATION ==========

-- Set initial tab
switchTab(1)

-- Position GUI
local screenSize = game:GetService("GuiService"):GetScreenResolution()
hubButton.Position = UDim2.new(0, screenSize.X - 70, 0, screenSize.Y/2 - 35)
mainFrame.Position = UDim2.new(0, screenSize.X/2 - 200, 0, screenSize.Y/2 - 200)

-- Ensure GUI is visible
screenGui.Parent = game:GetService("CoreGui") or game:GetService("StarterGui")
hubButton.Visible = true

-- Display welcome message
print("🗡️ Combo Destroyer GUI Loaded!")
print("✨ Features:")
print("  • Tab 1: Classic Fling (simple velocity fling)")
print("  • Tab 2: Teleport Kill (sword-based attacks)")
print("  • Tab 3: Collision Fling (multiple fling modes)")
print("  • Tab 4: Combo Destroyer (all-in-one)")
print("  • Tab 5: Anti-AFK (prevent inactivity kick)")
print("")
print("🎯 How to use:")
print("  1. Select a target from the player list")
print("  2. Toggle the feature ON")
print("  3. Watch the chaos unfold!")
print("")
print("⚠️ Warning: This GUI is for entertainment purposes only.")
print("Use at your own risk in private servers only.")

-- Clean up when player leaves
player:GetPropertyChangedSignal("Parent"):Connect(function()
    if player.Parent == nil then
        screenGui:Destroy()
        script.Parent:Destroy()
    end
end)
