-- ULTIMATE COLLISION FLING (SMART FOLLOW EDITION)
-- Works on MOVING targets with velocity prediction

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
local velocityPower = 999999
local angularPower = 999999
local collisionMode = "devastate"

-- Smart Follow Settings
local predictionEnabled = true
local velocityMatchEnabled = true
local predictionFrames = 3  -- How many frames ahead to predict

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
mainFrame.Size = UDim2.new(0, 460, 0, 500)
mainFrame.Position = UDim2.new(0.5, -230, 0.5, -250)
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
titleLabel.Text = "💀 SMART Collision Fling"
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
playerScroll.Size = UDim2.new(1, 0, 0, 100)
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
statusLabel.Size = UDim2.new(1, 0, 0, 35)
statusLabel.Position = UDim2.new(0, 0, 0, 190)
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
modeLabel.Position = UDim2.new(0, 0, 0, 230)
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
modesFrame.Position = UDim2.new(0, 0, 0, 248)
modesFrame.BackgroundTransparency = 1
modesFrame.Parent = leftFrame

local devastateModeBtn = Instance.new("TextButton")
devastateModeBtn.Size = UDim2.new(1, 0, 0, 26)
devastateModeBtn.Position = UDim2.new(0, 0, 0, 0)
devastateModeBtn.BackgroundColor3 = COLORS.buttonSuccess
devastateModeBtn.TextColor3 = COLORS.textLight
devastateModeBtn.Text = "✓ DEVASTATE"
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
orbitalModeBtn.Text = "ORBITAL"
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
chaosModeBtn.Text = "CHAOS"
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

-- SMART FOLLOW SECTION
local smartLabel = Instance.new("TextLabel")
smartLabel.Size = UDim2.new(1, 0, 0, 16)
smartLabel.Position = UDim2.new(0, 0, 0, 0)
smartLabel.BackgroundTransparency = 1
smartLabel.TextColor3 = COLORS.buttonWarning
smartLabel.Text = "⚡ SMART FOLLOW (Moving Targets)"
smartLabel.Font = Enum.Font.GothamBold
smartLabel.TextSize = 10
smartLabel.TextXAlignment = Enum.TextXAlignment.Left
smartLabel.Parent = rightFrame

local predictionToggle = Instance.new("TextButton")
predictionToggle.Size = UDim2.new(1, 0, 0, 24)
predictionToggle.Position = UDim2.new(0, 0, 0, 18)
predictionToggle.BackgroundColor3 = COLORS.buttonSuccess
predictionToggle.TextColor3 = COLORS.textLight
predictionToggle.Text = "✓ Prediction (Aim Ahead)"
predictionToggle.Font = Enum.Font.Gotham
predictionToggle.TextSize = 9
predictionToggle.Parent = rightFrame

local predCorner = Instance.new("UICorner")
predCorner.CornerRadius = UDim.new(0, 5)
predCorner.Parent = predictionToggle

local velocityMatchToggle = Instance.new("TextButton")
velocityMatchToggle.Size = UDim2.new(1, 0, 0, 24)
velocityMatchToggle.Position = UDim2.new(0, 0, 0, 46)
velocityMatchToggle.BackgroundColor3 = COLORS.buttonSuccess
velocityMatchToggle.TextColor3 = COLORS.textLight
velocityMatchToggle.Text = "✓ Velocity Match (Move With Target)"
velocityMatchToggle.Font = Enum.Font.Gotham
velocityMatchToggle.TextSize = 9
velocityMatchToggle.Parent = rightFrame

local velMatchCorner = Instance.new("UICorner")
velMatchCorner.CornerRadius = UDim.new(0, 5)
velMatchCorner.Parent = velocityMatchToggle

-- Prediction Frames
local predFramesRow = Instance.new("Frame")
predFramesRow.Size = UDim2.new(1, 0, 0, 24)
predFramesRow.Position = UDim2.new(0, 0, 0, 74)
predFramesRow.BackgroundTransparency = 1
predFramesRow.Parent = rightFrame

