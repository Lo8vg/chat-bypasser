-- Combined Hub: Fling + TP Kill + Ultimate Collision + Combo Destroyer + Anti-AFK (MOBILE FRIENDLY)
-- 5 Tabs, Independent Logic, Fixed Mobile Inputs

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
mainFrame.Size = UDim2.new(0, 420, 0, 350)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -175)
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
titleLabel.Text = "⚔️ Ultimate Hub"
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

local tabNames = {"Fling", "TP Kill", "Ult Fling", "Combo", "Anti-AFK"}
local tabButtons = {}
local currentTab = "Fling"

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, -3, 1, 0)
    btn.Position = UDim2.new((i-1)*0.2, (i-1)*0.2 + 2, 0, 0)
    btn.BackgroundColor3 = i == 1 and COLORS.tabActive or COLORS.tabInactive
    btn.TextColor3 = i == 1 and COLORS.textLight or COLORS.textDark
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = tabButtonsFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    tabButtons[name] = btn
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
teleLabel3.TextSize = 9
teleLabel3.TextXAlignment = Enum.TextXAlignment.Left
teleLabel3.Parent = rightFrame3

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
teleToggle3.Parent = rightFrame3

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

-- ========== TAB 4: COMBO DESTROYER (FIXED) ==========

local tab4Content = Instance.new("Frame")
tab4Content.Size = UDim2.new(1, -20, 1, -82)
tab4Content.Position = UDim2.new(0, 10, 0, 80)
tab4Content.BackgroundTransparency = 1
tab4Content.Visible = false
tab4Content.Parent = mainFrame

local toggleBtn4 = Instance.new("TextButton")
toggleBtn4.Size = UDim2.new(1, 0, 0, 32)
toggleBtn4.BackgroundColor3 = COLORS.buttonDanger
toggleBtn4.TextColor3 = COLORS.textLight
toggleBtn4.Text = "DESTROY: OFF"
toggleBtn4.Font = Enum.Font.GothamBold
toggleBtn4.TextSize = 13
toggleBtn4.Parent = tab4Content
local togCorner4 = Instance.new("UICorner")
togCorner4.CornerRadius = UDim.new(0, 6)
togCorner4.Parent = toggleBtn4

local statusLbl4 = Instance.new("TextLabel")
statusLbl4.Size = UDim2.new(1, 0, 0, 18)
statusLbl4.Position = UDim2.new(0, 0, 0, 36)
statusLbl4.BackgroundTransparency = 1
statusLbl4.TextColor3 = COLORS.textMuted
statusLbl4.Text = "No target"
statusLbl4.Font = Enum.Font.Gotham
statusLbl4.TextSize = 10
statusLbl4.Parent = tab4Content

local playerScroll4 = Instance.new("ScrollingFrame")
playerScroll4.Size = UDim2.new(1, 0, 0, 130)
playerScroll4.Position = UDim2.new(0, 0, 0, 58)
playerScroll4.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerScroll4.ScrollBarThickness = 4
playerScroll4.Parent = tab4Content
local plCorner4 = Instance.new("UICorner")
plCorner4.CornerRadius = UDim.new(0, 6)
plCorner4.Parent = playerScroll4
local plLayout4 = Instance.new("UIListLayout")
plLayout4.Padding = UDim.new(0, 2)
plLayout4.Parent = playerScroll4

-- ========== TAB 5: ANTI-AFK (FIXED) ==========

local tab5Content = Instance.new("Frame")
tab5Content.Size = UDim2.new(1, -20, 1, -82)
tab5Content.Position = UDim2.new(0, 10, 0, 80)
tab5Content.BackgroundTransparency = 1
tab5Content.Visible = false
tab5Content.Parent = mainFrame

local afkToggle = Instance.new("TextButton")
afkToggle.Size = UDim2.new(1, 0, 0, 50)
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
afkInfo.Position = UDim2.new(0.075, 0, 0, 65)
afkInfo.BackgroundTransparency = 1
afkInfo.TextColor3 = COLORS.textMuted
afkInfo.Text = "Prevents getting kicked for inactivity.\n\nWorks in any game.\nSimulates activity every 60 seconds."
afkInfo.Font = Enum.Font.Gotham
afkInfo.TextSize = 12
afkInfo.TextWrapped = true
afkInfo.Parent = tab5Content

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

-- ========== TAB SWITCHING (5 TABS) ==========

