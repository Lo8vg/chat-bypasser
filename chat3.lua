-- Custom Chat GUI (TALL + Spam Cycle Messages + Prefix + Settings Tabs)

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

-- Prefix Settings
local prefixEnabled = false
local prefixMode = "fixed" -- "fixed" or "rotate"
local prefixRotateIndex = 1
local currentPrefix = ""

-- Text Settings
local autoCapsEnabled = false
local autoLowerEnabled = false

-- Premade messages list
local premadeMessages = {
    "Hello",
    "GG",
    "What's up",
    "Bye"
}

-- Prefix emojis list
local prefixEmojis = {"😊", "😂", "🔥", "💯", "👀", "😈", "🎮", "⚡"}

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

-- ========== TAB BAR (4 tabs) ==========
local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, 0, 0, 28)
tabBar.Position = UDim2.new(0, 0, 0, 28)
tabBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabBar.BorderSizePixel = 0
tabBar.Parent = frame

local tab1Btn = Instance.new("TextButton")
tab1Btn.Size = UDim2.new(0.25, -1, 1, 0)
tab1Btn.Position = UDim2.new(0, 0, 0, 0)
tab1Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
tab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
tab1Btn.Text = "Chat"
tab1Btn.Font = Enum.Font.GothamBold
tab1Btn.TextSize = 10
tab1Btn.Parent = tabBar

local tab1Corner = Instance.new("UICorner")
tab1Corner.CornerRadius = UDim.new(0, 6)
tab1Corner.Parent = tab1Btn

local tab2Btn = Instance.new("TextButton")
tab2Btn.Size = UDim2.new(0.25, -1, 1, 0)
tab2Btn.Position = UDim2.new(0.25, 1, 0, 0)
tab2Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tab2Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
tab2Btn.Text = "Multi"
tab2Btn.Font = Enum.Font.GothamBold
tab2Btn.TextSize = 10
tab2Btn.Parent = tabBar

local tab2Corner = Instance.new("UICorner")
tab2Corner.CornerRadius = UDim.new(0, 6)
tab2Corner.Parent = tab2Btn

local tab3Btn = Instance.new("TextButton")
tab3Btn.Size = UDim2.new(0.25, -1, 1, 0)
tab3Btn.Position = UDim2.new(0.5, 2, 0, 0)
tab3Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tab3Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
tab3Btn.Text = "Prefix"
tab3Btn.Font = Enum.Font.GothamBold
tab3Btn.TextSize = 10
tab3Btn.Parent = tabBar

local tab3Corner = Instance.new("UICorner")
tab3Corner.CornerRadius = UDim.new(0, 6)
tab3Corner.Parent = tab3Btn

local tab4Btn = Instance.new("TextButton")
tab4Btn.Size = UDim2.new(0.25, -1, 1, 0)
tab4Btn.Position = UDim2.new(0.75, 3, 0, 0)
tab4Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tab4Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
tab4Btn.Text = "Settings"
tab4Btn.Font = Enum.Font.GothamBold
tab4Btn.TextSize = 10
tab4Btn.Parent = tabBar

local tab4Corner = Instance.new("UICorner")
tab4Corner.CornerRadius = UDim.new(0, 6)
tab4Corner.Parent = tab4Btn

-- ========== TAB 1: CHAT (Original Content) ==========
local tab1Content = Instance.new("Frame")
tab1Content.Name = "Tab1Content"
tab1Content.Size = UDim2.new(1, 0, 1, -56)
tab1Content.Position = UDim2.new(0, 0, 0, 56)
tab1Content.BackgroundTransparency = 1
tab1Content.Parent = frame

-- Textbox
local textbox = Instance.new("TextBox")
textbox.Name = "ChatInput"
textbox.Size = UDim2.new(1, -20, 0, 70)
textbox.Position = UDim2.new(0, 10, 0, 0)
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
textbox.Parent = tab1Content

local textboxCorner = Instance.new("UICorner")
textboxCorner.CornerRadius = UDim.new(0, 6)
textboxCorner.Parent = textbox

