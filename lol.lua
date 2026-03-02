-- BodyMover Fling Hub (Mobile Fixed - Same Structure as Working Chat Hub)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local flingEnabled = false
local targetPlayer = nil
local flingLoop = nil
local flingCount = 0

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========== HUB BUTTON (Collapsed State) ==========
local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 50, 0, 50)
hubButton.Position = UDim2.new(0, 20, 0.5, -25)
hubButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
hubButton.BorderSizePixel = 2
hubButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
hubButton.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 8)
hubCorner.Parent = hubButton

local hubIcon = Instance.new("TextLabel")
hubIcon.Size = UDim2.new(1, 0, 1, 0)
hubIcon.BackgroundTransparency = 1
hubIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
hubIcon.Text = "🌀"
hubIcon.Font = Enum.Font.GothamBold
hubIcon.TextSize = 22
hubIcon.Parent = hubButton

-- ========== MAIN FRAME (Expanded State) ==========
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 300)
mainFrame.Position = UDim2.new(0, 20, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "🌀 Fling Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Collapse Button
local collapseBtn = Instance.new("TextButton")
collapseBtn.Size = UDim2.new(0, 28, 0, 22)
collapseBtn.Position = UDim2.new(1, -32, 0.5, -11)
collapseBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
collapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
collapseBtn.Text = "×"
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.TextSize = 14
collapseBtn.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.Radius = UDim.new(0, 6)
collapseCorner.Parent = collapseBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -28)
contentFrame.Position = UDim2.new(0, 0, 0, 28)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -20, 0, 32)
toggleBtn.Position = UDim2.new(0, 10, 0, 8)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "FLING: OFF"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
toggleBtn.Parent = contentFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.Radius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

-- Counter Label
local counterLabel = Instance.new("TextLabel")
counterLabel.Size = UDim2.new(1, -20, 0, 16)
counterLabel.Position = UDim2.new(0, 10, 0, 44)
counterLabel.BackgroundTransparency = 1
counterLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
counterLabel.Text = "Flings: 0"
counterLabel.Font = Enum.Font.GothamBold
counterLabel.TextSize = 11
counterLabel.TextXAlignment = Enum.TextXAlignment.Left
counterLabel.Parent = contentFrame

-- Target Label
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, -20, 0, 16)
targetLabel.Position = UDim2.new(0, 10, 0, 62)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
targetLabel.Text = "Select Target:"
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextSize = 10
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = contentFrame

-- Player List
local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1, -20, 0, 80)
playerScroll.Position = UDim2.new(0, 10, 0, 80)
playerScroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
playerScroll.ScrollBarThickness = 4
playerScroll.Parent = contentFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.Radius = UDim.new(0, 6)
scrollCorner.Parent = playerScroll

local playerLayout = Instance.new("UIListLayout")
playerLayout.Padding = UDim.new(0, 2)
playerLayout.Parent = playerScroll

-- Spin Power Row
local spinRow = Instance.new("Frame")
spinRow.Size = UDim2.new(1, -20, 0, 24)
spinRow.Position = UDim2.new(0, 10, 0, 166)
spinRow.BackgroundTransparency = 1
spinRow.Parent = contentFrame

local spinLabel = Instance.new("TextLabel")
spinLabel.Size = UDim2.new(0, 80, 1, 0)
spinLabel.BackgroundTransparency = 1
spinLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
spinLabel.Text = "Spin:"
spinLabel.Font = Enum.Font.Gotham
spinLabel.TextSize = 10
spinLabel.TextXAlignment = Enum.TextXAlignment.Left
spinLabel.Parent = spinRow

local spinInput = Instance.new("TextBox")
spinInput.Size = UDim2.new(0, 60, 1, 0)
spinInput.Position = UDim2.new(0, 85, 0, 0)
spinInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
spinInput.TextColor3 = Color3.fromRGB(255, 255, 255)
spinInput.Text = "999999"
spinInput.Font = Enum.Font.Gotham
spinInput.TextSize = 10
spinInput.ClearTextOnFocus = false
spinInput.Parent = spinRow

local spinCorner = Instance.new("UICorner")
spinCorner.Radius = UDim.new(0, 6)
spinCorner.Parent = spinInput

-- Launch Power Row
local launchRow = Instance.new("Frame")
launchRow.Size = UDim2.new(1, -20, 0, 24)
launchRow.Position = UDim2.new(0, 10, 0, 194)
launchRow.BackgroundTransparency = 1
launchRow.Parent = contentFrame

local launchLabel = Instance.new("TextLabel")
launchLabel.Size = UDim2.new(0, 80, 1, 0)
launchLabel.BackgroundTransparency = 1
launchLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
launchLabel.Text = "Launch:"
launchLabel.Font = Enum.Font.Gotham
launchLabel.TextSize = 10
launchLabel.TextXAlignment = Enum.TextXAlignment.Left
launchLabel.Parent = launchRow

local launchInput = Instance.new("TextBox")
launchInput.Size = UDim2.new(0, 60, 1, 0)
launchInput.Position = UDim2.new(0, 85, 0, 0)
launchInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
launchInput.TextColor3 = Color3.fromRGB(255, 255, 255)
launchInput.Text = "999999"
launchInput.Font = Enum.Font.Gotham
launchInput.TextSize = 10
launchInput.ClearTextOnFocus = false
launchInput.Parent = launchRow

local launchCorner = Instance.new("UICorner")
launchCorner.Radius = UDim.new(0, 6)
launchCorner.Parent = launchInput

-- Prediction Row
local predRow = Instance.new("Frame")
predRow.Size = UDim2.new(1, -20, 0, 24)
predRow.Position = UDim2.new(0, 10, 0, 222)
predRow.BackgroundTransparency = 1
predRow.Parent = contentFrame

