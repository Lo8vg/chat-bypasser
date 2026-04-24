-- AUTO WALK (Simple)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Settings
local autoWalkEnabled = false
local autoEquipEnabled = false
local equipDelay = 0.5

-- Variables
local currentWalkDirection = nil
local lastCameraDirection = nil
local equipState = false

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
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
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

-- Auto Equip Toggle
local equipToggle = Instance.new("TextButton")
equipToggle.Size = UDim2.new(1, 0, 0, 32)
equipToggle.BackgroundColor3 = COLORS.buttonDanger
equipToggle.TextColor3 = COLORS.textLight
equipToggle.Text = "AUTO EQUIP: OFF"
equipToggle.Font = Enum.Font.GothamBold
equipToggle.TextSize = 12
equipToggle.Parent = content

local etCorner = Instance.new("UICorner")
etCorner.CornerRadius = UDim.new(0, 6)
etCorner.Parent = equipToggle

-- Equip Delay Slider
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
delayLabel.Text = "Equip Delay: " .. equipDelay .. "s"
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
delaySliderFill.Size = UDim2.new((equipDelay - 0.1) / 2.9, 0, 1, 0)
delaySliderFill.BackgroundColor3 = COLORS.buttonPrimary
delaySliderFill.Parent = delaySliderBg

local dsfCorner = Instance.new("UICorner")
dsfCorner.CornerRadius = UDim.new(0, 4)
dsfCorner.Parent = delaySliderFill

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

-- Delay Slider Logic
local sliderDragging = false

delaySliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        local pos = math.clamp((input.Position.X - delaySliderBg.AbsolutePosition.X) / delaySliderBg.AbsoluteSize.X, 0, 1)
        equipDelay = math.round((0.1 + 2.9 * pos) * 10) / 10
        delaySliderFill.Size = UDim2.new(pos, 0, 1, 0)
        delayLabel.Text = "Equip Delay: " .. equipDelay .. "s"
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
        equipDelay = math.round((0.1 + 2.9 * pos) * 10) / 10
        delaySliderFill.Size = UDim2.new(pos, 0, 1, 0)
        delayLabel.Text = "Equip Delay: " .. equipDelay .. "s"
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

-- Find ONLY the "swuvle" tool by name
local function findSword()
    local character = player.Character
    local backpack = player:FindFirstChild("Backpack")
    
    -- Check if "swuvle" is equipped (in character)
    if character then
        local tool = character:FindFirstChild("swuvle")
        if tool and tool:IsA("Tool") then
            return tool
        end
    end
    
    -- Check if "swuvle" is in backpack (not equipped)
    if backpack then
        local tool = backpack:FindFirstChild("swuvle")
        if tool and tool:IsA("Tool") then
            return tool
        end
    end
    
    return nil
end

-- ========== MAIN LOOPS ==========

local walkRunning = false
local equipRunning = false

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

local function equipLoop()
    while equipRunning do
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local sword = findSword()
            
            if humanoid and sword then
                if equipState then
                    -- Currently equipped, unequip it (goes back to backpack)
                    humanoid:UnequipTools()
                else
                    -- Currently unequipped, equip it
                    humanoid:EquipTool(sword)
                end
                equipState = not equipState
            end
        end
        wait(equipDelay)
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
        spawn(walkLoop)
    else
        walkToggle.Text = "AUTO WALK: OFF"
        walkToggle.BackgroundColor3 = COLORS.buttonDanger
        currentWalkDirection = nil
    end
end)

equipToggle.MouseButton1Click:Connect(function()
    equipRunning = not equipRunning
    
    if equipRunning then
        equipToggle.Text = "AUTO EQUIP: ON"
        equipToggle.BackgroundColor3 = COLORS.buttonSuccess
        equipState = false
        spawn(equipLoop)
    else
        equipToggle.Text = "AUTO EQUIP: OFF"
        equipToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

print("✅ Auto Walk + Auto Equip Loaded")