-- Bottom Row
local bottomRow = Instance.new("Frame")
bottomRow.Size = UDim2.new(1, -20, 0, 32)
bottomRow.Position = UDim2.new(0, 10, 0, 80)
bottomRow.BackgroundTransparency = 1
bottomRow.Parent = tab1Content

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

-- Messages Toggle Button
local messagesToggle = Instance.new("TextButton")
messagesToggle.Size = UDim2.new(1, -20, 0, 24)
messagesToggle.Position = UDim2.new(0, 10, 0, 117)
messagesToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
messagesToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
messagesToggle.Text = "▼ Messages"
messagesToggle.Font = Enum.Font.GothamBold
messagesToggle.TextSize = 11
messagesToggle.Parent = tab1Content

local messagesToggleCorner = Instance.new("UICorner")
messagesToggleCorner.CornerRadius = UDim.new(0, 6)
messagesToggleCorner.Parent = messagesToggle

-- Messages Panel (hidden by default)
local messagesPanel = Instance.new("Frame")
messagesPanel.Size = UDim2.new(1, -20, 0, 120)
messagesPanel.Position = UDim2.new(0, 10, 0, 145)
messagesPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
messagesPanel.Visible = false
messagesPanel.Parent = tab1Content

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

-- ========== TAB 2: MULTI (Second Textbox) ==========
local tab2Content = Instance.new("Frame")
tab2Content.Name = "Tab2Content"
tab2Content.Size = UDim2.new(1, 0, 1, -56)
tab2Content.Position = UDim2.new(0, 0, 0, 56)
tab2Content.BackgroundTransparency = 1
tab2Content.Visible = false
tab2Content.Parent = frame

-- Second Textbox Label
local textbox2Label = Instance.new("TextLabel")
textbox2Label.Size = UDim2.new(1, -20, 0, 20)
textbox2Label.Position = UDim2.new(0, 10, 0, 5)
textbox2Label.BackgroundTransparency = 1
textbox2Label.TextColor3 = Color3.fromRGB(150, 150, 150)
textbox2Label.Text = "Multi-line messages (one per line)"
textbox2Label.Font = Enum.Font.Gotham
textbox2Label.TextSize = 10
textbox2Label.TextXAlignment = Enum.TextXAlignment.Left
textbox2Label.Parent = tab2Content

-- Second Textbox
local textbox2 = Instance.new("TextBox")
textbox2.Name = "MultiInput"
textbox2.Size = UDim2.new(1, -20, 0, 90)
textbox2.Position = UDim2.new(0, 10, 0, 28)
textbox2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textbox2.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox2.Text = ""
textbox2.PlaceholderText = "Message 1\nMessage 2\nMessage 3"
textbox2.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
textbox2.Font = Enum.Font.Gotham
textbox2.TextSize = 14
textbox2.TextXAlignment = Enum.TextXAlignment.Left
textbox2.TextYAlignment = Enum.TextYAlignment.Top
textbox2.ClearTextOnFocus = false
textbox2.MultiLine = true
textbox2.TextWrapped = true
textbox2.Parent = tab2Content

local textbox2Corner = Instance.new("UICorner")
textbox2Corner.CornerRadius = UDim.new(0, 6)
textbox2Corner.Parent = textbox2

-- Char Counter 2
local charCounter2 = Instance.new("TextLabel")
charCounter2.Size = UDim2.new(1, -20, 0, 18)
charCounter2.Position = UDim2.new(0, 10, 0, 120)
charCounter2.BackgroundTransparency = 1
charCounter2.TextColor3 = Color3.fromRGB(150, 150, 150)
charCounter2.Text = "Lines: 0 | Chars: 0/200"
charCounter2.Font = Enum.Font.Gotham
charCounter2.TextSize = 10
charCounter2.TextXAlignment = Enum.TextXAlignment.Right
charCounter2.Parent = tab2Content

-- Delay Row 2
local delayRow2 = Instance.new("Frame")
delayRow2.Size = UDim2.new(1, -20, 0, 32)
delayRow2.Position = UDim2.new(0, 10, 0, 143)
delayRow2.BackgroundTransparency = 1
delayRow2.Parent = tab2Content

