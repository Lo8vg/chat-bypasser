-- KBL Chat Hub

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KBLChatHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Colors
local COLORS = {
    bg = Color3.fromRGB(15, 15, 20),
    header = Color3.fromRGB(25, 25, 35),
    card = Color3.fromRGB(30, 30, 40),
    accent = Color3.fromRGB(255, 60, 100),
    accent2 = Color3.fromRGB(255, 120, 50),
    text = Color3.fromRGB(255, 255, 255),
    textMuted = Color3.fromRGB(150, 150, 160),
    success = Color3.fromRGB(80, 200, 120),
    danger = Color3.fromRGB(200, 80, 80)
}

-- States
local states = {
    autoCaps = false,
    autoLower = false,
    spam = false,
    antiAFK = false,
    fakeBubble = false,
    rainbowName = false
}

local spamDelay = 1
local antiAFKDelay = 60
local antiAFKMessage = "afk"
local lastMessages = {}
local maxHistory = 20
local spamConnection = nil
local antiAFKConnection = nil
local rainbowConnection = nil

-- ========== HUB BUTTON ==========
local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 50, 0, 50)
hubButton.Position = UDim2.new(0, 15, 0.5, -25)
hubButton.BackgroundColor3 = COLORS.accent
hubButton.Visible = true
hubButton.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 12)
hubCorner.Parent = hubButton

local hubGradient = Instance.new("UIGradient")
hubGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, COLORS.accent), ColorSequenceKeypoint.new(1, COLORS.accent2)})
hubGradient.Rotation = 45
hubGradient.Parent = hubButton

local hubIcon = Instance.new("TextLabel")
hubIcon.Size = UDim2.new(1, 0, 1, 0)
hubIcon.BackgroundTransparency = 1
hubIcon.TextColor3 = COLORS.text
hubIcon.Text = "K"
hubIcon.Font = Enum.Font.GothamBold
hubIcon.TextSize = 24
hubIcon.Parent = hubButton

-- ========== MAIN FRAME ==========
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 320)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
mainFrame.BackgroundColor3 = COLORS.bg
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(50, 50, 60)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = COLORS.header
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 12)
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = COLORS.header
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleGradient = Instance.new("Frame")
titleGradient.Size = UDim2.new(1, 0, 0, 3)
titleGradient.Position = UDim2.new(0, 0, 1, -3)
titleGradient.BackgroundColor3 = COLORS.accent
titleGradient.BorderSizePixel = 0
titleGradient.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = COLORS.text
titleLabel.Text = "💬 KBL Chat Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local collapseBtn = Instance.new("TextButton")
collapseBtn.Size = UDim2.new(0, 28, 0, 22)
collapseBtn.Position = UDim2.new(1, -35, 0.5, -11)
collapseBtn.BackgroundColor3 = COLORS.danger
collapseBtn.TextColor3 = COLORS.text
collapseBtn.Text = "×"
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.TextSize = 12
collapseBtn.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseBtn

-- ========== TAB BUTTONS ==========
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 28)
tabFrame.Position = UDim2.new(0, 10, 0, 42)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabs = {"Main", "Tools", "Spam", "History", "Log"}
local tabButtons = {}
local currentTab = "Main"

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1/#tabs, -3, 1, 0)
    tabBtn.Position = UDim2.new((i-1)/#tabs + (i-1)*(3/500), 0, 0, 0)
    tabBtn.BackgroundColor3 = i == 1 and COLORS.accent or COLORS.card
    tabBtn.TextColor3 = COLORS.text
    tabBtn.Text = tabName
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 9
    tabBtn.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn
    
    tabButtons[tabName] = tabBtn
end

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -80)
contentFrame.Position = UDim2.new(0, 10, 0, 75)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ========== MAIN TAB ==========
local mainSection = Instance.new("Frame")
mainSection.Size = UDim2.new(1, 0, 1, 0)
mainSection.BackgroundTransparency = 1
mainSection.Visible = true
mainSection.Parent = contentFrame

-- Chat Input
local chatInput = Instance.new("TextBox")
chatInput.Size = UDim2.new(1, 0, 0, 35)
chatInput.BackgroundColor3 = COLORS.card
chatInput.TextColor3 = COLORS.text
chatInput.Text = ""
chatInput.PlaceholderText = "Type message here..."
chatInput.PlaceholderColor3 = COLORS.textMuted
chatInput.Font = Enum.Font.Gotham
chatInput.TextSize = 12
chatInput.Parent = mainSection

local chatInputCorner = Instance.new("UICorner")
chatInputCorner.CornerRadius = UDim.new(0, 8)
chatInputCorner.Parent = chatInput

-- Auto Caps Toggle
local autoCapsBtn = Instance.new("TextButton")
autoCapsBtn.Size = UDim2.new(0.5, -3, 0, 32)
autoCapsBtn.Position = UDim2.new(0, 0, 0, 40)
autoCapsBtn.BackgroundColor3 = COLORS.card
autoCapsBtn.TextColor3 = COLORS.text
autoCapsBtn.Text = "🔺 AUTO CAPS: OFF"
autoCapsBtn.Font = Enum.Font.GothamBold
autoCapsBtn.TextSize = 10
autoCapsBtn.Parent = mainSection

