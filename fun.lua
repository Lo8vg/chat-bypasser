-- KBL Chat Hub (Mobile Fixed - Complete)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- States
local states = {
    autoCaps = false,
    autoLower = false,
    spam = false,
    antiAFK = false
}

local spamDelay = 1
local antiAFKDelay = 60
local antiAFKMessage = "afk"
local lastMessages = {}
local maxHistory = 20
local lastSentMessage = ""

-- Colors
local COLORS = {
    background = Color3.fromRGB(15, 15, 20),
    header = Color3.fromRGB(25, 25, 35),
    card = Color3.fromRGB(30, 30, 40),
    accent = Color3.fromRGB(255, 60, 100),
    text = Color3.fromRGB(255, 255, 255),
    textMuted = Color3.fromRGB(150, 150, 160),
    success = Color3.fromRGB(80, 200, 120),
    danger = Color3.fromRGB(200, 80, 80)
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KBLChatHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========== HUB BUTTON ==========

local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 55, 0, 55)
hubButton.Position = UDim2.new(0, 20, 0.5, -27)
hubButton.BackgroundColor3 = COLORS.card
hubButton.BorderSizePixel = 2
hubButton.BorderColor3 = COLORS.accent
hubButton.Parent = screenGui

local hubButtonCorner = Instance.new("UICorner")
hubButtonCorner.CornerRadius = UDim.new(0, 12)
hubButtonCorner.Parent = hubButton

local hubButtonIcon = Instance.new("TextLabel")
hubButtonIcon.Size = UDim2.new(1, 0, 1, 0)
hubButtonIcon.BackgroundTransparency = 1
hubButtonIcon.TextColor3 = COLORS.text
hubButtonIcon.Text = "K"
hubButtonIcon.Font = Enum.Font.GothamBold
hubButtonIcon.TextSize = 28
hubButtonIcon.Parent = hubButton

-- ========== HUB FRAME ==========

local hubFrame = Instance.new("Frame")
hubFrame.Name = "HubFrame"
hubFrame.Size = UDim2.new(0, 500, 0, 300)
hubFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
hubFrame.BackgroundColor3 = COLORS.background
hubFrame.BorderSizePixel = 2
hubFrame.BorderColor3 = Color3.fromRGB(50, 50, 60)
hubFrame.Visible = false
hubFrame.Parent = screenGui

local hubFrameCorner = Instance.new("UICorner")
hubFrameCorner.CornerRadius = UDim.new(0, 16)
hubFrameCorner.Parent = hubFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
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
titleLabel.TextColor3 = COLORS.text
titleLabel.Text = "KBL Chat Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 35, 0, 28)
collapseButton.Position = UDim2.new(1, -45, 0.5, -14)
collapseButton.BackgroundColor3 = COLORS.danger
collapseButton.TextColor3 = COLORS.text
collapseButton.Text = "X"
collapseButton.Font = Enum.Font.GothamBold
collapseButton.TextSize = 14
collapseButton.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.Radius = UDim.new(0, 8)
collapseCorner.Parent = collapseButton

-- Tab Buttons Frame
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -30, 0, 32)
tabFrame.Position = UDim2.new(0, 15, 0, 50)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = hubFrame

-- Tab Buttons
local tabs = {"Main", "Tools", "Spam", "History"}
local tabButtons = {}
local currentTab = "Main"

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1/#tabs, -4, 1, 0)
    tabBtn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    tabBtn.BackgroundColor3 = i == 1 and COLORS.accent or COLORS.card
    tabBtn.TextColor3 = COLORS.text
    tabBtn.Text = tabName
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 11
    tabBtn.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.Radius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn
    
    tabButtons[tabName] = tabBtn
end

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -30, 1, -95)
contentFrame.Position = UDim2.new(0, 15, 0, 88)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = hubFrame

-- ========== MAIN SECTION ==========

local mainSection = Instance.new("Frame")
mainSection.Size = UDim2.new(1, 0, 1, 0)
mainSection.BackgroundTransparency = 1
mainSection.Visible = true
mainSection.Parent = contentFrame

