-- Kill Aura Script (Continuous Swing Edition)
-- Sword swings non-stop, teleports separately

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local killEnabled = false
local targetPlayer = nil
local teleportDelay = 0.1
local swingDelay = 0.01
local swingsPerBurst = 3
local teleportDistance = 2

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
screenGui.Name = "KillGui"
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
hubButtonIcon.Text = "⚔️"
hubButtonIcon.Font = Enum.Font.GothamBold
hubButtonIcon.TextSize = 22
hubButtonIcon.Parent = hubButton

-- ========== MAIN FRAME ==========

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 420)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -210)
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
titleBar.Size = UDim2.new(1, 0, 0, 40)
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
titleLabel.Text = "⚔️ Kill Aura Pro"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 30, 0, 24)
collapseButton.Position = UDim2.new(1, -38, 0.5, -12)
collapseButton.BackgroundColor3 = COLORS.buttonDanger
collapseButton.TextColor3 = COLORS.textLight
collapseButton.Text = "✕"
collapseButton.Font = Enum.Font.GothamBold
collapseButton.TextSize = 12
collapseButton.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseButton

-- ========== CONTENT ==========

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -30, 1, -55)
contentFrame.Position = UDim2.new(0, 15, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 0, 45)
toggleButton.Position = UDim2.new(0, 0, 0, 0)
toggleButton.BackgroundColor3 = COLORS.buttonDanger
toggleButton.TextColor3 = COLORS.textLight
toggleButton.Text = "KILL AURA: OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.Parent = contentFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Kill Counter
local killCounter = Instance.new("TextLabel")
killCounter.Size = UDim2.new(1, 0, 0, 20)
killCounter.Position = UDim2.new(0, 0, 0, 50)
killCounter.BackgroundTransparency = 1
killCounter.TextColor3 = COLORS.buttonSuccess
killCounter.Text = "Kills: 0"
killCounter.Font = Enum.Font.GothamBold
killCounter.TextSize = 12
killCounter.Parent = contentFrame

-- Target Label
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, 0, 0, 20)
targetLabel.Position = UDim2.new(0, 0, 0, 72)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = COLORS.textDark
targetLabel.Text = "Select Target:"
targetLabel.Font = Enum.Font.GothamBold
targetLabel.TextSize = 12
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = contentFrame

-- Player List
local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1, 0, 0, 120)
playerScroll.Position = UDim2.new(0, 0, 0, 95)
playerScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerScroll.ScrollBarThickness = 4
playerScroll.Parent = contentFrame

local playerScrollCorner = Instance.new("UICorner")
playerScrollCorner.CornerRadius = UDim.new(0, 6)
playerScrollCorner.Parent = playerScroll

local playerLayout = Instance.new("UIListLayout")
playerLayout.Padding = UDim.new(0, 3)
playerLayout.Parent = playerScroll

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 24)
statusLabel.Position = UDim2.new(0, 0, 0, 220)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = COLORS.textMuted
statusLabel.Text = "No target selected"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextWrapped = true
statusLabel.Parent = contentFrame

-- Teleport Delay
local tpDelayRow = Instance.new("Frame")
tpDelayRow.Size = UDim2.new(1, 0, 0, 28)
tpDelayRow.Position = UDim2.new(0, 0, 0, 248)
tpDelayRow.BackgroundTransparency = 1
tpDelayRow.Parent = contentFrame

local tpDelayLabel = Instance.new("TextLabel")
tpDelayLabel.Size = UDim2.new(0, 100, 1, 0)
tpDelayLabel.BackgroundTransparency = 1
tpDelayLabel.TextColor3 = COLORS.textDark
tpDelayLabel.Text = "Teleport Delay:"
tpDelayLabel.Font = Enum.Font.Gotham
tpDelayLabel.TextSize = 11
tpDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
tpDelayLabel.Parent = tpDelayRow

local tpDelayInput = Instance.new("TextBox")
tpDelayInput.Size = UDim2.new(0, 60, 1, 0)
tpDelayInput.Position = UDim2.new(0, 105, 0, 0)
tpDelayInput.BackgroundColor3 = COLORS.inputBg
tpDelayInput.TextColor3 = COLORS.textDark
tpDelayInput.Text = "0.1"
tpDelayInput.Font = Enum.Font.Gotham
tpDelayInput.TextSize = 12
tpDelayInput.ClearTextOnFocus = false
tpDelayInput.Parent = tpDelayRow

local tpDelayCorner = Instance.new("UICorner")
tpDelayCorner.CornerRadius = UDim.new(0, 6)
tpDelayCorner.Parent = tpDelayInput

