-- Chat Hub (Enhanced - Chunk 1)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

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

-- ========== NEW: Chat Logger ==========
local chatLog = {}
local maxLogEntries = 200

-- ========== NEW: Message Scheduler ==========
local scheduledMessages = {}
local schedulerRunning = false

-- ========== NEW: Typing Indicator ==========
local typingEnabled = false
local typingDelayMin = 0.5
local typingDelayMax = 1.5

-- ========== NEW: Spam Patterns ==========
local spamPattern = "NORMAL" -- NORMAL, COUNT, RANDOM, ALTERNATE
local countStart = 1
local alternateMessages = {"Message 1", "Message 2"}

-- ========== NEW: Quick Responses ==========
local quickResponses = {
    [Enum.KeyCode.One] = "Hello!",
    [Enum.KeyCode.Two] = "GG",
    [Enum.KeyCode.Three] = "Nice!",
    [Enum.KeyCode.Four] = "BRB",
    [Enum.KeyCode.Five] = "Thanks!",
    [Enum.KeyCode.Six] = "No problem",
    [Enum.KeyCode.Seven] = "Lol",
    [Enum.KeyCode.Eight] = "What?",
    [Enum.KeyCode.Nine] = "Ok"
}

-- ========== NEW: Cooldown Tracking ==========
local messagesSentRecently = 0
local lastMessageTime = 0
local RATE_LIMIT_WARNING = 5
local RATE_LIMIT_WINDOW = 10

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
    cardBg = Color3.fromRGB(255, 255, 255),
    warning = Color3.fromRGB(255, 193, 7)
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

-- ========== HUB FRAME (EXPANDED - WIDER FOR NEW TAB) ==========

local hubFrame = Instance.new("Frame")
hubFrame.Name = "HubFrame"
hubFrame.Size = UDim2.new(0, 600, 0, 350)
hubFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
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
titleLabel.Text = "💬 Chat Hub v2"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Rate Limit Warning
local rateLimitWarning = Instance.new("TextLabel")
rateLimitWarning.Size = UDim2.new(0, 120, 0, 20)
rateLimitWarning.Position = UDim2.new(1, -180, 0.5, -10)
rateLimitWarning.BackgroundTransparency = 1
rateLimitWarning.TextColor3 = COLORS.textMuted
rateLimitWarning.Text = "Msgs: 0/5"
rateLimitWarning.Font = Enum.Font.Gotham
rateLimitWarning.TextSize = 11
rateLimitWarning.Parent = titleBar

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

-- Tab Buttons (ADDED "Tools" TAB)
local tabs = {"Chat", "Spam", "AutoReply", "Tools", "AFK", "Settings"}
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

-- Quick Response Hint
local quickResponseHint = Instance.new("TextLabel")
quickResponseHint.Size = UDim2.new(1, 0, 0, 20)
quickResponseHint.Position = UDim2.new(0, 0, 0, 145)
quickResponseHint.BackgroundTransparency = 1
quickResponseHint.TextColor3 = COLORS.textMuted
quickResponseHint.Text = "💡 Quick Responses: Press 1-9 keys to send preset messages"
quickResponseHint.Font = Enum.Font.Gotham
quickResponseHint.TextSize = 10
quickResponseHint.TextXAlignment = Enum.TextXAlignment.Left
quickResponseHint.Parent = chatSection
-- ========== TOOLS SECTION (NEW TAB) ==========

local toolsSection = Instance.new("Frame")
toolsSection.Size = UDim2.new(1, 0, 1, 0)
toolsSection.BackgroundTransparency = 1
toolsSection.Visible = false
toolsSection.Parent = contentFrame

-- Tools Sub-tabs
local toolsTabFrame = Instance.new("Frame")
toolsTabFrame.Size = UDim2.new(1, 0, 0, 28)
toolsTabFrame.Position = UDim2.new(0, 0, 0, 0)
toolsTabFrame.BackgroundTransparency = 1
toolsTabFrame.Parent = toolsSection

local toolsSubTabs = {"Logger", "Scheduler", "Patterns"}
local toolsSubTabBtns = {}
local currentToolsTab = "Logger"

for i, tabName in ipairs(toolsSubTabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/3, -3, 1, 0)
    btn.Position = UDim2.new((i-1)/3, 0, 0, 0)
    btn.BackgroundColor3 = i == 1 and COLORS.buttonPrimary or Color3.fromRGB(220, 220, 220)
    btn.TextColor3 = i == 1 and COLORS.textLight or COLORS.textDark
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = toolsTabFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    toolsSubTabBtns[tabName] = btn
end

-- Tools Content Area
local toolsContent = Instance.new("Frame")
toolsContent.Size = UDim2.new(1, 0, 1, -35)
toolsContent.Position = UDim2.new(0, 0, 0, 33)
toolsContent.BackgroundTransparency = 1
toolsContent.Parent = toolsSection

-- ========== CHAT LOGGER ==========

local loggerPanel = Instance.new("Frame")
loggerPanel.Size = UDim2.new(1, 0, 1, 0)
loggerPanel.BackgroundTransparency = 1
loggerPanel.Visible = true
loggerPanel.Parent = toolsContent

-- Logger Search
local loggerSearchRow = Instance.new("Frame")
loggerSearchRow.Size = UDim2.new(1, 0, 0, 28)
loggerSearchRow.Position = UDim2.new(0, 0, 0, 0)
loggerSearchRow.BackgroundTransparency = 1
loggerSearchRow.Parent = loggerPanel

local loggerSearchInput = Instance.new("TextBox")
loggerSearchInput.Size = UDim2.new(1, -90, 1, 0)
loggerSearchInput.Position = UDim2.new(0, 0, 0, 0)
loggerSearchInput.BackgroundColor3 = COLORS.inputBg
loggerSearchInput.TextColor3 = COLORS.textDark
loggerSearchInput.Text = ""
loggerSearchInput.PlaceholderText = "Search messages..."
loggerSearchInput.PlaceholderColor3 = COLORS.textMuted
loggerSearchInput.Font = Enum.Font.Gotham
loggerSearchInput.TextSize = 12
loggerSearchInput.ClearTextOnFocus = false
loggerSearchInput.Parent = loggerSearchRow

local loggerSearchCorner = Instance.new("UICorner")
loggerSearchCorner.CornerRadius = UDim.new(0, 6)
loggerSearchCorner.Parent = loggerSearchInput

local loggerSearchStroke = Instance.new("UIStroke")
loggerSearchStroke.Color = COLORS.border
loggerSearchStroke.Thickness = 1
loggerSearchStroke.Parent = loggerSearchInput

local loggerClearBtn = Instance.new("TextButton")
loggerClearBtn.Size = UDim2.new(0, 80, 1, 0)
loggerClearBtn.Position = UDim2.new(1, -85, 0, 0)
loggerClearBtn.BackgroundColor3 = COLORS.buttonDanger
loggerClearBtn.TextColor3 = COLORS.textLight
loggerClearBtn.Text = "Clear Log"
loggerClearBtn.Font = Enum.Font.GothamBold
loggerClearBtn.TextSize = 11
loggerClearBtn.Parent = loggerSearchRow

local loggerClearCorner = Instance.new("UICorner")
loggerClearCorner.CornerRadius = UDim.new(0, 6)
loggerClearCorner.Parent = loggerClearBtn

-- Logger Display
local loggerScroll = Instance.new("ScrollingFrame")
loggerScroll.Size = UDim2.new(1, 0, 1, -65)
loggerScroll.Position = UDim2.new(0, 0, 0, 33)
loggerScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
loggerScroll.ScrollBarThickness = 4
loggerScroll.Parent = loggerPanel

local loggerScrollCorner = Instance.new("UICorner")
loggerScrollCorner.CornerRadius = UDim.new(0, 6)
loggerScrollCorner.Parent = loggerScroll

local loggerLayout = Instance.new("UIListLayout")
loggerLayout.Padding = UDim.new(0, 2)
loggerLayout.Parent = loggerScroll

-- Logger Stats
local loggerStats = Instance.new("TextLabel")
loggerStats.Size = UDim2.new(1, 0, 0, 20)
loggerStats.Position = UDim2.new(0, 0, 1, -25)
loggerStats.BackgroundTransparency = 1
loggerStats.TextColor3 = COLORS.textMuted
loggerStats.Text = "Messages: 0"
loggerStats.Font = Enum.Font.Gotham
loggerStats.TextSize = 10
loggerStats.TextXAlignment = Enum.TextXAlignment.Left
loggerStats.Parent = loggerPanel

-- ========== MESSAGE SCHEDULER ==========

local schedulerPanel = Instance.new("Frame")
schedulerPanel.Size = UDim2.new(1, 0, 1, 0)
schedulerPanel.BackgroundTransparency = 1
schedulerPanel.Visible = false
schedulerPanel.Parent = toolsContent

-- Scheduler Input Row
local schedulerInputRow = Instance.new("Frame")
schedulerInputRow.Size = UDim2.new(1, 0, 0, 28)
schedulerInputRow.Position = UDim2.new(0, 0, 0, 0)
schedulerInputRow.BackgroundTransparency = 1
schedulerInputRow.Parent = schedulerPanel

local schedulerMsgInput = Instance.new("TextBox")
schedulerMsgInput.Size = UDim2.new(0.55, 0, 1, 0)
schedulerMsgInput.Position = UDim2.new(0, 0, 0, 0)
schedulerMsgInput.BackgroundColor3 = COLORS.inputBg
schedulerMsgInput.TextColor3 = COLORS.textDark
schedulerMsgInput.Text = ""
schedulerMsgInput.PlaceholderText = "Message to schedule..."
schedulerMsgInput.PlaceholderColor3 = COLORS.textMuted
schedulerMsgInput.Font = Enum.Font.Gotham
schedulerMsgInput.TextSize = 11
schedulerMsgInput.ClearTextOnFocus = true
schedulerMsgInput.Parent = schedulerInputRow

local schedulerMsgCorner = Instance.new("UICorner")
schedulerMsgCorner.CornerRadius = UDim.new(0, 6)
schedulerMsgCorner.Parent = schedulerMsgInput

local schedulerMsgStroke = Instance.new("UIStroke")
schedulerMsgStroke.Color = COLORS.border
schedulerMsgStroke.Thickness = 1
schedulerMsgStroke.Parent = schedulerMsgInput

local schedulerDelayInput = Instance.new("TextBox")
schedulerDelayInput.Size = UDim2.new(0.15, -5, 1, 0)
schedulerDelayInput.Position = UDim2.new(0.55, 5, 0, 0)
schedulerDelayInput.BackgroundColor3 = COLORS.inputBg
schedulerDelayInput.TextColor3 = COLORS.textDark
schedulerDelayInput.Text = "5"
schedulerDelayInput.PlaceholderText = "Delay"
schedulerDelayInput.PlaceholderColor3 = COLORS.textMuted
schedulerDelayInput.Font = Enum.Font.Gotham
schedulerDelayInput.TextSize = 11
schedulerDelayInput.ClearTextOnFocus = false
schedulerDelayInput.Parent = schedulerInputRow

local schedulerDelayCorner = Instance.new("UICorner")
schedulerDelayCorner.CornerRadius = UDim.new(0, 6)
schedulerDelayCorner.Parent = schedulerDelayInput

local schedulerDelayStroke = Instance.new("UIStroke")
schedulerDelayStroke.Color = COLORS.border
schedulerDelayStroke.Thickness = 1
schedulerDelayStroke.Parent = schedulerDelayInput

local schedulerDelayLabel = Instance.new("TextLabel")
schedulerDelayLabel.Size = UDim2.new(0.1, 0, 1, 0)
schedulerDelayLabel.Position = UDim2.new(0.7, 0, 0, 0)
schedulerDelayLabel.BackgroundTransparency = 1
schedulerDelayLabel.TextColor3 = COLORS.textMuted
schedulerDelayLabel.Text = "sec"
schedulerDelayLabel.Font = Enum.Font.Gotham
schedulerDelayLabel.TextSize = 10
schedulerDelayLabel.Parent = schedulerInputRow

local schedulerAddBtn = Instance.new("TextButton")
schedulerAddBtn.Size = UDim2.new(0.2, 0, 1, 0)
schedulerAddBtn.Position = UDim2.new(0.8, 0, 0, 0)
schedulerAddBtn.BackgroundColor3 = COLORS.buttonSuccess
schedulerAddBtn.TextColor3 = COLORS.textLight
schedulerAddBtn.Text = "+ Add"
schedulerAddBtn.Font = Enum.Font.GothamBold
schedulerAddBtn.TextSize = 11
schedulerAddBtn.Parent = schedulerInputRow

local schedulerAddCorner = Instance.new("UICorner")
schedulerAddCorner.CornerRadius = UDim.new(0, 6)
schedulerAddCorner.Parent = schedulerAddBtn

-- Scheduler Type Row
local schedulerTypeRow = Instance.new("Frame")
schedulerTypeRow.Size = UDim2.new(1, 0, 0, 24)
schedulerTypeRow.Position = UDim2.new(0, 0, 0, 32)
schedulerTypeRow.BackgroundTransparency = 1
schedulerTypeRow.Parent = schedulerPanel

local schedulerTypeLabel = Instance.new("TextLabel")
schedulerTypeLabel.Size = UDim2.new(0, 50, 1, 0)
schedulerTypeLabel.BackgroundTransparency = 1
schedulerTypeLabel.TextColor3 = COLORS.textDark
schedulerTypeLabel.Text = "Type:"
schedulerTypeLabel.Font = Enum.Font.Gotham
schedulerTypeLabel.TextSize = 10
schedulerTypeLabel.TextXAlignment = Enum.TextXAlignment.Left
schedulerTypeLabel.Parent = schedulerTypeRow

local schedulerTypeBtns = {}
local schedulerTypes = {"Once", "Repeat", "Interval"}
local schedulerType = "Once"

for i, stype in ipairs(schedulerTypes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 1, 0)
    btn.Position = UDim2.new(0, 50 + (i-1) * 73, 0, 0)
    btn.BackgroundColor3 = stype == "Once" and COLORS.buttonPrimary or Color3.fromRGB(220, 220, 220)
    btn.TextColor3 = stype == "Once" and COLORS.textLight or COLORS.textDark
    btn.Text = stype
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.Parent = schedulerTypeRow
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    schedulerTypeBtns[stype] = btn
end

-- Scheduler Queue
local schedulerQueueLabel = Instance.new("TextLabel")
schedulerQueueLabel.Size = UDim2.new(1, 0, 0, 18)
schedulerQueueLabel.Position = UDim2.new(0, 0, 0, 60)
schedulerQueueLabel.BackgroundTransparency = 1
schedulerQueueLabel.TextColor3 = COLORS.textDark
schedulerQueueLabel.Text = "Scheduled Messages:"
schedulerQueueLabel.Font = Enum.Font.GothamBold
schedulerQueueLabel.TextSize = 11
schedulerQueueLabel.TextXAlignment = Enum.TextXAlignment.Left
schedulerQueueLabel.Parent = schedulerPanel

local schedulerScroll = Instance.new("ScrollingFrame")
schedulerScroll.Size = UDim2.new(1, 0, 1, -110)
schedulerScroll.Position = UDim2.new(0, 0, 0, 82)
schedulerScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
schedulerScroll.ScrollBarThickness = 4
schedulerScroll.Parent = schedulerPanel

local schedulerScrollCorner = Instance.new("UICorner")
schedulerScrollCorner.CornerRadius = UDim.new(0, 6)
schedulerScrollCorner.Parent = schedulerScroll

local schedulerLayout = Instance.new("UIListLayout")
schedulerLayout.Padding = UDim.new(0, 3)
schedulerLayout.Parent = schedulerScroll