-- Chat Input
local chatInput = Instance.new("TextBox")
chatInput.Size = UDim2.new(1, 0, 0, 45)
chatInput.BackgroundColor3 = COLORS.card
chatInput.TextColor3 = COLORS.text
chatInput.Text = ""
chatInput.PlaceholderText = "Type message here..."
chatInput.PlaceholderColor3 = COLORS.textMuted
chatInput.Font = Enum.Font.Gotham
chatInput.TextSize = 13
chatInput.TextXAlignment = Enum.TextXAlignment.Left
chatInput.TextYAlignment = Enum.TextYAlignment.Top
chatInput.MultiLine = true
chatInput.TextWrapped = true
chatInput.ClearTextOnFocus = false
chatInput.Parent = mainSection

local chatInputCorner = Instance.new("UICorner")
chatInputCorner.Radius = UDim.new(0, 8)
chatInputCorner.Parent = chatInput

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.Position = UDim2.new(0, 0, 0, 50)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = COLORS.accent
statusLabel.Text = "Mode: Normal"
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainSection

-- Button Row 1
local buttonRow1 = Instance.new("Frame")
buttonRow1.Size = UDim2.new(1, 0, 0, 35)
buttonRow1.Position = UDim2.new(0, 0, 0, 72)
buttonRow1.BackgroundTransparency = 1
buttonRow1.Parent = mainSection

-- Auto Caps Button
local autoCapsBtn = Instance.new("TextButton")
autoCapsBtn.Size = UDim2.new(0.5, -3, 1, 0)
autoCapsBtn.Position = UDim2.new(0, 0, 0, 0)
autoCapsBtn.BackgroundColor3 = COLORS.card
autoCapsBtn.TextColor3 = COLORS.text
autoCapsBtn.Text = "AUTO CAPS: OFF"
autoCapsBtn.Font = Enum.Font.GothamBold
autoCapsBtn.TextSize = 11
autoCapsBtn.Parent = buttonRow1

local autoCapsCorner = Instance.new("UICorner")
autoCapsCorner.Radius = UDim.new(0, 6)
autoCapsCorner.Parent = autoCapsBtn

-- Auto Lower Button
local autoLowerBtn = Instance.new("TextButton")
autoLowerBtn.Size = UDim2.new(0.5, -3, 1, 0)
autoLowerBtn.Position = UDim2.new(0.5, 3, 0, 0)
autoLowerBtn.BackgroundColor3 = COLORS.card
autoLowerBtn.TextColor3 = COLORS.text
autoLowerBtn.Text = "AUTO LOWER: OFF"
autoLowerBtn.Font = Enum.Font.GothamBold
autoLowerBtn.TextSize = 11
autoLowerBtn.Parent = buttonRow1

local autoLowerCorner = Instance.new("UICorner")
autoLowerCorner.Radius = UDim.new(0, 6)
autoLowerCorner.Parent = autoLowerBtn

-- Button Row 2
local buttonRow2 = Instance.new("Frame")
buttonRow2.Size = UDim2.new(1, 0, 0, 35)
buttonRow2.Position = UDim2.new(0, 0, 0, 112)
buttonRow2.BackgroundTransparency = 1
buttonRow2.Parent = mainSection

-- Send Button
local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0.5, -3, 1, 0)
sendBtn.Position = UDim2.new(0, 0, 0, 0)
sendBtn.BackgroundColor3 = COLORS.accent
sendBtn.TextColor3 = COLORS.text
sendBtn.Text = "SEND"
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 12
sendBtn.Parent = buttonRow2

local sendCorner = Instance.new("UICorner")
sendCorner.Radius = UDim.new(0, 6)
sendCorner.Parent = sendBtn

-- Clear Button
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.5, -3, 1, 0)
clearBtn.Position = UDim2.new(0.5, 3, 0, 0)
clearBtn.BackgroundColor3 = COLORS.danger
clearBtn.TextColor3 = COLORS.text
clearBtn.Text = "CLEAR"
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 12
clearBtn.Parent = buttonRow2

