-- Anti-Fling Protection System

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local DETECTION_RANGE = 50        -- Studs to detect flinger
local VELOCITY_THRESHOLD = 50     -- Angular velocity threshold
local PROTECTION_RANGE = 30       -- Studs to activate protection
local SCAN_INTERVAL = 0.05        -- How fast to scan

-- Protection toggles
local anchorProtection = true
local velocityReset = true
local massBoost = true
local collisionDisable = true

-- State
local isProtected = false
local lastThreat = nil
local whitelist = {} -- Players to ignore

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiFling"
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
hubIcon.Text = "🛡️"
hubIcon.Font = Enum.Font.GothamBold
hubIcon.TextSize = 24
hubIcon.Parent = hubButton

-- Protection indicator on hub
local protectDot = Instance.new("Frame")
protectDot.Size = UDim2.new(0, 14, 0, 14)
protectDot.Position = UDim2.new(1, -9, 0, -5)
protectDot.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
protectDot.Parent = hubButton

local protectDotCorner = Instance.new("UICorner")
protectDotCorner.CornerRadius = UDim.new(1, 0)
protectDotCorner.Parent = protectDot

-- ========== MAIN FRAME ==========
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
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
titleLabel.Text = "🛡️ Anti-Fling Protection"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

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

-- ========== STATUS ==========
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, -20, 0, 50)
statusFrame.Position = UDim2.new(0, 10, 0, 42)
statusFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
statusFrame.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -16, 0, 20)
statusLabel.Position = UDim2.new(0, 8, 0, 6)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.Text = "✓ PROTECTION ACTIVE"
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusFrame

local threatLabel = Instance.new("TextLabel")
threatLabel.Size = UDim2.new(1, -16, 0, 18)
threatLabel.Position = UDim2.new(0, 8, 0, 28)
threatLabel.BackgroundTransparency = 1
threatLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
threatLabel.Text = "No threats nearby"
threatLabel.Font = Enum.Font.Gotham
threatLabel.TextSize = 11
threatLabel.TextXAlignment = Enum.TextXAlignment.Left
threatLabel.Parent = statusFrame

-- ========== SETTINGS ==========
local settingsLabel = Instance.new("TextLabel")
settingsLabel.Size = UDim2.new(1, -20, 0, 20)
settingsLabel.Position = UDim2.new(0, 10, 0, 100)
settingsLabel.BackgroundTransparency = 1
settingsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
settingsLabel.Text = "Protection Methods"
settingsLabel.Font = Enum.Font.GothamBold
settingsLabel.TextSize = 12
settingsLabel.TextXAlignment = Enum.TextXAlignment.Left
settingsLabel.Parent = mainFrame

-- Anchor Toggle
local anchorRow = Instance.new("Frame")
anchorRow.Size = UDim2.new(1, -20, 0, 32)
anchorRow.Position = UDim2.new(0, 10, 0, 122)
anchorRow.BackgroundTransparency = 1
anchorRow.Parent = mainFrame

local anchorLabel = Instance.new("TextLabel")
anchorLabel.Size = UDim2.new(1, -70, 1, 0)
anchorLabel.BackgroundTransparency = 1
anchorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
anchorLabel.Text = "🔧 Anchor (Locks you in place)"
anchorLabel.Font = Enum.Font.Gotham
anchorLabel.TextSize = 11
anchorLabel.TextXAlignment = Enum.TextXAlignment.Left
anchorLabel.Parent = anchorRow

local anchorBtn = Instance.new("TextButton")
anchorBtn.Size = UDim2.new(0, 55, 1, 0)
anchorBtn.Position = UDim2.new(1, -55, 0, 0)
anchorBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
anchorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
anchorBtn.Text = "ON"
anchorBtn.Font = Enum.Font.GothamBold
anchorBtn.TextSize = 11
anchorBtn.Parent = anchorRow

local anchorCorner = Instance.new("UICorner")
anchorCorner.CornerRadius = UDim.new(0, 6)
anchorCorner.Parent = anchorBtn

-- Velocity Reset Toggle
local velocityRow = Instance.new("Frame")
velocityRow.Size = UDim2.new(1, -20, 0, 32)
velocityRow.Position = UDim2.new(0, 10, 0, 156)
velocityRow.BackgroundTransparency = 1
velocityRow.Parent = mainFrame

