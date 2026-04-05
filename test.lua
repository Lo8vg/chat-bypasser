-- Collision Fling Script
-- Uses rapid teleportation + collision physics (NO spinning)

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

-- Collision Settings
local collisionMode = "rapid" -- "rapid", "velocity", "hybrid"
local teleportSpeed = 1000
local velocityPower = 50000

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
screenGui.Name = "CollisionFlingGui"
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
hubButtonIcon.Text = "💥"
hubButtonIcon.Font = Enum.Font.GothamBold
hubButtonIcon.TextSize = 22
hubButtonIcon.Parent = hubButton

-- ========== MAIN FRAME ==========

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 350)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
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
titleLabel.Text = "💥 Collision Fling"
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

-- ========== LEFT FRAME ==========

local leftFrame = Instance.new("Frame")
leftFrame.Size = UDim2.new(0.5, -15, 1, -50)
leftFrame.Position = UDim2.new(0, 10, 0, 40)
leftFrame.BackgroundTransparency = 1
leftFrame.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 0, 35)
toggleButton.Position = UDim2.new(0, 0, 0, 0)
toggleButton.BackgroundColor3 = COLORS.buttonDanger
toggleButton.TextColor3 = COLORS.textLight
toggleButton.Text = "FLING: OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = leftFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Fling Counter
local flingCounter = Instance.new("TextLabel")
flingCounter.Size = UDim2.new(1, 0, 0, 18)
flingCounter.Position = UDim2.new(0, 0, 0, 40)
flingCounter.BackgroundTransparency = 1
flingCounter.TextColor3 = COLORS.buttonSuccess
flingCounter.Text = "Flings: 0"
flingCounter.Font = Enum.Font.GothamBold
flingCounter.TextSize = 11
flingCounter.Parent = leftFrame

-- Target Label
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, 0, 0, 16)
targetLabel.Position = UDim2.new(0, 0, 0, 58)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = COLORS.textDark
targetLabel.Text = "Select Target:"
targetLabel.Font = Enum.Font.GothamBold
targetLabel.TextSize = 10
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = leftFrame

-- Player List
local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1, 0, 0, 100)
playerScroll.Position = UDim2.new(0, 0, 0, 76)
playerScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerScroll.ScrollBarThickness = 4
playerScroll.Parent = leftFrame

local playerScrollCorner = Instance.new("UICorner")
playerScrollCorner.CornerRadius = UDim.new(0, 6)
playerScrollCorner.Parent = playerScroll

local playerLayout = Instance.new("UIListLayout")
playerLayout.Padding = UDim.new(0, 2)
playerLayout.Parent = playerScroll

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 35)
statusLabel.Position = UDim2.new(0, 0, 0, 180)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = COLORS.textMuted
statusLabel.Text = "No target selected"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextWrapped = true
statusLabel.Parent = leftFrame

-- ========== RIGHT FRAME ==========

local rightFrame = Instance.new("Frame")
rightFrame.Size = UDim2.new(0.5, -15, 1, -50)
rightFrame.Position = UDim2.new(0.5, 5, 0, 40)
rightFrame.BackgroundTransparency = 1
rightFrame.Parent = mainFrame

-- Mode Label
local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, 0, 0, 16)
modeLabel.Position = UDim2.new(0, 0, 0, 0)
modeLabel.BackgroundTransparency = 1
modeLabel.TextColor3 = COLORS.textDark
modeLabel.Text = "Fling Mode:"
modeLabel.Font = Enum.Font.GothamBold
modeLabel.TextSize = 10
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = rightFrame

-- Mode Buttons
local rapidModeBtn = Instance.new("TextButton")
rapidModeBtn.Size = UDim2.new(1, 0, 0, 24)
rapidModeBtn.Position = UDim2.new(0, 0, 0, 18)
rapidModeBtn.BackgroundColor3 = COLORS.buttonSuccess
rapidModeBtn.TextColor3 = COLORS.textLight
rapidModeBtn.Text = "✓ Rapid Teleport"
rapidModeBtn.Font = Enum.Font.Gotham
rapidModeBtn.TextSize = 10
rapidModeBtn.Parent = rightFrame

