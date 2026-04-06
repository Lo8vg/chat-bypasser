-- CLONE ARMY: HOLOGRAPHIC ARMY SYSTEM (450x240)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local cloneEnabled = false
local cloneMode = "mirror"
local cloneCount = 5
local cloneTransparency = 0.3
local cloneDelay = 0.1
local swarmTarget = nil
local formationType = "circle"
local clones = {}
local cloneConnections = {}
local swarmConnection = nil

local COLORS = {
    background = Color3.fromRGB(20, 20, 25),
    header = Color3.fromRGB(30, 30, 35),
    cardBg = Color3.fromRGB(35, 35, 42),
    buttonPrimary = Color3.fromRGB(0, 140, 200),
    buttonSuccess = Color3.fromRGB(40, 180, 80),
    buttonDanger = Color3.fromRGB(200, 50, 60),
    buttonWarning = Color3.fromRGB(220, 150, 40),
    textLight = Color3.fromRGB(255, 255, 255),
    textMuted = Color3.fromRGB(150, 150, 160),
    textDark = Color3.fromRGB(200, 200, 210),
    inputBg = Color3.fromRGB(45, 45, 52),
    border = Color3.fromRGB(60, 60, 70)
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CloneArmy"
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
hubIcon.Text = "👥"
hubIcon.Font = Enum.Font.GothamBold
hubIcon.TextSize = 20
hubIcon.Parent = hubButton

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 240)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -120)
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
title.Text = "👥 CLONE ARMY"
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local cloneCountLbl = Instance.new("TextLabel")
cloneCountLbl.Size = UDim2.new(0, 60, 1, 0)
cloneCountLbl.Position = UDim2.new(1, -130, 0, 0)
cloneCountLbl.BackgroundTransparency = 1
cloneCountLbl.TextColor3 = COLORS.buttonSuccess
cloneCountLbl.Text = "Clones: 0"
cloneCountLbl.Font = Enum.Font.GothamBold
cloneCountLbl.TextSize = 10
cloneCountLbl.Parent = titleBar

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

-- Column 1: Mode Selection
local col1 = Instance.new("Frame")
col1.Size = UDim2.new(0.32, 0, 1, 0)
col1.BackgroundTransparency = 1
col1.Parent = content

local modeLbl = Instance.new("TextLabel")
modeLbl.Size = UDim2.new(1, 0, 0, 16)
modeLbl.BackgroundTransparency = 1
modeLbl.TextColor3 = COLORS.textDark
modeLbl.Text = "MODE:"
modeLbl.Font = Enum.Font.GothamBold
modeLbl.TextSize = 10
modeLbl.TextXAlignment = Enum.TextXAlignment.Left
modeLbl.Parent = col1

local mirrorBtn = Instance.new("TextButton")
mirrorBtn.Size = UDim2.new(0.5, -1, 0, 26)
mirrorBtn.BackgroundColor3 = COLORS.buttonSuccess
mirrorBtn.TextColor3 = COLORS.textLight
mirrorBtn.Text = "✓ MIRROR"
mirrorBtn.Font = Enum.Font.GothamBold
mirrorBtn.TextSize = 9
mirrorBtn.Parent = col1
local mirCorner = Instance.new("UICorner")
mirCorner.CornerRadius = UDim.new(0, 5)
mirCorner.Parent = mirrorBtn

local decoyBtn = Instance.new("TextButton")
decoyBtn.Size = UDim2.new(0.5, -1, 0, 26)
decoyBtn.Position = UDim2.new(0.5, 1, 0, 0)
decoyBtn.BackgroundColor3 = COLORS.inputBg
decoyBtn.TextColor3 = COLORS.textDark
decoyBtn.Text = "DECOY"
decoyBtn.Font = Enum.Font.Gotham
decoyBtn.TextSize = 9
decoyBtn.Parent = col1
local decCorner = Instance.new("UICorner")
decCorner.CornerRadius = UDim.new(0, 5)
decCorner.Parent = decoyBtn