local autoCapsCorner = Instance.new("UICorner")
autoCapsCorner.CornerRadius = UDim.new(0, 6)
autoCapsCorner.Parent = autoCapsBtn

-- Auto Lower Toggle
local autoLowerBtn = Instance.new("TextButton")
autoLowerBtn.Size = UDim2.new(0.5, -3, 0, 32)
autoLowerBtn.Position = UDim2.new(0.5, 3, 0, 40)
autoLowerBtn.BackgroundColor3 = COLORS.card
autoLowerBtn.TextColor3 = COLORS.text
autoLowerBtn.Text = "🔻 AUTO LOWER: OFF"
autoLowerBtn.Font = Enum.Font.GothamBold
autoLowerBtn.TextSize = 10
autoLowerBtn.Parent = mainSection

local autoLowerCorner = Instance.new("UICorner")
autoLowerCorner.CornerRadius = UDim.new(0, 6)
autoLowerCorner.Parent = autoLowerBtn

-- Send Button
local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0.5, -3, 0, 32)
sendBtn.Position = UDim2.new(0, 0, 0, 77)
sendBtn.BackgroundColor3 = COLORS.accent
sendBtn.TextColor3 = COLORS.text
sendBtn.Text = "📤 SEND"
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 11
sendBtn.Parent = mainSection

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 6)
sendCorner.Parent = sendBtn

-- Clear Input Button
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.5, -3, 0, 32)
clearBtn.Position = UDim2.new(0.5, 3, 0, 77)
clearBtn.BackgroundColor3 = COLORS.card
clearBtn.TextColor3 = COLORS.text
clearBtn.Text = "🗑️ CLEAR"
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 11
clearBtn.Parent = mainSection

local clearCorner = Instance.new("UICorner")
clearCorner.Radius = UDim.new(0, 6)
clearCorner.Parent = clearBtn

-- Quick Messages
local quickLabel = Instance.new("TextLabel")
quickLabel.Size = UDim2.new(1, 0, 0, 18)
quickLabel.Position = UDim2.new(0, 0, 0, 115)
quickLabel.BackgroundTransparency = 1
quickLabel.TextColor3 = COLORS.textMuted
quickLabel.Text = "Quick Messages:"
quickLabel.Font = Enum.Font.GothamBold
quickLabel.TextSize = 10
quickLabel.TextXAlignment = Enum.TextXAlignment.Left
quickLabel.Parent = mainSection

local quickMsgs = {"GG", "Hello!", "Nice try", "LOL", "WTF", "Bye", "EZ", "Good game", "Noob", "Hack?", "Lag", "Ty"}
for i, msg in ipairs(quickMsgs) do
    local row = math.floor((i-1)/6)
    local col = (i-1) % 6
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/6 - 3, 0, 0, 25)
    btn.Position = UDim2.new(col/6 + col*(3/480), 0, 0, 135 + row * 28)
    btn.BackgroundColor3 = COLORS.card
    btn.TextColor3 = COLORS.text
    btn.Text = msg
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 9
    btn.Parent = mainSection
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
end

-- ========== TOOLS TAB ==========
local toolsSection = Instance.new("Frame")
toolsSection.Size = UDim2.new(1, 0, 1, 0)
toolsSection.BackgroundTransparency = 1
toolsSection.Visible = false
toolsSection.Parent = contentFrame

-- Anti AFK Chat
local antiAFKBtn = Instance.new("TextButton")
antiAFKBtn.Size = UDim2.new(0.5, -3, 0, 35)
antiAFKBtn.BackgroundColor3 = COLORS.card
antiAFKBtn.TextColor3 = COLORS.text
antiAFKBtn.Text = "💤 ANTI-AFK CHAT: OFF"
antiAFKBtn.Font = Enum.Font.GothamBold
antiAFKBtn.TextSize = 9
antiAFKBtn.Parent = toolsSection

local antiAFKCorner = Instance.new("UICorner")
antiAFKCorner.CornerRadius = UDim.new(0, 6)
antiAFKCorner.Parent = antiAFKBtn

-- Anti AFK Delay Input
local antiAFKDelayRow = Instance.new("Frame")
antiAFKDelayRow.Size = UDim2.new(0.5, -3, 0, 35)
antiAFKDelayRow.Position = UDim2.new(0.5, 3, 0, 0)
antiAFKDelayRow.BackgroundTransparency = 1
antiAFKDelayRow.Parent = toolsSection

local antiAFKDelayLabel = Instance.new("TextLabel")
antiAFKDelayLabel.Size = UDim2.new(0, 50, 1, 0)
antiAFKDelayLabel.BackgroundTransparency = 1
antiAFKDelayLabel.TextColor3 = COLORS.text
antiAFKDelayLabel.Text = "Delay:"
antiAFKDelayLabel.Font = Enum.Font.Gotham
antiAFKDelayLabel.TextSize = 10
antiAFKDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
antiAFKDelayLabel.Parent = antiAFKDelayRow