local delayLabel2 = Instance.new("TextLabel")
delayLabel2.Size = UDim2.new(0, 50, 1, 0)
delayLabel2.BackgroundTransparency = 1
delayLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
delayLabel2.Text = "Delay:"
delayLabel2.Font = Enum.Font.Gotham
delayLabel2.TextSize = 12
delayLabel2.TextXAlignment = Enum.TextXAlignment.Left
delayLabel2.Parent = delayRow2

local delayTextbox2 = Instance.new("TextBox")
delayTextbox2.Size = UDim2.new(0, 50, 1, 0)
delayTextbox2.Position = UDim2.new(0, 55, 0, 0)
delayTextbox2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayTextbox2.TextColor3 = Color3.fromRGB(255, 255, 255)
delayTextbox2.Text = "0.5"
delayTextbox2.PlaceholderText = "0.5"
delayTextbox2.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
delayTextbox2.Font = Enum.Font.Gotham
delayTextbox2.TextSize = 12
delayTextbox2.ClearTextOnFocus = false
delayTextbox2.Parent = delayRow2

local delayTextbox2Corner = Instance.new("UICorner")
delayTextbox2Corner.CornerRadius = UDim.new(0, 6)
delayTextbox2Corner.Parent = delayTextbox2

local secLabel2 = Instance.new("TextLabel")
secLabel2.Size = UDim2.new(0, 30, 1, 0)
secLabel2.Position = UDim2.new(0, 110, 0, 0)
secLabel2.BackgroundTransparency = 1
secLabel2.TextColor3 = Color3.fromRGB(150, 150, 150)
secLabel2.Text = "sec"
secLabel2.Font = Enum.Font.Gotham
secLabel2.TextSize = 10
secLabel2.Parent = delayRow2

-- Send All Button
local sendAllButton = Instance.new("TextButton")
sendAllButton.Size = UDim2.new(1, -20, 0, 35)
sendAllButton.Position = UDim2.new(0, 10, 0, 180)
sendAllButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
sendAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendAllButton.Text = "Send All"
sendAllButton.Font = Enum.Font.GothamBold
sendAllButton.TextSize = 13
sendAllButton.Parent = tab2Content

local sendAllCorner = Instance.new("UICorner")
sendAllCorner.CornerRadius = UDim.new(0, 6)
sendAllCorner.Parent = sendAllButton

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 220)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Text = "Ready"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = tab2Content

-- ========== TAB 3: PREFIX ==========
local tab3Content = Instance.new("Frame")
tab3Content.Name = "Tab3Content"
tab3Content.Size = UDim2.new(1, 0, 1, -56)
tab3Content.Position = UDim2.new(0, 0, 0, 56)
tab3Content.BackgroundTransparency = 1
tab3Content.Visible = false
tab3Content.Parent = frame

-- Prefix Enable Button
local prefixEnableBtn = Instance.new("TextButton")
prefixEnableBtn.Size = UDim2.new(1, -20, 0, 35)
prefixEnableBtn.Position = UDim2.new(0, 10, 0, 10)
prefixEnableBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
prefixEnableBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
prefixEnableBtn.Text = "PREFIX: OFF"
prefixEnableBtn.Font = Enum.Font.GothamBold
prefixEnableBtn.TextSize = 13
prefixEnableBtn.Parent = tab3Content

local prefixEnableCorner = Instance.new("UICorner")
prefixEnableCorner.CornerRadius = UDim.new(0, 6)
prefixEnableCorner.Parent = prefixEnableBtn

-- Mode Selection Label
local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, -20, 0, 20)
modeLabel.Position = UDim2.new(0, 10, 0, 52)
modeLabel.BackgroundTransparency = 1
modeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
modeLabel.Text = "Mode:"
modeLabel.Font = Enum.Font.Gotham
modeLabel.TextSize = 11
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = tab3Content

