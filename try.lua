-- Combined Hub: Original Fling + TP Kill
-- Two tabs in one interface

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Shared Settings
local targetPlayer = nil

-- Colors
local COLORS = {
    background = Color3.fromRGB(245, 245, 245),
    header = Color3.fromRGB(255, 255, 255),
    buttonPrimary = Color3.fromRGB(0, 120, 215),
    buttonDanger = Color3.fromRGB(220, 53, 69),
    buttonSuccess = Color3.fromRGB(40, 167, 69),
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
mainFrame.Size = UDim2.new(0, 380, 0, 320)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -160)
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
titleBar.Size = UDim2.new(1, 0, 0, 38)
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
tabButtonsFrame.Position = UDim2.new(0, 10, 0, 42)
tabButtonsFrame.BackgroundTransparency = 1
tabButtonsFrame.Parent = mainFrame

local tab1Button = Instance.new("TextButton")
tab1Button.Size = UDim2.new(0.5, -4, 1, 0)
tab1Button.Position = UDim2.new(0, 0, 0, 0)
tab1Button.BackgroundColor3 = COLORS.tabActive
tab1Button.TextColor3 = COLORS.textLight
tab1Button.Text = "Original Fling"
tab1Button.Font = Enum.Font.GothamBold
tab1Button.TextSize = 12
tab1Button.Parent = tabButtonsFrame

local tab1Corner = Instance.new("UICorner")
tab1Corner.CornerRadius = UDim.new(0, 6)
tab1Corner.Parent = tab1Button

local tab2Button = Instance.new("TextButton")
tab2Button.Size = UDim2.new(0.5, -4, 1, 0)
tab2Button.Position = UDim2.new(0.5, 4, 0, 0)
tab2Button.BackgroundColor3 = COLORS.tabInactive
tab2Button.TextColor3 = COLORS.textDark
tab2Button.Text = "TP Kill"
tab2Button.Font = Enum.Font.GothamBold
tab2Button.TextSize = 12
tab2Button.Parent = tabButtonsFrame

local tab2Corner = Instance.new("UICorner")
tab2Corner.CornerRadius = UDim.new(0, 6)
tab2Corner.Parent = tab2Button

-- ========== TAB 1: ORIGINAL FLING ==========

local tab1Content = Instance.new("Frame")
tab1Content.Size = UDim2.new(1, -20, 1, -82)
tab1Content.Position = UDim2.new(0, 10, 0, 78)
tab1Content.BackgroundTransparency = 1
tab1Content.Visible = true
tab1Content.Parent = mainFrame

-- Left Frame
local leftFrame1 = Instance.new("Frame")
leftFrame1.Size = UDim2.new(0.5, -5, 1, 0)
leftFrame1.Position = UDim2.new(0, 0, 0, 0)
leftFrame1.BackgroundTransparency = 1
leftFrame1.Parent = tab1Content

-- Fling Toggle
local flingToggle = Instance.new("TextButton")
flingToggle.Name = "FlingToggle"
flingToggle.Size = UDim2.new(1, 0, 0, 32)
flingToggle.Position = UDim2.new(0, 0, 0, 0)
flingToggle.BackgroundColor3 = COLORS.buttonDanger
flingToggle.TextColor3 = COLORS.textLight
flingToggle.Text = "FLING: OFF"
flingToggle.Font = Enum.Font.GothamBold
flingToggle.TextSize = 13
flingToggle.Parent = leftFrame1

local flingToggleCorner = Instance.new("UICorner")
flingToggleCorner.CornerRadius = UDim.new(0, 6)
flingToggleCorner.Parent = flingToggle

-- Counter
local flingCounter = Instance.new("TextLabel")
flingCounter.Name = "FlingCounter"
flingCounter.Size = UDim2.new(1, 0, 0, 18)
flingCounter.Position = UDim2.new(0, 0, 0, 36)
flingCounter.BackgroundTransparency = 1
flingCounter.TextColor3 = COLORS.buttonSuccess
flingCounter.Text = "Flings: 0"
flingCounter.Font = Enum.Font.GothamBold
flingCounter.TextSize = 11
flingCounter.Parent = leftFrame1

