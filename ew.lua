-- INVISIBILITY (Decoy Mode)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Colors
local COLOR_OFF = Color3.fromRGB(220, 53, 69)
local COLOR_ON = Color3.fromRGB(40, 167, 69)

-- States
local INVISIBLE = false
local decoyClone = nil
local connections = {}

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InvisibilityGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 120, 0, 60)
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
title.Size = UDim2.new(1, -12, 0, 16)
title.BackgroundTransparency = 1
title.Text = "INVISIBLE"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 10
title.Parent = mainFrame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -12, 0, 24)
toggleBtn.BackgroundColor3 = COLOR_OFF
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 11
toggleBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 4)
btnCorner.Parent = toggleBtn

-- ========== FUNCTIONS ==========

local function makeInvisible(character)
    -- Set all parts invisible
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 1
        elseif part:IsA("Accessory") then
            for _, p in pairs(part:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Transparency = 1
                end
            end
        end
    end
    
    -- Face
    local head = character:FindFirstChild("Head")
    if head then
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 1 end
    end
end

local function makeVisible(character)
    -- Set all parts visible
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 0
        elseif part:IsA("Accessory") then
            for _, p in pairs(part:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Transparency = 0
                end
            end
        end
    end
    
    -- Face
    local head = character:FindFirstChild("Head")
    if head then
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 0 end
    end
end

local function createDecoy(character)
    -- Clone the character
    decoyClone = character:Clone()
    decoyClone.Name = "Decoy"
    
    -- Remove scripts and humanoids from decoy
    for _, script in pairs(decoyClone:GetDescendants()) do
        if script:IsA("Script") or script:IsA("LocalScript") then
            script:Destroy()
        end
    end
    
    local humanoid = decoyClone:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
    
    -- Parent decoy to workspace
    decoyClone.Parent = workspace
    
    -- Position decoy at current position
    decoyClone:SetPrimaryPartCFrame(character:GetPrimaryPartCFrame())
    
    return decoyClone
end

local function removeDecoy()
    if decoyClone then
        decoyClone:Destroy()
        decoyClone = nil
    end
end

local function enableInvisibility()
    local character = player.Character
    if not character then return end
    
    -- Create decoy at current position
    createDecoy(character)
    
    -- Make real character invisible
    makeInvisible(character)
    
    -- Keep decoy in place (freeze it)
    connections.decoyFreeze = RunService.Heartbeat:Connect(function()
        if decoyClone and decoyClone.PrimaryPart then
            -- Keep decoy frozen in place
            for _, part in pairs(decoyClone:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = true
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)
    
    -- Continuously make invisible (in case of respawn/reset)
    connections.invisLoop = RunService.Heartbeat:Connect(function()
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Transparency < 1 then
                    part.Transparency = 1
                end
            end
        end
    end)
end

local function disableInvisibility()
    -- Stop connections
    if connections.decoyFreeze then
        connections.decoyFreeze:Disconnect()
        connections.decoyFreeze = nil
    end
    if connections.invisLoop then
        connections.invisLoop:Disconnect()
        connections.invisLoop = nil
    end
    
    -- Remove decoy
    removeDecoy()
    
    -- Make character visible again
    local character = player.Character
    if character then
        makeVisible(character)
    end
end

-- ========== TOGGLE ==========

toggleBtn.MouseButton1Click:Connect(function()
    INVISIBLE = not INVISIBLE
    
    if INVISIBLE then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = COLOR_ON
        enableInvisibility()
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = COLOR_OFF
        disableInvisibility()
    end
end)

-- Cleanup on respawn
player.CharacterAdded:Connect(function()
    if INVISIBLE then
        wait(0.5)
        local character = player.Character
        if character then
            createDecoy(character)
            makeInvisible(character)
        end
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

print("✅ Invisibility Loaded")
print("📌 Toggle ON to become invisible + create decoy")
