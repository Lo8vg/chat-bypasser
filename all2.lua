-- Combined Hub: Fling + TP Kill + Ultimate Collision + Combo Destroyer (No Logic Changes)
-- Four separate tabs, each works independently

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
titleLabel.Text = "⚔️ Combat Hub"
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

local tab1Button = Instance.new("TextButton")
tab1Button.Size = UDim2.new(0.25, -3, 1, 0)
tab1Button.Position = UDim2.new(0, 0, 0, 0)
tab1Button.BackgroundColor3 = COLORS.tabActive
tab1Button.TextColor3 = COLORS.textLight
tab1Button.Text = "Fling"
tab1Button.Font = Enum.Font.GothamBold
tab1Button.TextSize = 10
tab1Button.Parent = tabButtonsFrame

local tab1Corner = Instance.new("UICorner")
tab1Corner.CornerRadius = UDim.new(0, 6)
tab1Corner.Parent = tab1Button

local tab2Button = Instance.new("TextButton")
tab2Button.Size = UDim2.new(0.25, -3, 1, 0)
tab2Button.Position = UDim2.new(0.25, 3, 0, 0)
tab2Button.BackgroundColor3 = COLORS.tabInactive
tab2Button.TextColor3 = COLORS.textDark
tab2Button.Text = "TP Kill"
tab2Button.Font = Enum.Font.GothamBold
tab2Button.TextSize = 10
tab2Button.Parent = tabButtonsFrame

local tab2Corner = Instance.new("UICorner")
tab2Corner.CornerRadius = UDim.new(0, 6)
tab2Corner.Parent = tab2Button

local tab3Button = Instance.new("TextButton")
tab3Button.Size = UDim2.new(0.25, -3, 1, 0)
tab3Button.Position = UDim2.new(0.5, 6, 0, 0)
tab3Button.BackgroundColor3 = COLORS.tabInactive
tab3Button.TextColor3 = COLORS.textDark
tab3Button.Text = "Ultimate"
tab3Button.Font = Enum.Font.GothamBold
tab3Button.TextSize = 10
tab3Button.Parent = tabButtonsFrame

local tab3Corner = Instance.new("UICorner")
tab3Corner.CornerRadius = UDim.new(0, 6)
tab3Corner.Parent = tab3Button

local tab4Button = Instance.new("TextButton")
tab4Button.Size = UDim2.new(0.25, -3, 1, 0)
tab4Button.Position = UDim2.new(0.75, 9, 0, 0)
tab4Button.BackgroundColor3 = COLORS.tabInactive
tab4Button.TextColor3 = COLORS.textDark
tab4Button.Text = "Combo"
tab4Button.Font = Enum.Font.GothamBold
tab4Button.TextSize = 10
tab4Button.Parent = tabButtonsFrame

local tab4Corner = Instance.new("UICorner")
tab4Corner.CornerRadius = UDim.new(0, 6)
tab4Corner.Parent = tab4Button

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

-- ========== TAB 4: COMBO DESTROYER (FLING + SWORD) ==========

local tab4Content = Instance.new("Frame")
tab4Content.Size = UDim2.new(1, -20, 1, -82)
tab4Content.Position = UDim2.new(0, 10, 0, 80)
tab4Content.BackgroundTransparency = 1
tab4Content.Visible = false
tab4Content.Parent = mainFrame

-- Left Frame
local leftFrame4 = Instance.new("Frame")
leftFrame4.Size = UDim2.new(0.5, -8, 1, 0)
leftFrame4.Position = UDim2.new(0, 0, 0, 0)
leftFrame4.BackgroundTransparency = 1
leftFrame4.Parent = tab4Content

-- Toggle Button
local toggleButton4 = Instance.new("TextButton")
toggleButton4.Size = UDim2.new(1, 0, 0, 32)
toggleButton4.Position = UDim2.new(0, 0, 0, 0)
toggleButton4.BackgroundColor3 = COLORS.buttonDanger
toggleButton4.TextColor3 = COLORS.textLight
toggleButton4.Text = "DESTROY: OFF"
toggleButton4.Font = Enum.Font.GothamBold
toggleButton4.TextSize = 13
toggleButton4.Parent = leftFrame4

local toggleCorner4 = Instance.new("UICorner")
toggleCorner4.CornerRadius = UDim.new(0, 6)
toggleCorner4.Parent = toggleButton4

-- Kill Counter
local killCounter4 = Instance.new("TextLabel")
killCounter4.Size = UDim2.new(1, 0, 0, 14)
killCounter4.Position = UDim2.new(0, 0, 0, 36)
killCounter4.BackgroundTransparency = 1
killCounter4.TextColor3 = COLORS.buttonSuccess
killCounter4.Text = "Attacks: 0"
killCounter4.Font = Enum.Font.GothamBold
killCounter4.TextSize = 10
killCounter4.Parent = leftFrame4

