-- Network Fling Script (Actually works on other players)
-- Uses collision physics which replicates

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local flingEnabled = false
local targetPlayer = nil
local spinSpeed = 999999999
local flingTime = 5
local autoRefling = true
local respawnWait = 3

-- Colors
local COLORS = {
    background = Color3.fromRGB(245, 245, 245),
    header = Color3.fromRGB(255, 255, 255),
    buttonPrimary = Color3.fromRGB(0, 120, 215),
    buttonDanger = Color3.fromRGB(220, 53, 69),
    buttonSuccess = Color3.fromRGB(40, 167, 69),
    textDark = Color3.fromRGB(33, 37, 41),
    textLight = Color3.fromRGB(255, 255, 255),
    textMuted = Color3.fromRGB(134, 142, 150),
    inputBg = Color3.fromRGB(255, 255, 255),
    border = Color3.fromRGB(222, 226, 230),
    cardBg = Color3.fromRGB(255, 255, 255)
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========== HUB BUTTON ==========

local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 50, 0, 50)
hubButton.Position = UDim2.new(0, 20, 0.5, -25)
hubButton.BackgroundColor3 = COLORS.cardBg
hubButton.BorderSizePixel = 0
hubButton.Visible = true
hubButton.Parent = screenGui

local hubButtonCorner = Instance.new("UICorner")
hubButtonCorner.CornerRadius = UDim.new(0, 10)
hubButtonCorner.Parent = hubButton

local hubButtonShadow = Instance.new("UIStroke")
hubButtonShadow.Color = COLORS.border
hubButtonShadow.Thickness = 1
hubButtonShadow.Parent = hubButton

local hubButtonIcon = Instance.new("TextLabel")
hubButtonIcon.Size = UDim2.new(1, 0, 1, 0)
hubButtonIcon.BackgroundTransparency = 1
hubButtonIcon.TextColor3 = COLORS.textDark
hubButtonIcon.Text = "🌀"
hubButtonIcon.Font = Enum.Font.GothamBold
hubButtonIcon.TextSize = 22
hubButtonIcon.Parent = hubButton

-- ========== MAIN FRAME ==========

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 280)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
mainFrame.BackgroundColor3 = COLORS.background
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 14)
mainFrameCorner.Parent = mainFrame

local mainFrameShadow = Instance.new("UIStroke")
mainFrameShadow.Color = Color3.fromRGB(180, 180, 180)
mainFrameShadow.Thickness = 1
mainFrameShadow.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = COLORS.header
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 14)
titleBarCorner.Parent = titleBar

local titleBarFix = Instance.new("Frame")
titleBarFix.Size = UDim2.new(1, 0, 0, 14)
titleBarFix.Position = UDim2.new(0, 0, 1, -14)
titleBarFix.BackgroundColor3 = COLORS.header
titleBarFix.BorderSizePixel = 0
titleBarFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = COLORS.textDark
titleLabel.Text = "🌀 Network Fling"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 28, 0, 22)
collapseButton.Position = UDim2.new(1, -35, 0.5, -11)
collapseButton.BackgroundColor3 = COLORS.buttonDanger
collapseButton.TextColor3 = COLORS.textLight
collapseButton.Text = "✕"
collapseButton.Font = Enum.Font.GothamBold
collapseButton.TextSize = 11
collapseButton.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseButton

-- ========== LEFT FRAME ==========

local leftFrame = Instance.new("Frame")
leftFrame.Size = UDim2.new(0.5, -15, 1, -50)
leftFrame.Position = UDim2.new(0, 10, 0, 40)
leftFrame.BackgroundTransparency = 1
leftFrame.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 0, 35)
toggleButton.Position = UDim2.new(0, 0, 0, 0)
toggleButton.BackgroundColor3 = COLORS.buttonDanger
toggleButton.TextColor3 = COLORS.textLight
toggleButton.Text = "FLING: OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = leftFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Fling Counter
local flingCounter = Instance.new("TextLabel")
flingCounter.Size = UDim2.new(1, 0, 0, 18)
flingCounter.Position = UDim2.new(0, 0, 0, 40)
flingCounter.BackgroundTransparency = 1
flingCounter.TextColor3 = COLORS.buttonSuccess
flingCounter.Text = "Flings: 0"
flingCounter.Font = Enum.Font.GothamBold
flingCounter.TextSize = 11
flingCounter.Parent = leftFrame

