-- MULTI-TOOL HUB
-- 5 Tabs: Original Fling | Kill Aura | Collision Fling | Combo Destroyer | KILL HUB
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Colors (Shared across all tabs)
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
    tabInactive = Color3.fromRGB(200, 200, 200)
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MultiToolHub"
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
hubButtonIcon.Text = "⚡"
hubButtonIcon.Font = Enum.Font.GothamBold
hubButtonIcon.TextSize = 22
hubButtonIcon.Parent = hubButton

-- ========== MAIN FRAME (Wide, Not Tall) ==========

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 520, 0, 320)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
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

-- ========== TITLE BAR ==========

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
titleLabel.Text = "⚡ MULTI-TOOL HUB"
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

-- ========== TAB BAR ==========

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -20, 0, 30)
tabBar.Position = UDim2.new(0, 10, 0, 40)
tabBar.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

local tabBarCorner = Instance.new("UICorner")
tabBarCorner.CornerRadius = UDim.new(0, 6)
tabBarCorner.Parent = tabBar

-- Tab Buttons (5 tabs)
local tabButtons = {}
local tabNames = {"Original Fling", "Kill Aura", "Collision", "Combo", "KILL"}
local tabWidths = {0.19, 0.18, 0.18, 0.15, 0.15}

local currentX = 0
for i, name in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = "Tab" .. i
    tabBtn.Size = UDim2.new(tabWidths[i], -4, 1, -4)
    tabBtn.Position = UDim2.new(0, currentX + 2, 0, 2)
    tabBtn.BackgroundColor3 = i == 1 and COLORS.tabActive or COLORS.tabInactive
    tabBtn.TextColor3 = i == 1 and COLORS.textLight or COLORS.textDark
    tabBtn.Text = name
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 10
    tabBtn.Parent = tabBar
    
    local tabBtnCorner = Instance.new("UICorner")
    tabBtnCorner.CornerRadius = UDim.new(0, 4)
    tabBtnCorner.Parent = tabBtn
    
    tabButtons[i] = tabBtn
    currentX = currentX + tabWidths[i]
end

-- ========== CONTENT FRAME (where tab UIs appear) ==========

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -80)
contentFrame.Position = UDim2.new(0, 10, 0, 75)
contentFrame.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 8)
contentFrameCorner.Parent = contentFrame

-- ========== TAB CONTENT FRAMES ==========

local tabContentFrames = {}
for i = 1, 5 do
    local frame = Instance.new("Frame")
    frame.Name = "TabContent" .. i
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
    frame.BorderSizePixel = 0
    frame.Visible = i == 1
    frame.Parent = contentFrame
    tabContentFrames[i] = frame
end
-- ========== TAB 1: ORIGINAL FLING CONTENT ==========

local tab1 = tabContentFrames[1]

-- Left Side
local leftFrame1 = Instance.new("Frame")
leftFrame1.Size = UDim2.new(0.5, -10, 1, -10)
leftFrame1.Position = UDim2.new(0, 5, 0, 5)
leftFrame1.BackgroundTransparency = 1
leftFrame1.Parent = tab1

-- Toggle Button
local toggle1 = Instance.new("TextButton")
toggle1.Name = "Toggle1"
toggle1.Size = UDim2.new(1, 0, 0, 35)
toggle1.Position = UDim2.new(0, 0, 0, 0)
toggle1.BackgroundColor3 = COLORS.buttonDanger
toggle1.TextColor3 = COLORS.textLight
toggle1.Text = "FLING: OFF"
toggle1.Font = Enum.Font.GothamBold
toggle1.TextSize = 14
toggle1.Parent = leftFrame1

local toggle1Corner = Instance.new("UICorner")
toggle1Corner.CornerRadius = UDim.new(0, 8)
toggle1Corner.Parent = toggle1

-- Counter
local counter1 = Instance.new("TextLabel")
counter1.Name = "Counter1"
counter1.Size = UDim2.new(1, 0, 0, 16)
counter1.Position = UDim2.new(0, 0, 0, 40)
counter1.BackgroundTransparency = 1
counter1.TextColor3 = COLORS.buttonSuccess
counter1.Text = "Flings: 0"
counter1.Font = Enum.Font.GothamBold
counter1.TextSize = 11
counter1.Parent = leftFrame1

-- Target Label
local targetLabel1 = Instance.new("TextLabel")
targetLabel1.Size = UDim2.new(1, 0, 0, 14)
targetLabel1.Position = UDim2.new(0, 0, 0, 60)
targetLabel1.BackgroundTransparency = 1
targetLabel1.TextColor3 = COLORS.textDark
targetLabel1.Text = "Select Target:"
targetLabel1.Font = Enum.Font.GothamBold
targetLabel1.TextSize = 10
targetLabel1.TextXAlignment = Enum.TextXAlignment.Left
targetLabel1.Parent = leftFrame1

-- Player List (Tab 1)
local playerScroll1 = Instance.new("ScrollingFrame")
playerScroll1.Size = UDim2.new(1, 0, 0, 100)
playerScroll1.Position = UDim2.new(0, 0, 0, 76)
playerScroll1.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
playerScroll1.ScrollBarThickness = 4
playerScroll1.Parent = leftFrame1

local playerScroll1Corner = Instance.new("UICorner")
playerScroll1Corner.CornerRadius = UDim.new(0, 6)
playerScroll1Corner.Parent = playerScroll1

local playerLayout1 = Instance.new("UIListLayout")
playerLayout1.Padding = UDim.new(0, 2)
playerLayout1.Parent = playerScroll1

-- Status (Tab 1)
local status1 = Instance.new("TextLabel")
status1.Name = "Status1"
status1.Size = UDim2.new(1, 0, 0, 16)
status1.Position = UDim2.new(0, 0, 0, 180)
status1.BackgroundTransparency = 1
status1.TextColor3 = COLORS.textMuted
status1.Text = "No target selected"
status1.Font = Enum.Font.Gotham
status1.TextSize = 9
status1.TextWrapped = true
status1.Parent = leftFrame1

-- Right Side
local rightFrame1 = Instance.new("Frame")
rightFrame1.Size = UDim2.new(0.5, -10, 1, -10)
rightFrame1.Position = UDim2.new(0.5, 5, 0, 5)
rightFrame1.BackgroundTransparency = 1
rightFrame1.Parent = tab1

-- Spin Power
local spinLabel1 = Instance.new("TextLabel")
spinLabel1.Size = UDim2.new(1, 0, 0, 14)
spinLabel1.Position = UDim2.new(0, 0, 0, 0)
spinLabel1.BackgroundTransparency = 1
spinLabel1.TextColor3 = COLORS.textDark
spinLabel1.Text = "Spin Power:"
spinLabel1.Font = Enum.Font.GothamBold
spinLabel1.TextSize = 10
spinLabel1.TextXAlignment = Enum.TextXAlignment.Left
spinLabel1.Parent = rightFrame1

local spinInput1 = Instance.new("TextBox")
spinInput1.Name = "SpinInput1"
spinInput1.Size = UDim2.new(1, 0, 0, 28)
spinInput1.Position = UDim2.new(0, 0, 0, 16)
spinInput1.BackgroundColor3 = COLORS.inputBg
spinInput1.TextColor3 = COLORS.textDark
spinInput1.Text = "999999"
spinInput1.Font = Enum.Font.Gotham
spinInput1.TextSize = 12
spinInput1.ClearTextOnFocus = false
spinInput1.Parent = rightFrame1

local spinInput1Corner = Instance.new("UICorner")
spinInput1Corner.CornerRadius = UDim.new(0, 6)
spinInput1Corner.Parent = spinInput1

local spinInput1Stroke = Instance.new("UIStroke")
spinInput1Stroke.Color = COLORS.border
spinInput1Stroke.Thickness = 1
spinInput1Stroke.Parent = spinInput1

-- Launch Power
local launchLabel1 = Instance.new("TextLabel")
launchLabel1.Size = UDim2.new(1, 0, 0, 14)
launchLabel1.Position = UDim2.new(0, 0, 0, 50)
launchLabel1.BackgroundTransparency = 1
launchLabel1.TextColor3 = COLORS.textDark
launchLabel1.Text = "Launch Power:"
launchLabel1.Font = Enum.Font.GothamBold
launchLabel1.TextSize = 10
launchLabel1.TextXAlignment = Enum.TextXAlignment.Left
launchLabel1.Parent = rightFrame1

local launchInput1 = Instance.new("TextBox")
launchInput1.Name = "LaunchInput1"
launchInput1.Size = UDim2.new(1, 0, 0, 28)
launchInput1.Position = UDim2.new(0, 0, 0, 66)
launchInput1.BackgroundColor3 = COLORS.inputBg
launchInput1.TextColor3 = COLORS.textDark
launchInput1.Text = "999999"
launchInput1.Font = Enum.Font.Gotham
launchInput1.TextSize = 12
launchInput1.ClearTextOnFocus = false
launchInput1.Parent = rightFrame1

