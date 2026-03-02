-- Flinger Logger (Server-Wide Scanner)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local VELOCITY_THRESHOLD = 50  -- Angular velocity threshold to flag as suspicious
local SCAN_INTERVAL = 0.1      -- How often to scan
local MAX_LOG_ENTRIES = 50     -- Max entries in log

-- Suspicious players tracking
local suspiciousPlayers = {}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingerLogger"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========== HUB BUTTON ==========
local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 55, 0, 55)
hubButton.Position = UDim2.new(0, 20, 0.5, -27)
hubButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
hubButton.BorderSizePixel = 2
hubButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
hubButton.Visible = true
hubButton.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 10)
hubCorner.Parent = hubButton

local hubIcon = Instance.new("TextLabel")
hubIcon.Size = UDim2.new(1, 0, 1, 0)
hubIcon.BackgroundTransparency = 1
hubIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
hubIcon.Text = "🔍"
hubIcon.Font = Enum.Font.GothamBold
hubIcon.TextSize = 26
hubIcon.Parent = hubButton

-- Warning indicator on hub
local warningDot = Instance.new("Frame")
warningDot.Size = UDim2.new(0, 12, 0, 12)
warningDot.Position = UDim2.new(1, -8, 0, -4)
warningDot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
warningDot.Visible = false
warningDot.Parent = hubButton

local warningDotCorner = Instance.new("UICorner")
warningDotCorner.CornerRadius = UDim.new(1, 0)
warningDotCorner.Parent = warningDot

-- ========== MAIN FRAME ==========
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 10)
titleBarCorner.Parent = titleBar

local titleBarFix = Instance.new("Frame")
titleBarFix.Size = UDim2.new(1, 0, 0, 12)
titleBarFix.Position = UDim2.new(0, 0, 1, -12)
titleBarFix.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBarFix.BorderSizePixel = 0
titleBarFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "🔍 Flinger Logger"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Collapse Button
local collapseBtn = Instance.new("TextButton")
collapseBtn.Size = UDim2.new(0, 28, 0, 24)
collapseBtn.Position = UDim2.new(1, -36, 0.5, -12)
collapseBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
collapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
collapseBtn.Text = "×"
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.TextSize = 14
collapseBtn.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseBtn

-- ========== STATUS BAR ==========
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, -20, 0, 30)
statusBar.Position = UDim2.new(0, 10, 0, 42)
statusBar.BackgroundTransparency = 1
statusBar.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Text = "Scanning 0 players..."
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusBar

local threatLabel = Instance.new("TextLabel")
threatLabel.Size = UDim2.new(0, 100, 1, 0)
threatLabel.Position = UDim2.new(1, -100, 0, 0)
threatLabel.BackgroundTransparency = 1
threatLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
threatLabel.Text = "⚠ Threats: 0"
threatLabel.Font = Enum.Font.GothamBold
threatLabel.TextSize = 11
threatLabel.TextXAlignment = Enum.TextXAlignment.Right
threatLabel.Parent = statusBar

-- ========== SETTINGS BAR ==========
local settingsBar = Instance.new("Frame")
settingsBar.Size = UDim2.new(1, -20, 0, 28)
settingsBar.Position = UDim2.new(0, 10, 0, 75)
settingsBar.BackgroundTransparency = 1
settingsBar.Parent = mainFrame

local thresholdLabel = Instance.new("TextLabel")
thresholdLabel.Size = UDim2.new(0, 80, 1, 0)
thresholdLabel.BackgroundTransparency = 1
thresholdLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
thresholdLabel.Text = "Threshold:"
thresholdLabel.Font = Enum.Font.Gotham
thresholdLabel.TextSize = 11
thresholdLabel.TextXAlignment = Enum.TextXAlignment.Left
thresholdLabel.Parent = settingsBar

local thresholdInput = Instance.new("TextBox")
thresholdInput.Size = UDim2.new(0, 50, 1, 0)
thresholdInput.Position = UDim2.new(0, 80, 0, 0)
thresholdInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
thresholdInput.TextColor3 = Color3.fromRGB(255, 255, 255)
thresholdInput.Text = tostring(VELOCITY_THRESHOLD)
thresholdInput.Font = Enum.Font.Gotham
thresholdInput.TextSize = 11
thresholdInput.Parent = settingsBar

local thresholdCorner = Instance.new("UICorner")
thresholdCorner.CornerRadius = UDim.new(0, 4)
thresholdCorner.Parent = thresholdInput

