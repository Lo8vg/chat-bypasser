-- AUTO WALK + COMBO (Simple)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- SETTINGS
local TOOL_NAME = "swuvle"
local comboDelay = 0.5

-- Variables
local currentWalkDirection = nil
local lastCameraDirection = nil
local comboRunning = false

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

-- Main Frame (expanded height)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 210)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -105)
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

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -24, 1, -40)
content.Position = UDim2.new(0, 12, 0, 36)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 6)
contentLayout.Parent = content

-- Auto Walk Toggle
local walkToggle = Instance.new("TextButton")
walkToggle.Size = UDim2.new(1, 0, 0, 32)
walkToggle.BackgroundColor3 = COLORS.buttonDanger
walkToggle.TextColor3 = COLORS.textLight
walkToggle.Text = "AUTO WALK: OFF"
walkToggle.Font = Enum.Font.GothamBold
walkToggle.TextSize = 12
walkToggle.Parent = content

local wtCorner = Instance.new("UICorner")
wtCorner.CornerRadius = UDim.new(0, 6)
wtCorner.Parent = walkToggle

-- Combo Toggle
local comboToggle = Instance.new("TextButton")
comboToggle.Size = UDim2.new(1, 0, 0, 32)
comboToggle.BackgroundColor3 = COLORS.buttonDanger
comboToggle.TextColor3 = COLORS.textLight
comboToggle.Text = "COMBO: OFF"
comboToggle.Font = Enum.Font.GothamBold
comboToggle.TextSize = 12
comboToggle.Parent = content

local ctCorner = Instance.new("UICorner")
ctCorner.CornerRadius = UDim.new(0, 6)
ctCorner.Parent = comboToggle

-- Combo Info
local comboInfo = Instance.new("TextLabel")
comboInfo.Size = UDim2.new(1, 0, 0, 16)
comboInfo.BackgroundTransparency = 1
comboInfo.TextColor3 = COLORS.textDark
comboInfo.Text = "Equip + Jump + Swing"
comboInfo.Font = Enum.Font.Gotham
comboInfo.TextSize = 9
comboInfo.TextXAlignment = Enum.TextXAlignment.Left
comboInfo.Parent = content

-- Combo Delay Slider
local delayFrame = Instance.new("Frame")
delayFrame.Size = UDim2.new(1, 0, 0, 32)
delayFrame.BackgroundColor3 = COLORS.cardBg
delayFrame.Parent = content

local dfCorner = Instance.new("UICorner")
dfCorner.CornerRadius = UDim.new(0, 6)
dfCorner.Parent = delayFrame

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(1, 0, 0, 14)
delayLabel.Position = UDim2.new(0, 8, 0, 2)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = COLORS.textDark
delayLabel.Text = "Combo Delay: " .. comboDelay .. "s"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 10
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = delayFrame

local delaySliderBg = Instance.new("Frame")
delaySliderBg.Size = UDim2.new(1, -16, 0, 8)
delaySliderBg.Position = UDim2.new(0, 8, 0, 20)
delaySliderBg.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
delaySliderBg.Parent = delayFrame

local dsbCorner = Instance.new("UICorner")
dsbCorner.CornerRadius = UDim.new(0, 4)
dsbCorner.Parent = delaySliderBg

local delaySliderFill = Instance.new("Frame")
delaySliderFill.Size = UDim2.new((comboDelay - 0.1) / 2.9, 0, 1, 0)
delaySliderFill.BackgroundColor3 = COLORS.buttonPrimary
delaySliderFill.Parent = delaySliderBg

local dsfCorner = Instance.new("UICorner")
dsfCorner.CornerRadius = UDim.new(0, 4)
dsfCorner.Parent = delaySliderFill

-- Tool Name Input
local toolFrame = Instance.new("Frame")
toolFrame.Size = UDim2.new(1, 0, 0, 32)
toolFrame.BackgroundColor3 = COLORS.cardBg
toolFrame.Parent = content

local tfCorner = Instance.new("UICorner")
tfCorner.CornerRadius = UDim.new(0, 6)
tfCorner.Parent = toolFrame

local toolLabel = Instance.new("TextLabel")
toolLabel.Size = UDim2.new(0.4, 0, 1, 0)
toolLabel.Position = UDim2.new(0, 8, 0, 0)
toolLabel.BackgroundTransparency = 1
toolLabel.TextColor3 = COLORS.textDark
toolLabel.Text = "Tool:"
toolLabel.Font = Enum.Font.Gotham
toolLabel.TextSize = 10
toolLabel.TextXAlignment = Enum.TextXAlignment.Left
toolLabel.Parent = toolFrame

