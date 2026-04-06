-- COMBO DESTROYER: FLING + SWORD AUTO ATTACK (450x200)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local destroyEnabled = false
local targetPlayer = nil
local flingCount = 0
local velocityPower = 999999
local angularPower = 999999
local collisionMode = "devastate"
local swordSwings = 3
local swingDelay = 0.01
local swordReach = 15
local velocityEnabled = true
local angularEnabled = true
local teleportEnabled = true
local massEnabled = true
local swordEnabled = true
local flingLoop = nil
local bodyVel = nil
local bodyAngVel = nil
local angle = 0

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

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ComboDestroyer"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Hub Button
local hubButton = Instance.new("Frame")
hubButton.Size = UDim2.new(0, 40, 0, 40)
hubButton.Position = UDim2.new(0, 10, 0.5, -20)
hubButton.BackgroundColor3 = COLORS.cardBg
hubButton.BorderSizePixel = 0
hubButton.Parent = screenGui
local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 8)
hubCorner.Parent = hubButton
local hubIcon = Instance.new("TextLabel")
hubIcon.Size = UDim2.new(1, 0, 1, 0)
hubIcon.BackgroundTransparency = 1
hubIcon.TextColor3 = COLORS.textDark
hubIcon.Text = "💀"
hubIcon.Font = Enum.Font.GothamBold
hubIcon.TextSize = 18
hubIcon.Parent = hubButton

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 200)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -100)
mainFrame.BackgroundColor3 = COLORS.background
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui
local mfCorner = Instance.new("UICorner")
mfCorner.CornerRadius = UDim.new(0, 10)
mfCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 24)
titleBar.BackgroundColor3 = COLORS.header
titleBar.Parent = mainFrame
local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 10)
tbCorner.Parent = titleBar
local tbFix = Instance.new("Frame")
tbFix.Size = UDim2.new(1, 0, 0, 10)
tbFix.Position = UDim2.new(0, 0, 1, -10)
tbFix.BackgroundColor3 = COLORS.header
tbFix.BorderSizePixel = 0
tbFix.Parent = titleBar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = COLORS.textDark
title.Text = "💀 COMBO DESTROYER (Fling + Sword)"
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 18)
closeBtn.Position = UDim2.new(1, -48, 0.5, -9)
closeBtn.BackgroundColor3 = COLORS.buttonDanger
closeBtn.TextColor3 = COLORS.textLight
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 9
closeBtn.Parent = titleBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

local killBtn = Instance.new("TextButton")
killBtn.Size = UDim2.new(0, 22, 0, 18)
killBtn.Position = UDim2.new(1, -24, 0.5, -9)
killBtn.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
killBtn.TextColor3 = COLORS.textLight
killBtn.Text = "☠"
killBtn.Font = Enum.Font.GothamBold
killBtn.TextSize = 9
killBtn.Parent = titleBar
local killCorner = Instance.new("UICorner")
killCorner.CornerRadius = UDim.new(0, 4)
killCorner.Parent = killBtn

-- Content (3 columns)
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -12, 1, -28)
content.Position = UDim2.new(0, 6, 0, 26)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Column 1: Target & Toggle
local col1 = Instance.new("Frame")
col1.Size = UDim2.new(0.32, 0, 1, 0)
col1.BackgroundTransparency = 1
col1.Parent = content

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 0, 26)
toggleBtn.BackgroundColor3 = COLORS.buttonDanger
toggleBtn.TextColor3 = COLORS.textLight
toggleBtn.Text = "DESTROY: OFF"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.Parent = col1
local togCorner = Instance.new("UICorner")
togCorner.CornerRadius = UDim.new(0, 5)
togCorner.Parent = toggleBtn

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, 0, 0, 14)
statusLbl.Position = UDim2.new(0, 0, 0, 28)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3 = COLORS.textMuted
statusLbl.Text = "No target"
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 8
statusLbl.Parent = col1

