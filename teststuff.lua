local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local MOVE_SPEED = 18
local RAY_DISTANCE = 12

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoWalkGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 120, 0, 35)
button.Position = UDim2.new(0.5, -60, 0.85, 0)
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

-- Dragging (Mobile + PC)
local dragging = false
local dragStart, startPos
local dragInput = nil

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
        dragInput = input
    end
end)

button.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        dragInput = nil
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and dragInput and input == dragInput then
        local delta = input.Position - dragStart
        button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Raycast function
local function getClearDirection(humanoidRootPart)
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    
    local lookVector = camera.CFrame.LookVector
    local forward = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
    
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {player.Character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    
    -- Check forward
    local forwardHit = workspace:Raycast(humanoidRootPart.Position, forward * RAY_DISTANCE, params)
    
    if not forwardHit then
        return forward
    end
    
    -- Check left
    local rightVector = Vector3.new(forward.Z, 0, -forward.X)
    local leftVector = -rightVector
    
    local leftHit = workspace:Raycast(humanoidRootPart.Position, leftVector * RAY_DISTANCE, params)
    local rightHit = workspace:Raycast(humanoidRootPart.Position, rightVector * RAY_DISTANCE, params)
    
    if not leftHit then return leftVector end
    if not rightHit then return rightVector end
    
    -- Backwards
    local backHit = workspace:Raycast(humanoidRootPart.Position, -forward * RAY_DISTANCE, params)
    if not backHit then return -forward end
    
    -- Stuck, try diagonal
    local diag1 = (forward + leftVector).Unit
    local diag2 = (forward + rightVector).Unit
    
    if not workspace:Raycast(humanoidRootPart.Position, diag1 * RAY_DISTANCE, params) then
        return diag1
    end
    
    if not workspace:Raycast(humanoidRootPart.Position, diag2 * RAY_DISTANCE, params) then
        return diag2
    end
    
    return forward
end

-- Main auto-walk loop
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
        
        local direction = getClearDirection(humanoidRootPart)
        if direction then
            -- Move using MoveTo for reliability on mobile
            local targetPos = humanoidRootPart.Position + direction * MOVE_SPEED
            humanoid:MoveTo(targetPos)
        end
    end)
end

-- Toggle
button.MouseButton1Click:Connect(function()
    isAutoWalking = not isAutoWalking
    
    if isAutoWalking then
        button.Text = "Auto-Walk: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 140, 80)
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
            humanoid:MoveTo(humanoid.RootPart and humanoid.RootPart.Position or player.Character.HumanoidRootPart.Position)
        end
    end
end)

-- Handle respawn
player.CharacterAdded:Connect(function()
    wait(1)
    if isAutoWalking then
        startAutoWalk()
    end
end)

print("✅ Auto-Walk Loaded")