-- Target Label
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, 0, 0, 16)
targetLabel.Position = UDim2.new(0, 0, 0, 58)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = COLORS.textDark
targetLabel.Text = "Select Target:"
targetLabel.Font = Enum.Font.GothamBold
targetLabel.TextSize = 10
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = leftFrame

-- Player List
local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1, 0, 0, 105)
playerScroll.Position = UDim2.new(0, 0, 0, 76)
playerScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerScroll.ScrollBarThickness = 4
playerScroll.Parent = leftFrame

local playerScrollCorner = Instance.new("UICorner")
playerScrollCorner.CornerRadius = UDim.new(0, 6)
playerScrollCorner.Parent = playerScroll

local playerLayout = Instance.new("UIListLayout")
playerLayout.Padding = UDim.new(0, 2)
playerLayout.Parent = playerScroll

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.Position = UDim2.new(0, 0, 0, 185)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = COLORS.textMuted
statusLabel.Text = "No target selected"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextWrapped = true
statusLabel.Parent = leftFrame

-- ========== RIGHT FRAME ==========

local rightFrame = Instance.new("Frame")
rightFrame.Size = UDim2.new(0.5, -15, 1, -50)
rightFrame.Position = UDim2.new(0.5, 5, 0, 40)
rightFrame.BackgroundTransparency = 1
rightFrame.Parent = mainFrame

-- Settings Header
local settingsHeader = Instance.new("TextLabel")
settingsHeader.Size = UDim2.new(1, 0, 0, 18)
settingsHeader.Position = UDim2.new(0, 0, 0, 0)
settingsHeader.BackgroundTransparency = 1
settingsHeader.TextColor3 = COLORS.textDark
settingsHeader.Text = "Settings"
settingsHeader.Font = Enum.Font.GothamBold
settingsHeader.TextSize = 11
settingsHeader.TextXAlignment = Enum.TextXAlignment.Left
settingsHeader.Parent = rightFrame

-- Fling Duration
local timeRow = Instance.new("Frame")
timeRow.Size = UDim2.new(1, 0, 0, 22)
timeRow.Position = UDim2.new(0, 0, 0, 20)
timeRow.BackgroundTransparency = 1
timeRow.Parent = rightFrame

local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(0, 110, 1, 0)
timeLabel.BackgroundTransparency = 1
timeLabel.TextColor3 = COLORS.textDark
timeLabel.Text = "Fling Duration:"
timeLabel.Font = Enum.Font.Gotham
timeLabel.TextSize = 10
timeLabel.TextXAlignment = Enum.TextXAlignment.Left
timeLabel.Parent = timeRow

local timeInput = Instance.new("TextBox")
timeInput.Size = UDim2.new(0, 60, 1, 0)
timeInput.Position = UDim2.new(0, 115, 0, 0)
timeInput.BackgroundColor3 = COLORS.inputBg
timeInput.TextColor3 = COLORS.textDark
timeInput.Text = "5"
timeInput.Font = Enum.Font.Gotham
timeInput.TextSize = 10
timeInput.ClearTextOnFocus = false
timeInput.Parent = timeRow

local timeCorner = Instance.new("UICorner")
timeCorner.CornerRadius = UDim.new(0, 5)
timeCorner.Parent = timeInput

local timeStroke = Instance.new("UIStroke")
timeStroke.Color = COLORS.border
timeStroke.Thickness = 1
timeStroke.Parent = timeInput

local timeHint = Instance.new("TextLabel")
timeHint.Size = UDim2.new(0, 70, 1, 0)
timeHint.Position = UDim2.new(0, 180, 0, 0)
timeHint.BackgroundTransparency = 1
timeHint.TextColor3 = COLORS.textMuted
timeHint.Text = "seconds"
timeHint.Font = Enum.Font.Gotham
timeHint.TextSize = 9
timeHint.TextXAlignment = Enum.TextXAlignment.Left
timeHint.Parent = timeRow

-- Respawn Wait
local respawnRow = Instance.new("Frame")
respawnRow.Size = UDim2.new(1, 0, 0, 22)
respawnRow.Position = UDim2.new(0, 0, 0, 46)
respawnRow.BackgroundTransparency = 1
respawnRow.Parent = rightFrame

local respawnLabel = Instance.new("TextLabel")
respawnLabel.Size = UDim2.new(0, 110, 1, 0)
respawnLabel.BackgroundTransparency = 1
respawnLabel.TextColor3 = COLORS.textDark
respawnLabel.Text = "Respawn Wait:"
respawnLabel.Font = Enum.Font.Gotham
respawnLabel.TextSize = 10
respawnLabel.TextXAlignment = Enum.TextXAlignment.Left
respawnLabel.Parent = respawnRow