local targetLbl = Instance.new("TextLabel")
targetLbl.Size = UDim2.new(1, 0, 0, 12)
targetLbl.Position = UDim2.new(0, 0, 0, 44)
targetLbl.BackgroundTransparency = 1
targetLbl.TextColor3 = COLORS.textDark
targetLbl.Text = "Target:"
targetLbl.Font = Enum.Font.GothamBold
targetLbl.TextSize = 8
targetLbl.TextXAlignment = Enum.TextXAlignment.Left
targetLbl.Parent = col1

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, 0, 0, 100)
playerList.Position = UDim2.new(0, 0, 0, 58)
playerList.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerList.ScrollBarThickness = 3
playerList.Parent = col1
local plCorner = Instance.new("UICorner")
plCorner.CornerRadius = UDim.new(0, 4)
plCorner.Parent = playerList
local plLayout = Instance.new("UIListLayout")
plLayout.Padding = UDim.new(0, 1)
plLayout.Parent = playerList

-- Column 2: Modes & Settings
local col2 = Instance.new("Frame")
col2.Size = UDim2.new(0.36, -8, 1, 0)
col2.Position = UDim2.new(0.32, 4, 0, 0)
col2.BackgroundTransparency = 1
col2.Parent = content

local modeLbl = Instance.new("TextLabel")
modeLbl.Size = UDim2.new(1, 0, 0, 12)
modeLbl.BackgroundTransparency = 1
modeLbl.TextColor3 = COLORS.textDark
modeLbl.Text = "Mode:"
modeLbl.Font = Enum.Font.GothamBold
modeLbl.TextSize = 8
modeLbl.TextXAlignment = Enum.TextXAlignment.Left
modeLbl.Parent = col2

local devBtn = Instance.new("TextButton")
devBtn.Size = UDim2.new(0.33, -1, 0, 20)
devBtn.BackgroundColor3 = COLORS.buttonSuccess
devBtn.TextColor3 = COLORS.textLight
devBtn.Text = "✓ DEV"
devBtn.Font = Enum.Font.GothamBold
devBtn.TextSize = 8
devBtn.Parent = col2
local devCorner = Instance.new("UICorner")
devCorner.CornerRadius = UDim.new(0, 3)
devCorner.Parent = devBtn

local orbBtn = Instance.new("TextButton")
orbBtn.Size = UDim2.new(0.33, -1, 0, 20)
orbBtn.Position = UDim2.new(0.33, 1, 0, 0)
orbBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
orbBtn.TextColor3 = COLORS.textDark
orbBtn.Text = "ORB"
orbBtn.Font = Enum.Font.Gotham
orbBtn.TextSize = 8
orbBtn.Parent = col2
local orbCorner = Instance.new("UICorner")
orbCorner.CornerRadius = UDim.new(0, 3)
orbCorner.Parent = orbBtn

local chaosBtn = Instance.new("TextButton")
chaosBtn.Size = UDim2.new(0.34, -1, 0, 20)
chaosBtn.Position = UDim2.new(0.66, 2, 0, 0)
chaosBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
chaosBtn.TextColor3 = COLORS.textDark
chaosBtn.Text = "CHAOS"
chaosBtn.Font = Enum.Font.Gotham
chaosBtn.TextSize = 8
chaosBtn.Parent = col2
local chaosCorner = Instance.new("UICorner")
chaosCorner.CornerRadius = UDim.new(0, 3)
chaosCorner.Parent = chaosBtn

-- Toggles row 1
local swordTog = Instance.new("TextButton")
swordTog.Size = UDim2.new(0.5, -1, 0, 18)
swordTog.Position = UDim2.new(0, 0, 0, 24)
swordTog.BackgroundColor3 = COLORS.buttonSuccess
swordTog.TextColor3 = COLORS.textLight
swordTog.Text = "✓ Sword"
swordTog.Font = Enum.Font.Gotham
swordTog.TextSize = 8
swordTog.Parent = col2
local stCorner = Instance.new("UICorner")
stCorner.CornerRadius = UDim.new(0, 3)
stCorner.Parent = swordTog