local swarmBtn = Instance.new("TextButton")
swarmBtn.Size = UDim2.new(0.5, -1, 0, 26)
swarmBtn.Position = UDim2.new(0, 0, 0, 28)
swarmBtn.BackgroundColor3 = COLORS.inputBg
swarmBtn.TextColor3 = COLORS.textDark
swarmBtn.Text = "SWARM"
swarmBtn.Font = Enum.Font.Gotham
swarmBtn.TextSize = 9
swarmBtn.Parent = col1
local swCorner = Instance.new("UICorner")
swCorner.CornerRadius = UDim.new(0, 5)
swCorner.Parent = swarmBtn

local formationBtn = Instance.new("TextButton")
formationBtn.Size = UDim2.new(0.5, -1, 0, 26)
formationBtn.Position = UDim2.new(0.5, 1, 0, 28)
formationBtn.BackgroundColor3 = COLORS.inputBg
formationBtn.TextColor3 = COLORS.textDark
formationBtn.Text = "FORMATION"
formationBtn.Font = Enum.Font.Gotham
formationBtn.TextSize = 9
formationBtn.Parent = col1
local formCorner = Instance.new("UICorner")
formCorner.CornerRadius = UDim.new(0, 5)
formCorner.Parent = formationBtn

-- Formation Type (shown when formation selected)
local formationTypeLbl = Instance.new("TextLabel")
formationTypeLbl.Size = UDim2.new(1, 0, 0, 14)
formationTypeLbl.Position = UDim2.new(0, 0, 0, 58)
formationTypeLbl.BackgroundTransparency = 1
formationTypeLbl.TextColor3 = COLORS.textMuted
formationTypeLbl.Text = "Formation: Circle"
formationTypeLbl.Font = Enum.Font.Gotham
formationTypeLbl.TextSize = 8
formationTypeLbl.TextXAlignment = Enum.TextXAlignment.Left
formationTypeLbl.Parent = col1

-- Target Selection (for swarm)
local targetLbl = Instance.new("TextLabel")
targetLbl.Size = UDim2.new(1, 0, 0, 14)
targetLbl.Position = UDim2.new(0, 0, 0, 74)
targetLbl.BackgroundTransparency = 1
targetLbl.TextColor3 = COLORS.textMuted
targetLbl.Text = "Target: None"
targetLbl.Font = Enum.Font.Gotham
targetLbl.TextSize = 8
targetLbl.TextXAlignment = Enum.TextXAlignment.Left
targetLbl.Parent = col1

local targetScroll = Instance.new("ScrollingFrame")
targetScroll.Size = UDim2.new(1, 0, 0, 80)
targetScroll.Position = UDim2.new(0, 0, 0, 90)
targetScroll.BackgroundColor3 = COLORS.inputBg
targetScroll.ScrollBarThickness = 3
targetScroll.Parent = col1
local tsCorner = Instance.new("UICorner")
tsCorner.CornerRadius = UDim.new(0, 5)
tsCorner.Parent = targetScroll
local tsLayout = Instance.new("UIListLayout")
tsLayout.Padding = UDim.new(0, 1)
tsLayout.Parent = targetScroll

-- Column 2: Settings
local col2 = Instance.new("Frame")
col2.Size = UDim2.new(0.36, -8, 1, 0)
col2.Position = UDim2.new(0.32, 4, 0, 0)
col2.BackgroundTransparency = 1
col2.Parent = content

local settingsLbl = Instance.new("TextLabel")
settingsLbl.Size = UDim2.new(1, 0, 0, 16)
settingsLbl.BackgroundTransparency = 1
settingsLbl.TextColor3 = COLORS.textDark
settingsLbl.Text = "SETTINGS:"
settingsLbl.Font = Enum.Font.GothamBold
settingsLbl.TextSize = 10
settingsLbl.TextXAlignment = Enum.TextXAlignment.Left
settingsLbl.Parent = col2

-- Clone Count
local countLbl = Instance.new("TextLabel")
countLbl.Size = UDim2.new(0.5, 0, 0, 18)
countLbl.Position = UDim2.new(0, 0, 0, 20)
countLbl.BackgroundTransparency = 1
countLbl.TextColor3 = COLORS.textMuted
countLbl.Text = "Clone Count:"
countLbl.Font = Enum.Font.Gotham
countLbl.TextSize = 9
countLbl.TextXAlignment = Enum.TextXAlignment.Left
countLbl.Parent = col2

