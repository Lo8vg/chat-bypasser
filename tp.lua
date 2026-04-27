--[[
    kbl hoes Teleport
    Click near enemy dot to teleport to them
    Safe from accidental clicks
]]

getgenv()["kbl hoes TP"] = {
    Enabled = true,
    ESPEnabled = true,
    TeleportDistance = 15,      -- How close you need to click to enemy
    ESPColor = Color3.fromRGB(255, 0, 255),
    ShowDistance = true
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPObjects = {}
local Connections = {}

-- Create ESP dot over player head
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local function AddESP(character)
        if not character then return end
        
        local head = character:FindFirstChild("Head")
        if not head then 
            -- Wait for head
            task.spawn(function()
                character:WaitForChild("Head")
                AddESP(character)
            end)
            return 
        end
        
        -- Remove existing ESP for this player
        if ESPObjects[player] then
            for _, obj in pairs(ESPObjects[player]) do
                if obj and obj.Parent then
                    obj:Destroy()
                end
            end
        end
        
        ESPObjects[player] = {}
        
        -- Create BillboardGui for the dot
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "kbl_hoes_ESP"
        billboard.Size = UDim2.new(0, 30, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 3, 0)  -- Above head
        billboard.Adornee = head
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        
        -- The dot
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(1, 0, 1, 0)
        dot.BackgroundColor3 = getgenv()["kbl hoes TP"].ESPColor
        dot.BorderSizePixel = 0
        dot.Parent = billboard
        
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)  -- Circle
        dotCorner.Parent = dot
        
        -- Dot outline/glow
        local glow = Instance.new("UIStroke")
        glow.Color = Color3.new(1, 1, 1)
        glow.Thickness = 2
        glow.Parent = dot
        
        table.insert(ESPObjects[player], billboard)
        
        -- Distance label (optional)
        if getgenv()["kbl hoes TP"].ShowDistance then
            local distLabel = Instance.new("TextLabel")
            distLabel.Name = "DistanceLabel"
            distLabel.Size = UDim2.new(0, 50, 0, 20)
            distLabel.StudsOffset = Vector3.new(0, 4.5, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.TextColor3 = Color3.new(1, 1, 1)
            distLabel.TextSize = 12
            distLabel.Font = Enum.Font.GothamBold
            distLabel.TextStrokeTransparency = 0.5
            distLabel.Parent = billboard
            
            -- Update distance
            task.spawn(function()
                while billboard and billboard.Parent do
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local targetHRP = character and character:FindFirstChild("HumanoidRootPart")
                    
                    if hrp and targetHRP then
                        local dist = (hrp.Position - targetHRP.Position).Magnitude
                        distLabel.Text = tostring(math.floor(dist)) .. "m"
                    end
                    
                    task.wait(0.1)
                end
            end)
        end
    end
    
    -- Handle character added/removed
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
                if obj and obj.Parent then
                    obj:Destroy()
                end
            end
            ESPObjects[player] = nil
        end
    end)
end

-- Remove ESP
local function RemoveESP(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        ESPObjects[player] = nil
    end
end

-- Get closest player to click position
local function GetPlayerNearPosition(position, maxDistance)
    local closest = nil
    local closestDist = maxDistance
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if hrp and humanoid and humanoid.Health > 0 then
                -- Get screen position of enemy
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                
                if onScreen then
                    local screenVec = Vector2.new(screenPos.X, screenPos.Y)
                    local dist = (screenVec - position).Magnitude
                    
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    
    return closest
end

-- Teleport to player
local function TeleportTo(player)
    if not player or not player.Character then return end
    
    local myChar = LocalPlayer.Character
    if not myChar then return end
    
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
    
    if not myHRP or not targetHRP then return end
    
    -- Teleport behind them
    local behindPos = targetHRP.Position - (targetHRP.CFrame.LookVector * 3)
    behindPos = Vector3.new(behindPos.X, targetHRP.Position.Y, behindPos.Z)
    
    myHRP.CFrame = CFrame.new(behindPos)
    
    -- Notify
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kbl hoes TP",
        Text = "Teleported to " .. player.Name,
        Duration = 2
    })
end

-- Click detection
local function SetupClickDetection()
    Connections.Click = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not getgenv()["kbl hoes TP"].Enabled then return end
        if gameProcessed then return end
        
        -- Check for tap/click on screen (not button presses)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local position
            
            if input.UserInputType == Enum.UserInputType.Touch then
                -- Mobile touch
                position = Vector2.new(input.Position.X, input.Position.Y)
            else
                -- Mouse
                position = Vector2.new(input.Position.X, input.Position.Y)
            end
            
            -- Find if clicking near an enemy
            local targetPlayer = GetPlayerNearPosition(position, getgenv()["kbl hoes TP"].TeleportDistance)
            
            if targetPlayer then
                TeleportTo(targetPlayer)
            end
            -- If no enemy nearby, do nothing (safe!)
        end
    end)
end

