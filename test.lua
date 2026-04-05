-- Kill Aura Script with Kill All Tab
-- Tab 1: Kill Aura (single target)
-- Tab 2: Kill All (cycles through entire server, skips teammates)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Teams = game:GetService("Teams")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local killAuraEnabled = false
local killAllEnabled = false
local targetPlayer = nil
local attackDelay = 0.05
local swingsPerAttack = 3
local checkRate = 0.1
local currentIndex = 1
local killAllLoop = nil

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
    tabInactive = Color3.fromRGB(200, 200, 200)
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KillGui"
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
mainFrame.Size = UDim2.new(0, 300, 0, 450)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
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
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = COLORS.textDark
titleLabel.Text = "⚔️ Kill System"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 30, 0, 24)
collapseButton.Position = UDim2.new(1, -38, 0.5, -12)
collapseButton.BackgroundColor3 = COLORS.buttonDanger
collapseButton.TextColor3 = COLORS.textLight
collapseButton.Text = "✕"
collapseButton.Font = Enum.Font.GothamBold
collapseButton.TextSize = 12
collapseButton.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseButton

-- ========== TAB SYSTEM ==========

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 35)
tabFrame.Position = UDim2.new(0, 0, 0, 42)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabAura = Instance.new("TextButton")
tabAura.Size = UDim2.new(0.5, -5, 1, 0)
tabAura.Position = UDim2.new(0, 5, 0, 0)
tabAura.BackgroundColor3 = COLORS.tabActive
tabAura.TextColor3 = COLORS.textLight
tabAura.Text = "Kill Aura"
tabAura.Font = Enum.Font.GothamBold
tabAura.TextSize = 12
tabAura.Parent = tabFrame

local tabAuraCorner = Instance.new("UICorner")
tabAuraCorner.CornerRadius = UDim.new(0, 6)
tabAuraCorner.Parent = tabAura

local tabAll = Instance.new("TextButton")
tabAll.Size = UDim2.new(0.5, -5, 1, 0)
tabAll.Position = UDim2.new(0.5, 0, 0, 0)
tabAll.BackgroundColor3 = COLORS.tabInactive
tabAll.TextColor3 = COLORS.textDark
tabAll.Text = "Kill All"
tabAll.Font = Enum.Font.GothamBold
tabAll.TextSize = 12
tabAll.Parent = tabFrame

local tabAllCorner = Instance.new("UICorner")
tabAllCorner.CornerRadius = UDim.new(0, 6)
tabAllCorner.Parent = tabAll

-- ========== KILL AURA CONTENT ==========

local auraContent = Instance.new("Frame")
auraContent.Size = UDim2.new(1, -30, 1, -90)
auraContent.Position = UDim2.new(0, 15, 0, 80)
auraContent.BackgroundTransparency = 1
auraContent.Visible = true
auraContent.Parent = mainFrame

-- Toggle Button
local auraToggle = Instance.new("TextButton")
auraToggle.Size = UDim2.new(1, 0, 0, 40)
auraToggle.Position = UDim2.new(0, 0, 0, 0)
auraToggle.BackgroundColor3 = COLORS.buttonDanger
auraToggle.TextColor3 = COLORS.textLight
auraToggle.Text = "KILL AURA: OFF"
auraToggle.Font = Enum.Font.GothamBold
auraToggle.TextSize = 14
auraToggle.Parent = auraContent

local auraToggleCorner = Instance.new("UICorner")
auraToggleCorner.CornerRadius = UDim.new(0, 8)
auraToggleCorner.Parent = auraToggle

-- Protection Status
local auraProtection = Instance.new("TextLabel")
auraProtection.Size = UDim2.new(1, 0, 0, 18)
auraProtection.Position = UDim2.new(0, 0, 0, 45)
auraProtection.BackgroundTransparency = 1
auraProtection.TextColor3 = COLORS.textMuted
auraProtection.Text = "Protection: Waiting..."
auraProtection.Font = Enum.Font.Gotham
auraProtection.TextSize = 10
auraProtection.Parent = auraContent