-- Target Label
local targetLabel4 = Instance.new("TextLabel")
targetLabel4.Size = UDim2.new(1, 0, 0, 14)
targetLabel4.Position = UDim2.new(0, 0, 0, 52)
targetLabel4.BackgroundTransparency = 1
targetLabel4.TextColor3 = COLORS.textDark
targetLabel4.Text = "Select Target:"
targetLabel4.Font = Enum.Font.GothamBold
targetLabel4.TextSize = 10
targetLabel4.TextXAlignment = Enum.TextXAlignment.Left
targetLabel4.Parent = leftFrame4

-- Player List
local playerScroll4 = Instance.new("ScrollingFrame")
playerScroll4.Size = UDim2.new(1, 0, 0, 70)
playerScroll4.Position = UDim2.new(0, 0, 0, 68)
playerScroll4.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerScroll4.ScrollBarThickness = 4
playerScroll4.Parent = leftFrame4

local playerScrollCorner4 = Instance.new("UICorner")
playerScrollCorner4.CornerRadius = UDim.new(0, 6)
playerScrollCorner4.Parent = playerScroll4

local playerLayout4 = Instance.new("UIListLayout")
playerLayout4.Padding = UDim.new(0, 2)
playerLayout4.Parent = playerScroll4

-- Status Label
local statusLabel4 = Instance.new("TextLabel")
statusLabel4.Size = UDim2.new(1, 0, 0, 14)
statusLabel4.Position = UDim2.new(0, 0, 0, 142)
statusLabel4.BackgroundTransparency = 1
statusLabel4.TextColor3 = COLORS.textMuted
statusLabel4.Text = "No target selected"
statusLabel4.Font = Enum.Font.Gotham
statusLabel4.TextSize = 9
statusLabel4.TextWrapped = true
statusLabel4.Parent = leftFrame4

-- Mode Label
local modeLabel4 = Instance.new("TextLabel")
modeLabel4.Size = UDim2.new(1, 0, 0, 14)
modeLabel4.Position = UDim2.new(0, 0, 0, 158)
modeLabel4.BackgroundTransparency = 1
modeLabel4.TextColor3 = COLORS.textDark
modeLabel4.Text = "Fling Mode:"
modeLabel4.Font = Enum.Font.GothamBold
modeLabel4.TextSize = 9
modeLabel4.TextXAlignment = Enum.TextXAlignment.Left
modeLabel4.Parent = leftFrame4

local devastateModeBtn4 = Instance.new("TextButton")
devastateModeBtn4.Size = UDim2.new(1, 0, 0, 20)
devastateModeBtn4.Position = UDim2.new(0, 0, 0, 174)
devastateModeBtn4.BackgroundColor3 = COLORS.buttonSuccess
devastateModeBtn4.TextColor3 = COLORS.textLight
devastateModeBtn4.Text = "✓ DEVASTATE"
devastateModeBtn4.Font = Enum.Font.GothamBold
devastateModeBtn4.TextSize = 9
devastateModeBtn4.Parent = leftFrame4

local devastateCorner4 = Instance.new("UICorner")
devastateCorner4.CornerRadius = UDim.new(0, 4)
devastateCorner4.Parent = devastateModeBtn4

local orbitalModeBtn4 = Instance.new("TextButton")
orbitalModeBtn4.Size = UDim2.new(1, 0, 0, 20)
orbitalModeBtn4.Position = UDim2.new(0, 0, 0, 196)
orbitalModeBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
orbitalModeBtn4.TextColor3 = COLORS.textDark
orbitalModeBtn4.Text = "ORBITAL"
orbitalModeBtn4.Font = Enum.Font.Gotham
orbitalModeBtn4.TextSize = 9
orbitalModeBtn4.Parent = leftFrame4

local orbitalCorner4 = Instance.new("UICorner")
orbitalCorner4.CornerRadius = UDim.new(0, 4)
orbitalCorner4.Parent = orbitalModeBtn4

local chaosModeBtn4 = Instance.new("TextButton")
chaosModeBtn4.Size = UDim2.new(1, 0, 0, 20)
chaosModeBtn4.Position = UDim2.new(0, 0, 0, 218)
chaosModeBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
chaosModeBtn4.TextColor3 = COLORS.textDark
chaosModeBtn4.Text = "CHAOS"
chaosModeBtn4.Font = Enum.Font.Gotham
chaosModeBtn4.TextSize = 9
chaosModeBtn4.Parent = leftFrame4

local chaosCorner4 = Instance.new("UICorner")
chaosCorner4.CornerRadius = UDim.new(0, 4)
chaosCorner4.Parent = chaosModeBtn4

