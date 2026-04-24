- OBJECT SPAWNER WITH TEXT (Mobile Fixed)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ObjectSpawnerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 220)
mainFrame.Position = UDim2.new(0.5, -90, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mfCorner = Instance.new("UICorner")
mfCorner.CornerRadius = UDim.new(0, 10)
mfCorner.Parent = mainFrame

local mfStroke = Instance.new("UIStroke")
mfStroke.Color = Color3.fromRGB(200, 200, 200)
mfStroke.Thickness = 2
mfStroke.Parent = mainFrame

local mfLayout = Instance.new("UIListLayout")
mfLayout.Padding = UDim.new(0, 6)
mfLayout.Parent = mainFrame

local mfPadding = Instance.new("UIPadding")
mfPadding.PaddingTop = UDim.new(0, 10)
mfPadding.PaddingLeft = UDim.new(0, 10)
mfPadding.PaddingRight = UDim.new(0, 10)
mfPadding.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 22)
title.BackgroundTransparency = 1
title.Text = "OBJECT SPAWNER"
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

-- Text Input Label
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -20, 0, 16)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Text:"
textLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
textLabel.Font = Enum.Font.Gotham
textLabel.TextSize = 11
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.Parent = mainFrame

local textInput = Instance.new("TextBox")
textInput.Size = UDim2.new(1, -20, 0, 28)
textInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
textInput.TextColor3 = Color3.fromRGB(0, 0, 0)
textInput.Text = "BITCH"
textInput.Font = Enum.Font.GothamBold
textInput.TextSize = 12
textInput.PlaceholderText = "Enter text..."
textInput.Parent = mainFrame

local tiCorner = Instance.new("UICorner")
tiCorner.CornerRadius = UDim.new(0, 6)
tiCorner.Parent = textInput

local tiStroke = Instance.new("UIStroke")
tiStroke.Color = Color3.fromRGB(180, 180, 180)
tiStroke.Thickness = 1
tiStroke.Parent = textInput

-- Size Input Label
local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(1, -20, 0, 16)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "Size (X Y Z):"
sizeLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
sizeLabel.Font = Enum.Font.Gotham
sizeLabel.TextSize = 11
sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
sizeLabel.Parent = mainFrame

local sizeInput = Instance.new("TextBox")
sizeInput.Size = UDim2.new(1, -20, 0, 28)
sizeInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sizeInput.TextColor3 = Color3.fromRGB(0, 0, 0)
sizeInput.Text = "50 30 5"
sizeInput.Font = Enum.Font.Gotham
sizeInput.TextSize = 12
sizeInput.PlaceholderText = "50 30 5"
sizeInput.Parent = mainFrame

local siCorner = Instance.new("UICorner")
siCorner.CornerRadius = UDim.new(0, 6)
siCorner.Parent = sizeInput

local siStroke = Instance.new("UIStroke")
siStroke.Color = Color3.fromRGB(180, 180, 180)
siStroke.Thickness = 1
siStroke.Parent = sizeInput

-- Color Label
local colorLabel = Instance.new("TextLabel")
colorLabel.Size = UDim2.new(1, -20, 0, 16)
colorLabel.BackgroundTransparency = 1
colorLabel.Text = "Color:"
colorLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
colorLabel.Font = Enum.Font.Gotham
colorLabel.TextSize = 11
colorLabel.TextXAlignment = Enum.TextXAlignment.Left
colorLabel.Parent = mainFrame

-- Color Buttons Row
local colorFrame = Instance.new("Frame")
colorFrame.Size = UDim2.new(1, -20, 0, 28)
colorFrame.BackgroundTransparency = 1
colorFrame.Parent = mainFrame

local cfLayout = Instance.new("UIListLayout")
cfLayout.FillDirection = Enum.FillDirection.Horizontal
cfLayout.Padding = UDim.new(0, 4)
cfLayout.Parent = colorFrame

local selectedColor = Color3.fromRGB(255, 0, 0)
local colorButtons = {
    {name = "Red", color = Color3.fromRGB(255, 50, 50)},
    {name = "Blue", color = Color3.fromRGB(50, 150, 255)},
    {name = "Green", color = Color3.fromRGB(50, 255, 50)},
    {name = "Pink", color = Color3.fromRGB(255, 50, 255)},
    {name = "Yellow", color = Color3.fromRGB(255, 255, 50)},
}

