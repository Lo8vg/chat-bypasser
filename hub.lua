-- Chat Hub (White Theme, Wide Layout, Fixed Clear)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local MAX_CHARS = 200
local spamEnabled = false
local spamDelay = 1
local spamIndex = 1
local antiAfkEnabled = false
local autoReplyEnabled = false
local autoReplyTargets = {}
local premadeMessages = {"Hello", "GG", "What's up", "Bye"}

-- Prefix Settings
local prefixMode = "OFF"
local fixedPrefix = "★"
local rotatingPrefixes = {"★", "🔥", "💎", "🎮"}
local rotatingIndex = 1

-- GUI Settings
local guiTransparency = 0
local guiScale = 1

-- Colors (White Theme)
local COLORS = {
    background = Color3.fromRGB(245, 245, 245),
    header = Color3.fromRGB(255, 255, 255),
    buttonPrimary = Color3.fromRGB(0, 120, 215),
    buttonDanger = Color3.fromRGB(220, 53, 69),
    buttonSuccess = Color3.fromRGB(40, 167, 69),
    buttonOff = Color3.fromRGB(108, 117, 125),
    textDark = Color3.fromRGB(33, 37, 41),
    textLight = Color3.fromRGB(255, 255, 255),
    textMuted = Color3.fromRGB(134, 142, 150),
    inputBg = Color3.fromRGB(255, 255, 255),
    border = Color3.fromRGB(222, 226, 230),
    cardBg = Color3.fromRGB(255, 255, 255)
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========== HUB BUTTON (COLLAPSED) ==========

local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 55, 0, 55)
hubButton.Position = UDim2.new(0, 20, 0.5, -27)
hubButton.BackgroundColor3 = COLORS.cardBg
hubButton.BorderSizePixel = 0
hubButton.Visible = true
hubButton.Parent = screenGui

local hubButtonCorner = Instance.new("UICorner")
hubButtonCorner.CornerRadius = UDim.new(0, 12)
hubButtonCorner.Parent = hubButton

local hubButtonShadow = Instance.new("UIStroke")
hubButtonShadow.Color = COLORS.border
hubButtonShadow.Thickness = 1
hubButtonShadow.Parent = hubButton

local hubButtonIcon = Instance.new("TextLabel")
hubButtonIcon.Size = UDim2.new(1, 0, 1, 0)
hubButtonIcon.BackgroundTransparency = 1
hubButtonIcon.TextColor3 = COLORS.textDark
hubButtonIcon.Text = "💬"
hubButtonIcon.Font = Enum.Font.GothamBold
hubButtonIcon.TextSize = 26
hubButtonIcon.Parent = hubButton

-- ========== HUB FRAME (EXPANDED - WIDE NOT TALL) ==========

local hubFrame = Instance.new("Frame")
hubFrame.Name = "HubFrame"
hubFrame.Size = UDim2.new(0, 500, 0, 300)
hubFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
hubFrame.BackgroundColor3 = COLORS.background
hubFrame.BorderSizePixel = 0
hubFrame.Visible = false
hubFrame.Parent = screenGui

local hubFrameCorner = Instance.new("UICorner")
hubFrameCorner.CornerRadius = UDim.new(0, 16)
hubFrameCorner.Parent = hubFrame

local hubFrameShadow = Instance.new("UIStroke")
hubFrameShadow.Color = Color3.fromRGB(180, 180, 180)
hubFrameShadow.Thickness = 1
hubFrameShadow.Parent = hubFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = COLORS.header
titleBar.BorderSizePixel = 0
titleBar.Parent = hubFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 16)
titleBarCorner.Parent = titleBar

local titleBarFix = Instance.new("Frame")
titleBarFix.Size = UDim2.new(1, 0, 0, 16)
titleBarFix.Position = UDim2.new(0, 0, 1, -16)
titleBarFix.BackgroundColor3 = COLORS.header
titleBarFix.BorderSizePixel = 0
titleBarFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 20, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = COLORS.textDark
titleLabel.Text = "💬 Chat Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 35, 0, 28)
collapseButton.Position = UDim2.new(1, -45, 0.5, -14)
collapseButton.BackgroundColor3 = COLORS.buttonDanger
collapseButton.TextColor3 = COLORS.textLight
collapseButton.Text = "✕"
collapseButton.Font = Enum.Font.GothamBold
collapseButton.TextSize = 14
collapseButton.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 8)
collapseCorner.Parent = collapseButton

-- Tab Buttons Frame
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -30, 0, 32)
tabFrame.Position = UDim2.new(0, 15, 0, 50)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = hubFrame

-- Tab Buttons
local tabs = {"Chat", "Spam", "AutoReply", "AFK", "Settings"}
local tabButtons = {}
local currentTab = "Chat"

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1/#tabs, -4, 1, 0)
    tabBtn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    tabBtn.BackgroundColor3 = i == 1 and COLORS.buttonPrimary or Color3.fromRGB(230, 230, 230)
    tabBtn.TextColor3 = i == 1 and COLORS.textLight or COLORS.textDark
    tabBtn.Text = tabName
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 10
    tabBtn.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn
    
    tabButtons[tabName] = tabBtn
end

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -30, 1, -95)
contentFrame.Position = UDim2.new(0, 15, 0, 88)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = hubFrame

-- ========== CHAT SECTION ==========

local chatSection = Instance.new("Frame")
chatSection.Size = UDim2.new(1, 0, 1, 0)
chatSection.BackgroundTransparency = 1
chatSection.Visible = true
chatSection.Parent = contentFrame

-- Chat Textbox
local chatTextbox = Instance.new("TextBox")
chatTextbox.Size = UDim2.new(1, 0, 0, 70)
chatTextbox.Position = UDim2.new(0, 0, 0, 0)
chatTextbox.BackgroundColor3 = COLORS.inputBg
chatTextbox.TextColor3 = COLORS.textDark
chatTextbox.Text = ""
chatTextbox.PlaceholderText = "Type your message here..."
chatTextbox.PlaceholderColor3 = COLORS.textMuted
chatTextbox.Font = Enum.Font.Gotham
chatTextbox.TextSize = 14
chatTextbox.TextXAlignment = Enum.TextXAlignment.Left
chatTextbox.TextYAlignment = Enum.TextYAlignment.Top
chatTextbox.MultiLine = true
chatTextbox.TextWrapped = true
chatTextbox.ClearTextOnFocus = true
chatTextbox.Parent = chatSection

