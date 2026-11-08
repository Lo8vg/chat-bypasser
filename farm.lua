-- Simple Auto Farm Toggle Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local detectionRange = 30
local targetPlayer = nil
local isFollowing = false
local connection = nil

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmToggle"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Toggle Button (Rectangle)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0.5, -20)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
toggleButton.BorderSizePixel = 0
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

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
    toggleButton.Text = "ON"
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
end

local function stopFollowing()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    isFollowing = false
    targetPlayer = nil
    toggleButton.Text = "OFF"
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
end

-- Event Handlers
toggleButton.MouseButton1Click:Connect(function()
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