-- Fixed Mode Button
local fixedModeBtn = Instance.new("TextButton")
fixedModeBtn.Size = UDim2.new(0.5, -12, 0, 32)
fixedModeBtn.Position = UDim2.new(0, 10, 0, 75)
fixedModeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
fixedModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fixedModeBtn.Text = "Fixed"
fixedModeBtn.Font = Enum.Font.GothamBold
fixedModeBtn.TextSize = 12
fixedModeBtn.Parent = tab3Content

local fixedModeCorner = Instance.new("UICorner")
fixedModeCorner.CornerRadius = UDim.new(0, 6)
fixedModeCorner.Parent = fixedModeBtn

-- Rotate Mode Button
local rotateModeBtn = Instance.new("TextButton")
rotateModeBtn.Size = UDim2.new(0.5, -12, 0, 32)
rotateModeBtn.Position = UDim2.new(0.5, 2, 0, 75)
rotateModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
rotateModeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
rotateModeBtn.Text = "Rotate"
rotateModeBtn.Font = Enum.Font.GothamBold
rotateModeBtn.TextSize = 12
rotateModeBtn.Parent = tab3Content

local rotateModeCorner = Instance.new("UICorner")
rotateModeCorner.CornerRadius = UDim.new(0, 6)
rotateModeCorner.Parent = rotateModeBtn

-- Fixed Prefix Input Label
local fixedInputLabel = Instance.new("TextLabel")
fixedInputLabel.Size = UDim2.new(1, -20, 0, 20)
fixedInputLabel.Position = UDim2.new(0, 10, 0, 115)
fixedInputLabel.BackgroundTransparency = 1
fixedInputLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
fixedInputLabel.Text = "Fixed Prefix (emoji/text):"
fixedInputLabel.Font = Enum.Font.Gotham
fixedInputLabel.TextSize = 10
fixedInputLabel.TextXAlignment = Enum.TextXAlignment.Left
fixedInputLabel.Parent = tab3Content

-- Fixed Prefix Textbox
local fixedPrefixTextbox = Instance.new("TextBox")
fixedPrefixTextbox.Size = UDim2.new(1, -20, 0, 35)
fixedPrefixTextbox.Position = UDim2.new(0, 10, 0, 138)
fixedPrefixTextbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fixedPrefixTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
fixedPrefixTextbox.Text = "😊"
fixedPrefixTextbox.PlaceholderText = "Enter prefix..."
fixedPrefixTextbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
fixedPrefixTextbox.Font = Enum.Font.Gotham
fixedPrefixTextbox.TextSize = 16
fixedPrefixTextbox.ClearTextOnFocus = false
fixedPrefixTextbox.Parent = tab3Content

local fixedPrefixCorner = Instance.new("UICorner")
fixedPrefixCorner.CornerRadius = UDim.new(0, 6)
fixedPrefixCorner.Parent = fixedPrefixTextbox

-- Rotate Emojis Label
local rotateEmojisLabel = Instance.new("TextLabel")
rotateEmojisLabel.Size = UDim2.new(1, -20, 0, 20)
rotateEmojisLabel.Position = UDim2.new(0, 10, 0, 180)
rotateEmojisLabel.BackgroundTransparency = 1
rotateEmojisLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
rotateEmojisLabel.Text = "Rotate Emojis:"
rotateEmojisLabel.Font = Enum.Font.Gotham
rotateEmojisLabel.TextSize = 10
rotateEmojisLabel.TextXAlignment = Enum.TextXAlignment.Left
rotateEmojisLabel.Parent = tab3Content

-- Rotate Emojis Display
local rotateEmojisDisplay = Instance.new("TextLabel")
rotateEmojisDisplay.Size = UDim2.new(1, -20, 0, 35)
rotateEmojisDisplay.Position = UDim2.new(0, 10, 0, 203)
rotateEmojisDisplay.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
rotateEmojisDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
rotateEmojisDisplay.Text = table.concat(prefixEmojis, " ")
rotateEmojisDisplay.Font = Enum.Font.Gotham
rotateEmojisDisplay.TextSize = 14
rotateEmojisDisplay.Parent = tab3Content

local rotateEmojisCorner = Instance.new("UICorner")
rotateEmojisCorner.CornerRadius = UDim.new(0, 6)
rotateEmojisCorner.Parent = rotateEmojisDisplay

