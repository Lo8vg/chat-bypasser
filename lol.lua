-- BodyMover Fling Script (Rewritten)
-- Fixed for moving targets + added modes

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local flingEnabled = false
local targetPlayer = nil
local flingLoop = nil
local flingCount = 0
local killCount = 0
local lastTargetHealth = 100

-- Fling Modes: "Normal", "Orbit", "Chase", "Vertical"
local currentMode = "Normal"

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
    cardBg = Color3.fromRGB(255, 255, 255)
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingGui"
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
hubButtonIcon.Text = "🌀"
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
titleLabel.Text = "🌀 BodyMover Fling v2"
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
collapseCorner.Radius = UDim.new(0, 6)
collapseCorner.Parent = collapseButton

-- ========== LEFT FRAME ==========

local leftFrame = Instance.new("Frame")
leftFrame.Size = UDim2.new(0.55, -15, 1, -50)
leftFrame.Position = UDim2.new(0, 10, 0, 40)
leftFrame.BackgroundTransparency = 1
leftFrame.Parent = mainFrame

-- Target Input Row
local targetInputRow = Instance.new("Frame")
targetInputRow.Size = UDim2.new(1, 0, 0, 24)
targetInputRow.Position = UDim2.new(0, 0, 0, 0)
targetInputRow.BackgroundTransparency = 1
targetInputRow.Parent = leftFrame

local targetInput = Instance.new("TextBox")
targetInput.Size = UDim2.new(1, -75, 1, 0)
targetInput.BackgroundColor3 = COLORS.inputBg
targetInput.TextColor3 = COLORS.textDark
targetInput.Text = ""
targetInput.PlaceholderText = "Enter player name..."
targetInput.PlaceholderColor3 = COLORS.textMuted
targetInput.Font = Enum.Font.Gotham
targetInput.TextSize = 10
targetInput.ClearTextOnFocus = false
targetInput.Parent = targetInputRow

local targetInputCorner = Instance.new("UICorner")
targetInputCorner.Radius = UDim.new(0, 5)
targetInputCorner.Parent = targetInput

local targetInputStroke = Instance.new("UIStroke")
targetInputStroke.Color = COLORS.border
targetInputStroke.Thickness = 1
targetInputStroke.Parent = targetInput

local nearestBtn = Instance.new("TextButton")
nearestBtn.Size = UDim2.new(0, 65, 1, 0)
nearestBtn.Position = UDim2.new(1, -70, 0, 0)
nearestBtn.BackgroundColor3 = COLORS.buttonWarning
nearestBtn.TextColor3 = COLORS.textDark
nearestBtn.Text = "Nearest"
nearestBtn.Font = Enum.Font.GothamBold
nearestBtn.TextSize = 9
nearestBtn.Parent = targetInputRow

local nearestCorner = Instance.new("UICorner")
nearestCorner.Radius = UDim.new(0, 5)
nearestCorner.Parent = nearestBtn

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 0, 35)
toggleButton.Position = UDim2.new(0, 0, 0, 28)
toggleButton.BackgroundColor3 = COLORS.buttonDanger
toggleButton.TextColor3 = COLORS.textLight
toggleButton.Text = "FLING: OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = leftFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.Radius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Counters Row
local counterRow = Instance.new("Frame")
counterRow.Size = UDim2.new(1, 0, 0, 18)
counterRow.Position = UDim2.new(0, 0, 0, 68)
counterRow.BackgroundTransparency = 1
counterRow.Parent = leftFrame

local flingCounter = Instance.new("TextLabel")
flingCounter.Size = UDim2.new(0.5, 0, 1, 0)
flingCounter.BackgroundTransparency = 1
flingCounter.TextColor3 = COLORS.buttonSuccess
flingCounter.Text = "Flings: 0"
flingCounter.Font = Enum.Font.GothamBold
flingCounter.TextSize = 10
flingCounter.TextXAlignment = Enum.TextXAlignment.Left
flingCounter.Parent = counterRow

local killCounter = Instance.new("TextLabel")
killCounter.Size = UDim2.new(0.5, 0, 1, 0)
killCounter.Position = UDim2.new(0.5, 0, 0, 0)
killCounter.BackgroundTransparency = 1
killCounter.TextColor3 = COLORS.buttonDanger
killCounter.Text = "Kills: 0"
killCounter.Font = Enum.Font.GothamBold
killCounter.TextSize = 10
killCounter.TextXAlignment = Enum.TextXAlignment.Right
killCounter.Parent = counterRow

