-- PLAYER DRAG & VOID: TELEPORT TARGETS OUTSIDE MAP (420x220)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local targetPlayer = nil
local dragMode = "void"
local dragEnabled = false
local dragConnection = nil
local teleportDistance = 500
local dragSpeed = 100

local COLORS = {
    background = Color3.fromRGB(25, 25, 30),
    header = Color3.fromRGB(35, 35, 42),
    cardBg = Color3.fromRGB(40, 40, 48),
    buttonPrimary = Color3.fromRGB(0, 140, 200),
    buttonSuccess = Color3.fromRGB(50, 180, 80),
    buttonDanger = Color3.fromRGB(200, 50, 60),
    buttonWarning = Color3.fromRGB(220, 150, 40),
    textLight = Color3.fromRGB(255, 255, 255),
    textMuted = Color3.fromRGB(150, 150, 160),
    textDark = Color3.fromRGB(200, 200, 210),
    inputBg = Color3.fromRGB(50, 50, 58),
    border = Color3.fromRGB(60, 60, 70)
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DragVoid"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Hub Button
local hubButton = Instance.new("Frame")
hubButton.Size = UDim2.new(0, 45, 0, 45)
hubButton.Position = UDim2.new(0, 15, 0.5, -22)
hubButton.BackgroundColor3 = COLORS.cardBg
hubButton.BorderSizePixel = 0
hubButton.Parent = screenGui
local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 10)
hubCorner.Parent = hubButton
local hubIcon = Instance.new("TextLabel")
hubIcon.Size = UDim2.new(1, 0, 1, 0)
hubIcon.BackgroundTransparency = 1
hubIcon.TextColor3 = COLORS.textLight
hubIcon.Text = "🎯"
hubIcon.Font = Enum.Font.GothamBold
hubIcon.TextSize = 20
hubIcon.Parent = hubButton

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 220)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -110)
mainFrame.BackgroundColor3 = COLORS.background
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui
local mfCorner = Instance.new("UICorner")
mfCorner.CornerRadius = UDim.new(0, 10)
mfCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = COLORS.header
titleBar.Parent = mainFrame
local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 10)
tbCorner.Parent = titleBar
local tbFix = Instance.new("Frame")
tbFix.Size = UDim2.new(1, 0, 0, 14)
tbFix.Position = UDim2.new(0, 0, 1, -14)
tbFix.BackgroundColor3 = COLORS.header
tbFix.BorderSizePixel = 0
tbFix.Parent = titleBar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = COLORS.textLight
title.Text = "🎯 PLAYER DRAG & VOID"
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(0, 80, 1, 0)
statusLbl.Position = UDim2.new(1, -150, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3 = COLORS.buttonSuccess
statusLbl.Text = "Ready"
statusLbl.Font = Enum.Font.GothamBold
statusLbl.TextSize = 10
statusLbl.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 20)
closeBtn.Position = UDim2.new(1, -28, 0.5, -10)
closeBtn.BackgroundColor3 = COLORS.buttonDanger
closeBtn.TextColor3 = COLORS.textLight
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 10
closeBtn.Parent = titleBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -12, 1, -32)
content.Position = UDim2.new(0, 6, 0, 30)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Column 1: Target Selection
local col1 = Instance.new("Frame")
col1.Size = UDim2.new(0.35, 0, 1, 0)
col1.BackgroundTransparency = 1
col1.Parent = content

local targetLbl = Instance.new("TextLabel")
targetLbl.Size = UDim2.new(1, 0, 0, 16)
targetLbl.BackgroundTransparency = 1
targetLbl.TextColor3 = COLORS.textDark
targetLbl.Text = "SELECT TARGET:"
targetLbl.Font = Enum.Font.GothamBold
targetLbl.TextSize = 10
targetLbl.TextXAlignment = Enum.TextXAlignment.Left
targetLbl.Parent = col1

local targetScroll = Instance.new("ScrollingFrame")
targetScroll.Size = UDim2.new(1, 0, 1, -20)
targetScroll.Position = UDim2.new(0, 0, 0, 18)
targetScroll.BackgroundColor3 = COLORS.inputBg
targetScroll.ScrollBarThickness = 3
targetScroll.Parent = col1
local tsCorner = Instance.new("UICorner")
tsCorner.CornerRadius = UDim.new(0, 5)
tsCorner.Parent = targetScroll
local tsLayout = Instance.new("UIListLayout")
tsLayout.Padding = UDim.new(0, 2)
tsLayout.Parent = targetScroll

