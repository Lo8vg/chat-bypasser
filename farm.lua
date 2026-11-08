-- Auto Farm Script with Input Hub and On/Off Toggle
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local detectionRange = 50
local targetPlayer = nil
local isFollowing = false
local connection = nil

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Hub Button (Small Square)
local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 50, 0, 50)
hubButton.Position = UDim2.new(0, 20, 0.5, -25)
hubButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
hubButton.BorderSizePixel = 2
hubButton.BorderColor3 = Color3.fromRGB(255, 20, 147)
hubButton.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 8)
hubCorner.Parent = hubButton

local hubIcon = Instance.new("TextLabel")
hubIcon.Size = UDim2.new(1, 0, 1, 0)
hubIcon.BackgroundTransparency = 1
hubIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
hubIcon.Text = "🎯"
hubIcon.Font = Enum.Font.GothamBold
hubIcon.TextSize = 22
hubIcon.Parent = hubButton

-- Main Frame (Expanded)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 130)
mainFrame.Position = UDim2.new(0, 20, 0.5, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 20, 147)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 130, 200)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = Color3.fromRGB(255, 130, 200)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -30, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "🎯 Auto Farm Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 22)
closeBtn.Position = UDim2.new(1, -32, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -28)
content.Position = UDim2.new(0, 0, 0, 28)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Range Input
local rangeLabel = Instance.new("TextLabel")
rangeLabel.Size = UDim2.new(1, -20, 0, 16)
rangeLabel.Position = UDim2.new(0, 10, 0, 10)
rangeLabel.BackgroundTransparency = 1
rangeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
rangeLabel.Text = "Detection Range (studs):"
rangeLabel.Font = Enum.Font.Gotham
rangeLabel.TextSize = 11
rangeLabel.TextXAlignment = Enum.TextXAlignment.Left
rangeLabel.Parent = content

local rangeInput = Instance.new("TextBox")
rangeInput.Size = UDim2.new(1, -20, 0, 24)
rangeInput.Position = UDim2.new(0, 10, 0, 28)
rangeInput.BackgroundColor3 = Color3.fromRGB(255, 130, 200)
rangeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
rangeInput.Text = tostring(detectionRange)
rangeInput.PlaceholderText = "Enter range in studs..."
rangeInput.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
rangeInput.Font = Enum.Font.Gotham
rangeInput.TextSize = 12
rangeInput.Parent = content

local rangeCorner = Instance.new("UICorner")
rangeCorner.CornerRadius = UDim.new(0, 6)
rangeCorner.Parent = rangeInput

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -20, 0, 26)
toggleBtn.Position = UDim2.new(0, 10, 0, 60)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "TURN ON"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.Parent = content

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 16)
statusLabel.Position = UDim2.new(0, 10, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Text = "Status: OFF"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = content

-- Functions
local function findNearestPlayer()
    local nearestPlayer = nil
    local nearestDistance = detectionRange
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestPlayer = plr
            end
        end
    end
    
    return nearestPlayer
end

local function followTarget()
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        targetPlayer = findNearestPlayer()
        if targetPlayer then
            statusLabel.Text = "Status: Following " .. targetPlayer.Name
        else
            statusLabel.Text = "Status: No target found"
        end
    end
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = targetPlayer.Character.HumanoidRootPart.Position
        local playerChar = player.Character
        if playerChar and playerChar:FindFirstChild("HumanoidRootPart") then
            local offset = Vector3.new(0, 0, 0)
            playerChar.HumanoidRootPart.CFrame = CFrame.new(targetPos + offset)
        end
    end
end

local function startFollowing()
    if connection then connection:Disconnect() end
    isFollowing = true
    connection = RunService.Heartbeat:Connect(followTarget)
    toggleBtn.Text = "TURN OFF"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    statusLabel.Text = "Status: Following"
end

local function stopFollowing()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    isFollowing = false
    targetPlayer = nil
    toggleBtn.Text = "TURN ON"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
    statusLabel.Text = "Status: OFF"
end

-- Event Handlers
hubButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

rangeInput.FocusLost:Connect(function(enterPressed)
    local newRange = tonumber(rangeInput.Text)
    if newRange and newRange > 0 then
        detectionRange = newRange
        if isFollowing then
            stopFollowing()
            startFollowing()
        end
    else
        rangeInput.Text = tostring(detectionRange)
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    if isFollowing then
        stopFollowing()
    else
        startFollowing()
    end
end)

-- Respawn handler
player.CharacterAdded:Connect(function()
    if isFollowing then
        stopFollowing()
        startFollowing()
    end
end)
   