local velTog = Instance.new("TextButton")
velTog.Size = UDim2.new(0.5, -1, 0, 18)
velTog.Position = UDim2.new(0.5, 1, 0, 24)
velTog.BackgroundColor3 = COLORS.buttonSuccess
velTog.TextColor3 = COLORS.textLight
velTog.Text = "✓ Velocity"
velTog.Font = Enum.Font.Gotham
velTog.TextSize = 8
velTog.Parent = col2
local vtCorner = Instance.new("UICorner")
vtCorner.CornerRadius = UDim.new(0, 3)
vtCorner.Parent = velTog

-- Toggles row 2
local angTog = Instance.new("TextButton")
angTog.Size = UDim2.new(0.5, -1, 0, 18)
angTog.Position = UDim2.new(0, 0, 0, 44)
angTog.BackgroundColor3 = COLORS.buttonSuccess
angTog.TextColor3 = COLORS.textLight
angTog.Text = "✓ Angular"
angTog.Font = Enum.Font.Gotham
angTog.TextSize = 8
angTog.Parent = col2
local atCorner = Instance.new("UICorner")
atCorner.CornerRadius = UDim.new(0, 3)
atCorner.Parent = angTog

local tpTog = Instance.new("TextButton")
tpTog.Size = UDim2.new(0.5, -1, 0, 18)
tpTog.Position = UDim2.new(0.5, 1, 0, 44)
tpTog.BackgroundColor3 = COLORS.buttonSuccess
tpTog.TextColor3 = COLORS.textLight
tpTog.Text = "✓ Teleport"
tpTog.Font = Enum.Font.Gotham
tpTog.TextSize = 8
tpTog.Parent = col2
local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 3)
tpCorner.Parent = tpTog

-- Mass toggle
local massTog = Instance.new("TextButton")
massTog.Size = UDim2.new(1, 0, 0, 18)
massTog.Position = UDim2.new(0, 0, 0, 64)
massTog.BackgroundColor3 = COLORS.buttonSuccess
massTog.TextColor3 = COLORS.textLight
massTog.Text = "✓ Mass Boost"
massTog.Font = Enum.Font.Gotham
massTog.TextSize = 8
massTog.Parent = col2
local mtCorner = Instance.new("UICorner")
mtCorner.CornerRadius = UDim.new(0, 3)
mtCorner.Parent = massTog

-- Settings
local setLbl = Instance.new("TextLabel")
setLbl.Size = UDim2.new(1, 0, 0, 12)
setLbl.Position = UDim2.new(0, 0, 0, 86)
setLbl.BackgroundTransparency = 1
setLbl.TextColor3 = COLORS.textDark
setLbl.Text = "Power:"
setLbl.Font = Enum.Font.GothamBold
setLbl.TextSize = 8
setLbl.TextXAlignment = Enum.TextXAlignment.Left
setLbl.Parent = col2

local velInput = Instance.new("TextBox")
velInput.Size = UDim2.new(0.5, -1, 0, 18)
velInput.Position = UDim2.new(0, 0, 0, 100)
velInput.BackgroundColor3 = COLORS.inputBg
velInput.TextColor3 = COLORS.textDark
velInput.Text = "999999"
velInput.Font = Enum.Font.Gotham
velInput.TextSize = 8
velInput.PlaceholderText = "Vel"
velInput.Parent = col2
local viCorner = Instance.new("UICorner")
viCorner.CornerRadius = UDim.new(0, 3)
viCorner.Parent = velInput