local rapidCorner = Instance.new("UICorner")
rapidCorner.CornerRadius = UDim.new(0, 5)
rapidCorner.Parent = rapidModeBtn

local velocityModeBtn = Instance.new("TextButton")
velocityModeBtn.Size = UDim2.new(1, 0, 0, 24)
velocityModeBtn.Position = UDim2.new(0, 0, 0, 45)
velocityModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
velocityModeBtn.TextColor3 = COLORS.textDark
velocityModeBtn.Text = "Velocity Burst"
velocityModeBtn.Font = Enum.Font.Gotham
velocityModeBtn.TextSize = 10
velocityModeBtn.Parent = rightFrame

local velocityCorner = Instance.new("UICorner")
velocityCorner.CornerRadius = UDim.new(0, 5)
velocityCorner.Parent = velocityModeBtn

local hybridModeBtn = Instance.new("TextButton")
hybridModeBtn.Size = UDim2.new(1, 0, 0, 24)
hybridModeBtn.Position = UDim2.new(0, 0, 0, 72)
hybridModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
hybridModeBtn.TextColor3 = COLORS.textDark
hybridModeBtn.Text = "Hybrid (Best)"
hybridModeBtn.Font = Enum.Font.Gotham
hybridModeBtn.TextSize = 10
hybridModeBtn.Parent = rightFrame

local hybridCorner = Instance.new("UICorner")
hybridCorner.CornerRadius = UDim.new(0, 5)
hybridCorner.Parent = hybridModeBtn

-- Teleport Speed
local teleportRow = Instance.new("Frame")
teleportRow.Size = UDim2.new(1, 0, 0, 22)
teleportRow.Position = UDim2.new(0, 0, 0, 102)
teleportRow.BackgroundTransparency = 1
teleportRow.Parent = rightFrame

local teleportLabel = Instance.new("TextLabel")
teleportLabel.Size = UDim2.new(0, 100, 1, 0)
teleportLabel.BackgroundTransparency = 1
teleportLabel.TextColor3 = COLORS.textDark
teleportLabel.Text = "Teleport Speed:"
teleportLabel.Font = Enum.Font.Gotham
teleportLabel.TextSize = 10
teleportLabel.TextXAlignment = Enum.TextXAlignment.Left
teleportLabel.Parent = teleportRow

local teleportInput = Instance.new("TextBox")
teleportInput.Size = UDim2.new(0, 80, 1, 0)
teleportInput.Position = UDim2.new(0, 105, 0, 0)
teleportInput.BackgroundColor3 = COLORS.inputBg
teleportInput.TextColor3 = COLORS.textDark
teleportInput.Text = "1000"
teleportInput.Font = Enum.Font.Gotham
teleportInput.TextSize = 10
teleportInput.ClearTextOnFocus = false
teleportInput.Parent = teleportRow

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 5)
teleportCorner.Parent = teleportInput

local teleportStroke = Instance.new("UIStroke")
teleportStroke.Color = COLORS.border
teleportStroke.Thickness = 1
teleportStroke.Parent = teleportInput

-- Velocity Power
local velocityRow = Instance.new("Frame")
velocityRow.Size = UDim2.new(1, 0, 0, 22)
velocityRow.Position = UDim2.new(0, 0, 0, 128)
velocityRow.BackgroundTransparency = 1
velocityRow.Parent = rightFrame

local velocityLabel = Instance.new("TextLabel")
velocityLabel.Size = UDim2.new(0, 100, 1, 0)
velocityLabel.BackgroundTransparency = 1
velocityLabel.TextColor3 = COLORS.textDark
velocityLabel.Text = "Velocity Power:"
velocityLabel.Font = Enum.Font.Gotham
velocityLabel.TextSize = 10
velocityLabel.TextXAlignment = Enum.TextXAlignment.Left
velocityLabel.Parent = velocityRow