tabButtons["Fling"].MouseButton1Click:Connect(function()
    currentTab = "Fling"
    tab1Content.Visible = true
    tab2Content.Visible = false
    tab3Content.Visible = false
    tab4Content.Visible = false
    tab5Content.Visible = false
    for name, btn in pairs(tabButtons) do
        if name == "Fling" then
            btn.BackgroundColor3 = COLORS.tabActive
            btn.TextColor3 = COLORS.textLight
        else
            btn.BackgroundColor3 = COLORS.tabInactive
            btn.TextColor3 = COLORS.textDark
        end
    end
end)

tabButtons["TP Kill"].MouseButton1Click:Connect(function()
    currentTab = "TP Kill"
    tab1Content.Visible = false
    tab2Content.Visible = true
    tab3Content.Visible = false
    tab4Content.Visible = false
    tab5Content.Visible = false
    for name, btn in pairs(tabButtons) do
        if name == "TP Kill" then
            btn.BackgroundColor3 = COLORS.tabActive
            btn.TextColor3 = COLORS.textLight
        else
            btn.BackgroundColor3 = COLORS.tabInactive
            btn.TextColor3 = COLORS.textDark
        end
    end
end)

tabButtons["Ult Fling"].MouseButton1Click:Connect(function()
    currentTab = "Ult Fling"
    tab1Content.Visible = false
    tab2Content.Visible = false
    tab3Content.Visible = true
    tab4Content.Visible = false
    tab5Content.Visible = false
    for name, btn in pairs(tabButtons) do
        if name == "Ult Fling" then
            btn.BackgroundColor3 = COLORS.tabActive
            btn.TextColor3 = COLORS.textLight
        else
            btn.BackgroundColor3 = COLORS.tabInactive
            btn.TextColor3 = COLORS.textDark
        end
    end
end)

tabButtons["Combo"].MouseButton1Click:Connect(function()
    currentTab = "Combo"
    tab1Content.Visible = false
    tab2Content.Visible = false
    tab3Content.Visible = false
    tab4Content.Visible = true
    tab5Content.Visible = false
    for name, btn in pairs(tabButtons) do
        if name == "Combo" then
            btn.BackgroundColor3 = COLORS.tabActive
            btn.TextColor3 = COLORS.textLight
        else
            btn.BackgroundColor3 = COLORS.tabInactive
            btn.TextColor3 = COLORS.textDark
        end
    end
end)

tabButtons["Anti-AFK"].MouseButton1Click:Connect(function()
    currentTab = "Anti-AFK"
    tab1Content.Visible = false
    tab2Content.Visible = false
    tab3Content.Visible = false
    tab4Content.Visible = false
    tab5Content.Visible = true
    for name, btn in pairs(tabButtons) do
        if name == "Anti-AFK" then
            btn.BackgroundColor3 = COLORS.tabActive
            btn.TextColor3 = COLORS.textLight
        else
            btn.BackgroundColor3 = COLORS.tabInactive
            btn.TextColor3 = COLORS.textDark
        end
    end
end)

-- ========== LOGIC: TAB 1 (FLING) ==========

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

-- ========== LOGIC: TAB 2 (TP KILL) ==========

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

-- ========== LOGIC: TAB 3 (ULTIMATE COLLISION FLING) ==========

local flingEnabled3 = false
local targetPlayer3 = nil
local flingLoop3 = nil
local flingCount3 = 0
local playerButtons3 = {}

-- Power Settings
local teleportMultiplier = 1
local velocityPower = 999999
local angularPower = 999999
local collisionMode = "devastate"

-- Toggle states
local velocityEnabled = true
local angularEnabled = true
local teleportEnabled = true
local massEnabled = true

local bodyVel3 = nil
local bodyAngVel3 = nil
local angle = 0