local predLabel = Instance.new("TextLabel")
predLabel.Size = UDim2.new(0, 80, 1, 0)
predLabel.BackgroundTransparency = 1
predLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
predLabel.Text = "Prediction:"
predLabel.Font = Enum.Font.Gotham
predLabel.TextSize = 10
predLabel.TextXAlignment = Enum.TextXAlignment.Left
predLabel.Parent = predRow

local predInput = Instance.new("TextBox")
predInput.Size = UDim2.new(0, 60, 1, 0)
predInput.Position = UDim2.new(0, 85, 0, 0)
predInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
predInput.TextColor3 = Color3.fromRGB(255, 255, 255)
predInput.Text = "0.15"
predInput.Font = Enum.Font.Gotham
predInput.TextSize = 10
predInput.ClearTextOnFocus = false
predInput.Parent = predRow

local predCorner = Instance.new("UICorner")
predCorner.Radius = UDim.new(0, 6)
predCorner.Parent = predInput

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 16)
statusLabel.Position = UDim2.new(0, 10, 0, 250)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Text = "No target selected"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = contentFrame

-- ========== DRAGGING FOR HUB BUTTON (SAME AS WORKING SCRIPT) ==========
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

-- ========== DRAGGING FOR MAIN FRAME (SAME AS WORKING SCRIPT) ==========
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

-- ========== TOGGLE HUB (SAME AS WORKING SCRIPT) ==========
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
            btn.BackgroundColor3 = targetPlayer == plr and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 10
            btn.Parent = playerScroll
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.Radius = UDim.new(0, 4)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                targetPlayer = plr
                statusLabel.Text = "Target: " .. plr.Name
                updatePlayerList()
            end)
            
            table.insert(playerButtons, btn)
        end
    end
    
    playerScroll.CanvasSize = UDim2.new(0, 0, 0, #playerButtons * 22)
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

local bodyAngularVel = nil
local bodyVel = nil

local function stopFling()
    if flingLoop then
        flingLoop:Disconnect()
        flingLoop = nil
    end
    
    if bodyAngularVel then
        bodyAngularVel:Destroy()
        bodyAngularVel = nil
    end
    
    if bodyVel then
        bodyVel:Destroy()
        bodyVel = nil
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
    
    local myChar = player.Character
    if not myChar then return end
    
    local myRoot = getRoot(myChar)
    local myHumanoid = myChar:FindFirstChild("Humanoid")
    
    if not myRoot then return end
    
    local spinPower = tonumber(spinInput.Text) or 999999
    local launchPower = tonumber(launchInput.Text) or 999999
    local prediction = tonumber(predInput.Text) or 0.15
    
    if bodyAngularVel then bodyAngularVel:Destroy() end
    bodyAngularVel = Instance.new("BodyAngularVelocity")
    bodyAngularVel.Name = "FlingSpin"
    bodyAngularVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyAngularVel.AngularVelocity = Vector3.new(spinPower, spinPower, spinPower)
    bodyAngularVel.P = math.huge
    bodyAngularVel.Parent = myRoot
    
    if bodyVel then bodyVel:Destroy() end
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Name = "FlingLaunch"
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Velocity = Vector3.new(0, launchPower, 0)
    bodyVel.P = math.huge
    bodyVel.Parent = myRoot
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
    
    flingLoop = RunService.RenderStepped:Connect(function()
        if not flingEnabled then return end
        
        local char = player.Character
        if not char then return end
        
        local root = getRoot(char)
        if not root then return end
        
        if not targetPlayer or not targetPlayer.Character then
            return
        end
        
        local targetRoot = getRoot(targetPlayer.Character)
        if not targetRoot then return end
        
        local targetVel = targetRoot.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
        local predictedPos = targetRoot.Position + (targetVel * prediction)
        
        root.CFrame = CFrame.new(predictedPos) * targetRoot.CFrame.Rotation
        
        if not root:FindFirstChild("FlingSpin") then
            bodyAngularVel = Instance.new("BodyAngularVelocity")
            bodyAngularVel.Name = "FlingSpin"
            bodyAngularVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyAngularVel.AngularVelocity = Vector3.new(spinPower, spinPower, spinPower)
            bodyAngularVel.P = math.huge
            bodyAngularVel.Parent = root
        end
        
        if not root:FindFirstChild("FlingLaunch") then
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.Name = "FlingLaunch"
            bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVel.Velocity = Vector3.new(0, launchPower, 0)
            bodyVel.P = math.huge
            bodyVel.Parent = root
        end
    end)
end

-- ========== TOGGLE FLING ==========
toggleBtn.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    
    if flingEnabled then
        if not targetPlayer then
            statusLabel.Text = "Select a target first!"
            flingEnabled = false
            return
        end
        
        toggleBtn.Text = "FLING: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
        statusLabel.Text = "Flinging: " .. targetPlayer.Name
        
        startFling()
    else
        toggleBtn.Text = "FLING: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        statusLabel.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
        
        stopFling()
    end
end)

-- ========== TOGGLE WITH RIGHT CONTROL ==========
local guiVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        if mainFrame.Visible then
            mainFrame.Visible = false
            hubButton.Visible = guiVisible
        else
            guiVisible = not guiVisible
            hubButton.Visible = guiVisible
        end
    end
end)

-- ========== AUTO RESTART ON RESPAWN ==========
player.CharacterAdded:Connect(function(char)
    wait(0.3)
    
    if flingEnabled then
        flingCount = flingCount + 1
        counterLabel.Text = "Flings: " .. flingCount
        startFling()
    end
end)

player.CharacterRemoving:Connect(function()
    stopFling()
end)

print("✅ Fling Hub Loaded")
