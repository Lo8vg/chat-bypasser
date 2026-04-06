-- COMBO DESTROYER: FLING + SWORD AUTO ATTACK (300x350)

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
hubButton.Size = UDim2.new(0, 45, 0, 45)
hubButton.Position = UDim2.new(0, 10, 0.5, -22)
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
hubIcon.TextSize = 20
hubIcon.Parent = hubButton

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
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
tbFix.Size = UDim2.new(1, 0, 0, 12)
tbFix.Position = UDim2.new(0, 0, 1, -12)
tbFix.BackgroundColor3 = COLORS.header
tbFix.BorderSizePixel = 0
tbFix.Parent = titleBar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = COLORS.textDark
title.Text = "💀 COMBO DESTROYER"
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 20)
closeBtn.Position = UDim2.new(1, -52, 0.5, -10)
closeBtn.BackgroundColor3 = COLORS.buttonDanger
closeBtn.TextColor3 = COLORS.textLight
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 10
closeBtn.Parent = titleBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn

local killBtn = Instance.new("TextButton")
killBtn.Size = UDim2.new(0, 24, 0, 20)
killBtn.Position = UDim2.new(1, -26, 0.5, -10)
killBtn.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
killBtn.TextColor3 = COLORS.textLight
killBtn.Text = "☠"
killBtn.Font = Enum.Font.GothamBold
killBtn.TextSize = 10
killBtn.Parent = titleBar
local killCorner = Instance.new("UICorner")
killCorner.CornerRadius = UDim.new(0, 5)
killCorner.Parent = killBtn

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -12, 1, -32)
content.Position = UDim2.new(0, 6, 0, 30)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 0, 32)
toggleBtn.BackgroundColor3 = COLORS.buttonDanger
toggleBtn.TextColor3 = COLORS.textLight
toggleBtn.Text = "DESTROY: OFF"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.Parent = content
local togCorner = Instance.new("UICorner")
togCorner.CornerRadius = UDim.new(0, 6)
togCorner.Parent = toggleBtn

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, 0, 0, 16)
statusLbl.Position = UDim2.new(0, 0, 0, 35)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3 = COLORS.textMuted
statusLbl.Text = "No target selected"
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 9
statusLbl.Parent = content

-- Target Section
local targetLbl = Instance.new("TextLabel")
targetLbl.Size = UDim2.new(1, 0, 0, 14)
targetLbl.Position = UDim2.new(0, 0, 0, 55)
targetLbl.BackgroundTransparency = 1
targetLbl.TextColor3 = COLORS.textDark
targetLbl.Text = "Select Target:"
targetLbl.Font = Enum.Font.GothamBold
targetLbl.TextSize = 9
targetLbl.TextXAlignment = Enum.TextXAlignment.Left
targetLbl.Parent = content

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, 0, 0, 80)
playerList.Position = UDim2.new(0, 0, 0, 72)
playerList.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
playerList.ScrollBarThickness = 3
playerList.Parent = content
local plCorner = Instance.new("UICorner")
plCorner.CornerRadius = UDim.new(0, 5)
plCorner.Parent = playerList
local plLayout = Instance.new("UIListLayout")
plLayout.Padding = UDim.new(0, 2)
plLayout.Parent = playerList

-- Mode Section
local modeLbl = Instance.new("TextLabel")
modeLbl.Size = UDim2.new(1, 0, 0, 14)
modeLbl.Position = UDim2.new(0, 0, 0, 158)
modeLbl.BackgroundTransparency = 1
modeLbl.TextColor3 = COLORS.textDark
modeLbl.Text = "Fling Mode:"
modeLbl.Font = Enum.Font.GothamBold
modeLbl.TextSize = 9
modeLbl.TextXAlignment = Enum.TextXAlignment.Left
modeLbl.Parent = content

local devBtn = Instance.new("TextButton")
devBtn.Size = UDim2.new(0.33, -2, 0, 22)
devBtn.Position = UDim2.new(0, 0, 0, 174)
devBtn.BackgroundColor3 = COLORS.buttonSuccess
devBtn.TextColor3 = COLORS.textLight
devBtn.Text = "✓ DEVASTATE"
devBtn.Font = Enum.Font.GothamBold
devBtn.TextSize = 8
devBtn.Parent = content
local devCorner = Instance.new("UICorner")
devCorner.CornerRadius = UDim.new(0, 4)
devCorner.Parent = devBtn

