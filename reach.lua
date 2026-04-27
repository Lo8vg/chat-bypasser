--[[
    kbl hoes
    Reach Script - Mobile Friendly
    Uses firetouchinterest method
]]

getgenv()["kbl hoes"] = {
    Reach = 14,
    Enabled = true,
    TeamCheck = false,
    AutoClick = false
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Anti-detection
local gc = gcinfo or collectgarbage
hookfunction(gc, function(...)
    return math.random(200, 400)
end)

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() then
        if tostring(self) == "Humanoid" and key == "Health" then
            return 0
        end
    end
    return oldIndex(self, key)
end)

-- Notification function
local function Notify(Text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kbl hoes",
        Text = Text,
        Duration = 2
    })
end

-- Check if player is on same team
local function IsTeammate(player)
    if not getgenv()["kbl hoes"].TeamCheck then return false end
    return player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team
end

-- Main FTI function
local lastHit = tick()

local function HitPlayer(player, handle)
    if not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    
    local whitelistedParts = {
        "Head", "Torso", "HumanoidRootPart",
        "Left Arm", "Right Arm", "Left Leg", "Right Leg",
        "UpperTorso", "LowerTorso", "LeftHand", "RightHand", "LeftFoot", "RightFoot"
    }
    
    -- Rate limit to prevent lag
    if tick() - lastHit < 0.03 then return end
    lastHit = tick()
    
    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") then
            if table.find(whitelistedParts, part.Name) then
                firetouchinterest(part, handle, 0)
                firetouchinterest(part, handle, 1)
            end
        end
    end
end

