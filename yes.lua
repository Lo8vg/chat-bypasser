-- CHARACTER DESYNC

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Colors
local COLOR_OFF = Color3.fromRGB(220, 53, 69)
local COLOR_ON = Color3.fromRGB(40, 167, 69)

-- States
local DESYNC_ENABLED = false
local connections = {}

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DesyncGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 140, 0, 110)
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

-- Desync Toggle
local desyncBtn = Instance.new("TextButton")
desyncBtn.Size = UDim2.new(1, -12, 0, 24)
desyncBtn.BackgroundColor3 = COLOR_OFF
desyncBtn.BorderSizePixel = 0
desyncBtn.Text = "DESYNC: OFF"
desyncBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
desyncBtn.Font = Enum.Font.GothamBold
desyncBtn.TextSize = 10
desyncBtn.Parent = mainFrame

local dCorner = Instance.new("UICorner")
dCorner.CornerRadius = UDim.new(0, 4)
dCorner.Parent = desyncBtn

-- Desync Type Label
local typeLabel = Instance.new("TextLabel")
typeLabel.Size = UDim2.new(1, -12, 0, 16)
typeLabel.BackgroundTransparency = 1
typeLabel.Text = "Method: Velocity Spam"
typeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
typeLabel.Font = Enum.Font.Gotham
typeLabel.TextSize = 9
typeLabel.Parent = mainFrame

-- Strength Slider
local strengthFrame = Instance.new("Frame")
strengthFrame.Size = UDim2.new(1, -12, 0, 24)
strengthFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
strengthFrame.Parent = mainFrame

local sfCorner = Instance.new("UICorner")
sfCorner.CornerRadius = UDim.new(0, 4)
sfCorner.Parent = strengthFrame

local strengthLabel = Instance.new("TextLabel")
strengthLabel.Size = UDim2.new(1, -8, 0, 10)
strengthLabel.Position = UDim2.new(0, 4, 0, 2)
strengthLabel.BackgroundTransparency = 1
strengthLabel.Text = "Strength: 100"
strengthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
strengthLabel.Font = Enum.Font.Gotham
strengthLabel.TextSize = 8
strengthLabel.TextXAlignment = Enum.TextXAlignment.Left
strengthLabel.Parent = strengthFrame

local strengthSlider = Instance.new("TextButton")
strengthSlider.Size = UDim2.new(1, -8, 0, 8)
strengthSlider.Position = UDim2.new(0, 4, 0, 14)
strengthSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
strengthSlider.Text = ""
strengthSlider.Parent = strengthFrame

local ssCorner = Instance.new("UICorner")
ssCorner.CornerRadius = UDim.new(0, 2)
ssCorner.Parent = strengthSlider

local strengthFill = Instance.new("Frame")
strengthFill.Size = UDim2.new(0.5, 0, 1, 0)
strengthFill.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
strengthFill.Parent = strengthSlider

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 2)
fillCorner.Parent = strengthFill

local desyncStrength = 100

-- ========== FUNCTIONS ==========

