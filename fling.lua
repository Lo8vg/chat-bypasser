-- Auto Fling Script
-- Flings target to the sky, loops on respawn

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local flingEnabled = false
local targetPlayer = nil
local flingPower = 5000
local flingDelay = 1

-- Colors
local COLORS = {
    background = Color3.fromRGB(245, 245, 245),
    header = Color3.fromRGB(255, 255, 255),
    buttonPrimary = Color3.fromRGB(0, 120, 215),
    buttonDanger = Color3.fromRGB(220, 53, 69),
    buttonSuccess = Color3.fromRGB(40, 167, 69),
    buttonWarning = Color3.fromRGB(255, 193, 7),
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
titleLabel.Text = "🌀 Auto Fling"
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

-- Fling Power
local powerRow = Instance.new("Frame")
powerRow.Size = UDim2.new(1, 0, 0, 22)
powerRow.Position = UDim2.new(0, 0, 0, 20)
powerRow.BackgroundTransparency = 1
powerRow.Parent = rightFrame

local powerLabel = Instance.new("TextLabel")
powerLabel.Size = UDim2.new(0, 110, 1, 0)
powerLabel.BackgroundTransparency = 1
powerLabel.TextColor3 = COLORS.textDark
powerLabel.Text = "Fling Power:"
powerLabel.Font = Enum.Font.Gotham
powerLabel.TextSize = 10
powerLabel.TextXAlignment = Enum.TextXAlignment.Left
powerLabel.Parent = powerRow

local powerInput = Instance.new("TextBox")
powerInput.Size = UDim2.new(0, 60, 1, 0)
powerInput.Position = UDim2.new(0, 115, 0, 0)
powerInput.BackgroundColor3 = COLORS.inputBg
powerInput.TextColor3 = COLORS.textDark
powerInput.Text = "5000"
powerInput.Font = Enum.Font.Gotham
powerInput.TextSize = 10
powerInput.ClearTextOnFocus = false
powerInput.Parent = powerRow

local powerCorner = Instance.new("UICorner")
powerCorner.CornerRadius = UDim.new(0, 5)
powerCorner.Parent = powerInput

local powerStroke = Instance.new("UIStroke")
powerStroke.Color = COLORS.border
powerStroke.Thickness = 1
powerStroke.Parent = powerInput

local powerHint = Instance.new("TextLabel")
powerHint.Size = UDim2.new(0, 70, 1, 0)
powerHint.Position = UDim2.new(0, 180, 0, 0)
powerHint.BackgroundTransparency = 1
powerHint.TextColor3 = COLORS.textMuted
powerHint.Text = "(higher=far)"
powerHint.Font = Enum.Font.Gotham
powerHint.TextSize = 9
powerHint.TextXAlignment = Enum.TextXAlignment.Left
powerHint.Parent = powerRow

-- Fling Delay
local delayRow = Instance.new("Frame")
delayRow.Size = UDim2.new(1, 0, 0, 22)
delayRow.Position = UDim2.new(0, 0, 0, 46)
delayRow.BackgroundTransparency = 1
delayRow.Parent = rightFrame

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 110, 1, 0)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = COLORS.textDark
delayLabel.Text = "Fling Delay:"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 10
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = delayRow

local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0, 60, 1, 0)
delayInput.Position = UDim2.new(0, 115, 0, 0)
delayInput.BackgroundColor3 = COLORS.inputBg
delayInput.TextColor3 = COLORS.textDark
delayInput.Text = "1"
delayInput.Font = Enum.Font.Gotham
delayInput.TextSize = 10
delayInput.ClearTextOnFocus = false
delayInput.Parent = delayRow

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 5)
delayCorner.Parent = delayInput

local delayStroke = Instance.new("UIStroke")
delayStroke.Color = COLORS.border
delayStroke.Thickness = 1
delayStroke.Parent = delayInput

