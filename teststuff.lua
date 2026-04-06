local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local MOVE_SPEED = 16
local RAY_DISTANCE = 15
local JUMP_THRESHOLD = 5

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoWalkGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 120, 0, 35)
button.Position = UDim2.new(0.5, -60, 0.9, -20)
button.Text = "Auto-Walk: OFF"
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 12
button.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = button

-- Variables
local isAutoWalking = false
local connection = nil

-- Dragging
local dragging = false
local dragInput, dragStart, startPos

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Raycast function
local function raycast(origin, direction, distance)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {player.Character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    
    local result = workspace:Raycast(origin, direction * distance, params)
    return result ~= nil
end

-- Multi-direction obstacle check
local function getClearDirection(baseDirection, humanoidRootPart)
    local directions = {
        {dir = baseDirection, weight = 1},           -- Forward
        {dir = baseDirection * 0.8 + Vector3.new(-1, 0, 0).Unit * 0.2, weight = 0.9},  -- Slight left
        {dir = baseDirection * 0.8 + Vector3.new(1, 0, 0).Unit * 0.2, weight = 0.9},    -- Slight right
    }
    
    -- Check perpendicular directions
    local rightVector = Vector3.new(baseDirection.Z, 0, -baseDirection.X)
    local leftVector = -rightVector
    
    for _, data in ipairs(directions) do
        if not raycast(humanoidRootPart.Position, data.dir, RAY_DISTANCE) then
            return data.dir
        end
    end
    
    -- Try perpendicular
    if not raycast(humanoidRootPart.Position, rightVector, RAY_DISTANCE) then
        return rightVector
    elseif not raycast(humanoidRootPart.Position, leftVector, RAY_DISTANCE) then
        return leftVector
    end
    
    -- Backwards as last resort
    return -baseDirection
end

-- Check if we should jump
local function shouldJump(humanoidRootPart, direction)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {player.Character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    
    -- Check for obstacle we can jump over
    local result = workspace:Raycast(humanoidRootPart.Position, direction * 8, params)
    if result then
        local hitPos = result.Position
        local hitHeight = hitPos.Y - humanoidRootPart.Position.Y
        if hitHeight > 1 and hitHeight < JUMP_THRESHOLD then
            return true
        end
    end
    return false
end

-- Main auto-walk function
local function startAutoWalk()
    if connection then
        connection:Disconnect()
    end
    
    connection = RunService.Heartbeat:Connect(function()
        if not isAutoWalking then return end
        
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not humanoidRootPart then return end
        
        local camera = workspace.CurrentCamera
        if not camera then return end
        
        -- Get camera direction (horizontal only)
        local lookVector = camera.CFrame.LookVector
        local moveDirection = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
        
        -- Check for obstacles and get clear direction
        local clearDirection = getClearDirection(moveDirection, humanoidRootPart)
        
        -- Move in clear direction
        humanoid:Move(clearDirection, true)
        
        -- Jump over small obstacles
        if shouldJump(humanoidRootPart, moveDirection) then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

-- Toggle
button.MouseButton1Click:Connect(function()
    isAutoWalking = not isAutoWalking
    
    if isAutoWalking then
        button.Text = "Auto-Walk: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        startAutoWalk()
    else
        button.Text = "Auto-Walk: OFF"
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
        
        -- Stop movement
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:Move(Vector3.new(0, 0, 0), true)
        end
    end
end)

-- Handle respawn
player.CharacterAdded:Connect(function()
    if isAutoWalking then
        startAutoWalk()
    end
end)

print("✅ Auto-Walk Loaded")