local angInput = Instance.new("TextBox")
angInput.Size = UDim2.new(0.5, -1, 0, 18)
angInput.Position = UDim2.new(0.5, 1, 0, 100)
angInput.BackgroundColor3 = COLORS.inputBg
angInput.TextColor3 = COLORS.textDark
angInput.Text = "999999"
angInput.Font = Enum.Font.Gotham
angInput.TextSize = 8
angInput.PlaceholderText = "Ang"
angInput.Parent = col2
local aiCorner = Instance.new("UICorner")
aiCorner.CornerRadius = UDim.new(0, 3)
aiCorner.Parent = angInput

local swingInput = Instance.new("TextBox")
swingInput.Size = UDim2.new(0.5, -1, 0, 18)
swingInput.Position = UDim2.new(0, 0, 0, 120)
swingInput.BackgroundColor3 = COLORS.inputBg
swingInput.TextColor3 = COLORS.textDark
swingInput.Text = "3"
swingInput.Font = Enum.Font.Gotham
swingInput.TextSize = 8
swingInput.PlaceholderText = "Swings"
swingInput.Parent = col2
local siCorner = Instance.new("UICorner")
siCorner.CornerRadius = UDim.new(0, 3)
siCorner.Parent = swingInput

local reachInput = Instance.new("TextBox")
reachInput.Size = UDim2.new(0.5, -1, 0, 18)
reachInput.Position = UDim2.new(0.5, 1, 0, 120)
reachInput.BackgroundColor3 = COLORS.inputBg
reachInput.TextColor3 = COLORS.textDark
reachInput.Text = "15"
reachInput.Font = Enum.Font.Gotham
reachInput.TextSize = 8
reachInput.PlaceholderText = "Reach"
reachInput.Parent = col2
local riCorner = Instance.new("UICorner")
riCorner.CornerRadius = UDim.new(0, 3)
riCorner.Parent = reachInput

local infoLbl = Instance.new("TextLabel")
infoLbl.Size = UDim2.new(1, 0, 0, 20)
infoLbl.Position = UDim2.new(0, 0, 0, 142)
infoLbl.BackgroundTransparency = 1
infoLbl.TextColor3 = COLORS.textMuted
infoLbl.Text = "Fling + Sword combo = No escape"
infoLbl.Font = Enum.Font.Gotham
infoLbl.TextSize = 7
infoLbl.Parent = col2

-- Column 3: Extra info
local col3 = Instance.new("Frame")
col3.Size = UDim2.new(0.32, -8, 1, 0)
col3.Position = UDim2.new(0.68, 4, 0, 0)
col3.BackgroundTransparency = 1
col3.Parent = content

local howLbl = Instance.new("TextLabel")
howLbl.Size = UDim2.new(1, 0, 0, 12)
howLbl.BackgroundTransparency = 1
howLbl.TextColor3 = COLORS.textDark
howLbl.Text = "How it works:"
howLbl.Font = Enum.Font.GothamBold
howLbl.TextSize = 8
howLbl.TextXAlignment = Enum.TextXAlignment.Left
howLbl.Parent = col3

local info1 = Instance.new("TextLabel")
info1.Size = UDim2.new(1, 0, 0, 28)
info1.Position = UDim2.new(0, 0, 0, 14)
info1.BackgroundTransparency = 1
info1.TextColor3 = COLORS.textMuted
info1.Text = "1. Select target\n2. Toggle DESTROY ON\n3. Watch them suffer"
info1.Font = Enum.Font.Gotham
info1.TextSize = 7
info1.TextXAlignment = Enum.TextXAlignment.Left
info1.Parent = col3

local comboLbl = Instance.new("TextLabel")
comboLbl.Size = UDim2.new(1, 0, 0, 12)
comboLbl.Position = UDim2.new(0, 0, 0, 46)
comboLbl.BackgroundTransparency = 1
comboLbl.TextColor3 = COLORS.buttonDanger
comboLbl.Text = "COMBO ATTACK:"
comboLbl.Font = Enum.Font.GothamBold
comboLbl.TextSize = 8
comboLbl.TextXAlignment = Enum.TextXAlignment.Left
comboLbl.Parent = col3