local chatTextboxCorner = Instance.new("UICorner")
chatTextboxCorner.CornerRadius = UDim.new(0, 8)
chatTextboxCorner.Parent = chatTextbox

local chatTextboxStroke = Instance.new("UIStroke")
chatTextboxStroke.Color = COLORS.border
chatTextboxStroke.Thickness = 1
chatTextboxStroke.Parent = chatTextbox

-- Char Counter
local chatCharCounter = Instance.new("TextLabel")
chatCharCounter.Size = UDim2.new(0, 60, 0, 18)
chatCharCounter.Position = UDim2.new(1, -65, 0, 50)
chatCharCounter.BackgroundTransparency = 1
chatCharCounter.TextColor3 = COLORS.textMuted
chatCharCounter.Text = "0/200"
chatCharCounter.Font = Enum.Font.Gotham
chatCharCounter.TextSize = 11
chatCharCounter.Parent = chatSection

-- Prefix Status
local prefixStatus = Instance.new("TextLabel")
prefixStatus.Size = UDim2.new(1, 0, 0, 20)
prefixStatus.Position = UDim2.new(0, 0, 0, 75)
prefixStatus.BackgroundTransparency = 1
prefixStatus.TextColor3 = COLORS.textMuted
prefixStatus.Text = "Prefix: OFF"
prefixStatus.Font = Enum.Font.Gotham
prefixStatus.TextSize = 11
prefixStatus.TextXAlignment = Enum.TextXAlignment.Left
prefixStatus.Parent = chatSection

-- Chat Button Row
local chatButtonRow = Instance.new("Frame")
chatButtonRow.Size = UDim2.new(1, 0, 0, 40)
chatButtonRow.Position = UDim2.new(0, 0, 0, 100)
chatButtonRow.BackgroundTransparency = 1
chatButtonRow.Parent = chatSection

-- Send Button
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0.6, 0, 1, 0)
sendButton.Position = UDim2.new(0, 0, 0, 0)
sendButton.BackgroundColor3 = COLORS.buttonPrimary
sendButton.TextColor3 = COLORS.textLight
sendButton.Text = "Send Message"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 13
sendButton.Parent = chatButtonRow

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 8)
sendCorner.Parent = sendButton

-- Delay Input
local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0.2, -5, 1, 0)
delayInput.Position = UDim2.new(0.6, 5, 0, 0)
delayInput.BackgroundColor3 = COLORS.inputBg
delayInput.TextColor3 = COLORS.textDark
delayInput.Text = "1"
delayInput.PlaceholderText = "Delay"
delayInput.PlaceholderColor3 = COLORS.textMuted
delayInput.Font = Enum.Font.Gotham
delayInput.TextSize = 13
delayInput.ClearTextOnFocus = false
delayInput.Parent = chatButtonRow

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 8)
delayCorner.Parent = delayInput

local delayStroke = Instance.new("UIStroke")
delayStroke.Color = COLORS.border
delayStroke.Thickness = 1
delayStroke.Parent = delayInput

-- Delay Label
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0.2, 0, 1, 0)
delayLabel.Position = UDim2.new(0.8, 0, 0, 0)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = COLORS.textMuted
delayLabel.Text = "sec delay"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 11
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = chatButtonRow

-- ========== SPAM SECTION ==========

local spamSection = Instance.new("Frame")
spamSection.Size = UDim2.new(1, 0, 1, 0)
spamSection.BackgroundTransparency = 1
spamSection.Visible = false
spamSection.Parent = contentFrame

-- Spam Toggle
local spamToggle = Instance.new("TextButton")
spamToggle.Size = UDim2.new(1, 0, 0, 45)
spamToggle.Position = UDim2.new(0, 0, 0, 0)
spamToggle.BackgroundColor3 = COLORS.buttonDanger
spamToggle.TextColor3 = COLORS.textLight
spamToggle.Text = "SPAM: OFF"
spamToggle.Font = Enum.Font.GothamBold
spamToggle.TextSize = 16
spamToggle.Parent = spamSection

local spamToggleCorner = Instance.new("UICorner")
spamToggleCorner.CornerRadius = UDim.new(0, 8)
spamToggleCorner.Parent = spamToggle

-- Spam Delay Row
local spamDelayRow = Instance.new("Frame")
spamDelayRow.Size = UDim2.new(1, 0, 0, 30)
spamDelayRow.Position = UDim2.new(0, 0, 0, 55)
spamDelayRow.BackgroundTransparency = 1
spamDelayRow.Parent = spamSection

local spamDelayLabel = Instance.new("TextLabel")
spamDelayLabel.Size = UDim2.new(0, 80, 1, 0)
spamDelayLabel.BackgroundTransparency = 1
spamDelayLabel.TextColor3 = COLORS.textDark
spamDelayLabel.Text = "Delay (sec):"
spamDelayLabel.Font = Enum.Font.Gotham
spamDelayLabel.TextSize = 12
spamDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
spamDelayLabel.Parent = spamDelayRow

local spamDelayInput = Instance.new("TextBox")
spamDelayInput.Size = UDim2.new(0, 70, 1, 0)
spamDelayInput.Position = UDim2.new(0, 85, 0, 0)
spamDelayInput.BackgroundColor3 = COLORS.inputBg
spamDelayInput.TextColor3 = COLORS.textDark
spamDelayInput.Text = "1"
spamDelayInput.Font = Enum.Font.Gotham
spamDelayInput.TextSize = 12
spamDelayInput.ClearTextOnFocus = false
spamDelayInput.Parent = spamDelayRow

local spamDelayCorner = Instance.new("UICorner")
spamDelayCorner.CornerRadius = UDim.new(0, 6)
spamDelayCorner.Parent = spamDelayInput

local spamDelayStroke = Instance.new("UIStroke")
spamDelayStroke.Color = COLORS.border
spamDelayStroke.Thickness = 1
spamDelayStroke.Parent = spamDelayInput

