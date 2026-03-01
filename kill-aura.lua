-- Hybrid Script with Tabs
-- Fling + Kill Aura (Separate Modes)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local flingEnabled = false
local auraEnabled = false
local targetPlayer = nil

-- Fling settings
local flingSpinPower = 999999
local flingLaunchPower = 999999
local bodyAngularVel = nil
local bodyVel = nil
local flingLoop = nil

-- Aura settings
local teleportDistance = 2
local teleportDelay = 0.1
local swingDelay = 0.01
local smartMode = true
local spawnWaitTime = 5
local attackAngle = 0
local auraLoop = nil
local swingLoop = nil

-- Stats
local flingCount = 0
local killCount = 0

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
    cardBg = Color3.fromRGB(255, 255, 255),
    tabActive = Color3.fromRGB(0, 120, 215),
    tabInactive = Color3.fromRGB(200, 200, 200)
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HybridGui"
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
mainFrame.Size = UDim2.new(0, 450, 0, 320)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
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
titleLabel.Text = "⚔️ Hybrid Script"
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
tabBar.Size = UDim2.new(1, -20, 0, 35)
tabBar.Position = UDim2.new(0, 10, 0, 40)
tabBar.BackgroundTransparency = 1
tabBar.Parent = mainFrame

local flingTab = Instance.new("TextButton")
flingTab.Size = UDim2.new(0.5, -5, 1, 0)
flingTab.Position = UDim2.new(0, 0, 0, 0)
flingTab.BackgroundColor3 = COLORS.tabActive
flingTab.TextColor3 = COLORS.textLight
flingTab.Text = "🌀 FLING"
flingTab.Font = Enum.Font.GothamBold
flingTab.TextSize = 12
flingTab.Parent = tabBar

local flingTabCorner = Instance.new("UICorner")
flingTabCorner.CornerRadius = UDim.new(0, 8)
flingTabCorner.Parent = flingTab

local auraTab = Instance.new("TextButton")
auraTab.Size = UDim2.new(0.5, -5, 1, 0)
auraTab.Position = UDim2.new(0.5, 5, 0, 0)
auraTab.BackgroundColor3 = COLORS.tabInactive
auraTab.TextColor3 = COLORS.textDark
auraTab.Text = "⚔️ AURA"
auraTab.Font = Enum.Font.GothamBold
auraTab.TextSize = 12
auraTab.Parent = tabBar

local auraTabCorner = Instance.new("UICorner")
auraTabCorner.CornerRadius = UDim.new(0, 8)
auraTabCorner.Parent = auraTab

-- ========== FLING PAGE ==========

local flingPage = Instance.new("Frame")
flingPage.Name = "FlingPage"
flingPage.Size = UDim2.new(1, -20, 1, -85)
flingPage.Position = UDim2.new(0, 10, 0, 80)
flingPage.BackgroundTransparency = 1
flingPage.Visible = true
flingPage.Parent = mainFrame

-- Fling Toggle
local flingToggle = Instance.new("TextButton")
flingToggle.Size = UDim2.new(1, 0, 0, 35)
flingToggle.Position = UDim2.new(0, 0, 0, 0)
flingToggle.BackgroundColor3 = COLORS.buttonDanger
flingToggle.TextColor3 = COLORS.textLight
flingToggle.Text = "FLING: OFF"
flingToggle.Font = Enum.Font.GothamBold
flingToggle.TextSize = 14
flingToggle.Parent = flingPage

local flingToggleCorner = Instance.new("UICorner")
flingToggleCorner.CornerRadius = UDim.new(0, 8)
flingToggleCorner.Parent = flingToggle

-- Fling Counter
local flingCounterLabel = Instance.new("TextLabel")
flingCounterLabel.Size = UDim2.new(1, 0, 0, 18)
flingCounterLabel.Position = UDim2.new(0, 0, 0, 40)
flingCounterLabel.BackgroundTransparency = 1
flingCounterLabel.TextColor3 = COLORS.buttonPurple
flingCounterLabel.Text = "Flings: 0"
flingCounterLabel.Font = Enum.Font.GothamBold
flingCounterLabel.TextSize = 11
flingCounterLabel.Parent = flingPage