local tpDelayStroke = Instance.new("UIStroke")
tpDelayStroke.Color = COLORS.border
tpDelayStroke.Thickness = 1
tpDelayStroke.Parent = tpDelayInput

-- Swing Delay
local swingDelayRow = Instance.new("Frame")
swingDelayRow.Size = UDim2.new(1, 0, 0, 28)
swingDelayRow.Position = UDim2.new(0, 0, 0, 280)
swingDelayRow.BackgroundTransparency = 1
swingDelayRow.Parent = contentFrame

local swingDelayLabel = Instance.new("TextLabel")
swingDelayLabel.Size = UDim2.new(0, 100, 1, 0)
swingDelayLabel.BackgroundTransparency = 1
swingDelayLabel.TextColor3 = COLORS.textDark
swingDelayLabel.Text = "Swing Speed:"
swingDelayLabel.Font = Enum.Font.Gotham
swingDelayLabel.TextSize = 11
swingDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
swingDelayLabel.Parent = swingDelayRow

local swingDelayInput = Instance.new("TextBox")
swingDelayInput.Size = UDim2.new(0, 60, 1, 0)
swingDelayInput.Position = UDim2.new(0, 105, 0, 0)
swingDelayInput.BackgroundColor3 = COLORS.inputBg
swingDelayInput.TextColor3 = COLORS.textDark
swingDelayInput.Text = "0.01"
swingDelayInput.Font = Enum.Font.Gotham
swingDelayInput.TextSize = 12
swingDelayInput.ClearTextOnFocus = false
swingDelayInput.Parent = swingDelayRow

local swingDelayCorner = Instance.new("UICorner")
swingDelayCorner.CornerRadius = UDim.new(0, 6)
swingDelayCorner.Parent = swingDelayInput

local swingDelayStroke = Instance.new("UIStroke")
swingDelayStroke.Color = COLORS.border
swingDelayStroke.Thickness = 1
swingDelayStroke.Parent = swingDelayInput

local swingHint = Instance.new("TextLabel")
swingHint.Size = UDim2.new(0, 70, 1, 0)
swingHint.Position = UDim2.new(0, 170, 0, 0)
swingHint.BackgroundTransparency = 1
swingHint.TextColor3 = COLORS.textMuted
swingHint.Text = "(lower=faster)"
swingHint.Font = Enum.Font.Gotham
swingHint.TextSize = 10
swingHint.TextXAlignment = Enum.TextXAlignment.Left
swingHint.Parent = swingDelayRow

-- Distance Input
local distanceRow = Instance.new("Frame")
distanceRow.Size = UDim2.new(1, 0, 0, 28)
distanceRow.Position = UDim2.new(0, 0, 0, 312)
distanceRow.BackgroundTransparency = 1
distanceRow.Parent = contentFrame

local distanceLabel = Instance.new("TextLabel")
distanceLabel.Size = UDim2.new(0, 100, 1, 0)
distanceLabel.BackgroundTransparency = 1
distanceLabel.TextColor3 = COLORS.textDark
distanceLabel.Text = "Teleport Dist:"
distanceLabel.Font = Enum.Font.Gotham
distanceLabel.TextSize = 11
distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
distanceLabel.Parent = distanceRow

local distanceInput = Instance.new("TextBox")
distanceInput.Size = UDim2.new(0, 60, 1, 0)
distanceInput.Position = UDim2.new(0, 105, 0, 0)
distanceInput.BackgroundColor3 = COLORS.inputBg
distanceInput.TextColor3 = COLORS.textDark
distanceInput.Text = "2"
distanceInput.Font = Enum.Font.Gotham
distanceInput.TextSize = 12
distanceInput.ClearTextOnFocus = false
distanceInput.Parent = distanceRow

local distanceCorner = Instance.new("UICorner")
distanceCorner.CornerRadius = UDim.new(0, 6)
distanceCorner.Parent = distanceInput

local distanceStroke = Instance.new("UIStroke")
distanceStroke.Color = COLORS.border
distanceStroke.Thickness = 1
distanceStroke.Parent = distanceInput

local distanceHint = Instance.new("TextLabel")
distanceHint.Size = UDim2.new(0, 50, 1, 0)
distanceHint.Position = UDim2.new(0, 170, 0, 0)
distanceHint.BackgroundTransparency = 1
distanceHint.TextColor3 = COLORS.textMuted
distanceHint.Text = "studs"
distanceHint.Font = Enum.Font.Gotham
distanceHint.TextSize = 10
distanceHint.TextXAlignment = Enum.TextXAlignment.Left
distanceHint.Parent = distanceRow

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
local killCount = 0

