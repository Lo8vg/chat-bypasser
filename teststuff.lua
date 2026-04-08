-- Custom Chat GUI (TALL + Spam Cycle Messages + Follow-Up Tab)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local MAX_CHARS = 200
local spamEnabled = false
local spamDelay = 1
local messagesExpanded = false
local spamIndex = 1

-- Follow-Up Settings
local followUpEnabled = false
local followUpMessage = ""
local followUpDelay = 0.5

-- Premade messages list
local premadeMessages = {
    "Hello",
    "GG",
    "What's up",
    "Bye"
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomChatGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Name = "ChatFrame"
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(0.5, -100, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(60, 60, 60)
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

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
titleLabel.Size = UDim2.new(1, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "💬 Chat"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Char Counter
local charCounter = Instance.new("TextLabel")
charCounter.Size = UDim2.new(0, 40, 1, 0)
charCounter.Position = UDim2.new(1, -45, 0, 0)
charCounter.BackgroundTransparency = 1
charCounter.TextColor3 = Color3.fromRGB(150, 150, 150)
charCounter.Text = "0/200"
charCounter.Font = Enum.Font.Gotham
charCounter.TextSize = 10
charCounter.Parent = titleBar

-- Textbox
local textbox = Instance.new("TextBox")
textbox.Name = "ChatInput"
textbox.Size = UDim2.new(1, -20, 0, 70)
textbox.Position = UDim2.new(0, 10, 0, 35)
textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox.Text = ""
textbox.PlaceholderText = "Message..."
textbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
textbox.Font = Enum.Font.Gotham
textbox.TextSize = 16
textbox.TextXAlignment = Enum.TextXAlignment.Left
textbox.TextYAlignment = Enum.TextYAlignment.Top
textbox.ClearTextOnFocus = false
textbox.ReturnKeyType = Enum.ReturnKeyType.Send
textbox.MultiLine = true
textbox.TextWrapped = true
textbox.Parent = frame

local textboxCorner = Instance.new("UICorner")
textboxCorner.CornerRadius = UDim.new(0, 6)
textboxCorner.Parent = textbox

-- Bottom Row
local bottomRow = Instance.new("Frame")
bottomRow.Size = UDim2.new(1, -20, 0, 32)
bottomRow.Position = UDim2.new(0, 10, 0, 115)
bottomRow.BackgroundTransparency = 1
bottomRow.Parent = frame

-- Send Button
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0, 55, 0, 32)
sendButton.Position = UDim2.new(0, 0, 0, 0)
sendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Text = "Send"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 12
sendButton.Parent = bottomRow

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 6)
sendCorner.Parent = sendButton

-- Delay Textbox
local delayTextbox = Instance.new("TextBox")
delayTextbox.Size = UDim2.new(0, 35, 0, 32)
delayTextbox.Position = UDim2.new(0, 60, 0, 0)
delayTextbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayTextbox.Text = "1"
delayTextbox.PlaceholderText = "1"
delayTextbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
delayTextbox.Font = Enum.Font.Gotham
delayTextbox.TextSize = 12
delayTextbox.ClearTextOnFocus = false
delayTextbox.Parent = bottomRow

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 6)
delayCorner.Parent = delayTextbox

-- Delay Label
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 35, 0, 32)
delayLabel.Position = UDim2.new(0, 98, 0, 0)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
delayLabel.Text = "sec"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 10
delayLabel.Parent = bottomRow

-- Spam Button
local spamButton = Instance.new("TextButton")
spamButton.Size = UDim2.new(0, 75, 0, 32)
spamButton.Position = UDim2.new(1, -75, 0, 0)
spamButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
spamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spamButton.Text = "SPAM: OFF"
spamButton.Font = Enum.Font.GothamBold
spamButton.TextSize = 10
spamButton.Parent = bottomRow

local spamCorner = Instance.new("UICorner")
spamCorner.CornerRadius = UDim.new(0, 6)
spamCorner.Parent = spamButton