local clearCorner = Instance.new("UICorner")
clearCorner.Radius = UDim.new(0, 6)
clearCorner.Parent = clearBtn

-- Quick Messages Label
local quickLabel = Instance.new("TextLabel")
quickLabel.Size = UDim2.new(1, 0, 0, 18)
quickLabel.Position = UDim2.new(0, 0, 0, 152)
quickLabel.BackgroundTransparency = 1
quickLabel.TextColor3 = COLORS.textMuted
quickLabel.Text = "Quick Messages:"
quickLabel.Font = Enum.Font.GothamBold
quickLabel.TextSize = 10
quickLabel.TextXAlignment = Enum.TextXAlignment.Left
quickLabel.Parent = mainSection

-- Quick Messages
local quickMsgs = {"GG", "Hello!", "Nice!", "LOL", "WTF", "Bye", "EZ", "Good game", "Noob", "Ty", "Hacker", "Lag"}
local quickButtons = {}

for i, msg in ipairs(quickMsgs) do
    local row = math.floor((i-1)/6)
    local col = (i-1) % 6
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/6 - 3, 0, 0, 26)
    btn.Position = UDim2.new(col/6 + col*(3/470), 0, 0, 172 + row * 29)
    btn.BackgroundColor3 = COLORS.card
    btn.TextColor3 = COLORS.text
    btn.Text = msg
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 9
    btn.Parent = mainSection
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Radius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    quickButtons[btn] = msg
end

-- ========== TOOLS SECTION ==========

local toolsSection = Instance.new("Frame")
toolsSection.Size = UDim2.new(1, 0, 1, 0)
toolsSection.BackgroundTransparency = 1
toolsSection.Visible = false
toolsSection.Parent = contentFrame

-- Anti AFK Chat
local antiAFKBtn = Instance.new("TextButton")
antiAFKBtn.Size = UDim2.new(0.5, -3, 0, 40)
antiAFKBtn.BackgroundColor3 = COLORS.card
antiAFKBtn.TextColor3 = COLORS.text
antiAFKBtn.Text = "ANTI-AFK: OFF"
antiAFKBtn.Font = Enum.Font.GothamBold
antiAFKBtn.TextSize = 10
antiAFKBtn.Parent = toolsSection

local antiAFKCorner = Instance.new("UICorner")
antiAFKCorner.Radius = UDim.new(0, 6)
antiAFKCorner.Parent = antiAFKBtn

-- Anti AFK Delay
local antiAFKDelayRow = Instance.new("Frame")
antiAFKDelayRow.Size = UDim2.new(0.5, -3, 0, 40)
antiAFKDelayRow.Position = UDim2.new(0.5, 3, 0, 0)
antiAFKDelayRow.BackgroundTransparency = 1
antiAFKDelayRow.Parent = toolsSection

local antiAFKDelayLabel = Instance.new("TextLabel")
antiAFKDelayLabel.Size = UDim2.new(0, 50, 1, 0)
antiAFKDelayLabel.BackgroundTransparency = 1
antiAFKDelayLabel.TextColor3 = COLORS.text
antiAFKDelayLabel.Text = "Delay:"
antiAFKDelayLabel.Font = Enum.Font.Gotham
antiAFKDelayLabel.TextSize = 11
antiAFKDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
antiAFKDelayLabel.Parent = antiAFKDelayRow

local antiAFKDelayInput = Instance.new("TextBox")
antiAFKDelayInput.Size = UDim2.new(0, 50, 1, 0)
antiAFKDelayInput.Position = UDim2.new(0, 50, 0, 0)
antiAFKDelayInput.BackgroundColor3 = COLORS.card
antiAFKDelayInput.TextColor3 = COLORS.text
antiAFKDelayInput.Text = "60"
antiAFKDelayInput.Font = Enum.Font.Gotham
antiAFKDelayInput.TextSize = 11
antiAFKDelayInput.ClearTextOnFocus = false
antiAFKDelayInput.Parent = antiAFKDelayRow

