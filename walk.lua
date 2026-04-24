-- COMBAT MOVEMENT HELPER (Mobile Friendly)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local autoWalkEnabled = false
local autoJumpEnabled = true
local autoSwingEnabled = true
local autoEquipSword = true
local randomDirection = true
local jumpDelay = 1.5
local swingDelay = 0.3
local swingsPerJump = 2
local directionInterval = 5
local equipDelay = 0.5

-- Variables
local running = false
local currentDirection = Vector3.new(0, 0, -1)
local lastDirectionChange = 0
local lastJumpTime = 0
local lastEquipTime = 0
local isJumping = false

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
    cardBg = Color3.fromRGB(255, 255, 255)
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombatMovementHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Hub Button
local hubButton = Instance.new("TextButton")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 55, 0, 55)
hubButton.Position = UDim2.new(0, 10, 0.5, -27)
hubButton.BackgroundColor3 = COLORS.cardBg
hubButton.BorderSizePixel = 0
hubButton.Text = "⚔"
hubButton.TextColor3 = COLORS.textDark
hubButton.Font = Enum.Font.GothamBold
hubButton.TextSize = 28
hubButton.Visible = true
hubButton.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 12)
hubCorner.Parent = hubButton

-- Main Frame (reduced height)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 310)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -155)
mainFrame.BackgroundColor3 = COLORS.background
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mfCorner = Instance.new("UICorner")
mfCorner.CornerRadius = UDim.new(0, 12)
mfCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = COLORS.header
titleBar.Parent = mainFrame

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 12)
tbCorner.Parent = titleBar

local tbFix = Instance.new("Frame")
tbFix.Size = UDim2.new(1, 0, 0, 14)
tbFix.Position = UDim2.new(0, 0, 1, -14)
tbFix.BackgroundColor3 = COLORS.header
tbFix.BorderSizePixel = 0
tbFix.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = COLORS.textDark
title.Text = "⚔ COMBAT MOVEMENT"
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 22)
closeBtn.Position = UDim2.new(1, -32, 0.5, -11)
closeBtn.BackgroundColor3 = COLORS.buttonDanger
closeBtn.TextColor3 = COLORS.textLight
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 11
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -16, 1, -42)
scrollFrame.Position = UDim2.new(0, 8, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 4)
contentLayout.Parent = scrollFrame

-- ========== MAIN TOGGLE ==========
local mainToggleFrame = Instance.new("Frame")
mainToggleFrame.Size = UDim2.new(1, 0, 0, 36)
mainToggleFrame.BackgroundColor3 = COLORS.cardBg
mainToggleFrame.Parent = scrollFrame
local mtfCorner = Instance.new("UICorner")
mtfCorner.CornerRadius = UDim.new(0, 6)
mtfCorner.Parent = mainToggleFrame

local mainToggle = Instance.new("TextButton")
mainToggle.Size = UDim2.new(1, -12, 0, 28)
mainToggle.Position = UDim2.new(0, 6, 0, 4)
mainToggle.BackgroundColor3 = COLORS.buttonDanger
mainToggle.TextColor3 = COLORS.textLight
mainToggle.Text = "MOVEMENT: OFF"
mainToggle.Font = Enum.Font.GothamBold
mainToggle.TextSize = 13
mainToggle.Parent = mainToggleFrame
local mtCorner = Instance.new("UICorner")
mtCorner.CornerRadius = UDim.new(0, 5)
mtCorner.Parent = mainToggle

-- Helper function to create toggle
local function createToggle(name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 26)
    frame.BackgroundColor3 = COLORS.cardBg
    frame.Parent = scrollFrame
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 5)
    fCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = COLORS.textDark
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 20)
    btn.Position = UDim2.new(1, -58, 0.5, -10)
    btn.BackgroundColor3 = default and COLORS.buttonSuccess or COLORS.buttonDanger
    btn.TextColor3 = COLORS.textLight
    btn.Text = default and "ON" or "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.Parent = frame
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 4)
    bCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        local state = btn.Text == "OFF"
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and COLORS.buttonSuccess or COLORS.buttonDanger
        callback(state)
    end)
    
    return btn
end

-- Helper function to create slider
local function createSlider(name, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.BackgroundColor3 = COLORS.cardBg
    frame.Parent = scrollFrame
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 5)
    fCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 0, 14)
    label.Position = UDim2.new(0, 10, 0, 4)
    label.BackgroundTransparency = 1
    label.TextColor3 = COLORS.textDark
    label.Text = name .. ": " .. defaultVal
    label.Font = Enum.Font.Gotham
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 10)
    sliderBg.Position = UDim2.new(0, 10, 0, 22)
    sliderBg.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    sliderBg.Parent = frame
    local sbCorner = Instance.new("UICorner")
    sbCorner.CornerRadius = UDim.new(0, 5)
    sbCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = COLORS.buttonPrimary
    sliderFill.Parent = sliderBg
    local sfCorner = Instance.new("UICorner")
    sfCorner.CornerRadius = UDim.new(0, 5)
    sfCorner.Parent = sliderFill
    
    local dragging = false
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local value = minVal + (maxVal - minVal) * pos
        value = math.round(value * 10) / 10
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = name .. ": " .. value
        callback(value)
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            updateSlider(input)
        end
    end)