-- Target Label
local targetLabel1 = Instance.new("TextLabel")
targetLabel1.Size = UDim2.new(1, 0, 0, 16)
targetLabel1.Position = UDim2.new(0, 0, 0, 56)
targetLabel1.BackgroundTransparency = 1
targetLabel1.TextColor3 = COLORS.textDark
targetLabel1.Text = "Select Target:"
targetLabel1.Font = Enum.Font.GothamBold
targetLabel1.TextSize = 10
targetLabel1.TextXAlignment = Enum.TextXAlignment.Left
targetLabel1.Parent = leftFrame1

-- Player Scroll
local playerScroll1 = Instance.new("ScrollingFrame")
playerScroll1.Size = UDim2.new(1, 0, 0, 85)
playerScroll1.Position = UDim2.new(0, 0, 0, 74)
playerScroll1.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerScroll1.ScrollBarThickness = 4
playerScroll1.Parent = leftFrame1

local playerScroll1Corner = Instance.new("UICorner")
playerScroll1Corner.CornerRadius = UDim.new(0, 6)
playerScroll1Corner.Parent = playerScroll1

local playerLayout1 = Instance.new("UIListLayout")
playerLayout1.Padding = UDim.new(0, 2)
playerLayout1.Parent = playerScroll1

-- Status
local statusLabel1 = Instance.new("TextLabel")
statusLabel1.Name = "StatusLabel1"
statusLabel1.Size = UDim2.new(1, 0, 0, 16)
statusLabel1.Position = UDim2.new(0, 0, 0, 162)
statusLabel1.BackgroundTransparency = 1
statusLabel1.TextColor3 = COLORS.textMuted
statusLabel1.Text = "No target selected"
statusLabel1.Font = Enum.Font.Gotham
statusLabel1.TextSize = 9
statusLabel1.TextWrapped = true
statusLabel1.Parent = leftFrame1

-- Right Frame
local rightFrame1 = Instance.new("Frame")
rightFrame1.Size = UDim2.new(0.5, -5, 1, 0)
rightFrame1.Position = UDim2.new(0.5, 5, 0, 0)
rightFrame1.BackgroundTransparency = 1
rightFrame1.Parent = tab1Content

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
spinInput1.Size = UDim2.new(1, 0, 0, 24)
spinInput1.Position = UDim2.new(0, 0, 0, 16)
spinInput1.BackgroundColor3 = COLORS.inputBg
spinInput1.TextColor3 = COLORS.textDark
spinInput1.Text = "999999"
spinInput1.Font = Enum.Font.Gotham
spinInput1.TextSize = 11
spinInput1.ClearTextOnFocus = false
spinInput1.Parent = rightFrame1

local spinInput1Corner = Instance.new("UICorner")
spinInput1Corner.CornerRadius = UDim.new(0, 5)
spinInput1Corner.Parent = spinInput1

local spinInput1Stroke = Instance.new("UIStroke")
spinInput1Stroke.Color = COLORS.border
spinInput1Stroke.Thickness = 1
spinInput1Stroke.Parent = spinInput1

-- Launch Power
local launchLabel1 = Instance.new("TextLabel")
launchLabel1.Size = UDim2.new(1, 0, 0, 14)
launchLabel1.Position = UDim2.new(0, 0, 0, 46)
launchLabel1.BackgroundTransparency = 1
launchLabel1.TextColor3 = COLORS.textDark
launchLabel1.Text = "Launch Power:"
launchLabel1.Font = Enum.Font.GothamBold
launchLabel1.TextSize = 10
launchLabel1.TextXAlignment = Enum.TextXAlignment.Left
launchLabel1.Parent = rightFrame1

local launchInput1 = Instance.new("TextBox")
launchInput1.Name = "LaunchInput1"
launchInput1.Size = UDim2.new(1, 0, 0, 24)
launchInput1.Position = UDim2.new(0, 0, 0, 62)
launchInput1.BackgroundColor3 = COLORS.inputBg
launchInput1.TextColor3 = COLORS.textDark
launchInput1.Text = "999999"
launchInput1.Font = Enum.Font.Gotham
launchInput1.TextSize = 11
launchInput1.ClearTextOnFocus = false
launchInput1.Parent = rightFrame1

local launchInput1Corner = Instance.new("UICorner")
launchInput1Corner.CornerRadius = UDim.new(0, 5)
launchInput1Corner.Parent = launchInput1