local antiAFKDelayCorner = Instance.new("UICorner")
antiAFKDelayCorner.Radius = UDim.new(0, 6)
antiAFKDelayCorner.Parent = antiAFKDelayInput

-- Anti AFK Message
local antiAFKMsgRow = Instance.new("Frame")
antiAFKMsgRow.Size = UDim2.new(1, 0, 0, 35)
antiAFKMsgRow.Position = UDim2.new(0, 0, 0, 45)
antiAFKMsgRow.BackgroundTransparency = 1
antiAFKMsgRow.Parent = toolsSection

local antiAFKMsgLabel = Instance.new("TextLabel")
antiAFKMsgLabel.Size = UDim2.new(0, 60, 1, 0)
antiAFKMsgLabel.BackgroundTransparency = 1
antiAFKMsgLabel.TextColor3 = COLORS.text
antiAFKMsgLabel.Text = "Message:"
antiAFKMsgLabel.Font = Enum.Font.Gotham
antiAFKMsgLabel.TextSize = 11
antiAFKMsgLabel.TextXAlignment = Enum.TextXAlignment.Left
antiAFKMsgLabel.Parent = antiAFKMsgRow

local antiAFKMsgInput = Instance.new("TextBox")
antiAFKMsgInput.Size = UDim2.new(1, -65, 1, 0)
antiAFKMsgInput.Position = UDim2.new(0, 65, 0, 0)
antiAFKMsgInput.BackgroundColor3 = COLORS.card
antiAFKMsgInput.TextColor3 = COLORS.text
antiAFKMsgInput.Text = "afk"
antiAFKMsgInput.Font = Enum.Font.Gotham
antiAFKMsgInput.TextSize = 11
antiAFKMsgInput.ClearTextOnFocus = false
antiAFKMsgInput.Parent = antiAFKMsgRow

local antiAFKMsgCorner = Instance.new("UICorner")
antiAFKMsgCorner.Radius = UDim.new(0, 6)
antiAFKMsgCorner.Parent = antiAFKMsgInput

-- Repeat Last
local repeatBtn = Instance.new("TextButton")
repeatBtn.Size = UDim2.new(0.5, -3, 0, 40)
repeatBtn.Position = UDim2.new(0, 0, 0, 85)
repeatBtn.BackgroundColor3 = COLORS.card
repeatBtn.TextColor3 = COLORS.text
repeatBtn.Text = "REPEAT: OFF"
repeatBtn.Font = Enum.Font.GothamBold
repeatBtn.TextSize = 10
repeatBtn.Parent = toolsSection

local repeatCorner = Instance.new("UICorner")
repeatCorner.Radius = UDim.new(0, 6)
repeatCorner.Parent = repeatBtn

-- Repeat Count
local repeatCountRow = Instance.new("Frame")
repeatCountRow.Size = UDim2.new(0.5, -3, 0, 40)
repeatCountRow.Position = UDim2.new(0.5, 3, 0, 85)
repeatCountRow.BackgroundTransparency = 1
repeatCountRow.Parent = toolsSection

local repeatCountLabel = Instance.new("TextLabel")
repeatCountLabel.Size = UDim2.new(0, 70, 1, 0)
repeatCountLabel.BackgroundTransparency = 1
repeatCountLabel.TextColor3 = COLORS.text
repeatCountLabel.Text = "Count:"
repeatCountLabel.Font = Enum.Font.Gotham
repeatCountLabel.TextSize = 11
repeatCountLabel.TextXAlignment = Enum.TextXAlignment.Left
repeatCountLabel.Parent = repeatCountRow

local repeatCountInput = Instance.new("TextBox")
repeatCountInput.Size = UDim2.new(0, 50, 1, 0)
repeatCountInput.Position = UDim2.new(0, 70, 0, 0)
repeatCountInput.BackgroundColor3 = COLORS.card
repeatCountInput.TextColor3 = COLORS.text
repeatCountInput.Text = "5"
repeatCountInput.Font = Enum.Font.Gotham
repeatCountInput.TextSize = 11
repeatCountInput.ClearTextOnFocus = false
repeatCountInput.Parent = repeatCountRow

