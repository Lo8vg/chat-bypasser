-- FAGGOT KILLER

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings (hardcoded)
local destroyEnabled = false
local targetPlayer = nil
local velocityPower = 999999
local angularPower = 999999
local flingLoop = nil
local bodyVel = nil
local bodyAngVel = nil

local COLORS = {
    background = Color3.fromRGB(25, 25, 25),
    header = Color3.fromRGB(15, 15, 15),
    buttonPrimary = Color3.fromRGB(0, 120, 215),
    buttonDanger = Color3.fromRGB(220, 53, 69),
    buttonSuccess = Color3.fromRGB(40, 167, 69),
    textDark = Color3.fromRGB(240, 240, 240),
    textLight = Color3.fromRGB(255, 255, 255),
    textMuted = Color3.fromRGB(170, 170, 170),
    border = Color3.fromRGB(60, 60, 60),
    cardBg = Color3.fromRGB(35, 35, 35)
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FaggotKillerHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Hub Button
local hubButton = Instance.new("TextButton")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 60, 0, 60)
hubButton.Position = UDim2.new(0, 10, 0.5, -30)
hubButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
hubButton.BorderSizePixel = 0
hubButton.Text = "FLING"
hubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hubButton.Font = Enum.Font.GothamBold
hubButton.TextSize = 16
hubButton.Visible = true
hubButton.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 12)
hubCorner.Parent = hubButton

local hubGradient = Instance.new("UIGradient")
hubGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120))
})
hubGradient.Rotation = 45
hubGradient.Parent = hubButton

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 300)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -150)
mainFrame.BackgroundColor3 = COLORS.background
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mfCorner = Instance.new("UICorner")
mfCorner.CornerRadius = UDim.new(0, 12)
mfCorner.Parent = mainFrame

local mfGradient = Instance.new("UIGradient")
mfGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60))
})
mfGradient.Rotation = 90
mfGradient.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = COLORS.header
titleBar.Parent = mainFrame

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 12)
tbCorner.Parent = titleBar

local tbFix = Instance.new("Frame")
tbFix.Size = UDim2.new(1, 0, 0, 14)
tbFix.Position = UDim2.new(0, 0, 1, -14)
tbFix.BackgroundColor3 = COLORS.header
tbFix.BorderSizePixel = 0
tbFix.Parent = titleBar

local tbGradient = Instance.new("UIGradient")
tbGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 90, 90))
})
tbGradient.Rotation = 45
tbGradient.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = COLORS.textLight
title.Text = "FAGGOT KILLER"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 24)
closeBtn.Position = UDim2.new(1, -34, 0.5, -12)
closeBtn.BackgroundColor3 = COLORS.buttonDanger
closeBtn.TextColor3 = COLORS.textLight
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -16, 1, -54)
contentFrame.Position = UDim2.new(0, 8, 0, 46)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 0, 34)
toggleBtn.BackgroundColor3 = COLORS.buttonDanger
toggleBtn.TextColor3 = COLORS.textLight
toggleBtn.Text = "FAGGOT DESTROYER OFF"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.Parent = contentFrame
local togCorner = Instance.new("UICorner")
togCorner.CornerRadius = UDim.new(0, 6)
togCorner.Parent = toggleBtn

-- Target Label
local targetLbl = Instance.new("TextLabel")
targetLbl.Size = UDim2.new(1, 0, 0, 16)
targetLbl.Position = UDim2.new(0, 0, 0, 44)
targetLbl.BackgroundTransparency = 1
targetLbl.TextColor3 = COLORS.textDark
targetLbl.Text = "Target:"
targetLbl.Font = Enum.Font.GothamBold
targetLbl.TextSize = 10
targetLbl.TextXAlignment = Enum.TextXAlignment.Left
targetLbl.Parent = contentFrame