-- Target Label
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, 0, 0, 16)
targetLabel.Position = UDim2.new(0, 0, 0, 88)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = COLORS.textDark
targetLabel.Text = "Or select from list:"
targetLabel.Font = Enum.Font.GothamBold
targetLabel.TextSize = 10
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = leftFrame

-- Player List
local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1, 0, 0, 100)
playerScroll.Position = UDim2.new(0, 0, 0, 106)
playerScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerScroll.ScrollBarThickness = 4
playerScroll.Parent = leftFrame

local playerScrollCorner = Instance.new("UICorner")
playerScrollCorner.Radius = UDim.new(0, 6)
playerScrollCorner.Parent = playerScroll

local playerLayout = Instance.new("UIListLayout")
playerLayout.Padding = UDim.new(0, 2)
playerLayout.Parent = playerScroll

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.Position = UDim2.new(0, 0, 0, 210)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = COLORS.textMuted
statusLabel.Text = "No target selected"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextWrapped = true
statusLabel.Parent = leftFrame

-- Mode Buttons Label
local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, 0, 0, 16)
modeLabel.Position = UDim2.new(0, 0, 0, 232)
modeLabel.BackgroundTransparency = 1
modeLabel.TextColor3 = COLORS.textDark
modeLabel.Text = "Fling Mode:"
modeLabel.Font = Enum.Font.GothamBold
modeLabel.TextSize = 10
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = leftFrame

-- Mode Buttons
local modes = {"Normal", "Chase", "Orbit", "Vertical"}
local modeButtons = {}