local autoScrollLabel = Instance.new("TextLabel")
autoScrollLabel.Size = UDim2.new(0, 70, 1, 0)
autoScrollLabel.Position = UDim2.new(0, 145, 0, 0)
autoScrollLabel.BackgroundTransparency = 1
autoScrollLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
autoScrollLabel.Text = "Auto Scroll:"
autoScrollLabel.Font = Enum.Font.Gotham
autoScrollLabel.TextSize = 11
autoScrollLabel.TextXAlignment = Enum.TextXAlignment.Left
autoScrollLabel.Parent = settingsBar

local autoScrollBtn = Instance.new("TextButton")
autoScrollBtn.Size = UDim2.new(0, 50, 1, 0)
autoScrollBtn.Position = UDim2.new(0, 215, 0, 0)
autoScrollBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
autoScrollBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoScrollBtn.Text = "ON"
autoScrollBtn.Font = Enum.Font.GothamBold
autoScrollBtn.TextSize = 10
autoScrollBtn.Parent = settingsBar

local autoScrollCorner = Instance.new("UICorner")
autoScrollCorner.CornerRadius = UDim.new(0, 4)
autoScrollCorner.Parent = autoScrollBtn

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 55, 1, 0)
clearBtn.Position = UDim2.new(1, -55, 0, 0)
clearBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.Text = "Clear"
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 10
clearBtn.Parent = settingsBar

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 4)
clearCorner.Parent = clearBtn

-- ========== LOG SCROLLING FRAME ==========
local logFrame = Instance.new("Frame")
logFrame.Size = UDim2.new(1, -20, 1, -115)
logFrame.Position = UDim2.new(0, 10, 0, 108)
logFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
logFrame.Parent = mainFrame

local logFrameCorner = Instance.new("UICorner")
logFrameCorner.CornerRadius = UDim.new(0, 6)
logFrameCorner.Parent = logFrame

local logScroll = Instance.new("ScrollingFrame")
logScroll.Size = UDim2.new(1, -8, 1, -8)
logScroll.Position = UDim2.new(0, 4, 0, 4)
logScroll.BackgroundTransparency = 1
logScroll.ScrollBarThickness = 4
logScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
logScroll.Parent = logFrame

local logLayout = Instance.new("UIListLayout")
logLayout.Padding = UDim.new(0, 4)
logLayout.Parent = logScroll

-- ========== DRAGGING ==========
local dragging = false
local dragInput, dragStart, startPos

hubButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = hubButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

hubButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        hubButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Main frame dragging
local mainDragging = false
local mainDragInput, mainDragStart, mainDragPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mainDragging = true
        mainDragStart = input.Position
        mainDragPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                mainDragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        mainDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == mainDragInput and mainDragging then
        local delta = input.Position - mainDragStart
        mainFrame.Position = UDim2.new(mainDragPos.X.Scale, mainDragPos.X.Offset + delta.X, mainDragPos.Y.Scale, mainDragPos.Y.Offset + delta.Y)
    end
end)

-- ========== TOGGLE ==========
hubButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        wait(0.1)
        if not dragging then
            hubButton.Visible = false
            mainFrame.Visible = true
        end
    end
end)

collapseBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

-- ========== AUTO SCROLL TOGGLE ==========
local autoScroll = true

autoScrollBtn.MouseButton1Click:Connect(function()
    autoScroll = not autoScroll
    autoScrollBtn.Text = autoScroll and "ON" or "OFF"
    autoScrollBtn.BackgroundColor3 = autoScroll and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(108, 117, 125)
end)

-- ========== CLEAR LOG ==========
clearBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(logScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    suspiciousPlayers = {}
    threatLabel.Text = "⚠ Threats: 0"
    threatLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    warningDot.Visible = false
end)

-- ========== THRESHOLD UPDATE ==========
thresholdInput.FocusLost:Connect(function()
    local val = tonumber(thresholdInput.Text)
    if val and val > 0 then
        VELOCITY_THRESHOLD = val
    else
        thresholdInput.Text = tostring(VELOCITY_THRESHOLD)
    end
end)

-- ========== ADD LOG ENTRY ==========
local logCount = 0