-- Target Label
local auraTargetLabel = Instance.new("TextLabel")
auraTargetLabel.Size = UDim2.new(1, 0, 0, 18)
auraTargetLabel.Position = UDim2.new(0, 0, 0, 68)
auraTargetLabel.BackgroundTransparency = 1
auraTargetLabel.TextColor3 = COLORS.textDark
auraTargetLabel.Text = "Select Target:"
auraTargetLabel.Font = Enum.Font.GothamBold
auraTargetLabel.TextSize = 11
auraTargetLabel.TextXAlignment = Enum.TextXAlignment.Left
auraTargetLabel.Parent = auraContent

-- Player List
local auraPlayerScroll = Instance.new("ScrollingFrame")
auraPlayerScroll.Size = UDim2.new(1, 0, 0, 100)
auraPlayerScroll.Position = UDim2.new(0, 0, 0, 88)
auraPlayerScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
auraPlayerScroll.ScrollBarThickness = 4
auraPlayerScroll.Parent = auraContent

local auraPlayerScrollCorner = Instance.new("UICorner")
auraPlayerScrollCorner.CornerRadius = UDim.new(0, 6)
auraPlayerScrollCorner.Parent = auraPlayerScroll

local auraPlayerLayout = Instance.new("UIListLayout")
auraPlayerLayout.Padding = UDim.new(0, 3)
auraPlayerLayout.Parent = auraPlayerScroll

-- Aura Settings Row
local auraSettingsRow = Instance.new("Frame")
auraSettingsRow.Size = UDim2.new(1, 0, 0, 60)
auraSettingsRow.Position = UDim2.new(0, 0, 0, 195)
auraSettingsRow.BackgroundTransparency = 1
auraSettingsRow.Parent = auraContent

-- Delay
local auraDelayLabel = Instance.new("TextLabel")
auraDelayLabel.Size = UDim2.new(0, 80, 0, 25)
auraDelayLabel.Position = UDim2.new(0, 0, 0, 0)
auraDelayLabel.BackgroundTransparency = 1
auraDelayLabel.TextColor3 = COLORS.textDark
auraDelayLabel.Text = "Delay:"
auraDelayLabel.Font = Enum.Font.Gotham
auraDelayLabel.TextSize = 10
auraDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
auraDelayLabel.Parent = auraSettingsRow

local auraDelayInput = Instance.new("TextBox")
auraDelayInput.Size = UDim2.new(0, 50, 0, 25)
auraDelayInput.Position = UDim2.new(0, 50, 0, 0)
auraDelayInput.BackgroundColor3 = COLORS.inputBg
auraDelayInput.TextColor3 = COLORS.textDark
auraDelayInput.Text = "0.05"
auraDelayInput.Font = Enum.Font.Gotham
auraDelayInput.TextSize = 10
auraDelayInput.ClearTextOnFocus = false
auraDelayInput.Parent = auraSettingsRow

local auraDelayCorner = Instance.new("UICorner")
auraDelayCorner.CornerRadius = UDim.new(0, 5)
auraDelayCorner.Parent = auraDelayInput

local auraDelayStroke = Instance.new("UIStroke")
auraDelayStroke.Color = COLORS.border
auraDelayStroke.Thickness = 1
auraDelayStroke.Parent = auraDelayInput

-- Swings
local auraSwingsLabel = Instance.new("TextLabel")
auraSwingsLabel.Size = UDim2.new(0, 80, 0, 25)
auraSwingsLabel.Position = UDim2.new(0, 110, 0, 0)
auraSwingsLabel.BackgroundTransparency = 1
auraSwingsLabel.TextColor3 = COLORS.textDark
auraSwingsLabel.Text = "Swings:"
auraSwingsLabel.Font = Enum.Font.Gotham
auraSwingsLabel.TextSize = 10
auraSwingsLabel.TextXAlignment = Enum.TextXAlignment.Left
auraSwingsLabel.Parent = auraSettingsRow