-- Premade Messages Toggle
local premadeToggle = Instance.new("TextButton")
premadeToggle.Size = UDim2.new(1, 0, 0, 30)
premadeToggle.Position = UDim2.new(0, 0, 0, 95)
premadeToggle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
premadeToggle.TextColor3 = COLORS.textDark
premadeToggle.Text = "▼ Premade Messages"
premadeToggle.Font = Enum.Font.GothamBold
premadeToggle.TextSize = 12
premadeToggle.Parent = spamSection

local premadeToggleCorner = Instance.new("UICorner")
premadeToggleCorner.CornerRadius = UDim.new(0, 6)
premadeToggleCorner.Parent = premadeToggle

-- Premade Messages Panel
local premadePanel = Instance.new("Frame")
premadePanel.Size = UDim2.new(1, 0, 0, 180)
premadePanel.Position = UDim2.new(0, 0, 0, 130)
premadePanel.BackgroundColor3 = COLORS.cardBg
premadePanel.Visible = false
premadePanel.Parent = spamSection

local premadePanelCorner = Instance.new("UICorner")
premadePanelCorner.CornerRadius = UDim.new(0, 8)
premadePanelCorner.Parent = premadePanel

local premadePanelStroke = Instance.new("UIStroke")
premadePanelStroke.Color = COLORS.border
premadePanelStroke.Thickness = 1
premadePanelStroke.Parent = premadePanel

local premadeScroll = Instance.new("ScrollingFrame")
premadeScroll.Size = UDim2.new(1, -20, 1, -40)
premadeScroll.Position = UDim2.new(0, 10, 0, 10)
premadeScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
premadeScroll.ScrollBarThickness = 4
premadeScroll.Parent = premadePanel

local premadeScrollCorner = Instance.new("UICorner")
premadeScrollCorner.CornerRadius = UDim.new(0, 6)
premadeScrollCorner.Parent = premadeScroll

local premadeLayout = Instance.new("UIListLayout")
premadeLayout.Padding = UDim.new(0, 5)
premadeLayout.Parent = premadeScroll

local addPremadeBtn = Instance.new("TextButton")
addPremadeBtn.Size = UDim2.new(1, -20, 0, 28)
addPremadeBtn.Position = UDim2.new(0, 10, 1, -32)
addPremadeBtn.BackgroundColor3 = COLORS.buttonPrimary
addPremadeBtn.TextColor3 = COLORS.textLight
addPremadeBtn.Text = "+ Add Current Message"
addPremadeBtn.Font = Enum.Font.GothamBold
addPremadeBtn.TextSize = 11
addPremadeBtn.Parent = premadePanel

local addPremadeCorner = Instance.new("UICorner")
addPremadeCorner.CornerRadius = UDim.new(0, 6)
addPremadeCorner.Parent = addPremadeBtn

-- ========== AUTO-REPLY SECTION ==========

local autoReplySection = Instance.new("Frame")
autoReplySection.Size = UDim2.new(1, 0, 1, 0)
autoReplySection.BackgroundTransparency = 1
autoReplySection.Visible = false
autoReplySection.Parent = contentFrame

-- Auto-Reply Toggle
local autoReplyToggle = Instance.new("TextButton")
autoReplyToggle.Size = UDim2.new(1, 0, 0, 40)
autoReplyToggle.Position = UDim2.new(0, 0, 0, 0)
autoReplyToggle.BackgroundColor3 = COLORS.buttonDanger
autoReplyToggle.TextColor3 = COLORS.textLight
autoReplyToggle.Text = "AUTO-REPLY: OFF"
autoReplyToggle.Font = Enum.Font.GothamBold
autoReplyToggle.TextSize = 15
autoReplyToggle.Parent = autoReplySection

local autoReplyToggleCorner = Instance.new("UICorner")
autoReplyToggleCorner.CornerRadius = UDim.new(0, 8)
autoReplyToggleCorner.Parent = autoReplyToggle

-- Target Input Row
local targetRow = Instance.new("Frame")
targetRow.Size = UDim2.new(1, 0, 0, 28)
targetRow.Position = UDim2.new(0, 0, 0, 50)
targetRow.BackgroundTransparency = 1
targetRow.Parent = autoReplySection

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(0, 70, 1, 0)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = COLORS.textDark
targetLabel.Text = "Username:"
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextSize = 11
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = targetRow

local targetInput = Instance.new("TextBox")
targetInput.Size = UDim2.new(1, -75, 1, 0)
targetInput.Position = UDim2.new(0, 75, 0, 0)
targetInput.BackgroundColor3 = COLORS.inputBg
targetInput.TextColor3 = COLORS.textDark
targetInput.Text = ""
targetInput.PlaceholderText = "Enter username..."
targetInput.PlaceholderColor3 = COLORS.textMuted
targetInput.Font = Enum.Font.Gotham
targetInput.TextSize = 11
targetInput.ClearTextOnFocus = true
targetInput.Parent = targetRow

local targetInputCorner = Instance.new("UICorner")
targetInputCorner.CornerRadius = UDim.new(0, 6)
targetInputCorner.Parent = targetInput

local targetInputStroke = Instance.new("UIStroke")
targetInputStroke.Color = COLORS.border
targetInputStroke.Thickness = 1
targetInputStroke.Parent = targetInput

-- Reply Messages Input
local replyLabel = Instance.new("TextLabel")
replyLabel.Size = UDim2.new(1, 0, 0, 18)
replyLabel.Position = UDim2.new(0, 0, 0, 85)
replyLabel.BackgroundTransparency = 1
replyLabel.TextColor3 = COLORS.textDark
replyLabel.Text = "Reply Messages (one per line, cycles):"
replyLabel.Font = Enum.Font.Gotham
replyLabel.TextSize = 11
replyLabel.TextXAlignment = Enum.TextXAlignment.Left
replyLabel.Parent = autoReplySection