-- Column 2: Mode & Settings
local col2 = Instance.new("Frame")
col2.Size = UDim2.new(0.35, -4, 1, 0)
col2.Position = UDim2.new(0.35, 2, 0, 0)
col2.BackgroundTransparency = 1
col2.Parent = content

local modeLbl = Instance.new("TextLabel")
modeLbl.Size = UDim2.new(1, 0, 0, 16)
modeLbl.BackgroundTransparency = 1
modeLbl.TextColor3 = COLORS.textDark
modeLbl.Text = "MODE:"
modeLbl.Font = Enum.Font.GothamBold
modeLbl.TextSize = 10
modeLbl.TextXAlignment = Enum.TextXAlignment.Left
modeLbl.Parent = col2

-- Mode Buttons
local voidBtn = Instance.new("TextButton")
voidBtn.Size = UDim2.new(1, 0, 0, 24)
voidBtn.Position = UDim2.new(0, 0, 0, 18)
voidBtn.BackgroundColor3 = COLORS.buttonSuccess
voidBtn.TextColor3 = COLORS.textLight
voidBtn.Text = "✓ VOID"
voidBtn.Font = Enum.Font.GothamBold
voidBtn.TextSize = 10
voidBtn.Parent = col2
local voidCorner = Instance.new("UICorner")
voidCorner.CornerRadius = UDim.new(0, 5)
voidCorner.Parent = voidBtn

local dragBtn = Instance.new("TextButton")
dragBtn.Size = UDim2.new(1, 0, 0, 24)
dragBtn.Position = UDim2.new(0, 0, 0, 44)
dragBtn.BackgroundColor3 = COLORS.inputBg
dragBtn.TextColor3 = COLORS.textDark
dragBtn.Text = "DRAG"
dragBtn.Font = Enum.Font.Gotham
dragBtn.TextSize = 10
dragBtn.Parent = col2
local dragCorner = Instance.new("UICorner")
dragCorner.CornerRadius = UDim.new(0, 5)
dragCorner.Parent = dragBtn

local orbitBtn = Instance.new("TextButton")
orbitBtn.Size = UDim2.new(1, 0, 0, 24)
orbitBtn.Position = UDim2.new(0, 0, 0, 70)
orbitBtn.BackgroundColor3 = COLORS.inputBg
orbitBtn.TextColor3 = COLORS.textDark
orbitBtn.Text = "ORBIT"
orbitBtn.Font = Enum.Font.Gotham
orbitBtn.TextSize = 10
orbitBtn.Parent = col2
local orbitCorner = Instance.new("UICorner")
orbitCorner.CornerRadius = UDim.new(0, 5)
orbitCorner.Parent = orbitBtn

-- Settings
local settingsLbl = Instance.new("TextLabel")
settingsLbl.Size = UDim2.new(1, 0, 0, 14)
settingsLbl.Position = UDim2.new(0, 0, 0, 98)
settingsLbl.BackgroundTransparency = 1
settingsLbl.TextColor3 = COLORS.textDark
settingsLbl.Text = "SETTINGS:"
settingsLbl.Font = Enum.Font.GothamBold
settingsLbl.TextSize = 9
settingsLbl.TextXAlignment = Enum.TextXAlignment.Left
settingsLbl.Parent = col2

local distLbl = Instance.new("TextLabel")
distLbl.Size = UDim2.new(0.4, 0, 0, 18)
distLbl.Position = UDim2.new(0, 0, 0, 114)
distLbl.BackgroundTransparency = 1
distLbl.TextColor3 = COLORS.textMuted
distLbl.Text = "Distance:"
distLbl.Font = Enum.Font.Gotham
distLbl.TextSize = 9
distLbl.TextXAlignment = Enum.TextXAlignment.Left
distLbl.Parent = col2

local distInput = Instance.new("TextBox")
distInput.Size = UDim2.new(0.6, -2, 0, 18)
distInput.Position = UDim2.new(0.4, 2, 0, 114)
distInput.BackgroundColor3 = COLORS.inputBg
distInput.TextColor3 = COLORS.textLight
distInput.Text = "500"
distInput.Font = Enum.Font.Gotham
distInput.TextSize = 9
distInput.Parent = col2
local diCorner = Instance.new("UICorner")
diCorner.CornerRadius = UDim.new(0, 4)
diCorner.Parent = distInput