local orbBtn = Instance.new("TextButton")
orbBtn.Size = UDim2.new(0.33, -2, 0, 22)
orbBtn.Position = UDim2.new(0.33, 2, 0, 174)
orbBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
orbBtn.TextColor3 = COLORS.textDark
orbBtn.Text = "ORBITAL"
orbBtn.Font = Enum.Font.Gotham
orbBtn.TextSize = 8
orbBtn.Parent = content
local orbCorner = Instance.new("UICorner")
orbCorner.CornerRadius = UDim.new(0, 4)
orbCorner.Parent = orbBtn

local chaosBtn = Instance.new("TextButton")
chaosBtn.Size = UDim2.new(0.34, -2, 0, 22)
chaosBtn.Position = UDim2.new(0.66, 4, 0, 174)
chaosBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
chaosBtn.TextColor3 = COLORS.textDark
chaosBtn.Text = "CHAOS"
chaosBtn.Font = Enum.Font.Gotham
chaosBtn.TextSize = 8
chaosBtn.Parent = content
local chaosCorner = Instance.new("UICorner")
chaosCorner.CornerRadius = UDim.new(0, 4)
chaosCorner.Parent = chaosBtn

-- Toggles Section
local toggleLbl = Instance.new("TextLabel")
toggleLbl.Size = UDim2.new(1, 0, 0, 14)
toggleLbl.Position = UDim2.new(0, 0, 0, 202)
toggleLbl.BackgroundTransparency = 1
toggleLbl.TextColor3 = COLORS.textDark
toggleLbl.Text = "Options:"
toggleLbl.Font = Enum.Font.GothamBold
toggleLbl.TextSize = 9
toggleLbl.TextXAlignment = Enum.TextXAlignment.Left
toggleLbl.Parent = content

local swordTog = Instance.new("TextButton")
swordTog.Size = UDim2.new(0.5, -2, 0, 20)
swordTog.Position = UDim2.new(0, 0, 0, 218)
swordTog.BackgroundColor3 = COLORS.buttonSuccess
swordTog.TextColor3 = COLORS.textLight
swordTog.Text = "✓ Sword"
swordTog.Font = Enum.Font.Gotham
swordTog.TextSize = 8
swordTog.Parent = content
local stCorner = Instance.new("UICorner")
stCorner.CornerRadius = UDim.new(0, 4)
stCorner.Parent = swordTog

local velTog = Instance.new("TextButton")
velTog.Size = UDim2.new(0.5, -2, 0, 20)
velTog.Position = UDim2.new(0.5, 2, 0, 218)
velTog.BackgroundColor3 = COLORS.buttonSuccess
velTog.TextColor3 = COLORS.textLight
velTog.Text = "✓ Velocity"
velTog.Font = Enum.Font.Gotham
velTog.TextSize = 8
velTog.Parent = content
local vtCorner = Instance.new("UICorner")
vtCorner.CornerRadius = UDim.new(0, 4)
vtCorner.Parent = velTog

local angTog = Instance.new("TextButton")
angTog.Size = UDim2.new(0.5, -2, 0, 20)
angTog.Position = UDim2.new(0, 0, 0, 241)
angTog.BackgroundColor3 = COLORS.buttonSuccess
angTog.TextColor3 = COLORS.textLight
angTog.Text = "✓ Angular"
angTog.Font = Enum.Font.Gotham
angTog.TextSize = 8
angTog.Parent = content
local atCorner = Instance.new("UICorner")
atCorner.CornerRadius = UDim.new(0, 4)
atCorner.Parent = angTog

local tpTog = Instance.new("TextButton")
tpTog.Size = UDim2.new(0.5, -2, 0, 20)
tpTog.Position = UDim2.new(0.5, 2, 0, 241)
tpTog.BackgroundColor3 = COLORS.buttonSuccess
tpTog.TextColor3 = COLORS.textLight
tpTog.Text = "✓ Teleport"
tpTog.Font = Enum.Font.Gotham
tpTog.TextSize = 8
tpTog.Parent = content
local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 4)
tpCorner.Parent = tpTog

local massTog = Instance.new("TextButton")
massTog.Size = UDim2.new(0.5, -2, 0, 20)
massTog.Position = UDim2.new(0, 0, 0, 264)
massTog.BackgroundColor3 = COLORS.buttonSuccess
massTog.TextColor3 = COLORS.textLight
massTog.Text = "✓ Mass"
massTog.Font = Enum.Font.Gotham
massTog.TextSize = 8
massTog.Parent = content
local mtCorner = Instance.new("UICorner")
mtCorner.CornerRadius = UDim.new(0, 4)
mtCorner.Parent = massTog