local replyInput = Instance.new("TextBox")
replyInput.Size = UDim2.new(1, 0, 0, 60)
replyInput.Position = UDim2.new(0, 0, 0, 105)
replyInput.BackgroundColor3 = COLORS.inputBg
replyInput.TextColor3 = COLORS.textDark
replyInput.Text = ""
replyInput.PlaceholderText = "Hey!\nWhat's up?\nBe right back"
replyInput.PlaceholderColor3 = COLORS.textMuted
replyInput.Font = Enum.Font.Gotham
replyInput.TextSize = 11
replyInput.TextXAlignment = Enum.TextXAlignment.Left
replyInput.TextYAlignment = Enum.TextYAlignment.Top
replyInput.MultiLine = true
replyInput.TextWrapped = true
replyInput.ClearTextOnFocus = true
replyInput.Parent = autoReplySection

local replyInputCorner = Instance.new("UICorner")
replyInputCorner.CornerRadius = UDim.new(0, 6)
replyInputCorner.Parent = replyInput

local replyInputStroke = Instance.new("UIStroke")
replyInputStroke.Color = COLORS.border
replyInputStroke.Thickness = 1
replyInputStroke.Parent = replyInput

-- Reply Char Counter
local replyCharCounter = Instance.new("TextLabel")
replyCharCounter.Size = UDim2.new(0, 60, 0, 16)
replyCharCounter.Position = UDim2.new(1, -65, 0, 147)
replyCharCounter.BackgroundTransparency = 1
replyCharCounter.TextColor3 = COLORS.textMuted
replyCharCounter.Text = "0/200"
replyCharCounter.Font = Enum.Font.Gotham
replyCharCounter.TextSize = 10
replyCharCounter.Parent = autoReplySection

-- Add Target Button
local addTargetBtn = Instance.new("TextButton")
addTargetBtn.Size = UDim2.new(1, 0, 0, 32)
addTargetBtn.Position = UDim2.new(0, 0, 0, 170)
addTargetBtn.BackgroundColor3 = COLORS.buttonPrimary
addTargetBtn.TextColor3 = COLORS.textLight
addTargetBtn.Text = "+ Add Target"
addTargetBtn.Font = Enum.Font.GothamBold
addTargetBtn.TextSize = 12
addTargetBtn.Parent = autoReplySection

local addTargetCorner = Instance.new("UICorner")
addTargetCorner.CornerRadius = UDim.new(0, 8)
addTargetCorner.Parent = addTargetBtn

-- Targets List
local targetsScroll = Instance.new("ScrollingFrame")
targetsScroll.Size = UDim2.new(1, 0, 0, 85)
targetsScroll.Position = UDim2.new(0, 0, 0, 210)
targetsScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
targetsScroll.ScrollBarThickness = 4
targetsScroll.Parent = autoReplySection

local targetsScrollCorner = Instance.new("UICorner")
targetsScrollCorner.CornerRadius = UDim.new(0, 6)
targetsScrollCorner.Parent = targetsScroll

local targetsLayout = Instance.new("UIListLayout")
targetsLayout.Padding = UDim.new(0, 5)
targetsLayout.Parent = targetsScroll

-- ========== ANTI-AFK SECTION ==========

local afkSection = Instance.new("Frame")
afkSection.Size = UDim2.new(1, 0, 1, 0)
afkSection.BackgroundTransparency = 1
afkSection.Visible = false
afkSection.Parent = contentFrame

-- AFK Toggle
local afkToggle = Instance.new("TextButton")
afkToggle.Size = UDim2.new(1, 0, 0, 55)
afkToggle.Position = UDim2.new(0, 0, 0, 0)
afkToggle.BackgroundColor3 = COLORS.buttonDanger
afkToggle.TextColor3 = COLORS.textLight
afkToggle.Text = "ANTI-AFK: OFF"
afkToggle.Font = Enum.Font.GothamBold
afkToggle.TextSize = 18
afkToggle.Parent = afkSection

local afkToggleCorner = Instance.new("UICorner")
afkToggleCorner.CornerRadius = UDim.new(0, 10)
afkToggleCorner.Parent = afkToggle

-- AFK Info
local afkInfo = Instance.new("TextLabel")
afkInfo.Size = UDim2.new(1, 0, 0, 70)
afkInfo.Position = UDim2.new(0, 0, 0, 70)
afkInfo.BackgroundTransparency = 1
afkInfo.TextColor3 = COLORS.textMuted
afkInfo.Text = "Prevents getting kicked for inactivity.\n\nWorks in any game. Simulates activity every 60 seconds."
afkInfo.Font = Enum.Font.Gotham
afkInfo.TextSize = 12
afkInfo.TextWrapped = true
afkInfo.Parent = afkSection

-- ========== SETTINGS SECTION ==========

local settingsSection = Instance.new("Frame")
settingsSection.Size = UDim2.new(1, 0, 1, 0)
settingsSection.BackgroundTransparency = 1
settingsSection.Visible = false
settingsSection.Parent = contentFrame

-- Prefix Mode Label
local prefixModeLabel = Instance.new("TextLabel")
prefixModeLabel.Size = UDim2.new(1, 0, 0, 20)
prefixModeLabel.Position = UDim2.new(0, 0, 0, 0)
prefixModeLabel.BackgroundTransparency = 1
prefixModeLabel.TextColor3 = COLORS.textDark
prefixModeLabel.Text = "Message Prefix Mode"
prefixModeLabel.Font = Enum.Font.GothamBold
prefixModeLabel.TextSize = 13
prefixModeLabel.TextXAlignment = Enum.TextXAlignment.Left
prefixModeLabel.Parent = settingsSection

-- Prefix Mode Buttons
local prefixModeFrame = Instance.new("Frame")
prefixModeFrame.Size = UDim2.new(1, 0, 0, 32)
prefixModeFrame.Position = UDim2.new(0, 0, 0, 22)
prefixModeFrame.BackgroundTransparency = 1
prefixModeFrame.Parent = settingsSection

local prefixModes = {"OFF", "FIXED", "ROTATE"}
local prefixModeButtons = {}

