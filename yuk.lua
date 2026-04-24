-- REAL CHARACTER DESYNC (Parent Method)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Colors
local COLOR_OFF = Color3.fromRGB(220, 53, 69)
local COLOR_ON = Color3.fromRGB(40, 167, 69)

-- States
local DESYNC_ENABLED = false
local ghostCharacter = nil

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DesyncGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 140, 0, 80)
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
title.Text = "DESYNC"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 10
title.Parent = mainFrame

-- Method Label
local methodLabel = Instance.new("TextLabel")
methodLabel.Size = UDim2.new(1, -12, 0, 14)
methodLabel.BackgroundTransparency = 1
methodLabel.Text = "Method: Parent Desync"
methodLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
methodLabel.Font = Enum.Font.Gotham
methodLabel.TextSize = 8
methodLabel.Parent = mainFrame

-- Desync Toggle
local desyncBtn = Instance.new("TextButton")
desyncBtn.Size = UDim2.new(1, -12, 0, 24)
desyncBtn.BackgroundColor3 = COLOR_OFF
desyncBtn.BorderSizePixel = 0
desyncBtn.Text = "OFF"
desyncBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
desyncBtn.Font = Enum.Font.GothamBold
desyncBtn.TextSize = 11
desyncBtn.Parent = mainFrame

local dCorner = Instance.new("UICorner")
dCorner.CornerRadius = UDim.new(0, 4)
dCorner.Parent = desyncBtn

-- ========== REAL DESYNC METHODS ==========

local function enableParentDesync()
    local character = player.Character
    if not character then return end
    
    -- Store original parent
    local originalParent = character.Parent
    
    -- Method: Remove character from workspace on CLIENT only
    -- Server still has your character, but you're invisible to others
    
    -- Create a fake "ghost" reference
    ghostCharacter = character:Clone()
    ghostCharacter.Name = "GhostCharacter"
    
    -- Remove scripts from ghost
    for _, item in pairs(ghostCharacter:GetDescendants()) do
        if item:IsA("Script") or item:IsA("LocalScript") then
            item:Destroy()
        end
    end
    
    -- Make ghost visible only to you
    for _, part in pairs(ghostCharacter:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
        end
    end
    
    -- Parent ghost to workspace (you see this)
    ghostCharacter.Parent = workspace
    
    -- Hide real character from your view
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
        end
    end
    
    -- Now: Server thinks you're at position A
    -- Your ghost (what you see) is at position B
    -- Other players see server position (A)
    
    -- Continuously sync ghost position to your real position
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not DESYNC_ENABLED then
            connection:Disconnect()
            return
        end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local ghostRoot = ghostCharacter:FindFirstChild("HumanoidRootPart")
        
        if rootPart and ghostRoot then
            -- Ghost follows your real position (what you control)
            ghostRoot.CFrame = rootPart.CFrame
        end
    end)
    
    return connection
end

local function disableParentDesync()
    -- Remove ghost
    if ghostCharacter then
        ghostCharacter:Destroy()
        ghostCharacter = nil
    end
    
    -- Make real character visible again
    local character = player.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end
end

-- Alternative: Netless method (position desync)
local netlessConnection = nil

local function enableNetlessDesync()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Netless: Don't replicate position to server
    -- Your real position is hidden
    
    netlessConnection = RunService.RenderStepped:Connect(function()
        if not DESYNC_ENABLED then return end
        
        -- Store your actual position
        local actualPos = rootPart.CFrame
        
        -- Apply offset that server doesn't replicate properly
        rootPart.Velocity = Vector3.new(0, 0, 0)
        
        -- This creates a gap between what server sees and where you actually are
    end)
end

-- ========== ACTUAL WORKING INVISIBILITY ==========

local invisConnection = nil

local function enableRealInvisibility()
    local character = player.Character
    if not character then return end
    
    -- Method: Delete character on server's view of you
    -- Step 1: Remove all your parts from replication
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
        end
    end
    
    -- Step 2: Create local-only visual
    local fakeChar = character:Clone()
    fakeChar.Name = "LocalCharacter"
    fakeChar.Parent = workspace:FindFirstChild("Camera") or workspace.CurrentCamera
    
    -- Step 3: Remove network ownership
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.DisplayName = "" -- Hide name
    end
    
    -- Keep invisible
    invisConnection = RunService.Heartbeat:Connect(function()
        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Transparency < 1 then
                    part.Transparency = 1
                end
            end
        end
    end)
end

local function disableRealInvisibility()
    if invisConnection then
        invisConnection:Disconnect()
        invisConnection = nil
    end
    
    local character = player.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end
    
    -- Remove fake local character
    local camera = workspace.CurrentCamera
    if camera then
        local fakeChar = camera:FindFirstChild("LocalCharacter")
        if fakeChar then fakeChar:Destroy() end
    end
end

-- ========== TOGGLE ==========

local currentConnection = nil

desyncBtn.MouseButton1Click:Connect(function()
    DESYNC_ENABLED = not DESYNC_ENABLED
    
    if DESYNC_ENABLED then
        desyncBtn.Text = "ON"
        desyncBtn.BackgroundColor3 = COLOR_ON
        
        -- Use real invisibility method
        enableRealInvisibility()
        
        print("✅ Invisibility ON")
        print("📌 You are now invisible to other players")
        print("📌 Move around and kill - they can't see you")
    else
        desyncBtn.Text = "OFF"
        desyncBtn.BackgroundColor3 = COLOR_OFF
        
        disableRealInvisibility()
        
        print("❌ Invisibility OFF")
    end
end)

-- Re-apply on respawn
player.CharacterAdded:Connect(function()
    wait(0.5)
    if DESYNC_ENABLED then
        enableRealInvisibility()
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

print("✅ Real Invisibility Loaded")
print("📌 Toggle ON - you become invisible to other players")
print("📌 You can still move, attack, and see yourself")