local function enableDesync()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not rootPart or not humanoid then return end
    
    -- Method 1: AssemblyLinearVelocity spam
    connections.velocitySpam = RunService.Heartbeat:Connect(function()
        if rootPart and rootPart.Parent then
            -- Spam random velocities to desync position
            rootPart.AssemblyLinearVelocity = Vector3.new(
                math.random(-desyncStrength * 100, desyncStrength * 100),
                math.random(-desyncStrength * 50, desyncStrength * 50),
                math.random(-desyncStrength * 100, desyncStrength * 100)
            )
        end
    end)
    
    -- Method 2: Network ownership exploit
    connections.networkDesync = RunService.RenderStepped:Connect(function()
        if rootPart and rootPart.Parent then
            -- Force network ownership conflicts
            rootPart.Velocity = Vector3.new(
                math.random(-desyncStrength * 10, desyncStrength * 10),
                0,
                math.random(-desyncStrength * 10, desyncStrength * 10)
            )
            
            -- Random angular velocity
            rootPart.RotVelocity = Vector3.new(
                math.random(-desyncStrength, desyncStrength),
                math.random(-desyncStrength, desyncStrength),
                math.random(-desyncStrength, desyncStrength)
            )
        end
    end)
    
    -- Method 3: CFrame jitter
    connections.cframeJitter = RunService.Heartbeat:Connect(function(deltaTime)
        if rootPart and rootPart.Parent then
            local currentCFrame = rootPart.CFrame
            -- Small jitter that doesn't affect client movement but desyncs server
            rootPart.CFrame = currentCFrame * CFrame.new(
                math.random(-desyncStrength / 100, desyncStrength / 100),
                0,
                math.random(-desyncStrength / 100, desyncStrength / 100)
            )
        end
    end)
    
    -- Method 4: Tool desync (if holding tool)
    connections.toolDesync = RunService.Heartbeat:Connect(function()
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            local handle = tool:FindFirstChild("Handle")
            if handle and handle:IsA("BasePart") then
                handle.Velocity = Vector3.new(
                    math.random(-desyncStrength * 50, desyncStrength * 50),
                    math.random(-desyncStrength * 50, desyncStrength * 50),
                    math.random(-desyncStrength * 50, desyncStrength * 50)
                )
            end
        end
    end)
    
    -- Method 5: Humanoid state desync
    connections.humanoidDesync = RunService.Heartbeat:Connect(function()
        if humanoid then
            -- Constantly change walkspeed to confuse server
            humanoid.WalkSpeed = 16 + math.random(-2, 2)
        end
    end)
end

local function disableDesync()
    -- Disconnect all
    for name, conn in pairs(connections) do
        conn:Disconnect()
        connections[name] = nil
    end
    
    -- Reset character
    local character = player.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        
        if rootPart then
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            rootPart.Velocity = Vector3.new(0, 0, 0)
            rootPart.RotVelocity = Vector3.new(0, 0, 0)
        end
        
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
end

-- ========== STRENGTH SLIDER ==========

local sliderDragging = false

strengthSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        local pos = math.clamp((input.Position.X - strengthSlider.AbsolutePosition.X) / strengthSlider.AbsoluteSize.X, 0, 1)
        desyncStrength = math.floor(1 + pos * 199)
        strengthFill.Size = UDim2.new(pos, 0, 1, 0)
        strengthLabel.Text = "Strength: " .. desyncStrength
    end
end)

strengthSlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if sliderDragging then
        local pos = math.clamp((input.Position.X - strengthSlider.AbsolutePosition.X) / strengthSlider.AbsoluteSize.X, 0, 1)
        desyncStrength = math.floor(1 + pos * 199)
        strengthFill.Size = UDim2.new(pos, 0, 1, 0)
        strengthLabel.Text = "Strength: " .. desyncStrength
    end
end)

-- ========== TOGGLE ==========

desyncBtn.MouseButton1Click:Connect(function()
    DESYNC_ENABLED = not DESYNC_ENABLED
    
    if DESYNC_ENABLED then
        local character = player.Character
        if character then
            desyncBtn.Text = "DESYNC: ON"
            desyncBtn.BackgroundColor3 = COLOR_ON
            enableDesync()
        else
            DESYNC_ENABLED = false
        end
    else
        desyncBtn.Text = "DESYNC: OFF"
        desyncBtn.BackgroundColor3 = COLOR_OFF
        disableDesync()
    end
end)

-- Re-enable on respawn
player.CharacterAdded:Connect(function()
    wait(0.5)
    if DESYNC_ENABLED then
        enableDesync()
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

print("✅ Character Desync Loaded")
print("📌 Toggle ON to desync your character")
print("📌 Other players will see you glitching/teleporting")
print("📌 You can still move and attack normally")