local launchInput1Corner = Instance.new("UICorner")
launchInput1Corner.CornerRadius = UDim.new(0, 6)
launchInput1Corner.Parent = launchInput1

local launchInput1Stroke = Instance.new("UIStroke")
launchInput1Stroke.Color = COLORS.border
launchInput1Stroke.Thickness = 1
launchInput1Stroke.Parent = launchInput1

-- Info
local info1 = Instance.new("TextLabel")
info1.Size = UDim2.new(1, 0, 0, 60)
info1.Position = UDim2.new(0, 0, 0, 100)
info1.BackgroundTransparency = 1
info1.TextColor3 = COLORS.textMuted
info1.Text = "Original BodyMover Fling\nUses BodyAngularVelocity +\nBodyVelocity (visible spin)"
info1.Font = Enum.Font.Gotham
info1.TextSize = 9
info1.TextWrapped = true
info1.TextXAlignment = Enum.TextXAlignment.Left
info1.Parent = rightFrame1

-- ========== TAB 2: KILL AURA CONTENT ==========

local tab2 = tabContentFrames[2]

-- Left Side
local leftFrame2 = Instance.new("Frame")
leftFrame2.Size = UDim2.new(0.5, -10, 1, -10)
leftFrame2.Position = UDim2.new(0, 5, 0, 5)
leftFrame2.BackgroundTransparency = 1
leftFrame2.Parent = tab2

-- Toggle Button
local toggle2 = Instance.new("TextButton")
toggle2.Name = "Toggle2"
toggle2.Size = UDim2.new(1, 0, 0, 35)
toggle2.Position = UDim2.new(0, 0, 0, 0)
toggle2.BackgroundColor3 = COLORS.buttonDanger
toggle2.TextColor3 = COLORS.textLight
toggle2.Text = "KILL AURA: OFF"
toggle2.Font = Enum.Font.GothamBold
toggle2.TextSize = 14
toggle2.Parent = leftFrame2

local toggle2Corner = Instance.new("UICorner")
toggle2Corner.CornerRadius = UDim.new(0, 8)
toggle2Corner.Parent = toggle2

-- Protection Status
local protectLabel2 = Instance.new("TextLabel")
protectLabel2.Name = "ProtectLabel2"
protectLabel2.Size = UDim2.new(1, 0, 0, 16)
protectLabel2.Position = UDim2.new(0, 0, 0, 40)
protectLabel2.BackgroundTransparency = 1
protectLabel2.TextColor3 = COLORS.textMuted
protectLabel2.Text = "Protection: Waiting..."
protectLabel2.Font = Enum.Font.Gotham
protectLabel2.TextSize = 9
protectLabel2.Parent = leftFrame2

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
targetLabel2.Parent = leftFrame2

-- Player List (Tab 2)
local playerScroll2 = Instance.new("ScrollingFrame")
playerScroll2.Size = UDim2.new(1, 0, 0, 100)
playerScroll2.Position = UDim2.new(0, 0, 0, 76)
playerScroll2.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
playerScroll2.ScrollBarThickness = 4
playerScroll2.Parent = leftFrame2

local playerScroll2Corner = Instance.new("UICorner")
playerScroll2Corner.CornerRadius = UDim.new(0, 6)
playerScroll2Corner.Parent = playerScroll2

local playerLayout2 = Instance.new("UIListLayout")
playerLayout2.Padding = UDim.new(0, 2)
playerLayout2.Parent = playerScroll2

-- Status (Tab 2)
local status2 = Instance.new("TextLabel")
status2.Name = "Status2"
status2.Size = UDim2.new(1, 0, 0, 16)
status2.Position = UDim2.new(0, 0, 0, 180)
status2.BackgroundTransparency = 1
status2.TextColor3 = COLORS.textMuted
status2.Text = "No target selected"
status2.Font = Enum.Font.Gotham
status2.TextSize = 9
status2.TextWrapped = true
status2.Parent = leftFrame2

-- Right Side
local rightFrame2 = Instance.new("Frame")
rightFrame2.Size = UDim2.new(0.5, -10, 1, -10)
rightFrame2.Position = UDim2.new(0.5, 5, 0, 5)
rightFrame2.BackgroundTransparency = 1
rightFrame2.Parent = tab2

-- Attack Delay
local delayLabel2 = Instance.new("TextLabel")
delayLabel2.Size = UDim2.new(1, 0, 0, 14)
delayLabel2.Position = UDim2.new(0, 0, 0, 0)
delayLabel2.BackgroundTransparency = 1
delayLabel2.TextColor3 = COLORS.textDark
delayLabel2.Text = "Attack Delay:"
delayLabel2.Font = Enum.Font.GothamBold
delayLabel2.TextSize = 10
delayLabel2.TextXAlignment = Enum.TextXAlignment.Left
delayLabel2.Parent = rightFrame2

local delayInput2 = Instance.new("TextBox")
delayInput2.Name = "DelayInput2"
delayInput2.Size = UDim2.new(1, 0, 0, 28)
delayInput2.Position = UDim2.new(0, 0, 0, 16)
delayInput2.BackgroundColor3 = COLORS.inputBg
delayInput2.TextColor3 = COLORS.textDark
delayInput2.Text = "0.05"
delayInput2.Font = Enum.Font.Gotham
delayInput2.TextSize = 12
delayInput2.ClearTextOnFocus = false
delayInput2.Parent = rightFrame2

local delayInput2Corner = Instance.new("UICorner")
delayInput2Corner.CornerRadius = UDim.new(0, 6)
delayInput2Corner.Parent = delayInput2

local delayInput2Stroke = Instance.new("UIStroke")
delayInput2Stroke.Color = COLORS.border
delayInput2Stroke.Thickness = 1
delayInput2Stroke.Parent = delayInput2

-- Swings Per Attack
local swingsLabel2 = Instance.new("TextLabel")
swingsLabel2.Size = UDim2.new(1, 0, 0, 14)
swingsLabel2.Position = UDim2.new(0, 0, 0, 50)
swingsLabel2.BackgroundTransparency = 1
swingsLabel2.TextColor3 = COLORS.textDark
swingsLabel2.Text = "Swings/Attack:"
swingsLabel2.Font = Enum.Font.GothamBold
swingsLabel2.TextSize = 10
swingsLabel2.TextXAlignment = Enum.TextXAlignment.Left
swingsLabel2.Parent = rightFrame2

local swingsInput2 = Instance.new("TextBox")
swingsInput2.Name = "SwingsInput2"
swingsInput2.Size = UDim2.new(1, 0, 0, 28)
swingsInput2.Position = UDim2.new(0, 0, 0, 66)
swingsInput2.BackgroundColor3 = COLORS.inputBg
swingsInput2.TextColor3 = COLORS.textDark
swingsInput2.Text = "3"
swingsInput2.Font = Enum.Font.Gotham
swingsInput2.TextSize = 12
swingsInput2.ClearTextOnFocus = false
swingsInput2.Parent = rightFrame2

local swingsInput2Corner = Instance.new("UICorner")
swingsInput2Corner.CornerRadius = UDim.new(0, 6)
swingsInput2Corner.Parent = swingsInput2

local swingsInput2Stroke = Instance.new("UIStroke")
swingsInput2Stroke.Color = COLORS.border
swingsInput2Stroke.Thickness = 1
swingsInput2Stroke.Parent = swingsInput2

-- Info
local info2 = Instance.new("TextLabel")
info2.Size = UDim2.new(1, 0, 0, 60)
info2.Position = UDim2.new(0, 0, 0, 100)
info2.BackgroundTransparency = 1
info2.TextColor3 = COLORS.textMuted
info2.Text = "Auto sword attack\nDetects spawn protection\nWaits for vulnerable target"
info2.Font = Enum.Font.Gotham
info2.TextSize = 9
info2.TextWrapped = true
info2.TextXAlignment = Enum.TextXAlignment.Left
info2.Parent = rightFrame2
-- ========== TAB 3: COLLISION FLING CONTENT ==========

local tab3 = tabContentFrames[3]

-- Left Side
local leftFrame3 = Instance.new("Frame")
leftFrame3.Size = UDim2.new(0.5, -10, 1, -10)
leftFrame3.Position = UDim2.new(0, 5, 0, 5)
leftFrame3.BackgroundTransparency = 1
leftFrame3.Parent = tab3

-- Toggle Button
local toggle3 = Instance.new("TextButton")
toggle3.Name = "Toggle3"
toggle3.Size = UDim2.new(1, 0, 0, 35)
toggle3.Position = UDim2.new(0, 0, 0, 0)
toggle3.BackgroundColor3 = COLORS.buttonDanger
toggle3.TextColor3 = COLORS.textLight
toggle3.Text = "COLLISION: OFF"
toggle3.Font = Enum.Font.GothamBold
toggle3.TextSize = 14
toggle3.Parent = leftFrame3

local toggle3Corner = Instance.new("UICorner")
toggle3Corner.CornerRadius = UDim.new(0, 8)
toggle3Corner.Parent = toggle3

