-- IMMORTALITY (Hardcore Version)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Colors
local COLOR_OFF = Color3.fromRGB(220, 53, 69)
local COLOR_ON = Color3.fromRGB(40, 167, 69)

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ImmortalityGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 140, 0, 100)
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
mfPadding.PaddingLeft = UDim.new(0, 6)
mfPadding.PaddingRight = UDim.new(0, 6)
mfPadding.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -12, 0, 18)
title.BackgroundTransparency = 1
title.Text = "IMMORTALITY"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.Parent = mainFrame

-- Buttons
local godBtn = Instance.new("TextButton")
godBtn.Size = UDim2.new(1, -12, 0, 22)
godBtn.BackgroundColor3 = COLOR_OFF
godBtn.BorderSizePixel = 0
godBtn.Text = "GOD MODE"
godBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
godBtn.Font = Enum.Font.GothamBold
godBtn.TextSize = 10
godBtn.Parent = mainFrame

local godCorner = Instance.new("UICorner")
godCorner.CornerRadius = UDim.new(0, 4)
godCorner.Parent = godBtn

local healthBtn = Instance.new("TextButton")
healthBtn.Size = UDim2.new(1, -12, 0, 22)
healthBtn.BackgroundColor3 = COLOR_OFF
healthBtn.BorderSizePixel = 0
healthBtn.Text = "HEALTH LOCK"
healthBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
healthBtn.Font = Enum.Font.GothamBold
healthBtn.TextSize = 10
healthBtn.Parent = mainFrame

local healthCorner = Instance.new("UICorner")
healthCorner.CornerRadius = UDim.new(0, 4)
healthCorner.Parent = healthBtn

local maxHealthBtn = Instance.new("TextButton")
maxHealthBtn.Size = UDim2.new(1, -12, 0, 22)
maxHealthBtn.BackgroundColor3 = COLOR_OFF
maxHealthBtn.BorderSizePixel = 0
maxHealthBtn.Text = "INFINITE HP"
maxHealthBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
maxHealthBtn.Font = Enum.Font.GothamBold
maxHealthBtn.TextSize = 10
maxHealthBtn.Parent = mainFrame

local maxCorner = Instance.new("UICorner")
maxCorner.CornerRadius = UDim.new(0, 4)
maxCorner.Parent = maxHealthBtn

-- States
local GOD_ENABLED = false
local HEALTH_LOCK_ENABLED = false
local INFINITE_HP_ENABLED = false

local connections = {}
local forceField = nil

-- ========== GOD MODE (ForceField) ==========
local function enableGod()
    local character = player.Character
    if character then
        -- Remove old FF
        local oldFF = character:FindFirstChild("GodForceField")
        if oldFF then oldFF:Destroy() end
        
        -- Create new ForceField
        forceField = Instance.new("ForceField")
        forceField.Name = "GodForceField"
        forceField.Parent = character
    end
end

local function disableGod()
    if forceField then
        forceField:Destroy()
        forceField = nil
    end
    local character = player.Character
    if character then
        local ff = character:FindFirstChild("GodForceField")
        if ff then ff:Destroy() end
    end
end

-- ========== HEALTH LOCK (Locks health EVERY frame) ==========
local function enableHealthLock()
    connections.healthLock = RunService.Heartbeat:Connect(function()
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                -- Always set health to max
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end
    end)
end

local function disableHealthLock()
    if connections.healthLock then
        connections.healthLock:Disconnect()
        connections.healthLock = nil
    end
end

-- ========== INFINITE HP (Sets maxhealth to huge) ==========
local function enableInfiniteHP()
    connections.infiniteHP = RunService.Heartbeat:Connect(function()
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                -- Set max health to huge number
                if humanoid.MaxHealth ~= math.huge then
                    humanoid.MaxHealth = math.huge
                end
                -- Set health to huge
                if humanoid.Health ~= math.huge then
                    humanoid.Health = math.huge
                end
            end
        end
    end)
    
    -- Also set on current character
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end
end

local function disableInfiniteHP()
    if connections.infiniteHP then
        connections.infiniteHP:Disconnect()
        connections.infiniteHP = nil
    end
    -- Reset health
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end

-- ========== TOGGLES ==========
godBtn.MouseButton1Click:Connect(function()
    GOD_ENABLED = not GOD_ENABLED
    godBtn.BackgroundColor3 = GOD_ENABLED and COLOR_ON or COLOR_OFF
    
    if GOD_ENABLED then
        enableGod()
    else
        disableGod()
    end
end)

healthBtn.MouseButton1Click:Connect(function()
    HEALTH_LOCK_ENABLED = not HEALTH_LOCK_ENABLED
    healthBtn.BackgroundColor3 = HEALTH_LOCK_ENABLED and COLOR_ON or COLOR_OFF
    
    if HEALTH_LOCK_ENABLED then
        enableHealthLock()
    else
        disableHealthLock()
    end
end)

maxHealthBtn.MouseButton1Click:Connect(function()
    INFINITE_HP_ENABLED = not INFINITE_HP_ENABLED
    maxHealthBtn.BackgroundColor3 = INFINITE_HP_ENABLED and COLOR_ON or COLOR_OFF
    
    if INFINITE_HP_ENABLED then
        enableInfiniteHP()
    else
        disableInfiniteHP()
    end
end)

-- Re-apply on respawn
player.CharacterAdded:Connect(function(character)
    wait(0.5)
    if GOD_ENABLED then enableGod() end
    -- Health lock and infinite HP auto-run via heartbeat, no need to re-apply
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

print("✅ Hardcore Immortality Loaded")
print("📌 Enable all 3 for maximum protection")
print("📌 If still dying, tell me what game")