local repeatCountCorner = Instance.new("UICorner")
repeatCountCorner.Radius = UDim.new(0, 6)
repeatCountCorner.Parent = repeatCountInput

-- ========== SPAM SECTION ==========

local spamSection = Instance.new("Frame")
spamSection.Size = UDim2.new(1, 0, 1, 0)
spamSection.BackgroundTransparency = 1
spamSection.Visible = false
spamSection.Parent = contentFrame

-- Spam Input
local spamInput = Instance.new("TextBox")
spamInput.Size = UDim2.new(1, 0, 0, 50)
spamInput.BackgroundColor3 = COLORS.card
spamInput.TextColor3 = COLORS.text
spamInput.Text = ""
spamInput.PlaceholderText = "Message to spam..."
spamInput.PlaceholderColor3 = COLORS.textMuted
spamInput.Font = Enum.Font.Gotham
spamInput.TextSize = 12
spamInput.TextYAlignment = Enum.TextYAlignment.Top
spamInput.MultiLine = true
spamInput.TextWrapped = true
spamInput.ClearTextOnFocus = false
spamInput.Parent = spamSection

local spamInputCorner = Instance.new("UICorner")
spamInputCorner.Radius = UDim.new(0, 8)
spamInputCorner.Parent = spamInput

-- Spam Toggle
local spamToggle = Instance.new("TextButton")
spamToggle.Size = UDim2.new(0.5, -3, 0, 45)
spamToggle.Position = UDim2.new(0, 0, 0, 55)
spamToggle.BackgroundColor3 = COLORS.danger
spamToggle.TextColor3 = COLORS.text
spamToggle.Text = "SPAM: OFF"
spamToggle.Font = Enum.Font.GothamBold
spamToggle.TextSize = 14
spamToggle.Parent = spamSection

local spamToggleCorner = Instance.new("UICorner")
spamToggleCorner.Radius = UDim.new(0, 6)
spamToggleCorner.Parent = spamToggle

-- Spam Delay
local spamDelayRow = Instance.new("Frame")
spamDelayRow.Size = UDim2.new(0.5, -3, 0, 45)
spamDelayRow.Position = UDim2.new(0.5, 3, 0, 55)
spamDelayRow.BackgroundTransparency = 1
spamDelayRow.Parent = spamSection

local spamDelayLabel = Instance.new("TextLabel")
spamDelayLabel.Size = UDim2.new(0, 50, 1, 0)
spamDelayLabel.BackgroundTransparency = 1
spamDelayLabel.TextColor3 = COLORS.text
spamDelayLabel.Text = "Delay:"
spamDelayLabel.Font = Enum.Font.Gotham
spamDelayLabel.TextSize = 12
spamDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
spamDelayLabel.Parent = spamDelayRow

local spamDelayInput = Instance.new("TextBox")
spamDelayInput.Size = UDim2.new(0, 50, 1, 0)
spamDelayInput.Position = UDim2.new(0, 50, 0, 0)
spamDelayInput.BackgroundColor3 = COLORS.card
spamDelayInput.TextColor3 = COLORS.text
spamDelayInput.Text = "1"
spamDelayInput.Font = Enum.Font.Gotham
spamDelayInput.TextSize = 12
spamDelayInput.ClearTextOnFocus = false
spamDelayInput.Parent = spamDelayRow

local spamDelayCorner = Instance.new("UICorner")
spamDelayCorner.Radius = UDim.new(0, 6)
spamDelayCorner.Parent = spamDelayInput

