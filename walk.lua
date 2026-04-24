-- AUTO WALK (Simple)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Settings
local autoWalkEnabled = false
local currentWalkDirection = nil
local lastCameraDirection = nil

-- Colors
local COLOR_OFF = Color3.fromRGB(220, 53, 69)
local COLOR_ON = Color3.fromRGB(40, 167, 69)

-- Tiny Button
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoWalkGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 70, 0, 28)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -14)
toggleBtn.BackgroundColor3 = COLOR_OFF
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "AUTO WALK"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 10
toggleBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleBtn

-- Dragging
local dragging = false
local dragInput, dragStart, startPos

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ========== FUNCTIONS ==========

local function checkForObstacles(direction, distance)
    local character = player.Character
    if not character then return false end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = workspace:Raycast(rootPart.Position, direction * distance, raycastParams)
    return result and result.Instance ~= nil
end

local function getCameraDirection()
    local camera = workspace.CurrentCamera
    if camera then
        local lookVector = camera.CFrame.LookVector
        return Vector3.new(lookVector.X, 0, lookVector.Z).Unit
    end
    return Vector3.new(0, 0, -1)
end

local function areDirectionsSimilar(dir1, dir2, threshold)
    if not dir1 or not dir2 then return false end
    local dot = dir1:Dot(dir2)
    return dot > threshold
end

local function findBestDirection(preferredDirection)
    if not checkForObstacles(preferredDirection, 15) then
        return preferredDirection, false
    end
    
    local angles = {45, 90, 135, 180, 225, 270, 315}
    
    for _, angleOffset in pairs(angles) do
        local radians = math.rad(angleOffset)
        local newDir = Vector3.new(
            preferredDirection.X * math.cos(radians) - preferredDirection.Z * math.sin(radians),
            0,
            preferredDirection.X * math.sin(radians) + preferredDirection.Z * math.cos(radians)
        ).Unit
        
        if not checkForObstacles(newDir, 15) then
            return newDir, true
        end
    end
    
    local randomAngle = math.random() * math.pi * 2
    return Vector3.new(math.cos(randomAngle), 0, math.sin(randomAngle)), true
end

-- ========== MAIN LOOP ==========

local walkRunning = false

local function walkLoop()
    while walkRunning do
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                local cameraDirection = getCameraDirection()
                
                local cameraChanged = not areDirectionsSimilar(cameraDirection, lastCameraDirection, 0.9)
                local cameraPathClear = not checkForObstacles(cameraDirection, 15)
                
                if not currentWalkDirection then
                    currentWalkDirection, _ = findBestDirection(cameraDirection)
                    lastCameraDirection = cameraDirection
                elseif cameraChanged and cameraPathClear then
                    currentWalkDirection = cameraDirection
                    lastCameraDirection = cameraDirection
                elseif checkForObstacles(currentWalkDirection, 15) then
                    currentWalkDirection, _ = findBestDirection(cameraDirection)
                end
                
                humanoid:MoveTo(rootPart.Position + currentWalkDirection * 16)
            end
        end
        wait(0.1)
    end
end

-- ========== TOGGLE ==========

toggleBtn.MouseButton1Click:Connect(function()
    wait(0.05)
    if dragging then return end
    
    walkRunning = not walkRunning
    
    if walkRunning then
        toggleBtn.BackgroundColor3 = COLOR_ON
        currentWalkDirection = nil
        lastCameraDirection = nil
        spawn(walkLoop)
    else
        toggleBtn.BackgroundColor3 = COLOR_OFF
        currentWalkDirection = nil
    end
end)

print("✅ Auto Walk Loaded")
