local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Default values
local DEFAULT_SPEED = 25
local DEFAULT_GRAVITY = 85

-- Current states (these persist)
local speedEnabled = false
local gravityEnabled = false
local currentSpeed = DEFAULT_SPEED
local currentGravity = DEFAULT_GRAVITY

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
speedLabel.Text = "Speed (default: 25)"
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 12
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = panel

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 60, 0, 24)
speedInput.Position = UDim2.new(0, 10, 0, 58)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Text = "25"
speedInput.PlaceholderText = "25"
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
gravityLabel.Text = "Gravity (196=normal, higher=faster)"
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

-- FUNCTIONS
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

local function applyAllSettings()
    -- Reapply speed if enabled
    if speedEnabled then
        setSpeed(currentSpeed)
    else
        setSpeed(DEFAULT_SPEED)
    end
    
    -- Reapply gravity if enabled
    if gravityEnabled then
        setGravity(currentGravity)
    else
        setGravity(DEFAULT_GRAVITY)
    end
end

local function toggleSpeed()
    speedEnabled = not speedEnabled
    if speedEnabled then
        local speed = tonumber(speedInput.Text) or DEFAULT_SPEED
        if speed < 1 then speed = 1 end
        if speed > 500 then speed = 500 end
        currentSpeed = speed
        speedInput.Text = tostring(speed)
        setSpeed(speed)
        speedToggle.Text = "ON"
        speedToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        setSpeed(DEFAULT_SPEED)
        speedToggle.Text = "OFF"
        speedToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end

local function toggleGravity()
    gravityEnabled = not gravityEnabled
    if gravityEnabled then
        local gravity = tonumber(gravityInput.Text) or DEFAULT_GRAVITY
        if gravity < 0 then gravity = 0 end
        if gravity > 1000 then gravity = 1000 end
        currentGravity = gravity
        gravityInput.Text = tostring(math.floor(gravity))
        setGravity(gravity)
        gravityToggle.Text = "ON"
        gravityToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        setGravity(DEFAULT_GRAVITY)
        gravityToggle.Text = "OFF"
        gravityToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end

local function resetAll()
    speedEnabled = false
    gravityEnabled = false
    currentSpeed = DEFAULT_SPEED
    currentGravity = DEFAULT_GRAVITY
    setSpeed(DEFAULT_SPEED)
    setGravity(DEFAULT_GRAVITY)
    speedToggle.Text = "OFF"
    speedToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    gravityToggle.Text = "OFF"
    gravityToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    speedInput.Text = "25"
    gravityInput.Text = "196"
end

-- Character respawn handling - REAPPLY SETTINGS
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid", 5)
    wait(0.1)
    applyAllSettings()
end)

-- Also apply on spawn if character already exists
if player.Character then
    local humanoid = player.Character:WaitForChild("Humanoid", 5)
    if humanoid then
        applyAllSettings()
    end
end

-- Event connections
speedToggle.MouseButton1Click:Connect(toggleSpeed)
gravityToggle.MouseButton1Click:Connect(toggleGravity)
resetBtn.MouseButton1Click:Connect(resetAll)

-- Toggle panel with button click
mainButton.MouseButton1Click:Connect(function()
    mainButton.Visible = false
    panel.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    mainButton.Visible = true
end)

-- Update speed when input changes (if enabled)
speedInput.FocusLost:Connect(function()
    if speedEnabled then
        local speed = tonumber(speedInput.Text) or DEFAULT_SPEED
        if speed < 1 then speed = 1 end
        if speed > 500 then speed = 500 end
        currentSpeed = speed
        speedInput.Text = tostring(speed)
        setSpeed(speed)
    end
end)

gravityInput.FocusLost:Connect(function()
    if gravityEnabled then
        local gravity = tonumber(gravityInput.Text) or DEFAULT_GRAVITY
        if gravity < 0 then gravity = 0 end
        if gravity > 1000 then gravity = 1000 end
        currentGravity = gravity
        gravityInput.Text = tostring(math.floor(gravity))
        setGravity(gravity)
    end
end)

-- DRAGGING FOR MAIN BUTTON
local mainDragging = false
local mainDragInput, mainDragStart, mainDragPos

mainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        mainDragging = true
        mainDragStart = input.Position
        mainDragPos = mainButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                mainDragging = false
            end
        end)
    end
end)

mainButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        mainDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == mainDragInput and mainDragging then
        local delta = input.Position - mainDragStart
        mainButton.Position = UDim2.new(mainDragPos.X.Scale, mainDragPos.X.Offset + delta.X, mainDragPos.Y.Scale, mainDragPos.Y.Offset + delta.Y)
    end
end)

-- DRAGGING FOR PANEL
local panelDragging = false
local panelDragInput, panelDragStart, panelDragPos

panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        panelDragging = true
        panelDragStart = input.Position
        panelDragPos = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                panelDragging = false
            end
        end)
    end
end)

panel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        panelDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == panelDragInput and panelDragging then
        local delta = input.Position - panelDragStart
        panel.Position = UDim2.new(panelDragPos.X.Scale, panelDragPos.X.Offset + delta.X, panelDragPos.Y.Scale, panelDragPos.Y.Offset + delta.Y)
    end
end)

print("✅ Utility Hub Loaded - Speed & Gravity persist after death")
