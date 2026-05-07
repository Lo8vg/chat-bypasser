local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Store original values
local originalWalkSpeed = 16
local originalGravity = 196.2

-- Current states
local speedEnabled = false
local gravityEnabled = false
local currentSpeed = 16
local currentGravity = 196.2

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UtilityHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main small button (collapsed state)
local mainButton = Instance.new("TextButton")
mainButton.Name = "MainButton"
mainButton.Size = UDim2.new(0, 50, 0, 50)
mainButton.Position = UDim2.new(0.5, -25, 0.5, -25)
mainButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainButton.BorderColor3 = Color3.fromRGB(0, 120, 215)
mainButton.BorderSizePixel = 2
mainButton.Text = "⚡"
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.Font = Enum.Font.GothamBold
mainButton.TextSize = 24
mainButton.Parent = screenGui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainButton

-- Expanded panel (hidden by default)
local panel = Instance.new("Frame")
panel.Name = "ExpandedPanel"
panel.Size = UDim2.new(0, 200, 0, 180)
panel.Position = UDim2.new(0.5, -100, 0.5, -90)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
panel.BorderColor3 = Color3.fromRGB(60, 60, 60)
panel.BorderSizePixel = 2
panel.Visible = false
panel.Parent = screenGui
local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 8)
panelCorner.Parent = panel

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = panel
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -30, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "⚡ Utility Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -26, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = titleBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Speed section
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 35)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Text = "Speed"
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 12
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = panel

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 60, 0, 24)
speedInput.Position = UDim2.new(0, 10, 0, 58)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Text = "16"
speedInput.PlaceholderText = "16"
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 12
speedInput.Parent = panel
local speedInputCorner = Instance.new("UICorner")
speedInputCorner.CornerRadius = UDim.new(0, 6)
speedInputCorner.Parent = speedInput

local speedToggle = Instance.new("TextButton")
speedToggle.Size = UDim2.new(0, 60, 0, 24)
speedToggle.Position = UDim2.new(0, 80, 0, 58)
speedToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.Text = "OFF"
speedToggle.Font = Enum.Font.GothamBold
speedToggle.TextSize = 11
speedToggle.Parent = panel
local speedToggleCorner = Instance.new("UICorner")
speedToggleCorner.CornerRadius = UDim.new(0, 6)
speedToggleCorner.Parent = speedToggle

-- Gravity section
local gravityLabel = Instance.new("TextLabel")
gravityLabel.Size = UDim2.new(1, -20, 0, 20)
gravityLabel.Position = UDim2.new(0, 10, 0, 90)
gravityLabel.BackgroundTransparency = 1
gravityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityLabel.Text = "Gravity (default: 196)"
gravityLabel.Font = Enum.Font.GothamBold
gravityLabel.TextSize = 12
gravityLabel.TextXAlignment = Enum.TextXAlignment.Left
gravityLabel.Parent = panel

local gravityInput = Instance.new("TextBox")
gravityInput.Size = UDim2.new(0, 60, 0, 24)
gravityInput.Position = UDim2.new(0, 10, 0, 113)
gravityInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
gravityInput.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityInput.Text = "196"
gravityInput.PlaceholderText = "196"
gravityInput.Font = Enum.Font.Gotham
gravityInput.TextSize = 12
gravityInput.Parent = panel
local gravityInputCorner = Instance.new("UICorner")
gravityInputCorner.CornerRadius = UDim.new(0, 6)
gravityInputCorner.Parent = gravityInput

local gravityToggle = Instance.new("TextButton")
gravityToggle.Size = UDim2.new(0, 60, 0, 24)
gravityToggle.Position = UDim2.new(0, 80, 0, 113)
gravityToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
gravityToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityToggle.Text = "OFF"
gravityToggle.Font = Enum.Font.GothamBold
gravityToggle.TextSize = 11
gravityToggle.Parent = panel
local gravityToggleCorner = Instance.new("UICorner")
gravityToggleCorner.CornerRadius = UDim.new(0, 6)
gravityToggleCorner.Parent = gravityToggle

-- Reset button
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(1, -20, 0, 24)
resetBtn.Position = UDim2.new(0, 10, 1, -34)
resetBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.Text = "Reset All"
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 11
resetBtn.Parent = panel
local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 6)
resetCorner.Parent = resetBtn

-- Functionality
local function setSpeed(speed)
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end
end

local function setGravity(gravity)
    workspace.Gravity = gravity
end

local function toggleSpeed()
    speedEnabled = not speedEnabled
    if speedEnabled then
        local speed = tonumber(speedInput.Text) or 16
        currentSpeed = speed
        setSpeed(speed)
        speedToggle.Text = "ON"
        speedToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        setSpeed(16)
        speedToggle.Text = "OFF"
        speedToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end

local function toggleGravity()
    gravityEnabled = not gravityEnabled
    if gravityEnabled then
        local gravity = tonumber(gravityInput.Text) or 196.2
        currentGravity = gravity
        setGravity(gravity)
        gravityToggle.Text = "ON"
        gravityToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        setGravity(196.2)
        gravityToggle.Text = "OFF"
        gravityToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end

local function resetAll()
    speedEnabled = false
    gravityEnabled = false
    setSpeed(16)
    setGravity(196.2)
    speedToggle.Text = "OFF"
    speedToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    gravityToggle.Text = "OFF"
    gravityToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    speedInput.Text = "16"
    gravityInput.Text = "196"
end

-- Event connections
mainButton.MouseButton1Click:Connect(function()
    mainButton.Visible = false
    panel.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    mainButton.Visible = true
end)

speedToggle.MouseButton1Click:Connect(toggleSpeed)
gravityToggle.MouseButton1Click:Connect(toggleGravity)
resetBtn.MouseButton1Click:Connect(resetAll)

-- Update speed when input changes (if enabled)
speedInput.FocusLost:Connect(function()
    if speedEnabled then
        local speed = tonumber(speedInput.Text) or 16
        setSpeed(speed)
    end
end)

gravityInput.FocusLost:Connect(function()
    if gravityEnabled then
        local gravity = tonumber(gravityInput.Text) or 196.2
        setGravity(gravity)
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(character)
    if speedEnabled then
        wait(0.5) -- Wait for character to load
        setSpeed(currentSpeed)
    end
end)

-- Dragging
local dragging = false
local dragInput, dragStart, startPos

mainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Only drag, not toggle
    end
end)

panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

panel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("✅ Utility Hub Loaded")