-- Right Frame
local rightFrame4 = Instance.new("Frame")
rightFrame4.Size = UDim2.new(0.5, -8, 1, 0)
rightFrame4.Position = UDim2.new(0.5, 8, 0, 0)
rightFrame4.BackgroundTransparency = 1
rightFrame4.Parent = tab4Content

-- SWORD SECTION
local swordSectionLabel4 = Instance.new("TextLabel")
swordSectionLabel4.Size = UDim2.new(1, 0, 0, 14)
swordSectionLabel4.Position = UDim2.new(0, 0, 0, 0)
swordSectionLabel4.BackgroundTransparency = 1
swordSectionLabel4.TextColor3 = COLORS.buttonPrimary
swordSectionLabel4.Text = "⚔️ SWORD SETTINGS"
swordSectionLabel4.Font = Enum.Font.GothamBold
swordSectionLabel4.TextSize = 9
swordSectionLabel4.TextXAlignment = Enum.TextXAlignment.Left
swordSectionLabel4.Parent = rightFrame4

-- Sword Toggle
local swordToggle4 = Instance.new("TextButton")
swordToggle4.Size = UDim2.new(1, 0, 0, 18)
swordToggle4.Position = UDim2.new(0, 0, 0, 14)
swordToggle4.BackgroundColor3 = COLORS.buttonSuccess
swordToggle4.TextColor3 = COLORS.textLight
swordToggle4.Text = "✓ Auto Sword Attack"
swordToggle4.Font = Enum.Font.Gotham
swordToggle4.TextSize = 8
swordToggle4.Parent = rightFrame4

local swordTogCorner4 = Instance.new("UICorner")
swordTogCorner4.CornerRadius = UDim.new(0, 4)
swordTogCorner4.Parent = swordToggle4

-- Swings Per Attack
local swingsRow4 = Instance.new("Frame")
swingsRow4.Size = UDim2.new(1, 0, 0, 20)
swingsRow4.Position = UDim2.new(0, 0, 0, 36)
swingsRow4.BackgroundTransparency = 1
swingsRow4.Parent = rightFrame4

local swingsLabel4 = Instance.new("TextLabel")
swingsLabel4.Size = UDim2.new(0, 70, 1, 0)
swingsLabel4.BackgroundTransparency = 1
swingsLabel4.TextColor3 = COLORS.textDark
swingsLabel4.Text = "Swings/Attack:"
swingsLabel4.Font = Enum.Font.Gotham
swingsLabel4.TextSize = 8
swingsLabel4.TextXAlignment = Enum.TextXAlignment.Left
swingsLabel4.Parent = swingsRow4

local swingsInput4 = Instance.new("TextBox")
swingsInput4.Size = UDim2.new(0, 50, 1, 0)
swingsInput4.Position = UDim2.new(0, 75, 0, 0)
swingsInput4.BackgroundColor3 = COLORS.inputBg
swingsInput4.TextColor3 = COLORS.textDark
swingsInput4.Text = "3"
swingsInput4.Font = Enum.Font.Gotham
swingsInput4.TextSize = 8
swingsInput4.ClearTextOnFocus = false
swingsInput4.Parent = swingsRow4

local swingsCorner4 = Instance.new("UICorner")
swingsCorner4.CornerRadius = UDim.new(0, 4)
swingsCorner4.Parent = swingsInput4

local swingsStroke4 = Instance.new("UIStroke")
swingsStroke4.Color = COLORS.border
swingsStroke4.Thickness = 1
swingsStroke4.Parent = swingsInput4

-- Reach Distance
local reachRow4 = Instance.new("Frame")
reachRow4.Size = UDim2.new(1, 0, 0, 20)
reachRow4.Position = UDim2.new(0, 0, 0, 58)
reachRow4.BackgroundTransparency = 1
reachRow4.Parent = rightFrame4

local reachLabel4 = Instance.new("TextLabel")
reachLabel4.Size = UDim2.new(0, 70, 1, 0)
reachLabel4.BackgroundTransparency = 1
reachLabel4.TextColor3 = COLORS.textDark
reachLabel4.Text = "Reach Distance:"
reachLabel4.Font = Enum.Font.Gotham
reachLabel4.TextSize = 8
reachLabel4.TextXAlignment = Enum.TextXAlignment.Left
reachLabel4.Parent = reachRow4

local reachInput4 = Instance.new("TextBox")
reachInput4.Size = UDim2.new(0, 50, 1, 0)
reachInput4.Position = UDim2.new(0, 75, 0, 0)
reachInput4.BackgroundColor3 = COLORS.inputBg
reachInput4.TextColor3 = COLORS.textDark
reachInput4.Text = "15"
reachInput4.Font = Enum.Font.Gotham
reachInput4.TextSize = 8
reachInput4.ClearTextOnFocus = false
reachInput4.Parent = reachRow4