for i, mode in ipairs(prefixModes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/3, -3, 1, 0)
    btn.Position = UDim2.new((i-1)/3, 0, 0, 0)
    btn.BackgroundColor3 = mode == "OFF" and COLORS.buttonPrimary or Color3.fromRGB(230, 230, 230)
    btn.TextColor3 = mode == "OFF" and COLORS.textLight or COLORS.textDark
    btn.Text = mode
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = prefixModeFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    prefixModeButtons[mode] = btn
end

-- Fixed Prefix Input
local fixedPrefixLabel = Instance.new("TextLabel")
fixedPrefixLabel.Size = UDim2.new(0, 80, 0, 20)
fixedPrefixLabel.Position = UDim2.new(0, 0, 0, 62)
fixedPrefixLabel.BackgroundTransparency = 1
fixedPrefixLabel.TextColor3 = COLORS.textDark
fixedPrefixLabel.Text = "Fixed Prefix:"
fixedPrefixLabel.Font = Enum.Font.Gotham
fixedPrefixLabel.TextSize = 11
fixedPrefixLabel.TextXAlignment = Enum.TextXAlignment.Left
fixedPrefixLabel.Parent = settingsSection

local fixedPrefixInput = Instance.new("TextBox")
fixedPrefixInput.Size = UDim2.new(1, -85, 0, 28)
fixedPrefixInput.Position = UDim2.new(0, 80, 0, 58)
fixedPrefixInput.BackgroundColor3 = COLORS.inputBg
fixedPrefixInput.TextColor3 = COLORS.textDark
fixedPrefixInput.Text = "★"
fixedPrefixInput.Font = Enum.Font.Gotham
fixedPrefixInput.TextSize = 14
fixedPrefixInput.ClearTextOnFocus = false
fixedPrefixInput.Parent = settingsSection

local fixedPrefixCorner = Instance.new("UICorner")
fixedPrefixCorner.CornerRadius = UDim.new(0, 6)
fixedPrefixCorner.Parent = fixedPrefixInput

local fixedPrefixStroke = Instance.new("UIStroke")
fixedPrefixStroke.Color = COLORS.border
fixedPrefixStroke.Thickness = 1
fixedPrefixStroke.Parent = fixedPrefixInput

-- Rotating Prefixes Input
local rotatingPrefixLabel = Instance.new("TextLabel")
rotatingPrefixLabel.Size = UDim2.new(1, 0, 0, 20)
rotatingPrefixLabel.Position = UDim2.new(0, 0, 0, 95)
rotatingPrefixLabel.BackgroundTransparency = 1
rotatingPrefixLabel.TextColor3 = COLORS.textDark
rotatingPrefixLabel.Text = "Rotating Prefixes (space separated):"
rotatingPrefixLabel.Font = Enum.Font.Gotham
rotatingPrefixLabel.TextSize = 11
rotatingPrefixLabel.TextXAlignment = Enum.TextXAlignment.Left
rotatingPrefixLabel.Parent = settingsSection

local rotatingPrefixInput = Instance.new("TextBox")
rotatingPrefixInput.Size = UDim2.new(1, 0, 0, 28)
rotatingPrefixInput.Position = UDim2.new(0, 0, 0, 115)
rotatingPrefixInput.BackgroundColor3 = COLORS.inputBg
rotatingPrefixInput.TextColor3 = COLORS.textDark
rotatingPrefixInput.Text = "★ 🔥 💎 🎮"
rotatingPrefixInput.Font = Enum.Font.Gotham
rotatingPrefixInput.TextSize = 14
rotatingPrefixInput.ClearTextOnFocus = false
rotatingPrefixInput.Parent = settingsSection

local rotatingPrefixCorner = Instance.new("UICorner")
rotatingPrefixCorner.CornerRadius = UDim.new(0, 6)
rotatingPrefixCorner.Parent = rotatingPrefixInput

local rotatingPrefixStroke = Instance.new("UIStroke")
rotatingPrefixStroke.Color = COLORS.border
rotatingPrefixStroke.Thickness = 1
rotatingPrefixStroke.Parent = rotatingPrefixInput

-- Divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Position = UDim2.new(0, 0, 0, 155)
divider.BackgroundColor3 = COLORS.border
divider.BorderSizePixel = 0
divider.Parent = settingsSection

-- GUI Settings Label
local guiSettingsLabel = Instance.new("TextLabel")
guiSettingsLabel.Size = UDim2.new(1, 0, 0, 20)
guiSettingsLabel.Position = UDim2.new(0, 0, 0, 165)
guiSettingsLabel.BackgroundTransparency = 1
guiSettingsLabel.TextColor3 = COLORS.textDark
guiSettingsLabel.Text = "GUI Settings"
guiSettingsLabel.Font = Enum.Font.GothamBold
guiSettingsLabel.TextSize = 13
guiSettingsLabel.TextXAlignment = Enum.TextXAlignment.Left
guiSettingsLabel.Parent = settingsSection

-- Transparency Slider
local transparencyLabel = Instance.new("TextLabel")
transparencyLabel.Size = UDim2.new(0, 90, 0, 20)
transparencyLabel.Position = UDim2.new(0, 0, 0, 190)
transparencyLabel.BackgroundTransparency = 1
transparencyLabel.TextColor3 = COLORS.textDark
transparencyLabel.Text = "Transparency:"
transparencyLabel.Font = Enum.Font.Gotham
transparencyLabel.TextSize = 11
transparencyLabel.TextXAlignment = Enum.TextXAlignment.Left
transparencyLabel.Parent = settingsSection

local transparencySlider = Instance.new("TextBox")
transparencySlider.Size = UDim2.new(0, 60, 0, 28)
transparencySlider.Position = UDim2.new(0, 95, 0, 186)
transparencySlider.BackgroundColor3 = COLORS.inputBg
transparencySlider.TextColor3 = COLORS.textDark
transparencySlider.Text = "0"
transparencySlider.Font = Enum.Font.Gotham
transparencySlider.TextSize = 12
transparencySlider.ClearTextOnFocus = false
transparencySlider.Parent = settingsSection

local transparencySliderCorner = Instance.new("UICorner")
transparencySliderCorner.CornerRadius = UDim.new(0, 6)
transparencySliderCorner.Parent = transparencySlider

