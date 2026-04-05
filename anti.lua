-- ULTIMATE COLLISION FLING (FIXED)
-- Multiple physics methods combined for MAXIMUM power

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

-- Power Settings
local teleportMultiplier = 1
local velocityPower = 999999
local angularPower = 999999
local collisionMode = "devastate"

-- Toggle states
local velocityEnabled = true
local angularEnabled = true
local teleportEnabled = true
local massEnabled = true

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
screenGui.Name = "UltimateCollisionFling"
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
hubButtonIcon.Text = "💀"
hubButtonIcon.Font = Enum.Font.GothamBold
hubButtonIcon.TextSize = 22
hubButtonIcon.Parent = hubButton

-- ========== MAIN FRAME ==========

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 420, 0, 450)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -225)
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
titleLabel.Text = "💀 ULTIMATE Collision Fling"
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
toggleButton.Size = UDim2.new(1, 0, 0, 40)
toggleButton.Position = UDim2.new(0, 0, 0, 0)
toggleButton.BackgroundColor3 = COLORS.buttonDanger
toggleButton.TextColor3 = COLORS.textLight
toggleButton.Text = "FLING: OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.Parent = leftFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Fling Counter
local flingCounter = Instance.new("TextLabel")
flingCounter.Size = UDim2.new(1, 0, 0, 18)
flingCounter.Position = UDim2.new(0, 0, 0, 45)
flingCounter.BackgroundTransparency = 1
flingCounter.TextColor3 = COLORS.buttonSuccess
flingCounter.Text = "Flings: 0"
flingCounter.Font = Enum.Font.GothamBold
flingCounter.TextSize = 11
flingCounter.Parent = leftFrame

-- Target Label
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, 0, 0, 16)
targetLabel.Position = UDim2.new(0, 0, 0, 68)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = COLORS.textDark
targetLabel.Text = "Select Target:"
targetLabel.Font = Enum.Font.GothamBold
targetLabel.TextSize = 10
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = leftFrame

-- Player List
local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1, 0, 0, 120)
playerScroll.Position = UDim2.new(0, 0, 0, 86)
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
statusLabel.Position = UDim2.new(0, 0, 0, 210)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = COLORS.textMuted
statusLabel.Text = "No target selected"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextWrapped = true
statusLabel.Parent = leftFrame

-- Mode Label
local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, 0, 0, 16)
modeLabel.Position = UDim2.new(0, 0, 0, 232)
modeLabel.BackgroundTransparency = 1
modeLabel.TextColor3 = COLORS.textDark
modeLabel.Text = "Fling Mode:"
modeLabel.Font = Enum.Font.GothamBold
modeLabel.TextSize = 10
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = leftFrame

-- Mode Buttons Frame
local modesFrame = Instance.new("Frame")
modesFrame.Size = UDim2.new(1, 0, 0, 90)
modesFrame.Position = UDim2.new(0, 0, 0, 250)
modesFrame.BackgroundTransparency = 1
modesFrame.Parent = leftFrame

local devastateModeBtn = Instance.new("TextButton")
devastateModeBtn.Size = UDim2.new(1, 0, 0, 26)
devastateModeBtn.Position = UDim2.new(0, 0, 0, 0)
devastateModeBtn.BackgroundColor3 = COLORS.buttonSuccess
devastateModeBtn.TextColor3 = COLORS.textLight
devastateModeBtn.Text = "✓ DEVASTATE (Max Power)"
devastateModeBtn.Font = Enum.Font.GothamBold
devastateModeBtn.TextSize = 10
devastateModeBtn.Parent = modesFrame

local devastateCorner = Instance.new("UICorner")
devastateCorner.CornerRadius = UDim.new(0, 5)
devastateCorner.Parent = devastateModeBtn

local orbitalModeBtn = Instance.new("TextButton")
orbitalModeBtn.Size = UDim2.new(1, 0, 0, 26)
orbitalModeBtn.Position = UDim2.new(0, 0, 0, 30)
orbitalModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
orbitalModeBtn.TextColor3 = COLORS.textDark
orbitalModeBtn.Text = "Orbital (Circular)"
orbitalModeBtn.Font = Enum.Font.Gotham
orbitalModeBtn.TextSize = 10
orbitalModeBtn.Parent = modesFrame