local velocityLabel = Instance.new("TextLabel")
velocityLabel.Size = UDim2.new(1, -70, 1, 0)
velocityLabel.BackgroundTransparency = 1
velocityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
velocityLabel.Text = "🌀 Velocity Reset (Stops movement)"
velocityLabel.Font = Enum.Font.Gotham
velocityLabel.TextSize = 11
velocityLabel.TextXAlignment = Enum.TextXAlignment.Left
velocityLabel.Parent = velocityRow

local velocityBtn = Instance.new("TextButton")
velocityBtn.Size = UDim2.new(0, 55, 1, 0)
velocityBtn.Position = UDim2.new(1, -55, 0, 0)
velocityBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
velocityBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
velocityBtn.Text = "ON"
velocityBtn.Font = Enum.Font.GothamBold
velocityBtn.TextSize = 11
velocityBtn.Parent = velocityRow

local velocityCorner = Instance.new("UICorner")
velocityCorner.CornerRadius = UDim.new(0, 6)
velocityCorner.Parent = velocityBtn

-- Mass Boost Toggle
local massRow = Instance.new("Frame")
massRow.Size = UDim2.new(1, -20, 0, 32)
massRow.Position = UDim2.new(0, 10, 0, 190)
massRow.BackgroundTransparency = 1
massRow.Parent = mainFrame

local massLabel = Instance.new("TextLabel")
massLabel.Size = UDim2.new(1, -70, 1, 0)
massLabel.BackgroundTransparency = 1
massLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
massLabel.Text = "⚖️ Mass Boost (Harder to fling)"
massLabel.Font = Enum.Font.Gotham
massLabel.TextSize = 11
massLabel.TextXAlignment = Enum.TextXAlignment.Left
massLabel.Parent = massRow

local massBtn = Instance.new("TextButton")
massBtn.Size = UDim2.new(0, 55, 1, 0)
massBtn.Position = UDim2.new(1, -55, 0, 0)
massBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
massBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
massBtn.Text = "ON"
massBtn.Font = Enum.Font.GothamBold
massBtn.TextSize = 11
massBtn.Parent = massRow

local massCorner = Instance.new("UICorner")
massCorner.CornerRadius = UDim.new(0, 6)
massCorner.Parent = massBtn

-- Collision Toggle
local collisionRow = Instance.new("Frame")
collisionRow.Size = UDim2.new(1, -20, 0, 32)
collisionRow.Position = UDim2.new(0, 10, 0, 224)
collisionRow.BackgroundTransparency = 1
collisionRow.Parent = mainFrame

local collisionLabel = Instance.new("TextLabel")
collisionLabel.Size = UDim2.new(1, -70, 1, 0)
collisionLabel.BackgroundTransparency = 1
collisionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
collisionLabel.Text = "💥 No Collision (Phase through)"
collisionLabel.Font = Enum.Font.Gotham
collisionLabel.TextSize = 11
collisionLabel.TextXAlignment = Enum.TextXAlignment.Left
collisionLabel.Parent = collisionRow

local collisionBtn = Instance.new("TextButton")
collisionBtn.Size = UDim2.new(0, 55, 1, 0)
collisionBtn.Position = UDim2.new(1, -55, 0, 0)
collisionBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
collisionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
collisionBtn.Text = "ON"
collisionBtn.Font = Enum.Font.GothamBold
collisionBtn.TextSize = 11
collisionBtn.Parent = collisionRow

local collisionCorner = Instance.new("UICorner")
collisionCorner.CornerRadius = UDim.new(0, 6)
collisionCorner.Parent = collisionBtn

-- ========== RANGE SETTINGS ==========
local rangeLabel = Instance.new("TextLabel")
rangeLabel.Size = UDim2.new(1, -20, 0, 20)
rangeLabel.Position = UDim2.new(0, 10, 0, 265)
rangeLabel.BackgroundTransparency = 1
rangeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
rangeLabel.Text = "Range Settings"
rangeLabel.Font = Enum.Font.GothamBold
rangeLabel.TextSize = 12
rangeLabel.TextXAlignment = Enum.TextXAlignment.Left
rangeLabel.Parent = mainFrame

-- Detection Range
local detectRow = Instance.new("Frame")
detectRow.Size = UDim2.new(1, -20, 0, 28)
detectRow.Position = UDim2.new(0, 10, 0, 287)
detectRow.BackgroundTransparency = 1
detectRow.Parent = mainFrame

