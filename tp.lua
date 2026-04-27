--[[
    kbl hoes TP v2
    Teleport to closest enemy button
    ESP dots for enemies only
]]

getgenv()["kbl hoes TP"] = {
    Enabled = true,
    ESPEnabled = true,
    TeamCheck = true
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPObjects = {}

-- Get closest enemy
local function GetClosestEnemy()
    local closest = nil
    local closestDist = math.huge
    
    local myChar = LocalPlayer.Character
    if not myChar then return nil end
    
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Team check
            if getgenv()["kbl hoes TP"].TeamCheck then
                if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                    -- Skip teammate
                else
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    
                    if hrp and humanoid and humanoid.Health > 0 then
                        local dist = (myHRP.Position - hrp.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closest = player
                        end
                    end
                end
            else
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                
                if hrp and humanoid and humanoid.Health > 0 then
                    local dist = (myHRP.Position - hrp.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    
    return closest, closestDist
end

-- Create ESP
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local function AddESP(character)
        if not character then return end
        
        local head = character:FindFirstChild("Head")
        if not head then
            task.spawn(function()
                character:WaitForChild("Head")
                AddESP(character)
            end)
            return
        end
        
        -- Clear old
        if ESPObjects[player] then
            for _, obj in pairs(ESPObjects[player]) do
                if obj and obj.Parent then obj:Destroy() end
            end
        end
        ESPObjects[player] = {}
        
        -- BillboardGui
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "kbl_ESP"
        billboard.Size = UDim2.new(0, 25, 0, 25)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.Adornee = head
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(1, 0, 1, 0)
        dot.BackgroundTransparency = 0
        dot.BorderSizePixel = 0
        dot.Parent = billboard
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = dot
        
        -- Color based on team
        local function UpdateColor()
            if not billboard or not billboard.Parent then return end
            
            local color
            if getgenv()["kbl hoes TP"].TeamCheck then
                if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                    color = Color3.fromRGB(0, 255, 0) -- Green = Teammate
                else
                    color = Color3.fromRGB(255, 0, 100) -- Pink/Red = Enemy
                end
            else
                color = Color3.fromRGB(255, 0, 100)
            end
            
            dot.BackgroundColor3 = color
        end
        
        UpdateColor()
        
        table.insert(ESPObjects[player], billboard)
        
        -- Keep updating color
        task.spawn(function()
            while billboard and billboard.Parent and player and player.Parent do
                UpdateColor()
                task.wait(0.5)
            end
        end)
    end
    
    -- Teammate check for ESP visibility
    local function ShouldShowESP(player)
        if not getgenv()["kbl hoes TP"].ESPEnabled then return false end
        if not getgenv()["kbl hoes TP"].TeamCheck then return true end
        if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
            return false -- Hide teammates
        end
        return true
    end
    
    if player.Character then
        AddESP(player.Character)
    end
    
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        AddESP(char)
    end)
    
    player.CharacterRemoving:Connect(function()
        if ESPObjects[player] then
            for _, obj in pairs(ESPObjects[player]) do
                if obj and obj.Parent then obj:Destroy() end
            end
            ESPObjects[player] = nil
        end
    end)
end

-- Remove ESP
local function RemoveESP(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            if obj and obj.Parent then obj:Destroy() end
        end
        ESPObjects[player] = nil
    end
end

-- Teleport to player
local function TeleportTo(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "kbl hoes TP",
            Text = "No target found",
            Duration = 2
        })
        return
    end
    
    local myChar = LocalPlayer.Character
    if not myChar then return end
    
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not myHRP or not targetHRP then return end
    
    -- Teleport behind them
    local behindPos = targetHRP.Position - (targetHRP.CFrame.LookVector * 3)
    
    myHRP.CFrame = CFrame.new(behindPos.X, targetHRP.Position.Y, behindPos.Z)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kbl hoes TP",
        Text = "Teleported to " .. targetPlayer.Name,
        Duration = 2
    })
end