local orbitalCorner = Instance.new("UICorner")
orbitalCorner.CornerRadius = UDim.new(0, 5)
orbitalCorner.Parent = orbitalModeBtn

local chaosModeBtn = Instance.new("TextButton")
chaosModeBtn.Size = UDim2.new(1, 0, 0, 26)
chaosModeBtn.Position = UDim2.new(0, 0, 0, 60)
chaosModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
chaosModeBtn.TextColor3 = COLORS.textDark
chaosModeBtn.Text = "Chaos (Random)"
chaosModeBtn.Font = Enum.Font.Gotham
chaosModeBtn.TextSize = 10
chaosModeBtn.Parent = modesFrame

local chaosCorner = Instance.new("UICorner")
chaosCorner.CornerRadius = UDim.new(0, 5)
chaosCorner.Parent = chaosModeBtn

-- ========== RIGHT FRAME ==========

local rightFrame = Instance.new("Frame")
rightFrame.Size = UDim2.new(0.5, -15, 1, -50)
rightFrame.Position = UDim2.new(0.5, 5, 0, 40)
rightFrame.BackgroundTransparency = 1
rightFrame.Parent = mainFrame

-- Power Settings Label
local powerLabel = Instance.new("TextLabel")
powerLabel.Size = UDim2.new(1, 0, 0, 16)
powerLabel.Position = UDim2.new(0, 0, 0, 0)
powerLabel.BackgroundTransparency = 1
powerLabel.TextColor3 = COLORS.textDark
powerLabel.Text = "Power Settings:"
powerLabel.Font = Enum.Font.GothamBold
powerLabel.TextSize = 10
powerLabel.TextXAlignment = Enum.TextXAlignment.Left
powerLabel.Parent = rightFrame

-- Velocity Power
local velocityRow = Instance.new("Frame")
velocityRow.Size = UDim2.new(1, 0, 0, 24)
velocityRow.Position = UDim2.new(0, 0, 0, 18)
velocityRow.BackgroundTransparency = 1
velocityRow.Parent = rightFrame

local velocityLabel = Instance.new("TextLabel")
velocityLabel.Size = UDim2.new(0, 110, 1, 0)
velocityLabel.BackgroundTransparency = 1
velocityLabel.TextColor3 = COLORS.textDark
velocityLabel.Text = "Velocity Power:"
velocityLabel.Font = Enum.Font.Gotham
velocityLabel.TextSize = 10
velocityLabel.TextXAlignment = Enum.TextXAlignment.Left
velocityLabel.Parent = velocityRow

local velocityInput = Instance.new("TextBox")
velocityInput.Size = UDim2.new(0, 80, 1, 0)
velocityInput.Position = UDim2.new(0, 115, 0, 0)
velocityInput.BackgroundColor3 = COLORS.inputBg
velocityInput.TextColor3 = COLORS.textDark
velocityInput.Text = "999999"
velocityInput.Font = Enum.Font.Gotham
velocityInput.TextSize = 10
velocityInput.ClearTextOnFocus = false
velocityInput.Parent = velocityRow

local velocityCorner = Instance.new("UICorner")
velocityCorner.CornerRadius = UDim.new(0, 5)
velocityCorner.Parent = velocityInput

local velocityStroke = Instance.new("UIStroke")
velocityStroke.Color = COLORS.border
velocityStroke.Thickness = 1
velocityStroke.Parent = velocityInput

-- Angular Power
local angularRow = Instance.new("Frame")
angularRow.Size = UDim2.new(1, 0, 0, 24)
angularRow.Position = UDim2.new(0, 0, 0, 44)
angularRow.BackgroundTransparency = 1
angularRow.Parent = rightFrame

local angularLabel = Instance.new("TextLabel")
angularLabel.Size = UDim2.new(0, 110, 1, 0)
angularLabel.BackgroundTransparency = 1
angularLabel.TextColor3 = COLORS.textDark
angularLabel.Text = "Angular Power:"
angularLabel.Font = Enum.Font.Gotham
angularLabel.TextSize = 10
angularLabel.TextXAlignment = Enum.TextXAlignment.Left
angularLabel.Parent = angularRow

local angularInput = Instance.new("TextBox")
angularInput.Size = UDim2.new(0, 80, 1, 0)
angularInput.Position = UDim2.new(0, 115, 0, 0)
angularInput.BackgroundColor3 = COLORS.inputBg
angularInput.TextColor3 = COLORS.textDark
angularInput.Text = "999999"
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