-- Scheduler Status
local schedulerStatus = Instance.new("TextLabel")
schedulerStatus.Size = UDim2.new(1, 0, 0, 18)
schedulerStatus.Position = UDim2.new(0, 0, 1, -22)
schedulerStatus.BackgroundTransparency = 1
schedulerStatus.TextColor3 = COLORS.textMuted
schedulerStatus.Text = "Status: Idle"
schedulerStatus.Font = Enum.Font.Gotham
schedulerStatus.TextSize = 10
schedulerStatus.TextXAlignment = Enum.TextXAlignment.Left
schedulerStatus.Parent = schedulerPanel

-- ========== SPAM PATTERNS ==========

local patternsPanel = Instance.new("Frame")
patternsPanel.Size = UDim2.new(1, 0, 1, 0)
patternsPanel.BackgroundTransparency = 1
patternsPanel.Visible = false
patternsPanel.Parent = toolsContent

-- Pattern Mode Selection
local patternModeLabel = Instance.new("TextLabel")
patternModeLabel.Size = UDim2.new(1, 0, 0, 20)
patternModeLabel.Position = UDim2.new(0, 0, 0, 0)
patternModeLabel.BackgroundTransparency = 1
patternModeLabel.TextColor3 = COLORS.textDark
patternModeLabel.Text = "Spam Pattern Mode"
patternModeLabel.Font = Enum.Font.GothamBold
patternModeLabel.TextSize = 12
patternModeLabel.TextXAlignment = Enum.TextXAlignment.Left
patternModeLabel.Parent = patternsPanel

local patternModeRow = Instance.new("Frame")
patternModeRow.Size = UDim2.new(1, 0, 0, 32)
patternModeRow.Position = UDim2.new(0, 0, 0, 22)
patternModeRow.BackgroundTransparency = 1
patternModeRow.Parent = patternsPanel

local patternModes = {"NORMAL", "COUNT", "RANDOM", "ALTERNATE"}
local patternModeBtns = {}

for i, mode in ipairs(patternModes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, -3, 1, 0)
    btn.Position = UDim2.new((i-1)*0.25, 0, 0, 0)
    btn.BackgroundColor3 = mode == "NORMAL" and COLORS.buttonPrimary or Color3.fromRGB(220, 220, 220)
    btn.TextColor3 = mode == "NORMAL" and COLORS.textLight or COLORS.textDark
    btn.Text = mode
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = patternModeRow
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    patternModeBtns[mode] = btn
end

-- Count Pattern Settings
local countSettings = Instance.new("Frame")
countSettings.Size = UDim2.new(1, 0, 0, 60)
countSettings.Position = UDim2.new(0, 0, 0, 60)
countSettings.BackgroundTransparency = 1
countSettings.Visible = false
countSettings.Parent = patternsPanel

local countStartLabel = Instance.new("TextLabel")
countStartLabel.Size = UDim2.new(0, 100, 0, 24)
countStartLabel.Position = UDim2.new(0, 0, 0, 0)
countStartLabel.BackgroundTransparency = 1
countStartLabel.TextColor3 = COLORS.textDark
countStartLabel.Text = "Start Number:"
countStartLabel.Font = Enum.Font.Gotham
countStartLabel.TextSize = 11
countStartLabel.TextXAlignment = Enum.TextXAlignment.Left
countStartLabel.Parent = countSettings

local countStartInput = Instance.new("TextBox")
countStartInput.Size = UDim2.new(0, 80, 0, 24)
countStartInput.Position = UDim2.new(0, 100, 0, 0)
countStartInput.BackgroundColor3 = COLORS.inputBg
countStartInput.TextColor3 = COLORS.textDark
countStartInput.Text = "1"
countStartInput.Font = Enum.Font.Gotham
countStartInput.TextSize = 12
countStartInput.ClearTextOnFocus = false
countStartInput.Parent = countSettings

local countStartCorner = Instance.new("UICorner")
countStartCorner.CornerRadius = UDim.new(0, 6)
countStartCorner.Parent = countStartInput

local countStartStroke = Instance.new("UIStroke")
countStartStroke.Color = COLORS.border
countStartStroke.Thickness = 1
countStartStroke.Parent = countStartInput

local countPrefixLabel = Instance.new("TextLabel")
countPrefixLabel.Size = UDim2.new(0, 100, 0, 24)
countPrefixLabel.Position = UDim2.new(0, 0, 0, 30)
countPrefixLabel.BackgroundTransparency = 1
countPrefixLabel.TextColor3 = COLORS.textDark
countPrefixLabel.Text = "Prefix Text:"
countPrefixLabel.Font = Enum.Font.Gotham
countPrefixLabel.TextSize = 11
countPrefixLabel.TextXAlignment = Enum.TextXAlignment.Left
countPrefixLabel.Parent = countSettings

local countPrefixInput = Instance.new("TextBox")
countPrefixInput.Size = UDim2.new(0.7, 0, 0, 24)
countPrefixInput.Position = UDim2.new(0, 100, 0, 30)
countPrefixInput.BackgroundColor3 = COLORS.inputBg
countPrefixInput.TextColor3 = COLORS.textDark
countPrefixInput.Text = ""
countPrefixInput.PlaceholderText = "e.g., 'Count: ' → 'Count: 1, Count: 2...'"
countPrefixInput.PlaceholderColor3 = COLORS.textMuted
countPrefixInput.Font = Enum.Font.Gotham
countPrefixInput.TextSize = 11
countPrefixInput.ClearTextOnFocus = false
countPrefixInput.Parent = countSettings

local countPrefixCorner = Instance.new("UICorner")
countPrefixCorner.CornerRadius = UDim.new(0, 6)
countPrefixCorner.Parent = countPrefixInput

local countPrefixStroke = Instance.new("UIStroke")
countPrefixStroke.Color = COLORS.border
countPrefixStroke.Thickness = 1
countPrefixStroke.Parent = countPrefixInput

-- Alternate Pattern Settings
local alternateSettings = Instance.new("Frame")
alternateSettings.Size = UDim2.new(1, 0, 0, 80)
alternateSettings.Position = UDim2.new(0, 0, 0, 60)
alternateSettings.BackgroundTransparency = 1
alternateSettings.Visible = false
alternateSettings.Parent = patternsPanel

local altMsg1Label = Instance.new("TextLabel")
altMsg1Label.Size = UDim2.new(0, 100, 0, 24)
altMsg1Label.Position = UDim2.new(0, 0, 0, 0)
altMsg1Label.BackgroundTransparency = 1
altMsg1Label.TextColor3 = COLORS.textDark
altMsg1Label.Text = "Message 1:"
altMsg1Label.Font = Enum.Font.Gotham
altMsg1Label.TextSize = 11
altMsg1Label.TextXAlignment = Enum.TextXAlignment.Left
altMsg1Label.Parent = alternateSettings

local altMsg1Input = Instance.new("TextBox")
altMsg1Input.Size = UDim2.new(1, -105, 0, 24)
altMsg1Input.Position = UDim2.new(0, 100, 0, 0)
altMsg1Input.BackgroundColor3 = COLORS.inputBg
altMsg1Input.TextColor3 = COLORS.textDark
altMsg1Input.Text = "Message 1"
altMsg1Input.PlaceholderColor3 = COLORS.textMuted
altMsg1Input.Font = Enum.Font.Gotham
altMsg1Input.TextSize = 11
altMsg1Input.ClearTextOnFocus = false
altMsg1Input.Parent = alternateSettings

local altMsg1Corner = Instance.new("UICorner")
altMsg1Corner.CornerRadius = UDim.new(0, 6)
altMsg1Corner.Parent = altMsg1Input

local altMsg1Stroke = Instance.new("UIStroke")
altMsg1Stroke.Color = COLORS.border
altMsg1Stroke.Thickness = 1
altMsg1Stroke.Parent = altMsg1Input

local altMsg2Label = Instance.new("TextLabel")
altMsg2Label.Size = UDim2.new(0, 100, 0, 24)
altMsg2Label.Position = UDim2.new(0, 0, 0, 30)
altMsg2Label.BackgroundTransparency = 1
altMsg2Label.TextColor3 = COLORS.textDark
altMsg2Label.Text = "Message 2:"
altMsg2Label.Font = Enum.Font.Gotham
altMsg2Label.TextSize = 11
altMsg2Label.TextXAlignment = Enum.TextXAlignment.Left
altMsg2Label.Parent = alternateSettings

local altMsg2Input = Instance.new("TextBox")
altMsg2Input.Size = UDim2.new(1, -105, 0, 24)
altMsg2Input.Position = UDim2.new(0, 100, 0, 30)
altMsg2Input.BackgroundColor3 = COLORS.inputBg
altMsg2Input.TextColor3 = COLORS.textDark
altMsg2Input.Text = "Message 2"
altMsg2Input.PlaceholderColor3 = COLORS.textMuted
altMsg2Input.Font = Enum.Font.Gotham
altMsg2Input.TextSize = 11
altMsg2Input.ClearTextOnFocus = false
altMsg2Input.Parent = alternateSettings

local altMsg2Corner = Instance.new("UICorner")
altMsg2Corner.CornerRadius = UDim.new(0, 6)
altMsg2Corner.Parent = altMsg2Input

local altMsg2Stroke = Instance.new("UIStroke")
altMsg2Stroke.Color = COLORS.border
altMsg2Stroke.Thickness = 1
altMsg2Stroke.Parent = altMsg2Input

local altMsg3Label = Instance.new("TextLabel")
altMsg3Label.Size = UDim2.new(0, 100, 0, 24)
altMsg3Label.Position = UDim2.new(0, 0, 0, 60)
altMsg3Label.BackgroundTransparency = 1
altMsg3Label.TextColor3 = COLORS.textDark
altMsg3Label.Text = "Message 3:"
altMsg3Label.Font = Enum.Font.Gotham
altMsg3Label.TextSize = 11
altMsg3Label.TextXAlignment = Enum.TextXAlignment.Left
altMsg3Label.Parent = alternateSettings

local altMsg3Input = Instance.new("TextBox")
altMsg3Input.Size = UDim2.new(1, -105, 0, 24)
altMsg3Input.Position = UDim2.new(0, 100, 0, 60)
altMsg3Input.BackgroundColor3 = COLORS.inputBg
altMsg3Input.TextColor3 = COLORS.textDark
altMsg3Input.Text = ""
altMsg3Input.PlaceholderText = "(optional)"
altMsg3Input.PlaceholderColor3 = COLORS.textMuted
altMsg3Input.Font = Enum.Font.Gotham
altMsg3Input.TextSize = 11
altMsg3Input.ClearTextOnFocus = false
altMsg3Input.Parent = alternateSettings

local altMsg3Corner = Instance.new("UICorner")
altMsg3Corner.CornerRadius = UDim.new(0, 6)
altMsg3Corner.Parent = altMsg3Input

local altMsg3Stroke = Instance.new("UIStroke")
altMsg3Stroke.Color = COLORS.border
altMsg3Stroke.Thickness = 1
altMsg3Stroke.Parent = altMsg3Input

-- Pattern Info
local patternInfo = Instance.new("TextLabel")
patternInfo.Size = UDim2.new(1, 0, 0, 60)
patternInfo.Position = UDim2.new(0, 0, 1, -70)
patternInfo.BackgroundTransparency = 1
patternInfo.TextColor3 = COLORS.textMuted
patternInfo.Text = "NORMAL: Uses premade messages\nCOUNT: Counts up (1, 2, 3...)\nRANDOM: Picks random from premade\nALTERNATE: Cycles through 2-3 messages"
patternInfo.Font = Enum.Font.Gotham
patternInfo.TextSize = 10
patternInfo.TextXAlignment = Enum.TextXAlignment.Left
patternInfo.TextYAlignment = Enum.TextYAlignment.Top
patternInfo.Parent = patternsPanel
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

-- Spam Randomize Toggle
local spamRandomizeRow = Instance.new("Frame")
spamRandomizeRow.Size = UDim2.new(1, 0, 0, 30)
spamRandomizeRow.Position = UDim2.new(0, 0, 0, 90)
spamRandomizeRow.BackgroundTransparency = 1
spamRandomizeRow.Parent = spamSection

local spamRandomizeLabel = Instance.new("TextLabel")
spamRandomizeLabel.Size = UDim2.new(0, 150, 1, 0)
spamRandomizeLabel.BackgroundTransparency = 1
spamRandomizeLabel.TextColor3 = COLORS.textDark
spamRandomizeLabel.Text = "Randomize Delay:"
spamRandomizeLabel.Font = Enum.Font.Gotham
spamRandomizeLabel.TextSize = 11
spamRandomizeLabel.TextXAlignment = Enum.TextXAlignment.Left
spamRandomizeLabel.Parent = spamRandomizeRow

local spamRandomizeToggle = Instance.new("TextButton")
spamRandomizeToggle.Size = UDim2.new(0, 60, 1, 0)
spamRandomizeToggle.Position = UDim2.new(0, 155, 0, 0)
spamRandomizeToggle.BackgroundColor3 = COLORS.buttonOff
spamRandomizeToggle.TextColor3 = COLORS.textLight
spamRandomizeToggle.Text = "OFF"
spamRandomizeToggle.Font = Enum.Font.GothamBold
spamRandomizeToggle.TextSize = 11
spamRandomizeToggle.Parent = spamRandomizeRow

local spamRandomizeCorner = Instance.new("UICorner")
spamRandomizeCorner.CornerRadius = UDim.new(0, 6)
spamRandomizeCorner.Parent = spamRandomizeToggle

-- Spam Info
local spamInfo = Instance.new("TextLabel")
spamInfo.Size = UDim2.new(1, 0, 0, 40)
spamInfo.Position = UDim2.new(0, 0, 1, -50)
spamInfo.BackgroundTransparency = 1
spamInfo.TextColor3 = COLORS.textMuted
spamInfo.Text = "Pattern mode set in Tools tab.\nUses messages from Premade panel below."
spamInfo.Font = Enum.Font.Gotham
spamInfo.TextSize = 10
spamInfo.TextXAlignment = Enum.TextXAlignment.Left
spamInfo.TextYAlignment = Enum.TextYAlignment.Top
spamInfo.Parent = spamSection

-- Premade Messages Toggle
local premadeToggle = Instance.new("TextButton")
premadeToggle.Size = UDim2.new(1, 0, 0, 30)
premadeToggle.Position = UDim2.new(0, 0, 0, 125)
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
premadePanel.Size = UDim2.new(1, 0, 0, 150)
premadePanel.Position = UDim2.new(0, 0, 0, 160)
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

-- Keyword Triggers Toggle
local keywordToggleRow = Instance.new("Frame")
keywordToggleRow.Size = UDim2.new(1, 0, 0, 28)
keywordToggleRow.Position = UDim2.new(0, 0, 0, 48)
keywordToggleRow.BackgroundTransparency = 1
keywordToggleRow.Parent = autoReplySection

local keywordToggleLabel = Instance.new("TextLabel")
keywordToggleLabel.Size = UDim2.new(0, 120, 1, 0)
keywordToggleLabel.BackgroundTransparency = 1
keywordToggleLabel.TextColor3 = COLORS.textDark
keywordToggleLabel.Text = "Keyword Triggers:"
keywordToggleLabel.Font = Enum.Font.Gotham
keywordToggleLabel.TextSize = 11
keywordToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
keywordToggleLabel.Parent = keywordToggleRow

local keywordToggleBtn = Instance.new("TextButton")
keywordToggleBtn.Size = UDim2.new(0, 60, 1, 0)
keywordToggleBtn.Position = UDim2.new(0, 125, 0, 0)
keywordToggleBtn.BackgroundColor3 = COLORS.buttonOff
keywordToggleBtn.TextColor3 = COLORS.textLight
keywordToggleBtn.Text = "OFF"
keywordToggleBtn.Font = Enum.Font.GothamBold
keywordToggleBtn.TextSize = 11
keywordToggleBtn.Parent = keywordToggleRow