-- Counter
local counter3 = Instance.new("TextLabel")
counter3.Name = "Counter3"
counter3.Size = UDim2.new(1, 0, 0, 16)
counter3.Position = UDim2.new(0, 0, 0, 40)
counter3.BackgroundTransparency = 1
counter3.TextColor3 = COLORS.buttonSuccess
counter3.Text = "Flings: 0"
counter3.Font = Enum.Font.GothamBold
counter3.TextSize = 11
counter3.Parent = leftFrame3

-- Target Label
local targetLabel3 = Instance.new("TextLabel")
targetLabel3.Size = UDim2.new(1, 0, 0, 14)
targetLabel3.Position = UDim2.new(0, 0, 0, 58)
targetLabel3.BackgroundTransparency = 1
targetLabel3.TextColor3 = COLORS.textDark
targetLabel3.Text = "Select Target:"
targetLabel3.Font = Enum.Font.GothamBold
targetLabel3.TextSize = 10
targetLabel3.TextXAlignment = Enum.TextXAlignment.Left
targetLabel3.Parent = leftFrame3

-- Player List (Tab 3)
local playerScroll3 = Instance.new("ScrollingFrame")
playerScroll3.Size = UDim2.new(1, 0, 0, 70)
playerScroll3.Position = UDim2.new(0, 0, 0, 74)
playerScroll3.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
playerScroll3.ScrollBarThickness = 4
playerScroll3.Parent = leftFrame3

local playerScroll3Corner = Instance.new("UICorner")
playerScroll3Corner.CornerRadius = UDim.new(0, 6)
playerScroll3Corner.Parent = playerScroll3

local playerLayout3 = Instance.new("UIListLayout")
playerLayout3.Padding = UDim.new(0, 2)
playerLayout3.Parent = playerScroll3

-- Status (Tab 3)
local status3 = Instance.new("TextLabel")
status3.Name = "Status3"
status3.Size = UDim2.new(1, 0, 0, 14)
status3.Position = UDim2.new(0, 0, 0, 148)
status3.BackgroundTransparency = 1
status3.TextColor3 = COLORS.textMuted
status3.Text = "No target selected"
status3.Font = Enum.Font.Gotham
status3.TextSize = 9
status3.TextWrapped = true
status3.Parent = leftFrame3

-- Mode Label
local modeLabel3 = Instance.new("TextLabel")
modeLabel3.Size = UDim2.new(1, 0, 0, 14)
modeLabel3.Position = UDim2.new(0, 0, 0, 165)
modeLabel3.BackgroundTransparency = 1
modeLabel3.TextColor3 = COLORS.textDark
modeLabel3.Text = "Mode:"
modeLabel3.Font = Enum.Font.GothamBold
modeLabel3.TextSize = 10
modeLabel3.TextXAlignment = Enum.TextXAlignment.Left
modeLabel3.Parent = leftFrame3

-- Mode Buttons
local modeBtn1_3 = Instance.new("TextButton")
modeBtn1_3.Name = "ModeDevastate3"
modeBtn1_3.Size = UDim2.new(0.33, -2, 0, 22)
modeBtn1_3.Position = UDim2.new(0, 0, 0, 182)
modeBtn1_3.BackgroundColor3 = COLORS.buttonSuccess
modeBtn1_3.TextColor3 = COLORS.textLight
modeBtn1_3.Text = "DEVASTATE"
modeBtn1_3.Font = Enum.Font.GothamBold
modeBtn1_3.TextSize = 8
modeBtn1_3.Parent = leftFrame3

local modeBtn1_3Corner = Instance.new("UICorner")
modeBtn1_3Corner.CornerRadius = UDim.new(0, 4)
modeBtn1_3Corner.Parent = modeBtn1_3

local modeBtn2_3 = Instance.new("TextButton")
modeBtn2_3.Name = "ModeOrbital3"
modeBtn2_3.Size = UDim2.new(0.33, -2, 0, 22)
modeBtn2_3.Position = UDim2.new(0.33, 1, 0, 182)
modeBtn2_3.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
modeBtn2_3.TextColor3 = COLORS.textDark
modeBtn2_3.Text = "ORBITAL"
modeBtn2_3.Font = Enum.Font.Gotham
modeBtn2_3.TextSize = 8
modeBtn2_3.Parent = leftFrame3

local modeBtn2_3Corner = Instance.new("UICorner")
modeBtn2_3Corner.CornerRadius = UDim.new(0, 4)
modeBtn2_3Corner.Parent = modeBtn2_3

local modeBtn3_3 = Instance.new("TextButton")
modeBtn3_3.Name = "ModeChaos3"
modeBtn3_3.Size = UDim2.new(0.34, -2, 0, 22)
modeBtn3_3.Position = UDim2.new(0.66, 2, 0, 182)
modeBtn3_3.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
modeBtn3_3.TextColor3 = COLORS.textDark
modeBtn3_3.Text = "CHAOS"
modeBtn3_3.Font = Enum.Font.Gotham
modeBtn3_3.TextSize = 8
modeBtn3_3.Parent = leftFrame3

local modeBtn3_3Corner = Instance.new("UICorner")
modeBtn3_3Corner.CornerRadius = UDim.new(0, 4)
modeBtn3_3Corner.Parent = modeBtn3_3

-- Right Side
local rightFrame3 = Instance.new("Frame")
rightFrame3.Size = UDim2.new(0.5, -10, 1, -10)
rightFrame3.Position = UDim2.new(0.5, 5, 0, 5)
rightFrame3.BackgroundTransparency = 1
rightFrame3.Parent = tab3

-- Velocity
local velLabel3 = Instance.new("TextLabel")
velLabel3.Size = UDim2.new(0.5, -2, 0, 14)
velLabel3.Position = UDim2.new(0, 0, 0, 0)
velLabel3.BackgroundTransparency = 1
velLabel3.TextColor3 = COLORS.textDark
velLabel3.Text = "Velocity:"
velLabel3.Font = Enum.Font.GothamBold
velLabel3.TextSize = 9
velLabel3.TextXAlignment = Enum.TextXAlignment.Left
velLabel3.Parent = rightFrame3

local velInput3 = Instance.new("TextBox")
velInput3.Name = "VelInput3"
velInput3.Size = UDim2.new(0.5, -2, 0, 24)
velInput3.Position = UDim2.new(0.5, 2, 0, 0)
velInput3.BackgroundColor3 = COLORS.inputBg
velInput3.TextColor3 = COLORS.textDark
velInput3.Text = "999999"
velInput3.Font = Enum.Font.Gotham
velInput3.TextSize = 10
velInput3.ClearTextOnFocus = false
velInput3.Parent = rightFrame3

local velInput3Corner = Instance.new("UICorner")
velInput3Corner.CornerRadius = UDim.new(0, 4)
velInput3Corner.Parent = velInput3

local velInput3Stroke = Instance.new("UIStroke")
velInput3Stroke.Color = COLORS.border
velInput3Stroke.Thickness = 1
velInput3Stroke.Parent = velInput3

-- Angular
local angLabel3 = Instance.new("TextLabel")
angLabel3.Size = UDim2.new(0.5, -2, 0, 14)
angLabel3.Position = UDim2.new(0, 0, 0, 28)
angLabel3.BackgroundTransparency = 1
angLabel3.TextColor3 = COLORS.textDark
angLabel3.Text = "Angular:"
angLabel3.Font = Enum.Font.GothamBold
angLabel3.TextSize = 9
angLabel3.TextXAlignment = Enum.TextXAlignment.Left
angLabel3.Parent = rightFrame3

local angInput3 = Instance.new("TextBox")
angInput3.Name = "AngInput3"
angInput3.Size = UDim2.new(0.5, -2, 0, 24)
angInput3.Position = UDim2.new(0.5, 2, 0, 28)
angInput3.BackgroundColor3 = COLORS.inputBg
angInput3.TextColor3 = COLORS.textDark
angInput3.Text = "999999"
angInput3.Font = Enum.Font.Gotham
angInput3.TextSize = 10
angInput3.ClearTextOnFocus = false
angInput3.Parent = rightFrame3

local angInput3Corner = Instance.new("UICorner")
angInput3Corner.CornerRadius = UDim.new(0, 4)
angInput3Corner.Parent = angInput3

local angInput3Stroke = Instance.new("UIStroke")
angInput3Stroke.Color = COLORS.border
angInput3Stroke.Thickness = 1
angInput3Stroke.Parent = angInput3

-- Toggles Frame
local togglesFrame3 = Instance.new("Frame")
togglesFrame3.Size = UDim2.new(1, 0, 0, 100)
togglesFrame3.Position = UDim2.new(0, 0, 0, 56)
togglesFrame3.BackgroundTransparency = 1
togglesFrame3.Parent = rightFrame3