-- Target Label
local flingTargetLabel = Instance.new("TextLabel")
flingTargetLabel.Size = UDim2.new(1, 0, 0, 16)
flingTargetLabel.Position = UDim2.new(0, 0, 0, 60)
flingTargetLabel.BackgroundTransparency = 1
flingTargetLabel.TextColor3 = COLORS.textDark
flingTargetLabel.Text = "Select Target:"
flingTargetLabel.Font = Enum.Font.GothamBold
flingTargetLabel.TextSize = 10
flingTargetLabel.TextXAlignment = Enum.TextXAlignment.Left
flingTargetLabel.Parent = flingPage

-- Fling Player List
local flingPlayerScroll = Instance.new("ScrollingFrame")
flingPlayerScroll.Size = UDim2.new(1, 0, 0, 100)
flingPlayerScroll.Position = UDim2.new(0, 0, 0, 78)
flingPlayerScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
flingPlayerScroll.ScrollBarThickness = 4
flingPlayerScroll.Parent = flingPage

local flingPlayerScrollCorner = Instance.new("UICorner")
flingPlayerScrollCorner.CornerRadius = UDim.new(0, 6)
flingPlayerScrollCorner.Parent = flingPlayerScroll

local flingPlayerLayout = Instance.new("UIListLayout")
flingPlayerLayout.Padding = UDim.new(0, 2)
flingPlayerLayout.Parent = flingPlayerScroll

-- Fling Settings
local flingSettingsLabel = Instance.new("TextLabel")
flingSettingsLabel.Size = UDim2.new(1, 0, 0, 16)
flingSettingsLabel.Position = UDim2.new(0, 0, 0, 182)
flingSettingsLabel.BackgroundTransparency = 1
flingSettingsLabel.TextColor3 = COLORS.textDark
flingSettingsLabel.Text = "Settings:"
flingSettingsLabel.Font = Enum.Font.GothamBold
flingSettingsLabel.TextSize = 10
flingSettingsLabel.TextXAlignment = Enum.TextXAlignment.Left
flingSettingsLabel.Parent = flingPage

-- Spin Power
local spinRow = Instance.new("Frame")
spinRow.Size = UDim2.new(1, 0, 0, 22)
spinRow.Position = UDim2.new(0, 0, 0, 200)
spinRow.BackgroundTransparency = 1
spinRow.Parent = flingPage

local spinLabel = Instance.new("TextLabel")
spinLabel.Size = UDim2.new(0, 80, 1, 0)
spinLabel.BackgroundTransparency = 1
spinLabel.TextColor3 = COLORS.textDark
spinLabel.Text = "Spin Power:"
spinLabel.Font = Enum.Font.Gotham
spinLabel.TextSize = 10
spinLabel.TextXAlignment = Enum.TextXAlignment.Left
spinLabel.Parent = spinRow

local spinInput = Instance.new("TextBox")
spinInput.Size = UDim2.new(0, 80, 1, 0)
spinInput.Position = UDim2.new(0, 85, 0, 0)
spinInput.BackgroundColor3 = COLORS.inputBg
spinInput.TextColor3 = COLORS.textDark
spinInput.Text = "999999"
spinInput.Font = Enum.Font.Gotham
spinInput.TextSize = 10
spinInput.ClearTextOnFocus = false
spinInput.Parent = spinRow

local spinCorner = Instance.new("UICorner")
spinCorner.CornerRadius = UDim.new(0, 5)
spinCorner.Parent = spinInput

local spinStroke = Instance.new("UIStroke")
spinStroke.Color = COLORS.border
spinStroke.Thickness = 1
spinStroke.Parent = spinInput

-- Launch Power
local launchRow = Instance.new("Frame")
launchRow.Size = UDim2.new(1, 0, 0, 22)
launchRow.Position = UDim2.new(0, 0, 0, 226)
launchRow.BackgroundTransparency = 1
launchRow.Parent = flingPage