local antiAFKDelayInput = Instance.new("TextBox")
antiAFKDelayInput.Size = UDim2.new(0, 40, 1, 0)
antiAFKDelayInput.Position = UDim2.new(0, 50, 0, 0)
antiAFKDelayInput.BackgroundColor3 = COLORS.card
antiAFKDelayInput.TextColor3 = COLORS.text
antiAFKDelayInput.Text = "60"
antiAFKDelayInput.Font = Enum.Font.Gotham
antiAFKDelayInput.TextSize = 10
antiAFKDelayInput.Parent = antiAFKDelayRow

local antiAFKDelayCorner = Instance.new("UICorner")
antiAFKDelayCorner.CornerRadius = UDim.new(0, 4)
antiAFKDelayCorner.Parent = antiAFKDelayInput

local antiAFKDelaySec = Instance.new("TextLabel")
antiAFKDelaySec.Size = UDim2.new(0, 30, 1, 0)
antiAFKDelaySec.Position = UDim2.new(0, 95, 0, 0)
antiAFKDelaySec.BackgroundTransparency = 1
antiAFKDelaySec.TextColor3 = COLORS.textMuted
antiAFKDelaySec.Text = "sec"
antiAFKDelaySec.Font = Enum.Font.Gotham
antiAFKDelaySec.TextSize = 10
antiAFKDelaySec.Parent = antiAFKDelayRow

-- Anti AFK Message Input
local antiAFKMsgRow = Instance.new("Frame")
antiAFKMsgRow.Size = UDim2.new(1, 0, 0, 30)
antiAFKMsgRow.Position = UDim2.new(0, 0, 0, 40)
antiAFKMsgRow.BackgroundTransparency = 1
antiAFKMsgRow.Parent = toolsSection

local antiAFKMsgLabel = Instance.new("TextLabel")
antiAFKMsgLabel.Size = UDim2.new(0, 60, 1, 0)
antiAFKMsgLabel.BackgroundTransparency = 1
antiAFKMsgLabel.TextColor3 = COLORS.text
antiAFKMsgLabel.Text = "AFK Msg:"
antiAFKMsgLabel.Font = Enum.Font.Gotham
antiAFKMsgLabel.TextSize = 10
antiAFKMsgLabel.TextXAlignment = Enum.TextXAlignment.Left
antiAFKMsgLabel.Parent = antiAFKMsgRow

local antiAFKMsgInput = Instance.new("TextBox")
antiAFKMsgInput.Size = UDim2.new(1, -65, 1, 0)
antiAFKMsgInput.Position = UDim2.new(0, 65, 0, 0)
antiAFKMsgInput.BackgroundColor3 = COLORS.card
antiAFKMsgInput.TextColor3 = COLORS.text
antiAFKMsgInput.Text = "im afk"
antiAFKMsgInput.Font = Enum.Font.Gotham
antiAFKMsgInput.TextSize = 10
antiAFKMsgInput.Parent = antiAFKMsgRow

local antiAFKMsgCorner = Instance.new("UICorner")
antiAFKMsgCorner.CornerRadius = UDim.new(0, 4)
antiAFKMsgCorner.Parent = antiAFKMsgInput

-- Fake Bubble Chat
local fakeBubbleBtn = Instance.new("TextButton")
fakeBubbleBtn.Size = UDim2.new(0.5, -3, 0, 35)
fakeBubbleBtn.Position = UDim2.new(0, 0, 0, 75)
fakeBubbleBtn.BackgroundColor3 = COLORS.card
fakeBubbleBtn.TextColor3 = COLORS.text
fakeBubbleBtn.Text = "💬 FAKE BUBBLE: OFF"
fakeBubbleBtn.Font = Enum.Font.GothamBold
fakeBubbleBtn.TextSize = 9
fakeBubbleBtn.Parent = toolsSection

local fakeBubbleCorner = Instance.new("UICorner")
fakeBubbleCorner.CornerRadius = UDim.new(0, 6)
fakeBubbleCorner.Parent = fakeBubbleBtn

-- Fake Bubble Input
local fakeBubbleInput = Instance.new("TextBox")
fakeBubbleInput.Size = UDim2.new(0.5, -3, 0, 35)
fakeBubbleInput.Position = UDim2.new(0.5, 3, 0, 75)
fakeBubbleInput.BackgroundColor3 = COLORS.card
fakeBubbleInput.TextColor3 = COLORS.text
fakeBubbleInput.Text = "Fake message!"
fakeBubbleInput.Font = Enum.Font.Gotham
fakeBubbleInput.TextSize = 10
fakeBubbleInput.Parent = toolsSection

local fakeBubbleInputCorner = Instance.new("UICorner")
fakeBubbleInputCorner.CornerRadius = UDim.new(0, 6)
fakeBubbleInputCorner.Parent = fakeBubbleInput