-- Velocity Toggle
local velToggle3 = Instance.new("TextButton")
velToggle3.Name = "VelToggle3"
velToggle3.Size = UDim2.new(1, 0, 0, 22)
velToggle3.Position = UDim2.new(0, 0, 0, 0)
velToggle3.BackgroundColor3 = COLORS.buttonSuccess
velToggle3.TextColor3 = COLORS.textLight
velToggle3.Text = "✓ Velocity Burst"
velToggle3.Font = Enum.Font.Gotham
velToggle3.TextSize = 9
velToggle3.Parent = togglesFrame3

local velToggle3Corner = Instance.new("UICorner")
velToggle3Corner.CornerRadius = UDim.new(0, 4)
velToggle3Corner.Parent = velToggle3

-- Angular Toggle
local angToggle3 = Instance.new("TextButton")
angToggle3.Name = "AngToggle3"
angToggle3.Size = UDim2.new(1, 0, 0, 22)
angToggle3.Position = UDim2.new(0, 0, 0, 26)
angToggle3.BackgroundColor3 = COLORS.buttonSuccess
angToggle3.TextColor3 = COLORS.textLight
angToggle3.Text = "✓ Angular Force"
angToggle3.Font = Enum.Font.Gotham
angToggle3.TextSize = 9
angToggle3.Parent = togglesFrame3

local angToggle3Corner = Instance.new("UICorner")
angToggle3Corner.CornerRadius = UDim.new(0, 4)
angToggle3Corner.Parent = angToggle3

-- Teleport Toggle
local tpToggle3 = Instance.new("TextButton")
tpToggle3.Name = "TpToggle3"
tpToggle3.Size = UDim2.new(1, 0, 0, 22)
tpToggle3.Position = UDim2.new(0, 0, 0, 52)
tpToggle3.BackgroundColor3 = COLORS.buttonSuccess
tpToggle3.TextColor3 = COLORS.textLight
tpToggle3.Text = "✓ Rapid Teleport"
tpToggle3.Font = Enum.Font.Gotham
tpToggle3.TextSize = 9
tpToggle3.Parent = togglesFrame3

local tpToggle3Corner = Instance.new("UICorner")
tpToggle3Corner.CornerRadius = UDim.new(0, 4)
tpToggle3Corner.Parent = tpToggle3

-- Mass Toggle
local massToggle3 = Instance.new("TextButton")
massToggle3.Name = "MassToggle3"
massToggle3.Size = UDim2.new(1, 0, 0, 22)
massToggle3.Position = UDim2.new(0, 0, 0, 78)
massToggle3.BackgroundColor3 = COLORS.buttonSuccess
massToggle3.TextColor3 = COLORS.textLight
massToggle3.Text = "✓ Mass Boost"
massToggle3.Font = Enum.Font.Gotham
massToggle3.TextSize = 9
massToggle3.Parent = togglesFrame3

local massToggle3Corner = Instance.new("UICorner")
massToggle3Corner.CornerRadius = UDim.new(0, 4)
massToggle3Corner.Parent = massToggle3
-- ========== TAB 4: COMBO DESTROYER CONTENT ==========

local tab4 = tabContentFrames[4]

-- Left Side
local leftFrame4 = Instance.new("Frame")
leftFrame4.Size = UDim2.new(0.5, -10, 1, -10)
leftFrame4.Position = UDim2.new(0, 5, 0, 5)
leftFrame4.BackgroundTransparency = 1
leftFrame4.Parent = tab4

-- Toggle Button
local toggle4 = Instance.new("TextButton")
toggle4.Name = "Toggle4"
toggle4.Size = UDim2.new(1, 0, 0, 35)
toggle4.Position = UDim2.new(0, 0, 0, 0)
toggle4.BackgroundColor3 = COLORS.buttonDanger
toggle4.TextColor3 = COLORS.textLight
toggle4.Text = "DESTROY: OFF"
toggle4.Font = Enum.Font.GothamBold
toggle4.TextSize = 14
toggle4.Parent = leftFrame4

local toggle4Corner = Instance.new("UICorner")
toggle4Corner.CornerRadius = UDim.new(0, 8)
toggle4Corner.Parent = toggle4

-- Counter
local counter4 = Instance.new("TextLabel")
counter4.Name = "Counter4"
counter4.Size = UDim2.new(1, 0, 0, 16)
counter4.Position = UDim2.new(0, 0, 0, 40)
counter4.BackgroundTransparency = 1
counter4.TextColor3 = COLORS.buttonSuccess
counter4.Text = "Attacks: 0"
counter4.Font = Enum.Font.GothamBold
counter4.TextSize = 11
counter4.Parent = leftFrame4

-- Target Label
local targetLabel4 = Instance.new("TextLabel")
targetLabel4.Size = UDim2.new(1, 0, 0, 14)
targetLabel4.Position = UDim2.new(0, 0, 0, 58)
targetLabel4.BackgroundTransparency = 1
targetLabel4.TextColor3 = COLORS.textDark
targetLabel4.Text = "Select Target:"
targetLabel4.Font = Enum.Font.GothamBold
targetLabel4.TextSize = 10
targetLabel4.TextXAlignment = Enum.TextXAlignment.Left
targetLabel4.Parent = leftFrame4

-- Player List (Tab 4)
local playerScroll4 = Instance.new("ScrollingFrame")
playerScroll4.Size = UDim2.new(1, 0, 0, 70)
playerScroll4.Position = UDim2.new(0, 0, 0, 74)
playerScroll4.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
playerScroll4.ScrollBarThickness = 4
playerScroll4.Parent = leftFrame4

local playerScroll4Corner = Instance.new("UICorner")
playerScroll4Corner.CornerRadius = UDim.new(0, 6)
playerScroll4Corner.Parent = playerScroll4

local playerLayout4 = Instance.new("UIListLayout")
playerLayout4.Padding = UDim.new(0, 2)
playerLayout4.Parent = playerScroll4

-- Status (Tab 4)
local status4 = Instance.new("TextLabel")
status4.Name = "Status4"
status4.Size = UDim2.new(1, 0, 0, 14)
status4.Position = UDim2.new(0, 0, 0, 148)
status4.BackgroundTransparency = 1
status4.TextColor3 = COLORS.textMuted
status4.Text = "No target selected"
status4.Font = Enum.Font.Gotham
status4.TextSize = 9
status4.TextWrapped = true
status4.Parent = leftFrame4

-- Mode Label
local modeLabel4 = Instance.new("TextLabel")
modeLabel4.Size = UDim2.new(1, 0, 0, 14)
modeLabel4.Position = UDim2.new(0, 0, 0, 165)
modeLabel4.BackgroundTransparency = 1
modeLabel4.TextColor3 = COLORS.textDark
modeLabel4.Text = "Fling Mode:"
modeLabel4.Font = Enum.Font.GothamBold
modeLabel4.TextSize = 10
modeLabel4.TextXAlignment = Enum.TextXAlignment.Left
modeLabel4.Parent = leftFrame4

-- Mode Buttons
local modeBtn1_4 = Instance.new("TextButton")
modeBtn1_4.Name = "ModeDevastate4"
modeBtn1_4.Size = UDim2.new(0.33, -2, 0, 22)
modeBtn1_4.Position = UDim2.new(0, 0, 0, 182)
modeBtn1_4.BackgroundColor3 = COLORS.buttonSuccess
modeBtn1_4.TextColor3 = COLORS.textLight
modeBtn1_4.Text = "DEVASTATE"
modeBtn1_4.Font = Enum.Font.GothamBold
modeBtn1_4.TextSize = 8
modeBtn1_4.Parent = leftFrame4

local modeBtn1_4Corner = Instance.new("UICorner")
modeBtn1_4Corner.CornerRadius = UDim.new(0, 4)
modeBtn1_4Corner.Parent = modeBtn1_4

local modeBtn2_4 = Instance.new("TextButton")
modeBtn2_4.Name = "ModeOrbital4"
modeBtn2_4.Size = UDim2.new(0.33, -2, 0, 22)
modeBtn2_4.Position = UDim2.new(0.33, 1, 0, 182)
modeBtn2_4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
modeBtn2_4.TextColor3 = COLORS.textDark
modeBtn2_4.Text = "ORBITAL"
modeBtn2_4.Font = Enum.Font.Gotham
modeBtn2_4.TextSize = 8
modeBtn2_4.Parent = leftFrame4

local modeBtn2_4Corner = Instance.new("UICorner")
modeBtn2_4Corner.CornerRadius = UDim.new(0, 4)
modeBtn2_4Corner.Parent = modeBtn2_4

local modeBtn3_4 = Instance.new("TextButton")
modeBtn3_4.Name = "ModeChaos4"
modeBtn3_4.Size = UDim2.new(0.34, -2, 0, 22)
modeBtn3_4.Position = UDim2.new(0.66, 2, 0, 182)
modeBtn3_4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
modeBtn3_4.TextColor3 = COLORS.textDark
modeBtn3_4.Text = "CHAOS"
modeBtn3_4.Font = Enum.Font.Gotham
modeBtn3_4.TextSize = 8
modeBtn3_4.Parent = leftFrame4

