-- COMBO DESTROYER: FLING + SWORD AUTO ATTACK
-- Fling for stationary, Sword for moving = NO ESCAPE

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local destroyEnabled = false
local targetPlayer = nil
local flingCount = 0

-- Power Settings
local velocityPower = 999999
local angularPower = 999999
local collisionMode = "devastate"

-- Sword Settings
local swordSwings = 3
local swingDelay = 0.01
local swordReach = 15

-- Toggle states
local velocityEnabled = true
local angularEnabled = true
local teleportEnabled = true
local massEnabled = true
local swordEnabled = true

-- Loops
local flingLoop = nil

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
screenGui.Name = "ComboDestroyer"
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
mainFrame.Size = UDim2.new(0, 750, 0, 380)
mainFrame.Position = UDim2.new(0.5, -375, 0.5, -190)
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
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = COLORS.textDark
titleLabel.Text = "💀 COMBO DESTROYER (Fling + Sword)"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 28, 0, 22)
collapseButton.Position = UDim2.new(1, -65, 0.5, -11)
collapseButton.BackgroundColor3 = COLORS.buttonDanger
collapseButton.TextColor3 = COLORS.textLight
collapseButton.Text = "✕"
collapseButton.Font = Enum.Font.GothamBold
collapseButton.TextSize = 11
collapseButton.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseButton

local killButton = Instance.new("TextButton")
killButton.Size = UDim2.new(0, 28, 0, 22)
killButton.Position = UDim2.new(1, -32, 0.5, -11)
killButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
killButton.TextColor3 = COLORS.textLight
killButton.Text = "☠"
killButton.Font = Enum.Font.GothamBold
killButton.TextSize = 11
killButton.Parent = titleBar

local killCorner = Instance.new("UICorner")
killCorner.CornerRadius = UDim.new(0, 6)
killCorner.Parent = killButton

-- ========== LEFT FRAME ==========

local leftFrame = Instance.new("Frame")
leftFrame.Size = UDim2.new(0.33, -10, 1, -50)
leftFrame.Position = UDim2.new(0, 10, 0, 40)
leftFrame.BackgroundTransparency = 1
leftFrame.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 0, 40)
toggleButton.Position = UDim2.new(0, 0, 0, 0)
toggleButton.BackgroundColor3 = COLORS.buttonDanger
toggleButton.TextColor3 = COLORS.textLight
toggleButton.Text = "DESTROY: OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.Parent = leftFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Kill Counter
local killCounter = Instance.new("TextLabel")
killCounter.Size = UDim2.new(1, 0, 0, 18)
killCounter.Position = UDim2.new(0, 0, 0, 45)
killCounter.BackgroundTransparency = 1
killCounter.TextColor3 = COLORS.buttonSuccess
killCounter.Text = "Attacks: 0"
killCounter.Font = Enum.Font.GothamBold
killCounter.TextSize = 11
killCounter.Parent = leftFrame

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
statusLabel.Size = UDim2.new(1, 0, 0, 18)
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
modeLabel.Position = UDim2.new(0, 0, 0, 212)
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
modesFrame.Position = UDim2.new(0, 0, 0, 230)
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

-- ========== MIDDLE FRAME ==========

local middleFrame = Instance.new("Frame")
middleFrame.Size = UDim2.new(0.33, -10, 1, -50)
middleFrame.Position = UDim2.new(0.33, 5, 0, 40)
middleFrame.BackgroundTransparency = 1
middleFrame.Parent = mainFrame

-- SWORD SECTION
local swordSectionLabel = Instance.new("TextLabel")
swordSectionLabel.Size = UDim2.new(1, 0, 0, 16)
swordSectionLabel.Position = UDim2.new(0, 0, 0, 0)
swordSectionLabel.BackgroundTransparency = 1
swordSectionLabel.TextColor3 = COLORS.buttonPrimary
swordSectionLabel.Text = "⚔️ SWORD SETTINGS"
swordSectionLabel.Font = Enum.Font.GothamBold
swordSectionLabel.TextSize = 10
swordSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
swordSectionLabel.Parent = middleFrame

