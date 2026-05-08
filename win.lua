local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- Settings
getgenv().ReachSettings = {
    Size = 14.8,
    Enabled = false,
    AutoClicker = false,
    TeamCheck = false
}

local WhitelistedLimbs = {"Left Arm", "Right Arm", "Left Leg", "Right Leg", "Head", "Torso", "HumanoidRootPart"}

-- Notification function
local function Notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2
    })
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ReachHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main button
local mainBtn = Instance.new("TextButton")
mainBtn.Size = UDim2.new(0, 50, 0, 50)
mainBtn.Position = UDim2.new(0.5, -25, 0.5, -25)
mainBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainBtn.BorderColor3 = Color3.fromRGB(255, 100, 100)
mainBtn.BorderSizePixel = 2
mainBtn.Text = "⚔"
mainBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
mainBtn.Font = Enum.Font.GothamBold
mainBtn.TextSize = 24
mainBtn.Parent = screenGui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainBtn

-- Expanded panel
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 220, 0, 200)
panel.Position = UDim2.new(0.5, -110, 0.5, -100)
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
titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
titleLabel.Text = "⚔ Reach Hub"
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

-- Reach Size Input
local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(1, -20, 0, 18)
sizeLabel.Position = UDim2.new(0, 10, 0, 35)
sizeLabel.BackgroundTransparency = 1
sizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeLabel.Text = "Reach Size"
sizeLabel.Font = Enum.Font.GothamBold
sizeLabel.TextSize = 12
sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
sizeLabel.Parent = panel

local sizeInput = Instance.new("TextBox")
sizeInput.Size = UDim2.new(0, 60, 0, 24)
sizeInput.Position = UDim2.new(0, 10, 0, 56)
sizeInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeInput.Text = "14.8"
sizeInput.PlaceholderText = "14.8"
sizeInput.Font = Enum.Font.Gotham
sizeInput.TextSize = 12
sizeInput.Parent = panel
local sizeCorner = Instance.new("UICorner")
sizeCorner.CornerRadius = UDim.new(0, 6)
sizeCorner.Parent = sizeInput

local reachToggle = Instance.new("TextButton")
reachToggle.Size = UDim2.new(0, 70, 0, 24)
reachToggle.Position = UDim2.new(0, 80, 0, 56)
reachToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
reachToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
reachToggle.Text = "OFF"
reachToggle.Font = Enum.Font.GothamBold
reachToggle.TextSize = 11
reachToggle.Parent = panel
local reachCorner = Instance.new("UICorner")
reachCorner.CornerRadius = UDim.new(0, 6)
reachCorner.Parent = reachToggle

-- Auto Clicker Toggle
local acLabel = Instance.new("TextLabel")
acLabel.Size = UDim2.new(1, -20, 0, 18)
acLabel.Position = UDim2.new(0, 10, 0, 88)
acLabel.BackgroundTransparency = 1
acLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
acLabel.Text = "Auto Clicker"
acLabel.Font = Enum.Font.GothamBold
acLabel.TextSize = 12
acLabel.TextXAlignment = Enum.TextXAlignment.Left
acLabel.Parent = panel

local acToggle = Instance.new("TextButton")
acToggle.Size = UDim2.new(0, 70, 0, 24)
acToggle.Position = UDim2.new(0, 10, 0, 108)
acToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
acToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
acToggle.Text = "OFF"
acToggle.Font = Enum.Font.GothamBold
acToggle.TextSize = 11
acToggle.Parent = panel
local acCorner = Instance.new("UICorner")
acCorner.CornerRadius = UDim.new(0, 6)
acCorner.Parent = acToggle

-- Team Check Toggle
local teamLabel = Instance.new("TextLabel")
teamLabel.Size = UDim2.new(1, -20, 0, 18)
teamLabel.Position = UDim2.new(0, 10, 0, 138)
teamLabel.BackgroundTransparency = 1
teamLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
teamLabel.Text = "Team Check"
teamLabel.Font = Enum.Font.GothamBold
teamLabel.TextSize = 12
teamLabel.TextXAlignment = Enum.TextXAlignment.Left
teamLabel.Parent = panel

local teamToggle = Instance.new("TextButton")
teamToggle.Size = UDim2.new(0, 70, 0, 24)
teamToggle.Position = UDim2.new(0, 10, 0, 158)
teamToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
teamToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
teamToggle.Text = "OFF"
teamToggle.Font = Enum.Font.GothamBold
teamToggle.TextSize = 11
teamToggle.Parent = panel
local teamCorner = Instance.new("UICorner")
teamCorner.CornerRadius = UDim.new(0, 6)
teamCorner.Parent = teamToggle