-- GUI
local function CreateGUI()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    local old = PlayerGui:FindFirstChild("kbl hoes TP GUI")
    if old then old:Destroy() end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "kbl hoes TP GUI"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    
    -- Teleport Button
    local TPButton = Instance.new("TextButton")
    TPButton.Name = "TeleportBtn"
    TPButton.Size = UDim2.new(0, 120, 0, 50)
    TPButton.Position = UDim2.new(0.5, -60, 0.85, 0)
    TPButton.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    TPButton.Text = "TP to Enemy"
    TPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TPButton.TextSize = 14
    TPButton.Font = Enum.Font.GothamBold
    TPButton.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = TPButton
    
    -- Draggable Settings Frame
    local Frame = Instance.new("Frame")
    Frame.Name = "Settings"
    Frame.Size = UDim2.new(0, 150, 0, 130)
    Frame.Position = UDim2.new(0, 10, 0.25, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 10)
    FrameCorner.Parent = Frame
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Text = "kbl hoes TP"
    Title.TextColor3 = Color3.fromRGB(255, 0, 100)
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame
    
    -- ESP Toggle
    local ESPBtn = Instance.new("TextButton")
    ESPBtn.Size = UDim2.new(0.9, 0, 0, 28)
    ESPBtn.Position = UDim2.new(0.05, 0, 0, 30)
    ESPBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    ESPBtn.Text = "ESP: ON"
    ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPBtn.TextSize = 12
    ESPBtn.Font = Enum.Font.GothamBold
    ESPBtn.Parent = Frame
    
    local ESPCorner = Instance.new("UICorner")
    ESPCorner.CornerRadius = UDim.new(0, 6)
    ESPCorner.Parent = ESPBtn
    
    -- Team Check Toggle
    local TeamBtn = Instance.new("TextButton")
    TeamBtn.Size = UDim2.new(0.9, 0, 0, 28)
    TeamBtn.Position = UDim2.new(0.05, 0, 0, 62)
    TeamBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    TeamBtn.Text = "Team Check: ON"
    TeamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeamBtn.TextSize = 12
    TeamBtn.Font = Enum.Font.GothamBold
    TeamBtn.Parent = Frame
    
    local TeamCorner = Instance.new("UICorner")
    TeamCorner.CornerRadius = UDim.new(0, 6)
    TeamCorner.Parent = TeamBtn
    
    -- Distance Label
    local DistLabel = Instance.new("TextLabel")
    DistLabel.Size = UDim2.new(1, 0, 0, 20)
    DistLabel.Position = UDim2.new(0, 0, 0, 95)
    DistLabel.BackgroundTransparency = 1
    DistLabel.Text = "Distance: --"
    DistLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DistLabel.TextSize = 11
    DistLabel.Font = Enum.Font.Gotham
    DistLabel.Parent = Frame
    
    -- Update distance display
    task.spawn(function()
        while Frame and Frame.Parent do
            local _, dist = GetClosestEnemy()
            if dist and dist < math.huge then
                DistLabel.Text = "Nearest: " .. math.floor(dist) .. "m"
            else
                DistLabel.Text = "Nearest: --"
            end
            task.wait(0.2)
        end
    end)
    
    -- Button Events
    TPButton.MouseButton1Click:Connect(function()
        if not getgenv()["kbl hoes TP"].Enabled then return end
        
        local target, dist = GetClosestEnemy()
        if target then
            TeleportTo(target)
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "kbl hoes TP",
                Text = "No enemies nearby",
                Duration = 2
            })
        end
    end)
    
    ESPBtn.MouseButton1Click:Connect(function()
        getgenv()["kbl hoes TP"].ESPEnabled = not getgenv()["kbl hoes TP"].ESPEnabled
        ESPBtn.Text = "ESP: " .. (getgenv()["kbl hoes TP"].ESPEnabled and "ON" or "OFF")
        ESPBtn.BackgroundColor3 = getgenv()["kbl hoes TP"].ESPEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        
        for player, objects in pairs(ESPObjects) do
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    obj.Enabled = getgenv()["kbl hoes TP"].ESPEnabled
                end
            end
        end
    end)
    
    TeamBtn.MouseButton1Click:Connect(function()
        getgenv()["kbl hoes TP"].TeamCheck = not getgenv()["kbl hoes TP"].TeamCheck
        TeamBtn.Text = "Team Check: " .. (getgenv()["kbl hoes TP"].TeamCheck and "ON" or "OFF")
        TeamBtn.BackgroundColor3 = getgenv()["kbl hoes TP"].TeamCheck and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    end)
    
    -- Draggable
    local dragging, dragStart, startPos = false, nil, nil
    
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

-- Init
local function Init()
    -- ESP for existing players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end
    
    -- New players
    Players.PlayerAdded:Connect(function(player)
        CreateESP(player)
    end)
    
    -- Players leaving
    Players.PlayerRemoving:Connect(function(player)
        RemoveESP(player)
    end)
    
    CreateGUI()
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kbl hoes TP",
        Text = "Loaded! Tap button to TP to nearest enemy.",
        Duration = 3
    })
    
    print("[kbl hoes TP] Loaded!")
end

Init()
