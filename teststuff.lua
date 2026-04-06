local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoWalkGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

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
local moveSpeed = 16

-- Dragging (works on mobile + PC)
local dragging = false
local dragStart, startPos

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
    end
end)

button.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Raycast check for obstacles
local function checkForObstacles(direction, humanoidRootPart)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local raycastResult = workspace:Raycast(humanoidRootPart.Position, direction * 12, raycastParams)
    
    if raycastResult and raycastResult.Instance then
        return true
    end
    return false
end

-- Calculate clear path
local function calculateClearPath(direction, humanoidRootPart)
    if not checkForObstacles(direction, humanoidRootPart) then
        return direction
    end
    
    -- Try left
    local leftDirection = (direction + Vector3.new(-1, 0, 0)).Unit
    if not checkForObstacles(leftDirection, humanoidRootPart) then
        return leftDirection
    end
    
    -- Try right
    local rightDirection = (direction + Vector3.new(1, 0, 0)).Unit
    if not checkForObstacles(rightDirection, humanoidRootPart) then
        return rightDirection
    end
    
    -- Try backwards
    local backDirection = -direction
    if not checkForObstacles(backDirection, humanoidRootPart) then
        return backDirection
    end
    
    -- Random diagonal
    local randomDirection = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
    return randomDirection
end

-- Auto-walk loop
local function autoWalkLoop()
    while isAutoWalking and player.Character do
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local camera = workspace.CurrentCamera
        
        if humanoidRootPart and humanoid and camera then
            local lookVector = camera.CFrame.LookVector
            local moveDirection = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
            
            local clearPath = calculateClearPath(moveDirection, humanoidRootPart)
            humanoid:MoveTo(humanoidRootPart.Position + clearPath * moveSpeed)
        end
        
        wait(0.1)
    end
end

-- Toggle
button.MouseButton1Click:Connect(function()
    isAutoWalking = not isAutoWalking
    
    if isAutoWalking then
        button.Text = "Auto-Walk: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 140, 80)
        autoWalkLoop()
    else
        button.Text = "Auto-Walk: OFF"
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

-- Respawn handling
player.CharacterAdded:Connect(function()
    if isAutoWalking then
        autoWalkLoop()
    end
end)

print("✅ Auto-Walk Loaded")