-- Sword Toggle
local swordToggle = Instance.new("TextButton")
swordToggle.Size = UDim2.new(1, 0, 0, 24)
swordToggle.Position = UDim2.new(0, 0, 0, 18)
swordToggle.BackgroundColor3 = COLORS.buttonSuccess
swordToggle.TextColor3 = COLORS.textLight
swordToggle.Text = "✓ Auto Sword Attack"
swordToggle.Font = Enum.Font.Gotham
swordToggle.TextSize = 9
swordToggle.Parent = middleFrame

local swordTogCorner = Instance.new("UICorner")
swordTogCorner.CornerRadius = UDim.new(0, 5)
swordTogCorner.Parent = swordToggle

-- Swings Per Attack
local swingsRow = Instance.new("Frame")
swingsRow.Size = UDim2.new(1, 0, 0, 24)
swingsRow.Position = UDim2.new(0, 0, 0, 46)
swingsRow.BackgroundTransparency = 1
swingsRow.Parent = middleFrame

local swingsLabel = Instance.new("TextLabel")
swingsLabel.Size = UDim2.new(0, 100, 1, 0)
swingsLabel.BackgroundTransparency = 1
swingsLabel.TextColor3 = COLORS.textDark
swingsLabel.Text = "Swings/Attack:"
swingsLabel.Font = Enum.Font.Gotham
swingsLabel.TextSize = 9
swingsLabel.TextXAlignment = Enum.TextXAlignment.Left
swingsLabel.Parent = swingsRow

local swingsInput = Instance.new("TextBox")
swingsInput.Size = UDim2.new(0, 60, 1, 0)
swingsInput.Position = UDim2.new(0, 105, 0, 0)
swingsInput.BackgroundColor3 = COLORS.inputBg
swingsInput.TextColor3 = COLORS.textDark
swingsInput.Text = "3"
swingsInput.Font = Enum.Font.Gotham
swingsInput.TextSize = 9
swingsInput.ClearTextOnFocus = false
swingsInput.Parent = swingsRow

local swingsCorner = Instance.new("UICorner")
swingsCorner.CornerRadius = UDim.new(0, 5)
swingsCorner.Parent = swingsInput

local swingsStroke = Instance.new("UIStroke")
swingsStroke.Color = COLORS.border
swingsStroke.Thickness = 1
swingsStroke.Parent = swingsInput

-- Reach Distance
local reachRow = Instance.new("Frame")
reachRow.Size = UDim2.new(1, 0, 0, 24)
reachRow.Position = UDim2.new(0, 0, 0, 72)
reachRow.BackgroundTransparency = 1
reachRow.Parent = middleFrame

local reachLabel = Instance.new("TextLabel")
reachLabel.Size = UDim2.new(0, 100, 1, 0)
reachLabel.BackgroundTransparency = 1
reachLabel.TextColor3 = COLORS.textDark
reachLabel.Text = "Reach Distance:"
reachLabel.Font = Enum.Font.Gotham
reachLabel.TextSize = 9
reachLabel.TextXAlignment = Enum.TextXAlignment.Left
reachLabel.Parent = reachRow

local reachInput = Instance.new("TextBox")
reachInput.Size = UDim2.new(0, 60, 1, 0)
reachInput.Position = UDim2.new(0, 105, 0, 0)
reachInput.BackgroundColor3 = COLORS.inputBg
reachInput.TextColor3 = COLORS.textDark
reachInput.Text = "15"
reachInput.Font = Enum.Font.Gotham
reachInput.TextSize = 9
reachInput.ClearTextOnFocus = false
reachInput.Parent = reachRow

local reachCorner = Instance.new("UICorner")
reachCorner.CornerRadius = UDim.new(0, 5)
reachCorner.Parent = reachInput

local reachStroke = Instance.new("UIStroke")
reachStroke.Color = COLORS.border
reachStroke.Thickness = 1
reachStroke.Parent = reachInput

-- FLING SECTION
local flingSectionLabel = Instance.new("TextLabel")
flingSectionLabel.Size = UDim2.new(1, 0, 0, 16)
flingSectionLabel.Position = UDim2.new(0, 0, 0, 100)
flingSectionLabel.BackgroundTransparency = 1
flingSectionLabel.TextColor3 = COLORS.buttonDanger
flingSectionLabel.Text = "💥 FLING SETTINGS"
flingSectionLabel.Font = Enum.Font.GothamBold
flingSectionLabel.TextSize = 10
flingSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
flingSectionLabel.Parent = middleFrame