-- Tab Buttons Row
local tabRow = Instance.new("Frame")
tabRow.Size = UDim2.new(1, -20, 0, 24)
tabRow.Position = UDim2.new(0, 10, 0, 152)
tabRow.BackgroundTransparency = 1
tabRow.Parent = frame

-- Messages Tab Button
local messagesTab = Instance.new("TextButton")
messagesTab.Size = UDim2.new(0.5, -2, 0, 24)
messagesTab.Position = UDim2.new(0, 0, 0, 0)
messagesTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
messagesTab.TextColor3 = Color3.fromRGB(255, 255, 255)
messagesTab.Text = "▼ Messages"
messagesTab.Font = Enum.Font.GothamBold
messagesTab.TextSize = 11
messagesTab.Parent = tabRow

local messagesTabCorner = Instance.new("UICorner")
messagesTabCorner.CornerRadius = UDim.new(0, 6)
messagesTabCorner.Parent = messagesTab

-- Follow-Up Tab Button
local followUpTab = Instance.new("TextButton")
followUpTab.Size = UDim2.new(0.5, -2, 0, 24)
followUpTab.Position = UDim2.new(0.5, 2, 0, 0)
followUpTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
followUpTab.TextColor3 = Color3.fromRGB(200, 200, 200)
followUpTab.Text = "Follow-Up"
followUpTab.Font = Enum.Font.GothamBold
followUpTab.TextSize = 11
followUpTab.Parent = tabRow

local followUpTabCorner = Instance.new("UICorner")
followUpTabCorner.CornerRadius = UDim.new(0, 6)
followUpTabCorner.Parent = followUpTab

-- Messages Panel (hidden by default)
local messagesPanel = Instance.new("Frame")
messagesPanel.Size = UDim2.new(1, -20, 0, 120)
messagesPanel.Position = UDim2.new(0, 10, 0, 180)
messagesPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
messagesPanel.Visible = false
messagesPanel.Parent = frame

local messagesPanelCorner = Instance.new("UICorner")
messagesPanelCorner.CornerRadius = UDim.new(0, 6)
messagesPanelCorner.Parent = messagesPanel

-- Messages ScrollingFrame
local messagesScroll = Instance.new("ScrollingFrame")
messagesScroll.Size = UDim2.new(1, -10, 1, -35)
messagesScroll.Position = UDim2.new(0, 5, 0, 5)
messagesScroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
messagesScroll.ScrollBarThickness = 4
messagesScroll.Parent = messagesPanel

local messagesScrollCorner = Instance.new("UICorner")
messagesScrollCorner.CornerRadius = UDim.new(0, 4)
messagesScrollCorner.Parent = messagesScroll

local messagesLayout = Instance.new("UIListLayout")
messagesLayout.Padding = UDim.new(0, 4)
messagesLayout.Parent = messagesScroll

-- Add Message Button
local addMsgButton = Instance.new("TextButton")
addMsgButton.Size = UDim2.new(1, -10, 0, 24)
addMsgButton.Position = UDim2.new(0, 5, 1, -29)
addMsgButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
addMsgButton.TextColor3 = Color3.fromRGB(255, 255, 255)
addMsgButton.Text = "+ Add Current Message"
addMsgButton.Font = Enum.Font.GothamBold
addMsgButton.TextSize = 11
addMsgButton.Parent = messagesPanel

local addMsgCorner = Instance.new("UICorner")
addMsgCorner.CornerRadius = UDim.new(0, 6)
addMsgCorner.Parent = addMsgButton

-- Follow-Up Panel (hidden by default)
local followUpPanel = Instance.new("Frame")
followUpPanel.Size = UDim2.new(1, -20, 0, 120)
followUpPanel.Position = UDim2.new(0, 10, 0, 180)
followUpPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
followUpPanel.Visible = false
followUpPanel.Parent = frame

local followUpPanelCorner = Instance.new("UICorner")
followUpPanelCorner.CornerRadius = UDim.new(0, 6)
followUpPanelCorner.Parent = followUpPanel