local countInput = Instance.new("TextBox")
countInput.Size = UDim2.new(0.5, -2, 0, 18)
countInput.Position = UDim2.new(0.5, 2, 0, 20)
countInput.BackgroundColor3 = COLORS.inputBg
countInput.TextColor3 = COLORS.textLight
countInput.Text = "5"
countInput.Font = Enum.Font.Gotham
countInput.TextSize = 9
countInput.Parent = col2
local ciCorner = Instance.new("UICorner")
ciCorner.CornerRadius = UDim.new(0, 4)
ciCorner.Parent = countInput

-- Transparency
local transLbl = Instance.new("TextLabel")
transLbl.Size = UDim2.new(0.5, 0, 0, 18)
transLbl.Position = UDim2.new(0, 0, 0, 42)
transLbl.BackgroundTransparency = 1
transLbl.TextColor3 = COLORS.textMuted
transLbl.Text = "Transparency:"
transLbl.Font = Enum.Font.Gotham
transLbl.TextSize = 9
transLbl.TextXAlignment = Enum.TextXAlignment.Left
transLbl.Parent = col2

local transInput = Instance.new("TextBox")
transInput.Size = UDim2.new(0.5, -2, 0, 18)
transInput.Position = UDim2.new(0.5, 2, 0, 42)
transInput.BackgroundColor3 = COLORS.inputBg
transInput.TextColor3 = COLORS.textLight
transInput.Text = "0.3"
transInput.Font = Enum.Font.Gotham
transInput.TextSize = 9
transInput.Parent = col2
local tiCorner = Instance.new("UICorner")
tiCorner.CornerRadius = UDim.new(0, 4)
tiCorner.Parent = transInput

-- Mirror Delay
local delayLbl = Instance.new("TextLabel")
delayLbl.Size = UDim2.new(0.5, 0, 0, 18)
delayLbl.Position = UDim2.new(0, 0, 0, 64)
delayLbl.BackgroundTransparency = 1
delayLbl.TextColor3 = COLORS.textMuted
delayLbl.Text = "Mirror Delay:"
delayLbl.Font = Enum.Font.Gotham
delayLbl.TextSize = 9
delayLbl.TextXAlignment = Enum.TextXAlignment.Left
delayLbl.Parent = col2

local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0.5, -2, 0, 18)
delayInput.Position = UDim2.new(0.5, 2, 0, 64)
delayInput.BackgroundColor3 = COLORS.inputBg
delayInput.TextColor3 = COLORS.textLight
delayInput.Text = "0.1"
delayInput.Font = Enum.Font.Gotham
delayInput.TextSize = 9
delayInput.Parent = col2
local diCorner = Instance.new("UICorner")
diCorner.CornerRadius = UDim.new(0, 4)
diCorner.Parent = delayInput

-- Swarm Speed
local speedLbl = Instance.new("TextLabel")
speedLbl.Size = UDim2.new(0.5, 0, 0, 18)
speedLbl.Position = UDim2.new(0, 0, 0, 86)
speedLbl.BackgroundTransparency = 1
speedLbl.TextColor3 = COLORS.textMuted
speedLbl.Text = "Swarm Speed:"
speedLbl.Font = Enum.Font.Gotham
speedLbl.TextSize = 9
speedLbl.TextXAlignment = Enum.TextXAlignment.Left
speedLbl.Parent = col2

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.5, -2, 0, 18)
speedInput.Position = UDim2.new(0.5, 2, 0, 86)
speedInput.BackgroundColor3 = COLORS.inputBg
speedInput.TextColor3 = COLORS.textLight
speedInput.Text = "50"
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 9
speedInput.Parent = col2
local siCorner = Instance.new("UICorner")
siCorner.CornerRadius = UDim.new(0, 4)
siCorner.Parent = speedInput

-- Toggles
local copyToolsLbl = Instance.new("TextLabel")
copyToolsLbl.Size = UDim2.new(1, 0, 0, 18)
copyToolsLbl.Position = UDim2.new(0, 0, 0, 110)
copyToolsLbl.BackgroundTransparency = 1
copyToolsLbl.TextColor3 = COLORS.textMuted
copyToolsLbl.Text = "OPTIONS:"
copyToolsLbl.Font = Enum.Font.GothamBold
copyToolsLbl.TextSize = 9
copyToolsLbl.TextXAlignment = Enum.TextXAlignment.Left
copyToolsLbl.Parent = col2

