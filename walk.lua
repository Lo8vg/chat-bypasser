-- Combat Movement Helper (Builds on your Auto-Walk)
-- Keep your movement logic, adds combat features

local player = game.Players.LocalPlayer
local Humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
local HumanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

-- Settings (all customizable in GUI)
local autoWalkEnabled = false
local autoJumpEnabled = true
local autoSwingEnabled = true
local autoEquipSword = true
local randomDirectionEnabled = true

local jumpDelay = 1.5 -- seconds between jumps
local swingDelay = 0.3 -- seconds between swings
local swingsPerJump = 2 -- how many swings per jump
local directionChangeInterval = 5 -- seconds before changing direction
local swingRange = 15 -- sword reach

-- Movement variables
local currentDirection = Vector3.new(0, 0, -1)
local lastDirectionChange = 0
local lastJumpTime = 0
local lastSwingTime = 0

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombatMovementGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 300)
mainFrame.Position = UDim2.new(0, 20, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
mainFrame.Parent = screenGui
mainFrame.Visible = false

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Combat Movement"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

-- Toggle Button (small, draggable like original)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 120, 0, 28)
toggleBtn.Position = UDim2.new(0.5, -60, 0.9, -14)
toggleBtn.Text = "Movement: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.Parent = screenGui
toggleBtn.Draggable = true
toggleBtn.Active = true

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

-- Settings Button
local settingsBtn = Instance.new("TextButton")
settingsBtn.Size = UDim2.new(0, 28, 0, 28)
settingsBtn.Position = UDim2.new(1, -32, 0, 30)
settingsBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
settingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsBtn.Text = "⚙"
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextSize = 14
settingsBtn.Parent = mainFrame

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 6)
settingsCorner.Parent = settingsBtn

-- Content Container
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -70)
content.Position = UDim2.new(0, 10, 0, 35)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 8)
contentLayout.Parent = content

-- Helper function to create toggle
local function createToggle(name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 24)
    frame.BackgroundTransparency = 1
    frame.Parent = content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.35, 0, 1, 0)
    btn.Position = UDim2.new(0.65, 0, 0, 0)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 60, 60)
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
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 60, 60)
        callback(state)
    end)
    
    return btn
end

-- Helper function to create slider
local function createSlider(name, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 14)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Text = name..": "..defaultVal
    label.Font = Enum.Font.Gotham
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, 0, 0, 16)
    slider.Position = UDim2.new(0, 0, 0, 20)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    slider.Text = ""
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    fill.Parent = slider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.Radius = UDim.new(0, 4)
    fillCorner.Parent = fill
    
    local dragging = false
    
    slider.MouseButton1Down:Connect(function()
        dragging = true
        local input = game:GetService("UserInputService"):GetMouseLocation()
        local relativeX = math.clamp((input.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        local value = minVal + (maxVal - minVal) * relativeX
        value = math.round(value * 10) / 10
        fill.Size = UDim2.new(relativeX, 0, 1, 0)
        label.Text = name..": "..value
        callback(value)
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local value = minVal + (maxVal - minVal) * relativeX
            value = math.round(value * 10) / 10
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            label.Text = name..": "..value
            callback(value)
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragging = false
        end
    end)
end

-- Create toggles
createToggle("Auto Walk", false, function(state)
    autoWalkEnabled = state
end)

createToggle("Auto Jump", true, function(state)
    autoJumpEnabled = state
end)

createToggle("Auto Swing", true, function(state)
    autoSwingEnabled = state
end)

createToggle("Auto Equip Sword", true, function(state)
    autoEquipSword = state
end)

createToggle("Random Direction", true, function(state)
    randomDirectionEnabled = state
end)

-- Create sliders
createSlider("Jump Delay (sec)", 0.5, 5, jumpDelay, function(val)
    jumpDelay = val
end)

createSlider("Swing Delay (sec)", 0.1, 2, swingDelay, function(val)
    swingDelay = val
end)

createSlider("Swings Per Jump", 1, 5, swingsPerJump, function(val)
    swingsPerJump = math.floor(val)
end)

createSlider("Direction Change (sec)", 2, 15, directionChangeInterval, function(val)
    directionChangeInterval = val
end)

-- Function to check for obstacles (YOUR ORIGINAL LOGIC)
local function checkForObstacles(direction)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local raycastResult = workspace:Raycast(player.Character.HumanoidRootPart.Position, direction * 13, raycastParams)
    
    if raycastResult and raycastResult.Instance then
        return true
    end
    return false
end

-- Function to calculate clear path (YOUR ORIGINAL LOGIC)
local function calculateClearPath(direction)
    if not checkForObstacles(direction) then
        return direction
    else
        local leftDirection = (direction + Vector3.new(-1, 0, 0)).Unit
        local rightDirection = (direction + Vector3.new(1, 0, 0)).Unit
        local backDirection = -direction
        
        if not checkForObstacles(leftDirection) then
            return leftDirection
        elseif not checkForObstacles(rightDirection) then
            return rightDirection
        elseif not checkForObstacles(backDirection) then
            return backDirection
        else
            local randomDirection = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
            return randomDirection
        end
    end
end

-- Function to get random direction
local function getRandomDirection()
    local angle = math.random() * math.pi * 2
    return Vector3.new(math.cos(angle), 0, math.sin(angle))
end

-- Function to find sword in inventory
local function findSword()
    local character = player.Character
    if not character then return nil end
    
    -- Check if already equipped
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        return tool
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

-- Function to swing sword
local function swingSword()
    if not autoSwingEnabled then return end
    
    local sword = findSword()
    if not sword then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Equip if not equipped
    if autoEquipSword and sword.Parent ~= character then
        humanoid:EquipTool(sword)
        wait(0.1)
    end
    
    -- Activate sword (swing)
    sword:Activate()
end

-- Function to jump
local function jump()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

-- Main loop
local running = false
local lastTime = 0

local function mainLoop()
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
        
        local currentTime = tick()
        
        -- Auto equip sword
        if autoEquipSword then
            local sword = findSword()
            if sword and sword.Parent ~= character then
                humanoid:EquipTool(sword)
            end
        end
        
        -- Random direction change
        if randomDirectionEnabled and currentTime - lastDirectionChange >= directionChangeInterval then
            currentDirection = getRandomDirection()
            lastDirectionChange = currentTime
        end
        
        -- Auto walk (YOUR ORIGINAL MOVEMENT LOGIC)
        if autoWalkEnabled then
            local clearPath = calculateClearPath(currentDirection)
            humanoid:MoveTo(rootPart.Position + clearPath * 16)
        end
        
        -- Auto jump
        if autoJumpEnabled and currentTime - lastJumpTime >= jumpDelay then
            jump()
            lastJumpTime = currentTime
            
            -- Swing sword multiple times during jump
            if autoSwingEnabled then
                for i = 1, swingsPerJump do
                    wait(swingDelay)
                    swingSword()
                end
            end
        end
        
        wait(0.1)
    end
end

-- Toggle main function
local function toggleMovement()
    running = not running
    
    if running then
        toggleBtn.Text = "Movement: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        lastDirectionChange = tick()
        lastJumpTime = tick()
        spawn(mainLoop)
    else
        toggleBtn.Text = "Movement: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end

-- Settings button to show/hide GUI
settingsBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Toggle button click
toggleBtn.MouseButton1Click:Connect(function()
    toggleMovement()
end)

-- Make main frame draggable
local dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragInput = nil
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and mainFrame.Visible then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
print("📌 Click toggle button to start/stop")
print("📌 Click ⚙ to open settings")