local modeBtn3_4Corner = Instance.new("UICorner")
modeBtn3_4Corner.CornerRadius = UDim.new(0, 4)
modeBtn3_4Corner.Parent = modeBtn3_4

-- Right Side
local rightFrame4 = Instance.new("Frame")
rightFrame4.Size = UDim2.new(0.5, -10, 1, -10)
rightFrame4.Position = UDim2.new(0.5, 5, 0, 5)
rightFrame4.BackgroundTransparency = 1
rightFrame4.Parent = tab4

-- Sword Section
local swordLabel4 = Instance.new("TextLabel")
swordLabel4.Size = UDim2.new(1, 0, 0, 14)
swordLabel4.Position = UDim2.new(0, 0, 0, 0)
swordLabel4.BackgroundTransparency = 1
swordLabel4.TextColor3 = COLORS.buttonPrimary
swordLabel4.Text = "⚔️ SWORD SETTINGS"
swordLabel4.Font = Enum.Font.GothamBold
swordLabel4.TextSize = 10
swordLabel4.TextXAlignment = Enum.TextXAlignment.Left
swordLabel4.Parent = rightFrame4

-- Sword Toggle
local swordToggle4 = Instance.new("TextButton")
swordToggle4.Name = "SwordToggle4"
swordToggle4.Size = UDim2.new(1, 0, 0, 22)
swordToggle4.Position = UDim2.new(0, 0, 0, 16)
swordToggle4.BackgroundColor3 = COLORS.buttonSuccess
swordToggle4.TextColor3 = COLORS.textLight
swordToggle4.Text = "✓ Auto Sword Attack"
swordToggle4.Font = Enum.Font.Gotham
swordToggle4.TextSize = 9
swordToggle4.Parent = rightFrame4

local swordToggle4Corner = Instance.new("UICorner")
swordToggle4Corner.CornerRadius = UDim.new(0, 4)
swordToggle4Corner.Parent = swordToggle4

-- Swings
local swingsLabel4 = Instance.new("TextLabel")
swingsLabel4.Size = UDim2.new(0.5, -2, 0, 14)
swingsLabel4.Position = UDim2.new(0, 0, 0, 42)
swingsLabel4.BackgroundTransparency = 1
swingsLabel4.TextColor3 = COLORS.textDark
swingsLabel4.Text = "Swings:"
swingsLabel4.Font = Enum.Font.Gotham
swingsLabel4.TextSize = 9
swingsLabel4.TextXAlignment = Enum.TextXAlignment.Left
swingsLabel4.Parent = rightFrame4

local swingsInput4 = Instance.new("TextBox")
swingsInput4.Name = "SwingsInput4"
swingsInput4.Size = UDim2.new(0.5, -2, 0, 24)
swingsInput4.Position = UDim2.new(0.5, 2, 0, 42)
swingsInput4.BackgroundColor3 = COLORS.inputBg
swingsInput4.TextColor3 = COLORS.textDark
swingsInput4.Text = "3"
swingsInput4.Font = Enum.Font.Gotham
swingsInput4.TextSize = 10
swingsInput4.ClearTextOnFocus = false
swingsInput4.Parent = rightFrame4

local swingsInput4Corner = Instance.new("UICorner")
swingsInput4Corner.CornerRadius = UDim.new(0, 4)
swingsInput4Corner.Parent = swingsInput4

local swingsInput4Stroke = Instance.new("UIStroke")
swingsInput4Stroke.Color = COLORS.border
swingsInput4Stroke.Thickness = 1
swingsInput4Stroke.Parent = swingsInput4

-- Reach
local reachLabel4 = Instance.new("TextLabel")
reachLabel4.Size = UDim2.new(0.5, -2, 0, 14)
reachLabel4.Position = UDim2.new(0, 0, 0, 70)
reachLabel4.BackgroundTransparency = 1
reachLabel4.TextColor3 = COLORS.textDark
reachLabel4.Text = "Reach:"
reachLabel4.Font = Enum.Font.Gotham
reachLabel4.TextSize = 9
reachLabel4.TextXAlignment = Enum.TextXAlignment.Left
reachLabel4.Parent = rightFrame4

local reachInput4 = Instance.new("TextBox")
reachInput4.Name = "ReachInput4"
reachInput4.Size = UDim2.new(0.5, -2, 0, 24)
reachInput4.Position = UDim2.new(0.5, 2, 0, 70)
reachInput4.BackgroundColor3 = COLORS.inputBg
reachInput4.TextColor3 = COLORS.textDark
reachInput4.Text = "15"
reachInput4.Font = Enum.Font.Gotham
reachInput4.TextSize = 10
reachInput4.ClearTextOnFocus = false
reachInput4.Parent = rightFrame4

local reachInput4Corner = Instance.new("UICorner")
reachInput4Corner.CornerRadius = UDim.new(0, 4)
reachInput4Corner.Parent = reachInput4

local reachInput4Stroke = Instance.new("UIStroke")
reachInput4Stroke.Color = COLORS.border
reachInput4Stroke.Thickness = 1
reachInput4Stroke.Parent = reachInput4

-- Fling Section
local flingLabel4 = Instance.new("TextLabel")
flingLabel4.Size = UDim2.new(1, 0, 0, 14)
flingLabel4.Position = UDim2.new(0, 0, 0, 100)
flingLabel4.BackgroundTransparency = 1
flingLabel4.TextColor3 = COLORS.buttonDanger
flingLabel4.Text = "💥 FLING SETTINGS"
flingLabel4.Font = Enum.Font.GothamBold
flingLabel4.TextSize = 10
flingLabel4.TextXAlignment = Enum.TextXAlignment.Left
flingLabel4.Parent = rightFrame4

-- Velocity
local velLabel4 = Instance.new("TextLabel")
velLabel4.Size = UDim2.new(0.5, -2, 0, 14)
velLabel4.Position = UDim2.new(0, 0, 0, 116)
velLabel4.BackgroundTransparency = 1
velLabel4.TextColor3 = COLORS.textDark
velLabel4.Text = "Velocity:"
velLabel4.Font = Enum.Font.Gotham
velLabel4.TextSize = 9
velLabel4.TextXAlignment = Enum.TextXAlignment.Left
velLabel4.Parent = rightFrame4

local velInput4 = Instance.new("TextBox")
velInput4.Name = "VelInput4"
velInput4.Size = UDim2.new(0.5, -2, 0, 24)
velInput4.Position = UDim2.new(0.5, 2, 0, 116)
velInput4.BackgroundColor3 = COLORS.inputBg
velInput4.TextColor3 = COLORS.textDark
velInput4.Text = "999999"
velInput4.Font = Enum.Font.Gotham
velInput4.TextSize = 10
velInput4.ClearTextOnFocus = false
velInput4.Parent = rightFrame4

local velInput4Corner = Instance.new("UICorner")
velInput4Corner.CornerRadius = UDim.new(0, 4)
velInput4Corner.Parent = velInput4

local velInput4Stroke = Instance.new("UIStroke")
velInput4Stroke.Color = COLORS.border
velInput4Stroke.Thickness = 1
velInput4Stroke.Parent = velInput4

-- Angular
local angLabel4 = Instance.new("TextLabel")
angLabel4.Size = UDim2.new(0.5, -2, 0, 14)
angLabel4.Position = UDim2.new(0, 0, 0, 144)
angLabel4.BackgroundTransparency = 1
angLabel4.TextColor3 = COLORS.textDark
angLabel4.Text = "Angular:"
angLabel4.Font = Enum.Font.Gotham
angLabel4.TextSize = 9
angLabel4.TextXAlignment = Enum.TextXAlignment.Left
angLabel4.Parent = rightFrame4

local angInput4 = Instance.new("TextBox")
angInput4.Name = "AngInput4"
angInput4.Size = UDim2.new(0.5, -2, 0, 24)
angInput4.Position = UDim2.new(0.5, 2, 0, 144)
angInput4.BackgroundColor3 = COLORS.inputBg
angInput4.TextColor3 = COLORS.textDark
angInput4.Text = "999999"
angInput4.Font = Enum.Font.Gotham
angInput4.TextSize = 10
angInput4.ClearTextOnFocus = false
angInput4.Parent = rightFrame4

local angInput4Corner = Instance.new("UICorner")
angInput4Corner.CornerRadius = UDim.new(0, 4)
angInput4Corner.Parent = angInput4

local angInput4Stroke = Instance.new("UIStroke")
angInput4Stroke.Color = COLORS.border
angInput4Stroke.Thickness = 1
angInput4Stroke.Parent = angInput4

-- ========== TAB 5: KILL HUB ==========

local tab5 = tabContentFrames[5]

local killFrame = Instance.new("Frame")
killFrame.Size = UDim2.new(1, 0, 1, 0)
killFrame.BackgroundColor3 = Color3.fromRGB(255, 240, 240)
killFrame.BorderSizePixel = 0
killFrame.Parent = tab5