local copyToolsBtn = Instance.new("TextButton")
copyToolsBtn.Size = UDim2.new(0.5, -1, 0, 22)
copyToolsBtn.Position = UDim2.new(0, 0, 0, 128)
copyToolsBtn.BackgroundColor3 = COLORS.buttonSuccess
copyToolsBtn.TextColor3 = COLORS.textLight
copyToolsBtn.Text = "✓ Copy Tools"
copyToolsBtn.Font = Enum.Font.Gotham
copyToolsBtn.TextSize = 9
copyToolsBtn.Parent = col2
local ctCorner = Instance.new("UICorner")
ctCorner.CornerRadius = UDim.new(0, 4)
ctCorner.Parent = copyToolsBtn

local ghostModeBtn = Instance.new("TextButton")
ghostModeBtn.Size = UDim2.new(0.5, -1, 0, 22)
ghostModeBtn.Position = UDim2.new(0.5, 1, 0, 128)
ghostModeBtn.BackgroundColor3 = COLORS.inputBg
ghostModeBtn.TextColor3 = COLORS.textDark
ghostModeBtn.Text = "Ghost Mode"
ghostModeBtn.Font = Enum.Font.Gotham
ghostModeBtn.TextSize = 9
ghostModeBtn.Parent = col2
local gmCorner = Instance.new("UICorner")
gmCorner.CornerRadius = UDim.new(0, 4)
gmCorner.Parent = ghostModeBtn

-- Column 3: Actions
local col3 = Instance.new("Frame")
col3.Size = UDim2.new(0.32, -8, 1, 0)
col3.Position = UDim2.new(0.68, 4, 0, 0)
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

local spawnBtn = Instance.new("TextButton")
spawnBtn.Size = UDim2.new(1, 0, 0, 32)
spawnBtn.Position = UDim2.new(0, 0, 0, 18)
spawnBtn.BackgroundColor3 = COLORS.buttonPrimary
spawnBtn.TextColor3 = COLORS.textLight
spawnBtn.Text = "⚡ SPAWN CLONES"
spawnBtn.Font = Enum.Font.GothamBold
spawnBtn.TextSize = 12
spawnBtn.Parent = col3
local spCorner = Instance.new("UICorner")
spCorner.CornerRadius = UDim.new(0, 6)
spCorner.Parent = spawnBtn

local removeBtn = Instance.new("TextButton")
removeBtn.Size = UDim2.new(1, 0, 0, 28)
removeBtn.Position = UDim2.new(0, 0, 0, 54)
removeBtn.BackgroundColor3 = COLORS.buttonDanger
removeBtn.TextColor3 = COLORS.textLight
removeBtn.Text = "☠ KILL ALL CLONES"
removeBtn.Font = Enum.Font.GothamBold
removeBtn.TextSize = 10
removeBtn.Parent = col3
local rmCorner = Instance.new("UICorner")
rmCorner.CornerRadius = UDim.new(0, 5)
rmCorner.Parent = removeBtn

-- Status
local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, 0, 0, 14)
statusLbl.Position = UDim2.new(0, 0, 0, 86)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3 = COLORS.textMuted
statusLbl.Text = "Status: Ready"
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 9
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Parent = col3

-- Info
local infoLbl = Instance.new("TextLabel")
infoLbl.Size = UDim2.new(1, 0, 0, 50)
infoLbl.Position = UDim2.new(0, 0, 0, 102)
infoLbl.BackgroundTransparency = 1
infoLbl.TextColor3 = COLORS.textMuted
infoLbl.Text = "MIRROR: Clones copy you\nDECOY: Clones stand still\nSWARM: Clones attack target\nFORMATION: Clones form shapes"
infoLbl.Font = Enum.Font.Gotham
infoLbl.TextSize = 8
infoLbl.TextXAlignment = Enum.TextXAlignment.Left
infoLbl.TextWrapped = true
infoLbl.Parent = col3

-- Danger Zone
local dangerZone = Instance.new("Frame")
dangerZone.Size = UDim2.new(1, 0, 0, 50)
dangerZone.Position = UDim2.new(0, 0, 1, -54)
dangerZone.BackgroundColor3 = Color3.fromRGB(35, 25, 25)
dangerZone.Parent = col3
local dzCorner = Instance.new("UICorner")
dzCorner.CornerRadius = UDim.new(0, 6)
dzCorner.Parent = dangerZone