-- Rainbow Name
local rainbowNameBtn = Instance.new("TextButton")
rainbowNameBtn.Size = UDim2.new(0.5, -3, 0, 35)
rainbowNameBtn.Position = UDim2.new(0, 0, 0, 115)
rainbowNameBtn.BackgroundColor3 = COLORS.card
rainbowNameBtn.TextColor3 = COLORS.text
rainbowNameBtn.Text = "🌈 RAINBOW NAME: OFF"
rainbowNameBtn.Font = Enum.Font.GothamBold
rainbowNameBtn.TextSize = 9
rainbowNameBtn.Parent = toolsSection

local rainbowNameCorner = Instance.new("UICorner")
rainbowNameCorner.CornerRadius = UDim.new(0, 6)
rainbowNameCorner.Parent = rainbowNameBtn

-- Fake Lag Chat
local fakeLagChatBtn = Instance.new("TextButton")
fakeLagChatBtn.Size = UDim2.new(0.5, -3, 0, 35)
fakeLagChatBtn.Position = UDim2.new(0.5, 3, 0, 115)
fakeLagChatBtn.BackgroundColor3 = COLORS.card
fakeLagChatBtn.TextColor3 = COLORS.text
fakeLagChatBtn.Text = "📶 FAKE LAG CHAT: OFF"
fakeLagChatBtn.Font = Enum.Font.GothamBold
fakeLagChatBtn.TextSize = 9
fakeLagChatBtn.Parent = toolsSection

local fakeLagChatCorner = Instance.new("UICorner")
fakeLagChatCorner.CornerRadius = UDim.new(0, 6)
fakeLagChatCorner.Parent = fakeLagChatBtn

-- Commands Help
local helpLabel = Instance.new("TextLabel")
helpLabel.Size = UDim2.new(1, 0, 0, 60)
helpLabel.Position = UDim2.new(0, 0, 0, 160)
helpLabel.BackgroundTransparency = 1
helpLabel.TextColor3 = COLORS.textMuted
helpLabel.Text = "💡 Tips:\n• Auto Caps/Lower works when you send\n• Fake Bubble shows above your head (only you see)\n• Anti-AFK sends message every X seconds"
helpLabel.Font = Enum.Font.Gotham
helpLabel.TextSize = 9
helpLabel.TextXAlignment = Enum.TextXAlignment.Left
helpLabel.TextYAlignment = Enum.TextYAlignment.Top
helpLabel.Parent = toolsSection

-- ========== SPAM TAB ==========
local spamSection = Instance.new("Frame")
spamSection.Size = UDim2.new(1, 0, 1, 0)
spamSection.BackgroundTransparency = 1
spamSection.Visible = false
spamSection.Parent = contentFrame

-- Spam Message Input
local spamInput = Instance.new("TextBox")
spamInput.Size = UDim2.new(1, 0, 0, 40)
spamInput.BackgroundColor3 = COLORS.card
spamInput.TextColor3 = COLORS.text
spamInput.Text = ""
spamInput.PlaceholderText = "Message to spam..."
spamInput.PlaceholderColor3 = COLORS.textMuted
spamInput.Font = Enum.Font.Gotham
spamInput.TextSize = 11
spamInput.Parent = spamSection

local spamInputCorner = Instance.new("UICorner")
spamInputCorner.CornerRadius = UDim.new(0, 8)
spamInputCorner.Parent = spamInput

-- Spam Toggle
local spamToggleBtn = Instance.new("TextButton")
spamToggleBtn.Size = UDim2.new(0.5, -3, 0, 35)
spamToggleBtn.Position = UDim2.new(0, 0, 0, 45)
spamToggleBtn.BackgroundColor3 = COLORS.card
spamToggleBtn.TextColor3 = COLORS.text
spamToggleBtn.Text = "🔁 SPAM: OFF"
spamToggleBtn.Font = Enum.Font.GothamBold
spamToggleBtn.TextSize = 11
spamToggleBtn.Parent = spamSection

local spamToggleCorner = Instance.new("UICorner")
spamToggleCorner.CornerRadius = UDim.new(0, 6)
spamToggleCorner.Parent = spamToggleBtn

-- Spam Delay
local spamDelayRow = Instance.new("Frame")
spamDelayRow.Size = UDim2.new(0.5, -3, 0, 35)
spamDelayRow.Position = UDim2.new(0.5, 3, 0, 45)
spamDelayRow.BackgroundTransparency = 1
spamDelayRow.Parent = spamSection

local spamDelayLabel = Instance.new("TextLabel")
spamDelayLabel.Size = UDim2.new(0, 50, 1, 0)
spamDelayLabel.BackgroundTransparency = 1
spamDelayLabel.TextColor3 = COLORS.text
spamDelayLabel.Text = "Delay:"
spamDelayLabel.Font = Enum.Font.Gotham
spamDelayLabel.TextSize = 10
spamDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
spamDelayLabel.Parent = spamDelayRow

local spamDelayInput = Instance.new("TextBox")
spamDelayInput.Size = UDim2.new(0, 40, 1, 0)
spamDelayInput.Position = UDim2.new(0, 50, 0, 0)
spamDelayInput.BackgroundColor3 = COLORS.card
spamDelayInput.TextColor3 = COLORS.text
spamDelayInput.Text = "1"
spamDelayInput.Font = Enum.Font.Gotham
spamDelayInput.TextSize = 10
spamDelayInput.Parent = spamDelayRow