local killFrameCorner = Instance.new("UICorner")
killFrameCorner.CornerRadius = UDim.new(0, 8)
killFrameCorner.Parent = killFrame

local killIcon = Instance.new("TextLabel")
killIcon.Size = UDim2.new(1, 0, 0, 60)
killIcon.Position = UDim2.new(0, 0, 0.3, 0)
killIcon.BackgroundTransparency = 1
killIcon.TextColor3 = COLORS.buttonDanger
killIcon.Text = "⚠️"
killIcon.Font = Enum.Font.GothamBold
killIcon.TextSize = 48
killIcon.Parent = killFrame

local killTitle = Instance.new("TextLabel")
killTitle.Size = UDim2.new(1, 0, 0, 30)
killTitle.Position = UDim2.new(0, 0, 0.5, 0)
killTitle.BackgroundTransparency = 1
killTitle.TextColor3 = COLORS.buttonDanger
killTitle.Text = "KILL HUB"
killTitle.Font = Enum.Font.GothamBold
killTitle.TextSize = 20
killTitle.Parent = killFrame

local killDesc = Instance.new("TextLabel")
killDesc.Size = UDim2.new(1, -40, 0, 40)
killDesc.Position = UDim2.new(0, 20, 0.6, 0)
killDesc.BackgroundTransparency = 1
killDesc.TextColor3 = COLORS.textDark
killDesc.Text = "This will completely remove the hub from your screen. You will need to re-execute the script to get it back."
killDesc.Font = Enum.Font.Gotham
killDesc.TextSize = 11
killDesc.TextWrapped = true
killDesc.Parent = killFrame

local killButton = Instance.new("TextButton")
killButton.Name = "KillButton"
killButton.Size = UDim2.new(0.5, 0, 0, 40)
killButton.Position = UDim2.new(0.25, 0, 0.8, 0)
killButton.BackgroundColor3 = COLORS.buttonDanger
killButton.TextColor3 = COLORS.textLight
killButton.Text = "KILL HUB"
killButton.Font = Enum.Font.GothamBold
killButton.TextSize = 14
killButton.Parent = killFrame

local killButtonCorner = Instance.new("UICorner")
killButtonCorner.CornerRadius = UDim.new(0, 8)
killButtonCorner.Parent = killButton
-- ========== DRAGGING LOGIC ==========

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

-- ========== TAB SWITCHING ==========

local currentTab = 1

local function switchTab(tabNum)
    currentTab = tabNum
    
    for i, btn in ipairs(tabButtons) do
        if i == tabNum then
            btn.BackgroundColor3 = COLORS.tabActive
            btn.TextColor3 = COLORS.textLight
        else
            btn.BackgroundColor3 = COLORS.tabInactive
            btn.TextColor3 = COLORS.textDark
        end
    end
    
    for i, frame in ipairs(tabContentFrames) do
        frame.Visible = (i == tabNum)
    end
end

for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(i)
    end)
end

-- ========== SHARED VARIABLES ==========

local targetPlayer = nil
local playerLists = {playerScroll1, playerScroll2, playerScroll3, playerScroll4}
local playerButtons = {}

-- ========== PLAYER LIST UPDATE ==========

local function updateAllPlayerLists()
    for scrollIdx, scroll in ipairs(playerLists) do
        for _, btn in pairs(scroll:GetChildren()) do
            if btn:IsA("TextButton") then
                btn:Destroy()
            end
        end
    end
    playerButtons = {}
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            for scrollIdx, scroll in ipairs(playerLists) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 20)
                btn.BackgroundColor3 = targetPlayer == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
                btn.TextColor3 = targetPlayer == plr and COLORS.textLight or COLORS.textDark
                btn.Text = plr.Name
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 9
                btn.Parent = scroll
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    targetPlayer = plr
                    status1.Text = "Target: " .. plr.Name
                    status2.Text = "Target: " .. plr.Name
                    status3.Text = "Target: " .. plr.Name
                    status4.Text = "Target: " .. plr.Name
                    updateAllPlayerLists()
                end)
            end
        end
    end
    
    for _, scroll in ipairs(playerLists) do
        scroll.CanvasSize = UDim2.new(0, 0, 0, scroll:GetChildren()[1] and 22 or 0)
    end
end

Players.PlayerAdded:Connect(updateAllPlayerLists)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updateAllPlayerLists()
end)

updateAllPlayerLists()

-- ========== KILL HUB BUTTON ==========

killButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("✅ Hub killed. Re-execute script to restore.")
end)

-- ========== MODE BUTTONS - TAB 3 ==========

local collisionMode3 = "devastate"

modeBtn1_3.MouseButton1Click:Connect(function()
    collisionMode3 = "devastate"
    modeBtn1_3.BackgroundColor3 = COLORS.buttonSuccess
    modeBtn1_3.TextColor3 = COLORS.textLight
    modeBtn2_3.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    modeBtn2_3.TextColor3 = COLORS.textDark
    modeBtn3_3.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    modeBtn3_3.TextColor3 = COLORS.textDark
end)

modeBtn2_3.MouseButton1Click:Connect(function()
    collisionMode3 = "orbital"
    modeBtn1_3.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    modeBtn1_3.TextColor3 = COLORS.textDark
    modeBtn2_3.BackgroundColor3 = COLORS.buttonSuccess
    modeBtn2_3.TextColor3 = COLORS.textLight
    modeBtn3_3.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    modeBtn3_3.TextColor3 = COLORS.textDark
end)

modeBtn3_3.MouseButton1Click:Connect(function()
    collisionMode3 = "chaos"
    modeBtn1_3.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    modeBtn1_3.TextColor3 = COLORS.textDark
    modeBtn2_3.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    modeBtn2_3.TextColor3 = COLORS.textDark
    modeBtn3_3.BackgroundColor3 = COLORS.buttonSuccess
    modeBtn3_3.TextColor3 = COLORS.textLight
end)

-- ========== MODE BUTTONS - TAB 4 ==========

local collisionMode4 = "devastate"

modeBtn1_4.MouseButton1Click:Connect(function()
    collisionMode4 = "devastate"
    modeBtn1_4.BackgroundColor3 = COLORS.buttonSuccess
    modeBtn1_4.TextColor3 = COLORS.textLight
    modeBtn2_4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    modeBtn2_4.TextColor3 = COLORS.textDark
    modeBtn3_4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    modeBtn3_4.TextColor3 = COLORS.textDark
end)

modeBtn2_4.MouseButton1Click:Connect(function()
    collisionMode4 = "orbital"
    modeBtn1_4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    modeBtn1_4.TextColor3 = COLORS.textDark
    modeBtn2_4.BackgroundColor3 = COLORS.buttonSuccess
    modeBtn2_4.TextColor3 = COLORS.textLight
    modeBtn3_4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    modeBtn3_4.TextColor3 = COLORS.textDark
end)

modeBtn3_4.MouseButton1Click:Connect(function()
    collisionMode4 = "chaos"
    modeBtn1_4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    modeBtn1_4.TextColor3 = COLORS.textDark
    modeBtn2_4.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    modeBtn2_4.TextColor3 = COLORS.textDark
    modeBtn3_4.BackgroundColor3 = COLORS.buttonSuccess
    modeBtn3_4.TextColor3 = COLORS.textLight
end)

-- ========== TOGGLES - TAB 3 ==========

local velEnabled3 = true
local angEnabled3 = true
local tpEnabled3 = true
local massEnabled3 = true