local comboInfo = Instance.new("TextLabel")
comboInfo.Size = UDim2.new(1, 0, 0, 50)
comboInfo.Position = UDim2.new(0, 0, 0, 60)
comboInfo.BackgroundTransparency = 1
comboInfo.TextColor3 = COLORS.textMuted
comboInfo.Text = "• Fling launches you at target\n• Sword auto-swings in reach\n• Both activate together\n• Target can't escape either way"
comboInfo.Font = Enum.Font.Gotham
comboInfo.TextSize = 7
comboInfo.TextXAlignment = Enum.TextXAlignment.Left
comboInfo.TextWrapped = true
comboInfo.Parent = col3

local keyLbl = Instance.new("TextLabel")
keyLbl.Size = UDim2.new(1, 0, 0, 14)
keyLbl.Position = UDim2.new(0, 0, 0, 114)
keyLbl.BackgroundTransparency = 1
keyLbl.TextColor3 = COLORS.buttonPrimary
keyLbl.Text = "Press RightCtrl to toggle GUI"
keyLbl.Font = Enum.Font.Gotham
keyLbl.TextSize = 7
keyLbl.Parent = col3

-- Dragging
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

hubButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

killBtn.MouseButton1Click:Connect(function()
    destroyEnabled = false
    if flingLoop then
        flingLoop:Disconnect()
        flingLoop = nil
    end
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
    if bodyAngVel then bodyAngVel:Destroy() bodyAngVel = nil end
    screenGui:Destroy()
end)

-- Mode Buttons
devBtn.MouseButton1Click:Connect(function()
    collisionMode = "devastate"
    devBtn.Text = "✓ DEV"
    devBtn.BackgroundColor3 = COLORS.buttonSuccess
    devBtn.TextColor3 = COLORS.textLight
    orbBtn.Text = "ORB"
    orbBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    orbBtn.TextColor3 = COLORS.textDark
    chaosBtn.Text = "CHAOS"
    chaosBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    chaosBtn.TextColor3 = COLORS.textDark
end)

orbBtn.MouseButton1Click:Connect(function()
    collisionMode = "orbital"
    orbBtn.Text = "✓ ORB"
    orbBtn.BackgroundColor3 = COLORS.buttonSuccess
    orbBtn.TextColor3 = COLORS.textLight
    devBtn.Text = "DEV"
    devBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    devBtn.TextColor3 = COLORS.textDark
    chaosBtn.Text = "CHAOS"
    chaosBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    chaosBtn.TextColor3 = COLORS.textDark
end)

chaosBtn.MouseButton1Click:Connect(function()
    collisionMode = "chaos"
    chaosBtn.Text = "✓ CHAOS"
    chaosBtn.BackgroundColor3 = COLORS.buttonSuccess
    chaosBtn.TextColor3 = COLORS.textLight
    devBtn.Text = "DEV"
    devBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    devBtn.TextColor3 = COLORS.textDark
    orbBtn.Text = "ORB"
    orbBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    orbBtn.TextColor3 = COLORS.textDark
end)