local speedLbl = Instance.new("TextLabel")
speedLbl.Size = UDim2.new(0.4, 0, 0, 18)
speedLbl.Position = UDim2.new(0, 0, 0, 134)
speedLbl.BackgroundTransparency = 1
speedLbl.TextColor3 = COLORS.textMuted
speedLbl.Text = "Speed:"
speedLbl.Font = Enum.Font.Gotham
speedLbl.TextSize = 9
speedLbl.TextXAlignment = Enum.TextXAlignment.Left
speedLbl.Parent = col2

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.6, -2, 0, 18)
speedInput.Position = UDim2.new(0.4, 2, 0, 134)
speedInput.BackgroundColor3 = COLORS.inputBg
speedInput.TextColor3 = COLORS.textLight
speedInput.Text = "100"
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 9
speedInput.Parent = col2
local siCorner = Instance.new("UICorner")
siCorner.CornerRadius = UDim.new(0, 4)
siCorner.Parent = speedInput

-- Column 3: Actions
local col3 = Instance.new("Frame")
col3.Size = UDim2.new(0.30, -6, 1, 0)
col3.Position = UDim2.new(0.70, 2, 0, 0)
col3.BackgroundTransparency = 1
col3.Parent = content

local actionLbl = Instance.new("TextLabel")
actionLbl.Size = UDim2.new(1, 0, 0, 16)
actionLbl.BackgroundTransparency = 1
actionLbl.TextColor3 = COLORS.textDark
actionLbl.Text = "ACTIONS:"
actionLbl.Font = Enum.Font.GothamBold
actionLbl.TextSize = 10
actionLbl.TextXAlignment = Enum.TextXAlignment.Left
actionLbl.Parent = col3

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(1, 0, 0, 36)
startBtn.Position = UDim2.new(0, 0, 0, 18)
startBtn.BackgroundColor3 = COLORS.buttonPrimary
startBtn.TextColor3 = COLORS.textLight
startBtn.Text = "⚡ START DRAG"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 12
startBtn.Parent = col3
local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 6)
startCorner.Parent = startBtn

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(1, 0, 0, 28)
stopBtn.Position = UDim2.new(0, 0, 0, 56)
stopBtn.BackgroundColor3 = COLORS.buttonDanger
stopBtn.TextColor3 = COLORS.textLight
stopBtn.Text = "☠ STOP"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 10
stopBtn.Parent = col3
local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 5)
stopCorner.Parent = stopBtn

local flingBtn = Instance.new("TextButton")
flingBtn.Size = UDim2.new(1, 0, 0, 28)
flingBtn.Position = UDim2.new(0, 0, 0, 86)
flingBtn.BackgroundColor3 = COLORS.buttonWarning
flingBtn.TextColor3 = COLORS.textLight
flingBtn.Text = "💨 FLING OFF"
flingBtn.Font = Enum.Font.GothamBold
flingBtn.TextSize = 10
flingBtn.Parent = col3
local flingCorner = Instance.new("UICorner")
flingCorner.CornerRadius = UDim.new(0, 5)
flingCorner.Parent = flingBtn

-- Info
local infoLbl = Instance.new("TextLabel")
infoLbl.Size = UDim2.new(1, 0, 0, 50)
infoLbl.Position = UDim2.new(0, 0, 0, 118)
infoLbl.BackgroundTransparency = 1
infoLbl.TextColor3 = COLORS.textMuted
infoLbl.Text = "VOID: TP target to void\nDRAG: Attach & carry\nORBIT: Spin around target\nFLING: Launch them far"
infoLbl.Font = Enum.Font.Gotham
infoLbl.TextSize = 8
infoLbl.TextXAlignment = Enum.TextXAlignment.Left
infoLbl.TextWrapped = true
infoLbl.Parent = col3

-- Danger Zone
local dangerZone = Instance.new("Frame")
dangerZone.Size = UDim2.new(1, 0, 0, 30)
dangerZone.Position = UDim2.new(0, 0, 1, -32)
dangerZone.BackgroundColor3 = Color3.fromRGB(35, 25, 25)
dangerZone.Parent = col3
local dzCorner = Instance.new("UICorner")
dzCorner.CornerRadius = UDim.new(0, 5)
dzCorner.Parent = dangerZone

local killGuiBtn = Instance.new("TextButton")
killGuiBtn.Size = UDim2.new(1, -8, 0, 22)
killGuiBtn.Position = UDim2.new(0, 4, 0, 4)
killGuiBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
killGuiBtn.TextColor3 = COLORS.textLight
killGuiBtn.Text = "☠ KILL GUI"
killGuiBtn.Font = Enum.Font.GothamBold
killGuiBtn.TextSize = 9
killGuiBtn.Parent = dangerZone
local kgCorner = Instance.new("UICorner")
kgCorner.CornerRadius = UDim.new(0, 4)
kgCorner.Parent = killGuiBtn