local launchInput1Stroke = Instance.new("UIStroke")
launchInput1Stroke.Color = COLORS.border
launchInput1Stroke.Thickness = 1
launchInput1Stroke.Parent = launchInput1

-- Info
local infoLabel1 = Instance.new("TextLabel")
infoLabel1.Size = UDim2.new(1, 0, 0, 70)
infoLabel1.Position = UDim2.new(0, 0, 0, 92)
infoLabel1.BackgroundTransparency = 1
infoLabel1.TextColor3 = COLORS.textMuted
infoLabel1.Text = "Uses BodyAngularVelocity +\nBodyVelocity (visible spin).\nAnti-cheat kills you = target flung."
infoLabel1.Font = Enum.Font.Gotham
infoLabel1.TextSize = 9
infoLabel1.TextWrapped = true
infoLabel1.TextXAlignment = Enum.TextXAlignment.Left
infoLabel1.Parent = rightFrame1

-- ========== TAB 2: TP KILL ==========

local tab2Content = Instance.new("Frame")
tab2Content.Size = UDim2.new(1, -20, 1, -82)
tab2Content.Position = UDim2.new(0, 10, 0, 78)
tab2Content.BackgroundTransparency = 1
tab2Content.Visible = false
tab2Content.Parent = mainFrame

-- Kill Toggle
local killToggle = Instance.new("TextButton")
killToggle.Name = "KillToggle"
killToggle.Size = UDim2.new(1, 0, 0, 32)
killToggle.Position = UDim2.new(0, 0, 0, 0)
killToggle.BackgroundColor3 = COLORS.buttonDanger
killToggle.TextColor3 = COLORS.textLight
killToggle.Text = "KILL AURA: OFF"
killToggle.Font = Enum.Font.GothamBold
killToggle.TextSize = 13
killToggle.Parent = tab2Content

local killToggleCorner = Instance.new("UICorner")
killToggleCorner.CornerRadius = UDim.new(0, 6)
killToggleCorner.Parent = killToggle

-- Protection Status
local protectionLabel = Instance.new("TextLabel")
protectionLabel.Name = "ProtectionLabel"
protectionLabel.Size = UDim2.new(1, 0, 0, 16)
protectionLabel.Position = UDim2.new(0, 0, 0, 36)
protectionLabel.BackgroundTransparency = 1
protectionLabel.TextColor3 = COLORS.textMuted
protectionLabel.Text = "Protection: Waiting..."
protectionLabel.Font = Enum.Font.Gotham
protectionLabel.TextSize = 10
protectionLabel.Parent = tab2Content

-- Target Label
local targetLabel2 = Instance.new("TextLabel")
targetLabel2.Size = UDim2.new(1, 0, 0, 16)
targetLabel2.Position = UDim2.new(0, 0, 0, 56)
targetLabel2.BackgroundTransparency = 1
targetLabel2.TextColor3 = COLORS.textDark
targetLabel2.Text = "Select Target:"
targetLabel2.Font = Enum.Font.GothamBold
targetLabel2.TextSize = 10
targetLabel2.TextXAlignment = Enum.TextXAlignment.Left
targetLabel2.Parent = tab2Content

-- Player Scroll
local playerScroll2 = Instance.new("ScrollingFrame")
playerScroll2.Size = UDim2.new(1, 0, 0, 85)
playerScroll2.Position = UDim2.new(0, 0, 0, 74)
playerScroll2.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerScroll2.ScrollBarThickness = 4
playerScroll2.Parent = tab2Content

local playerScroll2Corner = Instance.new("UICorner")
playerScroll2Corner.CornerRadius = UDim.new(0, 6)
playerScroll2Corner.Parent = playerScroll2

local playerLayout2 = Instance.new("UIListLayout")
playerLayout2.Padding = UDim.new(0, 2)
playerLayout2.Parent = playerScroll2

-- Status
local statusLabel2 = Instance.new("TextLabel")
statusLabel2.Name = "StatusLabel2"
statusLabel2.Size = UDim2.new(1, 0, 0, 16)
statusLabel2.Position = UDim2.new(0, 0, 0, 162)
statusLabel2.BackgroundTransparency = 1
statusLabel2.TextColor3 = COLORS.textMuted
statusLabel2.Text = "No target selected"
statusLabel2.Font = Enum.Font.Gotham
statusLabel2.TextSize = 9
statusLabel2.TextWrapped = true
statusLabel2.Parent = tab2Content