local predFramesLabel = Instance.new("TextLabel")
predFramesLabel.Size = UDim2.new(0, 100, 1, 0)
predFramesLabel.BackgroundTransparency = 1
predFramesLabel.TextColor3 = COLORS.textDark
predFramesLabel.Text = "Predict Frames:"
predFramesLabel.Font = Enum.Font.Gotham
predFramesLabel.TextSize = 9
predFramesLabel.TextXAlignment = Enum.TextXAlignment.Left
predFramesLabel.Parent = predFramesRow

local predFramesInput = Instance.new("TextBox")
predFramesInput.Size = UDim2.new(0, 60, 1, 0)
predFramesInput.Position = UDim2.new(0, 105, 0, 0)
predFramesInput.BackgroundColor3 = COLORS.inputBg
predFramesInput.TextColor3 = COLORS.textDark
predFramesInput.Text = "3"
predFramesInput.Font = Enum.Font.Gotham
predFramesInput.TextSize = 9
predFramesInput.ClearTextOnFocus = false
predFramesInput.Parent = predFramesRow

local predFramesCorner = Instance.new("UICorner")
predFramesCorner.CornerRadius = UDim.new(0, 5)
predFramesCorner.Parent = predFramesInput

-- Power Settings Label
local powerLabel = Instance.new("TextLabel")
powerLabel.Size = UDim2.new(1, 0, 0, 16)
powerLabel.Position = UDim2.new(0, 0, 0, 105)
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
velocityRow.Position = UDim2.new(0, 0, 0, 123)
velocityRow.BackgroundTransparency = 1
velocityRow.Parent = rightFrame

local velocityLabel = Instance.new("TextLabel")
velocityLabel.Size = UDim2.new(0, 100, 1, 0)
velocityLabel.BackgroundTransparency = 1
velocityLabel.TextColor3 = COLORS.textDark
velocityLabel.Text = "Velocity Power:"
velocityLabel.Font = Enum.Font.Gotham
velocityLabel.TextSize = 9
velocityLabel.TextXAlignment = Enum.TextXAlignment.Left
velocityLabel.Parent = velocityRow

local velocityInput = Instance.new("TextBox")
velocityInput.Size = UDim2.new(0, 80, 1, 0)
velocityInput.Position = UDim2.new(0, 105, 0, 0)
velocityInput.BackgroundColor3 = COLORS.inputBg
velocityInput.TextColor3 = COLORS.textDark
velocityInput.Text = "999999"
velocityInput.Font = Enum.Font.Gotham
velocityInput.TextSize = 9
velocityInput.ClearTextOnFocus = false
velocityInput.Parent = velocityRow

local velocityCorner = Instance.new("UICorner")
velocityCorner.CornerRadius = UDim.new(0, 5)
velocityCorner.Parent = velocityInput

-- Angular Power
local angularRow = Instance.new("Frame")
angularRow.Size = UDim2.new(1, 0, 0, 24)
angularRow.Position = UDim2.new(0, 0, 0, 151)
angularRow.BackgroundTransparency = 1
angularRow.Parent = rightFrame

local angularLabel = Instance.new("TextLabel")
angularLabel.Size = UDim2.new(0, 100, 1, 0)
angularLabel.BackgroundTransparency = 1
angularLabel.TextColor3 = COLORS.textDark
angularLabel.Text = "Angular Power:"
angularLabel.Font = Enum.Font.Gotham
angularLabel.TextSize = 9
angularLabel.TextXAlignment = Enum.TextXAlignment.Left
angularLabel.Parent = angularRow

local angularInput = Instance.new("TextBox")
angularInput.Size = UDim2.new(0, 80, 1, 0)
angularInput.Position = UDim2.new(0, 105, 0, 0)
angularInput.BackgroundColor3 = COLORS.inputBg
angularInput.TextColor3 = COLORS.textDark
angularInput.Text = "999999"
angularInput.Font = Enum.Font.Gotham
angularInput.TextSize = 9
angularInput.ClearTextOnFocus = false
angularInput.Parent = angularRow

local angularCorner = Instance.new("UICorner")
angularCorner.CornerRadius = UDim.new(0, 5)
angularCorner.Parent = angularInput