local launchLabel = Instance.new("TextLabel")
launchLabel.Size = UDim2.new(0, 80, 1, 0)
launchLabel.BackgroundTransparency = 1
launchLabel.TextColor3 = COLORS.textDark
launchLabel.Text = "Launch Power:"
launchLabel.Font = Enum.Font.Gotham
launchLabel.TextSize = 10
launchLabel.TextXAlignment = Enum.TextXAlignment.Left
launchLabel.Parent = launchRow

local launchInput = Instance.new("TextBox")
launchInput.Size = UDim2.new(0, 80, 1, 0)
launchInput.Position = UDim2.new(0, 85, 0, 0)
launchInput.BackgroundColor3 = COLORS.inputBg
launchInput.TextColor3 = COLORS.textDark
launchInput.Text = "999999"
launchInput.Font = Enum.Font.Gotham
launchInput.TextSize = 10
launchInput.ClearTextOnFocus = false
launchInput.Parent = launchRow

local launchCorner = Instance.new("UICorner")
launchCorner.CornerRadius = UDim.new(0, 5)
launchCorner.Parent = launchInput

local launchStroke = Instance.new("UIStroke")
launchStroke.Color = COLORS.border
launchStroke.Thickness = 1
launchStroke.Parent = launchInput

-- ========== AURA PAGE ==========

local auraPage = Instance.new("Frame")
auraPage.Name = "AuraPage"
auraPage.Size = UDim2.new(1, -20, 1, -85)
auraPage.Position = UDim2.new(0, 10, 0, 80)
auraPage.BackgroundTransparency = 1
auraPage.Visible = false
auraPage.Parent = mainFrame

-- Aura Toggle
local auraToggle = Instance.new("TextButton")
auraToggle.Size = UDim2.new(1, 0, 0, 35)
auraToggle.Position = UDim2.new(0, 0, 0, 0)
auraToggle.BackgroundColor3 = COLORS.buttonDanger
auraToggle.TextColor3 = COLORS.textLight
auraToggle.Text = "KILL AURA: OFF"
auraToggle.Font = Enum.Font.GothamBold
auraToggle.TextSize = 14
auraToggle.Parent = auraPage

local auraToggleCorner = Instance.new("UICorner")
auraToggleCorner.CornerRadius = UDim.new(0, 8)
auraToggleCorner.Parent = auraToggle

-- Kill Counter
local killCounterLabel = Instance.new("TextLabel")
killCounterLabel.Size = UDim2.new(1, 0, 0, 18)
killCounterLabel.Position = UDim2.new(0, 0, 0, 40)
killCounterLabel.BackgroundTransparency = 1
killCounterLabel.TextColor3 = COLORS.buttonSuccess
killCounterLabel.Text = "Kills: 0"
killCounterLabel.Font = Enum.Font.GothamBold
killCounterLabel.TextSize = 11
killCounterLabel.Parent = auraPage

-- Target Label
local auraTargetLabel = Instance.new("TextLabel")
auraTargetLabel.Size = UDim2.new(1, 0, 0, 16)
auraTargetLabel.Position = UDim2.new(0, 0, 0, 60)
auraTargetLabel.BackgroundTransparency = 1
auraTargetLabel.TextColor3 = COLORS.textDark
auraTargetLabel.Text = "Select Target:"
auraTargetLabel.Font = Enum.Font.GothamBold
auraTargetLabel.TextSize = 10
auraTargetLabel.TextXAlignment = Enum.TextXAlignment.Left
auraTargetLabel.Parent = auraPage

-- Aura Player List
local auraPlayerScroll = Instance.new("ScrollingFrame")
auraPlayerScroll.Size = UDim2.new(1, 0, 0, 80)
auraPlayerScroll.Position = UDim2.new(0, 0, 0, 78)
auraPlayerScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
auraPlayerScroll.ScrollBarThickness = 4
auraPlayerScroll.Parent = auraPage

local auraPlayerScrollCorner = Instance.new("UICorner")
auraPlayerScrollCorner.CornerRadius = UDim.new(0, 6)
auraPlayerScrollCorner.Parent = auraPlayerScroll

local auraPlayerLayout = Instance.new("UIListLayout")
auraPlayerLayout.Padding = UDim.new(0, 2)
auraPlayerLayout.Parent = auraPlayerScroll