-- Teleport Speed
local teleportRow = Instance.new("Frame")
teleportRow.Size = UDim2.new(1, 0, 0, 24)
teleportRow.Position = UDim2.new(0, 0, 0, 70)
teleportRow.BackgroundTransparency = 1
teleportRow.Parent = rightFrame

local teleportLabel = Instance.new("TextLabel")
teleportLabel.Size = UDim2.new(0, 110, 1, 0)
teleportLabel.BackgroundTransparency = 1
teleportLabel.TextColor3 = COLORS.textDark
teleportLabel.Text = "Teleport Speed:"
teleportLabel.Font = Enum.Font.Gotham
teleportLabel.TextSize = 10
teleportLabel.TextXAlignment = Enum.TextXAlignment.Left
teleportLabel.Parent = teleportRow

local teleportInput = Instance.new("TextBox")
teleportInput.Size = UDim2.new(0, 80, 1, 0)
teleportInput.Position = UDim2.new(0, 115, 0, 0)
teleportInput.BackgroundColor3 = COLORS.inputBg
teleportInput.TextColor3 = COLORS.textDark
teleportInput.Text = "500"
teleportInput.Font = Enum.Font.Gotham
teleportInput.TextSize = 10
teleportInput.ClearTextOnFocus = false
teleportInput.Parent = teleportRow

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 5)
teleportCorner.Parent = teleportInput

local teleportStroke = Instance.new("UIStroke")
teleportStroke.Color = COLORS.border
teleportStroke.Thickness = 1
teleportStroke.Parent = teleportInput

-- Collision Layers Label
local layersLabel = Instance.new("TextLabel")
layersLabel.Size = UDim2.new(1, 0, 0, 16)
layersLabel.Position = UDim2.new(0, 0, 0, 98)
layersLabel.BackgroundTransparency = 1
layersLabel.TextColor3 = COLORS.textDark
layersLabel.Text = "Collision Layers:"
layersLabel.Font = Enum.Font.GothamBold
layersLabel.TextSize = 10
layersLabel.TextXAlignment = Enum.TextXAlignment.Left
layersLabel.Parent = rightFrame

-- Collision Toggles Frame
local layersFrame = Instance.new("Frame")
layersFrame.Size = UDim2.new(1, 0, 0, 120)
layersFrame.Position = UDim2.new(0, 0, 0, 116)
layersFrame.BackgroundTransparency = 1
layersFrame.Parent = rightFrame

local velocityToggle = Instance.new("TextButton")
velocityToggle.Size = UDim2.new(1, 0, 0, 22)
velocityToggle.Position = UDim2.new(0, 0, 0, 0)
velocityToggle.BackgroundColor3 = COLORS.buttonSuccess
velocityToggle.TextColor3 = COLORS.textLight
velocityToggle.Text = "✓ Velocity Burst"
velocityToggle.Font = Enum.Font.Gotham
velocityToggle.TextSize = 9
velocityToggle.Parent = layersFrame

local velocityTogCorner = Instance.new("UICorner")
velocityTogCorner.CornerRadius = UDim.new(0, 5)
velocityTogCorner.Parent = velocityToggle

local angularToggle = Instance.new("TextButton")
angularToggle.Size = UDim2.new(1, 0, 0, 22)
angularToggle.Position = UDim2.new(0, 0, 0, 26)
angularToggle.BackgroundColor3 = COLORS.buttonSuccess
angularToggle.TextColor3 = COLORS.textLight
angularToggle.Text = "✓ Angular Force"
angularToggle.Font = Enum.Font.Gotham
angularToggle.TextSize = 9
angularToggle.Parent = layersFrame

local angularTogCorner = Instance.new("UICorner")
angularTogCorner.CornerRadius = UDim.new(0, 5)
angularTogCorner.Parent = angularToggle

local teleportToggle = Instance.new("TextButton")
teleportToggle.Size = UDim2.new(1, 0, 0, 22)
teleportToggle.Position = UDim2.new(0, 0, 0, 52)
teleportToggle.BackgroundColor3 = COLORS.buttonSuccess
teleportToggle.TextColor3 = COLORS.textLight
teleportToggle.Text = "✓ Rapid Teleport"
teleportToggle.Font = Enum.Font.Gotham
teleportToggle.TextSize = 9
teleportToggle.Parent = layersFrame