local delayHint = Instance.new("TextLabel")
delayHint.Size = UDim2.new(0, 70, 1, 0)
delayHint.Position = UDim2.new(0, 180, 0, 0)
delayHint.BackgroundTransparency = 1
delayHint.TextColor3 = COLORS.textMuted
delayHint.Text = "seconds"
delayHint.Font = Enum.Font.Gotham
delayHint.TextSize = 9
delayHint.TextXAlignment = Enum.TextXAlignment.Left
delayHint.Parent = delayRow

-- Respawn Wait
local respawnRow = Instance.new("Frame")
respawnRow.Size = UDim2.new(1, 0, 0, 22)
respawnRow.Position = UDim2.new(0, 0, 0, 72)
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
autoToggle.Position = UDim2.new(0, 0, 0, 100)
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
infoLabel.Size = UDim2.new(1, 0, 0, 30)
infoLabel.Position = UDim2.new(0, 0, 0, 135)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = COLORS.textMuted
infoLabel.Text = "Auto re-flings target\nafter they respawn"
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
local autoRefling = true

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

local function flingTarget()
    if not targetPlayer then return false end
    
    local myChar = player.Character
    local myHum = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar and myChar:FindFirstChild("Humanoid")
    
    local targetChar = targetPlayer.Character
    local targetHum = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = targetChar and targetChar:FindFirstChild("Humanoid")
    
    if not myHum or not myHumanoid or not targetHum or not targetHumanoid then
        return false
    end
    
    if targetHumanoid.Health <= 0 then
        return false
    end
    
    -- Get network ownership
    targetHum:SetNetworkOwner(nil)
    
    -- Teleport inside target
    myHum.CFrame = targetHum.CFrame
    
    -- Set high velocity (fling)
    myHum.Velocity = Vector3.new(0, flingPower, 0)
    myHum.RotVelocity = Vector3.new(flingPower, flingPower, flingPower)
    
    -- Push
    for i = 1, 10 do
        myHum.CFrame = targetHum.CFrame
        wait(0.01)
    end
    
    -- Reset my velocity
    wait(0.1)
    myHum.Velocity = Vector3.new(0, 0, 0)
    myHum.RotVelocity = Vector3.new(0, 0, 0)
    
    return true
end

-- ========== FLING LOOP ==========

toggleButton.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    flingPower = tonumber(powerInput.Text) or 5000
    if flingPower < 100 then flingPower = 100 end
    if flingPower > 50000 then flingPower = 50000 end
    
    flingDelay = tonumber(delayInput.Text) or 1
    if flingDelay < 0.1 then flingDelay = 0.1 end
    
    local respawnWait = tonumber(respawnInput.Text) or 3
    if respawnWait < 1 then respawnWait = 1 end
    
    if flingEnabled then
        toggleButton.Text = "FLING: ON"
        toggleButton.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel.Text = targetPlayer and ("Flinging: " .. targetPlayer.Name) or "No target selected"
        
        spawn(function()
            while flingEnabled do
                if targetPlayer and targetPlayer.Character then
                    local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                    local targetHum = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    
                    if targetHumanoid and targetHum and targetHumanoid.Health > 0 then
                        -- Check for spawn protection
                        local forceField = targetPlayer.Character:FindFirstChild("ForceField")
                        
                        if forceField then
                            statusLabel.Text = "Waiting for spawn protection..."
                            forceField.Destroying:Wait()
                            wait(0.5)
                        end
                        
                        statusLabel.Text = "Flinging " .. targetPlayer.Name .. "..."
                        local success = flingTarget()
                        
                        if success then
                            flingCount = flingCount + 1
                            flingCounter.Text = "Flings: " .. flingCount
                            statusLabel.Text = "Flinged " .. targetPlayer.Name .. "!"
                        end
                        
                        wait(flingDelay)
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
            end
        end)
        
    else
        toggleButton.Text = "FLING: OFF"
        toggleButton.BackgroundColor3 = COLORS.buttonDanger
        statusLabel.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
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

print("✅ Auto Fling Loaded")