local reachCorner4 = Instance.new("UICorner")
reachCorner4.CornerRadius = UDim.new(0, 4)
reachCorner4.Parent = reachInput4

local reachStroke4 = Instance.new("UIStroke")
reachStroke4.Color = COLORS.border
reachStroke4.Thickness = 1
reachStroke4.Parent = reachInput4

-- FLING SECTION
local flingSectionLabel4 = Instance.new("TextLabel")
flingSectionLabel4.Size = UDim2.new(1, 0, 0, 14)
flingSectionLabel4.Position = UDim2.new(0, 0, 0, 82)
flingSectionLabel4.BackgroundTransparency = 1
flingSectionLabel4.TextColor3 = COLORS.buttonDanger
flingSectionLabel4.Text = "💥 FLING SETTINGS"
flingSectionLabel4.Font = Enum.Font.GothamBold
flingSectionLabel4.TextSize = 9
flingSectionLabel4.TextXAlignment = Enum.TextXAlignment.Left
flingSectionLabel4.Parent = rightFrame4

-- Velocity Power
local velocityRow4 = Instance.new("Frame")
velocityRow4.Size = UDim2.new(1, 0, 0, 20)
velocityRow4.Position = UDim2.new(0, 0, 0, 96)
velocityRow4.BackgroundTransparency = 1
velocityRow4.Parent = rightFrame4

local velocityLabel4 = Instance.new("TextLabel")
velocityLabel4.Size = UDim2.new(0, 70, 1, 0)
velocityLabel4.BackgroundTransparency = 1
velocityLabel4.TextColor3 = COLORS.textDark
velocityLabel4.Text = "Velocity Power:"
velocityLabel4.Font = Enum.Font.Gotham
velocityLabel4.TextSize = 8
velocityLabel4.TextXAlignment = Enum.TextXAlignment.Left
velocityLabel4.Parent = velocityRow4

local velocityInput4 = Instance.new("TextBox")
velocityInput4.Size = UDim2.new(0, 60, 1, 0)
velocityInput4.Position = UDim2.new(0, 75, 0, 0)
velocityInput4.BackgroundColor3 = COLORS.inputBg
velocityInput4.TextColor3 = COLORS.textDark
velocityInput4.Text = "999999"
velocityInput4.Font = Enum.Font.Gotham
velocityInput4.TextSize = 8
velocityInput4.ClearTextOnFocus = false
velocityInput4.Parent = velocityRow4

local velocityCorner4 = Instance.new("UICorner")
velocityCorner4.CornerRadius = UDim.new(0, 4)
velocityCorner4.Parent = velocityInput4

local velocityStroke4 = Instance.new("UIStroke")
velocityStroke4.Color = COLORS.border
velocityStroke4.Thickness = 1
velocityStroke4.Parent = velocityInput4

-- Angular Power
local angularRow4 = Instance.new("Frame")
angularRow4.Size = UDim2.new(1, 0, 0, 20)
angularRow4.Position = UDim2.new(0, 0, 0, 118)
angularRow4.BackgroundTransparency = 1
angularRow4.Parent = rightFrame4

local angularLabel4 = Instance.new("TextLabel")
angularLabel4.Size = UDim2.new(0, 70, 1, 0)
angularLabel4.BackgroundTransparency = 1
angularLabel4.TextColor3 = COLORS.textDark
angularLabel4.Text = "Angular Power:"
angularLabel4.Font = Enum.Font.Gotham
angularLabel4.TextSize = 8
angularLabel4.TextXAlignment = Enum.TextXAlignment.Left
angularLabel4.Parent = angularRow4

local angularInput4 = Instance.new("TextBox")
angularInput4.Size = UDim2.new(0, 60, 1, 0)
angularInput4.Position = UDim2.new(0, 75, 0, 0)
angularInput4.BackgroundColor3 = COLORS.inputBg
angularInput4.TextColor3 = COLORS.textDark
angularInput4.Text = "999999"
angularInput4.Font = Enum.Font.Gotham
angularInput4.TextSize = 8
angularInput4.ClearTextOnFocus = false
angularInput4.Parent = angularRow4

local angularCorner4 = Instance.new("UICorner")
angularCorner4.CornerRadius = UDim.new(0, 4)
angularCorner4.Parent = angularInput4

local angularStroke4 = Instance.new("UIStroke")
angularStroke4.Color = COLORS.border
angularStroke4.Thickness = 1
angularStroke4.Parent = angularInput4