local dangerLbl = Instance.new("TextLabel")
dangerLbl.Size = UDim2.new(1, 0, 0, 14)
dangerLbl.Position = UDim2.new(0, 0, 0, 4)
dangerLbl.BackgroundTransparency = 1
dangerLbl.TextColor3 = COLORS.buttonDanger
dangerLbl.Text = "⚠ DANGER ZONE"
dangerLbl.Font = Enum.Font.GothamBold
dangerLbl.TextSize = 9
dangerLbl.Parent = dangerZone

local killGuiBtn = Instance.new("TextButton")
killGuiBtn.Size = UDim2.new(1, -8, 0, 24)
killGuiBtn.Position = UDim2.new(0, 4, 0, 20)
killGuiBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
killGuiBtn.TextColor3 = COLORS.textLight
killGuiBtn.Text = "☠ DELETE GUI"
killGuiBtn.Font = Enum.Font.GothamBold
killGuiBtn.TextSize = 10
killGuiBtn.Parent = dangerZone
local kgCorner = Instance.new("UICorner")
kgCorner.CornerRadius = UDim.new(0, 5)
kgCorner.Parent = killGuiBtn

-- Toggle Variables
local copyTools = true
local ghostMode = false

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

local mfDragging = false
local mfDragInput, mfDragStart, mfDragPos

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
    -- Kill all clones
    for _, clone in pairs(clones) do
        if clone and clone.Parent then
            clone:Destroy()
        end
    end
    clones = {}
    -- Disconnect all
    for _, conn in pairs(cloneConnections) do
        if conn then conn:Disconnect() end
    end
    cloneConnections = {}
    if swarmConnection then swarmConnection:Disconnect() end
    screenGui:Destroy()
end)

-- ========== MODE BUTTONS ==========
local function updateModeButtons()
    mirrorBtn.Text = cloneMode == "mirror" and "✓ MIRROR" or "MIRROR"
    mirrorBtn.BackgroundColor3 = cloneMode == "mirror" and COLORS.buttonSuccess or COLORS.inputBg
    mirrorBtn.TextColor3 = cloneMode == "mirror" and COLORS.textLight or COLORS.textDark
    
    decoyBtn.Text = cloneMode == "decoy" and "✓ DECOY" or "DECOY"
    decoyBtn.BackgroundColor3 = cloneMode == "decoy" and COLORS.buttonSuccess or COLORS.inputBg
    decoyBtn.TextColor3 = cloneMode == "decoy" and COLORS.textLight or COLORS.textDark
    
    swarmBtn.Text = cloneMode == "swarm" and "✓ SWARM" or "SWARM"
    swarmBtn.BackgroundColor3 = cloneMode == "swarm" and COLORS.buttonSuccess or COLORS.inputBg
    swarmBtn.TextColor3 = cloneMode == "swarm" and COLORS.textLight or COLORS.textDark
    
    formationBtn.Text = cloneMode == "formation" and "✓ FORMATION" or "FORMATION"
    formationBtn.BackgroundColor3 = cloneMode == "formation" and COLORS.buttonSuccess or COLORS.inputBg
    formationBtn.TextColor3 = cloneMode == "formation" and COLORS.textLight or COLORS.textDark
    
    formationTypeLbl.Visible = cloneMode == "formation"
    targetLbl.Visible = cloneMode == "swarm"
    targetScroll.Visible = cloneMode == "swarm"
end

mirrorBtn.MouseButton1Click:Connect(function()
    cloneMode = "mirror"
    updateModeButtons()
    statusLbl.Text = "Mode: Mirror"
end)

decoyBtn.MouseButton1Click:Connect(function()
    cloneMode = "decoy"
    updateModeButtons()
    statusLbl.Text = "Mode: Decoy"
end)

swarmBtn.MouseButton1Click:Connect(function()
    cloneMode = "swarm"
    updateModeButtons()
    statusLbl.Text = "Mode: Swarm"
end)