local transparencySliderStroke = Instance.new("UIStroke")
transparencySliderStroke.Color = COLORS.border
transparencySliderStroke.Thickness = 1
transparencySliderStroke.Parent = transparencySlider

local transparencyHint = Instance.new("TextLabel")
transparencyHint.Size = UDim2.new(0, 60, 0, 20)
transparencyHint.Position = UDim2.new(0, 160, 0, 190)
transparencyHint.BackgroundTransparency = 1
transparencyHint.TextColor3 = COLORS.textMuted
transparencyHint.Text = "(0-100%)"
transparencyHint.Font = Enum.Font.Gotham
transparencyHint.TextSize = 10
transparencyHint.TextXAlignment = Enum.TextXAlignment.Left
transparencyHint.Parent = settingsSection

-- Scale Slider
local scaleLabel = Instance.new("TextLabel")
scaleLabel.Size = UDim2.new(0, 90, 0, 20)
scaleLabel.Position = UDim2.new(0, 0, 0, 225)
scaleLabel.BackgroundTransparency = 1
scaleLabel.TextColor3 = COLORS.textDark
scaleLabel.Text = "GUI Scale:"
scaleLabel.Font = Enum.Font.Gotham
scaleLabel.TextSize = 11
scaleLabel.TextXAlignment = Enum.TextXAlignment.Left
scaleLabel.Parent = settingsSection

local scaleSlider = Instance.new("TextBox")
scaleSlider.Size = UDim2.new(0, 60, 0, 28)
scaleSlider.Position = UDim2.new(0, 95, 0, 221)
scaleSlider.BackgroundColor3 = COLORS.inputBg
scaleSlider.TextColor3 = COLORS.textDark
scaleSlider.Text = "1"
scaleSlider.Font = Enum.Font.Gotham
scaleSlider.TextSize = 12
scaleSlider.ClearTextOnFocus = false
scaleSlider.Parent = settingsSection

local scaleSliderCorner = Instance.new("UICorner")
scaleSliderCorner.CornerRadius = UDim.new(0, 6)
scaleSliderCorner.Parent = scaleSlider

local scaleSliderStroke = Instance.new("UIStroke")
scaleSliderStroke.Color = COLORS.border
scaleSliderStroke.Thickness = 1
scaleSliderStroke.Parent = scaleSlider

local scaleHint = Instance.new("TextLabel")
scaleHint.Size = UDim2.new(0, 60, 0, 20)
scaleHint.Position = UDim2.new(0, 160, 0, 225)
scaleHint.BackgroundTransparency = 1
scaleHint.TextColor3 = COLORS.textMuted
scaleHint.Text = "(0.5-2.0)"
scaleHint.Font = Enum.Font.Gotham
scaleHint.TextSize = 10
scaleHint.TextXAlignment = Enum.TextXAlignment.Left
scaleHint.Parent = settingsSection

-- ========== DRAGGING (HUB BUTTON) ==========

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

-- ========== DRAGGING (HUB FRAME) ==========

local hubDragging = false
local hubDragInput, hubDragStart, hubDragPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        hubDragging = true
        hubDragStart = input.Position
        hubDragPos = hubFrame.Position
        
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
        hubFrame.Position = UDim2.new(hubDragPos.X.Scale, hubDragPos.X.Offset + delta.X, hubDragPos.Y.Scale, hubDragPos.Y.Offset + delta.Y)
    end
end)

-- ========== TOGGLE HUB ==========

hubButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        wait(0.1)
        if not dragging then
            hubButton.Visible = false
            hubFrame.Visible = true
        end
    end
end)

collapseButton.MouseButton1Click:Connect(function()
    hubFrame.Visible = false
    hubButton.Visible = true
end)

-- ========== TAB SWITCHING ==========

local function switchTab(tabName)
    currentTab = tabName
    chatSection.Visible = tabName == "Chat"
    spamSection.Visible = tabName == "Spam"
    autoReplySection.Visible = tabName == "AutoReply"
    afkSection.Visible = tabName == "AFK"
    settingsSection.Visible = tabName == "Settings"
    
    for name, btn in pairs(tabButtons) do
        if name == tabName then
            btn.BackgroundColor3 = COLORS.buttonPrimary
            btn.TextColor3 = COLORS.textLight
        else
            btn.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
            btn.TextColor3 = COLORS.textDark
        end
    end
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

switchTab("Chat")

-- ========== CHARACTER LIMITS ==========

chatTextbox:GetPropertyChangedSignal("Text"):Connect(function()
    if #chatTextbox.Text > MAX_CHARS then
        chatTextbox.Text = chatTextbox.Text:sub(1, MAX_CHARS)
    end
    chatCharCounter.Text = #chatTextbox.Text.."/"..MAX_CHARS
    chatCharCounter.TextColor3 = #chatTextbox.Text >= MAX_CHARS and COLORS.buttonDanger or COLORS.textMuted
end)

replyInput:GetPropertyChangedSignal("Text"):Connect(function()
    local totalChars = #replyInput.Text
    if totalChars > 500 then
        replyInput.Text = replyInput.Text:sub(1, 500)
    end
    replyCharCounter.Text = totalChars.."/200"
    replyCharCounter.TextColor3 = totalChars >= 180 and COLORS.buttonDanger or COLORS.textMuted
end)

-- ========== TEXTBOX CLEAR ON FOCUS ==========

chatTextbox.Focused:Connect(function()
    chatTextbox.Text = ""
end)

targetInput.Focused:Connect(function()
    targetInput.Text = ""
end)

replyInput.Focused:Connect(function()
    replyInput.Text = ""
end)

-- ========== GET PREFIX ==========

local function getPrefix()
    if prefixMode == "OFF" then
        return ""
    elseif prefixMode == "FIXED" then
        return fixedPrefixInput.Text .. " "
    elseif prefixMode == "ROTATE" then
        local prefixes = rotatingPrefixInput.Text:split(" ")
        if #prefixes > 0 then
            local prefix = prefixes[rotatingIndex]
            rotatingIndex = rotatingIndex + 1
            if rotatingIndex > #prefixes then
                rotatingIndex = 1
            end
            return prefix .. " "
        end
    end
    return ""
end