for i, c in ipairs(colorButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, -2, 1, 0)
    btn.BackgroundColor3 = c.color
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = colorFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    if i == 1 then
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(0, 0, 0)
        btnStroke.Thickness = 3
        btnStroke.Parent = btn
    end
    
    btn.MouseButton1Click:Connect(function()
        selectedColor = c.color
        -- Highlight selected
        for _, b in ipairs(colorFrame:GetChildren()) do
            if b:IsA("TextButton") then
                -- Remove all strokes first
                local foundStroke = nil
                for _, child in ipairs(b:GetChildren()) do
                    if child:IsA("UIStroke") then
                        child:Destroy()
                    end
                end
            end
        end
        -- Add stroke to selected
        local newStroke = Instance.new("UIStroke")
        newStroke.Color = Color3.fromRGB(0, 0, 0)
        newStroke.Thickness = 3
        newStroke.Parent = btn
    end)
end

-- Spawn Button
local spawnBtn = Instance.new("TextButton")
spawnBtn.Size = UDim2.new(1, -20, 0, 32)
spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
spawnBtn.BorderSizePixel = 0
spawnBtn.Text = "SPAWN OBJECT"
spawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnBtn.Font = Enum.Font.GothamBold
spawnBtn.TextSize = 13
spawnBtn.Parent = mainFrame

local spCorner = Instance.new("UICorner")
spCorner.CornerRadius = UDim.new(0, 6)
spCorner.Parent = spawnBtn

-- Clear Button
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(1, -20, 0, 28)
clearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
clearBtn.BorderSizePixel = 0
clearBtn.Text = "CLEAR ALL"
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 11
clearBtn.Parent = mainFrame

local clCorner = Instance.new("UICorner")
clCorner.CornerRadius = UDim.new(0, 6)
clCorner.Parent = clearBtn

-- Spawned objects tracker
local spawnedObjects = {}

-- ========== SPAWN FUNCTION ==========

local function spawnObject()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Parse text
    local text = textInput.Text
    if text == "" then text = "BITCH" end
    
    -- Parse size
    local sizeStr = sizeInput.Text
    local x, y, z = 50, 30, 5
    local sx, sy, sz = sizeStr:match("(%d+)%s+(%d+)%s+(%d+)")
    if sx and sy and sz then
        x, y, z = tonumber(sx) or 50, tonumber(sy) or 30, tonumber(sz) or 5
    end
    
    -- Create part
    local part = Instance.new("Part")
    part.Name = "TextObject_" .. #spawnedObjects
    part.Size = Vector3.new(x, y, z)
    part.Anchored = true
    part.CanCollide = false
    part.Color = selectedColor
    part.Material = Enum.Material.Neon
    
    -- Position in front of player
    local cf = rootPart.CFrame
    part.CFrame = cf * CFrame.new(0, y/2 + 5, -20)
    
    -- Create SurfaceGui for text (front face)
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Parent = part
    surfaceGui.Face = Enum.NormalId.Front
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Parent = surfaceGui
    
    -- Back face
    local surfaceGui2 = Instance.new("SurfaceGui")
    surfaceGui2.Parent = part
    surfaceGui2.Face = Enum.NormalId.Back
    
    local textLabel2 = textLabel:Clone()
    textLabel2.Parent = surfaceGui2
    
    -- Add to workspace
    part.Parent = workspace
    
    table.insert(spawnedObjects, part)
    
    -- Fade in
    part.Transparency = 1
    for i = 1, 10 do
        part.Transparency = 1 - (i/10)
        wait(0.02)
    end
    part.Transparency = 0
    
    print("✅ Spawned: " .. text)
end

-- Clear function
local function clearObjects()
    for _, obj in ipairs(spawnedObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    spawnedObjects = {}
    print("✅ Cleared all")
end

-- ========== BUTTONS ==========

spawnBtn.MouseButton1Click:Connect(function()
    spawnObject()
end)

clearBtn.MouseButton1Click:Connect(function()
    clearObjects()
end)

-- ========== DRAGGING (Mobile + PC) ==========
local dragging = false
local dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("✅ Object Spawner Loaded (Mobile Friendly)")