-- Settings Frame
local settingsFrame2 = Instance.new("Frame")
settingsFrame2.Size = UDim2.new(1, 0, 0, 60)
settingsFrame2.Position = UDim2.new(0, 0, 0, 182)
settingsFrame2.BackgroundTransparency = 1
settingsFrame2.Parent = tab2Content

-- Delay Row
local delayLabel2 = Instance.new("TextLabel")
delayLabel2.Size = UDim2.new(0, 80, 0, 24)
delayLabel2.Position = UDim2.new(0, 0, 0, 0)
delayLabel2.BackgroundTransparency = 1
delayLabel2.TextColor3 = COLORS.textDark
delayLabel2.Text = "Delay:"
delayLabel2.Font = Enum.Font.Gotham
delayLabel2.TextSize = 10
delayLabel2.TextXAlignment = Enum.TextXAlignment.Left
delayLabel2.Parent = settingsFrame2

local delayInput2 = Instance.new("TextBox")
delayInput2.Name = "DelayInput2"
delayInput2.Size = UDim2.new(0, 50, 0, 24)
delayInput2.Position = UDim2.new(0, 82, 0, 0)
delayInput2.BackgroundColor3 = COLORS.inputBg
delayInput2.TextColor3 = COLORS.textDark
delayInput2.Text = "0.05"
delayInput2.Font = Enum.Font.Gotham
delayInput2.TextSize = 10
delayInput2.ClearTextOnFocus = false
delayInput2.Parent = settingsFrame2

local delayInput2Corner = Instance.new("UICorner")
delayInput2Corner.CornerRadius = UDim.new(0, 5)
delayInput2Corner.Parent = delayInput2

local delayInput2Stroke = Instance.new("UIStroke")
delayInput2Stroke.Color = COLORS.border
delayInput2Stroke.Thickness = 1
delayInput2Stroke.Parent = delayInput2

-- Swings Row
local swingsLabel2 = Instance.new("TextLabel")
swingsLabel2.Size = UDim2.new(0, 80, 0, 24)
swingsLabel2.Position = UDim2.new(0, 0, 0, 28)
swingsLabel2.BackgroundTransparency = 1
swingsLabel2.TextColor3 = COLORS.textDark
swingsLabel2.Text = "Swings:"
swingsLabel2.Font = Enum.Font.Gotham
swingsLabel2.TextSize = 10
swingsLabel2.TextXAlignment = Enum.TextXAlignment.Left
swingsLabel2.Parent = settingsFrame2

local swingsInput2 = Instance.new("TextBox")
swingsInput2.Name = "SwingsInput2"
swingsInput2.Size = UDim2.new(0, 50, 0, 24)
swingsInput2.Position = UDim2.new(0, 82, 0, 28)
swingsInput2.BackgroundColor3 = COLORS.inputBg
swingsInput2.TextColor3 = COLORS.textDark
swingsInput2.Text = "3"
swingsInput2.Font = Enum.Font.Gotham
swingsInput2.TextSize = 10
swingsInput2.ClearTextOnFocus = false
swingsInput2.Parent = settingsFrame2

local swingsInput2Corner = Instance.new("UICorner")
swingsInput2Corner.CornerRadius = UDim.new(0, 5)
swingsInput2Corner.Parent = swingsInput2

local swingsInput2Stroke = Instance.new("UIStroke")
swingsInput2Stroke.Color = COLORS.border
swingsInput2Stroke.Thickness = 1
swingsInput2Stroke.Parent = swingsInput2

-- ========== DRAGGING ==========

local dragging = false
local dragInput, dragStart, startPos
local dragDistance = 0

hubButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = hubButton.Position
        dragDistance = 0
        
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
        dragDistance = delta.Magnitude
        hubButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Hub Button Click
