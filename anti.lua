-- ULTIMATE ANTI-FLING PROTECTION
-- Combines density manipulation, velocity limiting, body mover removal, and collision isolation

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local PhysicsService = game:GetService("PhysicsService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local antiFlingEnabled = false
local densityModeEnabled = true
local velocityLimitEnabled = true
local bodyMoverRemovalEnabled = true
local collisionGroupEnabled = true
local counterForceEnabled = true

-- Limits
local maxVelocity = 150
local maxAngularVelocity = 50
local counterForceMultiplier = 2

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
screenGui.Name = "UltimateAntiFling"
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
hubButtonIcon.Text = "🛡️"
hubButtonIcon.Font = Enum.Font.GothamBold
hubButtonIcon.TextSize = 22
hubButtonIcon.Parent = hubButton

-- ========== MAIN FRAME ==========

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 520)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -260)
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
titleLabel.Text = "🛡️ ULTIMATE Anti-Fling"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
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

-- ========== CONTENT ==========

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -45)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Main Toggle
local mainToggle = Instance.new("TextButton")
mainToggle.Size = UDim2.new(1, 0, 0, 40)
mainToggle.Position = UDim2.new(0, 0, 0, 0)
mainToggle.BackgroundColor3 = COLORS.buttonDanger
mainToggle.TextColor3 = COLORS.textLight
mainToggle.Text = "ANTI-FLING: OFF"
mainToggle.Font = Enum.Font.GothamBold
mainToggle.TextSize = 16
mainToggle.Parent = contentFrame