-- Toggles
swordTog.MouseButton1Click:Connect(function()
    swordEnabled = not swordEnabled
    swordTog.Text = swordEnabled and "✓ Sword" or "✗ Sword"
    swordTog.BackgroundColor3 = swordEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

velTog.MouseButton1Click:Connect(function()
    velocityEnabled = not velocityEnabled
    velTog.Text = velocityEnabled and "✓ Velocity" or "✗ Velocity"
    velTog.BackgroundColor3 = velocityEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

angTog.MouseButton1Click:Connect(function()
    angularEnabled = not angularEnabled
    angTog.Text = angularEnabled and "✓ Angular" or "✗ Angular"
    angTog.BackgroundColor3 = angularEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

tpTog.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    tpTog.Text = teleportEnabled and "✓ Teleport" or "✗ Teleport"
    tpTog.BackgroundColor3 = teleportEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

massTog.MouseButton1Click:Connect(function()
    massEnabled = not massEnabled
    massTog.Text = massEnabled and "✓ Mass Boost" or "✗ Mass Boost"
    massTog.BackgroundColor3 = massEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

-- Player List
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
            btn.BackgroundColor3 = targetPlayer == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn.TextColor3 = targetPlayer == plr and COLORS.textLight or COLORS.textDark
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 8
            btn.Parent = playerList
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 3)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                targetPlayer = plr
                statusLbl.Text = "Target: " .. plr.Name
                updatePlayerList()
            end)
            
            table.insert(playerButtons, btn)
        end
    end
    
    playerList.CanvasSize = UDim2.new(0, 0, 0, #playerButtons * 20)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function()
    wait(0.5)
    updatePlayerList()
end)
updatePlayerList()

-- Helper Functions
local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

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
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return nil end
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            humanoid:EquipTool(item)
            wait(0.05)
            return item
        end
    end
    return nil
end

local function boostMass(char)
    if not massEnabled then return end
    local root = getRoot(char)
    if root then
        root.CustomPhysicalProperties = PhysicalProperties.new(100, 0.5, 0.5)
    end
end

local function resetMass(char)
    local root = getRoot(char)
    if root then
        root.CustomPhysicalProperties = nil
    end
end

-- Fling Functions
local function devastateFling(targetRoot, myRoot, myHumanoid)
    velocityPower = tonumber(velInput.Text) or 999999
    angularPower = tonumber(angInput.Text) or 999999
    
    if massEnabled then boostMass(player.Character) end
    if teleportEnabled then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
    end
    if velocityEnabled then
        if bodyVel then bodyVel:Destroy() end
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.Name = "CollisionBurst"
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel.Velocity = Vector3.new(math.random(-1, 1) * velocityPower, velocityPower, math.random(-1, 1) * velocityPower)
        bodyVel.P = math.huge
        bodyVel.Parent = myRoot
    end
    if angularEnabled then
        if bodyAngVel then bodyAngVel:Destroy() end
        bodyAngVel = Instance.new("BodyAngularVelocity")
        bodyAngVel.Name = "CollisionSpin"
        bodyAngVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel.AngularVelocity = Vector3.new(angularPower, angularPower, angularPower)
        bodyAngVel.P = math.huge
        bodyAngVel.Parent = myRoot
    end
    if myHumanoid then myHumanoid.PlatformStand = true end
end

local function orbitalFling(targetRoot, myRoot, myHumanoid)
    velocityPower = tonumber(velInput.Text) or 999999
    angularPower = tonumber(angInput.Text) or 999999
    
    angle = angle + (math.pi * 2 / 500)
    local offsetX = math.cos(angle) * 2
    local offsetZ = math.sin(angle) * 2
    
    if massEnabled then boostMass(player.Character) end
    if teleportEnabled then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(offsetX, 1, offsetZ)
    end
    if velocityEnabled then
        local direction = (targetRoot.Position - myRoot.Position).Unit
        if bodyVel then bodyVel:Destroy() end
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.Name = "CollisionBurst"
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel.Velocity = direction * velocityPower
        bodyVel.P = math.huge
        bodyVel.Parent = myRoot
    end
    if angularEnabled then
        if bodyAngVel then bodyAngVel:Destroy() end
        bodyAngVel = Instance.new("BodyAngularVelocity")
        bodyAngVel.Name = "CollisionSpin"
        bodyAngVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel.AngularVelocity = Vector3.new(angularPower, angularPower, angularPower)
        bodyAngVel.P = math.huge
        bodyAngVel.Parent = myRoot
    end
    if myHumanoid then myHumanoid.PlatformStand = true end
end

local function chaosFling(targetRoot, myRoot, myHumanoid)
    velocityPower = tonumber(velInput.Text) or 999999
    angularPower = tonumber(angInput.Text) or 999999
    
    if massEnabled then boostMass(player.Character) end
    if teleportEnabled then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-3, 3), math.random(-2, 2), math.random(-3, 3))
    end
    if velocityEnabled then
        if bodyVel then bodyVel:Destroy() end
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.Name = "CollisionBurst"
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel.Velocity = Vector3.new(math.random(-1, 1) * velocityPower, math.random(-1, 1) * velocityPower, math.random(-1, 1) * velocityPower)
        bodyVel.P = math.huge
        bodyVel.Parent = myRoot
    end
    if angularEnabled then
        if bodyAngVel then bodyAngVel:Destroy() end
        bodyAngVel = Instance.new("BodyAngularVelocity")
        bodyAngVel.Name = "CollisionSpin"
        bodyAngVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel.AngularVelocity = Vector3.new(math.random(-1, 1) * angularPower, math.random(-1, 1) * angularPower, math.random(-1, 1) * angularPower)
        bodyAngVel.P = math.huge
        bodyAngVel.Parent = myRoot
    end
    if myHumanoid then myHumanoid.PlatformStand = true end
