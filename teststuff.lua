local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local moveSpeed = 16

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoWalkGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Create Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 100, 0, 30)
button.Position = UDim2.new(0.5, -50, 0.9, -15)
button.Text = "Auto-Walk: OFF"
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 11
button.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = button

-- Variables
local isAutoWalking = false
local currentMoveDirection = nil

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

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        dragInput = nil
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and dragInput then
        local delta = input.Position - dragStart
        button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Raycast obstacle check
local function checkForObstacles(direction, hrp, distance)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {player.Character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    
    local result = workspace:Raycast(hrp.Position, direction * distance, params)
    return result ~= nil
end

-- Calculate clear path
local function calculateClearPath(direction, hrp)
    local rightDir = Vector3.new(direction.Z, 0, -direction.X)
    local leftDir = Vector3.new(-direction.Z, 0, direction.X)
    
    local blockedForward = checkForObstacles(direction, hrp, 15)
    local blockedLeft = checkForObstacles(leftDir, hrp, 12)
    local blockedRight = checkForObstacles(rightDir, hrp, 12)
    local blockedBack = checkForObstacles(-direction, hrp, 15)
    
    -- Huge wall detected - all directions blocked except back
    if blockedForward and blockedLeft and blockedRight then
        if not blockedBack then
            currentMoveDirection = "back"
            return -direction
        end
    end
    
    -- Forward clear
    if not blockedForward then
        currentMoveDirection = "forward"
        return direction
    end
    
    -- Side clearances
    if not blockedLeft then
        currentMoveDirection = "left"
        return leftDir
    end
    
    if not blockedRight then
        currentMoveDirection = "right"
        return rightDir
    end
    
    -- Backward
    if not blockedBack then
        currentMoveDirection = "back"
        return -direction
    end
    
    -- Fully stuck, go backward anyway
    currentMoveDirection = "back"
    return -direction
end

-- Auto-walk loop
local function autoWalkLoop()
    while isAutoWalking and player.Character do
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local camera = workspace.CurrentCamera
        
        if hrp and humanoid and camera then
            local lookVector = camera.CFrame.LookVector
            local moveDirection = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
            
            local clearPath = calculateClearPath(moveDirection, hrp)
            
            -- Move character
            humanoid:MoveTo(hrp.Position + clearPath * moveSpeed)
            
            -- Force character rotation to face movement direction
            local targetCFrame = CFrame.new(hrp.Position, hrp.Position + clearPath)
            hrp.CFrame = hrp.CFrame:Lerp(targetCFrame, 0.5)
        end
        
        task.wait(0.1)
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
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        currentMoveDirection = nil
    end
end)

-- Respawn
player.CharacterAdded:Connect(function()
    if isAutoWalking then
        currentMoveDirection = nil
        autoWalkLoop()
    end
end)

print("✅ Auto-Walk Loaded")