local auraSwingsInput = Instance.new("TextBox")
auraSwingsInput.Size = UDim2.new(0, 40, 0, 25)
auraSwingsInput.Position = UDim2.new(0, 160, 0, 0)
auraSwingsInput.BackgroundColor3 = COLORS.inputBg
auraSwingsInput.TextColor3 = COLORS.textDark
auraSwingsInput.Text = "3"
auraSwingsInput.Font = Enum.Font.Gotham
auraSwingsInput.TextSize = 10
auraSwingsInput.ClearTextOnFocus = false
auraSwingsInput.Parent = auraSettingsRow

local auraSwingsCorner = Instance.new("UICorner")
auraSwingsCorner.CornerRadius = UDim.new(0, 5)
auraSwingsCorner.Parent = auraSwingsInput

local auraSwingsStroke = Instance.new("UIStroke")
auraSwingsStroke.Color = COLORS.border
auraSwingsStroke.Thickness = 1
auraSwingsStroke.Parent = auraSwingsInput

-- Status
local auraStatus = Instance.new("TextLabel")
auraStatus.Size = UDim2.new(1, 0, 0, 18)
auraStatus.Position = UDim2.new(0, 0, 0, 260)
auraStatus.BackgroundTransparency = 1
auraStatus.TextColor3 = COLORS.textMuted
auraStatus.Text = "No target selected"
auraStatus.Font = Enum.Font.Gotham
auraStatus.TextSize = 10
auraStatus.TextWrapped = true
auraStatus.Parent = auraContent

-- ========== KILL ALL CONTENT ==========

local allContent = Instance.new("Frame")
allContent.Size = UDim2.new(1, -30, 1, -90)
allContent.Position = UDim2.new(0, 15, 0, 80)
allContent.BackgroundTransparency = 1
allContent.Visible = false
allContent.Parent = mainFrame

-- Kill All Toggle
local allToggle = Instance.new("TextButton")
allToggle.Size = UDim2.new(1, 0, 0, 45)
allToggle.Position = UDim2.new(0, 0, 0, 0)
allToggle.BackgroundColor3 = COLORS.buttonDanger
allToggle.TextColor3 = COLORS.textLight
allToggle.Text = "KILL ALL: OFF"
allToggle.Font = Enum.Font.GothamBold
allToggle.TextSize = 16
allToggle.Parent = allContent

local allToggleCorner = Instance.new("UICorner")
allToggleCorner.CornerRadius = UDim.new(0, 8)
allToggleCorner.Parent = allToggle

-- Current Target
local allTargetLabel = Instance.new("TextLabel")
allTargetLabel.Size = UDim2.new(1, 0, 0, 20)
allTargetLabel.Position = UDim2.new(0, 0, 0, 55)
allTargetLabel.BackgroundTransparency = 1
allTargetLabel.TextColor3 = COLORS.textDark
allTargetLabel.Text = "Current Target: None"
allTargetLabel.Font = Enum.Font.GothamBold
allTargetLabel.TextSize = 11
allTargetLabel.Parent = allContent

-- Protection Status
local allProtection = Instance.new("TextLabel")
allProtection.Size = UDim2.new(1, 0, 0, 18)
allProtection.Position = UDim2.new(0, 0, 0, 78)
allProtection.BackgroundTransparency = 1
allProtection.TextColor3 = COLORS.textMuted
allProtection.Text = "Protection: Waiting..."
allProtection.Font = Enum.Font.Gotham
allProtection.TextSize = 10
allProtection.Parent = allContent

-- Players Found
local allPlayersLabel = Instance.new("TextLabel")
allPlayersLabel.Size = UDim2.new(1, 0, 0, 18)
allPlayersLabel.Position = UDim2.new(0, 0, 0, 100)
allPlayersLabel.BackgroundTransparency = 1
allPlayersLabel.TextColor3 = COLORS.textMuted
allPlayersLabel.Text = "Enemies found: 0"
allPlayersLabel.Font = Enum.Font.Gotham
allPlayersLabel.TextSize = 10
allPlayersLabel.Parent = allContent

-- Settings
local allSettingsRow = Instance.new("Frame")
allSettingsRow.Size = UDim2.new(1, 0, 0, 60)
allSettingsRow.Position = UDim2.new(0, 0, 0, 125)
allSettingsRow.BackgroundTransparency = 1
allSettingsRow.Parent = allContent