local teleportTogCorner = Instance.new("UICorner")
teleportTogCorner.CornerRadius = UDim.new(0, 5)
teleportTogCorner.Parent = teleportToggle

local massToggle = Instance.new("TextButton")
massToggle.Size = UDim2.new(1, 0, 0, 22)
massToggle.Position = UDim2.new(0, 0, 0, 78)
massToggle.BackgroundColor3 = COLORS.buttonSuccess
massToggle.TextColor3 = COLORS.textLight
massToggle.Text = "✓ Mass Boost"
massToggle.Font = Enum.Font.Gotham
massToggle.TextSize = 9
massToggle.Parent = layersFrame

local massTogCorner = Instance.new("UICorner")
massTogCorner.CornerRadius = UDim.new(0, 5)
massTogCorner.Parent = massToggle

-- Info
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 50)
infoLabel.Position = UDim2.new(0, 0, 0, 240)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = COLORS.textMuted
infoLabel.Text = "DEVASTATE = All methods at once\nORBITAL = Circular teleportation\nCHAOS = Random positions"
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

-- ========== MODE BUTTONS ==========

devastateModeBtn.MouseButton1Click:Connect(function()
    collisionMode = "devastate"
    devastateModeBtn.Text = "✓ DEVASTATE (Max Power)"
    devastateModeBtn.BackgroundColor3 = COLORS.buttonSuccess
    devastateModeBtn.TextColor3 = COLORS.textLight
    orbitalModeBtn.Text = "Orbital (Circular)"
    orbitalModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    orbitalModeBtn.TextColor3 = COLORS.textDark
    chaosModeBtn.Text = "Chaos (Random)"
    chaosModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    chaosModeBtn.TextColor3 = COLORS.textDark
end)

orbitalModeBtn.MouseButton1Click:Connect(function()
    collisionMode = "orbital"
    orbitalModeBtn.Text = "✓ Orbital (Circular)"
    orbitalModeBtn.BackgroundColor3 = COLORS.buttonSuccess
    orbitalModeBtn.TextColor3 = COLORS.textLight
    devastateModeBtn.Text = "DEVASTATE (Max Power)"
    devastateModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    devastateModeBtn.TextColor3 = COLORS.textDark
    chaosModeBtn.Text = "Chaos (Random)"
    chaosModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    chaosModeBtn.TextColor3 = COLORS.textDark
end)

chaosModeBtn.MouseButton1Click:Connect(function()
    collisionMode = "chaos"
    chaosModeBtn.Text = "✓ Chaos (Random)"
    chaosModeBtn.BackgroundColor3 = COLORS.buttonSuccess
    chaosModeBtn.TextColor3 = COLORS.textLight
    devastateModeBtn.Text = "DEVASTATE (Max Power)"
    devastateModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    devastateModeBtn.TextColor3 = COLORS.textDark
    orbitalModeBtn.Text = "Orbital (Circular)"
    orbitalModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    orbitalModeBtn.TextColor3 = COLORS.textDark
end)

-- ========== TOGGLE OPTIONS ==========