-- Velocity Power
local velocityRow = Instance.new("Frame")
velocityRow.Size = UDim2.new(1, 0, 0, 24)
velocityRow.Position = UDim2.new(0, 0, 0, 118)
velocityRow.BackgroundTransparency = 1
velocityRow.Parent = middleFrame

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

local velocityStroke = Instance.new("UIStroke")
velocityStroke.Color = COLORS.border
velocityStroke.Thickness = 1
velocityStroke.Parent = velocityInput

-- Angular Power
local angularRow = Instance.new("Frame")
angularRow.Size = UDim2.new(1, 0, 0, 24)
angularRow.Position = UDim2.new(0, 0, 0, 144)
angularRow.BackgroundTransparency = 1
angularRow.Parent = middleFrame

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

local angularStroke = Instance.new("UIStroke")
angularStroke.Color = COLORS.border
angularStroke.Thickness = 1
angularStroke.Parent = angularInput

-- ========== RIGHT FRAME ==========

local rightFrame = Instance.new("Frame")
rightFrame.Size = UDim2.new(0.3, -10, 1, -50)
rightFrame.Position = UDim2.new(0.66, 5, 0, 40)
rightFrame.BackgroundTransparency = 1
rightFrame.Parent = mainFrame

-- FLING TOGGLES
local flingTogglesLabel = Instance.new("TextLabel")
flingTogglesLabel.Size = UDim2.new(1, 0, 0, 16)
flingTogglesLabel.Position = UDim2.new(0, 0, 0, 0)
flingTogglesLabel.BackgroundTransparency = 1
flingTogglesLabel.TextColor3 = COLORS.textDark
flingTogglesLabel.Text = "Fling Layers:"
flingTogglesLabel.Font = Enum.Font.GothamBold
flingTogglesLabel.TextSize = 10
flingTogglesLabel.TextXAlignment = Enum.TextXAlignment.Left
flingTogglesLabel.Parent = rightFrame

-- Velocity Toggle
local velocityToggle = Instance.new("TextButton")
velocityToggle.Size = UDim2.new(1, 0, 0, 22)
velocityToggle.Position = UDim2.new(0, 0, 0, 20)
velocityToggle.BackgroundColor3 = COLORS.buttonSuccess
velocityToggle.TextColor3 = COLORS.textLight
velocityToggle.Text = "✓ Velocity Burst"
velocityToggle.Font = Enum.Font.Gotham
velocityToggle.TextSize = 9
velocityToggle.Parent = rightFrame

local velocityTogCorner = Instance.new("UICorner")
velocityTogCorner.CornerRadius = UDim.new(0, 5)
velocityTogCorner.Parent = velocityToggle

-- Angular Toggle
local angularToggle = Instance.new("TextButton")
angularToggle.Size = UDim2.new(1, 0, 0, 22)
angularToggle.Position = UDim2.new(0, 0, 0, 46)
angularToggle.BackgroundColor3 = COLORS.buttonSuccess
angularToggle.TextColor3 = COLORS.textLight
angularToggle.Text = "✓ Angular Force"
angularToggle.Font = Enum.Font.Gotham
angularToggle.TextSize = 9
angularToggle.Parent = rightFrame

local angularTogCorner = Instance.new("UICorner")
angularTogCorner.CornerRadius = UDim.new(0, 5)
angularTogCorner.Parent = angularToggle

-- Teleport Toggle
local teleportToggle = Instance.new("TextButton")
teleportToggle.Size = UDim2.new(1, 0, 0, 22)
teleportToggle.Position = UDim2.new(0, 0, 0, 72)
teleportToggle.BackgroundColor3 = COLORS.buttonSuccess
teleportToggle.TextColor3 = COLORS.textLight
teleportToggle.Text = "✓ Rapid Teleport"
teleportToggle.Font = Enum.Font.Gotham
teleportToggle.TextSize = 9
teleportToggle.Parent = rightFrame

local teleportTogCorner = Instance.new("UICorner")
teleportTogCorner.CornerRadius = UDim.new(0, 5)
teleportTogCorner.Parent = teleportToggle