local function updatePlayerList()
    for _, btn in pairs(playerButtons) do
        btn:Destroy()
    end
    playerButtons = {}
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 24)
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
    
    playerScroll.CanvasSize = UDim2.new(0, 0, 0, #playerButtons * 27)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerList()
end)

updatePlayerList()

-- ========== AUTO EQUIP SWORD ==========

local function getSword()
    local character = player.Character
    if not character then return nil end
    
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") then
            return item
        end
    end
    return nil
end

local function equipSword()
    local character = player.Character
    local backpack = player:FindFirstChild("Backpack")
    
    if not character or not backpack then return nil end
    
    local currentTool = getSword()
    if currentTool then return currentTool end
    
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            character.Humanoid:EquipTool(item)
            wait(0.1)
            return item
        end
    end
    
    return nil
end

-- ========== KILL AURA ==========

local attackAngle = 0
local lastHealth = 100

local function teleportToTarget()
    if not targetPlayer then return end
    
    local myChar = player.Character
    local myHum = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    local targetChar = targetPlayer.Character
    local targetHum = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = targetChar and targetChar:FindFirstChild("Humanoid")
    
    if not myHum or not targetHum or not targetHumanoid then return end
    if targetHumanoid.Health <= 0 then return end
    
    -- Rotate around target
    attackAngle = attackAngle + 60
    if attackAngle >= 360 then attackAngle = 0 end
    
    local angleRad = math.rad(attackAngle)
    local offsetX = math.cos(angleRad) * teleportDistance
    local offsetZ = math.sin(angleRad) * teleportDistance
    
    -- Teleport
    myHum.CFrame = targetHum.CFrame * CFrame.new(offsetX, 0, offsetZ)
    
    -- Reset velocity
    if myChar.HumanoidRootPart then
        myChar.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end
end

local function swingSword()
    local sword = getSword()
    if sword then
        sword:Activate()
    end
end

local function getTargetHealth()
    if not targetPlayer then return 0 end
    local targetChar = targetPlayer.Character
    local targetHumanoid = targetChar and targetChar:FindFirstChild("Humanoid")
    if targetHumanoid then
        return targetHumanoid.Health
    end
    return 0
end

toggleButton.MouseButton1Click:Connect(function()
    killEnabled = not killEnabled
    teleportDelay = tonumber(tpDelayInput.Text) or 0.1
    if teleportDelay < 0.01 then teleportDelay = 0.01 end
    
    swingDelay = tonumber(swingDelayInput.Text) or 0.01
    if swingDelay < 0.001 then swingDelay = 0.001 end
    
    teleportDistance = tonumber(distanceInput.Text) or 2
    if teleportDistance < 1 then teleportDistance = 1 end
    if teleportDistance > 10 then teleportDistance = 10 end
    
    if killEnabled then
        toggleButton.Text = "KILL AURA: ON"
        toggleButton.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel.Text = targetPlayer and ("Hunting: " .. targetPlayer.Name) or "No target selected"
        
        equipSword()
        
        -- Continuous swing loop (separate from teleport)
        spawn(function()
            while killEnabled do
                if targetPlayer and targetPlayer.Character then
                    local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                    if targetHumanoid and targetHumanoid.Health > 0 then
                        swingSword()
                    end
                end
                wait(swingDelay)
            end
        end)
        
        -- Teleport loop (separate from swing)
        spawn(function()
            while killEnabled do
                if targetPlayer and targetPlayer.Character then
                    local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                    if targetHumanoid then
                        if targetHumanoid.Health > 0 then
                            lastHealth = targetHumanoid.Health
                            teleportToTarget()
                            
                            -- Check for kill
                            wait(0.1)
                            if targetHumanoid.Health <= 0 and lastHealth > 0 then
                                killCount = killCount + 1
                                killCounter.Text = "Kills: " .. killCount
                                statusLabel.Text = "Killed " .. targetPlayer.Name .. "!"
                            end
                        else
                            statusLabel.Text = "Target dead! Waiting..."
                        end
                    end
                end
                wait(teleportDelay)
            end
        end)
        
        -- Re-equip loop (in case tool gets dropped)
        spawn(function()
            while killEnabled do
                local sword = getSword()
                if not sword then
                    equipSword()
                end
                wait(0.5)
            end
        end)
        
    else
        toggleButton.Text = "KILL AURA: OFF"
        toggleButton.BackgroundColor3 = COLORS.buttonDanger
        statusLabel.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
    end
end)

-- Respawn handler
player.CharacterAdded:Connect(function()
    wait(1)
    if killEnabled then
        equipSword()
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

print("✅ Kill Aura Pro Loaded (Continuous Swing)")