local respawnInput = Instance.new("TextBox")
respawnInput.Size = UDim2.new(0, 60, 1, 0)
respawnInput.Position = UDim2.new(0, 115, 0, 0)
respawnInput.BackgroundColor3 = COLORS.inputBg
respawnInput.TextColor3 = COLORS.textDark
respawnInput.Text = "3"
respawnInput.Font = Enum.Font.Gotham
respawnInput.TextSize = 10
respawnInput.ClearTextOnFocus = false
respawnInput.Parent = respawnRow

local respawnCorner = Instance.new("UICorner")
respawnCorner.CornerRadius = UDim.new(0, 5)
respawnCorner.Parent = respawnInput

local respawnStroke = Instance.new("UIStroke")
respawnStroke.Color = COLORS.border
respawnStroke.Thickness = 1
respawnStroke.Parent = respawnInput

local respawnHint = Instance.new("TextLabel")
respawnHint.Size = UDim2.new(0, 70, 1, 0)
respawnHint.Position = UDim2.new(0, 180, 0, 0)
respawnHint.BackgroundTransparency = 1
respawnHint.TextColor3 = COLORS.textMuted
respawnHint.Text = "seconds"
respawnHint.Font = Enum.Font.Gotham
respawnHint.TextSize = 9
respawnHint.TextXAlignment = Enum.TextXAlignment.Left
respawnHint.Parent = respawnRow

-- Auto Re-Fling Toggle
local autoToggle = Instance.new("TextButton")
autoToggle.Size = UDim2.new(1, 0, 0, 28)
autoToggle.Position = UDim2.new(0, 0, 0, 75)
autoToggle.BackgroundColor3 = COLORS.buttonSuccess
autoToggle.TextColor3 = COLORS.textLight
autoToggle.Text = "AUTO RE-FLING: ON"
autoToggle.Font = Enum.Font.GothamBold
autoToggle.TextSize = 10
autoToggle.Parent = rightFrame

local autoToggleCorner = Instance.new("UICorner")
autoToggleCorner.CornerRadius = UDim.new(0, 6)
autoToggleCorner.Parent = autoToggle

-- Info Label
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 40)
infoLabel.Position = UDim2.new(0, 0, 0, 110)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = COLORS.textMuted
infoLabel.Text = "Uses physics collision to fling.\nWorks on other players."
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 9
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = rightFrame

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

local hubDragging = false
local hubDragInput, hubDragStart, hubDragPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        hubDragging = true
        hubDragStart = input.Position
        hubDragPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                hubDragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        hubDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == hubDragInput and hubDragging then
        local delta = input.Position - hubDragStart
        mainFrame.Position = UDim2.new(hubDragPos.X.Scale, hubDragPos.X.Offset + delta.X, hubDragPos.Y.Scale, hubDragPos.Y.Offset + delta.Y)
    end
end)

-- ========== TOGGLE HUB ==========

hubButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        wait(0.1)
        if not dragging then
            hubButton.Visible = false
            mainFrame.Visible = true
        end
    end
end)

collapseButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

-- ========== PLAYER LIST ==========

local playerButtons = {}
local flingCount = 0

local function updatePlayerList()
    for _, btn in pairs(playerButtons) do
        btn:Destroy()
    end
    playerButtons = {}
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 22)
            btn.BackgroundColor3 = targetPlayer == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn.TextColor3 = targetPlayer == plr and COLORS.textLight or COLORS.textDark
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 10
            btn.Parent = playerScroll
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                targetPlayer = plr
                statusLabel.Text = "Target: " .. plr.Name
                updatePlayerList()
            end)
            
            table.insert(playerButtons, btn)
        end
    end
    
    playerScroll.CanvasSize = UDim2.new(0, 0, 0, #playerButtons * 24)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerList()
end)

updatePlayerList()

-- ========== AUTO RE-FLING TOGGLE ==========