local spamDelayInputCorner = Instance.new("UICorner")
spamDelayInputCorner.CornerRadius = UDim.new(0, 4)
spamDelayInputCorner.Parent = spamDelayInput

local spamDelaySec = Instance.new("TextLabel")
spamDelaySec.Size = UDim2.new(0, 30, 1, 0)
spamDelaySec.Position = UDim2.new(0, 95, 0, 0)
spamDelaySec.BackgroundTransparency = 1
spamDelaySec.TextColor3 = COLORS.textMuted
spamDelaySec.Text = "sec"
spamDelaySec.Font = Enum.Font.Gotham
spamDelaySec.TextSize = 10
spamDelaySec.Parent = spamDelayRow

-- Spam Mode
local spamModeLabel = Instance.new("TextLabel")
spamModeLabel.Size = UDim2.new(1, 0, 0, 18)
spamModeLabel.Position = UDim2.new(0, 0, 0, 85)
spamModeLabel.BackgroundTransparency = 1
spamModeLabel.TextColor3 = COLORS.textMuted
spamModeLabel.Text = "Spam Mode:"
spamModeLabel.Font = Enum.Font.GothamBold
spamModeLabel.TextSize = 10
spamModeLabel.TextXAlignment = Enum.TextXAlignment.Left
spamModeLabel.Parent = spamSection

local spamModes = {"Normal", "Caps", "Lower", "Alternating", "Rainbow"}
local spamModeBtns = {}
local currentSpamMode = "Normal"