-- GUI
local function CreateGUI()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Remove old
    local old = PlayerGui:FindFirstChild("kbl hoes TP GUI")
    if old then old:Destroy() end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "kbl hoes TP GUI"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    local Frame = Instance.new("Frame")
    Frame.Name = "Main"
    Frame.Size = UDim2.new(0, 160, 0, 180)
    Frame.Position = UDim2.new(0, 10, 0.3, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "kbl hoes TP"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame
    
    -- Toggle TP
    local TPToggle = Instance.new("TextButton")
    TPToggle.Name = "TPToggle"
    TPToggle.Size = UDim2.new(0.9, 0, 0, 30)
    TPToggle.Position = UDim2.new(0.05, 0, 0, 35)
    TPToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    TPToggle.Text = "Teleport: ON"
    TPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TPToggle.TextSize = 13
    TPToggle.Font = Enum.Font.GothamBold
    TPToggle.Parent = Frame
    
    local TPCorner = Instance.new("UICorner")
    TPCorner.CornerRadius = UDim.new(0, 6)
    TPCorner.Parent = TPToggle
    
    -- Toggle ESP
    local ESPToggle = Instance.new("TextButton")
    ESPToggle.Name = "ESPToggle"
    ESPToggle.Size = UDim2.new(0.9, 0, 0, 30)
    ESPToggle.Position = UDim2.new(0.05, 0, 0, 70)
    ESPToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    ESPToggle.Text = "ESP Dots: ON"
    ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPToggle.TextSize = 13
    ESPToggle.Font = Enum.Font.GothamBold
    ESPToggle.Parent = Frame
    
    local ESPCorner = Instance.new("UICorner")
    ESPCorner.CornerRadius = UDim.new(0, 6)
    ESPCorner.Parent = ESPToggle
    
    -- Click Distance
    local DistLabel = Instance.new("TextLabel")
    DistLabel.Size = UDim2.new(1, 0, 0, 20)
    DistLabel.Position = UDim2.new(0, 0, 0, 105)
    DistLabel.BackgroundTransparency = 1
    DistLabel.Text = "Click Range: 15px"
    DistLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DistLabel.TextSize = 12
    DistLabel.Font = Enum.Font.Gotham
    DistLabel.Parent = Frame
    
    -- + Distance
    local PlusBtn = Instance.new("TextButton")
    PlusBtn.Size = UDim2.new(0.43, 0, 0, 28)
    PlusBtn.Position = UDim2.new(0.05, 0, 0, 125)
    PlusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    PlusBtn.Text = "+ Range"
    PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlusBtn.TextSize = 12
    PlusBtn.Font = Enum.Font.GothamBold
    PlusBtn.Parent = Frame
    
    local PlusCorner = Instance.new("UICorner")
    PlusCorner.CornerRadius = UDim.new(0, 6)
    PlusCorner.Parent = PlusBtn
    
    -- - Distance
    local MinusBtn = Instance.new("TextButton")
    MinusBtn.Size = UDim2.new(0.43, 0, 0, 28)
    MinusBtn.Position = UDim2.new(0.52, 0, 0, 125)
    MinusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MinusBtn.Text = "- Range"
    MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinusBtn.TextSize = 12
    MinusBtn.Font = Enum.Font.GothamBold
    MinusBtn.Parent = Frame
    
    local MinusCorner = Instance.new("UICorner")
    MinusCorner.CornerRadius = UDim.new(0, 6)
    MinusCorner.Parent = MinusBtn
    
    -- Instructions
    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, 0, 0, 25)
    Info.Position = UDim2.new(0, 0, 0, 155)
    Info.BackgroundTransparency = 1
    Info.Text = "Click near dot to TP"
    Info.TextColor3 = Color3.fromRGB(150, 150, 150)
    Info.TextSize = 10
    Info.Font = Enum.Font.Gotham
    Info.Parent = Frame
    
    -- Update function
    local function UpdateGUI()
        TPToggle.Text = "Teleport: " .. (getgenv()["kbl hoes TP"].Enabled and "ON" or "OFF")
        TPToggle.BackgroundColor3 = getgenv()["kbl hoes TP"].Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        
        ESPToggle.Text = "ESP Dots: " .. (getgenv()["kbl hoes TP"].ESPEnabled and "ON" or "OFF")
        ESPToggle.BackgroundColor3 = getgenv()["kbl hoes TP"].ESPEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        
        DistLabel.Text = "Click Range: " .. getgenv()["kbl hoes TP"].TeleportDistance .. "px"
    end
    
    -- Button Events
    TPToggle.MouseButton1Click:Connect(function()
        getgenv()["kbl hoes TP"].Enabled = not getgenv()["kbl hoes TP"].Enabled
        UpdateGUI()
    end)
    
    ESPToggle.MouseButton1Click:Connect(function()
        getgenv()["kbl hoes TP"].ESPEnabled = not getgenv()["kbl hoes TP"].ESPEnabled
        
        -- Toggle ESP visibility
        for player, objects in pairs(ESPObjects) do
            for _, obj in pairs(objects) do
                if obj and obj.Parent then
                    obj.Enabled = getgenv()["kbl hoes TP"].ESPEnabled
                end
            end
        end
        
        UpdateGUI()
    end)
    
    PlusBtn.MouseButton1Click:Connect(function()
        getgenv()["kbl hoes TP"].TeleportDistance = math.min(100, getgenv()["kbl hoes TP"].TeleportDistance + 5)
        UpdateGUI()
    end)
    
    MinusBtn.MouseButton1Click:Connect(function()
        getgenv()["kbl hoes TP"].TeleportDistance = math.max(5, getgenv()["kbl hoes TP"].TeleportDistance - 5)
        UpdateGUI()
    end)
    
    -- Draggable
    local dragging = false
    local dragStart, startPos
    
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if input.Target == Frame then
                dragging = true
                dragStart = input.Position
                startPos = Frame.Position
            end
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

-- Initialize
local function Init()
    -- Setup ESP for all players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end
    
    -- New players joining
    Players.PlayerAdded:Connect(function(player)
        CreateESP(player)
    end)
    
    -- Players leaving
    Players.PlayerRemoving:Connect(function(player)
        RemoveESP(player)
    end)
    
    -- Setup click detection
    SetupClickDetection()
    
    -- Create GUI
    CreateGUI()
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kbl hoes TP",
        Text = "Loaded! Click near enemy dot to teleport.",
        Duration = 3
    })
    
    print("[kbl hoes TP] Loaded!")
end

Init()