local toolInput = Instance.new("TextBox")
toolInput.Size = UDim2.new(0.55, -8, 0, 22)
toolInput.Position = UDim2.new(0.45, 4, 0.5, -11)
toolInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toolInput.TextColor3 = COLORS.textDark
toolInput.Text = TOOL_NAME
toolInput.Font = Enum.Font.Gotham
toolInput.TextSize = 10
toolInput.PlaceholderText = "Tool name"
toolInput.Parent = toolFrame

local tiCorner = Instance.new("UICorner")
tiCorner.CornerRadius = UDim.new(0, 4)
tiCorner.Parent = toolInput

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
    task.wait(0.05)
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

-- Delay Slider Logic
local sliderDragging = false

delaySliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        local pos = math.clamp((input.Position.X - delaySliderBg.AbsolutePosition.X) / delaySliderBg.AbsoluteSize.X, 0, 1)
        comboDelay = math.round((0.1 + 2.9 * pos) * 10) / 10
        delaySliderFill.Size = UDim2.new(pos, 0, 1, 0)
        delayLabel.Text = "Combo Delay: " .. comboDelay .. "s"
    end
end)

delaySliderBg.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliderDragging then
        local pos = math.clamp((input.Position.X - delaySliderBg.AbsolutePosition.X) / delaySliderBg.AbsoluteSize.X, 0, 1)
        comboDelay = math.round((0.1 + 2.9 * pos) * 10) / 10
        delaySliderFill.Size = UDim2.new(pos, 0, 1, 0)
        delayLabel.Text = "Combo Delay: " .. comboDelay .. "s"
    end
end)

-- Tool input
toolInput.FocusLost:Connect(function()
    local newName = toolInput.Text:match("^%s*(.-)%s*$")
    if newName and newName ~= "" then
        TOOL_NAME = newName
        print("Tool name set to: " .. TOOL_NAME)
    else
        toolInput.Text = TOOL_NAME
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

-- ========== COMBO FUNCTION (equip + jump + swing synced) ==========

local function doCombo()
    local character = player.Character
    local backpack = player:FindFirstChild("Backpack")
    
    if not character or not backpack then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Find tool in character OR backpack (same method that works)
    local tool = character:FindFirstChild(TOOL_NAME) or backpack:FindFirstChild(TOOL_NAME)
    
    if not tool or not tool:IsA("Tool") then return end
    
    -- 1. Equip if in backpack
    if tool.Parent == backpack then
        humanoid:EquipTool(tool)
        task.wait() -- tiny sync frame
    end
    
    -- 2. Jump
    humanoid.Jump = true
    
    -- 3. Swing
    tool:Activate()
end

-- ========== MAIN LOOPS ==========

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
        task.wait(0.1)
    end
end

local function comboLoop()
    while comboRunning do
        doCombo()
        task.wait(comboDelay)
    end
end

-- ========== TOGGLES ==========

walkToggle.MouseButton1Click:Connect(function()
    walkRunning = not walkRunning
    
    if walkRunning then
        walkToggle.Text = "AUTO WALK: ON"
        walkToggle.BackgroundColor3 = COLORS.buttonSuccess
        currentWalkDirection = nil
        lastCameraDirection = nil
        task.spawn(walkLoop)
    else
        walkToggle.Text = "AUTO WALK: OFF"
        walkToggle.BackgroundColor3 = COLORS.buttonDanger
        currentWalkDirection = nil
    end
end)

comboToggle.MouseButton1Click:Connect(function()
    comboRunning = not comboRunning
    
    if comboRunning then
        -- Check if tool exists first
        local character = player.Character
        local backpack = player:FindFirstChild("Backpack")
        local tool = character and (character:FindFirstChild(TOOL_NAME) or backpack and backpack:FindFirstChild(TOOL_NAME))
        
        if not tool then
            comboToggle.Text = "COMBO: OFF"
            comboToggle.BackgroundColor3 = COLORS.buttonDanger
            comboRunning = false
            print("❌ Tool '" .. TOOL_NAME .. "' not found!")
            return
        end
        
        comboToggle.Text = "COMBO: ON"
        comboToggle.BackgroundColor3 = COLORS.buttonSuccess
        print("✅ Combo started with: " .. TOOL_NAME)
        task.spawn(comboLoop)
    else
        comboToggle.Text = "COMBO: OFF"
        comboToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

print("✅ Auto Walk + Combo Loaded")
print("📌 Tool name: " .. TOOL_NAME)