-- Current Prefix Display
local currentPrefixLabel = Instance.new("TextLabel")
currentPrefixLabel.Size = UDim2.new(1, -20, 0, 20)
currentPrefixLabel.Position = UDim2.new(0, 10, 0, 245)
currentPrefixLabel.BackgroundTransparency = 1
currentPrefixLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
currentPrefixLabel.Text = "Current: 😊"
currentPrefixLabel.Font = Enum.Font.Gotham
currentPrefixLabel.TextSize = 10
currentPrefixLabel.TextXAlignment = Enum.TextXAlignment.Left
currentPrefixLabel.Parent = tab3Content

-- ========== TAB 4: SETTINGS ==========
local tab4Content = Instance.new("Frame")
tab4Content.Name = "Tab4Content"
tab4Content.Size = UDim2.new(1, 0, 1, -56)
tab4Content.Position = UDim2.new(0, 0, 0, 56)
tab4Content.BackgroundTransparency = 1
tab4Content.Visible = false
tab4Content.Parent = frame

-- Settings Title
local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, -20, 0, 25)
settingsTitle.Position = UDim2.new(0, 10, 0, 10)
settingsTitle.BackgroundTransparency = 1
settingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsTitle.Text = "Text Settings"
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 14
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.Parent = tab4Content

-- Auto Caps Toggle
local autoCapsBtn = Instance.new("TextButton")
autoCapsBtn.Size = UDim2.new(1, -20, 0, 40)
autoCapsBtn.Position = UDim2.new(0, 10, 0, 45)
autoCapsBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
autoCapsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoCapsBtn.Text = "AUTO CAPS: OFF"
autoCapsBtn.Font = Enum.Font.GothamBold
autoCapsBtn.TextSize = 12
autoCapsBtn.Parent = tab4Content

local autoCapsCorner = Instance.new("UICorner")
autoCapsCorner.CornerRadius = UDim.new(0, 6)
autoCapsCorner.Parent = autoCapsBtn

-- Auto Caps Description
local autoCapsDesc = Instance.new("TextLabel")
autoCapsDesc.Size = UDim2.new(1, -20, 0, 18)
autoCapsDesc.Position = UDim2.new(0, 10, 0, 87)
autoCapsDesc.BackgroundTransparency = 1
autoCapsDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
autoCapsDesc.Text = "Capitalizes first letter of each word"
autoCapsDesc.Font = Enum.Font.Gotham
autoCapsDesc.TextSize = 9
autoCapsDesc.TextXAlignment = Enum.TextXAlignment.Left
autoCapsDesc.Parent = tab4Content

-- Auto Lowercase Toggle
local autoLowerBtn = Instance.new("TextButton")
autoLowerBtn.Size = UDim2.new(1, -20, 0, 40)
autoLowerBtn.Position = UDim2.new(0, 10, 0, 115)
autoLowerBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
autoLowerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoLowerBtn.Text = "AUTO LOWERCASE: OFF"
autoLowerBtn.Font = Enum.Font.GothamBold
autoLowerBtn.TextSize = 12
autoLowerBtn.Parent = tab4Content

local autoLowerCorner = Instance.new("UICorner")
autoLowerCorner.CornerRadius = UDim.new(0, 6)
autoLowerCorner.Parent = autoLowerBtn

-- Auto Lowercase Description
local autoLowerDesc = Instance.new("TextLabel")
autoLowerDesc.Size = UDim2.new(1, -20, 0, 18)
autoLowerDesc.Position = UDim2.new(0, 10, 0, 157)
autoLowerDesc.BackgroundTransparency = 1
autoLowerDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
autoLowerDesc.Text = "Converts all text to lowercase"
autoLowerDesc.Font = Enum.Font.Gotham
autoLowerDesc.TextSize = 9
autoLowerDesc.TextXAlignment = Enum.TextXAlignment.Left
autoLowerDesc.Parent = tab4Content