-- FLING TOGGLES
local flingTogglesLabel4 = Instance.new("TextLabel")
flingTogglesLabel4.Size = UDim2.new(1, 0, 0, 14)
flingTogglesLabel4.Position = UDim2.new(0, 0, 0, 142)
flingTogglesLabel4.BackgroundTransparency = 1
flingTogglesLabel4.TextColor3 = COLORS.textDark
flingTogglesLabel4.Text = "Fling Layers:"
flingTogglesLabel4.Font = Enum.Font.GothamBold
flingTogglesLabel4.TextSize = 9
flingTogglesLabel4.TextXAlignment = Enum.TextXAlignment.Left
flingTogglesLabel4.Parent = rightFrame4

-- Velocity Toggle
local velocityToggle4 = Instance.new("TextButton")
velocityToggle4.Size = UDim2.new(1, 0, 0, 16)
velocityToggle4.Position = UDim2.new(0, 0, 0, 156)
velocityToggle4.BackgroundColor3 = COLORS.buttonSuccess
velocityToggle4.TextColor3 = COLORS.textLight
velocityToggle4.Text = "✓ Velocity Burst"
velocityToggle4.Font = Enum.Font.Gotham
velocityToggle4.TextSize = 8
velocityToggle4.Parent = rightFrame4

local velocityTogCorner4 = Instance.new("UICorner")
velocityTogCorner4.CornerRadius = UDim.new(0, 4)
velocityTogCorner4.Parent = velocityToggle4

-- Angular Toggle
local angularToggle4 = Instance.new("TextButton")
angularToggle4.Size = UDim2.new(1, 0, 0, 16)
angularToggle4.Position = UDim2.new(0, 0, 0, 174)
angularToggle4.BackgroundColor3 = COLORS.buttonSuccess
angularToggle4.TextColor3 = COLORS.textLight
angularToggle4.Text = "✓ Angular Force"
angularToggle4.Font = Enum.Font.Gotham
angularToggle4.TextSize = 8
angularToggle4.Parent = rightFrame4

local angularTogCorner4 = Instance.new("UICorner")
angularTogCorner4.CornerRadius = UDim.new(0, 4)
angularTogCorner4.Parent = angularToggle4

-- Teleport Toggle
local teleportToggle4 = Instance.new("TextButton")
teleportToggle4.Size = UDim2.new(1, 0, 0, 16)
teleportToggle4.Position = UDim2.new(0, 0, 0, 192)
teleportToggle4.BackgroundColor3 = COLORS.buttonSuccess
teleportToggle4.TextColor3 = COLORS.textLight
teleportToggle4.Text = "✓ Rapid Teleport"
teleportToggle4.Font = Enum.Font.Gotham
teleportToggle4.TextSize = 8
teleportToggle4.Parent = rightFrame4

local teleportTogCorner4 = Instance.new("UICorner")
teleportTogCorner4.CornerRadius = UDim.new(0, 4)
teleportTogCorner4.Parent = teleportToggle4

-- Mass Toggle
local massToggle4 = Instance.new("TextButton")
massToggle4.Size = UDim2.new(1, 0, 0, 16)
massToggle4.Position = UDim2.new(0, 0, 0, 210)
massToggle4.BackgroundColor3 = COLORS.buttonSuccess
massToggle4.TextColor3 = COLORS.textLight
massToggle4.Text = "✓ Mass Boost"
massToggle4.Font = Enum.Font.Gotham
massToggle4.TextSize = 8
massToggle4.Parent = rightFrame4

local massTogCorner4 = Instance.new("UICorner")
massTogCorner4.CornerRadius = UDim.new(0, 4)
massTogCorner4.Parent = massToggle4

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

tab1Button.MouseButton1Click:Connect(function()
    tab1Button.BackgroundColor3 = COLORS.tabActive
    tab1Button.TextColor3 = COLORS.textLight
    tab2Button.BackgroundColor3 = COLORS.tabInactive
    tab2Button.TextColor3 = COLORS.textDark
    tab3Button.BackgroundColor3 = COLORS.tabInactive
    tab3Button.TextColor3 = COLORS.textDark
    tab4Button.BackgroundColor3 = COLORS.tabInactive
    tab4Button.TextColor3 = COLORS.textDark
    tab1Content.Visible = true
    tab2Content.Visible = false
    tab3Content.Visible = false
    tab4Content.Visible = false
end)

tab2Button.MouseButton1Click:Connect(function()
    tab1Button.BackgroundColor3 = COLORS.tabInactive
    tab1Button.TextColor3 = COLORS.textDark
    tab2Button.BackgroundColor3 = COLORS.tabActive
    tab2Button.TextColor3 = COLORS.textLight
    tab3Button.BackgroundColor3 = COLORS.tabInactive
    tab3Button.TextColor3 = COLORS.textDark
    tab4Button.BackgroundColor3 = COLORS.tabInactive
    tab4Button.TextColor3 = COLORS.textDark
    tab1Content.Visible = false
    tab2Content.Visible = true
    tab3Content.Visible = false
    tab4Content.Visible = false
end)