-- Collision Layers Label
local layersLabel = Instance.new("TextLabel")
layersLabel.Size = UDim2.new(1, 0, 0, 16)
layersLabel.Position = UDim2.new(0, 0, 0, 180)
layersLabel.BackgroundTransparency = 1
layersLabel.TextColor3 = COLORS.textDark
layersLabel.Text = "Collision Layers:"
layersLabel.Font = Enum.Font.GothamBold
layersLabel.TextSize = 10
layersLabel.TextXAlignment = Enum.TextXAlignment.Left
layersLabel.Parent = rightFrame

-- Collision Toggles Frame
local layersFrame = Instance.new("Frame")
layersFrame.Size = UDim2.new(1, 0, 0, 100)
layersFrame.Position = UDim2.new(0, 0, 0, 198)
layersFrame.BackgroundTransparency = 1
layersFrame.Parent = rightFrame

local velocityLayerToggle = Instance.new("TextButton")
velocityLayerToggle.Size = UDim2.new(1, 0, 0, 22)
velocityLayerToggle.Position = UDim2.new(0, 0, 0, 0)
velocityLayerToggle.BackgroundColor3 = COLORS.buttonSuccess
velocityLayerToggle.TextColor3 = COLORS.textLight
velocityLayerToggle.Text = "✓ Velocity Burst"
velocityLayerToggle.Font = Enum.Font.Gotham
velocityLayerToggle.TextSize = 9
velocityLayerToggle.Parent = layersFrame

local velLayCorner = Instance.new("UICorner")
velLayCorner.CornerRadius = UDim.new(0, 5)
velLayCorner.Parent = velocityLayerToggle

local angularLayerToggle = Instance.new("TextButton")
angularLayerToggle.Size = UDim2.new(1, 0, 0, 22)
angularLayerToggle.Position = UDim2.new(0, 0, 0, 26)
angularLayerToggle.BackgroundColor3 = COLORS.buttonSuccess
angularLayerToggle.TextColor3 = COLORS.textLight
angularLayerToggle.Text = "✓ Angular Force"
angularLayerToggle.Font = Enum.Font.Gotham
angularLayerToggle.TextSize = 9
angularLayerToggle.Parent = layersFrame

local angLayCorner = Instance.new("UICorner")
angLayCorner.CornerRadius = UDim.new(0, 5)
angLayCorner.Parent = angularLayerToggle

local teleportLayerToggle = Instance.new("TextButton")
teleportLayerToggle.Size = UDim2.new(1, 0, 0, 22)
teleportLayerToggle.Position = UDim2.new(0, 0, 0, 52)
teleportLayerToggle.BackgroundColor3 = COLORS.buttonSuccess
teleportLayerToggle.TextColor3 = COLORS.textLight
teleportLayerToggle.Text = "✓ Rapid Teleport"
teleportLayerToggle.Font = Enum.Font.Gotham
teleportLayerToggle.TextSize = 9
teleportLayerToggle.Parent = layersFrame

local telLayCorner = Instance.new("UICorner")
telLayCorner.CornerRadius = UDim.new(0, 5)
telLayCorner.Parent = teleportLayerToggle

local massLayerToggle = Instance.new("TextButton")
massLayerToggle.Size = UDim2.new(1, 0, 0, 22)
massLayerToggle.Position = UDim2.new(0, 0, 0, 78)
massLayerToggle.BackgroundColor3 = COLORS.buttonSuccess
massLayerToggle.TextColor3 = COLORS.textLight
massLayerToggle.Text = "✓ Mass Boost"
massLayerToggle.Font = Enum.Font.Gotham
massLayerToggle.TextSize = 9
massLayerToggle.Parent = layersFrame

local massLayCorner = Instance.new("UICorner")
massLayCorner.CornerRadius = UDim.new(0, 5)
massLayCorner.Parent = massLayerToggle