-- ========== DRAGGING ==========
local dragging = false
local dragStart, startPos, dragInput

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

local mfDragging = false
local mfDragStart, mfDragPos, mfDragInput

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mfDragging = true
        mfDragStart = input.Position
        mfDragPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                mfDragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        mfDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == mfDragInput and mfDragging then
        local delta = input.Position - mfDragStart
        mainFrame.Position = UDim2.new(mfDragPos.X.Scale, mfDragPos.X.Offset + delta.X, mfDragPos.Y.Scale, mfDragPos.Y.Offset + delta.Y)
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

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

killGuiBtn.MouseButton1Click:Connect(function()
    stopDragging()
    screenGui:Destroy()
end)

-- ========== PLAYER LIST ==========
local playerButtons = {}

local function updatePlayerList()
    for _, btn in pairs(playerButtons) do
        btn:Destroy()
    end
    playerButtons = {}
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 20)
            btn.BackgroundColor3 = targetPlayer == plr and COLORS.buttonPrimary or COLORS.inputBg
            btn.TextColor3 = targetPlayer == plr and COLORS.textLight or COLORS.textDark
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 9
            btn.Parent = targetScroll
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                targetPlayer = plr
                statusLbl.Text = "Target: " .. plr.Name
                updatePlayerList()
            end)
            
            table.insert(playerButtons, btn)
        end
    end
    
    targetScroll.CanvasSize = UDim2.new(0, 0, 0, #playerButtons * 22)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerList()
end)
updatePlayerList()

-- ========== MODE BUTTONS ==========
local function updateModeButtons()
    voidBtn.Text = dragMode == "void" and "✓ VOID" or "VOID"
    voidBtn.BackgroundColor3 = dragMode == "void" and COLORS.buttonSuccess or COLORS.inputBg
    voidBtn.TextColor3 = dragMode == "void" and COLORS.textLight or COLORS.textDark
    
    dragBtn.Text = dragMode == "drag" and "✓ DRAG" or "DRAG"
    dragBtn.BackgroundColor3 = dragMode == "drag" and COLORS.buttonSuccess or COLORS.inputBg
    dragBtn.TextColor3 = dragMode == "drag" and COLORS.textLight or COLORS.textDark
    
    orbitBtn.Text = dragMode == "orbit" and "✓ ORBIT" or "ORBIT"
    orbitBtn.BackgroundColor3 = dragMode == "orbit" and COLORS.buttonSuccess or COLORS.inputBg
    orbitBtn.TextColor3 = dragMode == "orbit" and COLORS.textLight or COLORS.textDark
end

voidBtn.MouseButton1Click:Connect(function()
    dragMode = "void"
    updateModeButtons()
end)

dragBtn.MouseButton1Click:Connect(function()
    dragMode = "drag"
    updateModeButtons()
end)

orbitBtn.MouseButton1Click:Connect(function()
    dragMode = "orbit"
    updateModeButtons()
end)