local velocityInput = Instance.new("TextBox")
velocityInput.Size = UDim2.new(0, 80, 1, 0)
velocityInput.Position = UDim2.new(0, 105, 0, 0)
velocityInput.BackgroundColor3 = COLORS.inputBg
velocityInput.TextColor3 = COLORS.textDark
velocityInput.Text = "50000"
velocityInput.Font = Enum.Font.Gotham
velocityInput.TextSize = 10
velocityInput.ClearTextOnFocus = false
velocityInput.Parent = velocityRow

local velocityCorner = Instance.new("UICorner")
velocityCorner.CornerRadius = UDim.new(0, 5)
velocityCorner.Parent = velocityInput

local velocityStroke = Instance.new("UIStroke")
velocityStroke.Color = COLORS.border
velocityStroke.Thickness = 1
velocityStroke.Parent = velocityInput

-- Info
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 90)
infoLabel.Position = UDim2.new(0, 0, 0, 155)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = COLORS.textMuted
infoLabel.Text = "RAPID: Fast teleports\nVELOCITY: High velocity burst\nHYBRID: Both combined\n\nNo visible spin - uses collision"
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

-- ========== MODE BUTTONS ==========

rapidModeBtn.MouseButton1Click:Connect(function()
    collisionMode = "rapid"
    rapidModeBtn.Text = "✓ Rapid Teleport"
    rapidModeBtn.BackgroundColor3 = COLORS.buttonSuccess
    rapidModeBtn.TextColor3 = COLORS.textLight
    velocityModeBtn.Text = "Velocity Burst"
    velocityModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    velocityModeBtn.TextColor3 = COLORS.textDark
    hybridModeBtn.Text = "Hybrid (Best)"
    hybridModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    hybridModeBtn.TextColor3 = COLORS.textDark
end)

velocityModeBtn.MouseButton1Click:Connect(function()
    collisionMode = "velocity"
    velocityModeBtn.Text = "✓ Velocity Burst"
    velocityModeBtn.BackgroundColor3 = COLORS.buttonSuccess
    velocityModeBtn.TextColor3 = COLORS.textLight
    rapidModeBtn.Text = "Rapid Teleport"
    rapidModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    rapidModeBtn.TextColor3 = COLORS.textDark
    hybridModeBtn.Text = "Hybrid (Best)"
    hybridModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    hybridModeBtn.TextColor3 = COLORS.textDark
end)

