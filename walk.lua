-- AUTO WALK (Simple)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Settings
local autoWalkEnabled = false

local COLORS = {
    background = Color3.fromRGB(245, 245, 245),
    header = Color3.fromRGB(255, 255, 255),
    buttonPrimary = Color3.fromRGB(0, 120, 215),
    buttonDanger = Color3.fromRGB(220, 53, 69),
    buttonSuccess = Color3.fromRGB(40, 167, 69),
    textDark = Color3.fromRGB(33, 37, 41),
    textLight = Color3.fromRGB(255, 255, 255),
    cardBg = Color3.fromRGB(255, 255, 255)
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoWalkGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Hub Button
local hubButton = Instance.new("TextButton")
hubButton.Size = UDim2.new(0, 55, 0, 55)
hubButton.Position = UDim2.new(0, 10, 0.5, -27)
hubButton.BackgroundColor3 = COLORS.cardBg
hubButton.BorderSizePixel = 0
hubButton.Text = "🚶"
hubButton.TextColor3 = COLORS.textDark
hubButton.Font = Enum.Font.GothamBold
hubButton.TextSize = 24
hubButton.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 12)
hubCorner.Parent = hubButton

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
mainFrame.BackgroundColor3 = COLORS.background
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mfCorner = Instance.new("UICorner")
mfCorner.CornerRadius = UDim.new(0, 12)
mfCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = COLORS.header
titleBar.Parent = mainFrame

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 12)
tbCorner.Parent = titleBar

local tbFix = Instance.new("Frame")
tbFix.Size = UDim2.new(1, 0, 0, 12)
tbFix.Position = UDim2.new(0, 0, 1, -12)
tbFix.BackgroundColor3 = COLORS.header
tbFix.BorderSizePixel = 0
tbFix.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = COLORS.textDark
title.Text = "AUTO WALK"
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 20)
closeBtn.Position = UDim2.new(1, -28, 0.5, -10)
closeBtn.BackgroundColor3 = COLORS.buttonDanger
closeBtn.TextColor3 = COLORS.textLight
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 10
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn

-- Toggle Button
local walkToggle = Instance.new("TextButton")
walkToggle.Size = UDim2.new(1, -24, 0, 40)
walkToggle.Position = UDim2.new(0, 12, 0, 44)
walkToggle.BackgroundColor3 = COLORS.buttonDanger
walkToggle.TextColor3 = COLORS.textLight
walkToggle.Text = "AUTO WALK: OFF"
walkToggle.Font = Enum.Font.GothamBold
walkToggle.TextSize = 14
walkToggle.Parent = mainFrame

local wtCorner = Instance.new("UICorner")
wtCorner.CornerRadius = UDim.new(0, 8)
wtCorner.Parent = walkToggle

-- Dragging
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

hubButton.MouseButton1Click:Connect(function()
    wait(0.05)
    if not dragging then
        hubButton.Visible = false
        mainFrame.Visible = true
    end
end)

-- Main frame dragging
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

-- ========== FUNCTIONS ==========

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

local function getCameraDirection()
    local camera = workspace.CurrentCamera
    if camera then
        local lookVector = camera.CFrame.LookVector
        return Vector3.new(lookVector.X, 0, lookVector.Z).Unit
    end
    return Vector3.new(0, 0, -1)
end

local function calculateClearPath(baseDirection)
    if not checkForObstacles(baseDirection) then
        return baseDirection
    end
    
    local leftDir = (baseDirection + Vector3.new(-1, 0, 0)).Unit
    local rightDir = (baseDirection + Vector3.new(1, 0, 0)).Unit
    
    if not checkForObstacles(leftDir) then return leftDir end
    if not checkForObstacles(rightDir) then return rightDir end
    
    local backDir = -baseDirection
    if not checkForObstacles(backDir) then return backDir end
    
    local angle = math.random() * math.pi * 2
    return Vector3.new(math.cos(angle), 0, math.sin(angle))
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
                local clearPath = calculateClearPath(cameraDirection)
                humanoid:MoveTo(rootPart.Position + clearPath * 16)
            end
        end
        wait(0.1)
    end
end

-- ========== TOGGLE ==========

walkToggle.MouseButton1Click:Connect(function()
    walkRunning = not walkRunning
    
    if walkRunning then
        walkToggle.Text = "AUTO WALK: ON"
        walkToggle.BackgroundColor3 = COLORS.buttonSuccess
        spawn(walkLoop)
    else
        walkToggle.Text = "AUTO WALK: OFF"
        walkToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

print("✅ Auto Walk Loaded")