-- Spam Mode Label
local spamModeLabel = Instance.new("TextLabel")
spamModeLabel.Size = UDim2.new(1, 0, 0, 18)
spamModeLabel.Position = UDim2.new(0, 0, 0, 105)
spamModeLabel.BackgroundTransparency = 1
spamModeLabel.TextColor3 = COLORS.textMuted
spamModeLabel.Text = "Spam Mode:"
spamModeLabel.Font = Enum.Font.GothamBold
spamModeLabel.TextSize = 11
spamModeLabel.TextXAlignment = Enum.TextXAlignment.Left
spamModeLabel.Parent = spamSection

-- Spam Mode Buttons
local spamModes = {"Normal", "CAPS", "lower", "AlTeRn"}
local spamModeBtns = {}
local currentSpamMode = "Normal"

for i, mode in ipairs(spamModes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#spamModes - 3, 0, 0, 32)
    btn.Position = UDim2.new((i-1)/#spamModes + (i-1)*(3/470), 0, 0, 125)
    btn.BackgroundColor3 = i == 1 and COLORS.accent or COLORS.card
    btn.TextColor3 = COLORS.text
    btn.Text = mode
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 10
    btn.Parent = spamSection
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Radius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    spamModeBtns[mode] = btn
end

-- Warning
local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, 0, 0, 40)
warningLabel.Position = UDim2.new(0, 0, 0, 165)
warningLabel.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
warningLabel.TextColor3 = COLORS.text
warningLabel.Text = "WARNING: Spam may get you kicked!"
warningLabel.Font = Enum.Font.Gotham
warningLabel.TextSize = 11
warningLabel.TextWrapped = true
warningLabel.Parent = spamSection

local warningCorner = Instance.new("UICorner")
warningCorner.Radius = UDim.new(0, 6)
warningCorner.Parent = warningLabel

-- ========== HISTORY SECTION ==========

local historySection = Instance.new("Frame")
historySection.Size = UDim2.new(1, 0, 1, 0)
historySection.BackgroundTransparency = 1
historySection.Visible = false
historySection.Parent = contentFrame

-- History Label
local historyLabel = Instance.new("TextLabel")
historyLabel.Size = UDim2.new(1, 0, 0, 18)
historyLabel.BackgroundTransparency = 1
historyLabel.TextColor3 = COLORS.textMuted
historyLabel.Text = "Recent Messages (Tap to resend):"
historyLabel.Font = Enum.Font.GothamBold
historyLabel.TextSize = 11
historyLabel.TextXAlignment = Enum.TextXAlignment.Left
historyLabel.Parent = historySection

-- Clear History Button
local clearHistoryBtn = Instance.new("TextButton")
clearHistoryBtn.Size = UDim2.new(0, 70, 0, 20)
clearHistoryBtn.Position = UDim2.new(1, -75, 0, 0)
clearHistoryBtn.BackgroundColor3 = COLORS.danger
clearHistoryBtn.TextColor3 = COLORS.text
clearHistoryBtn.Text = "Clear All"
clearHistoryBtn.Font = Enum.Font.GothamBold
clearHistoryBtn.TextSize = 9
clearHistoryBtn.Parent = historySection

local clearHistoryCorner = Instance.new("UICorner")
clearHistoryCorner.Radius = UDim.new(0, 4)
clearHistoryCorner.Parent = clearHistoryBtn

-- History Scroll
local historyScroll = Instance.new("ScrollingFrame")
historyScroll.Size = UDim2.new(1, 0, 1, -25)
historyScroll.Position = UDim2.new(0, 0, 0, 25)
historyScroll.BackgroundColor3 = COLORS.card
historyScroll.ScrollBarThickness = 4
historyScroll.ScrollBarImageColor3 = COLORS.textMuted
historyScroll.Parent = historySection

local historyScrollCorner = Instance.new("UICorner")
historyScrollCorner.Radius = UDim.new(0, 6)
historyScrollCorner.Parent = historyScroll

local historyLayout = Instance.new("UIListLayout")
historyLayout.Padding = UDim.new(0, 3)
historyLayout.Parent = historyScroll

-- ========== DRAGGING FOR HUB BUTTON ==========

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

-- ========== DRAGGING FOR HUB FRAME ==========

local hubDragging = false
local hubDragInput, hubDragStart, hubDragPos

hubFrame.InputBegan:Connect(function(input)
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

hubFrame.InputChanged:Connect(function(input)
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
    mainSection.Visible = tabName == "Main"
    toolsSection.Visible = tabName == "Tools"
    spamSection.Visible = tabName == "Spam"
    historySection.Visible = tabName == "History"
    
    for name, btn in pairs(tabButtons) do
        if name == tabName then
            btn.BackgroundColor3 = COLORS.accent
        else
            btn.BackgroundColor3 = COLORS.card
        end
    end
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- ========== SEND MESSAGE FUNCTION ==========

local function sendMessage(msg)
    local message = msg or chatInput.Text
    message = message:gsub("^%s+", ""):gsub("%s+\$", ""):gsub("\n", " ")
    
    if message == "" then return false end
    
    lastSentMessage = message
    
    -- Add to history
    for i, m in ipairs(lastMessages) do
        if m == message then
            table.remove(lastMessages, i)
            break
        end
    end
    table.insert(lastMessages, 1, message)
    if #lastMessages > maxHistory then
        table.remove(lastMessages)
    end
    
    -- Update history UI
    for _, child in pairs(historyScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for i, m in ipairs(lastMessages) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -6, 0, 28)
        btn.BackgroundColor3 = COLORS.background
        btn.TextColor3 = COLORS.text
        btn.Text = string.sub(m, 1, 45) .. (#m > 45 and "..." or "")
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 10
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = historyScroll
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.Radius = UDim.new(0, 4)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            chatInput.Text = m
        end)
    end
    
    historyScroll.CanvasSize = UDim2.new(0, 0, 0, #lastMessages * 31)
    
    -- Try TextChatService first
    local TCS = game:GetService("TextChatService")
    if TCS then
        local channel = TCS:FindFirstChild("TextChannels")
        if channel then
            local rbxGeneral = channel:FindFirstChild("RBXGeneral")
            if rbxGeneral then
                rbxGeneral:SendAsync(message)
                return true
            end
        end
    end
    
    -- Try DefaultChatSystem
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(message, "All")
            return true
        end
    end
    
    -- Fallback
    local sayMessageRemote = ReplicatedStorage:FindFirstChild("SayMessageRequest")
    if sayMessageRemote then
        sayMessageRemote:FireServer(message, "All")
        return true
    end
    
    return false
end

-- ========== PROCESS MESSAGE ==========

local function processMessage(message, mode)
    if mode == "CAPS" then
        return message:upper()
    elseif mode == "lower" then
        return message:lower()
    elseif mode == "AlTeRn" then
        local result = ""
        for i = 1, #message do
            if i % 2 == 0 then
                result = result .. message:sub(i, i):upper()
            else
                result = result .. message:sub(i, i):lower()
            end
        end
        return result
    end
    return message
end

-- ========== TOGGLE BUTTON HELPER ==========

local function toggleBtn(btn, state, onText, offText)
    btn.Text = state and onText or offText
    btn.BackgroundColor3 = state and COLORS.success or COLORS.card
end

-- ========== BUTTON FUNCTIONS ==========

autoCapsBtn.MouseButton1Click:Connect(function()
    states.autoCaps = not states.autoCaps
    if states.autoCaps then states.autoLower = false end
    toggleBtn(autoCapsBtn, states.autoCaps, "AUTO CAPS: ON", "AUTO CAPS: OFF")
    toggleBtn(autoLowerBtn, states.autoLower, "AUTO LOWER: ON", "AUTO LOWER: OFF")
    statusLabel.Text = states.autoCaps and "Mode: ALL CAPS" or (states.autoLower and "Mode: all lower" or "Mode: Normal")
end)

autoLowerBtn.MouseButton1Click:Connect(function()
    states.autoLower = not states.autoLower
    if states.autoLower then states.autoCaps = false end
    toggleBtn(autoLowerBtn, states.autoLower, "AUTO LOWER: ON", "AUTO LOWER: OFF")
    toggleBtn(autoCapsBtn, states.autoCaps, "AUTO CAPS: ON", "AUTO CAPS: OFF")
    statusLabel.Text = states.autoLower and "Mode: all lower" or (states.autoCaps and "Mode: ALL CAPS" or "Mode: Normal")
end)

sendBtn.MouseButton1Click:Connect(function()
    local msg = chatInput.Text
    if msg ~= "" then
        if states.autoCaps then
            msg = msg:upper()
        elseif states.autoLower then
            msg = msg:lower()
        end
        sendMessage(msg)
        chatInput.Text = ""
    end
end)

clearBtn.MouseButton1Click:Connect(function()
    chatInput.Text = ""
end)

chatInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and chatInput.Text ~= "" then
        local msg = chatInput.Text
            if states.autoCaps then
            msg = msg:upper()
        elseif states.autoLower then
            msg = msg:lower()
        end
        sendMessage(msg)
        chatInput.Text = ""
    end
end)

for btn, msg in pairs(quickButtons) do
    btn.MouseButton1Click:Connect(function()
        local finalMsg = msg
        if states.autoCaps then
            finalMsg = finalMsg:upper()
        elseif states.autoLower then
            finalMsg = finalMsg:lower()
        end
        sendMessage(finalMsg)
    end)
end

antiAFKBtn.MouseButton1Click:Connect(function()
    states.antiAFK = not states.antiAFK
    toggleBtn(antiAFKBtn, states.antiAFK, "ANTI-AFK: ON", "ANTI-AFK: OFF")
    
    if states.antiAFK then
        local delay = tonumber(antiAFKDelayInput.Text) or 60
        local msg = antiAFKMsgInput.Text ~= "" and antiAFKMsgInput.Text or "afk"
        
        spawn(function()
            while states.antiAFK do
                wait(delay)
                if states.antiAFK then
                    sendMessage(msg)
                end
            end
        end)
    end
end)

local repeatState = false

repeatBtn.MouseButton1Click:Connect(function()
    if lastSentMessage == "" then
        statusLabel.Text = "No message to repeat!"
        return
    end
    
    repeatState = not repeatState
    toggleBtn(repeatBtn, repeatState, "REPEAT: ON", "REPEAT: OFF")
    
    if repeatState then
        local count = tonumber(repeatCountInput.Text) or 5
        spawn(function()
            for i = 1, count do
                if not repeatState then break end
                sendMessage(lastSentMessage)
                wait(0.5)
            end
            repeatState = false
            toggleBtn(repeatBtn, false, "REPEAT: ON", "REPEAT: OFF")
        end)
    end
end)

spamToggle.MouseButton1Click:Connect(function()
    states.spam = not states.spam
    spamToggle.Text = states.spam and "SPAM: ON" or "SPAM: OFF"
    spamToggle.BackgroundColor3 = states.spam and COLORS.success or COLORS.danger
    
    if states.spam then
        local msg = spamInput.Text
        if msg ~= "" then
            local delay = tonumber(spamDelayInput.Text) or 1
            if delay < 0.1 then delay = 0.1 end
            
            spawn(function()
                while states.spam do
                    local finalMsg = processMessage(msg, currentSpamMode)
                    sendMessage(finalMsg)
                    wait(delay)
                end
            end)
        else
            states.spam = false
            spamToggle.Text = "SPAM: OFF"
            spamToggle.BackgroundColor3 = COLORS.danger
        end
    end
end)

for mode, btn in pairs(spamModeBtns) do
    btn.MouseButton1Click:Connect(function()
        currentSpamMode = mode
        for m, b in pairs(spamModeBtns) do
            b.BackgroundColor3 = m == mode and COLORS.accent or COLORS.card
        end
    end)
end

clearHistoryBtn.MouseButton1Click:Connect(function()
    lastMessages = {}
    for _, child in pairs(historyScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end)

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

print("KBL Chat Hub Loaded - Tap the K button to open!")