local detectLabel = Instance.new("TextLabel")
detectLabel.Size = UDim2.new(0, 120, 1, 0)
detectLabel.BackgroundTransparency = 1
detectLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
detectLabel.Text = "Detection Range:"
detectLabel.Font = Enum.Font.Gotham
detectLabel.TextSize = 11
detectLabel.TextXAlignment = Enum.TextXAlignment.Left
detectLabel.Parent = detectRow

local detectInput = Instance.new("TextBox")
detectInput.Size = UDim2.new(0, 50, 1, 0)
detectInput.Position = UDim2.new(0, 125, 0, 0)
detectInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
detectInput.TextColor3 = Color3.fromRGB(255, 255, 255)
detectInput.Text = tostring(DETECTION_RANGE)
detectInput.Font = Enum.Font.Gotham
detectInput.TextSize = 11
detectInput.Parent = detectRow

local detectCorner = Instance.new("UICorner")
detectCorner.CornerRadius = UDim.new(0, 4)
detectCorner.Parent = detectInput

local detectStuds = Instance.new("TextLabel")
detectStuds.Size = UDim2.new(0, 40, 1, 0)
detectStuds.Position = UDim2.new(0, 180, 0, 0)
detectStuds.BackgroundTransparency = 1
detectStuds.TextColor3 = Color3.fromRGB(150, 150, 150)
detectStuds.Text = "studs"
detectStuds.Font = Enum.Font.Gotham
detectStuds.TextSize = 11
detectStuds.TextXAlignment = Enum.TextXAlignment.Left
detectStuds.Parent = detectRow

-- Protection Range
local protectRow = Instance.new("Frame")
protectRow.Size = UDim2.new(1, -20, 0, 28)
protectRow.Position = UDim2.new(0, 10, 0, 319)
protectRow.BackgroundTransparency = 1
protectRow.Parent = mainFrame

local protectLabel = Instance.new("TextLabel")
protectLabel.Size = UDim2.new(0, 120, 1, 0)
protectLabel.BackgroundTransparency = 1
protectLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
protectLabel.Text = "Protection Range:"
protectLabel.Font = Enum.Font.Gotham
protectLabel.TextSize = 11
protectLabel.TextXAlignment = Enum.TextXAlignment.Left
protectLabel.Parent = protectRow

local protectInput = Instance.new("TextBox")
protectInput.Size = UDim2.new(0, 50, 1, 0)
protectInput.Position = UDim2.new(0, 125, 0, 0)
protectInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
protectInput.TextColor3 = Color3.fromRGB(255, 255, 255)
protectInput.Text = tostring(PROTECTION_RANGE)
protectInput.Font = Enum.Font.Gotham
protectInput.TextSize = 11
protectInput.Parent = protectRow

local protectCorner = Instance.new("UICorner")
protectCorner.CornerRadius = UDim.new(0, 4)
protectCorner.Parent = protectInput

local protectStuds = Instance.new("TextLabel")
protectStuds.Size = UDim2.new(0, 40, 1, 0)
protectStuds.Position = UDim2.new(0, 180, 0, 0)
protectStuds.BackgroundTransparency = 1
protectStuds.TextColor3 = Color3.fromRGB(150, 150, 150)
protectStuds.Text = "studs"
protectStuds.Font = Enum.Font.Gotham
protectStuds.TextSize = 11
protectStuds.TextXAlignment = Enum.TextXAlignment.Left
protectStuds.Parent = protectRow

-- ========== WHITELIST ==========
local whitelistLabel = Instance.new("TextLabel")
whitelistLabel.Size = UDim2.new(1, -20, 0, 20)
whitelistLabel.Position = UDim2.new(0, 10, 0, 355)
whitelistLabel.BackgroundTransparency = 1
whitelistLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
whitelistLabel.Text = "Whitelist (Ignore these players)"
whitelistLabel.Font = Enum.Font.GothamBold
whitelistLabel.TextSize = 12
whitelistLabel.TextXAlignment = Enum.TextXAlignment.Left
whitelistLabel.Parent = mainFrame

local whitelistInput = Instance.new("TextBox")
whitelistInput.Size = UDim2.new(1, -80, 0, 28)
whitelistInput.Position = UDim2.new(0, 10, 0, 377)
whitelistInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
whitelistInput.TextColor3 = Color3.fromRGB(255, 255, 255)
whitelistInput.Text = ""
whitelistInput.PlaceholderText = "Username1, Username2"
whitelistInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
whitelistInput.Font = Enum.Font.Gotham
whitelistInput.TextSize = 11
whitelistInput.Parent = mainFrame

