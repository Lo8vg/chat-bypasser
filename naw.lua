-- OBJECT SPAWNER WITH TEXT

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Colors
local COLOR_OFF = Color3.fromRGB(220, 53, 69)
local COLOR_ON = Color3.fromRGB(40, 167, 69)

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ObjectSpawnerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 160, 0, 180)
mainFrame.Position = UDim2.new(0, 10, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mfCorner = Instance.new("UICorner")
mfCorner.CornerRadius = UDim.new(0, 8)
mfCorner.Parent = mainFrame

local mfLayout = Instance.new("UIListLayout")
mfLayout.Padding = UDim.new(0, 4)
mfLayout.Parent = mainFrame

local mfPadding = Instance.new("UIPadding")
mfPadding.PaddingTop = UDim.new(0, 6)
mfPadding.PaddingLeft = UDim2.new(0, 6)
mfPadding.PaddingRight = UDim2.new(0, 6)
mfPadding.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -12, 0, 18)
title.BackgroundTransparency = 1
title.Text = "OBJECT SPAWNER"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.Parent = mainFrame

-- Text Input
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -12, 0, 14)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Text:"
textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
textLabel.Font = Enum.Font.Gotham
textLabel.TextSize = 9
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.Parent = mainFrame

local textInput = Instance.new("TextBox")
textInput.Size = UDim2.new(1, -12, 0, 22)
textInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textInput.TextColor3 = Color3.fromRGB(255, 255, 255)
textInput.Text = "BITCH"
textInput.Font = Enum.Font.GothamBold
textInput.TextSize = 10
textInput.PlaceholderText = "Enter text..."
textInput.Parent = mainFrame

local tiCorner = Instance.new("UICorner")
tiCorner.CornerRadius = UDim.new(0, 4)
tiCorner.Parent = textInput

-- Size Input
local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(1, -12, 0, 14)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "Size (X Y Z):"
sizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
sizeLabel.Font = Enum.Font.Gotham
sizeLabel.TextSize = 9
sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
sizeLabel.Parent = mainFrame

local sizeInput = Instance.new("TextBox")
sizeInput.Size = UDim2.new(1, -12, 0, 22)
sizeInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeInput.Text = "50 30 5"
sizeInput.Font = Enum.Font.Gotham
sizeInput.TextSize = 10
sizeInput.PlaceholderText = "50 30 5"
sizeInput.Parent = mainFrame

local siCorner = Instance.new("UICorner")
siCorner.CornerRadius = UDim.new(0, 4)
siCorner.Parent = sizeInput

-- Color Buttons Row
local colorFrame = Instance.new("Frame")
colorFrame.Size = UDim2.new(1, -12, 0, 22)
colorFrame.BackgroundTransparency = 1
colorFrame.Parent = mainFrame

local cfLayout = Instance.new("UIListLayout")
cfLayout.FillDirection = Enum.FillDirection.Horizontal
cfLayout.Padding = UDim.new(0, 2)
cfLayout.Parent = colorFrame

local selectedColor = Color3.fromRGB(255, 0, 0)
local colorButtons = {
    {name = "Red", color = Color3.fromRGB(255, 0, 0)},
    {name = "Blue", color = Color3.fromRGB(0, 100, 255)},
    {name = "Green", color = Color3.fromRGB(0, 255, 0)},
    {name = "Pink", color = Color3.fromRGB(255, 0, 255)},
}

for _, c in ipairs(colorButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, -2, 1, 0)
    btn.BackgroundColor3 = c.color
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = colorFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        selectedColor = c.color
        -- Highlight selected
        for _, b in ipairs(colorFrame:GetChildren()) do
            if b:IsA("TextButton") then
                if b.BackgroundColor3 == c.color then
                    b.BorderSizePixel = 2
                    b.BorderColor3 = Color3.fromRGB(255, 255, 255)
                else
                    b.BorderSizePixel = 0
                end
            end
        end
    end)
    
    if c.name == "Red" then
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Spawn Button
local spawnBtn = Instance.new("TextButton")
spawnBtn.Size = UDim2.new(1, -12, 0, 26)
spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
spawnBtn.BorderSizePixel = 0
spawnBtn.Text = "SPAWN OBJECT"
spawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnBtn.Font = Enum.Font.GothamBold
spawnBtn.TextSize = 11
spawnBtn.Parent = mainFrame

local spCorner = Instance.new("UICorner")
spCorner.CornerRadius = UDim.new(0, 4)
spCorner.Parent = spawnBtn

-- Clear Button
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(1, -12, 0, 20)
clearBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
clearBtn.BorderSizePixel = 0
clearBtn.Text = "CLEAR ALL"
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.Font = Enum.Font.Gotham
clearBtn.TextSize = 9
clearBtn.Parent = mainFrame

local clCorner = Instance.new("UICorner")
clCorner.CornerRadius = UDim.new(0, 4)
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
    part.CFrame = cf * CFrame.new(0, y/2 + 5, -20) -- 20 studs in front
    
    -- Create SurfaceGui for text
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Parent = part
    surfaceGui.Face = Enum.NormalId.Front
    
    -- Text label
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 100
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Parent = surfaceGui
    
    -- Add to workspace
    part.Parent = workspace
    
    table.insert(spawnedObjects, part)
    
    -- Animate entrance
    part.Transparency = 1
    for i = 1, 10 do
        part.Transparency = 1 - (i/10)
        wait(0.02)
    end
    part.Transparency = 0
    
    print("✅ Spawned: " .. text .. " (" .. x .. "x" .. y .. "x" .. z .. ")")
end

-- Clear function
local function clearObjects()
    for _, obj in ipairs(spawnedObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    spawnedObjects = {}
    print("✅ Cleared all spawned objects")
end

-- ========== BUTTONS ==========

spawnBtn.MouseButton1Click:Connect(function()
    spawnObject()
end)

clearBtn.MouseButton1Click:Connect(function()
    clearObjects()
end)

-- ========== DRAGGING ==========
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

print("✅ Object Spawner Loaded")
print("📌 Enter text, size, color and hit SPAWN")
print("📌 Object spawns 20 studs in front of you")
print("📌 ONLY YOU can see it (client-side)")