-- Delay
local allDelayLabel = Instance.new("TextLabel")
allDelayLabel.Size = UDim2.new(0, 80, 0, 25)
allDelayLabel.Position = UDim2.new(0, 0, 0, 0)
allDelayLabel.BackgroundTransparency = 1
allDelayLabel.TextColor3 = COLORS.textDark
allDelayLabel.Text = "Delay:"
allDelayLabel.Font = Enum.Font.Gotham
allDelayLabel.TextSize = 10
allDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
allDelayLabel.Parent = allSettingsRow

local allDelayInput = Instance.new("TextBox")
allDelayInput.Size = UDim2.new(0, 50, 0, 25)
allDelayInput.Position = UDim2.new(0, 50, 0, 0)
allDelayInput.BackgroundColor3 = COLORS.inputBg
allDelayInput.TextColor3 = COLORS.textDark
allDelayInput.Text = "0.05"
allDelayInput.Font = Enum.Font.Gotham
allDelayInput.TextSize = 10
allDelayInput.ClearTextOnFocus = false
allDelayInput.Parent = allSettingsRow

local allDelayCorner = Instance.new("UICorner")
allDelayCorner.CornerRadius = UDim.new(0, 5)
allDelayCorner.Parent = allDelayInput

local allDelayStroke = Instance.new("UIStroke")
allDelayStroke.Color = COLORS.border
allDelayStroke.Thickness = 1
allDelayStroke.Parent = allDelayInput

-- Swings
local allSwingsLabel = Instance.new("TextLabel")
allSwingsLabel.Size = UDim2.new(0, 80, 0, 25)
allSwingsLabel.Position = UDim2.new(0, 110, 0, 0)
allSwingsLabel.BackgroundTransparency = 1
allSwingsLabel.TextColor3 = COLORS.textDark
allSwingsLabel.Text = "Swings:"
allSwingsLabel.Font = Enum.Font.Gotham
allSwingsLabel.TextSize = 10
allSwingsLabel.TextXAlignment = Enum.TextXAlignment.Left
allSwingsLabel.Parent = allSettingsRow

local allSwingsInput = Instance.new("TextBox")
allSwingsInput.Size = UDim2.new(0, 40, 0, 25)
allSwingsInput.Position = UDim2.new(0, 160, 0, 0)
allSwingsInput.BackgroundColor3 = COLORS.inputBg
allSwingsInput.TextColor3 = COLORS.textDark
allSwingsInput.Text = "3"
allSwingsInput.Font = Enum.Font.Gotham
allSwingsInput.TextSize = 10
allSwingsInput.ClearTextOnFocus = false
allSwingsInput.Parent = allSettingsRow

local allSwingsCorner = Instance.new("UICorner")
allSwingsCorner.CornerRadius = UDim.new(0, 5)
allSwingsCorner.Parent = allSwingsInput

local allSwingsStroke = Instance.new("UIStroke")
allSwingsStroke.Color = COLORS.border
allSwingsStroke.Thickness = 1
allSwingsStroke.Parent = allSwingsInput

-- Status
local allStatus = Instance.new("TextLabel")
allStatus.Size = UDim2.new(1, 0, 0, 40)
allStatus.Position = UDim2.new(0, 0, 0, 190)
allStatus.BackgroundTransparency = 1
allStatus.TextColor3 = COLORS.textMuted
allStatus.Text = "Cycles through all enemies\nSkips teammates automatically"
allStatus.Font = Enum.Font.Gotham
allStatus.TextSize = 9
allStatus.TextWrapped = true
allStatus.Parent = allContent

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

tabAura.MouseButton1Click:Connect(function()
    auraContent.Visible = true
    allContent.Visible = false
    tabAura.BackgroundColor3 = COLORS.tabActive
    tabAura.TextColor3 = COLORS.textLight
    tabAll.BackgroundColor3 = COLORS.tabInactive
    tabAll.TextColor3 = COLORS.textDark
end)

tabAll.MouseButton1Click:Connect(function()
    auraContent.Visible = false
    allContent.Visible = true
    tabAll.BackgroundColor3 = COLORS.tabActive
    tabAll.TextColor3 = COLORS.textLight
    tabAura.BackgroundColor3 = COLORS.tabInactive
    tabAura.TextColor3 = COLORS.textDark
end)