local whitelistCorner = Instance.new("UICorner")
whitelistCorner.CornerRadius = UDim.new(0, 4)
whitelistCorner.Parent = whitelistInput

local addWhitelistBtn = Instance.new("TextButton")
addWhitelistBtn.Size = UDim2.new(0, 60, 0, 28)
addWhitelistBtn.Position = UDim2.new(1, -70, 0, 377)
addWhitelistBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
addWhitelistBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addWhitelistBtn.Text = "Add"
addWhitelistBtn.Font = Enum.Font.GothamBold
addWhitelistBtn.TextSize = 11
addWhitelistBtn.Parent = mainFrame

local addWhitelistCorner = Instance.new("UICorner")
addWhitelistCorner.CornerRadius = UDim.new(0, 4)
addWhitelistCorner.Parent = addWhitelistBtn

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

-- ========== TOGGLE BUTTONS ==========
local function toggleButton(btn, varName)
    if varName == "anchor" then
        anchorProtection = not anchorProtection
        btn.Text = anchorProtection and "ON" or "OFF"
        btn.BackgroundColor3 = anchorProtection and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(108, 117, 125)
    elseif varName == "velocity" then
        velocityReset = not velocityReset
        btn.Text = velocityReset and "ON" or "OFF"
        btn.BackgroundColor3 = velocityReset and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(108, 117, 125)
    elseif varName == "mass" then
        massBoost = not massBoost
        btn.Text = massBoost and "ON" or "OFF"
        btn.BackgroundColor3 = massBoost and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(108, 117, 125)
    elseif varName == "collision" then
        collisionDisable = not collisionDisable
        btn.Text = collisionDisable and "ON" or "OFF"
        btn.BackgroundColor3 = collisionDisable and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(108, 117, 125)
    end
end

anchorBtn.MouseButton1Click:Connect(function() toggleButton(anchorBtn, "anchor") end)
velocityBtn.MouseButton1Click:Connect(function() toggleButton(velocityBtn, "velocity") end)
massBtn.MouseButton1Click:Connect(function() toggleButton(massBtn, "mass") end)
collisionBtn.MouseButton1Click:Connect(function() toggleButton(collisionBtn, "collision") end)

-- ========== RANGE SETTINGS ==========
detectInput.FocusLost:Connect(function()
    local val = tonumber(detectInput.Text)
    if val and val > 0 then
        DETECTION_RANGE = val
    else
        detectInput.Text = tostring(DETECTION_RANGE)
    end
end)

protectInput.FocusLost:Connect(function()
    local val = tonumber(protectInput.Text)
    if val and val > 0 then
        PROTECTION_RANGE = val
    else
        protectInput.Text = tostring(PROTECTION_RANGE)
    end
end)

-- ========== WHITELIST ==========
addWhitelistBtn.MouseButton1Click:Connect(function()
    local text = whitelistInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if text ~= "" then
        for name in text:gmatch("[^,^]+") do
            local cleanName = name:gsub("^%s+", ""):gsub("%s+$", ""):lower()
            if cleanName ~= "" then
                whitelist[cleanName] = true
            end
        end
        whitelistInput.Text = ""
        -- Show confirmation
        addWhitelistBtn.Text = "Added!"
        addWhitelistBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
        wait(0.5)
        addWhitelistBtn.Text = "Add"
        addWhitelistBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end
end)

-- ========== PROTECTION FUNCTIONS ==========
local lastAnchorState = false
local lastMass = {}
local lastCollision = {}
local originalMasses = {}
local originalCollisions = {}

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChild("Humanoid")
end

local function getAllParts()
    local char = getCharacter()
    if not char then return {} end
    
    local parts = {}
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(parts, part)
        end
    end
    return parts
end