-- Player List
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, 0, 0, 150)
playerList.Position = UDim2.new(0, 0, 0, 64)
playerList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
playerList.ScrollBarThickness = 4
playerList.Parent = contentFrame
local plCorner = Instance.new("UICorner")
plCorner.CornerRadius = UDim.new(0, 6)
plCorner.Parent = playerList
local plLayout = Instance.new("UIListLayout")
plLayout.Padding = UDim.new(0, 2)
plLayout.Parent = playerList

-- Kill GUI Button
local killGuiBtn = Instance.new("TextButton")
killGuiBtn.Size = UDim2.new(1, 0, 0, 28)
killGuiBtn.Position = UDim2.new(0, 0, 1, -28)
killGuiBtn.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
killGuiBtn.TextColor3 = COLORS.textLight
killGuiBtn.Text = "☠ KILL GUI"
killGuiBtn.Font = Enum.Font.GothamBold
killGuiBtn.TextSize = 11
killGuiBtn.Parent = contentFrame
local killCorner = Instance.new("UICorner")
killCorner.CornerRadius = UDim.new(0, 5)
killCorner.Parent = contentFrame
-- Dragging (hub button)
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

hubButton.MouseButton1Click:Connect(function()
    wait(0.05)
    if not dragging then
        hubButton.Visible = false
        mainFrame.Visible = true
    end
end)

-- Dragging (main frame)
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

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

-- Kill GUI
killGuiBtn.MouseButton1Click:Connect(function()
    destroyEnabled = false
    if flingLoop then
        flingLoop:Disconnect()
        flingLoop = nil
    end
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
    if bodyAngVel then bodyAngVel:Destroy() bodyAngVel = nil end
    screenGui:Destroy()
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
            btn.BackgroundColor3 = targetPlayer == plr and COLORS.buttonPrimary or Color3.fromRGB(50, 50, 50)
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

-- Helpers
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
            return item
        end
    end
    return nil
end

local function boostMass(char)
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

-- Devastate Fling
local function devastateFling(targetRoot, myRoot, myHumanoid)
    boostMass(player.Character)
    myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
    
    if bodyVel then bodyVel:Destroy() end
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Name = "CollisionBurst"
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Velocity = Vector3.new(math.random(-1, 1) * velocityPower, velocityPower, math.random(-1, 1) * velocityPower)
    bodyVel.P = math.huge
    bodyVel.Parent = myRoot
    
    if bodyAngVel then bodyAngVel:Destroy() end
    bodyAngVel = Instance.new("BodyAngularVelocity")
    bodyAngVel.Name = "CollisionSpin"
    bodyAngVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyAngVel.AngularVelocity = Vector3.new(angularPower, angularPower, angularPower)
    bodyAngVel.P = math.huge
    bodyAngVel.Parent = myRoot
    
    if myHumanoid then myHumanoid.PlatformStand = true end
end

-- Sword Attack
local function swordAttack(targetRoot, myRoot)
    local sword = getSword()
    if not sword then
        sword = equipSword()
        if not sword then return end
    end
    local distance = (targetRoot.Position - myRoot.Position).Magnitude
    if distance <= 15 then
        for i = 1, 3 do
            sword:Activate()
            wait(0.01)
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
        
        devastateFling(targetRoot, myRoot, myHumanoid)
        swordAttack(targetRoot, myRoot)
    end)
end

-- Main Toggle
toggleBtn.MouseButton1Click:Connect(function()
    destroyEnabled = not destroyEnabled
    if destroyEnabled then
        if not targetPlayer then
            destroyEnabled = false
            return
        end
        toggleBtn.Text = "FAGGOT DESTROYER ON"
        toggleBtn.BackgroundColor3 = COLORS.buttonSuccess
        equipSword()
        startDestroy()
    else
        toggleBtn.Text = "FAGGOT DESTROYER OFF"
        toggleBtn.BackgroundColor3 = COLORS.buttonDanger
        stopAll()
    end
end)

-- Respawn Handler
player.CharacterAdded:Connect(function(char)
    if destroyEnabled then
        equipSword()
        startDestroy()
    end
end)

player.CharacterRemoving:Connect(function()
    stopAll()
end)

print("✅ FAGGOT KILLER Loaded")