-- DRAGGING FOR MAIN BUTTON
local mainDragging = false
local mainDragInput, mainDragStart, mainDragPos

mainBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        mainDragging = true
        mainDragStart = input.Position
        mainDragPos = mainBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                mainDragging = false
            end
        end)
    end
end)

mainBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        mainDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == mainDragInput and mainDragging then
        local delta = input.Position - mainDragStart
        mainBtn.Position = UDim2.new(mainDragPos.X.Scale, mainDragPos.X.Offset + delta.X, mainDragPos.Y.Scale, mainDragPos.Y.Offset + delta.Y)
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

-- TOGGLE FUNCTIONS
mainBtn.MouseButton1Click:Connect(function()
    mainBtn.Visible = false
    panel.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    mainBtn.Visible = true
end)

local function toggleReach()
    getgenv().ReachSettings.Enabled = not getgenv().ReachSettings.Enabled
    if getgenv().ReachSettings.Enabled then
        reachToggle.Text = "ON"
        reachToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        Notify("Reach", "Enabled")
    else
        reachToggle.Text = "OFF"
        reachToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        Notify("Reach", "Disabled")
    end
end

local function toggleAutoClicker()
    getgenv().ReachSettings.AutoClicker = not getgenv().ReachSettings.AutoClicker
    if getgenv().ReachSettings.AutoClicker then
        acToggle.Text = "ON"
        acToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        acToggle.Text = "OFF"
        acToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end

local function toggleTeamCheck()
    getgenv().ReachSettings.TeamCheck = not getgenv().ReachSettings.TeamCheck
    if getgenv().ReachSettings.TeamCheck then
        teamToggle.Text = "ON"
        teamToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        teamToggle.Text = "OFF"
        teamToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end

reachToggle.MouseButton1Click:Connect(toggleReach)
acToggle.MouseButton1Click:Connect(toggleAutoClicker)
teamToggle.MouseButton1Click:Connect(toggleTeamCheck)

sizeInput.FocusLost:Connect(function()
    local size = tonumber(sizeInput.Text) or 14.8
    if size < 1 then size = 1 end
    if size > 100 then size = 100 end
    getgenv().ReachSettings.Size = size
    sizeInput.Text = tostring(size)
end)

-- KEYBINDS (PC)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        toggleReach()
    elseif input.KeyCode == Enum.KeyCode.E then
        toggleAutoClicker()
    end
end)

-- HIT TRACKING - prevent hitting same target too fast
local recentHits = {}

local function FireTouch(targetChar, handle)
    local humanoid = targetChar:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    if targetChar.Name == LocalPlayer.Character.Name then return end
    
    -- Rate limit per target
    if recentHits[targetChar] and tick() - recentHits[targetChar] < 0.1 then
        return
    end
    recentHits[targetChar] = tick()
    
    -- Only hit actual body parts, not HumanoidRootPart directly
    for _, part in pairs(targetChar:GetChildren()) do
        if part:IsA("BasePart") then
            if table.find(WhitelistedLimbs, part.Name) and part.Name ~= "HumanoidRootPart" then
                firetouchinterest(part, handle, 0)
                firetouchinterest(part, handle, 1)
            end
        end
    end
end

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    if not getgenv().ReachSettings.Enabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    local handle = tool:FindFirstChild("Handle")
    if not handle then return end
    
    -- Auto clicker
    if getgenv().ReachSettings.AutoClicker then
        tool:Activate()
    end
    
    local size = getgenv().ReachSettings.Size
    
    -- Check all players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Team check
            if getgenv().ReachSettings.TeamCheck then
                if player.Team == LocalPlayer.Team then
                    -- Skip teammate
                else
                    local targetChar = player.Character
                    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local distance = (hrp.Position - handle.Position).Magnitude
                        if distance <= size then
                            FireTouch(targetChar, handle)
                        end
                    end
                end
            else
                local targetChar = player.Character
                local hrp = targetChar:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local distance = (hrp.Position - handle.Position).Magnitude
                    if distance <= size then
                        FireTouch(targetChar, handle)
                    end
                end
            end
        end
    end
end)

Notify("Reach Hub", "Loaded! Press R to toggle")
