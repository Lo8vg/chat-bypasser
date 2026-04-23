-- Combat Movement Helper (Fixed with Full GUI)

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Settings
local settings = {
    autoWalk = false,
    autoJump = true,
    autoSwing = true,
    autoEquipSword = true,
    randomDirection = true,
    jumpDelay = 1.5,
    swingDelay = 0.3,
    swingsPerJump = 2,
    directionInterval = 5
}

-- Variables
local running = false
local currentDirection = Vector3.new(0, 0, -1)
local lastDirectionChange = 0
local lastJumpTime = 0
local isJumping = false

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombatMovementGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Toggle Button (small, always visible)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 130, 0, 28)
toggleBtn.Position = UDim2.new(0.5, -65, 0.9, -35)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "Movement: OFF"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

-- Settings Button (gear icon next to toggle)
local settingsBtn = Instance.new("TextButton")
settingsBtn.Size = UDim2.new(0, 28, 0, 28)
settingsBtn.Position = UDim2.new(0.5, 70, 0.9, -35)
settingsBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
settingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsBtn.Text = "⚙"
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextSize = 16
settingsBtn.Parent = screenGui

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 6)
settingsCorner.Parent = settingsBtn

-- Main Settings Frame (hidden by default)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 340)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -170)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 15)
titleFix.Position = UDim2.new(0, 0, 1, -15)
titleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "Combat Movement"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Scrollable Content
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -40)
scrollFrame.Position = UDim2.new(0, 10, 0, 35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 6)
contentLayout.Parent = scrollFrame

-- Helper: Create Toggle
local function createToggle(name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 26)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.Parent = scrollFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.55, 0, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.4, 0, 0, 20)
    btn.Position = UDim2.new(0.57, 0, 0.5, -10)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(80, 80, 80)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = default and "ON" or "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        local state = btn.Text == "OFF"
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(80, 80, 80)
        callback(state)
    end)
    
    return btn
end

-- Helper: Create Slider
local function createSlider(name, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.Parent = scrollFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 16)
    label.Position = UDim2.new(0, 8, 0, 4)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = name .. ": " .. defaultVal
    label.Font = Enum.Font.Gotham
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -16, 0, 10)
    sliderBg.Position = UDim2.new(0, 8, 0, 24)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBg.Parent = frame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 4)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    sliderFill.Parent = sliderBg
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 4)
    sliderFillCorner.Parent = sliderFill
    
    -- Make it clickable
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouseX = input.Position.X
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderSize = sliderBg.AbsoluteSize.X
            local percent = math.clamp((mouseX - sliderPos) / sliderSize, 0, 1)
            local value = minVal + (maxVal - minVal) * percent
            value = math.round(value * 10) / 10
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = name .. ": " .. value
            callback(value)
        end
    end)
    
    -- Dragging
    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderSize = sliderBg.AbsoluteSize.X
            local percent = math.clamp((mouseX - sliderPos) / sliderSize, 0, 1)
            local value = minVal + (maxVal - minVal) * percent
            value = math.round(value * 10) / 10
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = name .. ": " .. value
            callback(value)
        end
    end)
end

-- Create all toggles and sliders
createToggle("Auto Walk", false, function(v) settings.autoWalk = v end)
createToggle("Auto Jump", true, function(v) settings.autoJump = v end)
createToggle("Auto Swing", true, function(v) settings.autoSwing = v end)
createToggle("Auto Equip Sword", true, function(v) settings.autoEquipSword = v end)
createToggle("Random Direction", true, function(v) settings.randomDirection = v end)

createSlider("Jump Delay", 0.5, 5, settings.jumpDelay, function(v) settings.jumpDelay = v end)
createSlider("Swing Delay", 0.1, 1, settings.swingDelay, function(v) settings.swingDelay = v end)
createSlider("Swings Per Jump", 1, 5, settings.swingsPerJump, function(v) settings.swingsPerJump = math.floor(v) end)
createSlider("Direction Interval", 2, 15, settings.directionInterval, function(v) settings.directionInterval = v end)

-- Dragging for main frame
local dragging = false
local dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle visibility of settings
settingsBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Obstacle check (your original logic)
local function checkForObstacles(direction)
    local character = player.Character
    if not character then return false end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = workspace:Raycast(rootPart.Position, direction * 13, raycastParams)
    return result and result.Instance ~= nil
end

-- Calculate clear path (your original logic)
local function calculateClearPath(direction)
    if not checkForObstacles(direction) then
        return direction
    end
    
    local leftDir = (direction + Vector3.new(-1, 0, 0)).Unit
    local rightDir = (direction + Vector3.new(1, 0, 0)).Unit
    local backDir = -direction
    
    if not checkForObstacles(leftDir) then return leftDir end
    if not checkForObstacles(rightDir) then return rightDir end
    if not checkForObstacles(backDir) then return backDir end
    
    return Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
end

-- Get random direction
local function getRandomDirection()
    local angle = math.random() * math.pi * 2
    return Vector3.new(math.cos(angle), 0, math.sin(angle))
end

-- Find sword
local function findSword()
    local character = player.Character
    if not character then return nil end
    
    -- Check equipped
    local equipped = character:FindFirstChildOfClass("Tool")
    if equipped and equipped:FindFirstChild("Handle") then
        return equipped
    end
    
    -- Check backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") and item:FindFirstChild("Handle") then
                return item
            end
        end
    end
    
    return nil
end

-- Swing sword
local function swingSword()
    local sword = findSword()
    if sword and sword:FindFirstChild("Handle") then
        sword:Activate()
    end
end

-- Equip sword
local function equipSword()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local sword = findSword()
    if sword and sword.Parent ~= character then
        humanoid:EquipTool(sword)
    end
end

-- Main loop
local function mainLoop()
    lastDirectionChange = tick()
    lastJumpTime = tick()
    
    while running do
        local character = player.Character
        if not character then
            wait(0.1)
            continue
        end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not rootPart then
            wait(0.1)
            continue
        end
        
        local now = tick()
        
        -- Auto equip sword
        if settings.autoEquipSword then
            equipSword()
        end
        
        -- Random direction change
        if settings.randomDirection and (now - lastDirectionChange) >= settings.directionInterval then
            currentDirection = getRandomDirection()
            lastDirectionChange = now
        end
        
        -- Auto walk (your original movement)
        if settings.autoWalk then
            local clearPath = calculateClearPath(currentDirection)
            humanoid:MoveTo(rootPart.Position + clearPath * 16)
        end
        
        -- Auto jump and swing
        if settings.autoJump and (now - lastJumpTime) >= settings.jumpDelay and not isJumping then
            isJumping = true
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            lastJumpTime = now
            
            -- Swing sword during jump
            if settings.autoSwing then
                for i = 1, settings.swingsPerJump do
                    wait(settings.swingDelay)
                    swingSword()
                end
            end
            
            wait(0.3)
            isJumping = false
        end
        
        wait(0.05)
    end
end

-- Toggle button
toggleBtn.MouseButton1Click:Connect(function()
    running = not running
    
    if running then
        toggleBtn.Text = "Movement: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        spawn(mainLoop)
    else
        toggleBtn.Text = "Movement: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

-- Handle respawn
player.CharacterAdded:Connect(function()
    if running then
        lastDirectionChange = tick()
        lastJumpTime = tick()
    end
end)

print("✅ Combat Movement Helper Loaded")
print("📌 Click toggle to start/stop")
print("📌 Click ⚙ to open settings")