-- Smart Mode Toggle
local smartToggle = Instance.new("TextButton")
smartToggle.Size = UDim2.new(1, 0, 0, 24)
smartToggle.Position = UDim2.new(0, 0, 0, 162)
smartToggle.BackgroundColor3 = COLORS.buttonSuccess
smartToggle.TextColor3 = COLORS.textLight
smartToggle.Text = "SMART MODE: ON"
smartToggle.Font = Enum.Font.GothamBold
smartToggle.TextSize = 10
smartToggle.Parent = auraPage

local smartCorner = Instance.new("UICorner")
smartCorner.CornerRadius = UDim.new(0, 5)
smartCorner.Parent = smartToggle

-- Distance
local distRow = Instance.new("Frame")
distRow.Size = UDim2.new(1, 0, 0, 22)
distRow.Position = UDim2.new(0, 0, 0, 190)
distRow.BackgroundTransparency = 1
distRow.Parent = auraPage

local distLabel = Instance.new("TextLabel")
distLabel.Size = UDim2.new(0, 80, 1, 0)
distLabel.BackgroundTransparency = 1
distLabel.TextColor3 = COLORS.textDark
distLabel.Text = "Distance:"
distLabel.Font = Enum.Font.Gotham
distLabel.TextSize = 10
distLabel.TextXAlignment = Enum.TextXAlignment.Left
distLabel.Parent = distRow

local distInput = Instance.new("TextBox")
distInput.Size = UDim2.new(0, 50, 1, 0)
distInput.Position = UDim2.new(0, 85, 0, 0)
distInput.BackgroundColor3 = COLORS.inputBg
distInput.TextColor3 = COLORS.textDark
distInput.Text = "2"
distInput.Font = Enum.Font.Gotham
distInput.TextSize = 10
distInput.ClearTextOnFocus = false
distInput.Parent = distRow

local distCorner = Instance.new("UICorner")
distCorner.CornerRadius = UDim.new(0, 5)
distCorner.Parent = distInput

local distStroke = Instance.new("UIStroke")
distStroke.Color = COLORS.border
distStroke.Thickness = 1
distStroke.Parent = distInput

-- Swing Speed
local swingRow = Instance.new("Frame")
swingRow.Size = UDim2.new(1, 0, 0, 22)
swingRow.Position = UDim2.new(0, 0, 0, 216)
swingRow.BackgroundTransparency = 1
swingRow.Parent = auraPage

local swingLabel = Instance.new("TextLabel")
swingLabel.Size = UDim2.new(0, 80, 1, 0)
swingLabel.BackgroundTransparency = 1
swingLabel.TextColor3 = COLORS.textDark
swingLabel.Text = "Swing Speed:"
swingLabel.Font = Enum.Font.Gotham
swingLabel.TextSize = 10
swingLabel.TextXAlignment = Enum.TextXAlignment.Left
swingLabel.Parent = swingRow

local swingInput = Instance.new("TextBox")
swingInput.Size = UDim2.new(0, 50, 1, 0)
swingInput.Position = UDim2.new(0, 85, 0, 0)
swingInput.BackgroundColor3 = COLORS.inputBg
swingInput.TextColor3 = COLORS.textDark
swingInput.Text = "0.01"
swingInput.Font = Enum.Font.Gotham
swingInput.TextSize = 10
swingInput.ClearTextOnFocus = false
swingInput.Parent = swingRow

local swingCorner = Instance.new("UICorner")
swingCorner.CornerRadius = UDim.new(0, 5)
swingCorner.Parent = swingInput

local swingStroke = Instance.new("UIStroke")
swingStroke.Color = COLORS.border
swingStroke.Thickness = 1
swingStroke.Parent = swingInput

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

-- ========== TAB SWITCHING ==========

flingTab.MouseButton1Click:Connect(function()
    flingPage.Visible = true
    auraPage.Visible = false
    flingTab.BackgroundColor3 = COLORS.tabActive
    flingTab.TextColor3 = COLORS.textLight
    auraTab.BackgroundColor3 = COLORS.tabInactive
    auraTab.TextColor3 = COLORS.textDark
end)