-- ========== UPDATE PREFIX STATUS ==========

local function updatePrefixStatus()
    if prefixMode == "OFF" then
        prefixStatus.Text = "Prefix: OFF"
    elseif prefixMode == "FIXED" then
        prefixStatus.Text = "Prefix: " .. fixedPrefixInput.Text .. " (Fixed)"
    elseif prefixMode == "ROTATE" then
        prefixStatus.Text = "Prefix: Rotating"
    end
end

-- ========== SEND MESSAGE FUNCTION ==========

local function sendMessage(msg)
    local message = msg or chatTextbox.Text
    message = message:gsub("^%s+", ""):gsub("%s+$", ""):gsub("\n", " ")
    
    if message == "" or #message > MAX_CHARS then return false end
    
    local prefix = getPrefix()
    local finalMessage = prefix .. message
    
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(finalMessage, "All")
            return true
        end
    end
    
    local TextChatService = game:GetService("TextChatService")
    if TextChatService then
        local channel = TextChatService:FindFirstChild("TextChannels")
        if channel then
            local rbxGeneral = channel:FindFirstChild("RBXGeneral")
            if rbxGeneral then
                rbxGeneral:SendAsync(finalMessage)
                return true
            end
        end
    end
    
    return false
end

-- ========== SEND BUTTON ==========

sendButton.MouseButton1Click:Connect(function()
    if chatTextbox.Text ~= "" then
        sendMessage()
    end
end)

chatTextbox.FocusLost:Connect(function(enterPressed)
    if chatTextbox.Text ~= "" and enterPressed then
        sendMessage()
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Enter and chatTextbox:IsFocused() then
        if chatTextbox.Text ~= "" then
            sendMessage()
        end
    end
end)

-- ========== PREMADE MESSAGES ==========

local premadeExpanded = false

local function updatePremadeUI()
    for _, child in pairs(premadeScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    for i, msg in ipairs(premadeMessages) do
        local msgFrame = Instance.new("Frame")
        msgFrame.Size = UDim2.new(1, 0, 0, 28)
        msgFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        msgFrame.Parent = premadeScroll
        
        local msgCorner = Instance.new("UICorner")
        msgCorner.CornerRadius = UDim.new(0, 5)
        msgCorner.Parent = msgFrame
        
        local msgLabel = Instance.new("TextLabel")
        msgLabel.Size = UDim2.new(1, -35, 1, 0)
        msgLabel.Position = UDim2.new(0, 8, 0, 0)
        msgLabel.BackgroundTransparency = 1
        msgLabel.TextColor3 = COLORS.textDark
        msgLabel.Text = msg
        msgLabel.Font = Enum.Font.Gotham
        msgLabel.TextSize = 11
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.TextTruncate = Enum.TextTruncate.AtEnd
        msgLabel.Parent = msgFrame
        
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 24, 0, 22)
        deleteBtn.Position = UDim2.new(1, -28, 0.5, -11)
        deleteBtn.BackgroundColor3 = COLORS.buttonDanger
        deleteBtn.TextColor3 = COLORS.textLight
        deleteBtn.Text = "✕"
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.TextSize = 10
        deleteBtn.Parent = msgFrame
        
        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, 5)
        deleteCorner.Parent = deleteBtn
        
        deleteBtn.MouseButton1Click:Connect(function()
            table.remove(premadeMessages, i)
            updatePremadeUI()
        end)
    end
    
    premadeScroll.CanvasSize = UDim2.new(0, 0, 0, #premadeMessages * 33)
end

premadeToggle.MouseButton1Click:Connect(function()
    premadeExpanded = not premadeExpanded
    premadePanel.Visible = premadeExpanded
    premadeToggle.Text = premadeExpanded and "▲ Premade Messages" or "▼ Premade Messages"
    if premadeExpanded then updatePremadeUI() end
end)

addPremadeBtn.MouseButton1Click:Connect(function()
    local msg = chatTextbox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if msg ~= "" then
        table.insert(premadeMessages, msg)
        chatTextbox.Text = ""
        updatePremadeUI()
    end
end)

-- ========== SPAM TOGGLE ==========

spamToggle.MouseButton1Click:Connect(function()
    spamEnabled = not spamEnabled
    spamDelay = tonumber(spamDelayInput.Text) or 1
    if spamDelay < 0.1 then spamDelay = 0.1 end
    
    if spamEnabled then
        spamToggle.Text = "SPAM: ON"
        spamToggle.BackgroundColor3 = COLORS.buttonSuccess
        
        spawn(function()
            while spamEnabled do
                if #premadeMessages > 0 then
                    sendMessage(premadeMessages[spamIndex])
                    spamIndex = spamIndex + 1
                    if spamIndex > #premadeMessages then spamIndex = 1 end
                else
                    sendMessage(chatTextbox.Text)
                end
                wait(spamDelay)
            end
        end)
    else
        spamToggle.Text = "SPAM: OFF"
        spamToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

-- ========== AUTO-REPLY ==========

local function updateTargetsUI()
    for _, child in pairs(targetsScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local i = 0
    for username, data in pairs(autoReplyTargets) do
        i = i + 1
        local targetFrame = Instance.new("Frame")
        targetFrame.Size = UDim2.new(1, 0, 0, 40)
        targetFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        targetFrame.Parent = targetsScroll
        
        local targetCorner = Instance.new("UICorner")
        targetCorner.CornerRadius = UDim.new(0, 5)
        targetCorner.Parent = targetFrame
        
        local targetLabel = Instance.new("TextLabel")
        targetLabel.Size = UDim2.new(1, -35, 0, 16)
        targetLabel.Position = UDim2.new(0, 8, 0, 4)
        targetLabel.BackgroundTransparency = 1
        targetLabel.TextColor3 = COLORS.textDark
        targetLabel.Text = "@" .. username
        targetLabel.Font = Enum.Font.GothamBold
        targetLabel.TextSize = 11
        targetLabel.TextXAlignment = Enum.TextXAlignment.Left
        targetLabel.Parent = targetFrame
        
        local replyLabel = Instance.new("TextLabel")
        replyLabel.Size = UDim2.new(1, -35, 0, 16)
        replyLabel.Position = UDim2.new(0, 8, 0, 20)
        replyLabel.BackgroundTransparency = 1
        replyLabel.TextColor3 = COLORS.textMuted
        replyLabel.Text = table.concat(data.messages, " → "):sub(1, 45) .. "..."
        replyLabel.Font = Enum.Font.Gotham
        replyLabel.TextSize = 10
        replyLabel.TextXAlignment = Enum.TextXAlignment.Left
        replyLabel.Parent = targetFrame
        
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 24, 0, 24)
        deleteBtn.Position = UDim2.new(1, -28, 0.5, -12)
        deleteBtn.BackgroundColor3 = COLORS.buttonDanger
        deleteBtn.TextColor3 = COLORS.textLight
        deleteBtn.Text = "✕"
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.TextSize = 10
        deleteBtn.Parent = targetFrame
        
        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, 5)
        deleteCorner.Parent = deleteBtn
        
        deleteBtn.MouseButton1Click:Connect(function()
            autoReplyTargets[username] = nil
            updateTargetsUI()
        end)
    end
    
    targetsScroll.CanvasSize = UDim2.new(0, 0, 0, i * 45)
end

addTargetBtn.MouseButton1Click:Connect(function()
    local username = targetInput.Text:gsub("^%s+", ""):gsub("%s+$", ""):lower()
    local replies = {}
    
    for line in replyInput.Text:gmatch("[^\r\n]+") do
        local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
        if trimmed ~= "" then
            table.insert(replies, trimmed)
        end
    end
    
    if username ~= "" and #replies > 0 then
        autoReplyTargets[username] = {
            messages = replies,
            index = 1
        }
        targetInput.Text = ""
        replyInput.Text = ""
        updateTargetsUI()
    end
end)

autoReplyToggle.MouseButton1Click:Connect(function()
    autoReplyEnabled = not autoReplyEnabled
    
    if autoReplyEnabled then
        autoReplyToggle.Text = "AUTO-REPLY: ON"
        autoReplyToggle.BackgroundColor3 = COLORS.buttonSuccess
    else
        autoReplyToggle.Text = "AUTO-REPLY: OFF"
        autoReplyToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

-- ========== AUTO-REPLY MESSAGE DETECTION ==========

local function sendReply(msg)
    if #msg > MAX_CHARS then
        msg = msg:sub(1, MAX_CHARS)
    end
    
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(msg, "All")
            return true
        end
    end
    
    local TextChatService = game:GetService("TextChatService")
    if TextChatService then
        local channel = TextChatService:FindFirstChild("TextChannels")
        if channel then
            local rbxGeneral = channel:FindFirstChild("RBXGeneral")
            if rbxGeneral then
                rbxGeneral:SendAsync(msg)
                return true
            end
        end
    end
    
    return false
end

Players.PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg)
        if autoReplyEnabled and autoReplyTargets[plr.Name:lower()] then
            local data = autoReplyTargets[plr.Name:lower()]
            local reply = data.messages[data.index]
            data.index = data.index + 1
            if data.index > #data.messages then
                data.index = 1
            end
            sendReply(reply)
        end
    end)
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then
        plr.Chatted:Connect(function(msg)
            if autoReplyEnabled and autoReplyTargets[plr.Name:lower()] then
                local data = autoReplyTargets[plr.Name:lower()]
                local reply = data.messages[data.index]
                data.index = data.index + 1
                if data.index > #data.messages then
                    data.index = 1
                end
                sendReply(reply)
            end
        end)
    end