-- ========== HELPER FUNCTIONS ==========

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

local function isTeammate(targetPlr)
    if targetPlr == player then return true end
    
    local myTeam = player.Team
    local targetTeam = targetPlr.Team
    
    if myTeam and targetTeam then
        return myTeam == targetTeam
    end
    
    return false
end

local function getEnemies()
    local enemies = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if not isTeammate(plr) then
            table.insert(enemies, plr)
        end
    end
    return enemies
end

-- ========== PLAYER LIST FOR KILL AURA ==========

local playerButtons = {}

local function updatePlayerList()
    for _, btn in pairs(playerButtons) do
        btn:Destroy()
    end
    playerButtons = {}
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and not isTeammate(plr) then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 26)
            btn.BackgroundColor3 = targetPlayer == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn.TextColor3 = targetPlayer == plr and COLORS.textLight or COLORS.textDark
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 10
            btn.Parent = auraPlayerScroll
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                targetPlayer = plr
                auraStatus.Text = "Target: " .. plr.Name
                updatePlayerList()
            end)
            
            table.insert(playerButtons, btn)
        end
    end
    
    auraPlayerScroll.CanvasSize = UDim2.new(0, 0, 0, #playerButtons * 29)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerList()
end)

updatePlayerList()

-- ========== ATTACK FUNCTION ==========

local function attackTarget(targetPlr)
    if not targetPlr then return end
    
    local myChar = player.Character
    local myHum = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar and myChar:FindFirstChild("Humanoid")
    
    local targetChar = targetPlr.Character
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

-- ========== KILL AURA TOGGLE ==========

auraToggle.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    
    -- Disable Kill All if Kill Aura is on
    if killAuraEnabled and killAllEnabled then
        killAllEnabled = false
        allToggle.Text = "KILL ALL: OFF"
        allToggle.BackgroundColor3 = COLORS.buttonDanger
        if killAllLoop then
            killAllLoop:Disconnect()
            killAllLoop = nil
        end
    end
    
    attackDelay = tonumber(auraDelayInput.Text) or 0.05
    if attackDelay < 0.01 then attackDelay = 0.01 end
    
    swingsPerAttack = tonumber(auraSwingsInput.Text) or 3
    if swingsPerAttack < 1 then swingsPerAttack = 1 end
    if swingsPerAttack > 10 then swingsPerAttack = 10 end
    
    if killAuraEnabled then
        auraToggle.Text = "KILL AURA: ON"
        auraToggle.BackgroundColor3 = COLORS.buttonSuccess
        auraStatus.Text = targetPlayer and ("Hunting: " .. targetPlayer.Name) or "No target selected"
        
        equipSword()
        
        spawn(function()
            while killAuraEnabled do
                if targetPlayer and targetPlayer.Character then
                    local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                    
                    if targetHumanoid then
                        if targetHumanoid.Health > 0 then
                            if hasProtection(targetPlayer) then
                                auraProtection.Text = "Protection: TARGET PROTECTED"
                                auraProtection.TextColor3 = COLORS.buttonWarning
                                auraStatus.Text = "Waiting for target protection to end..."
                            else
                                auraProtection.Text = "Protection: TARGET VULNERABLE"
                                auraProtection.TextColor3 = COLORS.buttonSuccess
                                auraStatus.Text = "ATTACKING!"
                                
                                attackTarget(targetPlayer)
                                wait(attackDelay)
                            end
                        else
                            auraProtection.Text = "Protection: Target dead"
                            auraProtection.TextColor3 = COLORS.textMuted
                            auraStatus.Text = "Waiting for target respawn..."
                        end
                    else
                        auraProtection.Text = "Protection: No humanoid"
                        auraProtection.TextColor3 = COLORS.textMuted
                    end
                else
                    auraProtection.Text = "Protection: No target"
                    auraProtection.TextColor3 = COLORS.textMuted
                    auraStatus.Text = "Target left or respawning..."
                end
                
                wait(checkRate)
            end
        end)
        
    else
        auraToggle.Text = "KILL AURA: OFF"
        auraToggle.BackgroundColor3 = COLORS.buttonDanger
        auraStatus.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
        auraProtection.Text = "Protection: Waiting..."
        auraProtection.TextColor3 = COLORS.textMuted
    end