local keywordToggleCorner = Instance.new("UICorner")
keywordToggleCorner.CornerRadius = UDim.new(0, 6)
keywordToggleCorner.Parent = keywordToggleBtn

local keywordEnabled = false

-- Target Input Row
local targetRow = Instance.new("Frame")
targetRow.Size = UDim2.new(1, 0, 0, 28)
targetRow.Position = UDim2.new(0, 0, 0, 82)
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
replyLabel.Position = UDim2.new(0, 0, 0, 115)
replyLabel.BackgroundTransparency = 1
replyLabel.TextColor3 = COLORS.textDark
replyLabel.Text = "Reply Messages (one per line, cycles):"
replyLabel.Font = Enum.Font.Gotham
replyLabel.TextSize = 11
replyLabel.TextXAlignment = Enum.TextXAlignment.Left
replyLabel.Parent = autoReplySection

local replyInput = Instance.new("TextBox")
replyInput.Size = UDim2.new(1, 0, 0, 50)
replyInput.Position = UDim2.new(0, 0, 0, 133)
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
replyCharCounter.Position = UDim2.new(1, -65, 0, 165)
replyCharCounter.BackgroundTransparency = 1
replyCharCounter.TextColor3 = COLORS.textMuted
replyCharCounter.Text = "0/200"
replyCharCounter.Font = Enum.Font.Gotham
replyCharCounter.TextSize = 10
replyCharCounter.Parent = autoReplySection

-- Add Target Button
local addTargetBtn = Instance.new("TextButton")
addTargetBtn.Size = UDim2.new(1, 0, 0, 28)
addTargetBtn.Position = UDim2.new(0, 0, 0, 190)
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
targetsScroll.Size = UDim2.new(1, 0, 0, 75)
targetsScroll.Position = UDim2.new(0, 0, 0, 225)
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
afkToggle.Size = UDim2.new(1, 0, 0, 50)
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

-- AFK Method Toggles
local afkMethodLabel = Instance.new("TextLabel")
afkMethodLabel.Size = UDim2.new(1, 0, 0, 20)
afkMethodLabel.Position = UDim2.new(0, 0, 0, 60)
afkMethodLabel.BackgroundTransparency = 1
afkMethodLabel.TextColor3 = COLORS.textDark
afkMethodLabel.Text = "Anti-AFK Methods:"
afkMethodLabel.Font = Enum.Font.GothamBold
afkMethodLabel.TextSize = 12
afkMethodLabel.TextXAlignment = Enum.TextXAlignment.Left
afkMethodLabel.Parent = afkSection

local afkMethods = {
    virtualUser = true,
    movement = false,
    jump = false
}

local afkMethodRow1 = Instance.new("Frame")
afkMethodRow1.Size = UDim2.new(1, 0, 0, 28)
afkMethodRow1.Position = UDim2.new(0, 0, 0, 82)
afkMethodRow1.BackgroundTransparency = 1
afkMethodRow1.Parent = afkSection

local afkVirtualUserBtn = Instance.new("TextButton")
afkVirtualUserBtn.Size = UDim2.new(0.32, -2, 1, 0)
afkVirtualUserBtn.Position = UDim2.new(0, 0, 0, 0)
afkVirtualUserBtn.BackgroundColor3 = COLORS.buttonSuccess
afkVirtualUserBtn.TextColor3 = COLORS.textLight
afkVirtualUserBtn.Text = "VirtualUser ✓"
afkVirtualUserBtn.Font = Enum.Font.GothamBold
afkVirtualUserBtn.TextSize = 10
afkVirtualUserBtn.Parent = afkMethodRow1

local afkVirtualUserCorner = Instance.new("UICorner")
afkVirtualUserCorner.CornerRadius = UDim.new(0, 6)
afkVirtualUserCorner.Parent = afkVirtualUserBtn

local afkMovementBtn = Instance.new("TextButton")
afkMovementBtn.Size = UDim2.new(0.32, -2, 1, 0)
afkMovementBtn.Position = UDim2.new(0.34, 0, 0, 0)
afkMovementBtn.BackgroundColor3 = COLORS.buttonOff
afkMovementBtn.TextColor3 = COLORS.textLight
afkMovementBtn.Text = "Movement"
afkMovementBtn.Font = Enum.Font.GothamBold
afkMovementBtn.TextSize = 10
afkMovementBtn.Parent = afkMethodRow1

local afkMovementCorner = Instance.new("UICorner")
afkMovementCorner.CornerRadius = UDim.new(0, 6)
afkMovementCorner.Parent = afkMovementBtn

local afkJumpBtn = Instance.new("TextButton")
afkJumpBtn.Size = UDim2.new(0.32, -2, 1, 0)
afkJumpBtn.Position = UDim2.new(0.68, 0, 0, 0)
afkJumpBtn.BackgroundColor3 = COLORS.buttonOff
afkJumpBtn.TextColor3 = COLORS.textLight
afkJumpBtn.Text = "Jump"
afkJumpBtn.Font = Enum.Font.GothamBold
afkJumpBtn.TextSize = 10
afkJumpBtn.Parent = afkMethodRow1

local afkJumpCorner = Instance.new("UICorner")
afkJumpCorner.CornerRadius = UDim.new(0, 6)
afkJumpCorner.Parent = afkJumpBtn

-- AFK Interval
local afkIntervalRow = Instance.new("Frame")
afkIntervalRow.Size = UDim2.new(1, 0, 0, 28)
afkIntervalRow.Position = UDim2.new(0, 0, 0, 115)
afkIntervalRow.BackgroundTransparency = 1
afkIntervalRow.Parent = afkSection

local afkIntervalLabel = Instance.new("TextLabel")
afkIntervalLabel.Size = UDim2.new(0, 100, 1, 0)
afkIntervalLabel.BackgroundTransparency = 1
afkIntervalLabel.TextColor3 = COLORS.textDark
afkIntervalLabel.Text = "Interval (sec):"
afkIntervalLabel.Font = Enum.Font.Gotham
afkIntervalLabel.TextSize = 11
afkIntervalLabel.TextXAlignment = Enum.TextXAlignment.Left
afkIntervalLabel.Parent = afkIntervalRow

local afkIntervalInput = Instance.new("TextBox")
afkIntervalInput.Size = UDim2.new(0, 60, 1, 0)
afkIntervalInput.Position = UDim2.new(0, 105, 0, 0)
afkIntervalInput.BackgroundColor3 = COLORS.inputBg
afkIntervalInput.TextColor3 = COLORS.textDark
afkIntervalInput.Text = "60"
afkIntervalInput.Font = Enum.Font.Gotham
afkIntervalInput.TextSize = 12
afkIntervalInput.ClearTextOnFocus = false
afkIntervalInput.Parent = afkIntervalRow

local afkIntervalCorner = Instance.new("UICorner")
afkIntervalCorner.CornerRadius = UDim.new(0, 6)
afkIntervalCorner.Parent = afkIntervalInput

local afkIntervalStroke = Instance.new("UIStroke")
afkIntervalStroke.Color = COLORS.border
afkIntervalStroke.Thickness = 1
afkIntervalStroke.Parent = afkIntervalInput

local afkRandomizeLabel = Instance.new("TextLabel")
afkRandomizeLabel.Size = UDim2.new(0, 100, 1, 0)
afkRandomizeLabel.Position = UDim2.new(0, 175, 0, 0)
afkRandomizeLabel.BackgroundTransparency = 1
afkRandomizeLabel.TextColor3 = COLORS.textMuted
afkRandomizeLabel.Text = "(+ random)"
afkRandomizeLabel.Font = Enum.Font.Gotham
afkRandomizeLabel.TextSize = 10
afkRandomizeLabel.Parent = afkIntervalRow

-- AFK Info
local afkInfo = Instance.new("TextLabel")
afkInfo.Size = UDim2.new(1, 0, 0, 60)
afkInfo.Position = UDim2.new(0, 0, 1, -70)
afkInfo.BackgroundTransparency = 1
afkInfo.TextColor3 = COLORS.textMuted
afkInfo.Text = "VirtualUser: Simulates clicks (undetectable)\nMovement: Moves slightly (some games detect)\nJump: Jumps (may trigger anti-cheat)\nRandom interval helps avoid detection."
afkInfo.Font = Enum.Font.Gotham
afkInfo.TextSize = 10
afkInfo.TextXAlignment = Enum.TextXAlignment.Left
afkInfo.TextYAlignment = Enum.TextYAlignment.Top
afkInfo.Parent = afkSection
-- ========== SETTINGS SECTION ==========

local settingsSection = Instance.new("Frame")
settingsSection.Size = UDim2.new(1, 0, 1, 0)
settingsSection.BackgroundTransparency = 1
settingsSection.Visible = false
settingsSection.Parent = contentFrame

-- Settings Scroll (since we have lots of settings now)
local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Size = UDim2.new(1, 0, 1, 0)
settingsScroll.Position = UDim2.new(0, 0, 0, 0)
settingsScroll.BackgroundTransparency = 1
settingsScroll.ScrollBarThickness = 4
settingsScroll.Parent = settingsSection

local settingsLayout = Instance.new("UIListLayout")
settingsLayout.Padding = UDim.new(0, 8)
settingsLayout.Parent = settingsScroll

-- Prefix Mode Label
local prefixModeLabel = Instance.new("TextLabel")
prefixModeLabel.Size = UDim2.new(1, 0, 0, 20)
prefixModeLabel.BackgroundTransparency = 1
prefixModeLabel.TextColor3 = COLORS.textDark
prefixModeLabel.Text = "Message Prefix Mode"
prefixModeLabel.Font = Enum.Font.GothamBold
prefixModeLabel.TextSize = 13
prefixModeLabel.TextXAlignment = Enum.TextXAlignment.Left
prefixModeLabel.Parent = settingsScroll

-- Prefix Mode Buttons
local prefixModeFrame = Instance.new("Frame")
prefixModeFrame.Size = UDim2.new(1, 0, 0, 32)
prefixModeFrame.BackgroundTransparency = 1
prefixModeFrame.Parent = settingsScroll

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
fixedPrefixLabel.BackgroundTransparency = 1
fixedPrefixLabel.TextColor3 = COLORS.textDark
fixedPrefixLabel.Text = "Fixed Prefix:"
fixedPrefixLabel.Font = Enum.Font.Gotham
fixedPrefixLabel.TextSize = 11
fixedPrefixLabel.TextXAlignment = Enum.TextXAlignment.Left
fixedPrefixLabel.Parent = settingsScroll

local fixedPrefixInput = Instance.new("TextBox")
fixedPrefixInput.Size = UDim2.new(1, -85, 0, 28)
fixedPrefixInput.BackgroundColor3 = COLORS.inputBg
fixedPrefixInput.TextColor3 = COLORS.textDark
fixedPrefixInput.Text = "★"
fixedPrefixInput.Font = Enum.Font.Gotham
fixedPrefixInput.TextSize = 14
fixedPrefixInput.ClearTextOnFocus = false
fixedPrefixInput.Parent = settingsScroll

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
rotatingPrefixLabel.BackgroundTransparency = 1
rotatingPrefixLabel.TextColor3 = COLORS.textDark
rotatingPrefixLabel.Text = "Rotating Prefixes (space separated):"
rotatingPrefixLabel.Font = Enum.Font.Gotham
rotatingPrefixLabel.TextSize = 11
rotatingPrefixLabel.TextXAlignment = Enum.TextXAlignment.Left
rotatingPrefixLabel.Parent = settingsScroll

local rotatingPrefixInput = Instance.new("TextBox")
rotatingPrefixInput.Size = UDim2.new(1, 0, 0, 28)
rotatingPrefixInput.BackgroundColor3 = COLORS.inputBg
rotatingPrefixInput.TextColor3 = COLORS.textDark
rotatingPrefixInput.Text = "★ 🔥 💎 🎮"
rotatingPrefixInput.Font = Enum.Font.Gotham
rotatingPrefixInput.TextSize = 14
rotatingPrefixInput.ClearTextOnFocus = false
rotatingPrefixInput.Parent = settingsScroll

local rotatingPrefixCorner = Instance.new("UICorner")
rotatingPrefixCorner.CornerRadius = UDim.new(0, 6)
rotatingPrefixCorner.Parent = rotatingPrefixInput

local rotatingPrefixStroke = Instance.new("UIStroke")
rotatingPrefixStroke.Color = COLORS.border
rotatingPrefixStroke.Thickness = 1
rotatingPrefixStroke.Parent = rotatingPrefixInput

-- ========== TYPING INDICATOR SETTINGS ==========

local divider1 = Instance.new("Frame")
divider1.Size = UDim2.new(1, 0, 0, 1)
divider1.BackgroundColor3 = COLORS.border
divider1.BorderSizePixel = 0
divider1.Parent = settingsScroll

local typingLabel = Instance.new("TextLabel")
typingLabel.Size = UDim2.new(1, 0, 0, 20)
typingLabel.BackgroundTransparency = 1
typingLabel.TextColor3 = COLORS.textDark
typingLabel.Text = "Typing Indicator"
typingLabel.Font = Enum.Font.GothamBold
typingLabel.TextSize = 13
typingLabel.TextXAlignment = Enum.TextXAlignment.Left
typingLabel.Parent = settingsScroll

local typingToggleRow = Instance.new("Frame")
typingToggleRow.Size = UDim2.new(1, 0, 0, 28)
typingToggleRow.BackgroundTransparency = 1
typingToggleRow.Parent = settingsScroll

local typingToggleLabel = Instance.new("TextLabel")
typingToggleLabel.Size = UDim2.new(0, 150, 1, 0)
typingToggleLabel.BackgroundTransparency = 1
typingToggleLabel.TextColor3 = COLORS.textDark
typingToggleLabel.Text = "Fake Typing Delay:"
typingToggleLabel.Font = Enum.Font.Gotham
typingToggleLabel.TextSize = 11
typingToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
typingToggleLabel.Parent = typingToggleRow

local typingToggleBtn = Instance.new("TextButton")
typingToggleBtn.Size = UDim2.new(0, 60, 1, 0)
typingToggleBtn.Position = UDim2.new(0, 155, 0, 0)
typingToggleBtn.BackgroundColor3 = COLORS.buttonOff
typingToggleBtn.TextColor3 = COLORS.textLight
typingToggleBtn.Text = "OFF"
typingToggleBtn.Font = Enum.Font.GothamBold
typingToggleBtn.TextSize = 11
typingToggleBtn.Parent = typingToggleRow

local typingToggleCorner = Instance.new("UICorner")
typingToggleCorner.CornerRadius = UDim.new(0, 6)
typingToggleCorner.Parent = typingToggleBtn

local typingDelayRow = Instance.new("Frame")
typingDelayRow.Size = UDim2.new(1, 0, 0, 28)
typingDelayRow.BackgroundTransparency = 1
typingDelayRow.Parent = settingsScroll

local typingDelayLabel = Instance.new("TextLabel")
typingDelayLabel.Size = UDim2.new(0, 100, 1, 0)
typingDelayLabel.BackgroundTransparency = 1
typingDelayLabel.TextColor3 = COLORS.textDark
typingDelayLabel.Text = "Delay Range:"
typingDelayLabel.Font = Enum.Font.Gotham
typingDelayLabel.TextSize = 11
typingDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
typingDelayLabel.Parent = typingDelayRow

local typingMinInput = Instance.new("TextBox")
typingMinInput.Size = UDim2.new(0, 50, 1, 0)
typingMinInput.Position = UDim2.new(0, 105, 0, 0)
typingMinInput.BackgroundColor3 = COLORS.inputBg
typingMinInput.TextColor3 = COLORS.textDark
typingMinInput.Text = "0.5"
typingMinInput.Font = Enum.Font.Gotham
typingMinInput.TextSize = 11
typingMinInput.ClearTextOnFocus = false
typingMinInput.Parent = typingDelayRow

