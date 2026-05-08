local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Settings (persistent)
local viewEnabled = false
local targetUsername = ""
local currentTarget = nil

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ViewHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main button
local mainBtn = Instance.new("TextButton")
mainBtn.Size = UDim2.new(0, 50, 0, 50)
mainBtn.Position = UDim2.new(0.5, -25, 0.5, -25)
mainBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainBtn.BorderColor3 = Color3.fromRGB(100, 200, 255)
mainBtn.BorderSizePixel = 2
mainBtn.Text = "👁"
mainBtn.TextColor3 = Color3.fromRGB(100, 200, 255)
mainBtn.Font = Enum.Font.GothamBold
mainBtn.TextSize = 24
mainBtn.Parent = screenGui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainBtn

-- Expanded panel
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 240, 0, 140)
panel.Position = UDim2.new(0.5, -120, 0.5, -70)
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
titleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
titleLabel.Text = "👁 View Player"
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

-- Username input
local userLabel = Instance.new("TextLabel")
userLabel.Size = UDim2.new(1, -20, 0, 18)
userLabel.Position = UDim2.new(0, 10, 0, 35)
userLabel.BackgroundTransparency = 1
userLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
userLabel.Text = "Username / Display Name"
userLabel.Font = Enum.Font.GothamBold
userLabel.TextSize = 12
userLabel.TextXAlignment = Enum.TextXAlignment.Left
userLabel.Parent = panel

local userInput = Instance.new("TextBox")
userInput.Size = UDim2.new(1, -20, 0, 28)
userInput.Position = UDim2.new(0, 10, 0, 56)
userInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
userInput.TextColor3 = Color3.fromRGB(255, 255, 255)
userInput.Text = ""
userInput.PlaceholderText = "Enter username..."
userInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
userInput.Font = Enum.Font.Gotham
userInput.TextSize = 12
userInput.Parent = panel
local userCorner = Instance.new("UICorner")
userCorner.CornerRadius = UDim.new(0, 6)
userCorner.Parent = userInput

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 16)
statusLabel.Position = UDim2.new(0, 10, 0, 88)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Text = "Not viewing anyone"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = panel

-- View toggle
local viewToggle = Instance.new("TextButton")
viewToggle.Size = UDim2.new(1, -20, 0, 28)
viewToggle.Position = UDim2.new(0, 10, 1, -38)
viewToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
viewToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
viewToggle.Text = "VIEW: OFF"
viewToggle.Font = Enum.Font.GothamBold
viewToggle.TextSize = 12
viewToggle.Parent = panel
local viewCorner = Instance.new("UICorner")
viewCorner.CornerRadius = UDim.new(0, 6)
viewCorner.Parent = viewToggle

-- DRAGGING MAIN BUTTON
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

-- DRAGGING PANEL
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

-- TOGGLE PANEL
mainBtn.MouseButton1Click:Connect(function()
    mainBtn.Visible = false
    panel.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    mainBtn.Visible = true
end)

-- FIND PLAYER BY USERNAME OR DISPLAY NAME
local function findPlayer(name)
    name = name:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():sub(1, #name) == name then
            return player
        end
        if player.DisplayName:lower():sub(1, #name) == name then
            return player
        end
    end
    return nil
end

-- VIEW FUNCTION
local viewConnection = nil

local function startViewing()
    if targetUsername == "" then
        statusLabel.Text = "Enter a username first"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local target = findPlayer(targetUsername)
    if not target then
        statusLabel.Text = "Player not found"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    currentTarget = target
    statusLabel.Text = "Viewing: " .. target.Name
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    -- Set camera to follow target
    local camera = workspace.CurrentCamera
    camera.CameraSubject = target.Character and target.Character:FindFirstChild("Humanoid")
    
    -- Keep updating camera subject
    if viewConnection then viewConnection:Disconnect() end
    
    viewConnection = RunService.RenderStepped:Connect(function()
        if viewEnabled and currentTarget then
            if currentTarget.Character then
                local humanoid = currentTarget.Character:FindFirstChild("Humanoid")
                if humanoid then
                    camera.CameraSubject = humanoid
                end
            end
        end
    end)
end

local function stopViewing()
    if viewConnection then
        viewConnection:Disconnect()
        viewConnection = nil
    end
    
    currentTarget = nil
    
    -- Reset camera to local player
    local camera = workspace.CurrentCamera
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            camera.CameraSubject = humanoid
        end
    end
    
    statusLabel.Text = "Not viewing anyone"
    statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
end

-- Reapply viewing on respawn
LocalPlayer.CharacterAdded:Connect(function(character)
    if viewEnabled and currentTarget then
        wait(0.5)
        startViewing()
    end
end)

-- TOGGLE VIEW
viewToggle.MouseButton1Click:Connect(function()
    viewEnabled = not viewEnabled
    
    if viewEnabled then
        targetUsername = userInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if targetUsername ~= "" then
            viewToggle.Text = "VIEW: ON"
            viewToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
            startViewing()
        else
            viewEnabled = false
            statusLabel.Text = "Enter a username first"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    else
        viewToggle.Text = "VIEW: OFF"
        viewToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        stopViewing()
    end
end)

-- Update target when typing new name
userInput.FocusLost:Connect(function()
    if viewEnabled then
        targetUsername = userInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if targetUsername ~= "" then
            startViewing()
        end
    end
end)

print("✅ View Player script loaded")