-- GUI
local function CreateGUI()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Remove old
    local old = PlayerGui:FindFirstChild("kbl hoes GUI")
    if old then old:Destroy() end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "kbl hoes GUI"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    local Frame = Instance.new("Frame")
    Frame.Name = "Main"
    Frame.Size = UDim2.new(0, 180, 0, 220)
    Frame.Position = UDim2.new(0, 10, 0.4, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "kbl hoes"
    Title.TextColor3 = Color3.fromRGB(255, 0, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame
    
    -- Reach Display
    local ReachLabel = Instance.new("TextLabel")
    ReachLabel.Name = "ReachLabel"
    ReachLabel.Size = UDim2.new(1, 0, 0, 25)
    ReachLabel.Position = UDim2.new(0, 0, 0, 40)
    ReachLabel.BackgroundTransparency = 1
    ReachLabel.Text = "Reach: 14"
    ReachLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ReachLabel.TextSize = 14
    ReachLabel.Font = Enum.Font.Gotham
    ReachLabel.Parent = Frame
    
    -- Toggle Button
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "Toggle"
    ToggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
    ToggleBtn.Position = UDim2.new(0.05, 0, 0, 70)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    ToggleBtn.Text = "Reach: ON"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 13
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.Parent = Frame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = ToggleBtn
    
    -- Team Check Button
    local TeamBtn = Instance.new("TextButton")
    TeamBtn.Name = "TeamCheck"
    TeamBtn.Size = UDim2.new(0.9, 0, 0, 30)
    TeamBtn.Position = UDim2.new(0.05, 0, 0, 105)
    TeamBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    TeamBtn.Text = "Team Check: OFF"
    TeamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeamBtn.TextSize = 13
    TeamBtn.Font = Enum.Font.GothamBold
    TeamBtn.Parent = Frame
    
    local TeamBtnCorner = Instance.new("UICorner")
    TeamBtnCorner.CornerRadius = UDim.new(0, 6)
    TeamBtnCorner.Parent = TeamBtn
    
    -- Auto Click Button
    local AutoBtn = Instance.new("TextButton")
    AutoBtn.Name = "AutoClick"
    AutoBtn.Size = UDim2.new(0.9, 0, 0, 30)
    AutoBtn.Position = UDim2.new(0.05, 0, 0, 140)
    AutoBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    AutoBtn.Text = "Auto Click: OFF"
    AutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoBtn.TextSize = 13
    AutoBtn.Font = Enum.Font.GothamBold
    AutoBtn.Parent = Frame
    
    local AutoBtnCorner = Instance.new("UICorner")
    AutoBtnCorner.CornerRadius = UDim.new(0, 6)
    AutoBtnCorner.Parent = AutoBtn
    
    -- Reach + Button
    local PlusBtn = Instance.new("TextButton")
    PlusBtn.Name = "Plus"
    PlusBtn.Size = UDim2.new(0.43, 0, 0, 30)
    PlusBtn.Position = UDim2.new(0.05, 0, 0, 175)
    PlusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    PlusBtn.Text = "+ Reach"
    PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlusBtn.TextSize = 12
    PlusBtn.Font = Enum.Font.GothamBold
    PlusBtn.Parent = Frame
    
    local PlusCorner = Instance.new("UICorner")
    PlusCorner.CornerRadius = UDim.new(0, 6)
    PlusCorner.Parent = PlusBtn
    
    -- Reach - Button
    local MinusBtn = Instance.new("TextButton")
    MinusBtn.Name = "Minus"
    MinusBtn.Size = UDim2.new(0.43, 0, 0, 30)
    MinusBtn.Position = UDim2.new(0.52, 0, 0, 175)
    MinusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MinusBtn.Text = "- Reach"
    MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinusBtn.TextSize = 12
    MinusBtn.Font = Enum.Font.GothamBold
    MinusBtn.Parent = Frame
    
    local MinusCorner = Instance.new("UICorner")
    MinusCorner.CornerRadius = UDim.new(0, 6)
    MinusCorner.Parent = MinusBtn
    
    -- Update function
    local function UpdateDisplay()
        ReachLabel.Text = "Reach: " .. getgenv()["kbl hoes"].Reach
        ToggleBtn.Text = "Reach: " .. (getgenv()["kbl hoes"].Enabled and "ON" or "OFF")
        ToggleBtn.BackgroundColor3 = getgenv()["kbl hoes"].Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        TeamBtn.Text = "Team Check: " .. (getgenv()["kbl hoes"].TeamCheck and "ON" or "OFF")
        TeamBtn.BackgroundColor3 = getgenv()["kbl hoes"].TeamCheck and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        AutoBtn.Text = "Auto Click: " .. (getgenv()["kbl hoes"].AutoClick and "ON" or "OFF")
        AutoBtn.BackgroundColor3 = getgenv()["kbl hoes"].AutoClick and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    end
    
    -- Button Events
    ToggleBtn.MouseButton1Click:Connect(function()
        getgenv()["kbl hoes"].Enabled = not getgenv()["kbl hoes"].Enabled
        UpdateDisplay()
        Notify("Reach " .. (getgenv()["kbl hoes"].Enabled and "ON" or "OFF"))
    end)
    
    TeamBtn.MouseButton1Click:Connect(function()
        getgenv()["kbl hoes"].TeamCheck = not getgenv()["kbl hoes"].TeamCheck
        UpdateDisplay()
        Notify("Team Check " .. (getgenv()["kbl hoes"].TeamCheck and "ON" or "OFF"))
    end)
    
    AutoBtn.MouseButton1Click:Connect(function()
        getgenv()["kbl hoes"].AutoClick = not getgenv()["kbl hoes"].AutoClick
        UpdateDisplay()
        Notify("Auto Click " .. (getgenv()["kbl hoes"].AutoClick and "ON" or "OFF"))
    end)
    
    PlusBtn.MouseButton1Click:Connect(function()
        getgenv()["kbl hoes"].Reach = getgenv()["kbl hoes"].Reach + 1
        UpdateDisplay()
        Notify("Reach: " .. getgenv()["kbl hoes"].Reach)
    end)
    
    MinusBtn.MouseButton1Click:Connect(function()
        getgenv()["kbl hoes"].Reach = math.max(1, getgenv()["kbl hoes"].Reach - 1)
        UpdateDisplay()
        Notify("Reach: " .. getgenv()["kbl hoes"].Reach)
    end)
    
    -- Draggable
    local dragging = false
    local dragStart, startPos
    
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
        end
    end)
    
    Frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    Frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Main Loop
RunService.RenderStepped:Connect(function()
    local settings = getgenv()["kbl hoes"]
    
    if not settings.Enabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    local handle = tool:FindFirstChild("Handle")
    if not handle then return end
    
    -- Auto Click
    if settings.AutoClick then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            tool:Activate()
        end
    end
    
    -- Check all players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if IsTeammate(player) then
                -- Skip teammates if team check is on
            else
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                
                if hrp and humanoid and humanoid.Health > 0 then
                    local distance = (hrp.Position - handle.Position).Magnitude
                    
                    if distance <= settings.Reach then
                        HitPlayer(player, handle)
                    end
                end
            end
        end
    end
end)

-- Initialize
CreateGUI()
Notify("Loaded successfully!")
print("[kbl hoes] Reach script loaded!")