local typingMinCorner = Instance.new("UICorner")
typingMinCorner.CornerRadius = UDim.new(0, 6)
typingMinCorner.Parent = typingMinInput

local typingMinStroke = Instance.new("UIStroke")
typingMinStroke.Color = COLORS.border
typingMinStroke.Thickness = 1
typingMinStroke.Parent = typingMinInput

local typingToLabel = Instance.new("TextLabel")
typingToLabel.Size = UDim2.new(0, 20, 1, 0)
typingToLabel.Position = UDim2.new(0, 160, 0, 0)
typingToLabel.BackgroundTransparency = 1
typingToLabel.TextColor3 = COLORS.textDark
typingToLabel.Text = "to"
typingToLabel.Font = Enum.Font.Gotham
typingToLabel.TextSize = 11
typingToLabel.TextXAlignment = Enum.TextXAlignment.Center
typingToLabel.Parent = typingDelayRow

local typingMaxInput = Instance.new("TextBox")
typingMaxInput.Size = UDim2.new(0, 50, 1, 0)
typingMaxInput.Position = UDim2.new(0, 185, 0, 0)
typingMaxInput.BackgroundColor3 = COLORS.inputBg
typingMaxInput.TextColor3 = COLORS.textDark
typingMaxInput.Text = "1.5"
typingMaxInput.Font = Enum.Font.Gotham
typingMaxInput.TextSize = 11
typingMaxInput.ClearTextOnFocus = false
typingMaxInput.Parent = typingDelayRow

local typingMaxCorner = Instance.new("UICorner")
typingMaxCorner.CornerRadius = UDim.new(0, 6)
typingMaxCorner.Parent = typingMaxInput

local typingMaxStroke = Instance.new("UIStroke")
typingMaxStroke.Color = COLORS.border
typingMaxStroke.Thickness = 1
typingMaxStroke.Parent = typingMaxInput

local typingSecLabel = Instance.new("TextLabel")
typingSecLabel.Size = UDim2.new(0, 30, 1, 0)
typingSecLabel.Position = UDim2.new(0, 240, 0, 0)
typingSecLabel.BackgroundTransparency = 1
typingSecLabel.TextColor3 = COLORS.textMuted
typingSecLabel.Text = "sec"
typingSecLabel.Font = Enum.Font.Gotham
typingSecLabel.TextSize = 10
typingSecLabel.TextXAlignment = Enum.TextXAlignment.Left
typingSecLabel.Parent = typingDelayRow

-- ========== QUICK RESPONSES SETTINGS ==========

local divider2 = Instance.new("Frame")
divider2.Size = UDim2.new(1, 0, 0, 1)
divider2.BackgroundColor3 = COLORS.border
divider2.BorderSizePixel = 0
divider2.Parent = settingsScroll

local quickRespLabel = Instance.new("TextLabel")
quickRespLabel.Size = UDim2.new(1, 0, 0, 20)
quickRespLabel.BackgroundTransparency = 1
quickRespLabel.TextColor3 = COLORS.textDark
quickRespLabel.Text = "Quick Responses (Keys 1-9)"
quickRespLabel.Font = Enum.Font.GothamBold
quickRespLabel.TextSize = 13
quickRespLabel.TextXAlignment = Enum.TextXAlignment.Left
quickRespLabel.Parent = settingsScroll

local quickRespInfo = Instance.new("TextLabel")
quickRespInfo.Size = UDim2.new(1, 0, 0, 18)
quickRespInfo.BackgroundTransparency = 1
quickRespInfo.TextColor3 = COLORS.textMuted
quickRespInfo.Text = "Press number keys while GUI is open to send"
quickRespInfo.Font = Enum.Font.Gotham
quickRespInfo.TextSize = 10
quickRespInfo.TextXAlignment = Enum.TextXAlignment.Left
quickRespInfo.Parent = settingsScroll

local quickRespInputs = {}
local quickRespKeys = {"1", "2", "3", "4", "5", "6", "7", "8", "9"}
local quickRespDefaults = {"Hello!", "GG", "Nice!", "BRB", "Thanks!", "No problem", "Lol", "What?", "Ok"}

for i, key in ipairs(quickRespKeys) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 24)
    row.BackgroundTransparency = 1
    row.Parent = settingsScroll
    
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(0, 30, 1, 0)
    keyLabel.BackgroundTransparency = 1
    keyLabel.TextColor3 = COLORS.textMuted
    keyLabel.Text = "[" .. key .. "]"
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.TextSize = 11
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    keyLabel.Parent = row
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -35, 1, 0)
    input.Position = UDim2.new(0, 35, 0, 0)
    input.BackgroundColor3 = COLORS.inputBg
    input.TextColor3 = COLORS.textDark
    input.Text = quickRespDefaults[i]
    input.Font = Enum.Font.Gotham
    input.TextSize = 11
    input.ClearTextOnFocus = false
    input.Parent = row
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = input
    
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = COLORS.border
    inputStroke.Thickness = 1
    inputStroke.Parent = input
    
    quickRespInputs[i] = input
end

-- ========== GUI SETTINGS ==========

local divider3 = Instance.new("Frame")
divider3.Size = UDim2.new(1, 0, 0, 1)
divider3.BackgroundColor3 = COLORS.border
divider3.BorderSizePixel = 0
divider3.Parent = settingsScroll

local guiSettingsLabel = Instance.new("TextLabel")
guiSettingsLabel.Size = UDim2.new(1, 0, 0, 20)
guiSettingsLabel.BackgroundTransparency = 1
guiSettingsLabel.TextColor3 = COLORS.textDark
guiSettingsLabel.Text = "GUI Settings"
guiSettingsLabel.Font = Enum.Font.GothamBold
guiSettingsLabel.TextSize = 13
guiSettingsLabel.TextXAlignment = Enum.TextXAlignment.Left
guiSettingsLabel.Parent = settingsScroll

-- Transparency Slider
local transparencyLabel = Instance.new("TextLabel")
transparencyLabel.Size = UDim2.new(0, 90, 0, 20)
transparencyLabel.BackgroundTransparency = 1
transparencyLabel.TextColor3 = COLORS.textDark
transparencyLabel.Text = "Transparency:"
transparencyLabel.Font = Enum.Font.Gotham
transparencyLabel.TextSize = 11
transparencyLabel.TextXAlignment = Enum.TextXAlignment.Left
transparencyLabel.Parent = settingsScroll

local transparencySlider = Instance.new("TextBox")
transparencySlider.Size = UDim2.new(0, 60, 0, 28)
transparencySlider.BackgroundColor3 = COLORS.inputBg
transparencySlider.TextColor3 = COLORS.textDark
transparencySlider.Text = "0"
transparencySlider.Font = Enum.Font.Gotham
transparencySlider.TextSize = 12
transparencySlider.ClearTextOnFocus = false
transparencySlider.Parent = settingsScroll

local transparencySliderCorner = Instance.new("UICorner")
transparencySliderCorner.CornerRadius = UDim.new(0, 6)
transparencySliderCorner.Parent = transparencySlider

local transparencySliderStroke = Instance.new("UIStroke")
transparencySliderStroke.Color = COLORS.border
transparencySliderStroke.Thickness = 1
transparencySliderStroke.Parent = transparencySlider

local transparencyHint = Instance.new("TextLabel")
transparencyHint.Size = UDim2.new(0, 60, 0, 20)
transparencyHint.BackgroundTransparency = 1
transparencyHint.TextColor3 = COLORS.textMuted
transparencyHint.Text = "(0-100%)"
transparencyHint.Font = Enum.Font.Gotham
transparencyHint.TextSize = 10
transparencyHint.TextXAlignment = Enum.TextXAlignment.Left
transparencyHint.Parent = settingsScroll

-- Scale Slider
local scaleLabel = Instance.new("TextLabel")
scaleLabel.Size = UDim2.new(0, 90, 0, 20)
scaleLabel.BackgroundTransparency = 1
scaleLabel.TextColor3 = COLORS.textDark
scaleLabel.Text = "GUI Scale:"
scaleLabel.Font = Enum.Font.Gotham
scaleLabel.TextSize = 11
scaleLabel.TextXAlignment = Enum.TextXAlignment.Left
scaleLabel.Parent = settingsScroll

local scaleSlider = Instance.new("TextBox")
scaleSlider.Size = UDim2.new(0, 60, 0, 28)
scaleSlider.BackgroundColor3 = COLORS.inputBg
scaleSlider.TextColor3 = COLORS.textDark
scaleSlider.Text = "1"
scaleSlider.Font = Enum.Font.Gotham
scaleSlider.TextSize = 12
scaleSlider.ClearTextOnFocus = false
scaleSlider.Parent = settingsScroll

local scaleSliderCorner = Instance.new("UICorner")
scaleSliderCorner.CornerRadius = UDim.new(0, 6)
scaleSliderCorner.Parent = scaleSlider

local scaleSliderStroke = Instance.new("UIStroke")
scaleSliderStroke.Color = COLORS.border
scaleSliderStroke.Thickness = 1
scaleSliderStroke.Parent = scaleSlider

local scaleHint = Instance.new("TextLabel")
scaleHint.Size = UDim2.new(0, 60, 0, 20)
scaleHint.BackgroundTransparency = 1
scaleHint.TextColor3 = COLORS.textMuted
scaleHint.Text = "(0.5-2.0)"
scaleHint.Font = Enum.Font.Gotham
scaleHint.TextSize = 10
scaleHint.TextXAlignment = Enum.TextXAlignment.Left
scaleHint.Parent = settingsScroll

-- ========== MESSAGE HISTORY ==========

local divider4 = Instance.new("Frame")
divider4.Size = UDim2.new(1, 0, 0, 1)
divider4.BackgroundColor3 = COLORS.border
divider4.BorderSizePixel = 0
divider4.Parent = settingsScroll

local historyLabel = Instance.new("TextLabel")
historyLabel.Size = UDim2.new(1, 0, 0, 20)
historyLabel.BackgroundTransparency = 1
historyLabel.TextColor3 = COLORS.textDark
historyLabel.Text = "Message History"
historyLabel.Font = Enum.Font.GothamBold
historyLabel.TextSize = 13
historyLabel.TextXAlignment = Enum.TextXAlignment.Left
historyLabel.Parent = settingsScroll

local historyInfo = Instance.new("TextLabel")
historyInfo.Size = UDim2.new(1, 0, 0, 18)
historyInfo.BackgroundTransparency = 1
historyInfo.TextColor3 = COLORS.textMuted
historyInfo.Text = "Use ↑/↓ arrow keys in chat box to cycle history"
historyInfo.Font = Enum.Font.Gotham
historyInfo.TextSize = 10
historyInfo.TextXAlignment = Enum.TextXAlignment.Left
historyInfo.Parent = settingsScroll

local historyCountRow = Instance.new("Frame")
historyCountRow.Size = UDim2.new(1, 0, 0, 28)
historyCountRow.BackgroundTransparency = 1
historyCountRow.Parent = settingsScroll

local historyCountLabel = Instance.new("TextLabel")
historyCountLabel.Size = UDim2.new(0, 120, 1, 0)
historyCountLabel.BackgroundTransparency = 1
historyCountLabel.TextColor3 = COLORS.textDark
historyCountLabel.Text = "Max History Size:"
historyCountLabel.Font = Enum.Font.Gotham
historyCountLabel.TextSize = 11
historyCountLabel.TextXAlignment = Enum.TextXAlignment.Left
historyCountLabel.Parent = historyCountRow

local historyCountInput = Instance.new("TextBox")
historyCountInput.Size = UDim2.new(0, 60, 1, 0)
historyCountInput.Position = UDim2.new(0, 125, 0, 0)
historyCountInput.BackgroundColor3 = COLORS.inputBg
historyCountInput.TextColor3 = COLORS.textDark
historyCountInput.Text = "20"
historyCountInput.Font = Enum.Font.Gotham
historyCountInput.TextSize = 12
historyCountInput.ClearTextOnFocus = false
historyCountInput.Parent = historyCountRow

local historyCountCorner = Instance.new("UICorner")
historyCountCorner.CornerRadius = UDim.new(0, 6)
historyCountCorner.Parent = historyCountInput

local historyCountStroke = Instance.new("UIStroke")
historyCountStroke.Color = COLORS.border
historyCountStroke.Thickness = 1
historyCountStroke.Parent = historyCountInput
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
    toolsSection.Visible = tabName == "Tools"
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

-- ========== TOOLS SUB-TAB SWITCHING ==========

local function switchToolsTab(tabName)
    currentToolsTab = tabName
    loggerPanel.Visible = tabName == "Logger"
    schedulerPanel.Visible = tabName == "Scheduler"
    patternsPanel.Visible = tabName == "Patterns"
    
    for name, btn in pairs(toolsSubTabBtns) do
        if name == tabName then
            btn.BackgroundColor3 = COLORS.buttonPrimary
            btn.TextColor3 = COLORS.textLight
        else
            btn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            btn.TextColor3 = COLORS.textDark
        end
    end
end

for name, btn in pairs(toolsSubTabBtns) do
    btn.MouseButton1Click:Connect(function()
        switchToolsTab(name)
    end)
end

switchTab("Chat")
switchToolsTab("Logger")

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

-- ========== MESSAGE HISTORY ==========

local messageHistory = {}
local historyIndex = 0
local maxHistory = 20

local function addToHistory(msg)
    if msg == "" or msg == nil then return end
    table.insert(messageHistory, 1, msg)
    if #messageHistory > maxHistory then
        table.remove(messageHistory, #messageHistory)
    end
    historyIndex = 0
end

-- ========== RATE LIMIT TRACKING ==========

local function updateRateLimit()
    local now = tick()
    -- Clean old entries
    local recentCount = 0
    for i, time in ipairs(messageHistory) do
        -- This is a bit hacky, messageHistory stores strings, not times. 
        -- Let's create a separate table for rate limiting
    end
    -- Actually better approach:
end

local recentMessages = {} -- Stores timestamps

local function checkRateLimit()
    local now = tick()
    -- Remove messages older than window
    local i = 1
    while i <= #recentMessages do
        if now - recentMessages[i] > RATE_LIMIT_WINDOW then
            table.remove(recentMessages, i)
        else
            i = i + 1
        end
    end
    
    messagesSentRecently = #recentMessages
    rateLimitWarning.Text = "Msgs: " .. messagesSentRecently .. "/" .. RATE_LIMIT_WARNING
    
    if messagesSentRecently >= RATE_LIMIT_WARNING then
        rateLimitWarning.TextColor3 = COLORS.buttonDanger
    elseif messagesSentRecently >= RATE_LIMIT_WARNING - 2 then
        rateLimitWarning.TextColor3 = COLORS.warning
    else
        rateLimitWarning.TextColor3 = COLORS.textMuted
    end
    
    return messagesSentRecently < RATE_LIMIT_WARNING
end

-- ========== SEND MESSAGE FUNCTION ==========

local function sendMessage(msg)
    local message = msg or chatTextbox.Text
    message = message:gsub("^%s+", ""):gsub("%s+$", ""):gsub("\n", " ")
    
    if message == "" or #message > MAX_CHARS then return false end
    
    if not checkRateLimit() then
        print("⚠️ Rate limit reached! Waiting...")
        return false
    end
    
    local prefix = getPrefix()
    local finalMessage = prefix .. message
    
    -- Typing indicator delay
    if typingEnabled then
        local minDelay = tonumber(typingMinInput.Text) or 0.5
        local maxDelay = tonumber(typingMaxInput.Text) or 1.5
        local delay = minDelay + (math.random() * (maxDelay - minDelay))
        wait(delay)
    end
    
    local success = false
    
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(finalMessage, "All")
            success = true
        end
    end
    
    if not success then
        local TextChatService = game:GetService("TextChatService")
        if TextChatService then
            local channel = TextChatService:FindFirstChild("TextChannels")
            if channel then
                local rbxGeneral = channel:FindFirstChild("RBXGeneral")
                if rbxGeneral then
                    rbxGeneral:SendAsync(finalMessage)
                    success = true
                end
            end
        end
    end
    
    if success then
        table.insert(recentMessages, tick())
        addToHistory(message)
        checkRateLimit()
        if msg == nil then chatTextbox.Text = "" end
    end
    
    return success
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

-- ========== MESSAGE HISTORY ARROW KEYS ==========

chatTextbox.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Up then
        if #messageHistory > 0 then
            historyIndex = math.min(historyIndex + 1, #messageHistory)
            chatTextbox.Text = messageHistory[historyIndex]
        end
    elseif input.KeyCode == Enum.KeyCode.Down then
        if historyIndex > 1 then
            historyIndex = historyIndex - 1
            chatTextbox.Text = messageHistory[historyIndex]
        elseif historyIndex == 1 then
            historyIndex = 0
            chatTextbox.Text = ""
        end
    end
end)

-- ========== QUICK RESPONSES ==========

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    for keyCode, defaultMsg in pairs(quickResponses) do
        if input.KeyCode == keyCode then
            local index = tonumber(keyCode.Name) or 0
            if quickRespInputs[index] then
                local msg = quickRespInputs[index].Text
                if msg ~= "" then
                    sendMessage(msg)
                end
            end
        end
    end
end)