-- Mass Toggle
local massToggle = Instance.new("TextButton")
massToggle.Size = UDim2.new(1, 0, 0, 22)
massToggle.Position = UDim2.new(0, 0, 0, 98)
massToggle.BackgroundColor3 = COLORS.buttonSuccess
massToggle.TextColor3 = COLORS.textLight
massToggle.Text = "✓ Mass Boost"
massToggle.Font = Enum.Font.Gotham
massToggle.TextSize = 9
massToggle.Parent = rightFrame

local massTogCorner = Instance.new("UICorner")
massTogCorner.CornerRadius = UDim.new(0, 5)
massTogCorner.Parent = massToggle

-- Info
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 50)
infoLabel.Position = UDim2.new(0, 0, 0, 130)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = COLORS.textMuted
infoLabel.Text = "ONE toggle = BOTH attacks\nFling + Sword together\nNo escape for target"
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

-- ========== KILL BUTTON ==========

killButton.MouseButton1Click:Connect(function()
    destroyEnabled = false
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
    
    screenGui:Destroy()
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

swordToggle.MouseButton1Click:Connect(function()
    swordEnabled = not swordEnabled
    swordToggle.Text = swordEnabled and "✓ Auto Sword Attack" or "✗ Auto Sword Attack"
    swordToggle.BackgroundColor3 = swordEnabled and COLORS.buttonSuccess or COLORS.buttonDanger
end)

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

-- ========== HELPER FUNCTIONS ==========

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

-- ========== FLING FUNCTIONS ==========

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
    
    angle = angle + (math.pi * 2 / 500)
    
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

-- ========== SWORD ATTACK FUNCTION ==========

local function swordAttack(targetRoot, myRoot)
    if not swordEnabled then return end
    
    swordReach = tonumber(reachInput.Text) or 15
    swordSwings = tonumber(swingsInput.Text) or 3
    
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

-- ========== STOP FUNCTION ==========

local function stopAll()
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

-- ========== START FUNCTION ==========

local function startDestroy()
    if flingLoop then
        flingLoop:Disconnect()
    end
    
    flingLoop = RunService.Heartbeat:Connect(function()
        if not destroyEnabled then return end
        
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
        
        -- Run fling
        if collisionMode == "devastate" then
            devastateFling(targetRoot, myRoot, myHumanoid)
        elseif collisionMode == "orbital" then
            orbitalFling(targetRoot, myRoot, myHumanoid)
        else
            chaosFling(targetRoot, myRoot, myHumanoid)
        end
        
        -- Run sword attack (both run together!)
        swordAttack(targetRoot, myRoot)
    end)
end

-- ========== MAIN TOGGLE ==========

toggleButton.MouseButton1Click:Connect(function()
    destroyEnabled = not destroyEnabled
    
    if destroyEnabled then
        if not targetPlayer then
            statusLabel.Text = "Select a target first!"
            destroyEnabled = false
            return
        end
        
        toggleButton.Text = "DESTROY: ON"
        toggleButton.BackgroundColor3 = COLORS.buttonSuccess
        statusLabel.Text = "Destroying: " .. targetPlayer.Name .. " (" .. collisionMode:upper() .. ")"
        
        -- Equip sword immediately
        equipSword()
        
        -- Start both attacks
        startDestroy()
    else
        toggleButton.Text = "DESTROY: OFF"
        toggleButton.BackgroundColor3 = COLORS.buttonDanger
        statusLabel.Text = targetPlayer and ("Target: " .. targetPlayer.Name) or "No target selected"
        
        stopAll()
    end
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

player.CharacterAdded:Connect(function(char)
    wait(0.3)
    
    if destroyEnabled then
        flingCount = flingCount + 1
        killCounter.Text = "Attacks: " .. flingCount
        
        -- Re-equip sword
        equipSword()
        
        -- Restart attacks
        startDestroy()
    end
end)

-- Cleanup on character removal
player.CharacterRemoving:Connect(function()
    stopAll()
end)

print("✅ COMBO DESTROYER Loaded")
print("   Fling + Sword working together")
print("   One toggle = Both attacks")
print("   Stationary target = Fling destroys")
print("   Moving target = Sword hits")
print("   NO ESCAPE")