auraTab.MouseButton1Click:Connect(function()
    flingPage.Visible = false
    auraPage.Visible = true
    auraTab.BackgroundColor3 = COLORS.tabActive
    auraTab.TextColor3 = COLORS.textLight
    flingTab.BackgroundColor3 = COLORS.tabInactive
    flingTab.TextColor3 = COLORS.textDark
end)

-- ========== PLAYER LISTS ==========

local flingPlayerButtons = {}
local auraPlayerButtons = {}

local function updatePlayerLists()
    -- Clear both lists
    for _, btn in pairs(flingPlayerButtons) do btn:Destroy() end
    for _, btn in pairs(auraPlayerButtons) do btn:Destroy() end
    flingPlayerButtons = {}
    auraPlayerButtons = {}
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            -- Fling list
            local btn1 = Instance.new("TextButton")
            btn1.Size = UDim2.new(1, 0, 0, 22)
            btn1.BackgroundColor3 = targetPlayer == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn1.TextColor3 = targetPlayer == plr and COLORS.textLight or COLORS.textDark
            btn1.Text = plr.Name
            btn1.Font = Enum.Font.Gotham
            btn1.TextSize = 10
            btn1.Parent = flingPlayerScroll
            
            local btn1Corner = Instance.new("UICorner")
            btn1Corner.CornerRadius = UDim.new(0, 5)
            btn1Corner.Parent = btn1
            
            btn1.MouseButton1Click:Connect(function()
                targetPlayer = plr
                updatePlayerLists()
            end)
            
            table.insert(flingPlayerButtons, btn1)
            
            -- Aura list
            local btn2 = Instance.new("TextButton")
            btn2.Size = UDim2.new(1, 0, 0, 22)
            btn2.BackgroundColor3 = targetPlayer == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn2.TextColor3 = targetPlayer == plr and COLORS.textLight or COLORS.textDark
            btn2.Text = plr.Name
            btn2.Font = Enum.Font.Gotham
            btn2.TextSize = 10
            btn2.Parent = auraPlayerScroll
            
            local btn2Corner = Instance.new("UICorner")
            btn2Corner.CornerRadius = UDim.new(0, 5)
            btn2Corner.Parent = btn2
            
            btn2.MouseButton1Click:Connect(function()
                targetPlayer = plr
                updatePlayerLists()
            end)
            
            table.insert(auraPlayerButtons, btn2)
        end
    end
    
    flingPlayerScroll.CanvasSize = UDim2.new(0, 0, 0, #flingPlayerButtons * 24)
    auraPlayerScroll.CanvasSize = UDim2.new(0, 0, 0, #auraPlayerButtons * 24)
end

Players.PlayerAdded:Connect(updatePlayerLists)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerLists()
end)

updatePlayerLists()

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

-- ========== FLING FUNCTIONS ==========

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
    
    flingLoop = RunService.Heartbeat:Connect(function()
        if not flingEnabled then return end
        
        local char = player.Character
        if not char then return end
        
        local root = getRoot(char)
        if not root then return end
        
        if not targetPlayer or not targetPlayer.Character then return end
        
        local targetRoot = getRoot(targetPlayer.Character)
        if not targetRoot then return end
        
        -- Teleport inside target
        root.CFrame = targetRoot.CFrame
        
        -- Re-apply body movers if needed
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

-- ========== AURA FUNCTIONS ==========

local function stopAura()
    if auraLoop then
        auraLoop:Disconnect()
        auraLoop = nil
    end
    
    if swingLoop then
        swingLoop:Disconnect()
        swingLoop = nil
    end
end

local function startAura()
    stopAura()
    
    equipSword()
    
    local dist = tonumber(distInput.Text) or 2
    local swing = tonumber(swingInput.Text) or 0.01
    
    -- Swing loop
    swingLoop = RunService.Heartbeat:Connect(function()
        if not auraEnabled then return end
        
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
    
    -- Teleport loop
    auraLoop = RunService.Heartbeat:Connect(function()
        if not auraEnabled then return end
        if not targetPlayer or not targetPlayer.Character then return end
        
        local myChar = player.Character
        local myRoot = myChar and getRoot(myChar)
        
        local targetChar = targetPlayer.Character
        local targetRoot = getRoot(targetChar)
        local targetHumanoid = targetChar and targetChar:FindFirstChild("Humanoid")
        
        if not myRoot or not targetRoot or not targetHumanoid then return end
        if targetHumanoid.Health <= 0 then return end
        
        -- Smart mode check
        if smartMode and hasSpawnProtection(targetPlayer) then
            return
        end
        
        -- Rotate around target
        attackAngle = attackAngle + 60
        if attackAngle >= 360 then attackAngle = 0 end
        
        local angleRad = math.rad(attackAngle)
        local offsetX = math.cos(angleRad) * dist
        local offsetZ = math.sin(angleRad) * dist
        
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(offsetX, 0, offsetZ)
        
        if myChar.HumanoidRootPart then
            myChar.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    -- Re-equip loop
    spawn(function()
        while auraEnabled do
            local sword = getSword()
            if not sword then
                equipSword()
            end
            wait(0.5)
        end
    end)
    
    -- Kill detection
    local lastHealth = 100
    spawn(function()
        while auraEnabled do
            if targetPlayer and targetPlayer.Character then
                local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                if targetHumanoid then
                    if targetHumanoid.Health <= 0 and lastHealth > 0 then
                        killCount = killCount + 1
                        killCounterLabel.Text = "Kills: " .. killCount
                    end
                    lastHealth = targetHumanoid.Health
                end
            end
            wait(0.1)
        end
    end)
end

local function swingSword()
    local sword = getSword()
    if sword then
        sword:Activate()
    end
end

-- ========== FLING TOGGLE ==========

flingToggle.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    
    if flingEnabled then
        -- Disable aura if on
        if auraEnabled then
            auraEnabled = false
            auraToggle.Text = "KILL AURA: OFF"
            auraToggle.BackgroundColor3 = COLORS.buttonDanger
            stopAura()
        end
        
        flingToggle.Text = "FLING: ON"
        flingToggle.BackgroundColor3 = COLORS.buttonSuccess
        
        if targetPlayer then
            startFling()
        end
        
    else
        flingToggle.Text = "FLING: OFF"
        flingToggle.BackgroundColor3 = COLORS.buttonDanger
        stopFling()
    end
end)

-- ========== AURA TOGGLE ==========

auraToggle.MouseButton1Click:Connect(function()
    auraEnabled = not auraEnabled
    
    if auraEnabled then
        -- Disable fling if on
        if flingEnabled then
            flingEnabled = false
            flingToggle.Text = "FLING: OFF"
            flingToggle.BackgroundColor3 = COLORS.buttonDanger
            stopFling()
        end
        
        auraToggle.Text = "KILL AURA: ON"
        auraToggle.BackgroundColor3 = COLORS.buttonSuccess
        
        if targetPlayer then
            startAura()
        end
        
    else
        auraToggle.Text = "KILL AURA: OFF"
        auraToggle.BackgroundColor3 = COLORS.buttonDanger
        stopAura()
    end
end)

-- ========== SMART MODE TOGGLE ==========

smartToggle.MouseButton1Click:Connect(function()
    smartMode = not smartMode
    
    if smartMode then
        smartToggle.Text = "SMART MODE: ON"
        smartToggle.BackgroundColor3 = COLORS.buttonSuccess
    else
        smartToggle.Text = "SMART MODE: OFF"
        smartToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

-- ========== RESPAWN HANDLER ==========

player.CharacterAdded:Connect(function(char)
    wait(0.5)
    
    if flingEnabled then
        flingCount = flingCount + 1
        flingCounterLabel.Text = "Flings: " .. flingCount
        startFling()
    end
    
    if auraEnabled then
        equipSword()
    end
end)

player.CharacterRemoving:Connect(function()
    stopFling()
    stopAura()
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

print("✅ Hybrid Script Loaded")
print("   Two tabs: FLING and AURA")
print("   Select target, then toggle one mode")