formationBtn.MouseButton1Click:Connect(function()
    cloneMode = "formation"
    updateModeButtons()
    statusLbl.Text = "Mode: Formation"
    -- Cycle formation type on click
    if formationType == "circle" then
        formationType = "line"
    elseif formationType == "line" then
        formationType = "surround"
    else
        formationType = "circle"
    end
    formationTypeLbl.Text = "Formation: " .. formationType:sub(1,1):upper() .. formationType:sub(2)
end)

-- ========== TOGGLES ==========
copyToolsBtn.MouseButton1Click:Connect(function()
    copyTools = not copyTools
    copyToolsBtn.Text = copyTools and "✓ Copy Tools" or "✗ Copy Tools"
    copyToolsBtn.BackgroundColor3 = copyTools and COLORS.buttonSuccess or COLORS.buttonDanger
end)

ghostModeBtn.MouseButton1Click:Connect(function()
    ghostMode = not ghostMode
    ghostModeBtn.Text = ghostMode and "✓ Ghost Mode" or "Ghost Mode"
    ghostModeBtn.BackgroundColor3 = ghostMode and COLORS.buttonSuccess or COLORS.inputBg
    ghostModeBtn.TextColor3 = ghostMode and COLORS.textLight or COLORS.textDark
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
            btn.Size = UDim2.new(1, 0, 0, 18)
            btn.BackgroundColor3 = swarmTarget == plr and COLORS.buttonPrimary or COLORS.inputBg
            btn.TextColor3 = swarmTarget == plr and COLORS.textLight or COLORS.textDark
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 8
            btn.Parent = targetScroll
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 3)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                swarmTarget = plr
                targetLbl.Text = "Target: " .. plr.Name
                updatePlayerList()
            end)
            
            table.insert(playerButtons, btn)
        end
    end
    
    targetScroll.CanvasSize = UDim2.new(0, 0, 0, #playerButtons * 19)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerList()
end)
updatePlayerList()

-- ========== CLONE FUNCTIONS ==========
local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function getHumanoid(char)
    return char:FindFirstChild("Humanoid")
end