velocityToggle.MouseButton1Click:Connect(function()
    velocityEnabled = not velocityEnabled
    velocityToggle.Text = velocityEnabled and "✓ Velocity Burst" or "✗ Velocity Burst"
    velocityToggle.BackgroundColor3 = velocityEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

angularToggle.MouseButton1Click:Connect(function()
    angularEnabled = not angularEnabled
    angularToggle.Text = angularEnabled and "✓ Angular Force" or "✗ Angular Force"
    angularToggle.BackgroundColor3 = angularEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

teleportToggle.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    teleportToggle.Text = teleportEnabled and "✓ Rapid Teleport" or "✗ Rapid Teleport"
    teleportToggle.BackgroundColor3 = teleportEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

massToggle.MouseButton1Click:Connect(function()
    massEnabled = not massEnabled
    massToggle.Text = massEnabled and "✓ Mass Boost" or "✗ Mass Boost"
    massToggle.BackgroundColor3 = massEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
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

-- ========== FLING FUNCTIONS ==========

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local bodyVel = nil
local bodyAngVel = nil
local angle = 0

local function boostMass(char)
    if not massEnabled then return end
    
    local root = getRoot(char)
    if not root then return end
    
    root.CustomPhysicalProperties = PhysicalProperties.new(100, 0.5, 0.5)
end

local function resetMass(char)
    local root = getRoot(char)
    if root then
        root.CustomPhysicalProperties = nil
    end
end

local function stopFling()
    if flingLoop then
        flingLoop:Disconnect()
        flingLoop = nil
    end
    
    if bodyVel then
        bodyVel:Destroy()
        bodyVel = nil
    end
    
    if bodyAngVel then
        bodyAngVel:Destroy()
        bodyAngVel = nil
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
        
        resetMass(myChar)
    end
end

local function devastateFling(targetRoot, myRoot, myHumanoid)
    velocityPower = tonumber(velocityInput.Text) or 999999
    angularPower = tonumber(angularInput.Text) or 999999
    
    if massEnabled then
        boostMass(player.Character)
    end
    
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
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

local function orbitalFling(targetRoot, myRoot, myHumanoid)
    velocityPower = tonumber(velocityInput.Text) or 999999
    angularPower = tonumber(angularInput.Text) or 999999
    teleportMultiplier = tonumber(teleportInput.Text) or 500
    
    angle = angle + (math.pi * 2 / teleportMultiplier)
    
    local offsetX = math.cos(angle) * 2
    local offsetZ = math.sin(angle) * 2
    
    if massEnabled then
        boostMass(player.Character)
    end
    
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
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

local function chaosFling(targetRoot, myRoot, myHumanoid)
    velocityPower = tonumber(velocityInput.Text) or 999999
    angularPower = tonumber(angularInput.Text) or 999999
    
    if massEnabled then
        boostMass(player.Character)
    end
    
    if teleportEnabled then
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(
            math.random(-3, 3),
            math.random(-2, 2),
            math.random(-3, 3)
        )
    end
    
    if velocityEnabled then
        if bodyVel then bodyVel:Destroy() end
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.Name = "CollisionBurst"
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel.Velocity = Vector3.new(
            math.random(-1, 1) * velocityPower,
            math.random(-1, 1) * velocityPower,
            math.random(-1, 1) * velocityPower
        )
        bodyVel.P = math.huge
        bodyVel.Parent = myRoot
    end
    
    if angularEnabled then
        if bodyAngVel then bodyAngVel:Destroy() end
        bodyAngVel = Instance.new("BodyAngularVelocity")
        bodyAngVel.Name = "CollisionSpin"
        bodyAngVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngVel.AngularVelocity = Vector3.new(
            math.random(-1, 1) * angularPower,
            math.random(-1, 1) * angularPower,
            math.random(-1, 1) * angularPower
        )
        bodyAngVel.P = math.huge
        bodyAngVel.Parent = myRoot
    end
    
    if myHumanoid then
        myHumanoid.PlatformStand = true
    end
end

local function startFling()
    if flingLoop then
        flingLoop:Disconnect()
    end
    
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
        
        if collisionMode == "devastate" then
            devastateFling(targetRoot, myRoot, myHumanoid)
        elseif collisionMode == "orbital" then
            orbitalFling(targetRoot, myRoot, myHumanoid)
        else
            chaosFling(targetRoot, myRoot, myHumanoid)
        end
    end)
end

-- ========== FLING TOGGLE ==========

toggleButton.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    
    if flingEnabled then
        if not targetPlayer then
            statusLabel.Text = "Select a target first!"
            flingEnabled = false
            return
        end
        
        toggleButton.Text = "FLING: ON"
        toggleButton.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel.Text = "Flinging: " .. targetPlayer.Name .. " (" .. collisionMode:upper() .. ")"
        
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
    wait(0.3)
    
    if flingEnabled then
        flingCount = flingCount + 1
        flingCounter.Text = "Flings: " .. flingCount
        startFling()
    end
end)

-- Cleanup on character removal
player.CharacterRemoving:Connect(function()
    stopFling()
end)

print("✅ ULTIMATE Collision Fling Loaded")
print("   3 Modes: DEVASTATE, ORBITAL, CHAOS")
print("   4 Layers: Velocity + Angular + Teleport + Mass")
print("   Maximum power configuration")