autoToggle.MouseButton1Click:Connect(function()
    autoRefling = not autoRefling
    
    if autoRefling then
        autoToggle.Text = "AUTO RE-FLING: ON"
        autoToggle.BackgroundColor3 = COLORS.buttonSuccess
    else
        autoToggle.Text = "AUTO RE-FLING: OFF"
        autoToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

-- ========== FLING FUNCTION ==========

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function flingTarget()
    local myChar = player.Character
    if not myChar then return false, "no char" end
    
    local myRoot = getRoot(myChar)
    local myHumanoid = myChar:FindFirstChild("Humanoid")
    
    if not myRoot or not myHumanoid then return false, "no root" end
    
    local targetChar = targetPlayer.Character
    if not targetChar then return false, "no target char" end
    
    local targetRoot = getRoot(targetChar)
    local targetHumanoid = targetChar:FindFirstChild("Humanoid")
    
    if not targetRoot or not targetHumanoid then return false, "no target root" end
    if targetHumanoid.Health <= 0 then return false, "dead" end
    
    -- Check spawn protection
    local forceField = targetChar:FindFirstChild("ForceField")
    if forceField then
        return false, "protection"
    end
    
    -- Store original state
    local originalAnchored = myRoot.Anchored
    
    -- Step 1: Teleport to target
    myRoot.CFrame = targetRoot.CFrame
    
    -- Step 2: Set extreme angular velocity (this is what causes the fling)
    -- Using AssemblyAngularVelocity which is the modern way
    for _, part in pairs(myChar:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
            part.Massless = false
        end
    end
    
    -- Set our root part to have extreme angular velocity
    myRoot.AssemblyAngularVelocity = Vector3.new(math.huge, math.huge, math.huge)
    
    -- Step 3: Keep teleporting to target while spinning
    -- This ensures constant collision
    local flingStart = tick()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if tick() - flingStart > flingTime then
            connection:Disconnect()
            return
        end
        if targetRoot and myRoot then
            -- Keep teleporting inside them
            myRoot.CFrame = targetRoot.CFrame + Vector3.new(math.random(-1, 1), 0, math.random(-1, 1))
        end
    end)
    
    -- Wait for fling duration
    wait(flingTime)
    
    -- Step 4: Stop spinning and clean up
    if connection then
        connection:Disconnect()
    end
    
    myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    myRoot.Velocity = Vector3.new(0, 0, 0)
    
    -- Reset all body parts
    for _, part in pairs(myChar:GetDescendants()) do
        if part:IsA("BasePart") then
            part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            part.Velocity = Vector3.new(0, 0, 0)
        end
    end
    
    return true
end

-- ========== FLING LOOP ==========

toggleButton.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    flingTime = tonumber(timeInput.Text) or 5
    if flingTime < 1 then flingTime = 1 end
    if flingTime > 15 then flingTime = 15 end
    
    respawnWait = tonumber(respawnInput.Text) or 3
    if respawnWait < 1 then respawnWait = 1 end
    
    if flingEnabled then
        toggleButton.Text = "FLING: ON"
        toggleButton.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
        
        spawn(function()
            while flingEnabled do
                if targetPlayer and targetPlayer.Character then
                    local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                    
                    if targetHumanoid and targetHumanoid.Health > 0 then
                        local success, reason = flingTarget()
                        
                        if success then
                            flingCount = flingCount + 1
                            flingCounter.Text = "Flings: " .. flingCount
                            statusLabel.Text = "Flinged " .. targetPlayer.Name .. "!"
                        elseif reason == "protection" then
                            statusLabel.Text = "Waiting for spawn protection..."
                            wait(3)
                        else
                            statusLabel.Text = "Fling failed: " .. (reason or "unknown")
                        end
                    else
                        if autoRefling then
                            statusLabel.Text = "Waiting for respawn..."
                            wait(respawnWait)
                        else
                            statusLabel.Text = "Target dead!"
                            break
                        end
                    end
                else
                    if autoRefling then
                        statusLabel.Text = "Waiting for target..."
                        wait(1)
                    else
                        statusLabel.Text = "Target not found!"
                        break
                    end
                end
                
                wait(0.5)
            end
        end)
        
    else
        toggleButton.Text = "FLING: OFF"
        toggleButton.BackgroundColor3 = COLORS.buttonDanger
        statusLabel.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
        
        -- Clean up
        local myChar = player.Character
        if myChar then
            local myRoot = getRoot(myChar)
            if myRoot then
                myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                myRoot.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

-- Toggle with key
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

-- Cleanup on death
player.CharacterRemoving:Connect(function()
    flingEnabled = false
    toggleButton.Text = "FLING: OFF"
    toggleButton.BackgroundColor3 = COLORS.buttonDanger
end)

print("✅ Network Fling Loaded")