-- Info
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 70)
infoLabel.Position = UDim2.new(0, 0, 0, 305)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = COLORS.textMuted
infoLabel.Text = "SMART FOLLOW predicts where\nmoving targets will be and\nmatches their velocity!\nWorks on running players!"
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
    devastateModeBtn.Text = "✓ DEVASTATE"
    devastateModeBtn.BackgroundColor3 = COLORS.buttonSuccess
    devastateModeBtn.TextColor3 = COLORS.textLight
    orbitalModeBtn.Text = "ORBITAL"
    orbitalModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    orbitalModeBtn.TextColor3 = COLORS.textDark
    chaosModeBtn.Text = "CHAOS"
    chaosModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    chaosModeBtn.TextColor3 = COLORS.textDark
end)

orbitalModeBtn.MouseButton1Click:Connect(function()
    collisionMode = "orbital"
    orbitalModeBtn.Text = "✓ ORBITAL"
    orbitalModeBtn.BackgroundColor3 = COLORS.buttonSuccess
    orbitalModeBtn.TextColor3 = COLORS.textLight
    devastateModeBtn.Text = "DEVASTATE"
    devastateModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    devastateModeBtn.TextColor3 = COLORS.textDark
    chaosModeBtn.Text = "CHAOS"
    chaosModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    chaosModeBtn.TextColor3 = COLORS.textDark
end)

chaosModeBtn.MouseButton1Click:Connect(function()
    collisionMode = "chaos"
    chaosModeBtn.Text = "✓ CHAOS"
    chaosModeBtn.BackgroundColor3 = COLORS.buttonSuccess
    chaosModeBtn.TextColor3 = COLORS.textLight
    devastateModeBtn.Text = "DEVASTATE"
    devastateModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    devastateModeBtn.TextColor3 = COLORS.textDark
    orbitalModeBtn.Text = "ORBITAL"
    orbitalModeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    orbitalModeBtn.TextColor3 = COLORS.textDark
end)

-- ========== TOGGLE OPTIONS ==========