end

-- ========== ANTI-AFK ==========

afkToggle.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    
    if antiAfkEnabled then
        afkToggle.Text = "ANTI-AFK: ON"
        afkToggle.BackgroundColor3 = COLORS.buttonSuccess
    else
        afkToggle.Text = "ANTI-AFK: OFF"
        afkToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

spawn(function()
    while true do
        wait(60)
        if antiAfkEnabled then
            local vu = game:GetService("VirtualUser")
            vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            wait(0.1)
            vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end
    end
end)

-- ========== SETTINGS: PREFIX MODE ==========

for mode, btn in pairs(prefixModeButtons) do
    btn.MouseButton1Click:Connect(function()
        prefixMode = mode
        updatePrefixStatus()
        
        for m, b in pairs(prefixModeButtons) do
            if m == mode then
                b.BackgroundColor3 = COLORS.buttonPrimary
                b.TextColor3 = COLORS.textLight
            else
                b.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                b.TextColor3 = COLORS.textDark
            end
        end
    end)
end

fixedPrefixInput:GetPropertyChangedSignal("Text"):Connect(function()
    updatePrefixStatus()
end)

rotatingPrefixInput:GetPropertyChangedSignal("Text"):Connect(function()
    updatePrefixStatus()
end)

-- ========== SETTINGS: TRANSPARENCY ==========

transparencySlider.FocusLost:Connect(function()
    local val = tonumber(transparencySlider.Text) or 0
    val = math.clamp(val, 0, 100)
    transparencySlider.Text = tostring(val)
    guiTransparency = val / 100
    
    hubFrame.BackgroundTransparency = guiTransparency
    titleBar.BackgroundTransparency = guiTransparency
    titleBarFix.BackgroundTransparency = guiTransparency
end)

-- ========== SETTINGS: SCALE ==========

scaleSlider.FocusLost:Connect(function()
    local val = tonumber(scaleSlider.Text) or 1
    val = math.clamp(val, 0.5, 2.0)
    scaleSlider.Text = tostring(val)
    guiScale = val
    
    hubFrame.Size = UDim2.new(0, 500 * guiScale, 0, 300 * guiScale)
    hubFrame.Position = UDim2.new(0.5, -250 * guiScale, 0.5, -150 * guiScale)
end)

-- ========== TOGGLE WITH KEY ==========

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        if hubFrame.Visible then
            hubFrame.Visible = false
            hubButton.Visible = true
        else
            hubButton.Visible = not hubButton.Visible
        end
    end
end)

-- ========== INITIALIZE ==========

updatePremadeUI()
updateTargetsUI()
updatePrefixStatus()

print("✅ Chat Hub Loaded")