end

local function swordAttack(targetRoot, myRoot)
    if not swordEnabled then return end
    swordReach = tonumber(reachInput.Text) or 15
    swordSwings = tonumber(swingInput.Text) or 3
    local sword = getSword()
    if not sword then
        sword = equipSword()
        if not sword then return end
    end
    local distance = (targetRoot.Position - myRoot.Position).Magnitude
    if distance <= swordReach then
        for i = 1, swordSwings do
            sword:Activate()
            wait(swingDelay)
        end
    end
end

local function stopAll()
    if flingLoop then
        flingLoop:Disconnect()
        flingLoop = nil
    end
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
    if bodyAngVel then bodyAngVel:Destroy() bodyAngVel = nil end
    local myChar = player.Character
    if myChar then
        local myRoot = getRoot(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        if myRoot then
            myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
        if myHumanoid then myHumanoid.PlatformStand = false end
        resetMass(myChar)
    end
end

local function startDestroy()
    if flingLoop then flingLoop:Disconnect() end
    flingLoop = RunService.Heartbeat:Connect(function()
        if not destroyEnabled then return end
        local myChar = player.Character
        if not myChar then return end
        local myRoot = getRoot(myChar)
        local myHumanoid = myChar:FindFirstChild("Humanoid")
        if not myRoot then return end
        if not targetPlayer or not targetPlayer.Character then return end
        local targetRoot = getRoot(targetPlayer.Character)
        if not targetRoot then return end
        
        if collisionMode == "devastate" then
            devastateFling(targetRoot, myRoot, myHumanoid)
        elseif collisionMode == "orbital" then
            orbitalFling(targetRoot, myRoot, myHumanoid)
        else
            chaosFling(targetRoot, myRoot, myHumanoid)
        end
        swordAttack(targetRoot, myRoot)
    end)
end

-- Main Toggle
toggleBtn.MouseButton1Click:Connect(function()
    destroyEnabled = not destroyEnabled
    if destroyEnabled then
        if not targetPlayer then
            statusLbl.Text = "Select target!"
            destroyEnabled = false
            return
        end
        toggleBtn.Text = "DESTROY: ON"
        toggleBtn.BackgroundColor3 = COLORS.buttonSuccess
        statusLbl.Text = "Destroying: " .. targetPlayer.Name
        equipSword()
        startDestroy()
    else
        toggleBtn.Text = "DESTROY: OFF"
        toggleBtn.BackgroundColor3 = COLORS.buttonDanger
        statusLbl.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target"
        stopAll()
    end
end)

-- Keybind
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

-- Respawn Handler
player.CharacterAdded:Connect(function(char)
    wait(0.3)
    if destroyEnabled then
        flingCount = flingCount + 1
        equipSword()
        startDestroy()
    end
end)

player.CharacterRemoving:Connect(function()
    stopAll()
end)

print("✅ COMBO DESTROYER Loaded (450x200)")
