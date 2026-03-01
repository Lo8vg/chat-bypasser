-- Real Physics Fling Script
-- Uses finite values + proper timing + network ownership

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local flingEnabled = false
local targetPlayer = nil
local flingLoop = nil

-- FINITE VALUES (not math.huge)
local ANGULAR_VEL = 20000  -- Spin speed
local LINEAR_VEL = 500     -- Launch force

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
mainFrame.Size = UDim2.new(0, 400, 0, 250)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
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
titleLabel.Text = "🌀 Real Physics Fling"
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
playerScroll.Size = UDim2.new(1, 0, 0, 80)
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
statusLabel.Position = UDim2.new(0, 0, 0, 160)
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

-- Angular Velocity
local angularRow = Instance.new("Frame")
angularRow.Size = UDim2.new(1, 0, 0, 22)
angularRow.Position = UDim2.new(0, 0, 0, 0)
angularRow.BackgroundTransparency = 1
angularRow.Parent = rightFrame

local angularLabel = Instance.new("TextLabel")
angularLabel.Size = UDim2.new(0, 100, 1, 0)
angularLabel.BackgroundTransparency = 1
angularLabel.TextColor3 = COLORS.textDark
angularLabel.Text = "Spin Speed:"
angularLabel.Font = Enum.Font.Gotham
angularLabel.TextSize = 10
angularLabel.TextXAlignment = Enum.TextXAlignment.Left
angularLabel.Parent = angularRow

local angularInput = Instance.new("TextBox")
angularInput.Size = UDim2.new(0, 70, 1, 0)
angularInput.Position = UDim2.new(0, 105, 0, 0)
angularInput.BackgroundColor3 = COLORS.inputBg
angularInput.TextColor3 = COLORS.textDark
angularInput.Text = "20000"
angularInput.Font = Enum.Font.Gotham
angularInput.TextSize = 10
angularInput.ClearTextOnFocus = false
angularInput.Parent = angularRow

local angularCorner = Instance.new("UICorner")
angularCorner.CornerRadius = UDim.new(0, 5)
angularCorner.Parent = angularInput

local angularStroke = Instance.new("UIStroke")
angularStroke.Color = COLORS.border
angularStroke.Thickness = 1
angularStroke.Parent = angularInput

-- Linear Velocity
local linearRow = Instance.new("Frame")
linearRow.Size = UDim2.new(1, 0, 0, 22)
linearRow.Position = UDim2.new(0, 0, 0, 26)
linearRow.BackgroundTransparency = 1
linearRow.Parent = rightFrame

local linearLabel = Instance.new("TextLabel")
linearLabel.Size = UDim2.new(0, 100, 1, 0)
linearLabel.BackgroundTransparency = 1
linearLabel.TextColor3 = COLORS.textDark
linearLabel.Text = "Launch Force:"
linearLabel.Font = Enum.Font.Gotham
linearLabel.TextSize = 10
linearLabel.TextXAlignment = Enum.TextXAlignment.Left
linearLabel.Parent = linearRow

local linearInput = Instance.new("TextBox")
linearInput.Size = UDim2.new(0, 70, 1, 0)
linearInput.Position = UDim2.new(0, 105, 0, 0)
linearInput.BackgroundColor3 = COLORS.inputBg
linearInput.TextColor3 = COLORS.textDark
linearInput.Text = "500"
linearInput.Font = Enum.Font.Gotham
linearInput.TextSize = 10
linearInput.ClearTextOnFocus = false
linearInput.Parent = linearRow

local linearCorner = Instance.new("UICorner")
linearCorner.CornerRadius = UDim.new(0, 5)
linearCorner.Parent = linearInput

local linearStroke = Instance.new("UIStroke")
linearStroke.Color = COLORS.border
linearStroke.Thickness = 1
linearStroke.Parent = linearInput

-- Info
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 70)
infoLabel.Position = UDim2.new(0, 0, 0, 55)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = COLORS.textMuted
infoLabel.Text = "Uses finite velocity values.\nTeleport delay allows physics.\nOnly root part gets velocity."
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

-- ========== FLING FUNCTION ==========

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local lastTeleport = 0
local TELEPORT_DELAY = 0.05 -- Wait between teleports to let physics resolve

local function stopFling()
    if flingLoop then
        flingLoop:Disconnect()
        flingLoop = nil
    end
    
    local myChar = player.Character
    if myChar then
        local myRoot = getRoot(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        
        if myRoot then
            myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
        
        if myHumanoid then
            myHumanoid.PlatformStand = false
        end
    end
end

local function startFling()
    if flingLoop then
        flingLoop:Disconnect()
    end
    
    -- Read values from UI
    local angularVel = tonumber(angularInput.Text) or 20000
    local linearVel = tonumber(linearInput.Text) or 500
    
    -- Clamp to reasonable values
    if angularVel > 50000 then angularVel = 50000 end
    if angularVel < 1000 then angularVel = 1000 end
    if linearVel > 2000 then linearVel = 2000 end
    if linearVel < 100 then linearVel = 100 end
    
    lastTeleport = tick()
    
    flingLoop = RunService.Heartbeat:Connect(function()
        if not flingEnabled then return end
        
        local myChar = player.Character
        if not myChar then return end
        
        local myRoot = getRoot(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        
        if not myRoot then return end
        
        if not targetPlayer or not targetPlayer.Character then
            return
        end
        
        local targetRoot = getRoot(targetPlayer.Character)
        if not targetRoot then return end
        
        -- Set network ownership (key for replication)
        pcall(function()
            myRoot:SetNetworkOwner(player)
        end)
        
        -- Teleport to target (with delay to let physics resolve)
        local now = tick()
        if now - lastTeleport >= TELEPORT_DELAY then
            myRoot.CFrame = targetRoot.CFrame
            lastTeleport = now
        end
        
        -- Apply FINITE velocity to ROOT PART ONLY
        -- This creates unbalanced rotation = impulse transfer
        myRoot.AssemblyAngularVelocity = Vector3.new(angularVel, angularVel, angularVel)
        myRoot.AssemblyLinearVelocity = Vector3.new(
            math.random(-linearVel, linearVel),
            linearVel * 2,
            math.random(-linearVel, linearVel)
        )
        
        -- DO NOT set PlatformStand - it breaks force chain
        -- DO NOT apply velocity to all parts - it balances the rig
    end)
end

-- ========== FLING TOGGLE ==========

toggleButton.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    
    if flingEnabled then
        toggleButton.Text = "FLING: ON"
        toggleButton.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel.Text = targetPlayer and ("Flinging: " .. targetPlayer.Name) or "No target selected"
        
        startFling()
        
    else
        toggleButton.Text = "FLING: OFF"
        toggleButton.BackgroundColor3 = COLORS.buttonDanger
        statusLabel.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
        
        stopFling()
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

-- Auto-restart on respawn
player.CharacterAdded:Connect(function(char)
    if flingEnabled then
        wait(0.3) -- Short wait for character load
        startFling()
        flingCount = flingCount + 1
        flingCounter.Text = "Flings: " .. flingCount
    end
end)

-- Cleanup
player.CharacterRemoving:Connect(function()
    stopFling()
end)

print("✅ Real Physics Fling Loaded")
print("   Spin: " .. ANGULAR_VEL .. " | Launch: " .. LINEAR_VEL)
