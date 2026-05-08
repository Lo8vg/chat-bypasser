local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- Settings
local reachEnabled = false
local reachSize = 14
local autoClick = false
local teamCheck = false

local function Notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2
    })
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ReachHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

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
titleLabel.Text = "⚔ Invisible Reach"
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

-- Size Input
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
sizeInput.Text = "14"
sizeInput.PlaceholderText = "14"
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

-- Auto Clicker
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

-- Team Check
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

-- Dragging
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

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == mainDragInput and mainDragging then
        local delta = input.Position - mainDragStart
        mainBtn.Position = UDim2.new(mainDragPos.X.Scale, mainDragPos.X.Offset + delta.X, mainDragPos.Y.Scale, mainDragPos.Y.Offset + delta.Y)
    end
end)

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

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == panelDragInput and panelDragging then
        local delta = input.Position - panelDragStart
        panel.Position = UDim2.new(panelDragPos.X.Scale, panelDragPos.X.Offset + delta.X, panelDragPos.Y.Scale, panelDragPos.Y.Offset + delta.Y)
    end
end)

-- Toggle logic
mainBtn.MouseButton1Click:Connect(function()
    mainBtn.Visible = false
    panel.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    mainBtn.Visible = true
end)

reachToggle.MouseButton1Click:Connect(function()
    reachEnabled = not reachEnabled
    if reachEnabled then
        reachToggle.Text = "ON"
        reachToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        Notify("Reach", "Enabled")
    else
        reachToggle.Text = "OFF"
        reachToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        Notify("Reach", "Disabled")
    end
end)

acToggle.MouseButton1Click:Connect(function()
    autoClick = not autoClick
    if autoClick then
        acToggle.Text = "ON"
        acToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        acToggle.Text = "OFF"
        acToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end)

teamToggle.MouseButton1Click:Connect(function()
    teamCheck = not teamCheck
    if teamCheck then
        teamToggle.Text = "ON"
        teamToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        teamToggle.Text = "OFF"
        teamToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end)

sizeInput.FocusLost:Connect(function()
    local size = tonumber(sizeInput.Text) or 14
    if size < 1 then size = 1 end
    if size > 100 then size = 100 end
    reachSize = size
    sizeInput.Text = tostring(size)
end)

-- Keybinds
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.R then
        reachEnabled = not reachEnabled
        if reachEnabled then
            reachToggle.Text = "ON"
            reachToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
            Notify("Reach", "Enabled")
        else
            reachToggle.Text = "OFF"
            reachToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
            Notify("Reach", "Disabled")
        end
    end
end)

-- INVISIBLE HITBOX
local hitbox = nil
local connection = nil

local function createHitbox(tool)
    if hitbox then hitbox:Destroy() end
    
    local handle = tool:FindFirstChild("Handle")
    if not handle then return end
    
    -- Create invisible hitbox
    hitbox = Instance.new("Part")
    hitbox.Name = "ReachHitbox"
    hitbox.Size = Vector3.new(reachSize, reachSize, reachSize)
    hitbox.Transparency = 1
    hitbox.CanCollide = false
    hitbox.Massless = true
    hitbox.Anchored = false
    hitbox.Parent = workspace.CurrentCamera
    
    -- Attach to tool handle
    local weld = Instance.new("WeldConstraint")
    weld.Name = "HitboxWeld"
    weld.Part0 = hitbox
    weld.Part1 = handle
    weld.Parent = hitbox
    
    -- Track hits with cooldown
    local hitCooldowns = {}
    
    hitbox.Touched:Connect(function(hit)
        if not reachEnabled then return end
        
        local character = hit.Parent
        if not character then return end
        if character == LocalPlayer.Character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end
        
        -- Team check
        local player = Players:GetPlayerFromCharacter(character)
        if player and teamCheck and player.Team == LocalPlayer.Team then return end
        
        -- Cooldown per character
        if hitCooldowns[character] and tick() - hitCooldowns[character] < 0.2 then return end
        hitCooldowns[character] = tick()
        
        -- Fire touch to handle
        firetouchinterest(hit, handle, 0)
        firetouchinterest(hit, handle, 1)
    end)
end

local function removeHitbox()
    if hitbox then
        hitbox:Destroy()
        hitbox = nil
    end
end

-- Watch for tool equip/unequip
local function onCharacterAdded(character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            child.Equipped:Connect(function()
                if reachEnabled then
                    wait(0.1)
                    createHitbox(child)
                end
            end)
            child.Unequipped:Connect(function()
                removeHitbox()
            end)
        end
    end)
    
    -- Check if already holding tool
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("Tool") then
            if reachEnabled then
                createHitbox(child)
            end
        end
    end
end

if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Update hitbox size when reach changes
RunService.Heartbeat:Connect(function()
    if hitbox and reachEnabled then
        hitbox.Size = Vector3.new(reachSize, reachSize, reachSize)
    end
    
    -- Auto clicker
    if reachEnabled and autoClick then
        local character = LocalPlayer.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
        end
    end
end)

Notify("Invisible Reach", "Loaded! Press R to toggle")