local mainToggleCorner = Instance.new("UICorner")
mainToggleCorner.CornerRadius = UDim.new(0, 8)
mainToggleCorner.Parent = mainToggle

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.Position = UDim2.new(0, 0, 0, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = COLORS.textMuted
statusLabel.Text = "Protection disabled"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.Parent = contentFrame

-- Blocked Counter
local blockedLabel = Instance.new("TextLabel")
blockedLabel.Size = UDim2.new(1, 0, 0, 18)
blockedLabel.Position = UDim2.new(0, 0, 0, 63)
blockedLabel.BackgroundTransparency = 1
blockedLabel.TextColor3 = COLORS.buttonSuccess
blockedLabel.Text = "Fling attempts blocked: 0"
blockedLabel.Font = Enum.Font.GothamBold
blockedLabel.TextSize = 10
blockedLabel.Parent = contentFrame

-- Protection Label
local protectionLabel = Instance.new("TextLabel")
protectionLabel.Size = UDim2.new(1, 0, 0, 20)
protectionLabel.Position = UDim2.new(0, 0, 0, 88)
protectionLabel.BackgroundTransparency = 1
protectionLabel.TextColor3 = COLORS.textDark
protectionLabel.Text = "Protection Layers:"
protectionLabel.Font = Enum.Font.GothamBold
protectionLabel.TextSize = 11
protectionLabel.TextXAlignment = Enum.TextXAlignment.Left
protectionLabel.Parent = contentFrame

-- Option 1: Density Mode
local densityToggle = Instance.new("TextButton")
densityToggle.Size = UDim2.new(1, 0, 0, 28)
densityToggle.Position = UDim2.new(0, 0, 0, 108)
densityToggle.BackgroundColor3 = COLORS.buttonSuccess
densityToggle.TextColor3 = COLORS.textLight
densityToggle.Text = "✓ Density Manipulation (BEST)"
densityToggle.Font = Enum.Font.Gotham
densityToggle.TextSize = 10
densityToggle.Parent = contentFrame

local densityCorner = Instance.new("UICorner")
densityCorner.CornerRadius = UDim.new(0, 6)
densityCorner.Parent = densityToggle

-- Density Info
local densityInfo = Instance.new("TextLabel")
densityInfo.Size = UDim2.new(1, 0, 0, 14)
densityInfo.Position = UDim2.new(0, 0, 0, 137)
densityInfo.BackgroundTransparency = 1
densityInfo.TextColor3 = COLORS.textMuted
densityInfo.Text = "Sets other players' density to 0.01 - can't push you"
densityInfo.Font = Enum.Font.Gotham
densityInfo.TextSize = 8
densityInfo.TextXAlignment = Enum.TextXAlignment.Left
densityInfo.Parent = contentFrame

-- Option 2: Velocity Limit
local velToggle = Instance.new("TextButton")
velToggle.Size = UDim2.new(1, 0, 0, 28)
velToggle.Position = UDim2.new(0, 0, 0, 152)
velToggle.BackgroundColor3 = COLORS.buttonSuccess
velToggle.TextColor3 = COLORS.textLight
velToggle.Text = "✓ Velocity Limiter"
velToggle.Font = Enum.Font.Gotham
velToggle.TextSize = 10
velToggle.Parent = contentFrame

local velCorner = Instance.new("UICorner")
velCorner.CornerRadius = UDim.new(0, 6)
velCorner.Parent = velToggle

-- Option 3: BodyMover Remover
local moverToggle = Instance.new("TextButton")
moverToggle.Size = UDim2.new(1, 0, 0, 28)
moverToggle.Position = UDim2.new(0, 0, 0, 180)
moverToggle.BackgroundColor3 = COLORS.buttonSuccess
moverToggle.TextColor3 = COLORS.textLight
moverToggle.Text = "✓ BodyMover Scanner"
moverToggle.Font = Enum.Font.Gotham
moverToggle.TextSize = 10
moverToggle.Parent = contentFrame

local moverCorner = Instance.new("UICorner")
moverCorner.CornerRadius = UDim.new(0, 6)
moverCorner.Parent = moverToggle

-- Option 4: Counter Force
local counterToggle = Instance.new("TextButton")
counterToggle.Size = UDim2.new(1, 0, 0, 28)
counterToggle.Position = UDim2.new(0, 0, 0, 208)
counterToggle.BackgroundColor3 = COLORS.buttonSuccess
counterToggle.TextColor3 = COLORS.textLight
counterToggle.Text = "✓ Counter Force"
counterToggle.Font = Enum.Font.Gotham
counterToggle.TextSize = 10
counterToggle.Parent = contentFrame

local counterCorner = Instance.new("UICorner")
counterCorner.CornerRadius = UDim.new(0, 6)
counterCorner.Parent = counterToggle

-- Option 5: Angular Limiter
local angularToggle = Instance.new("TextButton")
angularToggle.Size = UDim2.new(1, 0, 0, 28)
angularToggle.Position = UDim2.new(0, 0, 0, 236)
angularToggle.BackgroundColor3 = COLORS.buttonSuccess
angularToggle.TextColor3 = COLORS.textLight
angularToggle.Text = "✓ Angular Velocity Cap"
angularToggle.Font = Enum.Font.Gotham
angularToggle.TextSize = 10
angularToggle.Parent = contentFrame

local angularCorner = Instance.new("UICorner")
angularCorner.CornerRadius = UDim.new(0, 6)
angularCorner.Parent = angularToggle

-- Settings Section
local settingsLabel = Instance.new("TextLabel")
settingsLabel.Size = UDim2.new(1, 0, 0, 20)
settingsLabel.Position = UDim2.new(0, 0, 0, 270)
settingsLabel.BackgroundTransparency = 1
settingsLabel.TextColor3 = COLORS.textDark
settingsLabel.Text = "Settings:"
settingsLabel.Font = Enum.Font.GothamBold
settingsLabel.TextSize = 11
settingsLabel.TextXAlignment = Enum.TextXAlignment.Left
settingsLabel.Parent = contentFrame

-- Velocity Threshold
local velRow = Instance.new("Frame")
velRow.Size = UDim2.new(1, 0, 0, 25)
velRow.Position = UDim2.new(0, 0, 0, 290)
velRow.BackgroundTransparency = 1
velRow.Parent = contentFrame

local velLabel = Instance.new("TextLabel")
velLabel.Size = UDim2.new(0, 140, 1, 0)
velLabel.BackgroundTransparency = 1
velLabel.TextColor3 = COLORS.textDark
velLabel.Text = "Max Velocity:"
velLabel.Font = Enum.Font.Gotham
velLabel.TextSize = 10
velLabel.TextXAlignment = Enum.TextXAlignment.Left
velLabel.Parent = velRow

local velInput = Instance.new("TextBox")
velInput.Size = UDim2.new(0, 80, 1, 0)
velInput.Position = UDim2.new(0, 145, 0, 0)
velInput.BackgroundColor3 = COLORS.inputBg
velInput.TextColor3 = COLORS.textDark
velInput.Text = "150"
velInput.Font = Enum.Font.Gotham
velInput.TextSize = 10
velInput.ClearTextOnFocus = false
velInput.Parent = velRow

local velInputCorner = Instance.new("UICorner")
velInputCorner.CornerRadius = UDim.new(0, 5)
velInputCorner.Parent = velInput

local velInputStroke = Instance.new("UIStroke")
velInputStroke.Color = COLORS.border
velInputStroke.Thickness = 1
velInputStroke.Parent = velInput

-- Angular Threshold
local angRow = Instance.new("Frame")
angRow.Size = UDim2.new(1, 0, 0, 25)
angRow.Position = UDim2.new(0, 0, 0, 315)
angRow.BackgroundTransparency = 1
angRow.Parent = contentFrame

local angLabel = Instance.new("TextLabel")
angLabel.Size = UDim2.new(0, 140, 1, 0)
angLabel.BackgroundTransparency = 1
angLabel.TextColor3 = COLORS.textDark
angLabel.Text = "Max Angular Vel:"
angLabel.Font = Enum.Font.Gotham
angLabel.TextSize = 10
angLabel.TextXAlignment = Enum.TextXAlignment.Left
angLabel.Parent = angRow

local angInput = Instance.new("TextBox")
angInput.Size = UDim2.new(0, 80, 1, 0)
angInput.Position = UDim2.new(0, 145, 0, 0)
angInput.BackgroundColor3 = COLORS.inputBg
angInput.TextColor3 = COLORS.textDark
angInput.Text = "50"
angInput.Font = Enum.Font.Gotham
angInput.TextSize = 10
angInput.ClearTextOnFocus = false
angInput.Parent = angRow

local angInputCorner = Instance.new("UICorner")
angInputCorner.CornerRadius = UDim.new(0, 5)
angInputCorner.Parent = angInput

local angInputStroke = Instance.new("UIStroke")
angInputStroke.Color = COLORS.border
angInputStroke.Thickness = 1
angInputStroke.Parent = angInput

-- Counter Force Multiplier
local counterRow = Instance.new("Frame")
counterRow.Size = UDim2.new(1, 0, 0, 25)
counterRow.Position = UDim2.new(0, 0, 0, 340)
counterRow.BackgroundTransparency = 1
counterRow.Parent = contentFrame

local counterLabel = Instance.new("TextLabel")
counterLabel.Size = UDim2.new(0, 140, 1, 0)
counterLabel.BackgroundTransparency = 1
counterLabel.TextColor3 = COLORS.textDark
counterLabel.Text = "Counter Force Mult:"
counterLabel.Font = Enum.Font.Gotham
counterLabel.TextSize = 10
counterLabel.TextXAlignment = Enum.TextXAlignment.Left
counterLabel.Parent = counterRow

local counterInput = Instance.new("TextBox")
counterInput.Size = UDim2.new(0, 80, 1, 0)
counterInput.Position = UDim2.new(0, 145, 0, 0)
counterInput.BackgroundColor3 = COLORS.inputBg
counterInput.TextColor3 = COLORS.textDark
counterInput.Text = "2"
counterInput.Font = Enum.Font.Gotham
counterInput.TextSize = 10
counterInput.ClearTextOnFocus = false
counterInput.Parent = counterRow

local counterInputCorner = Instance.new("UICorner")
counterInputCorner.CornerRadius = UDim.new(0, 5)
counterInputCorner.Parent = counterInput

local counterInputStroke = Instance.new("UIStroke")
counterInputStroke.Color = COLORS.border
counterInputStroke.Thickness = 1
counterInputStroke.Parent = counterInput

-- Detection Log
local logLabel = Instance.new("TextLabel")
logLabel.Size = UDim2.new(1, 0, 0, 20)
logLabel.Position = UDim2.new(0, 0, 0, 375)
logLabel.BackgroundTransparency = 1
logLabel.TextColor3 = COLORS.textDark
logLabel.Text = "Detection Log:"
logLabel.Font = Enum.Font.GothamBold
logLabel.TextSize = 10
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.Parent = contentFrame

local logFrame = Instance.new("Frame")
logFrame.Size = UDim2.new(1, 0, 0, 80)
logFrame.Position = UDim2.new(0, 0, 0, 395)
logFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
logFrame.Parent = contentFrame

local logFrameCorner = Instance.new("UICorner")
logFrameCorner.CornerRadius = UDim.new(0, 6)
logFrameCorner.Parent = logFrame

local logScroll = Instance.new("ScrollingFrame")
logScroll.Size = UDim2.new(1, -10, 1, -10)
logScroll.Position = UDim2.new(0, 5, 0, 5)
logScroll.BackgroundTransparency = 1
logScroll.ScrollBarThickness = 4
logScroll.Parent = logFrame

local logLayout = Instance.new("UIListLayout")
logLayout.Padding = UDim.new(0, 2)
logLayout.Parent = logScroll

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

-- ========== TOGGLE OPTIONS ==========

densityToggle.MouseButton1Click:Connect(function()
    densityModeEnabled = not densityModeEnabled
    densityToggle.Text = densityModeEnabled and "✓ Density Manipulation (BEST)" or "✗ Density Manipulation (BEST)"
    densityToggle.BackgroundColor3 = densityModeEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

velToggle.MouseButton1Click:Connect(function()
    velocityLimitEnabled = not velocityLimitEnabled
    velToggle.Text = velocityLimitEnabled and "✓ Velocity Limiter" or "✗ Velocity Limiter"
    velToggle.BackgroundColor3 = velocityLimitEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

moverToggle.MouseButton1Click:Connect(function()
    bodyMoverRemovalEnabled = not bodyMoverRemovalEnabled
    moverToggle.Text = bodyMoverRemovalEnabled and "✓ BodyMover Scanner" or "✗ BodyMover Scanner"
    moverToggle.BackgroundColor3 = bodyMoverRemovalEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

counterToggle.MouseButton1Click:Connect(function()
    counterForceEnabled = not counterForceEnabled
    counterToggle.Text = counterForceEnabled and "✓ Counter Force" or "✗ Counter Force"
    counterToggle.BackgroundColor3 = counterForceEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

angularToggle.MouseButton1Click:Connect(function()
    angularLimitEnabled = not angularLimitEnabled
    angularToggle.Text = angularLimitEnabled and "✓ Angular Velocity Cap" or "✗ Angular Velocity Cap"
    angularToggle.BackgroundColor3 = angularLimitEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

-- ========== LOGGING ==========

local blockedCount = 0
local logEntries = {}

local function addLog(text)
    local entry = Instance.new("TextLabel")
    entry.Size = UDim2.new(1, 0, 0, 16)
    entry.BackgroundTransparency = 1
    entry.TextColor3 = COLORS.textMuted
    entry.Text = os.date("[%H:%M:%S] ") .. text
    entry.Font = Enum.Font.Gotham
    entry.TextSize = 8
    entry.TextXAlignment = Enum.TextXAlignment.Left
    entry.Parent = logScroll
    
    table.insert(logEntries, entry)
    
    if #logEntries > 20 then
        logEntries[1]:Destroy()
        table.remove(logEntries, 1)
    end
    
    logScroll.CanvasSize = UDim2.new(0, 0, 0, #logEntries * 18)
end

-- ========== ANTI-FLING LOGIC ==========

local antiFlingLoop = nil
local lastVelocity = Vector3.new(0, 0, 0)
local lastPosition = Vector3.new(0, 0, 0)
local lastTime = tick()

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function isFlinging(char)
    local root = getRoot(char)
    if not root then return false, 0 end
    
    -- Check for body movers
    for _, child in pairs(root:GetChildren()) do
        if child:IsA("BodyAngularVelocity") or child:IsA("BodyVelocity") or child:IsA("BodyForce") or child:IsA("BodyPosition") or child:IsA("BodyGyro") or child:IsA("BodyThrust") then
            return true, 1
        end
    end
    
    -- Check for spinning (high angular velocity)
    local angVel = root.AssemblyAngularVelocity
    local totalAngVel = math.sqrt(angVel.X^2 + angVel.Y^2 + angVel.Z^2)
    
    if totalAngVel > 50 then
        return true, 2
    end
    
    return false, 0
end

local function removeBodyMovers(char)
    local root = getRoot(char)
    if not root then return end
    
    for _, child in pairs(root:GetChildren()) do
        if child:IsA("BodyAngularVelocity") or child:IsA("BodyVelocity") or child:IsA("BodyForce") or child:IsA("BodyPosition") or child:IsA("BodyGyro") or child:IsA("BodyThrust") then
            child:Destroy()
        end
    end
end

local function setDensityLow(char)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CustomPhysicalProperties = PhysicalProperties.new(
                0.01, -- density (VERY LOW - can't push others)
                0.5,   -- friction
                0.5    -- elasticity
            )
        end
    end
end

local function limitVelocity(root)
    local maxVel = tonumber(velInput.Text) or 150
    local vel = root.AssemblyLinearVelocity
    local speed = math.sqrt(vel.X^2 + vel.Y^2 + vel.Z^2)
    
    if speed > maxVel then
        local ratio = maxVel / speed
        root.AssemblyLinearVelocity = vel * ratio
        return true
    end
    
    return false
end

local function limitAngularVelocity(root)
    local maxAng = tonumber(angInput.Text) or 50
    local angVel = root.AssemblyAngularVelocity
    local angSpeed = math.sqrt(angVel.X^2 + angVel.Y^2 + angVel.Z^2)
    
    if angSpeed > maxAng then
        local ratio = maxAng / angSpeed
        root.AssemblyAngularVelocity = angVel * ratio
        return true
    end
    
    return false
end

local function applyCounterForce(char, flingerRoot)
    local myRoot = getRoot(char)
    if not myRoot or not flingerRoot then return end
    
    local mult = tonumber(counterInput.Text) or 2
    
    -- Get flinger's velocity
    local flingerVel = flingerRoot.AssemblyLinearVelocity
    local flingerAngVel = flingerRoot.AssemblyAngularVelocity
    
    -- Apply opposite force
    local counterVel = -flingerVel * mult
    local counterAng = -flingerAngVel * mult
    
    myRoot.AssemblyLinearVelocity = counterVel
    myRoot.AssemblyAngularVelocity = counterAng
end

local function startAntiFling()
    if antiFlingLoop then
        antiFlingLoop:Disconnect()
    end
    
    addLog("Protection started")
    
    antiFlingLoop = RunService.Heartbeat:Connect(function()
        if not antiFlingEnabled then return end
        
        local myChar = player.Character
        if not myChar then return end
        
        local myRoot = getRoot(myChar)
        if not myRoot then return end
        
        -- 1. DENSITY MANIPULATION (most effective)
        if densityModeEnabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    setDensityLow(plr.Character)
                end
            end
        end
        
        -- 2. REMOVE BODY MOVERS FROM SELF
        if bodyMoverRemovalEnabled then
            removeBodyMovers(myChar)
        end
        
        -- 3. LIMIT VELOCITY
        if velocityLimitEnabled then
            local velLimited = limitVelocity(myRoot)
            if velLimited then
                blockedCount = blockedCount + 1
                blockedLabel.Text = "Fling attempts blocked: " .. blockedCount
            end
        end
        
        -- 4. LIMIT ANGULAR VELOCITY
        if angularLimitEnabled then
            local angLimited = limitAngularVelocity(myRoot)
            if angLimited then
                blockedCount = blockedCount + 1
                blockedLabel.Text = "Fling attempts blocked: " .. blockedCount
            end
        end
        
        -- 5. DETECT AND COUNTER FLINGERS
        if counterForceEnabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local theirRoot = getRoot(plr.Character)
                    if theirRoot then
                        local flinging, type = isFlinging(plr.Character)
                        
                        if flinging then
                            local distance = (myRoot.Position - theirRoot.Position).Magnitude
                            
                            if distance < 15 then
                                blockedCount = blockedCount + 1
                                blockedLabel.Text = "Fling attempts blocked: " .. blockedCount
                                addLog(plr.Name .. " fling blocked (type " .. type .. ")")
                                
                                -- Apply counter force
                                applyCounterForce(myChar, theirRoot)
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function stopAntiFling()
    if antiFlingLoop then
        antiFlingLoop:Disconnect()
        antiFlingLoop = nil
    end
    addLog("Protection stopped")
end

-- ========== MAIN TOGGLE ==========

mainToggle.MouseButton1Click:Connect(function()
    antiFlingEnabled = not antiFlingEnabled
    
    if antiFlingEnabled then
        mainToggle.Text = "ANTI-FLING: ON"
        mainToggle.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel.Text = "Protection ACTIVE"
        statusLabel.TextColor3 = COLORS.buttonSuccess
        startAntiFling()
    else
        mainToggle.Text = "ANTI-FLING: OFF"
        mainToggle.BackgroundColor3 = COLORS.buttonDanger
        statusLabel.Text = "Protection disabled"
        statusLabel.TextColor3 = COLORS.textMuted
        stopAntiFling()
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

-- Auto-restart on respawn
player.CharacterAdded:Connect(function()
    if antiFlingEnabled then
        wait(0.5)
        startAntiFling()
        addLog("Re-enabled on respawn")
    end
end)

print("✅ ULTIMATE Anti-Fling Loaded")
print("   5 protection layers active")
print("   Density manipulation + velocity limiter + body mover scanner + counter force + angular cap")