hubButton.MouseButton1Click:Connect(function()
    if dragDistance < 10 then
        hubButton.Visible = false
        mainFrame.Visible = true
    end
    dragDistance = 0
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

-- Collapse Button
collapseButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

-- ========== TAB SWITCHING ==========

local function switchTab(tabNum)
    if tabNum == 1 then
        tab1Button.BackgroundColor3 = COLORS.tabActive
        tab1Button.TextColor3 = COLORS.textLight
        tab2Button.BackgroundColor3 = COLORS.tabInactive
        tab2Button.TextColor3 = COLORS.textDark
        tab1Content.Visible = true
        tab2Content.Visible = false
    else
        tab1Button.BackgroundColor3 = COLORS.tabInactive
        tab1Button.TextColor3 = COLORS.textDark
        tab2Button.BackgroundColor3 = COLORS.tabActive
        tab2Button.TextColor3 = COLORS.textLight
        tab1Content.Visible = false
        tab2Content.Visible = true
    end
end

tab1Button.MouseButton1Click:Connect(function() switchTab(1) end)
tab2Button.MouseButton1Click:Connect(function() switchTab(2) end)

-- ========== PLAYER LISTS ==========

local function updatePlayerLists()
    -- Tab 1
    for _, child in pairs(playerScroll1:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    -- Tab 2
    for _, child in pairs(playerScroll2:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            -- Tab 1 Button
            local btn1 = Instance.new("TextButton")
            btn1.Size = UDim2.new(1, 0, 0, 22)
            btn1.BackgroundColor3 = targetPlayer == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn1.TextColor3 = targetPlayer == plr and COLORS.textLight or COLORS.textDark
            btn1.Text = plr.Name
            btn1.Font = Enum.Font.Gotham
            btn1.TextSize = 10
            btn1.Parent = playerScroll1
            
            local btn1Corner = Instance.new("UICorner")
            btn1Corner.CornerRadius = UDim.new(0, 5)
            btn1Corner.Parent = btn1
            
            btn1.MouseButton1Click:Connect(function()
                targetPlayer = plr
                statusLabel1.Text = "Target: " .. plr.Name
                statusLabel2.Text = "Target: " .. plr.Name
                updatePlayerLists()
            end)
            
            -- Tab 2 Button
            local btn2 = Instance.new("TextButton")
            btn2.Size = UDim2.new(1, 0, 0, 22)
            btn2.BackgroundColor3 = targetPlayer == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn2.TextColor3 = targetPlayer == plr and COLORS.textLight or COLORS.textDark
            btn2.Text = plr.Name
            btn2.Font = Enum.Font.Gotham
            btn2.TextSize = 10
            btn2.Parent = playerScroll2
            
            local btn2Corner = Instance.new("UICorner")
            btn2Corner.CornerRadius = UDim.new(0, 5)
            btn2Corner.Parent = btn2
            
            btn2.MouseButton1Click:Connect(function()
                targetPlayer = plr
                statusLabel1.Text = "Target: " .. plr.Name
                statusLabel2.Text = "Target: " .. plr.Name
                updatePlayerLists()
            end)
        end
    end
    
    -- Update canvas sizes
    playerScroll1.CanvasSize = UDim2.new(0, 0, 0, playerLayout1.AbsoluteContentSize.Y)
    playerScroll2.CanvasSize = UDim2.new(0, 0, 0, playerLayout2.AbsoluteContentSize.Y)
end

Players.PlayerAdded:Connect(updatePlayerLists)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerLists()
end)

updatePlayerLists()

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
            wait(0.1)
            return item
        end
    end
    
    return nil
end

-- ========== TAB 1: FLING LOGIC ==========

local flingEnabled = false
local flingLoop = nil
local flingCount = 0
local bodyAngularVel = nil
local bodyVel = nil

local function stopFling()
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

local function startFling()
    if flingLoop then
        flingLoop:Disconnect()
    end
    
    local spinPower = tonumber(spinInput1.Text) or 999999
    local launchPower = tonumber(launchInput1.Text) or 999999
    
    flingLoop = RunService.Heartbeat:Connect(function()
        if not flingEnabled then return end
        
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
        
        -- Create BodyAngularVelocity if needed
        if not myRoot:FindFirstChild("FlingSpin") then
            bodyAngularVel = Instance.new("BodyAngularVelocity")
            bodyAngularVel.Name = "FlingSpin"
            bodyAngularVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyAngularVel.AngularVelocity = Vector3.new(spinPower, spinPower, spinPower)
            bodyAngularVel.P = math.huge
            bodyAngularVel.Parent = myRoot
        end
        
        -- Create BodyVelocity if needed
        if not myRoot:FindFirstChild("FlingLaunch") then
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.Name = "FlingLaunch"
            bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVel.Velocity = Vector3.new(0, launchPower, 0)
            bodyVel.P = math.huge
            bodyVel.Parent = myRoot
        end
        
        if myHumanoid then
            myHumanoid.PlatformStand = true
        end
    end)
end

flingToggle.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    
    if flingEnabled then
        if not targetPlayer then
            statusLabel1.Text = "Select a target first!"
            flingEnabled = false
            return
        end
        
        flingToggle.Text = "FLING: ON"
        flingToggle.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel1.Text = "Flinging: " .. targetPlayer.Name
        
        startFling()
    else
        flingToggle.Text = "FLING: OFF"
        flingToggle.BackgroundColor3 = COLORS.buttonDanger
        statusLabel1.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
        
        stopFling()
    end
end)

-- ========== TAB 2: KILL AURA LOGIC ==========

local killEnabled = false
local killLoop = nil

local function hasProtection(targetPlr)
    if not targetPlr or not targetPlr.Character then return false end
    local forceField = targetPlr.Character:FindFirstChild("ForceField")
    return forceField ~= nil
end

local function stopKill()
    if killLoop then
        killLoop:Disconnect()
        killLoop = nil
    end
end

local function startKill()
    if killLoop then
        killLoop:Disconnect()
    end
    
    local attackDelay = tonumber(delayInput2.Text) or 0.05
    local swingsPerAttack = tonumber(swingsInput2.Text) or 3
    
    equipSword()
    
    killLoop = RunService.Heartbeat:Connect(function()
        if not killEnabled then return end
        
        local myChar = player.Character
        if not myChar then return end
        
        local myRoot = getRoot(myChar)
        if not myRoot then return end
        
        if not targetPlayer or not targetPlayer.Character then
            return
        end
        
        local targetRoot = getRoot(targetPlayer.Character)
        local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        
        if not targetRoot or not targetHumanoid then return end
        
        if targetHumanoid.Health <= 0 then
            protectionLabel.Text = "Protection: Target dead"
            protectionLabel.TextColor3 = COLORS.textMuted
            return
        end
        
        -- Check for protection
        if hasProtection(targetPlayer) then
            protectionLabel.Text = "Protection: TARGET PROTECTED"
            protectionLabel.TextColor3 = Color3.fromRGB(255, 193, 7)
            statusLabel2.Text = "Waiting for protection to end..."
            return
        end
        
        protectionLabel.Text = "Protection: TARGET VULNERABLE"
        protectionLabel.TextColor3 = COLORS.buttonSuccess
        statusLabel2.Text = "ATTACKING: " .. targetPlayer.Name
        
        -- Teleport to target
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
        
        -- Sword attack
        local sword = getSword()
        if sword then
            for i = 1, swingsPerAttack do
                sword:Activate()
                wait(attackDelay)
            end
        end
    end)
end

killToggle.MouseButton1Click:Connect(function()
    killEnabled = not killEnabled
    
    if killEnabled then
        if not targetPlayer then
            statusLabel2.Text = "Select a target first!"
            killEnabled = false
            return
        end
        
        killToggle.Text = "KILL AURA: ON"
        killToggle.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel2.Text = "Hunting: " .. targetPlayer.Name
        
        startKill()
    else
        killToggle.Text = "KILL AURA: OFF"
        killToggle.BackgroundColor3 = COLORS.buttonDanger
        statusLabel2.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
        protectionLabel.Text = "Protection: Waiting..."
        protectionLabel.TextColor3 = COLORS.textMuted
        
        stopKill()
    end
end)

-- ========== RESPAWN HANDLERS ==========

player.CharacterAdded:Connect(function(char)
    wait(0.3)
    
    if flingEnabled then
        flingCount = flingCount + 1
        flingCounter.Text = "Flings: " .. flingCount
        startFling()
    end
    
    if killEnabled then
        equipSword()
    end
end)

player.CharacterRemoving:Connect(function()
    stopFling()
    stopKill()
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

print("✅ Combined Hub Loaded")
print("   Tab 1: Original Fling (BodyMover)")
print("   Tab 2: TP Kill (Spawn Protection Detection)")
print("   RightCtrl to toggle hub")