local function getRoot3(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function boostMass(char)
    if not massEnabled then return end
    
    local root = getRoot3(char)
    if not root then return end
    
    root.CustomPhysicalProperties = PhysicalProperties.new(100, 0.5, 0.5)
end

local function resetMass(char)
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
        flingLoop3 = **nil**
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
        
        resetMass(myChar)
    end
end

local function devastateFling(targetRoot, myRoot, myHumanoid)
    velocityPower = tonumber(velocityInput3.Text) or 999999
    angularPower = tonumber(angularInput3.Text) or 999999
    
    if massEnabled then
        boostMass(player.Character)
    end
    
    if teleportEnabled then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
    end
    
    if velocityEnabled then
        if bodyVel3 then bodyVel3:Destroy() end
        bodyVel3 = Instance.new("BodyVelocity")
        bodyVel3.Name = "CollisionBurst"
        bodyVel3.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel3.Velocity = Vector3.new(math.random(-1, 1) * velocityPower, velocityPower, math.random(-1, 1) * velocityPower)
        bodyVel3.P = math.huge
        bodyVel3.Parent = myRoot
    end
    
    if angularEnabled then
        if bodyAngVel3 then bodyAngVel3:Destroy() end
        bodyAngVel3 = Instance.new("BodyAngularVelocity")
        bodyAngVel3.Name = "CollisionSpin"
        bodyAngVel3.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel3.AngularVelocity = Vector3.new(angularPower, angularPower, angularPower)
        bodyAngVel3.P = math.huge
        bodyAngVel3.Parent = myRoot
    end
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

local function orbitalFling(targetRoot, myRoot, myHumanoid)
    velocityPower = tonumber(velocityInput3.Text) or 999999
    angularPower = tonumber(angularInput3.Text) or 999999
    teleportMultiplier = tonumber(teleportInput3.Text) or 500
    
    angle = angle + (math.pi * 2 / teleportMultiplier)
    
    local offsetX = math.cos(angle) * 2
    local offsetZ = math.sin(angle) * 2
    
    if massEnabled then
        boostMass(player.Character)
    end
    
    if teleportEnabled then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(offsetX, 1, offsetZ)
    end
    
    if velocityEnabled then
        local direction = (targetRoot.Position - myRoot.Position).Unit
        
        if bodyVel3 then bodyVel3:Destroy() end
        bodyVel3 = Instance.new("BodyVelocity")
        bodyVel3.Name = "CollisionBurst"
        bodyVel3.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel3.Velocity = direction * velocityPower
        bodyVel3.P = math.huge
        bodyVel3.Parent = myRoot
    end
    
    if angularEnabled then
        if bodyAngVel3 then bodyAngVel3:Destroy() end
        bodyAngVel3 = Instance.new("BodyAngularVelocity")
        bodyAngVel3.Name = "CollisionSpin"
        bodyAngVel3.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel3.AngularVelocity = Vector3.new(angularPower, angularPower, angularPower)
        bodyAngVel3.P = math.huge
        bodyAngVel3.Parent = myRoot
    end
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

local function chaosFling(targetRoot, myRoot, myHumanoid)
    velocityPower = tonumber(velocityInput3.Text) or 999999
    angularPower = tonumber(angularInput3.Text) or 999999
    
    if massEnabled then
        boostMass(player.Character)
    end
    
    if teleportEnabled then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(
            math.random(-3, 3),
            math.random(-2, 2),
            math.random(-3, 3)
        )
    end
    
    if velocityEnabled then
        if bodyVel3 then bodyVel3:Destroy() end
        bodyVel3 = Instance.new("BodyVelocity")
        bodyVel3.Name = "CollisionBurst"
        bodyVel3.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel3.Velocity = Vector3.new(
            math.random(-1, 1) * velocityPower,
            math.random(-1, 1) * velocityPower,
            math.random(-1, 1) * velocityPower
        )
        bodyVel3.P = math.huge
        bodyVel3.Parent = myRoot
    end
    
    if angularEnabled then
        if bodyAngVel3 then bodyAngVel3:Destroy() end
        bodyAngVel3 = Instance.new("BodyAngularVelocity")
        bodyAngVel3.Name = "CollisionSpin"
        bodyAngVel3.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel3.AngularVelocity = Vector3.new(
            math.random(-1, 1) * angularPower,
            math.random(-1, 1) * angularPower,
            math.random(-1, 1) * angularPower
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
    velocityEnabled = not velocityEnabled
    velocityToggle3.Text = velocityEnabled and "✓ Velocity Burst" or "✗ Velocity Burst"
    velocityToggle3.BackgroundColor3 = velocityEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

angularToggle3.MouseButton1Click:Connect(function()
    angularEnabled = not angularEnabled
    angularToggle3.Text = angularEnabled and "✓ Angular Force" or "✗ Angular Force"
    angularToggle3.BackgroundColor3 = angularEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

teleportToggle3.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    teleportToggle3.Text = teleportEnabled and "✓ Rapid Teleport" or "✗ Rapid Teleport"
    teleportToggle3.BackgroundColor3 = teleportEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

massToggle3.MouseButton1Click:Connect(function()
    massEnabled = not massEnabled
    massToggle3.Text = massEnabled and "✓ Mass Boost" or "✗ Mass Boost"
    massToggle3.BackgroundColor3 = massEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
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

-- ========== LOGIC: TAB 4 (COMBO DESTROYER) ==========
-- NOTE: Logic for Tab 4 goes here (Copy from the fixed combo script you liked)
local cdEnabled = false
local cdTarget = nil
local cdSwings = 3
local cdReach = 15
local cdPower = 999999
local cdLoop = nil

local function updateCDPlayerList()
    for _, child in pairs(playerScroll4:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 25)
            btn.BackgroundColor3 = cdTarget == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn.TextColor3 = cdTarget == plr and COLORS.textLight or COLORS.textDark
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 11
            btn.Parent = playerScroll4
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                cdTarget = plr
                statusLbl4.Text = "Target: " .. plr.Name
                updateCDPlayerList()
            end)
        end
    end
end

local function devastateFlingCD(targetRoot, myRoot, myHumanoid)
    if massEnabled then
        myRoot.CustomPhysicalProperties = PhysicalProperties.new(100, 0.5, 0.5)
    end
    myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
    
    local vel = Instance.new("BodyVelocity")
    vel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    vel.Velocity = Vector3.new(math.random(-1, 1) * cdPower, cdPower, math.random(-1, 1) * cdPower)
    vel.P = math.huge
    vel.Parent = myRoot
    
    local ang = Instance.new("BodyAngularVelocity")
    ang.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    ang.AngularVelocity = Vector3.new(cdPower, cdPower, cdPower)
    ang.P = math.huge
    ang.Parent = myRoot
    if myHumanoid then myHumanoid.PlatformStand = true end
    
    -- Cleanup inside loop usually handles this, but to be safe:
    spawn(function()
        wait(0.1)
        if vel then vel:Destroy() end
        if ang then ang:Destroy() end
    end)
end

local function swordAttackCD(targetRoot, myRoot)
    local sword = getSword() -- Reusing helper from Tab 2
    if not sword then
        sword = equipSword()
    end
    local dist = (targetRoot.Position - myRoot.Position).Magnitude
    if dist <= cdReach then
        for i = 1, cdSwings do
            if sword then sword:Activate() end
            wait(0.05)
        end
    end
end

local function startCD()
    if cdLoop then cdLoop:Disconnect() end
    cdLoop = RunService.Heartbeat:Connect(function()
        if not cdEnabled or not cdTarget then return end
        local myChar = player.Character
        local targetChar = cdTarget.Character
        if not myChar or not targetChar then return end
        
        local myRoot = getRoot(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        local targetRoot = getRoot(targetChar)
        if not myRoot or not targetRoot then return end
        
        devastateFlingCD(targetRoot, myRoot, myHumanoid)
        swordAttackCD(targetRoot, myRoot)
    end)
end

toggleBtn4.MouseButton1Click:Connect(function()
    cdEnabled = not cdEnabled
    if cdEnabled then
        if not cdTarget then updateCDPlayerList() return end
        toggleBtn4.Text = "DESTROY: ON"
        toggleBtn4.BackgroundColor3 = COLORS.buttonSuccess
        statusLbl4.Text = "Destroying: " .. cdTarget.Name
        startCD()
    else
        toggleBtn4.Text = "DESTROY: OFF"
        toggleBtn4.BackgroundColor3 = COLORS.buttonDanger
        statusLbl4.Text = cdTarget and ("Target: " .. cdTarget.Name) or "No target"
        if cdLoop then cdLoop:Disconnect() cdLoop = nil end
        -- Stop physics
        local myChar = player.Character
        if myChar then
            local myRoot = getRoot(myChar)
            if myRoot then
                myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                myRoot.CustomPhysicalProperties = nil
            end
            local myHumanoid = myChar:FindFirstChild("Humanoid")
            if myHumanoid then myHumanoid.PlatformStand = false end
        end
    end
end)

Players.PlayerAdded:Connect(updateCDPlayerList)
Players.PlayerRemoving:Connect(function() wait(0.5) updateCDPlayerList() end)
updateCDPlayerList()

-- ========== LOGIC: TAB 5 (ANTI-AFK) ==========
local antiAfkEnabled = false

afkToggle.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    if antiAfkEnabled then
        afkToggle.Text = "ANTI-AFK: ON"
        afkToggle.BackgroundColor3 = COLORS.buttonSuccess
    else
        afkToggle.Text = "ANTI-AFK: OFF"
        afkToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

spawn(function()
    while true do
        wait(60)
        if antiAfkEnabled then
            local vu = game:GetService("VirtualUser")
            vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            wait(0.1)
            vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end
    end
end)

print("✅ 5-Tab Ultimate Hub Loaded (Mobile Fixed)")