-- ========== TAB SWITCHING ==========
tab1Btn.MouseButton1Click:Connect(function()
    tab1Content.Visible = true
    tab2Content.Visible = false
    tab3Content.Visible = false
    tab4Content.Visible = false
    tab1Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    tab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab2Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab2Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tab3Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab3Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tab4Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab4Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

tab2Btn.MouseButton1Click:Connect(function()
    tab1Content.Visible = false
    tab2Content.Visible = true
    tab3Content.Visible = false
    tab4Content.Visible = false
    tab2Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    tab2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab1Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab1Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tab3Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab3Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tab4Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab4Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

tab3Btn.MouseButton1Click:Connect(function()
    tab1Content.Visible = false
    tab2Content.Visible = false
    tab3Content.Visible = true
    tab4Content.Visible = false
    tab3Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    tab3Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab1Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab1Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tab2Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab2Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tab4Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab4Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

tab4Btn.MouseButton1Click:Connect(function()
    tab1Content.Visible = false
    tab2Content.Visible = false
    tab3Content.Visible = false
    tab4Content.Visible = true
    tab4Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    tab4Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab1Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab1Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tab2Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab2Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tab3Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab3Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

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

-- Character limit (Tab 1)
textbox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = textbox.Text
    if #text > MAX_CHARS then
        textbox.Text = text:sub(1, MAX_CHARS)
    end
    charCounter.Text = #textbox.Text.."/"..MAX_CHARS
    
    if #textbox.Text >= MAX_CHARS then
        charCounter.TextColor3 = Color3.fromRGB(255, 100, 100)
    elseif #textbox.Text >= MAX_CHARS * 0.8 then
        charCounter.TextColor3 = Color3.fromRGB(255, 200, 100)
    else
        charCounter.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- Character limit (Tab 2)
textbox2:GetPropertyChangedSignal("Text"):Connect(function()
    local text = textbox2.Text
    if #text > MAX_CHARS then
        textbox2.Text = text:sub(1, MAX_CHARS)
    end
    
    local lineCount = 1
    for _ in textbox2.Text:gmatch("\n") do
        lineCount = lineCount + 1
    end
    
    charCounter2.Text = "Lines: "..lineCount.." | Chars: "..#textbox2.Text.."/"..MAX_CHARS
    
    if #textbox2.Text >= MAX_CHARS then
        charCounter2.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        charCounter2.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- Get current prefix
local function getCurrentPrefix()
    if not prefixEnabled then
        return ""
    end
    
    if prefixMode == "fixed" then
        return fixedPrefixTextbox.Text
    else -- rotate
        local prefix = prefixEmojis[prefixRotateIndex]
        prefixRotateIndex = prefixRotateIndex + 1
        if prefixRotateIndex > #prefixEmojis then
            prefixRotateIndex = 1
        end
        currentPrefixLabel.Text = "Current: " .. prefix
        return prefix
    end
end

-- Apply text transformations
local function applyTextTransforms(message)
    if autoLowerEnabled then
        message = message:lower()
    end
    
    if autoCapsEnabled then
        message = message:gsub("(%l)(%w*)", function(first, rest)
            return first:upper() .. rest
        end)
    end
    
    return message
end

-- Send message function
local function sendMessage(msg)
    local message = msg or textbox.Text
    message = message:gsub("^%s+", ""):gsub("%s+$", "")
    message = message:gsub("\n", " ")
    
    if message == "" then
        return false
    end
    
    -- Apply text transforms
    message = applyTextTransforms(message)
    
    -- Add prefix
    local prefix = getCurrentPrefix()
    if prefix ~= "" then
        message = prefix .. " " .. message
    end
    
    if #message > MAX_CHARS then
        message = message:sub(1, MAX_CHARS)
    end
    
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(message, "All")
            return true
        end
    end
    
    local TextChatService = game:GetService("TextChatService")
    if TextChatService then
        local channel = TextChatService:FindFirstChild("TextChannels")
        if channel then
            local rbxGeneral = channel:FindFirstChild("RBXGeneral")
            if rbxGeneral then
                rbxGeneral:SendAsync(message)
                return true
            end
        end
    end
    
    return false
end

-- Update messages list UI
local function updateMessagesUI()
    -- Clear existing
    for _, child in pairs(messagesScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Add messages
    for i, msg in ipairs(premadeMessages) do
        local msgFrame = Instance.new("Frame")
        msgFrame.Size = UDim2.new(1, 0, 0, 28)
        msgFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        msgFrame.Parent = messagesScroll
        
        local msgCorner = Instance.new("UICorner")
        msgCorner.CornerRadius = UDim.new(0, 4)
        msgCorner.Parent = msgFrame
        
        local msgLabel = Instance.new("TextLabel")
        msgLabel.Size = UDim2.new(1, -35, 1, 0)
        msgLabel.Position = UDim2.new(0, 5, 0, 0)
        msgLabel.BackgroundTransparency = 1
        msgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        msgLabel.Text = msg
        msgLabel.Font = Enum.Font.Gotham
        msgLabel.TextSize = 12
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.TextTruncate = Enum.TextTruncate.AtEnd
        msgLabel.Parent = msgFrame
        
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 24, 0, 24)
        deleteBtn.Position = UDim2.new(1, -26, 0.5, -12)
        deleteBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        deleteBtn.Text = "X"
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.TextSize = 12
        deleteBtn.Parent = msgFrame
        
        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, 4)
        deleteCorner.Parent = deleteBtn
        
        deleteBtn.MouseButton1Click:Connect(function()
            table.remove(premadeMessages, i)
            updateMessagesUI()
        end)
    end
    
    -- Update canvas size
    messagesScroll.CanvasSize = UDim2.new(0, 0, 0, #premadeMessages * 32)
end

-- Toggle messages panel
messagesToggle.MouseButton1Click:Connect(function()
    messagesExpanded = not messagesExpanded
    messagesPanel.Visible = messagesExpanded
    
    if messagesExpanded then
        messagesToggle.Text = "▲ Messages"
        frame.Size = UDim2.new(0, 200, 0, 310)
    else
        messagesToggle.Text = "▼ Messages"
        frame.Size = UDim2.new(0, 200, 0, 180)
    end
    
    updateMessagesUI()
end)

-- Add current message to list
addMsgButton.MouseButton1Click:Connect(function()
    local msg = textbox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if msg ~= "" then
        table.insert(premadeMessages, msg)
        updateMessagesUI()
        textbox.Text = ""
    end
end)

-- Send button (Tab 1)
sendButton.MouseButton1Click:Connect(function()
    if textbox.Text ~= "" then
        sendMessage()
    end
end)

-- FocusLost (Tab 1) - Send on Enter
textbox.FocusLost:Connect(function(enterPressed)
    if enterPressed and textbox.Text ~= "" then
        sendMessage()
    end
end)

-- Focused - clear (Tab 1)
textbox.Focused:Connect(function()
    textbox.Text = ""
end)

-- ========== MOBILE FIX FOR TAB 2 (Multi-line textbox) ==========
textbox2.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        -- Mobile pressed Enter - add newline and refocus
        textbox2.Text = textbox2.Text .. "\n"
        task.wait()
        textbox2:CaptureFocus()
    end
    -- Don't send on Enter - only send via button
end)

-- Focused - clear (Tab 2)
textbox2.Focused:Connect(function()
    textbox2.Text = ""
end)

-- Send All Button (Tab 2)
sendAllButton.MouseButton1Click:Connect(function()
    local text = textbox2.Text
    if text == "" then return end
    
    local lines = {}
    for line in text:gmatch("[^\n]+") do
        if line:match("%S") then
            table.insert(lines, line)
        end
    end
    
    if #lines == 0 then return end
    
    local delay = tonumber(delayTextbox2.Text) or 0.5
    if delay < 0.1 then delay = 0.1 end
    
    sendAllButton.Text = "Sending..."
    sendAllButton.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
    statusLabel.Text = "Sending "..#lines.." messages..."
    
    spawn(function()
        for i, line in ipairs(lines) do
            sendMessage(line)
            statusLabel.Text = "Sent "..i.."/"..#lines
            if i < #lines then
                wait(delay)
            end
        end
        sendAllButton.Text = "Send All"
        sendAllButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        statusLabel.Text = "Done! Sent "..#lines.." messages"
    end)
end)

-- Spam toggle
local function toggleSpam()
    spamEnabled = not spamEnabled
    
    if spamEnabled then
        spamDelay = tonumber(delayTextbox.Text) or 1
        if spamDelay < 0.1 then
            spamDelay = 0.1
        end
        
        spamButton.Text = "SPAM: ON"
        spamButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
        -- Check if we have premade messages
        if #premadeMessages > 0 then
            spamIndex = 1
            spawn(function()
                while spamEnabled do
                    local msg = premadeMessages[spamIndex]
                    if msg then
                        sendMessage(msg)
                    end
                    spamIndex = spamIndex + 1
                    if spamIndex > #premadeMessages then
                        spamIndex = 1
                    end
                    wait(spamDelay)
                end
            end)
        else
            -- Use textbox message if no premade messages
            spawn(function()
                while spamEnabled do
                    local msg = textbox.Text
                    if msg ~= "" then
                        sendMessage(msg)
                    end
                    wait(spamDelay)
                end
            end)
        end
    else
        spamButton.Text = "SPAM: OFF"
        spamButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end

spamButton.MouseButton1Click:Connect(toggleSpam)

-- ========== PREFIX TAB FUNCTIONALITY ==========
-- Prefix Enable Toggle
prefixEnableBtn.MouseButton1Click:Connect(function()
    prefixEnabled = not prefixEnabled
    
    if prefixEnabled then
        prefixEnableBtn.Text = "PREFIX: ON"
        prefixEnableBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        currentPrefixLabel.Text = "Current: " .. fixedPrefixTextbox.Text
    else
        prefixEnableBtn.Text = "PREFIX: OFF"
        prefixEnableBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        currentPrefixLabel.Text = "Prefix Disabled"
    end
end)

-- Fixed Mode Button
fixedModeBtn.MouseButton1Click:Connect(function()
    prefixMode = "fixed"
    fixedModeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    fixedModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    rotateModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    rotateModeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    if prefixEnabled then
        currentPrefixLabel.Text = "Current: " .. fixedPrefixTextbox.Text
    end
end)

-- Rotate Mode Button
rotateModeBtn.MouseButton1Click:Connect(function()
    prefixMode = "rotate"
    rotateModeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    rotateModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    fixedModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    fixedModeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    if prefixEnabled then
        currentPrefixLabel.Text = "Current: " .. prefixEmojis[prefixRotateIndex]
    end
end)

-- Update current prefix when fixed prefix changes
fixedPrefixTextbox:GetPropertyChangedSignal("Text"):Connect(function()
    if prefixMode == "fixed" and prefixEnabled then
        currentPrefixLabel.Text = "Current: " .. fixedPrefixTextbox.Text
    end
end)

-- ========== SETTINGS TAB FUNCTIONALITY ==========
-- Auto Caps Toggle
autoCapsBtn.MouseButton1Click:Connect(function()
    autoCapsEnabled = not autoCapsEnabled
    
    if autoCapsEnabled then
        autoLowerEnabled = false
        autoLowerBtn.Text = "AUTO LOWERCASE: OFF"
        autoLowerBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        autoCapsBtn.Text = "AUTO CAPS: ON"
        autoCapsBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        autoCapsBtn.Text = "AUTO CAPS: OFF"
        autoCapsBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end)

-- Auto Lowercase Toggle
autoLowerBtn.MouseButton1Click:Connect(function()
    autoLowerEnabled = not autoLowerEnabled
    
    if autoLowerEnabled then
        autoCapsEnabled = false
        autoCapsBtn.Text = "AUTO CAPS: OFF"
        autoCapsBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        autoLowerBtn.Text = "AUTO LOWERCASE: ON"
        autoLowerBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        autoLowerBtn.Text = "AUTO LOWERCASE: OFF"
        autoLowerBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end)

-- Toggle GUI with RightControl
local guiVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        frame.Visible = guiVisible
    end
end)

-- Initialize messages UI
updateMessagesUI()

print("✅ Custom Chat GUI Loaded (Prefix + Settings Tabs)")