tab3Button.MouseButton1Click:Connect(function()
    tab1Button.BackgroundColor3 = COLORS.tabInactive
    tab1Button.TextColor3 = COLORS.textDark
    tab2Button.BackgroundColor3 = COLORS.tabInactive
    tab2Button.TextColor3 = COLORS.textDark
    tab3Button.BackgroundColor3 = COLORS.tabActive
    tab3Button.TextColor3 = COLORS.textLight
    tab4Button.BackgroundColor3 = COLORS.tabInactive
    tab4Button.TextColor3 = COLORS.textDark
    tab1Content.Visible = false
    tab2Content.Visible = false
    tab3Content.Visible = true
    tab4Content.Visible = false
end)

tab4Button.MouseButton1Click:Connect(function()
    tab1Button.BackgroundColor3 = COLORS.tabInactive
    tab1Button.TextColor3 = COLORS.textDark
    tab2Button.BackgroundColor3 = COLORS.tabInactive
    tab2Button.TextColor3 = COLORS.textDark
    tab3Button.BackgroundColor3 = COLORS.tabInactive
    tab3Button.TextColor3 = COLORS.textDark
    tab4Button.BackgroundColor3 = COLORS.tabActive
    tab4Button.TextColor3 = COLORS.textLight
    tab1Content.Visible = false
    tab2Content.Visible = false
    tab3Content.Visible = false
    tab4Content.Visible = true
end)

print("✅ Combined Hub Loaded - ALL 4 TABS READY")
print("   Tab 1: Original Fling (BodyMover)")
print("   Tab 2: TP Kill (Spawn Protection Detection)")
print("   Tab 3: Ultimate Collision Fling (3 Modes + 4 Layers)")
print("   Tab 4: Combo Destroyer (Fling + Sword AUTO)")
print("   RightCtrl to toggle hub")
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
        if not targetPlayer1 then
            statusLabel1.Text = "Select a target first!"
            flingEnabled = false
            return
        end
        
        toggleButton1.Text = "FLING: ON"
        toggleButton1.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel1.Text = "Flinging: " .. targetPlayer1.Name
        
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
        if not targetPlayer2 then
            statusLabel2.Text = "Select a target first!"
            killEnabled = false
            return
        end
        
        toggleButton2.Text = "KILL AURA: ON"
        toggleButton2.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel2.Text = "Hunting: " .. targetPlayer2.Name
        
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

-- Mode Buttons Tab 3
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

-- Layer Toggles Tab 3
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

-- Fling Toggle Tab 3
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

-- ========== TAB 4: COMBO DESTROYER (FLING + SWORD AUTO) ==========

local destroyEnabled = false
local targetPlayer4 = nil
local flingCount4 = 0

-- Power Settings Tab 4
local velocityPower4 = 999999
local angularPower4 = 999999
local collisionMode4 = "devastate"
local teleportMultiplier4 = 500

-- Sword Settings Tab 4
local swordSwings4 = 3
local swingDelay4 = 0.01
local swordReach4 = 15

-- Toggle states Tab 4
local velocityEnabled4 = true
local angularEnabled4 = true
local teleportEnabled4 = true
local massEnabled4 = true
local swordEnabled4 = true

-- Loops Tab 4
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
    if not root then return end
    
    root.CustomPhysicalProperties = PhysicalProperties.new(100, 0.5, 0.5)
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
            btn.Size = UDim2.new(1, 0, 0, 18)
            btn.BackgroundColor3 = targetPlayer4 == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn.TextColor3 = targetPlayer4 == plr and COLORS.textLight or COLORS.textDark
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 9
            btn.Parent = playerScroll4
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                targetPlayer4 = plr
                statusLabel4.Text = "Target: " .. plr.Name
                updatePlayerList4()
            end)
            
            table.insert(playerButtons4, btn)
        end
    end
    
    playerScroll4.CanvasSize = UDim2.new(0, 0, 0, playerLayout4.AbsoluteContentSize.Y)
end

-- ========== FLING FUNCTIONS TAB 4 ==========

local function devastateFling4(targetRoot, myRoot, myHumanoid)
    velocityPower4 = tonumber(velocityInput4.Text) or 999999
    angularPower4 = tonumber(angularInput4.Text) or 999999
    
    if massEnabled4 then
        boostMass4(player.Character)
    end
    
    if teleportEnabled4 then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
    end
    
    if velocityEnabled4 then
        if bodyVel4 then bodyVel4:Destroy() end
        bodyVel4 = Instance.new("BodyVelocity")
        bodyVel4.Name = "CollisionBurst"
        bodyVel4.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel4.Velocity = Vector3.new(math.random(-1, 1) * velocityPower4, velocityPower4, math.random(-1, 1) * velocityPower4)
        bodyVel4.P = math.huge
        bodyVel4.Parent = myRoot
    end
    
    if angularEnabled4 then
        if bodyAngVel4 then bodyAngVel4:Destroy() end
        bodyAngVel4 = Instance.new("BodyAngularVelocity")
        bodyAngVel4.Name = "CollisionSpin"
        bodyAngVel4.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel4.AngularVelocity = Vector3.new(angularPower4, angularPower4, angularPower4)
        bodyAngVel4.P = math.huge
        bodyAngVel4.Parent = myRoot
    end
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