velToggle3.MouseButton1Click:Connect(function()
    velEnabled3 = not velEnabled3
    velToggle3.Text = velEnabled3 and "✓ Velocity Burst" or "✗ Velocity Burst"
    velToggle3.BackgroundColor3 = velEnabled3 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

angToggle3.MouseButton1Click:Connect(function()
    angEnabled3 = not angEnabled3
    angToggle3.Text = angEnabled3 and "✓ Angular Force" or "✗ Angular Force"
    angToggle3.BackgroundColor3 = angEnabled3 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

tpToggle3.MouseButton1Click:Connect(function()
    tpEnabled3 = not tpEnabled3
    tpToggle3.Text = tpEnabled3 and "✓ Rapid Teleport" or "✗ Rapid Teleport"
    tpToggle3.BackgroundColor3 = tpEnabled3 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

massToggle3.MouseButton1Click:Connect(function()
    massEnabled3 = not massEnabled3
    massToggle3.Text = massEnabled3 and "✓ Mass Boost" or "✗ Mass Boost"
    massToggle3.BackgroundColor3 = massEnabled3 and COLORS.buttonSuccess or COLORS.buttonDanger
end)

-- ========== TOGGLES - TAB 4 ==========

local swordEnabled4 = true

swordToggle4.MouseButton1Click:Connect(function()
    swordEnabled4 = not swordEnabled4
    swordToggle4.Text = swordEnabled4 and "✓ Auto Sword Attack" or "✗ Auto Sword Attack"
    swordToggle4.BackgroundColor3 = swordEnabled4 and COLORS.buttonSuccess or COLORS.buttonDanger
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
-- ========== HELPER FUNCTIONS ==========

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
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

-- ========== TAB 1: ORIGINAL FLING ==========

local fling1Enabled = false
local fling1Loop = nil
local fling1Count = 0
local bodyAngularVel1 = nil
local bodyVel1 = nil

local function stopFling1()
    if fling1Loop then
        fling1Loop:Disconnect()
        fling1Loop = nil
    end
    
    if bodyAngularVel1 then
        bodyAngularVel1:Destroy()
        bodyAngularVel1 = nil
    end
    
    if bodyVel1 then
        bodyVel1:Destroy()
        bodyVel1 = nil
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
    if fling1Loop then
        fling1Loop:Disconnect()
    end
    
    local spinPower = tonumber(spinInput1.Text) or 999999
    local launchPower = tonumber(launchInput1.Text) or 999999
    
    fling1Loop = RunService.Heartbeat:Connect(function()
        if not fling1Enabled then return end
        
        local myChar = player.Character
        if not myChar then return end
        
        local myRoot = getRoot(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        
        if not myRoot then return end
        
        if not targetPlayer or not targetPlayer.Character then
            return
        end
        
        local targetRoot = getRoot(targetPlayer.Character)
        if not targetRoot then return end
        
        -- Teleport inside target
        myRoot.CFrame = targetRoot.CFrame
        
        -- Apply BodyAngularVelocity
        if not myRoot:FindFirstChild("FlingSpin") then
            bodyAngularVel1 = Instance.new("BodyAngularVelocity")
            bodyAngularVel1.Name = "FlingSpin"
            bodyAngularVel1.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyAngularVel1.AngularVelocity = Vector3.new(spinPower, spinPower, spinPower)
            bodyAngularVel1.P = math.huge
            bodyAngularVel1.Parent = myRoot
        end
        
        -- Apply BodyVelocity
        if not myRoot:FindFirstChild("FlingLaunch") then
            bodyVel1 = Instance.new("BodyVelocity")
            bodyVel1.Name = "FlingLaunch"
            bodyVel1.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVel1.Velocity = Vector3.new(0, launchPower, 0)
            bodyVel1.P = math.huge
            bodyVel1.Parent = myRoot
        end
        
        if myHumanoid then
            myHumanoid.PlatformStand = true
        end
    end)
end

toggle1.MouseButton1Click:Connect(function()
    fling1Enabled = not fling1Enabled
    
    if fling1Enabled then
        if not targetPlayer then
            status1.Text = "Select a target first!"
            fling1Enabled = false
            return
        end
        
        toggle1.Text = "FLING: ON"
        toggle1.BackgroundColor3 = COLORS.buttonSuccess
        status1.Text = "Flinging: " .. targetPlayer.Name
        
        startFling1()
    else
        toggle1.Text = "FLING: OFF"
        toggle1.BackgroundColor3 = COLORS.buttonDanger
        status1.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
        
        stopFling1()
    end
end)

-- ========== TAB 2: KILL AURA ==========

local aura2Enabled = false
local aura2Loop = nil

local function stopAura2()
    if aura2Loop then
        aura2Loop:Disconnect()
        aura2Loop = nil
    end
end

local function startAura2()
    if aura2Loop then
        aura2Loop:Disconnect()
    end
    
    local attackDelay = tonumber(delayInput2.Text) or 0.05
    local swingCount = tonumber(swingsInput2.Text) or 3
    
    aura2Loop = RunService.Heartbeat:Connect(function()
        if not aura2Enabled then return end
        
        local myChar = player.Character
        if not myChar then return end
        
        local myRoot = getRoot(myChar)
        if not myRoot then return end
        
        if not targetPlayer or not targetPlayer.Character then
            return
        end
        
        local targetRoot = getRoot(targetPlayer.Character)
        if not targetRoot then return end
        
        -- Check for spawn protection
        local hasProtection = false
        for _, child in pairs(targetPlayer.Character:GetChildren()) do
            if child:IsA("ForceField") then
                hasProtection = true
                break
            end
        end
        
        if hasProtection then
            protectLabel2.Text = "Protection: ACTIVE"
            protectLabel2.TextColor3 = COLORS.buttonDanger
            return
        else
            protectLabel2.Text = "Protection: NONE"
            protectLabel2.TextColor3 = COLORS.buttonSuccess
        end
        
        -- Equip sword
        local sword = getSword()
        if not sword then
            sword = equipSword()
            if not sword then return end
        end
        
        -- Teleport to target
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
        
        -- Swing sword
        for i = 1, swingCount do
            sword:Activate()
            wait(attackDelay)
        end
    end)
end

toggle2.MouseButton1Click:Connect(function()
    aura2Enabled = not aura2Enabled
    
    if aura2Enabled then
        if not targetPlayer then
            status2.Text = "Select a target first!"
            aura2Enabled = false
            return
        end
        
        toggle2.Text = "KILL AURA: ON"
        toggle2.BackgroundColor3 = COLORS.buttonSuccess
        status2.Text = "Attacking: " .. targetPlayer.Name
        
        equipSword()
        startAura2()
    else
        toggle2.Text = "KILL AURA: OFF"
        toggle2.BackgroundColor3 = COLORS.buttonDanger
        status2.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
        
        stopAura2()
    end
end)
-- ========== TAB 3: COLLISION FLING ==========

local fling3Enabled = false
local fling3Loop = nil
local fling3Count = 0
local bodyVel3 = nil
local bodyAngVel3 = nil
local angle3 = 0

local function boostMass(char)
    local root = getRoot(char)
    if not root then return end
    root.CustomPhysicalProperties = PhysicalProperties.new(100, 0.5, 0.5)
end

local function resetMass(char)
    local root = getRoot(char)
    if root then
        root.CustomPhysicalProperties = nil
    end
end

local function stopFling3()
    if fling3Loop then
        fling3Loop:Disconnect()
        fling3Loop = nil
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
        local myRoot = getRoot(myChar)
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

local function devastateFling3(targetRoot, myRoot, myHumanoid)
    local velocityPower = tonumber(velInput3.Text) or 999999
    local angularPower = tonumber(angInput3.Text) or 999999
    
    if massEnabled3 then
        boostMass(player.Character)
    end
    
    if tpEnabled3 then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
    end
    
    if velEnabled3 then
        if bodyVel3 then bodyVel3:Destroy() end
        bodyVel3 = Instance.new("BodyVelocity")
        bodyVel3.Name = "CollisionBurst"
        bodyVel3.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel3.Velocity = Vector3.new(math.random(-1, 1) * velocityPower, velocityPower, math.random(-1, 1) * velocityPower)
        bodyVel3.P = math.huge
        bodyVel3.Parent = myRoot
    end
    
    if angEnabled3 then
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

local function orbitalFling3(targetRoot, myRoot, myHumanoid)
    local velocityPower = tonumber(velInput3.Text) or 999999
    local angularPower = tonumber(angInput3.Text) or 999999
    
    angle3 = angle3 + (math.pi * 2 / 500)
    
    local offsetX = math.cos(angle3) * 2
    local offsetZ = math.sin(angle3) * 2
    
    if massEnabled3 then
        boostMass(player.Character)
    end
    
    if tpEnabled3 then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(offsetX, 1, offsetZ)
    end
    
    if velEnabled3 then
        local direction = (targetRoot.Position - myRoot.Position).Unit
        
        if bodyVel3 then bodyVel3:Destroy() end
        bodyVel3 = Instance.new("BodyVelocity")
        bodyVel3.Name = "CollisionBurst"
        bodyVel3.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel3.Velocity = direction * velocityPower
        bodyVel3.P = math.huge
        bodyVel3.Parent = myRoot
    end
    
    if angEnabled3 then
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

local function chaosFling3(targetRoot, myRoot, myHumanoid)
    local velocityPower = tonumber(velInput3.Text) or 999999
    local angularPower = tonumber(angInput3.Text) or 999999
    
    if massEnabled3 then
        boostMass(player.Character)
    end
    
    if tpEnabled3 then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(
            math.random(-3, 3),
            math.random(-2, 2),
            math.random(-3, 3)
        )
    end
    
    if velEnabled3 then
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
    
    if angEnabled3 then
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
    if fling3Loop then
        fling3Loop:Disconnect()
    end
    
    fling3Loop = RunService.Heartbeat:Connect(function()
        if not fling3Enabled then return end
        
        local myChar = player.Character
        if not myChar then return end
        
        local myRoot = getRoot(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        
        if not myRoot then return end
        
        if not targetPlayer or not targetPlayer.Character then
            return
        end
        
        local targetRoot = getRoot(targetPlayer.Character)
        if not targetRoot then return end
        
        if collisionMode3 == "devastate" then
            devastateFling3(targetRoot, myRoot, myHumanoid)
        elseif collisionMode3 == "orbital" then
            orbitalFling3(targetRoot, myRoot, myHumanoid)
        else
            chaosFling3(targetRoot, myRoot, myHumanoid)
        end
    end)
end

toggle3.MouseButton1Click:Connect(function()
    fling3Enabled = not fling3Enabled
    
    if fling3Enabled then
        if not targetPlayer then
            status3.Text = "Select a target first!"
            fling3Enabled = false
            return
        end
        
        toggle3.Text = "COLLISION: ON"
        toggle3.BackgroundColor3 = COLORS.buttonSuccess
        status3.Text = "Flinging: " .. targetPlayer.Name .. " (" .. collisionMode3:upper() .. ")"
        
        startFling3()
    else
        toggle3.Text = "COLLISION: OFF"
        toggle3.BackgroundColor3 = COLORS.buttonDanger
        status3.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
        
        stopFling3()
    end
end)
-- ========== TAB 4: COMBO DESTROYER ==========

local fling4Enabled = false
local fling4Loop = nil
local fling4Count = 0
local bodyVel4 = nil
local bodyAngVel4 = nil
local angle4 = 0
local swingDelay4 = 0.05

local function boostMass4(char)
    local root = getRoot(char)
    if not root then return end
    root.CustomPhysicalProperties = PhysicalProperties.new(100, 0.5, 0.5)
end

local function resetMass4(char)
    local root = getRoot(char)
    if root then
        root.CustomPhysicalProperties = nil
    end
end

local function stopFling4()
    if fling4Loop then
        fling4Loop:Disconnect()
        fling4Loop = nil
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
        local myRoot = getRoot(myChar)
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

local function devastateFling4(targetRoot, myRoot, myHumanoid)
    local velocityPower = tonumber(velInput4.Text) or 999999
    local angularPower = tonumber(angInput4.Text) or 999999
    
    if massEnabled3 then
        boostMass4(player.Character)
    end
    
    myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
    
    if bodyVel4 then bodyVel4:Destroy() end
    bodyVel4 = Instance.new("BodyVelocity")
    bodyVel4.Name = "ComboBurst"
    bodyVel4.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel4.Velocity = Vector3.new(math.random(-1, 1) * velocityPower, velocityPower, math.random(-1, 1) * velocityPower)
    bodyVel4.P = math.huge
    bodyVel4.Parent = myRoot
    
    if bodyAngVel4 then bodyAngVel4:Destroy() end
    bodyAngVel4 = Instance.new("BodyAngularVelocity")
    bodyAngVel4.Name = "ComboSpin"
    bodyAngVel4.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyAngVel4.AngularVelocity = Vector3.new(angularPower, angularPower, angularPower)
    bodyAngVel4.P = math.huge
    bodyAngVel4.Parent = myRoot
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

local function orbitalFling4(targetRoot, myRoot, myHumanoid)
    local velocityPower = tonumber(velInput4.Text) or 999999
    local angularPower = tonumber(angInput4.Text) or 999999
    
    angle4 = angle4 + (math.pi * 2 / 500)
    
    local offsetX = math.cos(angle4) * 2
    local offsetZ = math.sin(angle4) * 2
    
    if massEnabled3 then
        boostMass4(player.Character)
    end
    
    myRoot.CFrame = targetRoot.CFrame * CFrame.new(offsetX, 1, offsetZ)
    
    local direction = (targetRoot.Position - myRoot.Position).Unit
    
    if bodyVel4 then bodyVel4:Destroy() end
    bodyVel4 = Instance.new("BodyVelocity")
    bodyVel4.Name = "ComboBurst"
    bodyVel4.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel4.Velocity = direction * velocityPower
    bodyVel4.P = math.huge
    bodyVel4.Parent = myRoot
    
    if bodyAngVel4 then bodyAngVel4:Destroy() end
    bodyAngVel4 = Instance.new("BodyAngularVelocity")
    bodyAngVel4.Name = "ComboSpin"
    bodyAngVel4.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyAngVel4.AngularVelocity = Vector3.new(angularPower, angularPower, angularPower)
    bodyAngVel4.P = math.huge
    bodyAngVel4.Parent = myRoot
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

local function chaosFling4(targetRoot, myRoot, myHumanoid)
    local velocityPower = tonumber(velInput4.Text) or 999999
    local angularPower = tonumber(angInput4.Text) or 999999
    
    if massEnabled3 then
        boostMass4(player.Character)
    end
    
    myRoot.CFrame = targetRoot.CFrame * CFrame.new(
        math.random(-3, 3),
        math.random(-2, 2),
        math.random(-3, 3)
    )
    
    if bodyVel4 then bodyVel4:Destroy() end
    bodyVel4 = Instance.new("BodyVelocity")
    bodyVel4.Name = "ComboBurst"
    bodyVel4.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel4.Velocity = Vector3.new(
        math.random(-1, 1) * velocityPower,
        math.random(-1, 1) * velocityPower,
        math.random(-1, 1) * velocityPower
    )
    bodyVel4.P = math.huge
    bodyVel4.Parent = myRoot
    
    if bodyAngVel4 then bodyAngVel4:Destroy() end
    bodyAngVel4 = Instance.new("BodyAngularVelocity")
    bodyAngVel4.Name = "ComboSpin"
    bodyAngVel4.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyAngVel4.AngularVelocity = Vector3.new(
        math.random(-1, 1) * angularPower,
        math.random(-1, 1) * angularPower,
        math.random(-1, 1) * angularPower
    )
    bodyAngVel4.P = math.huge
    bodyAngVel4.Parent = myRoot
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

local function swordAttack4(targetRoot, myRoot)
    if not swordEnabled4 then return end
    
    local swordReach = tonumber(reachInput4.Text) or 15
    local swordSwings = tonumber(swingsInput4.Text) or 3
    
    local sword = getSword()
    if not sword then
        sword = equipSword()
        if not sword then return end
    end
    
    local distance = (targetRoot.Position - myRoot.Position).Magnitude
    
    if distance <= swordReach then
        for i = 1, swordSwings do
            sword:Activate()
            wait(swingDelay4)
        end
    end
end

local function startFling4()
    if fling4Loop then
        fling4Loop:Disconnect()
    end
    
    fling4Loop = RunService.Heartbeat:Connect(function()
        if not fling4Enabled then return end
        
        local myChar = player.Character
        if not myChar then return end
        
        local myRoot = getRoot(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        
        if not myRoot then return end
        
        if not targetPlayer or not targetPlayer.Character then
            return
        end
        
        local targetRoot = getRoot(targetPlayer.Character)
        if not targetRoot then return end
        
        -- Run fling based on mode
        if collisionMode4 == "devastate" then
            devastateFling4(targetRoot, myRoot, myHumanoid)
        elseif collisionMode4 == "orbital" then
            orbitalFling4(targetRoot, myRoot, myHumanoid)
        else
            chaosFling4(targetRoot, myRoot, myHumanoid)
        end
        
        -- Run sword attack (both run together)
        swordAttack4(targetRoot, myRoot)
    end)
end

toggle4.MouseButton1Click:Connect(function()
    fling4Enabled = not fling4Enabled
    
    if fling4Enabled then
        if not targetPlayer then
            status4.Text = "Select a target first!"
            fling4Enabled = false
            return
        end
        
        toggle4.Text = "DESTROY: ON"
        toggle4.BackgroundColor3 = COLORS.buttonSuccess
        status4.Text = "Destroying: " .. targetPlayer.Name .. " (" .. collisionMode4:upper() .. ")"
        
        -- Equip sword immediately
        equipSword()
        
        startFling4()
    else
        toggle4.Text = "DESTROY: OFF"
        toggle4.BackgroundColor3 = COLORS.buttonDanger
        status4.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
        
        stopFling4()
    end
end)

-- ========== RESPAWN HANDLERS ==========

player.CharacterAdded:Connect(function(char)
    wait(0.3)
    
    -- Tab 1 respawn
    if fling1Enabled then
        fling1Count = fling1Count + 1
        counter1.Text = "Flings: " .. fling1Count
        startFling1()
    end
    
    -- Tab 3 respawn
    if fling3Enabled then
        fling3Count = fling3Count + 1
        counter3.Text = "Flings: " .. fling3Count
        startFling3()
    end
    
    -- Tab 4 respawn
    if fling4Enabled then
        fling4Count = fling4Count + 1
        counter4.Text = "Attacks: " .. fling4Count
        
        -- Re-equip sword
        equipSword()
        
        startFling4()
    end
end)

-- Cleanup on character removal
player.CharacterRemoving:Connect(function()
    stopFling1()
    stopAura2()
    stopFling3()
    stopFling4()
end)

print("✅ MULTI-TOOL HUB Loaded")
print("   Tab 1: Original Fling (BodyMover)")
print("   Tab 2: Kill Aura (Sword + Protection Detect)")
print("   Tab 3: Collision Fling (Physics)")
print("   Tab 4: Combo Destroyer (Fling + Sword)")
print("   Tab 5: Kill Hub (Remove)")
print("   RightCtrl to toggle hub")