-- Follow-Up Toggle
local followUpToggle = Instance.new("TextButton")
followUpToggle.Size = UDim2.new(1, -10, 0, 28)
followUpToggle.Position = UDim2.new(0, 5, 0, 5)
followUpToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
followUpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
followUpToggle.Text = "FOLLOW-UP: OFF"
followUpToggle.Font = Enum.Font.GothamBold
followUpToggle.TextSize = 12
followUpToggle.Parent = followUpPanel

local followUpToggleCorner = Instance.new("UICorner")
followUpToggleCorner.CornerRadius = UDim.new(0, 6)
followUpToggleCorner.Parent = followUpToggle

-- Follow-Up Message Input Label
local followUpLabel = Instance.new("TextLabel")
followUpLabel.Size = UDim2.new(1, -10, 0, 16)
followUpLabel.Position = UDim2.new(0, 5, 0, 38)
followUpLabel.BackgroundTransparency = 1
followUpLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
followUpLabel.Text = "Follow-Up Message:"
followUpLabel.Font = Enum.Font.Gotham
followUpLabel.TextSize = 10
followUpLabel.TextXAlignment = Enum.TextXAlignment.Left
followUpLabel.Parent = followUpPanel

-- Follow-Up Message Input
local followUpInput = Instance.new("TextBox")
followUpInput.Size = UDim2.new(1, -10, 0, 32)
followUpInput.Position = UDim2.new(0, 5, 0, 56)
followUpInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
followUpInput.TextColor3 = Color3.fromRGB(255, 255, 255)
followUpInput.Text = ""
followUpInput.PlaceholderText = "Message to send after..."
followUpInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
followUpInput.Font = Enum.Font.Gotham
followUpInput.TextSize = 12
followUpInput.ClearTextOnFocus = false
followUpInput.Parent = followUpPanel

local followUpInputCorner = Instance.new("UICorner")
followUpInputCorner.CornerRadius = UDim.new(0, 6)
followUpInputCorner.Parent = followUpInput

-- Follow-Up Delay Row
local followUpDelayRow = Instance.new("Frame")
followUpDelayRow.Size = UDim2.new(1, -10, 0, 24)
followUpDelayRow.Position = UDim2.new(0, 5, 0, 92)
followUpDelayRow.BackgroundTransparency = 1
followUpDelayRow.Parent = followUpPanel

local followUpDelayLabel = Instance.new("TextLabel")
followUpDelayLabel.Size = UDim2.new(0, 60, 0, 24)
followUpDelayLabel.BackgroundTransparency = 1
followUpDelayLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
followUpDelayLabel.Text = "Delay:"
followUpDelayLabel.Font = Enum.Font.Gotham
followUpDelayLabel.TextSize = 10
followUpDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
followUpDelayLabel.Parent = followUpDelayRow

local followUpDelayInput = Instance.new("TextBox")
followUpDelayInput.Size = UDim2.new(0, 50, 0, 24)
followUpDelayInput.Position = UDim2.new(0, 60, 0, 0)
followUpDelayInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
followUpDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
followUpDelayInput.Text = "0.5"
followUpDelayInput.Font = Enum.Font.Gotham
followUpDelayInput.TextSize = 11
followUpDelayInput.ClearTextOnFocus = false
followUpDelayInput.Parent = followUpDelayRow

local followUpDelayCorner = Instance.new("UICorner")
followUpDelayCorner.CornerRadius = UDim.new(0, 4)
followUpDelayCorner.Parent = followUpDelayInput

local followUpDelaySec = Instance.new("TextLabel")
followUpDelaySec.Size = UDim2.new(0, 30, 0, 24)
followUpDelaySec.Position = UDim2.new(0, 112, 0, 0)
followUpDelaySec.BackgroundTransparency = 1
followUpDelaySec.TextColor3 = Color3.fromRGB(150, 150, 150)
followUpDelaySec.Text = "sec"
followUpDelaySec.Font = Enum.Font.Gotham
followUpDelaySec.TextSize = 10
followUpDelaySec.Parent = followUpDelayRow

-- Dragging
local dragging = false
local dragInput
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Character limit
textbox:GetPropertyChangedSignal("Text