local function orbitalFling4(targetRoot, myRoot, myHumanoid)
    velocityPower4 = tonumber(velocityInput4.Text) or 999999
    angularPower4 = tonumber(angularInput4.Text) or 999999
    teleportMultiplier4 = 500
    
    angle4 = angle4 + (math.pi * 2 / teleportMultiplier4)
    
    local offsetX = math.cos(angle4) * 2
    local offsetZ = math.sin(angle4) * 2
    
    if massEnabled4 then
        boostMass4(player.Character)
    end
    
    if teleportEnabled4 then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(offsetX, 1, offsetZ)
    end
    
    if velocityEnabled4 then
        local direction = (targetRoot.Position - myRoot.Position).Unit
        
        if bodyVel4 then bodyVel4:Destroy() end
        bodyVel4 = Instance.new("BodyVelocity")
        bodyVel4.Name = "CollisionBurst"
        bodyVel4.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel4.Velocity = direction * velocityPower4
        bodyVel4.P = math.huge
        bodyVel4.Parent = myRoot
    end
    
    if angularEnabled4 then
        if bodyAngVel4 then bodyAngVel4:Destroy() end
        bodyAngVel4 = Instance.new("BodyAngularVelocity")
        bodyAngVel4.Name = "CollisionSpin"
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
    velocityPower4 = tonumber(velocityInput4.Text) or 999999
    angularPower4 = tonumber(angularInput4.Text) or 999999
    
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
        bodyVel4.Name = "CollisionBurst"
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
        bodyAngVel4.Name = "CollisionSpin"
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

local function performSwordAttack4(targetRoot, myRoot)
    if not swordEnabled4 then return end
    
    local sword = getSword4()
    if not sword then
        sword = equipSword4()
        if not sword then return end
    end
    
    swordSwings4 = tonumber(swingsInput4.Text) or 3
    swordReach4 = tonumber(reachInput4.Text) or 15
    
    if swordReach4 < 1 then swordReach4 = 1 end
    if swordReach4 > 50 then swordReach4 = 50 end
    
    local targetChar = targetPlayer4.Character
    if not targetChar then return end
    
    local targetHumanoid = targetChar:FindFirstChild("Humanoid")
    if not targetHumanoid then return end
    
    if targetHumanoid.Health <= 0 then return end
    
    local distance = (myRoot.Position - targetRoot.Position).Magnitude
    
    if distance <= swordReach4 then
        for i = 1, swordSwings4 do
            if sword then
                sword:Activate()
                wait(swingDelay4)
            end
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
        
        -- Apply fling based on mode
        if collisionMode4 == "devastate" then
            devastateFling4(targetRoot, myRoot, myHumanoid)
        elseif collisionMode4 == "orbital" then
            orbitalFling4(targetRoot, myRoot, myHumanoid)
        else
            chaosFling4(targetRoot, myRoot, myHumanoid)
        end
        
        -- Perform sword attack
        performSwordAttack4(targetRoot, myRoot)
    end)
end

-- ========== MODE BUTTONS TAB 4 ==========

devastateModeBtn4.MouseButton1Click:Connect(function()
    collisionMode4 = "devastate"
    devastateModeBtn4.Text = "✓ DEVASTATE"
    devastateModeBtn4.BackgroundColor3 = COLORS.buttonSuccess
    devastateModeBtn4.TextColor3 = COLORS.textLight
    orbitalModeBtn4.Text = "ORBITAL"
    orbitalModeBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    orbitalModeBtn4.TextColor3 = COLORS.textDark
    chaosModeBtn4.Text = "CHAOS"
    chaosModeBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    chaosModeBtn4.TextColor3 = COLORS.textDark
end)

orbitalModeBtn4.MouseButton1Click:Connect(function()
    collisionMode4 = "orbital"
    orbitalModeBtn4.Text = "✓ ORBITAL"
    orbitalModeBtn4.BackgroundColor3 = COLORS.buttonSuccess
    orbitalModeBtn4.TextColor3 = COLORS.textLight
    devastateModeBtn4.Text = "DEVASTATE"
    devastateModeBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    devastateModeBtn4.TextColor3 = COLORS.textDark
    chaosModeBtn4.Text = "CHAOS"
    chaosModeBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    chaosModeBtn4.TextColor3 = COLORS.textDark
end)