for i, mode in ipairs(modes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#modes, -3, 0, 24)
    btn.Position = UDim2.new((i-1)/#modes + (i-1)*(3/200), 0, 0, 250)
    btn.BackgroundColor3 = i == 1 and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
    btn.TextColor3 = i == 1 and COLORS.textLight or COLORS.textDark
    btn.Text = mode
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.Parent = leftFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Radius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    modeButtons[mode] = btn
end

-- ========== RIGHT FRAME ==========

local rightFrame = Instance.new("Frame")
rightFrame.Size = UDim2.new(0.45, -15, 1, -50)
rightFrame.Position = UDim2.new(0.55, 5, 0, 40)
rightFrame.BackgroundTransparency = 1
rightFrame.Parent = mainFrame

-- Spin Power
local spinRow = Instance.new("Frame")
spinRow.Size = UDim2.new(1, 0, 0, 24)
spinRow.Position = UDim2.new(0, 0, 0, 0)
spinRow.BackgroundTransparency = 1
spinRow.Parent = rightFrame

local spinLabel = Instance.new("TextLabel")
spinLabel.Size = UDim2.new(0, 90, 1, 0)
spinLabel.BackgroundTransparency = 1
spinLabel.TextColor3 = COLORS.textDark
spinLabel.Text = "Spin Power:"
spinLabel.Font = Enum.Font.Gotham
spinLabel.TextSize = 10
spinLabel.TextXAlignment = Enum.TextXAlignment.Left
spinLabel.Parent = spinRow

local spinInput = Instance.new("TextBox")
spinInput.Size = UDim2.new(0, 80, 1, 0)
spinInput.Position = UDim2.new(0, 95, 0, 0)
spinInput.BackgroundColor3 = COLORS.inputBg
spinInput.TextColor3 = COLORS.textDark
spinInput.Text = "999999"
spinInput.Font = Enum.Font.Gotham
spinInput.TextSize = 10
spinInput.ClearTextOnFocus = false
spinInput.Parent = spinRow

local spinCorner = Instance.new("UICorner")
spinCorner.Radius = UDim.new(0, 5)
spinCorner.Parent = spinInput

local spinStroke = Instance.new("UIStroke")
spinStroke.Color = COLORS.border
spinStroke.Thickness = 1
spinStroke.Parent = spinInput

-- Launch Power
local launchRow = Instance.new("Frame")
launchRow.Size = UDim2.new(1, 0, 0, 24)
launchRow.Position = UDim2.new(0, 0, 0, 28)
launchRow.BackgroundTransparency = 1
launchRow.Parent = rightFrame

local launchLabel = Instance.new("TextLabel")
launchLabel.Size = UDim2.new(0, 90, 1, 0)
launchLabel.BackgroundTransparency = 1
launchLabel.TextColor3 = COLORS.textDark
launchLabel.Text = "Launch Power:"
launchLabel.Font = Enum.Font.Gotham
launchLabel.TextSize = 10
launchLabel.TextXAlignment = Enum.TextXAlignment.Left
launchLabel.Parent = launchRow

local launchInput = Instance.new("TextBox")
launchInput.Size = UDim2.new(0, 80, 1, 0)
launchInput.Position = UDim2.new(0, 95, 0, 0)
launchInput.BackgroundColor3 = COLORS.inputBg
launchInput.TextColor3 = COLORS.textDark
launchInput.Text = "999999"
launchInput.Font = Enum.Font.Gotham
launchInput.TextSize = 10
launchInput.ClearTextOnFocus = false
launchInput.Parent = launchRow

local launchCorner = Instance.new("UICorner")
launchCorner.Radius = UDim.new(0, 5)
launchCorner.Parent = launchInput

local launchStroke = Instance.new("UIStroke")
launchStroke.Color = COLORS.border
launchStroke.Thickness = 1
launchStroke.Parent = launchInput

-- Prediction
local predRow = Instance.new("Frame")
predRow.Size = UDim2.new(1, 0, 0, 24)
predRow.Position = UDim2.new(0, 0, 0, 56)
predRow.BackgroundTransparency = 1
predRow.Parent = rightFrame

local predLabel = Instance.new("TextLabel")
predLabel.Size = UDim2.new(0, 90, 1, 0)
predLabel.BackgroundTransparency = 1
predLabel.TextColor3 = COLORS.textDark
predLabel.Text = "Prediction:"
predLabel.Font = Enum.Font.Gotham
predLabel.TextSize = 10
predLabel.TextXAlignment = Enum.TextXAlignment.Left
predLabel.Parent = predRow

local predInput = Instance.new("TextBox")
predInput.Size = UDim2.new(0, 80, 1, 0)
predInput.Position = UDim2.new(0, 95, 0, 0)
predInput.BackgroundColor3 = COLORS.inputBg
predInput.TextColor3 = COLORS.textDark
predInput.Text = "0.15"
predInput.Font = Enum.Font.Gotham
predInput.TextSize = 10
predInput.ClearTextOnFocus = false
predInput.Parent = predRow

local predCorner = Instance.new("UICorner")
predCorner.Radius = UDim.new(0, 5)
predCorner.Parent = predInput

local predStroke = Instance.new("UIStroke")
predStroke.Color = COLORS.border
predStroke.Thickness = 1
predStroke.Parent = predInput

-- Info
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 100)
infoLabel.Position = UDim2.new(0, 0, 0, 90)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = COLORS.textMuted
infoLabel.Text = "MODES:\n• Normal - Standard fling\n• Chase - Aggressive tracking\n• Orbit - Spin around target\n• Vertical - Launch upward\n\nHigher prediction = better for\nfast-moving targets"
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
            btnCorner.Radius = UDim.new(0, 5)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                targetPlayer = plr
                targetInput.Text = plr.Name
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

-- ========== HELPER FUNCTIONS ==========

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function getNearestPlayer()
    local myChar = player.Character
    if not myChar then return nil end
    
    local myRoot = getRoot(myChar)
    if not myRoot then return nil end
    
    local nearest = nil
    local nearestDist = math.huge
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local root = getRoot(plr.Character)
            if root then
                local dist = (root.Position - myRoot.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = plr
                end
            end
        end
    end
    
    return nearest
end

local bodyAngularVel = nil
local bodyVel = nil
local orbitAngle = 0

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
    local prediction = tonumber(predInput.Text) or 0.15
    
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
    
    orbitAngle = 0
    
    -- Use RenderStepped for faster updates
    flingLoop = RunService.RenderStepped:Connect(function()
        if not flingEnabled then return end
        
        local char = player.Character
        if not char then return end
        
        local root = getRoot(char)
        if not root then return end
        
        if not targetPlayer or not targetPlayer.Character then
            return
        end
        
        local targetRoot = getRoot(targetPlayer.Character)
        if not targetRoot then return end
        
        local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        
        -- Track kills
        if targetHumanoid then
            local currentHealth = targetHumanoid.Health
            if lastTargetHealth > 0 and currentHealth <= 0 then
                killCount = killCount + 1
                killCounter.Text = "Kills: " .. killCount
            end
            lastTargetHealth = currentHealth
        end
        
        -- Get target velocity for prediction
        local targetVel = targetRoot.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
        local predictedPos = targetRoot.Position + (targetVel * prediction)
        
        if currentMode == "Normal" then
            -- Standard fling with prediction
            root.CFrame = CFrame.new(predictedPos) * targetRoot.CFrame.Rotation
            
        elseif currentMode == "Chase" then
            -- Aggressive tracking - higher prediction
            local chasePred = targetVel * (prediction * 2)
            local chasePos = targetRoot.Position + chasePred
            root.CFrame = CFrame.new(chasePos) * targetRoot.CFrame.Rotation
            
        elseif currentMode == "Orbit" then
            -- Spin around target
            orbitAngle = orbitAngle + 0.3
            local orbitDist = 3
            local offsetX = math.cos(orbitAngle) * orbitDist
            local offsetZ = math.sin(orbitAngle) * orbitDist
            local orbitPos = predictedPos + Vector3.new(offsetX, 0, offsetZ)
            root.CFrame = CFrame.new(orbitPos, predictedPos)
            
        elseif currentMode == "Vertical" then
            -- Launch straight up while tracking
            root.CFrame = CFrame.new(predictedPos + Vector3.new(0, 5, 0))
            bodyVel.Velocity = Vector3.new(0, launchPower * 2, 0)
        end
        
        -- Re-apply body movers if removed
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

-- ========== MODE BUTTONS ==========

for mode, btn in pairs(modeButtons) do
    btn.MouseButton1Click:Connect(function()
        currentMode = mode
        for m, b in pairs(modeButtons) do
            if m == mode then
                b.BackgroundColor3 = COLORS.buttonPrimary
                b.TextColor3 = COLORS.textLight
            else
                b.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
                b.TextColor3 = COLORS.textDark
            end
        end
    end)
end

-- ========== NEAREST BUTTON ==========

nearestBtn.MouseButton1Click:Connect(function()
    local nearest = getNearestPlayer()
    if nearest then
        targetPlayer = nearest
        targetInput.Text = nearest.Name
        statusLabel.Text = "Target: " .. nearest.Name
        updatePlayerList()
    else
        statusLabel.Text = "No players nearby"
    end
end)

-- ========== TARGET INPUT ==========

targetInput.FocusLost:Connect(function(enterPressed)
    if enterPressed or true then
        local name = targetInput.Text:lower()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Name:lower():sub(1, #name) == name then
                targetPlayer = plr
                statusLabel.Text = "Target: " .. plr.Name
                updatePlayerList()
                return
            end
        end
        statusLabel.Text = "Player not found"
    end
end)

-- ========== FLING TOGGLE ==========

toggleButton.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    
    if flingEnabled then
        if not targetPlayer then
            statusLabel.Text = "Select a target first!"
            flingEnabled = false
            return
        end
        
        toggleButton.Text = "FLING: ON"
        toggleButton.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel.Text = "Flinging: " .. targetPlayer.Name .. " (" .. currentMode .. ")"
        lastTargetHealth = 100
        
        startFling()
        
    else
        toggleButton.Text = "FLING: OFF"
        toggleButton.BackgroundColor3 = COLORS.buttonDanger
        statusLabel.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
        
        stopFling()
    end
end)

-- Toggle with key
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

-- Auto-restart on respawn
player.CharacterAdded:Connect(function(char)
    wait(0.3)
    
    if flingEnabled then
        flingCount = flingCount + 1
        flingCounter.Text = "Flings: " .. flingCount
        startFling()
    end
end)

-- Cleanup
player.CharacterRemoving:Connect(function()
    stopFling()
end)

print("✅ BodyMover Fling v2 Loaded")
print("   Modes: Normal, Chase, Orbit, Vertical")
print("   Fixed for moving targets with velocity prediction")