predictionToggle.MouseButton1Click:Connect(function()
    predictionEnabled = not predictionEnabled
    predictionToggle.Text = predictionEnabled and "✓ Prediction (Aim Ahead)" or "✗ Prediction (Aim Ahead)"
    predictionToggle.BackgroundColor3 = predictionEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

velocityMatchToggle.MouseButton1Click:Connect(function()
    velocityMatchEnabled = not velocityMatchEnabled
    velocityMatchToggle.Text = velocityMatchEnabled and "✓ Velocity Match (Move With Target)" or "✗ Velocity Match (Move With Target)"
    velocityMatchToggle.BackgroundColor3 = velocityMatchEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

velocityLayerToggle.MouseButton1Click:Connect(function()
    velocityEnabled = not velocityEnabled
    velocityLayerToggle.Text = velocityEnabled and "✓ Velocity Burst" or "✗ Velocity Burst"
    velocityLayerToggle.BackgroundColor3 = velocityEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

angularLayerToggle.MouseButton1Click:Connect(function()
    angularEnabled = not angularEnabled
    angularLayerToggle.Text = angularEnabled and "✓ Angular Force" or "✗ Angular Force"
    angularLayerToggle.BackgroundColor3 = angularEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

teleportLayerToggle.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    teleportLayerToggle.Text = teleportEnabled and "✓ Rapid Teleport" or "✗ Rapid Teleport"
    teleportLayerToggle.BackgroundColor3 = teleportEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

massLayerToggle.MouseButton1Click:Connect(function()
    massEnabled = not massEnabled
    massLayerToggle.Text = massEnabled and "✓ Mass Boost" or "✗ Mass Boost"
    massLayerToggle.BackgroundColor3 = massEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
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

local function getTargetVelocity(targetRoot)
    if not targetRoot then return Vector3.new(0, 0, 0) end
    return targetRoot.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
end

local function predictPosition(targetRoot, frames)
    if not targetRoot then return targetRoot.CFrame end
    
    frames = frames or 3
    
    local velocity = getTargetVelocity(targetRoot)
    local position = targetRoot.Position
    
    -- Predict where target will be
    local predictedPos = position + (velocity * (frames / 60)) -- Convert frames to seconds
    
    return CFrame.new(predictedPos) * targetRoot.Rotation
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
    predictionFrames = tonumber(predFramesInput.Text) or 3
    
    if massEnabled then
        boostMass(player.Character)
    end
    
    -- SMART TELEPORT: Predict position if enabled
    local targetCFrame
    if predictionEnabled then targetCFrame = predictPosition(targetRoot, predictionFrames)
    else
        targetCFrame = targetRoot.CFrame
    end
    
    -- TELEPORT
    if teleportEnabled then
        myRoot.CFrame = targetCFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
    end
    
    -- VELOCITY with matching
    if velocityEnabled then
        local targetVel = Vector3.new(0, 0, 0)
        if velocityMatchEnabled then
            targetVel = getTargetVelocity(targetRoot)
        end
        
        if bodyVel then bodyVel:Destroy() end
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.Name = "CollisionBurst"
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel.Velocity = Vector3.new(
            math.random(-1, 1) * velocityPower + targetVel.X,
            velocityPower + targetVel.Y,
            math.random(-1, 1) * velocityPower + targetVel.Z
        )
        bodyVel.P = math.huge
        bodyVel.Parent = myRoot
    end
    
    -- ANGULAR
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
    predictionFrames = tonumber(predFramesInput.Text) or 3
    
    angle = angle + (math.pi * 2 / 60)
    
    local offsetX = math.cos(angle) * 2
    local offsetZ = math.sin(angle) * 2
    
    if massEnabled then
        boostMass(player.Character)
    end
    
    -- SMART ORBITAL: Predict where target moves
    local targetCFrame
    if predictionEnabled then
        targetCFrame = predictPosition(targetRoot, predictionFrames)
    else
        targetCFrame = targetRoot.CFrame
    end
    
    -- TELEPORT in orbit
    if teleportEnabled then
        myRoot.CFrame = targetCFrame * CFrame.new(offsetX, 1, offsetZ)
    end
    
    -- VELOCITY toward target with matching
    if velocityEnabled then
        local direction = (targetRoot.Position - myRoot.Position).Unit
        local targetVel = Vector3.new(0, 0, 0)
        
        if velocityMatchEnabled then
            targetVel = getTargetVelocity(targetRoot)
        end
        
        if bodyVel then bodyVel:Destroy() end
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.Name = "CollisionBurst"
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel.Velocity = direction * velocityPower + targetVel
        bodyVel.P = math.huge
        bodyVel.Parent = myRoot
    end
    
    -- ANGULAR
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
    predictionFrames = tonumber(predFramesInput.Text) or 3
    
    if massEnabled then
        boostMass(player.Character)
    end
    
    -- SMART CHAOS: Predict random position
    local targetCFrame
    if predictionEnabled then
        targetCFrame = predictPosition(targetRoot, predictionFrames)
    else
        targetCFrame = targetRoot.CFrame
    end
    
    -- TELEPORT randomly
    if teleportEnabled then
        myRoot.CFrame = targetCFrame * CFrame.new(
            math.random(-3, 3),
            math.random(-2, 2),
            math.random(-3, 3)
        )
    end
    
    -- VELOCITY with matching
    if velocityEnabled then
        local targetVel = Vector3.new(0, 0, 0)
        
        if velocityMatchEnabled then
            targetVel = getTargetVelocity(targetRoot)
        end
        
        if bodyVel then bodyVel:Destroy() end
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.Name = "CollisionBurst"
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel.Velocity = Vector3.new(
            math.random(-1, 1) * velocityPower + targetVel.X,
            math.random(-1, 1) * velocityPower + targetVel.Y,
            math.random(-1, 1) * velocityPower + targetVel.Z
        )
        bodyVel.P = math.huge
        bodyVel.Parent = myRoot
    end
    
    -- ANGULAR
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

print("✅ SMART Collision Fling Loaded")
print("   Works on MOVING targets!")
print("   Prediction + Velocity Matching")
print("   3 Modes: DEVASTATE, ORBITAL, CHAOS")
print("   4 Layers: Velocity + Angular + Teleport + Mass")