chaosModeBtn4.MouseButton1Click:Connect(function()
    collisionMode4 = "chaos"
    chaosModeBtn4.Text = "✓ CHAOS"
    chaosModeBtn4.BackgroundColor3 = COLORS.buttonSuccess
    chaosModeBtn4.TextColor3 = COLORS.textLight
    devastateModeBtn4.Text = "DEVASTATE"
    devastateModeBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    devastateModeBtn4.TextColor3 = COLORS.textDark
    orbitalModeBtn4.Text = "ORBITAL"
    orbitalModeBtn4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    orbitalModeBtn4.TextColor3 = COLORS.textDark
end)

-- ========== TOGGLE BUTTONS TAB 4 ==========

-- Sword Toggle
swordToggle4.MouseButton1Click:Connect(function()
    swordEnabled4 = not swordEnabled4
    swordToggle4.Text = swordEnabled4 and "✓ Auto Sword Attack" or "✗ Auto Sword Attack"
    swordToggle4.BackgroundColor3 = swordEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

-- Velocity Toggle
velocityToggle4.MouseButton1Click:Connect(function()
    velocityEnabled4 = not velocityEnabled4
    velocityToggle4.Text = velocityEnabled4 and "✓ Velocity Burst" or "✗ Velocity Burst"
    velocityToggle4.BackgroundColor3 = velocityEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

-- Angular Toggle
angularToggle4.MouseButton1Click:Connect(function()
    angularEnabled4 = not angularEnabled4
    angularToggle4.Text = angularEnabled4 and "✓ Angular Force" or "✗ Angular Force"
    angularToggle4.BackgroundColor3 = angularEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

-- Teleport Toggle
teleportToggle4.MouseButton1Click:Connect(function()
    teleportEnabled4 = not teleportEnabled4
    teleportToggle4.Text = teleportEnabled4 and "✓ Rapid Teleport" or "✗ Rapid Teleport"
    teleportToggle4.BackgroundColor3 = teleportEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

-- Mass Toggle
massToggle4.MouseButton1Click:Connect(function()
    massEnabled4 = not massEnabled4
    massToggle4.Text = massEnabled4 and "✓ Mass Boost" or "✗ Mass Boost"
    massToggle4.BackgroundColor3 = massEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

-- ========== MAIN TOGGLE TAB 4 ==========

toggleButton4.MouseButton1Click:Connect(function()
    destroyEnabled = not destroyEnabled
    
    if destroyEnabled then
        if not targetPlayer4 then
            statusLabel4.Text = "Select a target first!"
            destroyEnabled = false
            return
        end
        
        toggleButton4.Text = "DESTROY: ON"
        toggleButton4.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel4.Text = "Destroying: " .. targetPlayer4.Name .. " (" .. collisionMode4:upper() .. ")"
        
        -- Equip sword immediately
        if swordEnabled4 then
            equipSword4()
        end
        
        startFling4()
    else
        toggleButton4.Text = "DESTROY: OFF"
        toggleButton4.BackgroundColor3 = COLORS.buttonDanger
        statusLabel4.Text = targetPlayer4 and ("Target: " .. targetPlayer4.Name) or "No target selected"
        
        stopFling4()
    end
end)

-- ========== CHARACTER EVENTS TAB 4 ==========

player.CharacterAdded:Connect(function()
    wait(0.3)
    
    if destroyEnabled then
        flingCount4 = flingCount4 + 1
        killCounter4.Text = "Attacks: " .. flingCount4
        
        -- Re-equip sword
        if swordEnabled4 then
            equipSword4()
        end
        
        startFling4()
    end
end)

player.CharacterRemoving:Connect(function()
    stopFling4()
end)

-- ========== PLAYER LIST EVENTS TAB 4 ==========

Players.PlayerAdded:Connect(updatePlayerList4)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerList4()
end)

-- Initialize player list
updatePlayerList4()

-- ========== KEYBIND TOGGLE ==========

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        if mainFrame.Visible then
            mainFrame.Visible = false
            hubButton.Visible = true
        else
            hubButton.Visible = false
            mainFrame.Visible = true
        end
    end
end)

-- ========== FINAL PRINT ==========

print("═══════════════════════════════════════")
print("   ULTIMATE FLING HUB - LOADED")
print("═══════════════════════════════════════")
print("   Tab 1: Original Fling (BodyMover)")
print("   Tab 2: TP Kill (Spawn Protection Detection)")
print("   Tab 3: Ultimate Collision Fling (3 Modes + 4 Layers)")
print("   Tab 4: Combo Destroyer (Fling + Sword AUTO)")
print("═══════════════════════════════════════")
print("   Press RightCtrl to toggle hub")
print("   Drag title bar to move window")
print("═══════════════════════════════════════")