-- Settings Inputs
local settingsLbl = Instance.new("TextLabel")
settingsLbl.Size = UDim2.new(1, 0, 0, 14)
settingsLbl.Position = UDim2.new(0, 0, 0, 288)
settingsLbl.BackgroundTransparency = 1
settingsLbl.TextColor3 = COLORS.textDark
settingsLbl.Text = "Settings:"
settingsLbl.Font = Enum.Font.GothamBold
settingsLbl.TextSize = 9
settingsLbl.TextXAlignment = Enum.TextXAlignment.Left
settingsLbl.Parent = content

local velInput = Instance.new("TextBox")
velInput.Size = UDim2.new(0.5, -2, 0, 20)
velInput.Position = UDim2.new(0, 0, 0, 304)
velInput.BackgroundColor3 = COLORS.inputBg
velInput.TextColor3 = COLORS.textDark
velInput.Text = "999999"
velInput.Font = Enum.Font.Gotham
velInput.TextSize = 9
velInput.PlaceholderText = "Vel Power"
velInput.Parent = content
local viCorner = Instance.new("UICorner")
viCorner.CornerRadius = UDim.new(0, 4)
viCorner.Parent = velInput

local angInput = Instance.new("TextBox")
angInput.Size = UDim2.new(0.5, -2, 0, 20)
angInput.Position = UDim2.new(0.5, 2, 0, 304)
angInput.BackgroundColor3 = COLORS.inputBg
angInput.TextColor3 = COLORS.textDark
angInput.Text = "999999"
angInput.Font = Enum.Font.Gotham
angInput.TextSize = 9
angInput.PlaceholderText = "Ang Power"
angInput.Parent = content
local aiCorner = Instance.new("UICorner")
aiCorner.CornerRadius = UDim.new(0, 4)
aiCorner.Parent = angInput

local swingInput = Instance.new("TextBox")
swingInput.Size = UDim2.new(0.5, -2, 0, 20)
swingInput.Position = UDim2.new(0, 0, 0, 327)
swingInput.BackgroundColor3 = COLORS.inputBg
swingInput.TextColor3 = COLORS.textDark
swingInput.Text = "3"
swingInput.Font = Enum.Font.Gotham
swingInput.TextSize = 9
swingInput.PlaceholderText = "Swings"
swingInput.Parent = content
local siCorner = Instance.new("UICorner")
siCorner.CornerRadius = UDim.new(0, 4)
siCorner.Parent = swingInput

local reachInput = Instance.new("TextBox")
reachInput.Size = UDim2.new(0.5, -2, 0, 20)
reachInput.Position = UDim2.new(0.5, 2, 0, 327)
reachInput.BackgroundColor3 = COLORS.inputBg
reachInput.TextColor3 = COLORS.textDark
reachInput.Text = "15"
reachInput.Font = Enum.Font.Gotham
reachInput.TextSize = 9
reachInput.PlaceholderText = "Reach"
reachInput.Parent = content
local riCorner = Instance.new("UICorner")
riCorner.CornerRadius = UDim.new(0, 4)
riCorner.Parent = reachInput

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
    devBtn.Text = "✓ DEVASTATE"
    devBtn.BackgroundColor3 = COLORS.buttonSuccess
    devBtn.TextColor3 = COLORS.textLight
    orbBtn.Text = "ORBITAL"
    orbBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    orbBtn.TextColor3 = COLORS.textDark
    chaosBtn.Text = "CHAOS"
    chaosBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    chaosBtn.TextColor3 = COLORS.textDark
end)

orbBtn.MouseButton1Click:Connect(function()
    collisionMode = "orbital"
    orbBtn.Text = "✓ ORBITAL"
    orbBtn.BackgroundColor3 = COLORS.buttonSuccess
    orbBtn.TextColor3 = COLORS.textLight
    devBtn.Text = "DEVASTATE"
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
    devBtn.Text = "DEVASTATE"
    devBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    devBtn.TextColor3 = COLORS.textDark
    orbBtn.Text = "ORBITAL"
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
    massTog.Text = massEnabled and "✓ Mass" or "✗ Mass"
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
            btn.Size = UDim2.new(1, 0, 0, 20)
            btn.BackgroundColor3 = targetPlayer == plr and COLORS.buttonPrimary or Color3.fromRGB(240, 240, 240)
            btn.TextColor3 = targetPlayer == plr and COLORS.textLight or COLORS.textDark
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 9
            btn.Parent = playerList
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
    
    playerList.CanvasSize = UDim2.new(0, 0, 0, #playerButtons * 22)
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
            statusLbl.Text = "Select a target first!"
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
        statusLbl.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
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

print("✅ COMBO DESTROYER Loaded (300x350)")