end)

-- ========== KILL ALL TOGGLE ==========

allToggle.MouseButton1Click:Connect(function()
    killAllEnabled = not killAllEnabled
    
    -- Disable Kill Aura if Kill All is on
    if killAllEnabled and killAuraEnabled then
        killAuraEnabled = false
        auraToggle.Text = "KILL AURA: OFF"
        auraToggle.BackgroundColor3 = COLORS.buttonDanger
    end
    
    attackDelay = tonumber(allDelayInput.Text) or 0.05
    if attackDelay < 0.01 then attackDelay = 0.01 end
    
    swingsPerAttack = tonumber(allSwingsInput.Text) or 3
    if swingsPerAttack < 1 then swingsPerAttack = 1 end
    if swingsPerAttack > 10 then swingsPerAttack = 10 end
    
    if killAllEnabled then
        allToggle.Text = "KILL ALL: ON"
        allToggle.BackgroundColor3 = COLORS.buttonSuccess
        allStatus.Text = "Cycling through enemies..."
        
        equipSword()
        currentIndex = 1
        
        killAllLoop = spawn(function()
            while killAllEnabled do
                local enemies = getEnemies()
                allPlayersLabel.Text = "Enemies found: " .. #enemies
                
                if #enemies == 0 then
                    allTargetLabel.Text = "Current Target: None"
                    allProtection.Text = "Protection: No enemies"
                    allStatus.Text = "Waiting for enemies..."
                    wait(1)
                else
                    -- Cycle through enemies
                    if currentIndex > #enemies then
                        currentIndex = 1
                    end
                    
                    local currentEnemy = enemies[currentIndex]
                    
                    if currentEnemy and currentEnemy.Character then
                        local targetHumanoid = currentEnemy.Character:FindFirstChild("Humanoid")
                        
                        if targetHumanoid and targetHumanoid.Health > 0 then
                            allTargetLabel.Text = "Current Target: " .. currentEnemy.Name
                            
                            if hasProtection(currentEnemy) then
                                allProtection.Text = "Protection: PROTECTED - SKIP"
                                allProtection.TextColor3 = COLORS.buttonWarning
                                allStatus.Text = "Has protection, moving to next..."
                            else
                                allProtection.Text = "Protection: VULNERABLE - ATTACK"
                                allProtection.TextColor3 = COLORS.buttonSuccess
                                allStatus.Text = "ATTACKING: " .. currentEnemy.Name
                                
                                attackTarget(currentEnemy)
                                wait(attackDelay)
                            end
                        else
                            allTargetLabel.Text = "Current Target: " .. currentEnemy.Name .. " (dead)"
                            allProtection.Text = "Protection: Target dead"
                            allProtection.TextColor3 = COLORS.textMuted
                        end
                    else
                        allTargetLabel.Text = "Current Target: " .. (currentEnemy and currentEnemy.Name or "None")
                        allProtection.Text = "Protection: No character"
                        allProtection.TextColor3 = COLORS.textMuted
                    end
                    
                    currentIndex = currentIndex + 1
                    wait(checkRate)
                end
            end
        end)
        
    else
        allToggle.Text = "KILL ALL: OFF"
        allToggle.BackgroundColor3 = COLORS.buttonDanger
        allTargetLabel.Text = "Current Target: None"
        allProtection.Text = "Protection: Waiting..."
        allProtection.TextColor3 = COLORS.textMuted
        allPlayersLabel.Text = "Enemies found: 0"
        allStatus.Text = "Cycles through all enemies\nSkips teammates automatically"
        
        if killAllLoop then
            killAllLoop:Disconnect()
            killAllLoop = nil
        end
    end
end)

-- ========== RESPAWN HANDLER ==========

player.CharacterAdded:Connect(function()
    wait(1)
    if killAuraEnabled or killAllEnabled then
        equipSword()
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

print("✅ Kill System Loaded - Two tabs: Kill Aura & Kill All")