-- ========== CHAT LOGGER ==========

local function addLogEntry(playerName, message, isSelf)
    local entry = {
        player = playerName,
        message = message,
        time = os.date("%H:%M:%S"),
        isSelf = isSelf
    }
    table.insert(chatLog, 1, entry)
    
    if #chatLog > maxLogEntries then
        table.remove(chatLog, #chatLog)
    end
    
    -- Update UI
    local searchTerm = loggerSearchInput.Text:lower()
    if searchTerm == "" or message:lower():find(searchTerm) or playerName:lower():find(searchTerm) then
        local entryFrame = Instance.new("Frame")
        entryFrame.Size = UDim2.new(1, 0, 0, 22)
        entryFrame.BackgroundColor3 = isSelf and Color3.fromRGB(230, 245, 255) or Color3.fromRGB(250, 250, 250)
        entryFrame.Parent = loggerScroll
        
        local entryCorner = Instance.new("UICorner")
        entryCorner.CornerRadius = UDim.new(0, 4)
        entryCorner.Parent = entryFrame
        
        local entryText = Instance.new("TextLabel")
        entryText.Size = UDim2.new(1, -10, 1, 0)
        entryText.Position = UDim2.new(0, 5, 0, 0)
        entryText.BackgroundTransparency = 1
        entryText.TextColor3 = COLORS.textDark
        entryText.Text = string.format("[%s] %s: %s", entry.time, playerName, message)
        entryText.Font = Enum.Font.Gotham
        entryText.TextSize = 11
        entryText.TextXAlignment = Enum.TextXAlignment.Left
        entryText.TextTruncate = Enum.TextTruncate.AtEnd
        entryText.Parent = entryFrame
        
        loggerScroll.CanvasSize = UDim2.new(0, 0, 0, loggerLayout.AbsoluteContentSize.Y + 10)
    end
    
    loggerStats.Text = "Messages: " .. #chatLog
end

local function refreshLoggerDisplay()
    for _, child in pairs(loggerScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local searchTerm = loggerSearchInput.Text:lower()
    
    for _, entry in ipairs(chatLog) do
        if searchTerm == "" or entry.message:lower():find(searchTerm) or entry.player:lower():find(searchTerm) then
            local entryFrame = Instance.new("Frame")
            entryFrame.Size = UDim2.new(1, 0, 0, 22)
            entryFrame.BackgroundColor3 = entry.isSelf and Color3.fromRGB(230, 245, 255) or Color3.fromRGB(250, 250, 250)
            entryFrame.Parent = loggerScroll
            
            local entryCorner = Instance.new("UICorner")
            entryCorner.CornerRadius = UDim.new(0, 4)
            entryCorner.Parent = entryFrame
            
            local entryText = Instance.new("TextLabel")
            entryText.Size = UDim2.new(1, -10, 1, 0)
            entryText.Position = UDim2.new(0, 5, 0, 0)
            entryText.BackgroundTransparency = 1
            entryText.TextColor3 = COLORS.textDark
            entryText.Text = string.format("[%s] %s: %s", entry.time, entry.player, entry.message)
            entryText.Font = Enum.Font.Gotham
            entryText.TextSize = 11
            entryText.TextXAlignment = Enum.TextXAlignment.Left
            entryText.TextTruncate = Enum.TextTruncate.AtEnd
            entryText.Parent = entryFrame
        end
    end
    
    loggerScroll.CanvasSize = UDim2.new(0, 0, 0, loggerLayout.AbsoluteContentSize.Y + 10)
end

loggerSearchInput:GetPropertyChangedSignal("Text"):Connect(refreshLoggerDisplay)

loggerClearBtn.MouseButton1Click:Connect(function()
    chatLog = {}
    for _, child in pairs(loggerScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    loggerStats.Text = "Messages: 0"
end)

-- Hook into chat events for logging
local function hookPlayerChat(plr)
    plr.Chatted:Connect(function(msg)
        addLogEntry(plr.Name, msg, plr == player)
    end)
end

for _, plr in pairs(Players:GetPlayers()) do
    hookPlayerChat(plr)
end

Players.PlayerAdded:Connect(hookPlayerChat)

-- ========== MESSAGE SCHEDULER ==========

local schedulerId = 0

local function updateSchedulerUI()
    for _, child in pairs(schedulerScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    for i, item in ipairs(scheduledMessages) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Size = UDim2.new(1, 0, 0, 35)
        itemFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        itemFrame.Parent = schedulerScroll
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 5)
        itemCorner.Parent = itemFrame
        
        local itemText = Instance.new("TextLabel")
        itemText.Size = UDim2.new(1, -60, 0, 18)
        itemText.Position = UDim2.new(0, 8, 0, 2)
        itemText.BackgroundTransparency = 1
        itemText.TextColor3 = COLORS.textDark
        itemText.Text = item.message
        itemText.Font = Enum.Font.Gotham
        itemText.TextSize = 10
        itemText.TextXAlignment = Enum.TextXAlignment.Left
        itemText.TextTruncate = Enum.TextTruncate.AtEnd
        itemText.Parent = itemFrame
        
        local itemInfo = Instance.new("TextLabel")
        itemInfo.Size = UDim2.new(1, -60, 0, 14)
        itemInfo.Position = UDim2.new(0, 8, 0, 18)
        itemInfo.BackgroundTransparency = 1
        itemInfo.TextColor3 = COLORS.textMuted
        itemInfo.Text = string.format("%s | Delay: %ds", item.type, item.delay)
        itemInfo.Font = Enum.Font.Gotham
        itemInfo.TextSize = 9
        itemInfo.TextXAlignment = Enum.TextXAlignment.Left
        itemInfo.Parent = itemFrame
        
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 28, 0, 25)
        deleteBtn.Position = UDim2.new(1, -32, 0.5, -12)
        deleteBtn.BackgroundColor3 = COLORS.buttonDanger
        deleteBtn.TextColor3 = COLORS.textLight
        deleteBtn.Text = "✕"
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.TextSize = 10
        deleteBtn.Parent = itemFrame
        
        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, 5)
        deleteCorner.Parent = deleteBtn
        
        deleteBtn.MouseButton1Click:Connect(function()
            table.remove(scheduledMessages, i)
            updateSchedulerUI()
        end)
    end
    
    schedulerScroll.CanvasSize = UDim2.new(0, 0, 0, schedulerLayout.AbsoluteContentSize.Y + 10)
end

schedulerAddBtn.MouseButton1Click:Connect(function()
    local msg = schedulerMsgInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
    local delay = tonumber(schedulerDelayInput.Text) or 5
    
    if msg ~= "" then
        schedulerId = schedulerId + 1
        table.insert(scheduledMessages, {
            id = schedulerId,
            message = msg,
            delay = delay,
            type = schedulerType
        })
        schedulerMsgInput.Text = ""
        updateSchedulerUI()
        
        if not schedulerRunning then
            schedulerRunning = true
            spawn(function()
                while #scheduledMessages > 0 do
                    local now = tick()
                    for i = #scheduledMessages, 1, -1 do
                        local item = scheduledMessages[i]
                        if item.delay <= 0 then
                            sendMessage(item.message)
                            if item.type == "Once" then
                                table.remove(scheduledMessages, i)
                            elseif item.type == "Repeat" then
                                item.delay = tonumber(schedulerDelayInput.Text) or 5
                            end
                        else
                            item.delay = item.delay - 0.1
                        end
                    end
                    updateSchedulerUI()
                    wait(0.1)
                end
                schedulerRunning = false
            end)
        end
    end
end)

for stype, btn in pairs(schedulerTypeBtns) do
    btn.MouseButton1Click:Connect(function()
        schedulerType = stype
        for m, b in pairs(schedulerTypeBtns) do
            if m == stype then
                b.BackgroundColor3 = COLORS.buttonPrimary
                b.TextColor3 = COLORS.textLight
            else
                b.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
                b.TextColor3 = COLORS.textDark
            end
        end
    end)
end

-- ========== SPAM PATTERNS ==========

for mode, btn in pairs(patternModeBtns) do
    btn.MouseButton1Click:Connect(function()
        spamPattern = mode
        countSettings.Visible = mode == "COUNT"
        alternateSettings.Visible = mode == "ALTERNATE"
        
        for m, b in pairs(patternModeBtns) do
            if m == mode then
                b.BackgroundColor3 = COLORS.buttonPrimary
                b.TextColor3 = COLORS.textLight
            else
                b.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
                b.TextColor3 = COLORS.textDark
            end
        end
    end)
end

local function getSpamMessage()
    if spamPattern == "NORMAL" then
        if #premadeMessages > 0 then
            local msg = premadeMessages[spamIndex]
            spamIndex = spamIndex + 1
            if spamIndex > #premadeMessages then spamIndex = 1 end
            return msg
        else
            return chatTextbox.Text
        end
    elseif spamPattern == "COUNT" then
        local start = tonumber(countStartInput.Text) or 1
        local prefix = countPrefixInput.Text
        countStartInput.Text = tostring(start + 1)
        return prefix .. tostring(start)
    elseif spamPattern == "RANDOM" then
        if #premadeMessages > 0 then
            return premadeMessages[math.random(1, #premadeMessages)]
        else
            return chatTextbox.Text
        end
    elseif spamPattern == "ALTERNATE" then
        local msgs = {altMsg1Input.Text, altMsg2Input.Text, altMsg3Input.Text}
        local validMsgs = {}
        for _, m in ipairs(msgs) do
            if m ~= "" then table.insert(validMsgs, m) end
        end
        
        if #validMsgs > 0 then
            local msg = validMsgs[spamIndex]
            spamIndex = spamIndex + 1
            if spamIndex > #validMsgs then spamIndex = 1 end
            return msg
        else
            return "Message " .. spamIndex
        end
    end
    return chatTextbox.Text
end

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

local spamRandomizeEnabled = false

spamRandomizeToggle.MouseButton1Click:Connect(function()
    spamRandomizeEnabled = not spamRandomizeEnabled
    spamRandomizeToggle.Text = spamRandomizeEnabled and "ON" or "OFF"
    spamRandomizeToggle.BackgroundColor3 = spamRandomizeEnabled and COLORS.buttonSuccess or COLORS.buttonOff
end)

spamToggle.MouseButton1Click:Connect(function()
    spamEnabled = not spamEnabled
    spamDelay = tonumber(spamDelayInput.Text) or 1
    if spamDelay < 0.1 then spamDelay = 0.1 end
    
    if spamEnabled then
        spamToggle.Text = "SPAM: ON"
        spamToggle.BackgroundColor3 = COLORS.buttonSuccess
        
        spawn(function()
            while spamEnabled do
                local msg = getSpamMessage()
                sendMessage(msg)
                
                local actualDelay = spamDelay
                if spamRandomizeEnabled then
                    actualDelay = spamDelay + (math.random() * spamDelay * 0.5)
                end
                
                wait(actualDelay)
            end
        end)
    else
        spamToggle.Text = "SPAM: OFF"
        spamToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

-- ========== AUTO-REPLY ==========

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

keywordToggleBtn.MouseButton1Click:Connect(function()
    keywordEnabled = not keywordEnabled
    keywordToggleBtn.Text = keywordEnabled and "ON" or "OFF"
    keywordToggleBtn.BackgroundColor3 = keywordEnabled and COLORS.buttonSuccess or COLORS.buttonOff
end)

-- Auto-Reply Message Detection
local function handleChat(plr, msg)
    addLogEntry(plr.Name, msg, plr == player)
    
    if autoReplyEnabled and autoReplyTargets[plr.Name:lower()] then
        local data = autoReplyTargets[plr.Name:lower()]
        local reply = data.messages[data.index]
        data.index = data.index + 1
        if data.index > #data.messages then
            data.index = 1
        end
        wait(0.5 + math.random() * 0.5)
        sendReply(reply)
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg)
        handleChat(plr, msg)
    end)
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then
        plr.Chatted:Connect(function(msg)
            handleChat(plr, msg)
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

local function toggleAfkMethod(method, btn)
    afkMethods[method] = not afkMethods[method]
    if afkMethods[method] then
        btn.Text = method .. " ✓"
        btn.BackgroundColor3 = COLORS.buttonSuccess
    else
        btn.Text = method
        btn.BackgroundColor3 = COLORS.buttonOff
    end
end

afkVirtualUserBtn.MouseButton1Click:Connect(function()
    toggleAfkMethod("virtualUser", afkVirtualUserBtn)
end)

afkMovementBtn.MouseButton1Click:Connect(function()
    toggleAfkMethod("movement", afkMovementBtn)
end)

afkJumpBtn.MouseButton1Click:Connect(function()
    toggleAfkMethod("jump", afkJumpBtn)
end)

spawn(function()
    while true do
        local interval = tonumber(afkIntervalInput.Text) or 60
        local randomAdd = math.random(5, 15)
        wait(interval + randomAdd)
        
        if antiAfkEnabled then
            local vu = game:GetService("VirtualUser")
            
            if afkMethods.virtualUser then
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end
            
            if afkMethods.movement then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 0.1)
                    wait(0.1)
                    hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -0.1)
                end
            end
            
            if afkMethods.jump then
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.Jump = true
                end
            end
        end
    end
end)

-- ========== SETTINGS HANDLERS ==========

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

fixedPrefixInput:GetPropertyChangedSignal("Text"):Connect(updatePrefixStatus)
rotatingPrefixInput:GetPropertyChangedSignal("Text"):Connect(updatePrefixStatus)

typingToggleBtn.MouseButton1Click:Connect(function()
    typingEnabled = not typingEnabled
    typingToggleBtn.Text = typingEnabled and "ON" or "OFF"
    typingToggleBtn.BackgroundColor3 = typingEnabled and COLORS.buttonSuccess or COLORS.buttonOff
end)

transparencySlider.FocusLost:Connect(function()
    local val = tonumber(transparencySlider.Text) or 0
    val = math.clamp(val, 0, 100)
    transparencySlider.Text = tostring(val)
    guiTransparency = val / 100
    
    hubFrame.BackgroundTransparency = guiTransparency
    titleBar.BackgroundTransparency = guiTransparency
    titleBarFix.BackgroundTransparency = guiTransparency
end)

scaleSlider.FocusLost:Connect(function()
    local val = tonumber(scaleSlider.Text) or 1
    val = math.clamp(val, 0.5, 2.0)
    scaleSlider.Text = tostring(val)
    guiScale = val
    
    hubFrame.Size = UDim2.new(0, 600 * guiScale, 0, 350 * guiScale)
    hubFrame.Position = UDim2.new(0.5, -300 * guiScale, 0.5, -175 * guiScale)
end)

historyCountInput.FocusLost:Connect(function()
    local val = tonumber(historyCountInput.Text) or 20
    val = math.clamp(val, 5, 100)
    historyCountInput.Text = tostring(val)
    maxHistory = val
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
updateSchedulerUI()

print("✅ Chat Hub v2 Loaded - Logger, Scheduler, Patterns, Quick Responses, Anti-AFK+, Rate Limit Protection")
-- ========== CHUNK 2: ADVANCED FEATURES ==========

-- Extend existing variables
local whisperMode = false
local tradeModeEnabled = false
local tradeMessages = {"WTT [item]", "Looking for trades!", "DM me for trades"}
local tradeInterval = 180
local grindModeEnabled = false
local grindMessages = {"Buying X paying Y", "Selling Z for W"}
local grindInterval = 120
local autoGGEnabled = false
local autoGGMessages = {"GG", "gg", "Good game!", "GG wp"}
local pingKeywords = {}
local pingEnabled = false
local muteList = {}
local encryptionEnabled = false
local encryptionKey = "secret"
local statsEnabled = true
local smartReplyEnabled = false
local smartReplyCooldown = 30
local lastReplyTimes = {}

-- Stats tracking
local messageStats = {
    sent = 0,
    received = 0,
    autoReplies = 0,
    spamSent = 0,
    startTime = os.time()
}

-- ========== ADD NEW TAB: "Advanced" ==========

-- Update tabs array (need to rebuild tab buttons)
table.insert(tabs, "Advanced")

-- Recreate tab buttons with new tab
for _, child in pairs(tabFrame:GetChildren()) do
    if child:IsA("TextButton") then child:Destroy() end
end

tabButtons = {}
for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1/#tabs, -2, 1, 0)
    tabBtn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    tabBtn.BackgroundColor3 = i == 1 and COLORS.buttonPrimary or Color3.fromRGB(230, 230, 230)
    tabBtn.TextColor3 = i == 1 and COLORS.textLight or COLORS.textDark
    tabBtn.Text = tabName
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 9
    tabBtn.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn
    
    tabButtons[tabName] = tabBtn
end

-- ========== ADVANCED SECTION ==========

local advancedSection = Instance.new("Frame")
advancedSection.Size = UDim2.new(1, 0, 1, 0)
advancedSection.BackgroundTransparency = 1
advancedSection.Visible = false
advancedSection.Parent = contentFrame

-- Advanced Sub-tabs
local advTabFrame = Instance.new("Frame")
advTabFrame.Size = UDim2.new(1, 0, 0, 28)
advTabFrame.Position = UDim2.new(0, 0, 0, 0)
advTabFrame.BackgroundTransparency = 1
advTabFrame.Parent = advancedSection

local advSubTabs = {"Trade", "Grind", "AutoGG", "Alerts", "Muter", "Stats"}
local advSubTabBtns = {}
local currentAdvTab = "Trade"

for i, tabName in ipairs(advSubTabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#advSubTabs, -2, 1, 0)
    btn.Position = UDim2.new((i-1)/#advSubTabs, 0, 0, 0)
    btn.BackgroundColor3 = i == 1 and COLORS.buttonPrimary or Color3.fromRGB(220, 220, 220)
    btn.TextColor3 = i == 1 and COLORS.textLight or COLORS.textDark
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.Parent = advTabFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    advSubTabBtns[tabName] = btn
end

-- Advanced Content Area
local advContent = Instance.new("Frame")
advContent.Size = UDim2.new(1, 0, 1, -35)
advContent.Position = UDim2.new(0, 0, 0, 33)
advContent.BackgroundTransparency = 1
advContent.Parent = advancedSection

-- ========== TRADE MODE PANEL ==========

local tradePanel = Instance.new("Frame")
tradePanel.Size = UDim2.new(1, 0, 1, 0)
tradePanel.BackgroundTransparency = 1
tradePanel.Visible = true
tradePanel.Parent = advContent

-- Trade Toggle
local tradeToggle = Instance.new("TextButton")
tradeToggle.Size = UDim2.new(1, 0, 0, 40)
tradeToggle.Position = UDim2.new(0, 0, 0, 0)
tradeToggle.BackgroundColor3 = COLORS.buttonDanger
tradeToggle.TextColor3 = COLORS.textLight
tradeToggle.Text = "TRADE MODE: OFF"
tradeToggle.Font = Enum.Font.GothamBold
tradeToggle.TextSize = 15
tradeToggle.Parent = tradePanel

local tradeToggleCorner = Instance.new("UICorner")
tradeToggleCorner.CornerRadius = UDim.new(0, 8)
tradeToggleCorner.Parent = tradeToggle

-- Trade Interval
local tradeIntervalRow = Instance.new("Frame")
tradeIntervalRow.Size = UDim2.new(1, 0, 0, 28)
tradeIntervalRow.Position = UDim2.new(0, 0, 0, 48)
tradeIntervalRow.BackgroundTransparency = 1
tradeIntervalRow.Parent = tradePanel

local tradeIntervalLabel = Instance.new("TextLabel")
tradeIntervalLabel.Size = UDim2.new(0, 100, 1, 0)
tradeIntervalLabel.BackgroundTransparency = 1
tradeIntervalLabel.TextColor3 = COLORS.textDark
tradeIntervalLabel.Text = "Interval (sec):"
tradeIntervalLabel.Font = Enum.Font.Gotham
tradeIntervalLabel.TextSize = 11
tradeIntervalLabel.TextXAlignment = Enum.TextXAlignment.Left
tradeIntervalLabel.Parent = tradeIntervalRow

local tradeIntervalInput = Instance.new("TextBox")
tradeIntervalInput.Size = UDim2.new(0, 60, 1, 0)
tradeIntervalInput.Position = UDim2.new(0, 105, 0, 0)
tradeIntervalInput.BackgroundColor3 = COLORS.inputBg
tradeIntervalInput.TextColor3 = COLORS.textDark
tradeIntervalInput.Text = "180"
tradeIntervalInput.Font = Enum.Font.Gotham
tradeIntervalInput.TextSize = 12
tradeIntervalInput.ClearTextOnFocus = false
tradeIntervalInput.Parent = tradeIntervalRow

local tradeIntervalCorner = Instance.new("UICorner")
tradeIntervalCorner.CornerRadius = UDim.new(0, 6)
tradeIntervalCorner.Parent = tradeIntervalInput

local tradeIntervalStroke = Instance.new("UIStroke")
tradeIntervalStroke.Color = COLORS.border
tradeIntervalStroke.Thickness = 1
tradeIntervalStroke.Parent = tradeIntervalInput

local tradeIntervalHint = Instance.new("TextLabel")
tradeIntervalHint.Size = UDim2.new(0, 100, 1, 0)
tradeIntervalHint.Position = UDim2.new(0, 170, 0, 0)
tradeIntervalHint.BackgroundTransparency = 1
tradeIntervalHint.TextColor3 = COLORS.textMuted
tradeIntervalHint.Text = "(+ random 30s)"
tradeIntervalHint.Font = Enum.Font.Gotham
tradeIntervalHint.TextSize = 10
tradeIntervalHint.Parent = tradeIntervalRow

-- Trade Messages Label
local tradeMsgsLabel = Instance.new("TextLabel")
tradeMsgsLabel.Size = UDim2.new(1, 0, 0, 18)
tradeMsgsLabel.Position = UDim2.new(0, 0, 0, 82)
tradeMsgsLabel.BackgroundTransparency = 1
tradeMsgsLabel.TextColor3 = COLORS.textDark
tradeMsgsLabel.Text = "Trade Messages (one per line):"
tradeMsgsLabel.Font = Enum.Font.GothamBold
tradeMsgsLabel.TextSize = 11
tradeMsgsLabel.TextXAlignment = Enum.TextXAlignment.Left
tradeMsgsLabel.Parent = tradePanel

-- Trade Messages Input
local tradeMsgsInput = Instance.new("TextBox")
tradeMsgsInput.Size = UDim2.new(1, 0, 0, 80)
tradeMsgsInput.Position = UDim2.new(0, 0, 0, 100)
tradeMsgsInput.BackgroundColor3 = COLORS.inputBg
tradeMsgsInput.TextColor3 = COLORS.textDark
tradeMsgsInput.Text = "WTT [item] for [item]\nLooking for trades!\nDM me if interested"
tradeMsgsInput.PlaceholderText = "WTT [item]\nLooking for trades!\nDM me"
tradeMsgsInput.PlaceholderColor3 = COLORS.textMuted
tradeMsgsInput.Font = Enum.Font.Gotham
tradeMsgsInput.TextSize = 11
tradeMsgsInput.TextXAlignment = Enum.TextXAlignment.Left
tradeMsgsInput.TextYAlignment = Enum.TextYAlignment.Top
tradeMsgsInput.MultiLine = true
tradeMsgsInput.TextWrapped = true
tradeMsgsInput.ClearTextOnFocus = false
tradeMsgsInput.Parent = tradePanel

local tradeMsgsCorner = Instance.new("UICorner")
tradeMsgsCorner.CornerRadius = UDim.new(0, 6)
tradeMsgsCorner.Parent = tradeMsgsInput

local tradeMsgsStroke = Instance.new("UIStroke")
tradeMsgsStroke.Color = COLORS.border
tradeMsgsStroke.Thickness = 1
tradeMsgsStroke.Parent = tradeMsgsInput

-- Trade Info
local tradeInfo = Instance.new("TextLabel")
tradeInfo.Size = UDim2.new(1, 0, 0, 35)
tradeInfo.Position = UDim2.new(0, 0, 1, -45)
tradeInfo.BackgroundTransparency = 1
tradeInfo.TextColor3 = COLORS.textMuted
tradeInfo.Text = "Auto-bumps your trade offers.\nRandom interval helps avoid detection.\nStops automatically when someone responds."
tradeInfo.Font = Enum.Font.Gotham
tradeInfo.TextSize = 10
tradeInfo.TextXAlignment = Enum.TextXAlignment.Left
tradeInfo.TextYAlignment = Enum.TextYAlignment.Top
tradeInfo.Parent = tradePanel

-- ========== GRIND MODE PANEL ==========

local grindPanel = Instance.new("Frame")
grindPanel.Size = UDim2.new(1, 0, 1, 0)
grindPanel.BackgroundTransparency = 1
grindPanel.Visible = false
grindPanel.Parent = advContent

-- Grind Toggle
local grindToggle = Instance.new("TextButton")
grindToggle.Size = UDim2.new(1, 0, 0, 40)
grindToggle.Position = UDim2.new(0, 0, 0, 0)
grindToggle.BackgroundColor3 = COLORS.buttonDanger
grindToggle.TextColor3 = COLORS.textLight
grindToggle.Text = "GRIND MODE: OFF"
grindToggle.Font = Enum.Font.GothamBold
grindToggle.TextSize = 15
grindToggle.Parent = grindPanel

local grindToggleCorner = Instance.new("UICorner")
grindToggleCorner.CornerRadius = UDim.new(0, 8)
grindToggleCorner.Parent = grindToggle

-- Grind Interval
local grindIntervalRow = Instance.new("Frame")
grindIntervalRow.Size = UDim2.new(1, 0, 0, 28)
grindIntervalRow.Position = UDim2.new(0, 0, 0, 48)
grindIntervalRow.BackgroundTransparency = 1
grindIntervalRow.Parent = grindPanel

local grindIntervalLabel = Instance.new("TextLabel")
grindIntervalLabel.Size = UDim2.new(0, 100, 1, 0)
grindIntervalLabel.BackgroundTransparency = 1
grindIntervalLabel.TextColor3 = COLORS.textDark
grindIntervalLabel.Text = "Interval (sec):"
grindIntervalLabel.Font = Enum.Font.Gotham
grindIntervalLabel.TextSize = 11
grindIntervalLabel.TextXAlignment = Enum.TextXAlignment.Left
grindIntervalLabel.Parent = grindIntervalRow

local grindIntervalInput = Instance.new("TextBox")
grindIntervalInput.Size = UDim2.new(0, 60, 1, 0)
grindIntervalInput.Position = UDim2.new(0, 105, 0, 0)
grindIntervalInput.BackgroundColor3 = COLORS.inputBg
grindIntervalInput.TextColor3 = COLORS.textDark
grindIntervalInput.Text = "120"
grindIntervalInput.Font = Enum.Font.Gotham
grindIntervalInput.TextSize = 12
grindIntervalInput.ClearTextOnFocus = false
grindIntervalInput.Parent = grindIntervalRow

local grindIntervalCorner = Instance.new("UICorner")
grindIntervalCorner.CornerRadius = UDim.new(0, 6)
grindIntervalCorner.Parent = grindIntervalInput

local grindIntervalStroke = Instance.new("UIStroke")
grindIntervalStroke.Color = COLORS.border
grindIntervalStroke.Thickness = 1
grindIntervalStroke.Parent = grindIntervalInput

-- Stop on Response Toggle
local stopResponseRow = Instance.new("Frame")
stopResponseRow.Size = UDim2.new(1, 0, 0, 28)
stopResponseRow.Position = UDim2.new(0, 0, 0, 82)
stopResponseRow.BackgroundTransparency = 1
stopResponseRow.Parent = grindPanel

local stopResponseLabel = Instance.new("TextLabel")
stopResponseLabel.Size = UDim2.new(0, 130, 1, 0)
stopResponseLabel.BackgroundTransparency = 1
stopResponseLabel.TextColor3 = COLORS.textDark
stopResponseLabel.Text = "Stop on Response:"
stopResponseLabel.Font = Enum.Font.Gotham
stopResponseLabel.TextSize = 11
stopResponseLabel.TextXAlignment = Enum.TextXAlignment.Left
stopResponseLabel.Parent = stopResponseRow

local stopResponseBtn = Instance.new("TextButton")
stopResponseBtn.Size = UDim2.new(0, 50, 1, 0)
stopResponseBtn.Position = UDim2.new(0, 135, 0, 0)
stopResponseBtn.BackgroundColor3 = COLORS.buttonSuccess
stopResponseBtn.TextColor3 = COLORS.textLight
stopResponseBtn.Text = "ON"
stopResponseBtn.Font = Enum.Font.GothamBold
stopResponseBtn.TextSize = 11
stopResponseBtn.Parent = stopResponseRow

local stopResponseCorner = Instance.new("UICorner")
stopResponseCorner.CornerRadius = UDim.new(0, 6)
stopResponseCorner.Parent = stopResponseBtn

local stopResponseEnabled = true

-- Grind Messages Label
local grindMsgsLabel = Instance.new("TextLabel")
grindMsgsLabel.Size = UDim2.new(1, 0, 0, 18)
grindMsgsLabel.Position = UDim2.new(0, 0, 0, 115)
grindMsgsLabel.BackgroundTransparency = 1
grindMsgsLabel.TextColor3 = COLORS.textDark
grindMsgsLabel.Text = "Grind/Buy/Sell Messages:"
grindMsgsLabel.Font = Enum.Font.GothamBold
grindMsgsLabel.TextSize = 11
grindMsgsLabel.TextXAlignment = Enum.TextXAlignment.Left
grindMsgsLabel.Parent = grindPanel

-- Grind Messages Input
local grindMsgsInput = Instance.new("TextBox")
grindMsgsInput.Size = UDim2.new(1, 0, 0, 70)
grindMsgsInput.Position = UDim2.new(0, 0, 0, 133)
grindMsgsInput.BackgroundColor3 = COLORS.inputBg
grindMsgsInput.TextColor3 = COLORS.textDark
grindMsgsInput.Text = "Buying [item] paying [price]\nSelling [item] for [price]"
grindMsgsInput.PlaceholderText = "Buying X, paying Y\nSelling Z for W"
grindMsgsInput.PlaceholderColor3 = COLORS.textMuted
grindMsgsInput.Font = Enum.Font.Gotham
grindMsgsInput.TextSize = 11
grindMsgsInput.TextXAlignment = Enum.TextXAlignment.Left
grindMsgsInput.TextYAlignment = Enum.TextYAlignment.Top
grindMsgsInput.MultiLine = true
grindMsgsInput.TextWrapped = true
grindMsgsInput.ClearTextOnFocus = false
grindMsgsInput.Parent = grindPanel

local grindMsgsCorner = Instance.new("UICorner")
grindMsgsCorner.CornerRadius = UDim.new(0, 6)
grindMsgsCorner.Parent = grindMsgsInput

local grindMsgsStroke = Instance.new("UIStroke")
grindMsgsStroke.Color = COLORS.border
grindMsgsStroke.Thickness = 1
grindMsgsStroke.Parent = grindMsgsInput

-- ========== AUTO-GG PANEL ==========

local autoGGPanel = Instance.new("Frame")
autoGGPanel.Size = UDim2.new(1, 0, 1, 0)
autoGGPanel.BackgroundTransparency = 1
autoGGPanel.Visible = false
autoGGPanel.Parent = advContent

-- Auto-GG Toggle
local autoGGToggle = Instance.new("TextButton")
autoGGToggle.Size = UDim2.new(1, 0, 0, 40)
autoGGToggle.Position = UDim2.new(0, 0, 0, 0)
autoGGToggle.BackgroundColor3 = COLORS.buttonDanger
autoGGToggle.TextColor3 = COLORS.textLight
autoGGToggle.Text = "AUTO-GG: OFF"
autoGGToggle.Font = Enum.Font.GothamBold
autoGGToggle.TextSize = 15
autoGGToggle.Parent = autoGGPanel

local autoGGToggleCorner = Instance.new("UICorner")
autoGGToggleCorner.CornerRadius = UDim.new(0, 8)
autoGGToggleCorner.Parent = autoGGToggle

-- Auto-GG Settings
local autoGGSettingsLabel = Instance.new("TextLabel")
autoGGSettingsLabel.Size = UDim2.new(1, 0, 0, 20)
autoGGSettingsLabel.Position = UDim2.new(0, 0, 0, 48)
autoGGSettingsLabel.BackgroundTransparency = 1
autoGGSettingsLabel.TextColor3 = COLORS.textDark
autoGGSettingsLabel.Text = "Trigger Settings"
autoGGSettingsLabel.Font = Enum.Font.GothamBold
autoGGSettingsLabel.TextSize = 12
autoGGSettingsLabel.TextXAlignment = Enum.TextXAlignment.Left
autoGGSettingsLabel.Parent = autoGGPanel

-- Detect Game End
local detectEndRow = Instance.new("Frame")
detectEndRow.Size = UDim2.new(1, 0, 0, 28)
detectEndRow.Position = UDim2.new(0, 0, 0, 70)
detectEndRow.BackgroundTransparency = 1
detectEndRow.Parent = autoGGPanel

local detectEndLabel = Instance.new("TextLabel")
detectEndLabel.Size = UDim2.new(0, 150, 1, 0)
detectEndLabel.BackgroundTransparency = 1
detectEndLabel.TextColor3 = COLORS.textDark
detectEndLabel.Text = "Detect Game End:"
detectEndLabel.Font = Enum.Font.Gotham
detectEndLabel.TextSize = 11
detectEndLabel.TextXAlignment = Enum.TextXAlignment.Left
detectEndLabel.Parent = detectEndRow

local detectEndBtn = Instance.new("TextButton")
detectEndBtn.Size = UDim2.new(0, 50, 1, 0)
detectEndBtn.Position = UDim2.new(0, 155, 0, 0)
detectEndBtn.BackgroundColor3 = COLORS.buttonSuccess
detectEndBtn.TextColor3 = COLORS.textLight
detectEndBtn.Text = "ON"
detectEndBtn.Font = Enum.Font.GothamBold
detectEndBtn.TextSize = 11
detectEndBtn.Parent = detectEndRow

local detectEndCorner = Instance.new("UICorner")
detectEndCorner.CornerRadius = UDim.new(0, 6)
detectEndCorner.Parent = detectEndBtn

local detectEndEnabled = true

-- Detect Death
local detectDeathRow = Instance.new("Frame")
detectDeathRow.Size = UDim2.new(1, 0, 0, 28)
detectDeathRow.Position = UDim2.new(0, 0, 0, 100)
detectDeathRow.BackgroundTransparency = 1
detectDeathRow.Parent = autoGGPanel

local detectDeathLabel = Instance.new("TextLabel")
detectDeathLabel.Size = UDim2.new(0, 150, 1, 0)
detectDeathLabel.BackgroundTransparency = 1
detectDeathLabel.TextColor3 = COLORS.textDark
detectDeathLabel.Text = "Auto-Say on Death:"
detectDeathLabel.Font = Enum.Font.Gotham
detectDeathLabel.TextSize = 11
detectDeathLabel.TextXAlignment = Enum.TextXAlignment.Left
detectDeathLabel.Parent = detectDeathRow

local detectDeathBtn = Instance.new("TextButton")
detectDeathBtn.Size = UDim2.new(0, 50, 1, 0)
detectDeathBtn.Position = UDim2.new(0, 155, 0, 0)
detectDeathBtn.BackgroundColor3 = COLORS.buttonOff
detectDeathBtn.TextColor3 = COLORS.textLight
detectDeathBtn.Text = "OFF"
detectDeathBtn.Font = Enum.Font.GothamBold
detectDeathBtn.TextSize = 11
detectDeathBtn.Parent = detectDeathRow

local detectDeathCorner = Instance.new("UICorner")
detectDeathCorner.CornerRadius = UDim.new(0, 6)
detectDeathCorner.Parent = detectDeathBtn

local detectDeathEnabled = false

-- Death Messages
local deathMsgsLabel = Instance.new("TextLabel")
deathMsgsLabel.Size = UDim2.new(1, 0, 0, 18)
deathMsgsLabel.Position = UDim2.new(0, 0, 0, 132)
deathMsgsLabel.BackgroundTransparency = 1
deathMsgsLabel.TextColor3 = COLORS.textDark
deathMsgsLabel.Text = "Death Messages (random):"
deathMsgsLabel.Font = Enum.Font.Gotham
deathMsgsLabel.TextSize = 11
deathMsgsLabel.TextXAlignment = Enum.TextXAlignment.Left
deathMsgsLabel.Parent = autoGGPanel

local deathMsgsInput = Instance.new("TextBox")
deathMsgsInput.Size = UDim2.new(1, 0, 0, 45)
deathMsgsInput.Position = UDim2.new(0, 0, 0, 150)
deathMsgsInput.BackgroundColor3 = COLORS.inputBg
deathMsgsInput.TextColor3 = COLORS.textDark
deathMsgsInput.Text = "rip\nlol\nbruh"
deathMsgsInput.PlaceholderColor3 = COLORS.textMuted
deathMsgsInput.Font = Enum.Font.Gotham
deathMsgsInput.TextSize = 11
deathMsgsInput.TextXAlignment = Enum.TextXAlignment.Left
deathMsgsInput.TextYAlignment = Enum.TextYAlignment.Top
deathMsgsInput.MultiLine = true
deathMsgsInput.ClearTextOnFocus = false
deathMsgsInput.Parent = autoGGPanel

local deathMsgsCorner = Instance.new("UICorner")
deathMsgsCorner.CornerRadius = UDim.new(0, 6)
deathMsgsCorner.Parent = deathMsgsInput

local deathMsgsStroke = Instance.new("UIStroke")
deathMsgsStroke.Color = COLORS.border
deathMsgsStroke.Thickness = 1
deathMsgsStroke.Parent = deathMsgsInput

-- GG Messages Label
local ggMsgsLabel = Instance.new("TextLabel")
ggMsgsLabel.Size = UDim2.new(1, 0, 0, 18)
ggMsgsLabel.Position = UDim2.new(0, 0, 0, 200)
ggMsgsLabel.BackgroundTransparency = 1
ggMsgsLabel.TextColor3 = COLORS.textDark
ggMsgsLabel.Text = "GG Messages (one per line):"
ggMsgsLabel.Font = Enum.Font.GothamBold
ggMsgsLabel.TextSize = 11
ggMsgsLabel.TextXAlignment = Enum.TextXAlignment.Left
ggMsgsLabel.Parent = autoGGPanel

-- GG Messages Input
local ggMsgsInput = Instance.new("TextBox")
ggMsgsInput.Size = UDim2.new(1, 0, 0, 45)
ggMsgsInput.Position = UDim2.new(0, 0, 0, 218)
ggMsgsInput.BackgroundColor3 = COLORS.inputBg
ggMsgsInput.TextColor3 = COLORS.textDark
ggMsgsInput.Text = "GG\ngg\nGood game!\nGG wp"
ggMsgsInput.PlaceholderColor3 = COLORS.textMuted
ggMsgsInput.Font = Enum.Font.Gotham
ggMsgsInput.TextSize = 11
ggMsgsInput.TextXAlignment = Enum.TextXAlignment.Left
ggMsgsInput.TextYAlignment = Enum.TextYAlignment.Top
ggMsgsInput.MultiLine = true
ggMsgsInput.ClearTextOnFocus = false
ggMsgsInput.Parent = autoGGPanel

local ggMsgsCorner = Instance.new("UICorner")
ggMsgsCorner.CornerRadius = UDim.new(0, 6)
ggMsgsCorner.Parent = ggMsgsInput

local ggMsgsStroke = Instance.new("UIStroke")
ggMsgsStroke.Color = COLORS.border
ggMsgsStroke.Thickness = 1
ggMsgsStroke.Parent = ggMsgsInput

-- ========== ALERTS/PING PANEL ==========

local alertsPanel = Instance.new("Frame")
alertsPanel.Size = UDim2.new(1, 0, 1, 0)
alertsPanel.BackgroundTransparency = 1
alertsPanel.Visible = false
alertsPanel.Parent = advContent

-- Alerts Toggle
local alertsToggle = Instance.new("TextButton")
alertsToggle.Size = UDim2.new(1, 0, 0, 40)
alertsToggle.Position = UDim2.new(0, 0, 0, 0)
alertsToggle.BackgroundColor3 = COLORS.buttonDanger
alertsToggle.TextColor3 = COLORS.textLight
alertsToggle.Text = "KEYWORD ALERTS: OFF"
alertsToggle.Font = Enum.Font.GothamBold
alertsToggle.TextSize = 15
alertsToggle.Parent = alertsPanel

local alertsToggleCorner = Instance.new("UICorner")
alertsToggleCorner.CornerRadius = UDim.new(0, 8)
alertsToggleCorner.Parent = alertsToggle

-- Sound Alert Toggle
local soundAlertRow = Instance.new("Frame")
soundAlertRow.Size = UDim2.new(1, 0, 0, 28)
soundAlertRow.Position = UDim2.new(0, 0, 0, 48)
soundAlertRow.BackgroundTransparency = 1
soundAlertRow.Parent = alertsPanel

local soundAlertLabel = Instance.new("TextLabel")
soundAlertLabel.Size = UDim2.new(0, 120, 1, 0)
soundAlertLabel.BackgroundTransparency = 1
soundAlertLabel.TextColor3 = COLORS.textDark
soundAlertLabel.Text = "Play Sound:"
soundAlertLabel.Font = Enum.Font.Gotham
soundAlertLabel.TextSize = 11
soundAlertLabel.TextXAlignment = Enum.TextXAlignment.Left
soundAlertLabel.Parent = soundAlertRow

local soundAlertBtn = Instance.new("TextButton")
soundAlertBtn.Size = UDim2.new(0, 50, 1, 0)
soundAlertBtn.Position = UDim2.new(0, 125, 0, 0)
soundAlertBtn.BackgroundColor3 = COLORS.buttonSuccess
soundAlertBtn.TextColor3 = COLORS.textLight
soundAlertBtn.Text = "ON"
soundAlertBtn.Font = Enum.Font.GothamBold
soundAlertBtn.TextSize = 11
soundAlertBtn.Parent = soundAlertRow

local soundAlertCorner = Instance.new("UICorner")
soundAlertCorner.CornerRadius = UDim.new(0, 6)
soundAlertCorner.Parent = soundAlertBtn

local soundAlertEnabled = true

-- Flash Toggle
local flashAlertRow = Instance.new("Frame")
flashAlertRow.Size = UDim2.new(1, 0, 0, 28)
flashAlertRow.Position = UDim2.new(0, 0, 0, 78)
flashAlertRow.BackgroundTransparency = 1
flashAlertRow.Parent = alertsPanel

local flashAlertLabel = Instance.new("TextLabel")
flashAlertLabel.Size = UDim2.new(0, 120, 1, 0)
flashAlertLabel.BackgroundTransparency = 1
flashAlertLabel.TextColor3 = COLORS.textDark
flashAlertLabel.Text = "Flash GUI:"
flashAlertLabel.Font = Enum.Font.Gotham
flashAlertLabel.TextSize = 11
flashAlertLabel.TextXAlignment = Enum.TextXAlignment.Left
flashAlertLabel.Parent = flashAlertRow

local flashAlertBtn = Instance.new("TextButton")
flashAlertBtn.Size = UDim2.new(0, 50, 1, 0)
flashAlertBtn.Position = UDim2.new(0, 125, 0, 0)
flashAlertBtn.BackgroundColor3 = COLORS.buttonSuccess
flashAlertBtn.TextColor3 = COLORS.textLight
flashAlertBtn.Text = "ON"
flashAlertBtn.Font = Enum.Font.GothamBold
flashAlertBtn.TextSize = 11
flashAlertBtn.Parent = flashAlertRow

local flashAlertCorner = Instance.new("UICorner")
flashAlertCorner.CornerRadius = UDim.new(0, 6)
flashAlertCorner.Parent = flashAlertBtn

local flashAlertEnabled = true

-- Keywords Label
local keywordsLabel = Instance.new("TextLabel")
keywordsLabel.Size = UDim2.new(1, 0, 0, 18)
keywordsLabel.Position = UDim2.new(0, 0, 0, 112)
keywordsLabel.BackgroundTransparency = 1
keywordsLabel.TextColor3 = COLORS.textDark
keywordsLabel.Text = "Alert Keywords (comma separated):"
keywordsLabel.Font = Enum.Font.GothamBold
keywordsLabel.TextSize = 11
keywordsLabel.TextXAlignment = Enum.TextXAlignment.Left
keywordsLabel.Parent = alertsPanel

-- Keywords Input
local keywordsInput = Instance.new("TextBox")
keywordsInput.Size = UDim2.new(1, 0, 0, 35)
keywordsInput.Position = UDim2.new(0, 0, 0, 130)
keywordsInput.BackgroundColor3 = COLORS.inputBg
keywordsInput.TextColor3 = COLORS.textDark
keywordsInput.Text = "glitch, exploit, hack, dupe, free, scam"
keywordsInput.PlaceholderText = "keyword1, keyword2, keyword3"
keywordsInput.PlaceholderColor3 = COLORS.textMuted
keywordsInput.Font = Enum.Font.Gotham
keywordsInput.TextSize = 11
keywordsInput.ClearTextOnFocus = false
keywordsInput.Parent = alertsPanel

local keywordsCorner = Instance.new("UICorner")
keywordsCorner.CornerRadius = UDim.new(0, 6)
keywordsCorner.Parent = keywordsInput

local keywordsStroke = Instance.new("UIStroke")
keywordsStroke.Color = COLORS.border
keywordsStroke.Thickness = 1
keywordsStroke.Parent = keywordsInput

-- Alert Log
local alertLogLabel = Instance.new("TextLabel")
alertLogLabel.Size = UDim2.new(1, 0, 0, 18)
alertLogLabel.Position = UDim2.new(0, 0, 0, 172)
alertLogLabel.BackgroundTransparency = 1
alertLogLabel.TextColor3 = COLORS.textDark
alertLogLabel.Text = "Recent Alerts:"
alertLogLabel.Font = Enum.Font.GothamBold
alertLogLabel.TextSize = 11
alertLogLabel.TextXAlignment = Enum.TextXAlignment.Left
alertLogLabel.Parent = alertsPanel

local alertLogScroll = Instance.new("ScrollingFrame")
alertLogScroll.Size = UDim2.new(1, 0, 0, 80)
alertLogScroll.Position = UDim2.new(0, 0, 0, 190)
alertLogScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
alertLogScroll.ScrollBarThickness = 4
alertLogScroll.Parent = alertsPanel

local alertLogCorner = Instance.new("UICorner")
alertLogCorner.CornerRadius = UDim.new(0, 6)
alertLogCorner.Parent = alertLogScroll

local alertLogLayout = Instance.new("UIListLayout")
alertLogLayout.Padding = UDim.new(0, 2)
alertLogLayout.Parent = alertLogScroll

local alertLog = {}

local function addAlertLog(keyword, playerName, message)
    local entry = {
        keyword = keyword,
        player = playerName,
        message = message,
        time = os.date("%H:%M:%S")
    }
    table.insert(alertLog, 1, entry)
    if #alertLog > 20 then table.remove(alertLog) end
    
    -- Update UI
    local entryFrame = Instance.new("Frame")
    entryFrame.Size = UDim2.new(1, 0, 0, 20)
    entryFrame.BackgroundColor3 = COLORS.buttonWarning or Color3.fromRGB(255, 193, 7)
    entryFrame.Parent = alertLogScroll
    
    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 4)
    entryCorner.Parent = entryFrame
    
    local entryText = Instance.new("TextLabel")
    entryText.Size = UDim2.new(1, -10, 1, 0)
    entryText.Position = UDim2.new(0, 5, 0, 0)
    entryText.BackgroundTransparency = 1
    entryText.TextColor3 = COLORS.textDark
    entryText.Text = string.format("[%s] %s: \"%s\" (%s)", entry.time, playerName, message:sub(1, 30), keyword)
    entryText.Font = Enum.Font.Gotham
    entryText.TextSize = 10
    entryText.TextXAlignment = Enum.TextXAlignment.Left
    entryText.TextTruncate = Enum.TextTruncate.AtEnd
    entryText.Parent = entryFrame
    
    alertLogScroll.CanvasSize = UDim2.new(0, 0, 0, alertLogLayout.AbsoluteContentSize.Y + 10)
end

-- ========== CHART MUTER PANEL ==========

local muterPanel = Instance.new("Frame")
muterPanel.Size = UDim2.new(1, 0, 1, 0)
muterPanel.BackgroundTransparency = 1
muterPanel.Visible = false
muterPanel.Parent = advContent

-- Mute Input Row
local muteInputRow = Instance.new("Frame")
muteInputRow.Size = UDim2.new(1, 0, 0, 28)
muteInputRow.Position = UDim2.new(0, 0, 0, 0)
muteInputRow.BackgroundTransparency = 1
muteInputRow.Parent = muterPanel

local muteInputLabel = Instance.new("TextLabel")
muteInputLabel.Size = UDim2.new(0, 80, 1, 0)
muteInputLabel.BackgroundTransparency = 1
muteInputLabel.TextColor3 = COLORS.textDark
muteInputLabel.Text = "Username:"
muteInputLabel.Font = Enum.Font.Gotham
muteInputLabel.TextSize = 11
muteInputLabel.TextXAlignment = Enum.TextXAlignment.Left
muteInputLabel.Parent = muteInputRow

local muteInput = Instance.new("TextBox")
muteInput.Size = UDim2.new(1, -175, 1, 0)
muteInput.Position = UDim2.new(0, 85, 0, 0)
muteInput.BackgroundColor3 = COLORS.inputBg
muteInput.TextColor3 = COLORS.textDark
muteInput.Text = ""
muteInput.PlaceholderText = "Player to mute..."
muteInput.PlaceholderColor3 = COLORS.textMuted
muteInput.Font = Enum.Font.Gotham
muteInput.TextSize = 11
muteInput.ClearTextOnFocus = true
muteInput.Parent = muteInputRow

local muteInputCorner = Instance.new("UICorner")
muteInputCorner.CornerRadius = UDim.new(0, 6)
muteInputCorner.Parent = muteInput

local muteInputStroke = Instance.new("UIStroke")
muteInputStroke.Color = COLORS.border
muteInputStroke.Thickness = 1
muteInputStroke.Parent = muteInput

local addMuteBtn = Instance.new("TextButton")
addMuteBtn.Size = UDim2.new(0, 80, 1, 0)
addMuteBtn.Position = UDim2.new(1, -85, 0, 0)
addMuteBtn.BackgroundColor3 = COLORS.buttonPrimary
addMuteBtn.TextColor3 = COLORS.textLight
addMuteBtn.Text = "+ Mute"
addMuteBtn.Font = Enum.Font.GothamBold
addMuteBtn.TextSize = 11
addMuteBtn.Parent = muteInputRow

local addMuteCorner = Instance.new("UICorner")
addMuteCorner.CornerRadius = UDim.new(0, 6)
addMuteCorner.Parent = addMuteBtn

-- Muted List Label
local mutedListLabel = Instance.new("TextLabel")
mutedListLabel.Size = UDim2.new(1, 0, 0, 20)
mutedListLabel.Position = UDim2.new(0, 0, 0, 35)
mutedListLabel.BackgroundTransparency = 1
mutedListLabel.TextColor3 = COLORS.textDark
mutedListLabel.Text = "Muted Players:"
mutedListLabel.Font = Enum.Font.GothamBold
mutedListLabel.TextSize = 12
mutedListLabel.TextXAlignment = Enum.TextXAlignment.Left
mutedListLabel.Parent = muterPanel

-- Muted List
local mutedScroll = Instance.new("ScrollingFrame")
mutedScroll.Size = UDim2.new(1, 0, 1, -60)
mutedScroll.Position = UDim2.new(0, 0, 0, 58)
mutedScroll.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
mutedScroll.ScrollBarThickness = 4
mutedScroll.Parent = muterPanel

local mutedScrollCorner = Instance.new("UICorner")
mutedScrollCorner.CornerRadius = UDim.new(0, 6)
mutedScrollCorner.Parent = mutedScroll

local mutedLayout = Instance.new("UIListLayout")
mutedLayout.Padding = UDim.new(0, 5)
mutedLayout.Parent = mutedScroll

local function updateMutedList()
    for _, child in pairs(mutedScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local i = 0
    for _, name in ipairs(muteList) do
        i = i + 1
        local muteFrame = Instance.new("Frame")
        muteFrame.Size = UDim2.new(1, 0, 0, 35)
        muteFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        muteFrame.Parent = mutedScroll
        
        local muteFrameCorner = Instance.new("UICorner")
        muteFrameCorner.CornerRadius = UDim.new(0, 5)
        muteFrameCorner.Parent = muteFrame
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -50, 1, 0)
        nameLabel.Position = UDim2.new(0, 10, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = COLORS.textDark
        nameLabel.Text = name
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 12
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = muteFrame
        
        local unmuteBtn = Instance.new("TextButton")
        unmuteBtn.Size = UDim2.new(0, 35, 0, 25)
        unmuteBtn.Position = UDim2.new(1, -42, 0.5, -12)
        unmuteBtn.BackgroundColor3 = COLORS.buttonDanger
        unmuteBtn.TextColor3 = COLORS.textLight
        unmuteBtn.Text = "Unmute"
        unmuteBtn.Font = Enum.Font.GothamBold
        unmuteBtn.TextSize = 9
        unmuteBtn.Parent = muteFrame
        
        local unmuteCorner = Instance.new("UICorner")
        unmuteCorner.CornerRadius = UDim.new(0, 5)
        unmuteCorner.Parent = unmuteBtn
        
        unmuteBtn.MouseButton1Click:Connect(function()
            for j, n in ipairs(muteList) do
                if n == name then
                    table.remove(muteList, j)
                    break
                end
            end
            updateMutedList()
        end)
    end
    
    mutedScroll.CanvasSize = UDim2.new(0, 0, 0, i * 40)
end

addMuteBtn.MouseButton1Click:Connect(function()
    local name = muteInput.Text:gsub("^%s+", ""):gsub("%s+$", ""):lower()
    if name ~= "" then
        local alreadyMuted = false
        for _, n in ipairs(muteList) do
            if n == name then alreadyMuted = true break end
        end
        if not alreadyMuted then
            table.insert(muteList, name)
            updateMutedList()
        end
        muteInput.Text = ""
    end
end)

-- ========== STATS PANEL ==========

local statsPanel = Instance.new("Frame")
statsPanel.Size = UDim2.new(1, 0, 1, 0)
statsPanel.BackgroundTransparency = 1
statsPanel.Visible = false
statsPanel.Parent = advContent

-- Stats Display
local statsMainFrame = Instance.new("Frame")
statsMainFrame.Size = UDim2.new(1, 0, 0, 180)
statsMainFrame.BackgroundColor3 = COLORS.cardBg
statsMainFrame.Parent = statsPanel

local statsMainCorner = Instance.new("UICorner")
statsMainCorner.CornerRadius = UDim.new(0, 8)
statsMainCorner.Parent = statsMainFrame

local statsMainStroke = Instance.new("UIStroke")
statsMainStroke.Color = COLORS.border
statsMainStroke.Thickness = 1
statsMainStroke.Parent = statsMainFrame

-- Session Time
local sessionTimeLabel = Instance.new("TextLabel")
sessionTimeLabel.Size = UDim2.new(1, 0, 0, 35)
sessionTimeLabel.Position = UDim2.new(0, 0, 0, 5)
sessionTimeLabel.BackgroundTransparency = 1
sessionTimeLabel.TextColor3 = COLORS.textDark
sessionTimeLabel.Text = "Session Time: 0h 0m 0s"
sessionTimeLabel.Font = Enum.Font.GothamBold
sessionTimeLabel.TextSize = 14
sessionTimeLabel.Parent = statsMainFrame

-- Messages Sent
local msgsSentLabel = Instance.new("TextLabel")
msgsSentLabel.Size = UDim2.new(1, 0, 0, 25)
msgsSentLabel.Position = UDim2.new(0, 0, 0, 42)
msgsSentLabel.BackgroundTransparency = 1
msgsSentLabel.TextColor3 = COLORS.textDark
msgsSentLabel.Text = "Messages Sent: 0"
msgsSentLabel.Font = Enum.Font.Gotham
msgsSentLabel.TextSize = 12
msgsSentLabel.TextXAlignment = Enum.TextXAlignment.Left
msgsSentLabel.Parent = statsMainFrame

-- Messages Received
local msgsReceivedLabel = Instance.new("TextLabel")
msgsReceivedLabel.Size = UDim2.new(1, 0, 0, 25)
msgsReceivedLabel.Position = UDim2.new(0, 0, 0, 67)
msgsReceivedLabel.BackgroundTransparency = 1
msgsReceivedLabel.TextColor3 = COLORS.textDark
msgsReceivedLabel.Text = "Messages Received: 0"
msgsReceivedLabel.Font = Enum.Font.Gotham
msgsReceivedLabel.TextSize = 12
msgsReceivedLabel.TextXAlignment = Enum.TextXAlignment.Left
msgsReceivedLabel.Parent = statsMainFrame

-- Auto-Replies Sent
local autoRepliesLabel = Instance.new("TextLabel")
autoRepliesLabel.Size = UDim2.new(1, 0, 0, 25)
autoRepliesLabel.Position = UDim2.new(0, 0, 0, 92)
autoRepliesLabel.BackgroundTransparency = 1
autoRepliesLabel.TextColor3 = COLORS.textDark
autoRepliesLabel.Text = "Auto-Replies Sent: 0"
autoRepliesLabel.Font = Enum.Font.Gotham
autoRepliesLabel.TextSize = 12
autoRepliesLabel.TextXAlignment = Enum.TextXAlignment.Left
autoRepliesLabel.Parent = statsMainFrame

-- Spam Messages
local spamMsgsLabel = Instance.new("TextLabel")
spamMsgsLabel.Size = UDim2.new(1, 0, 0, 25)
spamMsgsLabel.Position = UDim2.new(0, 0, 0, 117)
spamMsgsLabel.BackgroundTransparency = 1
spamMsgsLabel.TextColor3 = COLORS.textDark
spamMsgsLabel.Text = "Spam Messages: 0"
spamMsgsLabel.Font = Enum.Font.Gotham
spamMsgsLabel.TextSize = 12
spamMsgsLabel.TextXAlignment = Enum.TextXAlignment.Left
spamMsgsLabel.Parent = statsMainFrame

-- Msgs Per Minute
local msgsPerMinLabel = Instance.new("TextLabel")
msgsPerMinLabel.Size = UDim2.new(1, 0, 0, 25)
msgsPerMinLabel.Position = UDim2.new(0, 0, 0, 147)
msgsPerMinLabel.BackgroundTransparency = 1
msgsPerMinLabel.TextColor3 = COLORS.textMuted
msgsPerMinLabel.Text = "Messages/Min: 0.0"
msgsPerMinLabel.Font = Enum.Font.Gotham
msgsPerMinLabel.TextSize = 11
msgsPerMinLabel.TextXAlignment = Enum.TextXAlignment.Left
msgsPerMinLabel.Parent = statsMainFrame

-- Reset Stats Button
local resetStatsBtn = Instance.new("TextButton")
resetStatsBtn.Size = UDim2.new(1, 0, 0, 35)
resetStatsBtn.Position = UDim2.new(0, 0, 0, 190)
resetStatsBtn.BackgroundColor3 = COLORS.buttonDanger
resetStatsBtn.TextColor3 = COLORS.textLight
resetStatsBtn.Text = "Reset Statistics"
resetStatsBtn.Font = Enum.Font.GothamBold
resetStatsBtn.TextSize = 12
resetStatsBtn.Parent = statsPanel

local resetStatsCorner = Instance.new("UICorner")
resetStatsCorner.CornerRadius = UDim.new(0, 8)
resetStatsCorner.Parent = resetStatsBtn

resetStatsBtn.MouseButton1Click:Connect(function()
    messageStats.sent = 0
    messageStats.received = 0
    messageStats.autoReplies = 0
    messageStats.spamSent = 0
    messageStats.startTime = os.time()
end)

-- Update stats display
spawn(function()
    while true do
        wait(1)
        local elapsed = os.time() - messageStats.startTime
        local hours = math.floor(elapsed / 3600)
        local mins = math.floor((elapsed % 3600) / 60)
        local secs = elapsed % 60
        
        sessionTimeLabel.Text = string.format("Session Time: %dh %dm %ds", hours, mins, secs)
        msgsSentLabel.Text = "Messages Sent: " .. messageStats.sent
        msgsReceivedLabel.Text = "Messages Received: " .. messageStats.received
        autoRepliesLabel.Text = "Auto-Replies Sent: " .. messageStats.autoReplies
        spamMsgsLabel.Text = "Spam Messages: " .. messageStats.spamSent
        
        local minsElapsed = elapsed / 60
        if minsElapsed > 0 then
            local msgPerMin = messageStats.sent / minsElapsed
            msgsPerMinLabel.Text = string.format("Messages/Min: %.1f", msgPerMin)
        end
    end
end)