-- ========== HELPER FUNCTIONS ==========
local function getRoot(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
end

local function getHumanoid(char)
    return char and char:FindFirstChild("Humanoid")
end

-- ========== DRAG FUNCTIONS ==========
local orbitAngle = 0

local function stopDragging()
    dragEnabled = false
    if dragConnection then
        dragConnection:Disconnect()
        dragConnection = nil
    end
    
    -- Reset our character
    local myChar = player.Character
    local myHumanoid = getHumanoid(myChar)
    local myRoot = getRoot(myChar)
    if myHumanoid then
        myHumanoid.PlatformStand = false
    end
    if myRoot then
        myRoot.Velocity = Vector3.new(0, 0, 0)
        myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
    
    startBtn.Text = "⚡ START DRAG"
    startBtn.BackgroundColor3 = COLORS.buttonPrimary
    statusLbl.Text = "Stopped"
end

local function startDragging()
    if not targetPlayer then
        statusLbl.Text = "Select target!"
        return
    end
    
    if not targetPlayer.Character or not getRoot(targetPlayer.Character) then
        statusLbl.Text = "Target not alive"
        return
    end
    
    dragEnabled = true
    startBtn.Text = "⚡ DRAGGING..."
    startBtn.BackgroundColor3 = COLORS.buttonSuccess
    statusLbl.Text = "Dragging: " .. targetPlayer.Name
    
    local distance = tonumber(distInput.Text) or 500
    local speed = tonumber(speedInput.Text) or 100
    local myChar = player.Character
    local myRoot = getRoot(myChar)
    local myHumanoid = getHumanoid(myChar)
    
    if dragMode == "void" then
        -- VOID MODE: Teleport to them, grab, TP to void
        dragConnection = RunService.Heartbeat:Connect(function()
            if not dragEnabled then return end
            
            local targetChar = targetPlayer.Character
            local targetRoot = getRoot(targetChar)
            
            if not targetRoot then
                stopDragging()
                return
            end
            
            -- Teleport to target
            myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
            
            -- Calculate void position (far below map)
            local voidPos = Vector3.new(0, -distance, 0)
            
            -- Drag them with us using velocity
            local direction = (voidPos - myRoot.Position).Unit
            targetRoot.Velocity = direction * speed
            myRoot.Velocity = direction * speed
            
            -- If we're far enough down, stop
            if myRoot.Position.Y < -distance + 100 then
                stopDragging()
            end
        end)
        
    elseif dragMode == "drag" then
        -- DRAG MODE: Attach to them and carry
        if myHumanoid then myHumanoid.PlatformStand = true end
        
        dragConnection = RunService.Heartbeat:Connect(function()
            if not dragEnabled then return end
            
            local targetChar = targetPlayer.Character
            local targetRoot = getRoot(targetChar)
            
            if not targetRoot then
                stopDragging()
                return
            end
            
            -- Get camera direction for movement
            local camera = workspace.CurrentCamera
            local lookVector = camera.CFrame.LookVector
            local moveDir = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
            
            -- Move both of us
            local moveCFrame = CFrame.new(myRoot.Position + moveDir * 2)
            myRoot.CFrame = myRoot.CFrame:Lerp(moveCFrame, 0.3)
            
            -- Drag target with us
            targetRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -3)
            targetRoot.Velocity = moveDir * speed
        end)
        
    elseif dragMode == "orbit" then
        -- ORBIT MODE: Spin around them
        dragConnection = RunService.Heartbeat:Connect(function()
            if not dragEnabled then return end
            
            local targetChar = targetPlayer.Character
            local targetRoot = getRoot(targetChar)
            
            if not targetRoot then
                stopDragging()
                return
            end
            
            orbitAngle = orbitAngle + 0.1
            
            local radius = 3
            local offsetX = math.cos(orbitAngle) * radius
            local offsetZ = math.sin(orbitAngle) * radius
            
            -- Orbit around target
            myRoot.CFrame = targetRoot.CFrame * CFrame.new(offsetX, 0, offsetZ)
            
            -- Push them outward
            local pushDir = (targetRoot.Position - myRoot.Position).Unit
            targetRoot.Velocity = pushDir * (speed / 2)
        end)
    end
end

local function flingTarget()
    if not targetPlayer or not targetPlayer.Character then
        statusLbl.Text = "Select target!"
        return
    end
    
    local targetRoot = getRoot(targetPlayer.Character)
    local myRoot = getRoot(player.Character)
    
    if not targetRoot or not myRoot then return end
    
    -- Boost our mass
    local oldMass = myRoot.CustomPhysicalProperties
    myRoot.CustomPhysicalProperties = PhysicalProperties.new(100, 0.5, 0.5)
    
    -- Teleport to them
    myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 1)
    
    -- Fling velocity
    local flingVel = Instance.new("BodyVelocity")
    flingVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flingVel.Velocity = Vector3.new(
        math.random(-1, 1) * 999999,
        999999,
        math.random(-1, 1) * 999999
    )
    flingVel.P = math.huge
    flingVel.Parent = myRoot
    
    local flingAng = Instance.new("BodyAngularVelocity")
    flingAng.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flingAng.AngularVelocity = Vector3.new(999999, 999999, 999999)
    flingAng.P = math.huge
    flingAng.Parent = myRoot
    
    local myHumanoid = getHumanoid(player.Character)
    if myHumanoid then myHumanoid.PlatformStand = true end
    
    -- Remove after short time
    wait(0.3)
    flingVel:Destroy()
    flingAng:Destroy()
    if myHumanoid then myHumanoid.PlatformStand = false end
    myRoot.CustomPhysicalProperties = oldMass
    statusLbl.Text = "Flinged: " .. targetPlayer.Name
end

-- ========== BUTTONS ==========
startBtn.MouseButton1Click:Connect(function()
    if dragEnabled then
        stopDragging()
    else
        startDragging()
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    stopDragging()
end)

flingBtn.MouseButton1Click:Connect(function()
    flingTarget()
end)

-- ========== KEYBIND ==========
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

print("✅ PLAYER DRAG & VOID Loaded - RightCtrl to toggle")