local function createClone()
    local character = player.Character
    if not character then return nil end
    
    local clone = character:Clone()
    clone.Name = "Clone_" .. tostring(#clones + 1)
    
    -- Remove scripts
    for _, obj in pairs(clone:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            obj:Destroy()
        end
    end
    
    -- Remove unnecessary components
    for _, obj in pairs(clone:GetChildren()) do
        if obj:IsA("Accessory") or obj.Name == "Health" or obj.Name == "Sound" then
            obj:Destroy()
        end
    end
    
    -- Set transparency
    local trans = tonumber(transInput.Text) or 0.3
    for _, obj in pairs(clone:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Transparency = math.min(obj.Transparency + trans, 1)
            if ghostMode then
                obj.CanCollide = false
            end
        end
    end
    
    -- Handle tools
    if not copyTools then
        for _, obj in pairs(clone:GetChildren()) do
            if obj:IsA("Tool") then
                obj:Destroy()
            end
        end
    end
    
    clone.Parent = workspace
    return clone
end

local function removeClone(clone)
    if clone and clone.Parent then
        clone:Destroy()
    end
end

local function killAllClones()
    for _, clone in pairs(clones) do
        removeClone(clone)
    end
    clones = {}
    for _, conn in pairs(cloneConnections) do
        if conn then conn:Disconnect() end
    end
    cloneConnections = {}
    if swarmConnection then
        swarmConnection:Disconnect()
        swarmConnection = nil
    end
    cloneCountLbl.Text = "Clones: 0"
    statusLbl.Text = "All clones removed"
end

local function mirrorClones()
    local character = player.Character
    if not character then return end
    local myRoot = getRoot(character)
    local myHumanoid = getHumanoid(character)
    if not myRoot or not myHumanoid then return end
    
    local delay = tonumber(delayInput.Text) or 0.1
    local positions = {}
    local animations = {}
    
    -- Store position history for delay
    local conn = RunService.Heartbeat:Connect(function()
        if not character or not myRoot or not myHumanoid then return end
        
        table.insert(positions, 1, {
            cframe = myRoot.CFrame,
            position = myRoot.Position,
            walkSpeed = myHumanoid.WalkSpeed,
            jump = myHumanoid.Jump
        })
        
        -- Keep only last 100 positions
        if #positions > 100 then
            table.remove(positions, #positions)
        end
        
        -- Update clones with delay
        for i, clone in pairs(clones) do
            if clone and clone.Parent then
                local cloneRoot = getRoot(clone)
                local cloneHumanoid = getHumanoid(clone)
                if cloneRoot and cloneHumanoid then
                    local delayFrames = math.floor(delay * 60) * i
                    local posData = positions[math.min(delayFrames + 1, #positions)]
                    if posData then
                        cloneRoot.CFrame = posData.cframe
                        cloneHumanoid.WalkSpeed = posData.walkSpeed
                        cloneHumanoid.Jump = posData.jump
                    end
                end
            end
        end
    end)
    
    table.insert(cloneConnections, conn)
end

local function swarmTargetPlayer()
    if not swarmTarget or not swarmTarget.Character then return end
    
    local conn = RunService.Heartbeat:Connect(function()
        local targetRoot = getRoot(swarmTarget.Character)
        if not targetRoot then return end
        
        local speed = tonumber(speedInput.Text) or 50
        
        for i, clone in pairs(clones) do
            if clone and clone.Parent then
                local cloneRoot = getRoot(clone)
                local cloneHumanoid = getHumanoid(clone)
                if cloneRoot and cloneHumanoid then
                    local direction = (targetRoot.Position - cloneRoot.Position).Unit
                    cloneRoot.Velocity = direction * speed
                end
            end
        end
    end)
    
    swarmConnection = conn
end

local function formationClones()
    local character = player.Character
    if not character then return end
    local myRoot = getRoot(character)
    if not myRoot then return end
    
    local conn = RunService.Heartbeat:Connect(function()
        local count = #clones
        local radius = 5 + (count * 0.5)
        
        for i, clone in pairs(clones) do
            if clone and clone.Parent then
                local cloneRoot = getRoot(clone)
                local cloneHumanoid = getHumanoid(clone)
                if cloneRoot and cloneHumanoid then
                    local offset
                    if formationType == "circle" then
                        local angle = (i / count) * math.pi * 2
                        offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
                    elseif formationType == "line" then offset = Vector3.new((i - count/2) * 3, 0, 0)
                    else -- surround
                        local angle = (i / count) * math.pi * 2
                        local vertOffset = math.sin(angle) > 0 and 2 or -2
                        offset = Vector3.new(math.cos(angle) * radius, vertOffset, math.sin(angle) * radius)
                    end
                    
                    local targetPos = myRoot.Position + offset
                    cloneRoot.CFrame = CFrame.new(targetPos)
                end
            end
        end
    end)
    
    table.insert(cloneConnections, conn)
end

local function spawnClones()
    killAllClones()
    
    local count = tonumber(countInput.Text) or 5
    if count > 20 then count = 20 end
    
    statusLbl.Text = "Spawning " .. count .. " clones..."
    
    for i = 1, count do
        local clone = createClone()
        if clone then
            table.insert(clones, clone)
        end
        wait(0.05)
    end
    
    cloneCountLbl.Text = "Clones: " .. #clones
    
    -- Apply mode behavior
    if cloneMode == "mirror" then
        mirrorClones()
        statusLbl.Text = "Clones mirroring you"
    elseif cloneMode == "decoy" then
        -- Clones stay still (already positioned)
        statusLbl.Text = "Clones acting as decoys"
    elseif cloneMode == "swarm" then
        if swarmTarget then
            swarmTargetPlayer()
            statusLbl.Text = "Clones swarming: " .. swarmTarget.Name
        else
            statusLbl.Text = "Select a target first!"
        end
    elseif cloneMode == "formation" then
        formationClones()
        statusLbl.Text = "Clones in " .. formationType .. " formation"
    end
end

-- ========== BUTTON ACTIONS ==========
spawnBtn.MouseButton1Click:Connect(function()
    spawnClones()
end)

removeBtn.MouseButton1Click:Connect(function()
    killAllClones()
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

-- ========== RESPAWN HANDLER ==========
player.CharacterAdded:Connect(function()
    wait(0.5)
    if #clones > 0 then
        statusLbl.Text = "Respawned - Clones still active"
    end
end)

player.CharacterRemoving:Connect(function()
    -- Optionally kill clones on death
    -- killAllClones()
end)

updateModeButtons()
print("✅ CLONE ARMY Loaded - RightCtrl to toggle GUI")
                       