hybridModeBtn.MouseButton1Click:Connect(function()
    collisionMode = "hybrid"
    hybridModeBtn.Text = "✓ Hybrid (Best)"
    hybridModeBtn.BackgroundColor3 = COLORS.buttonSuccess
    hybridModeBtn.TextColor3 = COLORS.textLight
    rapidModeBtn.Text = "Rapid Teleport"
    rapidModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    rapidModeBtn.TextColor3 = COLORS.textDark
    velocityModeBtn.Text = "Velocity Burst"
    velocityModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    velocityModeBtn.TextColor3 = COLORS.textDark
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
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                targetPlayer = plr
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

-- ========== FLING FUNCTIONS ==========

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local bodyVel = nil
local bodyAngVel = nil

local function stopFling()
    if flingLoop then
        flingLoop:Disconnect()
        flingLoop = nil
    end
    
    -- Remove body movers
    if bodyVel then
        bodyVel:Destroy()
        bodyVel = nil
    end
    
    if bodyAngVel then
        bodyAngVel:Destroy()
        bodyAngVel = nil
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

local function rapidTeleportFling()
    local myChar = player.Character
    if not myChar then return end
    
    local myRoot = getRoot(myChar)
    if not myRoot then return end
    
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetRoot = getRoot(targetPlayer.Character)
    if not targetRoot then return end
    
    teleportSpeed = tonumber(teleportInput.Text) or 1000
    
    -- Rapid teleportation creates collision
    for i = 1, 3 do
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
        wait(0.01)
    end
end

local function velocityBurstFling()
    local myChar = player.Character
    if not myChar then return end
    
    local myRoot = getRoot(myChar)
    local myHumanoid = myChar:FindFirstChild("Humanoid")
    if not myRoot then return end
    
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetRoot = getRoot(targetPlayer.Character)
    if not targetRoot then return end
    
    velocityPower = tonumber(velocityInput.Text) or 50000
    
    -- Teleport to target
    myRoot.CFrame = targetRoot.CFrame
    
    -- Create massive velocity burst
    if bodyVel then bodyVel:Destroy() end
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Name = "CollisionBurst"
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Velocity = Vector3.new(math.random(-1, 1) * velocityPower, velocityPower, math.random(-1, 1) * velocityPower)
    bodyVel.P = math.huge
    bodyVel.Parent = myRoot
    
    -- Small angular velocity for collision spread
    if bodyAngVel then bodyAngVel:Destroy() end
    bodyAngVel = Instance.new("BodyAngularVelocity")
    bodyAngVel.Name = "CollisionSpin"
    bodyAngVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyAngVel.AngularVelocity = Vector3.new(10000, 10000, 10000)
    bodyAngVel.P = math.huge
    bodyAngVel.Parent = myRoot
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
    
    wait(0.05)
    
    -- Remove after burst
    if bodyVel then bodyVel:Destroy() end
    if bodyAngVel then bodyAngVel:Destroy() end
end

local function hybridFling()
    local myChar = player.Character
    if not myChar then return end
    
    local myRoot = getRoot(myChar)
    local myHumanoid = myChar:FindFirstChild("Humanoid")
    if not myRoot then return end
    
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetRoot = getRoot(targetPlayer.Character)
    if not targetRoot then return end
    
    teleportSpeed = tonumber(teleportInput.Text) or 1000
    velocityPower = tonumber(velocityInput.Text) or 50000
    
    -- Teleport to target
    myRoot.CFrame = targetRoot.CFrame
    
    -- Create velocity burst
    if bodyVel then bodyVel:Destroy() end
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Name = "CollisionBurst"
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Velocity = Vector3.new(math.random(-1, 1) * velocityPower, velocityPower / 2, math.random(-1, 1) * velocityPower)
    bodyVel.P = math.huge
    bodyVel.Parent = myRoot
    
    -- Angular for collision spread
    if bodyAngVel then bodyAngVel:Destroy() end
    bodyAngVel = Instance.new("BodyAngularVelocity")
    bodyAngVel.Name = "CollisionSpin"
    bodyAngVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyAngVel.AngularVelocity = Vector3.new(50000, 50000, 50000)
    bodyAngVel.P = math.huge
    bodyAngVel.Parent = myRoot
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
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
    
    flingLoop = RunService.Heartbeat:Connect(function()
        if not flingEnabled then return end
        
        if not targetPlayer or not targetPlayer.Character then
            return
        end
        
        local targetRoot = getRoot(targetPlayer.Character)
        if not targetRoot then return end
        
        if collisionMode == "rapid" then
            rapidTeleportFling()
        elseif collisionMode == "velocity" then
            velocityBurstFling()
        else -- hybrid
            hybridFling()
        end
    end)
end

-- ========== FLING TOGGLE ==========

toggleButton.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    
    if flingEnabled then
        toggleButton.Text = "FLING: ON"
        toggleButton.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel.Text = targetPlayer and ("Flinging: " .. targetPlayer.Name .. " (" .. collisionMode .. ")") or "No target selected"
        
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

print("✅ Collision Fling Loaded")
print("   3 Modes: Rapid, Velocity, Hybrid")
print("   No visible spin - pure collision physics")