for i, mode in ipairs(spamModes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#spamModes - 3, 0, 0, 28)
    btn.Position = UDim2.new((i-1)/#spamModes + (i-1)*(3/480), 0, 0, 105)
    btn.BackgroundColor3 = i == 1 and COLORS.accent or COLORS.card
    btn.TextColor3 = COLORS.text
    btn.Text = mode
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 9
    btn.Parent = spamSection
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    spamModeBtns[mode] = btn
end

-- Warning
local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, 0, 0, 40)
warningLabel.Position = UDim2.new(0, 0, 0, 140)
warningLabel.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
warningLabel.TextColor3 = COLORS.text
warningLabel.Text = "⚠️ WARNING: Spam may get you kicked or banned!\nUse responsibly. Some games have chat cooldowns."
warningLabel.Font = Enum.Font.Gotham
warningLabel.TextSize = 9
warningLabel.TextWrapped = true
warningLabel.Parent = spamSection

local warningCorner = Instance.new("UICorner")
warningCorner.CornerRadius = UDim.new(0, 6)
warningCorner.Parent = warningLabel

-- ========== HISTORY TAB ==========
local historySection = Instance.new("Frame")
historySection.Size = UDim2.new(1, 0, 1, 0)
historySection.BackgroundTransparency = 1
historySection.Visible = false
historySection.Parent = contentFrame

-- History Label
local historyLabel = Instance.new("TextLabel")
historyLabel.Size = UDim2.new(1, 0, 0, 20)
historyLabel.BackgroundTransparency = 1
historyLabel.TextColor3 = COLORS.textMuted
historyLabel.Text = "Recent Messages (Click to resend):"
historyLabel.Font = Enum.Font.GothamBold
historyLabel.TextSize = 10
historyLabel.TextXAlignment = Enum.TextXAlignment.Left
historyLabel.Parent = historySection

-- History Frame
local historyScroll = Instance.new("ScrollingFrame")
historyScroll.Size = UDim2.new(1, 0, 1, -25)
historyScroll.Position = UDim2.new(0, 0, 0, 25)
historyScroll.BackgroundColor3 = COLORS.card
historyScroll.ScrollBarThickness = 4
historyScroll.ScrollBarImageColor3 = COLORS.textMuted
historyScroll.Parent = historySection

local historyCorner = Instance.new("UICorner")
historyCorner.CornerRadius = UDim.new(0, 6)
historyCorner.Parent = historyScroll

local historyLayout = Instance.new("UIListLayout")
historyLayout.Padding = UDim.new(0, 2)
historyLayout.Parent = historyScroll

-- Clear History Button
local clearHistoryBtn = Instance.new("TextButton")
clearHistoryBtn.Size = UDim2.new(0, 80, 0, 22)
clearHistoryBtn.Position = UDim2.new(1, -85, 0, 0)
clearHistoryBtn.BackgroundColor3 = COLORS.danger
clearHistoryBtn.TextColor3 = COLORS.text
clearHistoryBtn.Text = "Clear All"
clearHistoryBtn.Font = Enum.Font.GothamBold
clearHistoryBtn.TextSize = 9
clearHistoryBtn.Parent = historySection

local clearHistoryCorner = Instance.new("UICorner")
clearHistoryCorner.CornerRadius = UDim.new(0, 4)
clearHistoryCorner.Parent = clearHistoryBtn

-- ========== LOG TAB ==========
local logSection = Instance.new("Frame")
logSection.Size = UDim2.new(1, 0, 1, 0)
logSection.BackgroundTransparency = 1
logSection.Visible = false
logSection.Parent = contentFrame

-- Log Label
local logLabel = Instance.new("TextLabel")
logLabel.Size = UDim2.new(1, 0, 0, 20)
logLabel.BackgroundTransparency = 1
logLabel.TextColor3 = COLORS.textMuted
logLabel.Text = "Chat Log (All server messages):"
logLabel.Font = Enum.Font.GothamBold
logLabel.TextSize = 10
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.Parent = logSection

-- Log Frame
local logScroll = Instance.new("ScrollingFrame")
logScroll.Size = UDim2.new(1, 0, 1, -25)
logScroll.Position = UDim2.new(0, 0, 0, 25)
logScroll.BackgroundColor3 = COLORS.card
logScroll.ScrollBarThickness = 4
logScroll.ScrollBarImageColor3 = COLORS.textMuted
logScroll.Parent = logSection

local logCorner = Instance.new("UICorner")
logCorner.CornerRadius = UDim.new(0, 6)
logCorner.Parent = logScroll

local logLayout = Instance.new("UIListLayout")
logLayout.Padding = UDim.new(0, 2)
logLayout.Parent = logScroll

-- Clear Log Button
local clearLogBtn = Instance.new("TextButton")
clearLogBtn.Size = UDim2.new(0, 80, 0, 22)
clearLogBtn.Position = UDim2.new(1, -85, 0, 0)
clearLogBtn.BackgroundColor3 = COLORS.danger
clearLogBtn.TextColor3 = COLORS.text
clearLogBtn.Text = "Clear Log"
clearLogBtn.Font = Enum.Font.GothamBold
clearLogBtn.TextSize = 9
clearLogBtn.Parent = logSection

local clearLogCorner = Instance.new("UICorner")
clearLogCorner.Radius = UDim.new(0, 4)
clearLogCorner.Parent = clearLogBtn

-- ========== FUNCTIONS ==========

-- Send chat message (works with both old and new chat systems)
local function sendChat(message)
    if message == "" then return end
    
    -- Try TextChatService first (new chat)
    local textChat = TextChatService:FindFirstChild("TextChannels")
    if textChat then
        local channel = textChat:FindFirstChild("RBXGeneral") or textChat:FindFirstChildOfClass("TextChannel")
        if channel then
            channel:SendAsync(message)
            return true
        end
    end
    
    -- Try DefaultChatSystem (old chat)
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(message, "All")
            return true
        end
    end
    
    -- Fallback: Try chat remote
    local chatRemote = ReplicatedStorage:FindFirstChild("SayMessageRequest")
    if chatRemote then
        chatRemote:InvokeServer(message, "All")
        return true
    end
    
    return false
end

-- Process message based on mode
local function processMessage(message, mode)
    if mode == "Caps" then
        return message:upper()
    elseif mode == "Lower" then
        return message:lower()
    elseif mode == "Alternating" then
        local result = ""
        for i = 1, #message do
            if i % 2 == 0 then
                result = result .. message:sub(i, i):upper()
            else
                result = result .. message:sub(i, i):lower()
            end
        end
        return result
    elseif mode == "Rainbow" then
        -- Add some special characters for effect
        return "★ " .. message .. " ★"
    end
    return message
end

-- Add to history
local function addToHistory(message)
    if message == "" then return end
    
    -- Check if already exists
    for i, msg in ipairs(lastMessages) do
        if msg == message then
            table.remove(lastMessages, i)
            break
        end
    end
    
    -- Add to front
    table.insert(lastMessages, 1, message)
    
    -- Limit size
    if #lastMessages > maxHistory then
        table.remove(lastMessages)
    end
    
    -- Update history UI
    updateHistoryUI()
end

-- Update history UI
function updateHistoryUI()
    -- Clear existing
    for _, child in pairs(historyScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Add messages
    for i, msg in ipairs(lastMessages) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 0, 24)
        btn.BackgroundColor3 = COLORS.bg
        btn.TextColor3 = COLORS.text
        btn.Text = string.sub(msg, 1, 40) .. (#msg > 40 and "..." or "")
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 9
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = historyScroll
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.Radius = UDim.new(0, 4)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            chatInput.Text = msg
        end)
    end
    
    historyScroll.CanvasSize = UDim2.new(0, 0, 0, #lastMessages * 26)
end

-- Add to log
local function addToLog(text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = color or COLORS.text
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 9
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = logScroll
    
    logScroll.CanvasSize = UDim2.new(0, 0, 0, logLayout.AbsoluteContentSize.Y + 8)
end

-- Chat logger
local function setupChatLogger()
    -- Log existing players
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            addToLog("[JOINED] " .. plr.Name, Color3.fromRGB(100, 200, 100))
        end
    end
    
    -- Player joined
    Players.PlayerAdded:Connect(function(plr)
        addToLog("[JOINED] " .. plr.Name, Color3.fromRGB(100, 200, 100))
    end)
    
    -- Player left
    Players.PlayerRemoving:Connect(function(plr)
        addToLog("[LEFT] " .. plr.Name, Color3.fromRGB(200, 100, 100))
    end)
    
    -- Try to hook into chat messages
    spawn(function()
        -- Try TextChatService
        local textChat = TextChatService:FindFirstChild("TextChannels")
        if textChat then
            for _, channel in pairs(textChat:GetChildren()) do
                if channel:IsA("TextChannel") then
                    channel.OnIncomingMessage = function(message)
                        if message.Text ~= "" then
                            addToLog(message.PrefixText .. ": " .. message.Text, COLORS.text)
                        end
                    end
                end
            end
        end
    end)
end

-- Create fake bubble
local function createFakeBubble(text)
    local character = player.Character
    if not character then return end
    
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    -- Create bubble
    local bubble = Instance.new("BillboardGui")
    bubble.Name = "FakeBubble"
    bubble.Size = UDim2.new(0, 200, 0, 50)
    bubble.StudsOffset = Vector3.new(0, 3, 0)
    bubble.Adornee = head
    bubble.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = 0.2
    frame.Parent = bubble
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.Radius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(200, 200, 200)
    stroke.Thickness = 1
    stroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
    label.Text = text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextWrapped = true
    label.TextScaled = true
    label.Parent = frame
    
    -- Remove after delay
    spawn(function()
        wait(5)
        bubble:Destroy()
    end)
end

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

-- ========== TOGGLE ==========
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

-- ========== TAB SWITCHING ==========
local function switchTab(tabName)
    currentTab = tabName
    
    mainSection.Visible = false
    toolsSection.Visible = false
    spamSection.Visible = false
    historySection.Visible = false
    logSection.Visible = false
    
    if tabName == "Main" then mainSection.Visible = true
    elseif tabName == "Tools" then toolsSection.Visible = true
    elseif tabName == "Spam" then spamSection.Visible = true
    elseif tabName == "History" then historySection.Visible = true
    elseif tabName == "Log" then logSection.Visible = true
    end
    
    for name, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = name == tabName and COLORS.accent or COLORS.card
    end
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- ========== TOGGLE KEY ==========
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

-- ========== BUTTON FUNCTIONS ==========

-- Toggle button visual
local function toggleBtn(btn, state, onText, offText)
    btn.Text = state and onText or offText
    btn.BackgroundColor3 = state and COLORS.success or COLORS.card
end

-- Auto Caps
autoCapsBtn.MouseButton1Click:Connect(function()
    states.autoCaps = not states.autoCaps
    if states.autoCaps then states.autoLower = false end
    toggleBtn(autoCapsBtn, states.autoCaps, "🔺 AUTO CAPS: ON", "🔺 AUTO CAPS: OFF")
    toggleBtn(autoLowerBtn, states.autoLower, "🔻 AUTO LOWER: ON", "🔻 AUTO LOWER: OFF")
end)

-- Auto Lower
autoLowerBtn.MouseButton1Click:Connect(function()
    states.autoLower = not states.autoLower
    if states.autoLower then states.autoCaps = false end
    toggleBtn(autoLowerBtn, states.autoLower, "🔻 AUTO LOWER: ON", "🔻 AUTO LOWER: OFF")
    toggleBtn(autoCapsBtn, states.autoCaps, "🔺 AUTO CAPS: ON", "🔺 AUTO CAPS: OFF")
end)

-- Send Message
sendBtn.MouseButton1Click:Connect(function()
    local msg = chatInput.Text
    if msg ~= "" then
        -- Process based on auto modes
        if states.autoCaps then
            msg = msg:upper()
        elseif states.autoLower then
            msg = msg:lower()
        end
        
        sendChat(msg)
        addToHistory(msg)
        addToLog("[YOU]: " .. msg, COLORS.accent)
        chatInput.Text = ""
    end
end)

-- Clear Input
clearBtn.MouseButton1Click:Connect(function()
    chatInput.Text = ""
end)

-- Quick Messages
for i, msg in ipairs(quickMsgs) do
    local row = math.floor((i-1)/6)
    local col = (i-1) % 6
    
    local btn = mainSection:FindFirstChild("TextButton")
    if btn then
        btn.MouseButton1Click:Connect(function()
            local finalMsg = msg
            if states.autoCaps then
                finalMsg = finalMsg:upper()
            elseif states.autoLower then
                finalMsg = finalMsg:lower()
            end
            sendChat(finalMsg)
            addToHistory(finalMsg)
            addToLog("[YOU]: " .. finalMsg, COLORS.accent)
        end)
    end
end

-- Quick message buttons (need to reconnect properly)
spawn(function()
    wait(0.5)
    for _, child in pairs(mainSection:GetChildren()) do
        if child:IsA("TextButton") and child.Text ~= "" then
            local msgText = child.Text
            child.MouseButton1Click:Connect(function()
                local finalMsg = msgText
                if states.autoCaps then
                    finalMsg = finalMsg:upper()
                elseif states.autoLower then
                    finalMsg = finalMsg:lower()
                end
                sendChat(finalMsg)
                addToHistory(finalMsg)
                addToLog("[YOU]: " .. finalMsg, COLORS.accent)
            end)
        end
    end
end)

-- Anti-AFK Chat
antiAFKBtn.MouseButton1Click:Connect(function()
    states.antiAFK = not states.antiAFK
    toggleBtn(antiAFKBtn, states.antiAFK, "💤 ANTI-AFK CHAT: ON", "💤 ANTI-AFK CHAT: OFF")
    
    if states.antiAFK then
        local delay = tonumber(antiAFKDelayInput.Text) or 60
        local msg = antiAFKMsgInput.Text ~= "" and antiAFKMsgInput.Text or "afk"
        
        antiAFKConnection = spawn(function()
            while states.antiAFK do
                wait(delay)
                if states.antiAFK then
                    sendChat(msg)
                    addToLog("[ANTI-AFK]: " .. msg, Color3.fromRGB(100, 150, 255))
                end
            end
        end)
    end
end)

-- Fake Bubble Chat
fakeBubbleBtn.MouseButton1Click:Connect(function()
    states.fakeBubble = not states.fakeBubble
    toggleBtn(fakeBubbleBtn, states.fakeBubble, "💬 FAKE BUBBLE: ON", "💬 FAKE BUBBLE: OFF")
    
    if states.fakeBubble then
        local msg = fakeBubbleInput.Text ~= "" and fakeBubbleInput.Text or "Fake message!"
        createFakeBubble(msg)
        states.fakeBubble = false
        toggleBtn(fakeBubbleBtn, false, "💬 FAKE BUBBLE: ON", "💬 FAKE BUBBLE: OFF")
    end
end)

-- Rainbow Name
rainbowNameBtn.MouseButton1Click:Connect(function()
    states.rainbowName = not states.rainbowName
    toggleBtn(rainbowNameBtn, states.rainbowName, "🌈 RAINBOW NAME: ON", "🌈 RAINBOW NAME: OFF")
    
    if states.rainbowName then
        rainbowConnection = spawn(function()
            while states.rainbowName do
                local hue = tick() % 1
                local color = Color3.fromHSV(hue, 1, 1)
                local hex = string.format("%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
                -- This doesn't actually change name color in Roblox chat, but shows the effect
                rainbowNameBtn.BackgroundColor3 = color
                wait(0.1)
            end
        end)
    else
        if rainbowConnection then
            rainbowNameBtn.BackgroundColor3 = COLORS.card
        end
    end
end)

-- Fake Lag Chat
local fakeLagChatConnection
fakeLagChatBtn.MouseButton1Click:Connect(function()
    states.fakeLagChat = not states.fakeLagChat
    toggleBtn(fakeLagChatBtn, states.fakeLagChat, "📶 FAKE LAG CHAT: ON", "📶 FAKE LAG CHAT: OFF")
    
    if states.fakeLagChat then
        fakeLagChatConnection = spawn(function()
            while states.fakeLagChat do
                -- Send laggy messages
                local lagMsgs = {"...", ".......", "............", "lagging"}
                local msg = lagMsgs[math.random(1, #lagMsgs)]
                sendChat(msg)
                addToLog("[FAKE LAG]: " .. msg, Color3.fromRGB(150, 150, 150))
                wait(math.random(3, 8))
            end
        end)
    end
end)

-- Spam Toggle
spamToggleBtn.MouseButton1Click:Connect(function()
    states.spam = not states.spam
    toggleBtn(spamToggleBtn, states.spam, "🔁 SPAM: ON", "🔁 SPAM: OFF")
    
    if states.spam then
        local msg = spamInput.Text
        if msg ~= "" then
            local delay = tonumber(spamDelayInput.Text) or 1
            
            spamConnection = spawn(function()
                while states.spam do
                    local finalMsg = processMessage(msg, currentSpamMode)
                    sendChat(finalMsg)
                    addToLog("[SPAM]: " .. finalMsg, COLORS.danger)
                    wait(delay)
                end
            end)
        else
            states.spam = false
            toggleBtn(spamToggleBtn, false, "🔁 SPAM: ON", "🔁 SPAM: OFF")
        end
    else
        if spamConnection then
            spamConnection = nil
        end
    end
end)

-- Spam Mode Buttons
for mode, btn in pairs(spamModeBtns) do
    btn.MouseButton1Click:Connect(function()
        currentSpamMode = mode
        for m, b in pairs(spamModeBtns) do
            b.BackgroundColor3 = m == mode and COLORS.accent or COLORS.card
        end
    end)
end

-- Clear History
clearHistoryBtn.MouseButton1Click:Connect(function()
    lastMessages = {}
    for _, child in pairs(historyScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end)

-- Clear Log
clearLogBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(logScroll:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end)

-- Enter key to send
chatInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        sendBtn.MouseButton1Click:Fire()
    end
end)

spamInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        spamToggleBtn.MouseButton1Click:Fire()
    end
end)

-- Setup chat logger
setupChatLogger()

print("✅ KBL Chat Hub Loaded - Press RightControl to toggle")
