-- IMMORTALITY (All-in-One Protection)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Settings
local GOD_ENABLED = false
local HEAL_ENABLED = false
local ANTI_FLING_ENABLED = false
local ANTI_TP_ENABLED = false
local ANTI_FREEZE_ENABLED = false

-- Colors
local COLOR_OFF = Color3.fromRGB(220, 53, 69)
local COLOR_ON = Color3.fromRGB(40, 167, 69)

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ImmortalityGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 130, 0, 130)
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
local buttons = {}

local function createToggle(name, defaultState)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 22)
    btn.BackgroundColor3 = defaultState and COLOR_ON or COLOR_OFF
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    return btn
end

-- GOD MODE (ForceField + Health Lock)
local godBtn = createToggle("GOD MODE", false)

-- AUTO HEAL
local healBtn = createToggle("AUTO HEAL", false)

-- ANTI FLING
local flingBtn = createToggle("ANTI FLING", false)

-- ANTI TP KILL
local tpBtn = createToggle("ANTI TP KILL", false)

-- ANTI FREEZE
local freezeBtn = createToggle("ANTI FREEZE", false)

-- Connections table
local connections = {}
local forceField = nil

-- ========== GOD MODE ==========
local function enableGod()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
    
    -- Create ForceField
    if forceField then forceField:Destroy() end
    forceField = Instance.new("ForceField")
    forceField.Name = "GodForceField"
    forceField.Parent = character
    
    -- Anti-break joints
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BreakableJoint") or part:IsA("Motor6D") or part:IsA("Weld") then
            part.Anchored = false
        end
    end
end

local function disableGod()
    if forceField then
        forceField:Destroy()
        forceField = nil
    end
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end

-- ========== AUTO HEAL ==========
local function startHeal()
    connections.heal = RunService.Heartbeat:Connect(function()
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end
    end)
end

-- ========== ANTI FLING ==========
local function startAntiFling()
    connections.fling = RunService.Heartbeat:Connect(function()
        local character = player.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        -- Limit velocity
        local velocity = rootPart:FindFirstChild("Velocity")
        if velocity then
            velocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        -- Remove BodyMovers on others
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                for _, part in pairs(otherPlayer.Character:GetDescendants()) do
                    if part:IsA("BodyMover") or part:IsA("BodyVelocity") or part:IsA("BodyGyro") or part:IsA("BodyPosition") or part:IsA("BodyThrust") or part:IsA("BodyAngularVelocity") then
                        part:Destroy()
                    end
                end
            end
        end
        
        -- Cap rootPart velocity
        if rootPart.AssemblyLinearVelocity.Magnitude > 100 then
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
        
        -- Cap angular velocity
        if rootPart.AssemblyAngularVelocity.Magnitude > 50 then
            rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end)
end

-- ========== ANTI TP KILL ==========
local lastSafePosition = nil

local function startAntiTP()
    connections.tp = RunService.Heartbeat:Connect(function()
        local character = player.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        
        if rootPart and humanoid then
            -- If health suddenly drops and we're far from last safe position
            if humanoid.Health > 0 then
                lastSafePosition = rootPart.CFrame
            else
                -- Teleport back to safe position
                if lastSafePosition then
                    rootPart.CFrame = lastSafePosition
                    humanoid.Health = humanoid.MaxHealth
                end
            end
            
            -- Anti-void
            if rootPart.Position.Y < -100 then
                rootPart.CFrame = CFrame.new(0, 50, 0)
            end
        end
    end)
end

-- ========== ANTI FREEZE ==========
local function startAntiFreeze()
    connections.freeze = RunService.Heartbeat:Connect(function()
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            -- Unfreeze walkspeed
            if humanoid.WalkSpeed == 0 then
                humanoid.WalkSpeed = 16
            end
            
            -- Unfreeze jump
            if humanoid.JumpPower == 0 then
                humanoid.JumpPower = 50
            end
            
            -- Remove any ice/freeze effects
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BodyVelocity") or part:IsA("BodyGyro") or part:IsA("BodyPosition") then
                    if part.Name:lower():find("freeze") or part.Name:lower():find("ice") then
                        part:Destroy()
                    end
                end
            end
        end
    end)
end

-- ========== TOGGLE FUNCTIONS ==========
local function stopConnection(name)
    if connections[name] then
        connections[name]:Disconnect()
        connections[name] = nil
    end
end

godBtn.MouseButton1Click:Connect(function()
    GOD_ENABLED = not GOD_ENABLED
    godBtn.BackgroundColor3 = GOD_ENABLED and COLOR_ON or COLOR_OFF
    
    if GOD_ENABLED then
        enableGod()
        player.CharacterAdded:Connect(function()
            wait(0.5)
            if GOD_ENABLED then enableGod() end
        end)
    else
        disableGod()
    end
end)

healBtn.MouseButton1Click:Connect(function()
    HEAL_ENABLED = not HEAL_ENABLED
    healBtn.BackgroundColor3 = HEAL_ENABLED and COLOR_ON or COLOR_OFF
    
    if HEAL_ENABLED then
        startHeal()
    else
        stopConnection("heal")
    end
end)

flingBtn.MouseButton1Click:Connect(function()
    ANTI_FLING_ENABLED = not ANTI_FLING_ENABLED
    flingBtn.BackgroundColor3 = ANTI_FLING_ENABLED and COLOR_ON or COLOR_OFF
    
    if ANTI_FLING_ENABLED then
        startAntiFling()
    else
        stopConnection("fling")
    end
end)

tpBtn.MouseButton1Click:Connect(function()
    ANTI_TP_ENABLED = not ANTI_TP_ENABLED
    tpBtn.BackgroundColor3 = ANTI_TP_ENABLED and COLOR_ON or COLOR_OFF
    
    if ANTI_TP_ENABLED then
        startAntiTP()
    else
        stopConnection("tp")
        lastSafePosition = nil
    end
end)

freezeBtn.MouseButton1Click:Connect(function()
    ANTI_FREEZE_ENABLED = not ANTI_FREEZE_ENABLED
    freezeBtn.BackgroundColor3 = ANTI_FREEZE_ENABLED and COLOR_ON or COLOR_OFF
    
    if ANTI_FREEZE_ENABLED then
        startAntiFreeze()
    else
        stopConnection("freeze")
    end
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

print("✅ Immortality Script Loaded")
print("📌 Enable all toggles for maximum protection")