-- Apply protection
local function applyProtection(threatName, threatDistance)
    local hrp = getHRP()
    local humanoid = getHumanoid()
    local parts = getAllParts()
    
    if not hrp then return end
    
    -- ANCHOR PROTECTION
    if anchorProtection then
        if not lastAnchorState then
            hrp.Anchored = true
            lastAnchorState = true
        end
    end
    
    -- VELOCITY RESET
    if velocityReset then
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
    
    -- MASS BOOST
    if massBoost then
        for _, part in pairs(parts) do
            if not originalMasses[part] then
                originalMasses[part] = part:GetAttribute("OriginalMass") or part.CustomPhysicalProperties and part.CustomPhysicalProperties.Density or 1
            end
            
            local physProps = part.CustomPhysicalProperties or PhysicalProperties.new(1, 0.3, 0.5)
            part.CustomPhysicalProperties = PhysicalProperties.new(
                100,  -- Very high density
                physProps.Friction,
                physProps.Elasticity,
                physProps.FrictionWeight,
                physProps.ElasticityWeight
            )
        end
    end
    
    -- COLLISION DISABLE (with threat only)
    if collisionDisable then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Name:lower() ~= threatName:lower() then
                -- Check if they're a threat
                local plrChar = plr.Character
                local plrHrp = plrChar and plrChar:FindFirstChild("HumanoidRootPart")
                
                if plrHrp then
                    local angularVel = plrHrp.AssemblyAngularVelocity
                    local totalVel = math.abs(angularVel.X) + math.abs(angularVel.Y) + math.abs(angularVel.Z)
                    
                    if totalVel > VELOCITY_THRESHOLD then
                        -- Disable collision with this threat
                        for _, myPart in pairs(parts) do
                            for _, theirPart in pairs(plrChar:GetDescendants()) do
                                if theirPart:IsA("BasePart") then
                                    myPart.CanCollide = false
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Update UI
    statusLabel.Text = "⚠ PROTECTION TRIGGERED"
    statusLabel.TextColor3 = Color3.fromRGB(255, 193, 7)
    threatLabel.Text = string.format("Threat: %s (%.1f studs)", threatName, threatDistance)
    threatLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    protectDot.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
end

-- Remove protection
local function removeProtection()
    local hrp = getHRP()
    local parts = getAllParts()
    
    if anchorProtection and lastAnchorState then
        if hrp then
            hrp.Anchored = false
        end
        lastAnchorState = false
    end
    
    -- Restore masses
    if massBoost then
        for _, part in pairs(parts) do
            if originalMasses[part] then
                local physProps = part.CustomPhysicalProperties or PhysicalProperties.new(1, 0.3, 0.5)
                part.CustomPhysicalProperties = PhysicalProperties.new(
                    originalMasses[part],
                    physProps.Friction,
                    physProps.Elasticity,
                    physProps.FrictionWeight,
                    physProps.ElasticityWeight
                )
            end
        end
    end
    
    -- Restore collisions
    if collisionDisable then
        for _, part in pairs(parts) do
            if part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
    
    -- Update UI
    statusLabel.Text = "✓ PROTECTION ACTIVE"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    threatLabel.Text = "No threats nearby"
    threatLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    protectDot.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
end

-- ========== SCAN LOOP ==========
local lastScanTime = 0

RunService.Heartbeat:Connect(function()
    local currentTime = tick()
    if currentTime - lastScanTime < SCAN_INTERVAL then return end
    lastScanTime = currentTime
    
    local hrp = getHRP()
    if not hrp then return end
    
    local nearestThreat = nil
    local nearestDistance = math.huge
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            -- Check whitelist
            if whitelist[plr.Name:lower()] then
                -- Skip whitelisted players
            else
                local plrChar = plr.Character
                local plrHrp = plrChar and plrChar:FindFirstChild("HumanoidRootPart")
                
                if plrHrp then
                    local angularVel = plrHrp.AssemblyAngularVelocity
                    local totalVel = math.abs(angularVel.X) + math.abs(angularVel.Y) + math.abs(angularVel.Z)
                    local distance = (plrHrp.Position - hrp.Position).Magnitude
                    
                    -- Check if threat
                    if totalVel > VELOCITY_THRESHOLD and distance < DETECTION_RANGE then
                        if distance < nearestDistance then
                            nearestThreat = plr.Name
                            nearestDistance = distance
                        end
                    end
                end
            end
        end
    end
    
    -- Apply or remove protection
    if nearestThreat and nearestDistance <= PROTECTION_RANGE then
        applyProtection(nearestThreat, nearestDistance)
        isProtected = true
        lastThreat = nearestThreat
    else
        if isProtected then
            removeProtection()
            isProtected = false
            lastThreat = nil
        end
    end
    
    -- Always reset velocity if protection is on and velocity reset enabled
    if velocityReset and isProtected then
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
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

print("✅ Anti-Fling Protection Loaded")
print("Detection Range: "..DETECTION_RANGE.." studs")
print("Protection Range: "..PROTECTION_RANGE.." studs")