end

-- Create all toggles
local autoWalkToggle = createToggle("Auto Walk", autoWalkEnabled, function(v) autoWalkEnabled = v end)
local autoJumpToggle = createToggle("Auto Jump", autoJumpEnabled, function(v) autoJumpEnabled = v end)
local autoSwingToggle = createToggle("Auto Swing", autoSwingEnabled, function(v) autoSwingEnabled = v end)
local autoEquipToggle = createToggle("Auto Equip Sword", autoEquipSword, function(v) autoEquipSword = v end)
local randomDirToggle = createToggle("Random Direction", randomDirection, function(v) randomDirection = v end)

-- Create all sliders
createSlider("Jump Delay (sec)", 0.5, 5, jumpDelay, function(v) jumpDelay = v end)
createSlider("Swing Delay (sec)", 0.1, 1, swingDelay, function(v) swingDelay = v end)
createSlider("Swings Per Jump", 1, 5, swingsPerJump, function(v) swingsPerJump = math.floor(v) end)
createSlider("Direction Interval", 2, 15, directionInterval, function(v) directionInterval = v end)
createSlider("Equip Delay (sec)", 0.1, 3, equipDelay, function(v) equipDelay = v end)

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

-- Open hub on click
hubButton.MouseButton1Click:Connect(function()
    wait(0.05)
    if not dragging then
        hubButton.Visible = false
        mainFrame.Visible = true
    end
end)

-- Drag main frame
local mfDragging = false
local mfDragInput, mfDragStart, mfDragPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mfDragging = true
        mfDragStart = input.Position
        mfDragPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                mfDragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        mfDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == mfDragInput and mfDragging then
        local delta = input.Position - mfDragStart
        mainFrame.Position = UDim2.new(mfDragPos.X.Scale, mfDragPos.X.Offset + delta.X, mfDragPos.Y.Scale, mfDragPos.Y.Offset + delta.Y)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

-- ========== MOVEMENT FUNCTIONS ==========

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

local function getRandomDirection()
    local angle = math.random() * math.pi * 2
    return Vector3.new(math.cos(angle), 0, math.sin(angle))
end

local function findSword()
    local character = player.Character
    if not character then return nil end
    
    local equipped = character:FindFirstChildOfClass("Tool")
    if equipped and equipped:FindFirstChild("Handle") then
        return equipped
    end
    
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

local function swingSword()
    local sword = findSword()
    if sword and sword:FindFirstChild("Handle") then
        sword:Activate()
    end
end

-- ========== MAIN LOOP ==========

local function mainLoop()
    lastDirectionChange = tick()
    lastJumpTime = tick()
    lastEquipTime = tick()
    
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
        
        -- Auto equip sword with delay
        if autoEquipSword and (now - lastEquipTime) >= equipDelay then
            equipSword()
            lastEquipTime = now
        end
        
        -- Random direction change
        if randomDirection and (now - lastDirectionChange) >= directionInterval then
            currentDirection = getRandomDirection()
            lastDirectionChange = now
        end
        
        -- Auto walk
        if autoWalkEnabled then
            local clearPath = calculateClearPath(currentDirection)
            humanoid:MoveTo(rootPart.Position + clearPath * 16)
        end
        
        -- Auto jump and swing
        if autoJumpEnabled and (now - lastJumpTime) >= jumpDelay and not isJumping then
            isJumping = true
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            lastJumpTime = now
            
            if autoSwingEnabled then
                for i = 1, swingsPerJump do
                    wait(swingDelay)
                    swingSword()
                end
            end
            
            wait(0.3)
            isJumping = false
        end
        
        wait(0.05)
    end
end

-- ========== MAIN TOGGLE ==========

mainToggle.MouseButton1Click:Connect(function()
    running = not running
    
    if running then
        mainToggle.Text = "MOVEMENT: ON"
        mainToggle.BackgroundColor3 = COLORS.buttonSuccess
        spawn(mainLoop)
    else
        mainToggle.Text = "MOVEMENT: OFF"
        mainToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

-- Handle respawn
player.CharacterAdded:Connect(function()
    if running then
        lastDirectionChange = tick()
        lastJumpTime = tick()
        lastEquipTime = tick()
    end
end)

print("✅ Combat Movement Helper Loaded")
print("📌 Click hub button to open")
