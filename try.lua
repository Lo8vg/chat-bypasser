-- Combined Hub: Fling + TP Kill (No Logic Changes)
-- Two separate tabs, each works independently

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
    tab1Content.Visible = true
    tab2Content.Visible = false
end)

tab2Button.MouseButton1Click:Connect(function()
    tab1Button.BackgroundColor3 = COLORS.tabInactive
    tab1Button.TextColor3 = COLORS.textDark
    tab2Button.BackgroundColor3 = COLORS.tabActive
    tab2Button.TextColor3 = COLORS.textLight
    tab1Content.Visible = false
    tab2Content.Visible = true
end)

-- ========== FLING SCRIPT (UNCHANGED LOGIC) ==========

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
        
        startFling()
    else
        toggleButton1.Text = "FLING: OFF"
        toggleButton1.BackgroundColor3 = COLORS.buttonDanger
        statusLabel1.Text = targetPlayer1 and ("Target: " .. targetPlayer1.Name) or "No target selected"
        
        stopFling()
    end
end)

player.CharacterAdded:Connect(function(char)
    wait(0.3)
    
    if flingEnabled then
        flingCount = flingCount + 1
        flingCounter.Text = "Flings: " .. flingCount
        startFling()
    end
end)

player.CharacterRemoving:Connect(function()
    stopFling()
end)

Players.PlayerAdded:Connect(updatePlayerList1)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerList1()
end)

updatePlayerList1()

-- ========== TP KILL SCRIPT (UNCHANGED LOGIC) ==========

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