local function addLogEntry(playerName, velocity, distance, threatLevel, color)
    logCount = logCount + 1
    
    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1, 0, 0, 50)
    entry.BackgroundColor3 = color
    entry.Parent = logScroll
    
    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 4)
    entryCorner.Parent = entry
    
    -- Player name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -10, 0, 16)
    nameLabel.Position = UDim2.new(0, 8, 0, 3)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Text = playerName
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 12
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = entry
    
    -- Velocity
    local velLabel = Instance.new("TextLabel")
    velLabel.Size = UDim2.new(1, -10, 0, 14)
    velLabel.Position = UDim2.new(0, 8, 0, 19)
    velLabel.BackgroundTransparency = 1
    velLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    velLabel.Text = string.format("Angular Vel: X=%.1f Y=%.1f Z=%.1f", velocity.X, velocity.Y, velocity.Z)
    velLabel.Font = Enum.Font.Gotham
    velLabel.TextSize = 10
    velLabel.TextXAlignment = Enum.TextXAlignment.Left
    velLabel.Parent = entry
    
    -- Distance and threat
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, -10, 0, 14)
    distLabel.Position = UDim2.new(0, 8, 0, 33)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    distLabel.Text = string.format("Distance: %.1f studs | Threat: %s", distance, threatLevel)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 10
    distLabel.TextXAlignment = Enum.TextXAlignment.Left
    distLabel.Parent = entry
    
    -- Time stamp
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(0, 60, 0, 14)
    timeLabel.Position = UDim2.new(1, -65, 0, 3)
    timeLabel.BackgroundTransparency = 1
    timeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    timeLabel.Text = os.date("%H:%M:%S")
    timeLabel.Font = Enum.Font.Gotham
    timeLabel.TextSize = 9
    timeLabel.TextXAlignment = Enum.TextXAlignment.Right
    timeLabel.Parent = entry
    
    -- Auto scroll
    if autoScroll then
        logScroll.CanvasSize = UDim2.new(0, 0, 0, logLayout.AbsoluteContentSize.Y + 8)
        logScroll.CanvasPosition = Vector2.new(0, math.huge)
    end
    
    -- Limit entries
    local children = logScroll:GetChildren()
    local frameCount = 0
    for _, child in pairs(children) do
        if child:IsA("Frame") then
            frameCount = frameCount + 1
        end
    end
    
    if frameCount > MAX_LOG_ENTRIES then
        for _, child in pairs(children) do
            if child:IsA("Frame") then
                child:Destroy()
                break
            end
        end
    end
end

-- ========== SCAN PLAYERS ==========
local lastScanTime = 0
local threatCount = 0

RunService.Heartbeat:Connect(function()
    local currentTime = tick()
    if currentTime - lastScanTime < SCAN_INTERVAL then return end
    lastScanTime = currentTime
    
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    local playerCount = 0
    local newThreatCount = 0
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            playerCount = playerCount + 1
            
            local plrChar = plr.Character
            local plrHrp = plrChar and plrChar:FindFirstChild("HumanoidRootPart")
            
            if plrHrp then
                local angularVel = plrHrp.AssemblyAngularVelocity
                local totalVel = math.abs(angularVel.X) + math.abs(angularVel.Y) + math.abs(angularVel.Z)
                
                local distance = 0
                if hrp then
                    distance = (plrHrp.Position - hrp.Position).Magnitude
                end
                
                if totalVel > VELOCITY_THRESHOLD then
                    newThreatCount = newThreatCount + 1
                    
                    -- Determine threat level
                    local threatLevel, color
                    if totalVel > 200 then
                        threatLevel = "CRITICAL"
                        color = Color3.fromRGB(180, 40, 40)
                    elseif totalVel > 100 then
                        threatLevel = "HIGH"
                        color = Color3.fromRGB(200, 100, 40)
                    else
                        threatLevel = "MEDIUM"
                        color = Color3.fromRGB(180, 150, 40)
                    end
                    
                    -- Only log if new or changed significantly
                    local lastVel = suspiciousPlayers[plr.Name]
                    if not lastVel or math.abs(lastVel - totalVel) > 10 then
                        addLogEntry(plr.Name, angularVel, distance, threatLevel, color)
                        suspiciousPlayers[plr.Name] = totalVel
                    end
                else
                    -- Reset if no longer suspicious
                    if suspiciousPlayers[plr.Name] then
                        suspiciousPlayers[plr.Name] = nil
                    end
                end
            end
        end
    end
    
    -- Update status
    statusLabel.Text = string.format("Scanning %d players...", playerCount)
    
    -- Update threat count
    if newThreatCount ~= threatCount then
        threatCount = newThreatCount
        threatLabel.Text = string.format("⚠ Threats: %d", threatCount)
        
        if threatCount > 0 then
            threatLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
            warningDot.Visible = true
        else
            threatLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            warningDot.Visible = false
        end
    end
end)

-- ========== TOGGLE WITH KEY ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        if mainFrame.Visible then
            mainFrame.Visible = false
            hubButton.Visible = true
        else
            hubButton.Visible = not hubButton.Visible
        end
    end
end)

print("✅ Flinger Logger Loaded - Threshold: "..VELOCITY_THRESHOLD)
