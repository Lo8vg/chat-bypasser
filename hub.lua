-- Chat Hub (Collapsible with Multiple Sections)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local MAX_CHARS = 200
local spamEnabled = false
local spamDelay = 1
local spamIndex = 1
local antiAfkEnabled = false
local autoReplyEnabled = false
local autoReplyTargets = {} -- {["username"] = "reply message"}
local premadeMessages = {"Hello", "GG", "What's up", "Bye"}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========== HUB BUTTON (COLLAPSED) ==========

local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 50, 0, 50)
hubButton.Position = UDim2.new(0, 20, 0.5, -25)
hubButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
hubButton.BorderSizePixel = 2
hubButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
hubButton.Visible = true
hubButton.Parent = screenGui

local hubButtonCorner = Instance.new("UICorner")
hubButtonCorner.CornerRadius = UDim.new(0, 8)
hubButtonCorner.Parent = hubButton

local hubButtonIcon = Instance.new("TextLabel")
hubButtonIcon.Size = UDim2.new(1, 0, 1, 0)
hubButtonIcon.BackgroundTransparency = 1
hubButtonIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
hubButtonIcon.Text = "💬"
hubButtonIcon.Font = Enum.Font.GothamBold
hubButtonIcon.TextSize = 24
hubButtonIcon.Parent = hubButton

-- ========== HUB FRAME (EXPANDED) ==========

local hubFrame = Instance.new("Frame")
hubFrame.Name = "HubFrame"
hubFrame.Size = UDim2.new(0, 280, 0, 380)
hubFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
hubFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
hubFrame.BorderSizePixel = 2
hubFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
hubFrame.Visible = false
hubFrame.Parent = screenGui

local hubFrameCorner = Instance.new("UICorner")
hubFrameCorner.CornerRadius = UDim.new(0, 10)
hubFrameCorner.Parent = hubFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = hubFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 10)
titleBarCorner.Parent = titleBar

local titleBarFix = Instance.new("Frame")
titleBarFix.Size = UDim2.new(1, 0, 0, 10)
titleBarFix.Position = UDim2.new(0, 0, 1, -10)
titleBarFix.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBarFix.BorderSizePixel = 0
titleBarFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "💬 Chat Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 30, 0, 25)
collapseButton.Position = UDim2.new(1, -35, 0, 5)
collapseButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
collapseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
collapseButton.Text = "─"
collapseButton.Font = Enum.Font.GothamBold
collapseButton.TextSize = 14
collapseButton.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseButton

-- Tab Buttons Frame
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -10, 0, 30)
tabFrame.Position = UDim2.new(0, 5, 0, 40)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = hubFrame

-- Tab Buttons
local tabs = {"Chat", "Spam", "AutoReply", "AFK"}
local tabButtons = {}
local currentTab = "Chat"

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.25, -2, 1, 0)
    tabBtn.Position = UDim2.new((i - 1) * 0.25, 0, 0, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.Text = tabName
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 10
    tabBtn.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 4)
    tabCorner.Parent = tabBtn
    
    tabButtons[tabName] = tabBtn
end

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -10, 1, -80)
contentFrame.Position = UDim2.new(0, 5, 0, 75)
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
chatTextbox.Size = UDim2.new(1, 0, 0, 80)
chatTextbox.Position = UDim2.new(0, 0, 0, 0)
chatTextbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
chatTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
chatTextbox.Text = ""
chatTextbox.PlaceholderText = "Type message..."
chatTextbox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
chatTextbox.Font = Enum.Font.Gotham
chatTextbox.TextSize = 14
chatTextbox.TextXAlignment = Enum.TextXAlignment.Left
chatTextbox.TextYAlignment = Enum.TextYAlignment.Top
chatTextbox.MultiLine = true
chatTextbox.TextWrapped = true
chatTextbox.ClearTextOnFocus = false
chatTextbox.Parent = chatSection

local chatTextboxCorner = Instance.new("UICorner")
chatTextboxCorner.CornerRadius = UDim.new(0, 6)
chatTextboxCorner.Parent = chatTextbox

-- Char Counter
local chatCharCounter = Instance.new("TextLabel")
chatCharCounter.Size = UDim2.new(0, 50, 0, 18)
chatCharCounter.Position = UDim2.new(1, -52, 0, 60)
chatCharCounter.BackgroundTransparency = 1
chatCharCounter.TextColor3 = Color3.fromRGB(150, 150, 150)
chatCharCounter.Text = "0/200"
chatCharCounter.Font = Enum.Font.Gotham
chatCharCounter.TextSize = 10
chatCharCounter.Parent = chatSection

-- Chat Button Row
local chatButtonRow = Instance.new("Frame")
chatButtonRow.Size = UDim2.new(1, 0, 0, 35)
chatButtonRow.Position = UDim2.new(0, 0, 0, 85)
chatButtonRow.BackgroundTransparency = 1
chatButtonRow.Parent = chatSection

-- Send Button
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0.5, -2, 1, 0)
sendButton.Position = UDim2.new(0, 0, 0, 0)
sendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Text = "Send"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 12
sendButton.Parent = chatButtonRow

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 6)
sendCorner.Parent = sendButton

-- Delay Input
local delayInput = Instance.new("TextBox")
delayInput.Size = UDim2.new(0.5, -2, 1, 0)
delayInput.Position = UDim2.new(0.5, 2, 0, 0)
delayInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
delayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
delayInput.Text = "1"
delayInput.PlaceholderText = "Delay"
delayInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
delayInput.Font = Enum.Font.Gotham
delayInput.TextSize = 12
delayInput.ClearTextOnFocus = false
delayInput.Parent = chatButtonRow

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 6)
delayCorner.Parent = delayInput

-- Delay Label
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 30, 0, 18)
delayLabel.Position = UDim2.new(1, -30, 0, 8)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
delayLabel.Text = "sec"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 10
delayLabel.Parent = chatButtonRow

-- ========== SPAM SECTION ==========

local spamSection = Instance.new("Frame")
spamSection.Size = UDim2.new(1, 0, 1, 0)
spamSection.BackgroundTransparency = 1
spamSection.Visible = false
spamSection.Parent = contentFrame

-- Spam Toggle
local spamToggle = Instance.new("TextButton")
spamToggle.Size = UDim2.new(1, 0, 0, 35)
spamToggle.Position = UDim2.new(0, 0, 0, 0)
spamToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
spamToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
spamToggle.Text = "SPAM: OFF"
spamToggle.Font = Enum.Font.GothamBold
spamToggle.TextSize = 14
spamToggle.Parent = spamSection

local spamToggleCorner = Instance.new("UICorner")
spamToggleCorner.CornerRadius = UDim.new(0, 6)
spamToggleCorner.Parent = spamToggle

-- Spam Delay Label
local spamDelayLabel = Instance.new("TextLabel")
spamDelayLabel.Size = UDim2.new(0, 50, 0, 20)
spamDelayLabel.Position = UDim2.new(0, 0, 0, 45)
spamDelayLabel.BackgroundTransparency = 1
spamDelayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
spamDelayLabel.Text = "Delay:"
spamDelayLabel.Font = Enum.Font.Gotham
spamDelayLabel.TextSize = 12
spamDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
spamDelayLabel.Parent = spamSection

-- Spam Delay Input
local spamDelayInput = Instance.new("TextBox")
spamDelayInput.Size = UDim2.new(0, 60, 0, 25)
spamDelayInput.Position = UDim2.new(0, 55, 0, 42)
spamDelayInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
spamDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
spamDelayInput.Text = "1"
spamDelayInput.Font = Enum.Font.Gotham
spamDelayInput.TextSize = 12
spamDelayInput.ClearTextOnFocus = false
spamDelayInput.Parent = spamSection

local spamDelayCorner = Instance.new("UICorner")
spamDelayCorner.CornerRadius = UDim.new(0, 4)
spamDelayCorner.Parent = spamDelayInput

-- Premade Messages Toggle
local premadeToggle = Instance.new("TextButton")
premadeToggle.Size = UDim2.new(1, 0, 0, 25)
premadeToggle.Position = UDim2.new(0, 0, 0, 75)
premadeToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
premadeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
premadeToggle.Text = "▼ Premade Messages"
premadeToggle.Font = Enum.Font.GothamBold
premadeToggle.TextSize = 11
premadeToggle.Parent = spamSection

local premadeCorner = Instance.new("UICorner")
premadeCorner.CornerRadius = UDim.new(0, 4)
premadeCorner.Parent = premadeToggle

-- Premade Messages Panel
local premadePanel = Instance.new("Frame")
premadePanel.Size = UDim2.new(1, 0, 0, 180)
premadePanel.Position = UDim2.new(0, 0, 0, 105)
premadePanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
premadePanel.Visible = false
premadePanel.Parent = spamSection

local premadePanelCorner = Instance.new("UICorner")
premadePanelCorner.CornerRadius = UDim.new(0, 6)
premadePanelCorner.Parent = premadePanel

local premadeScroll = Instance.new("ScrollingFrame")
premadeScroll.Size = UDim2.new(1, -10, 1, -35)
premadeScroll.Position = UDim2.new(0, 5, 0, 5)
premadeScroll.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
premadeScroll.ScrollBarThickness = 4
premadeScroll.Parent = premadePanel

local premadeScrollCorner = Instance.new("UICorner")
premadeScrollCorner.CornerRadius = UDim.new(0, 4)
premadeScrollCorner.Parent = premadeScroll

local premadeLayout = Instance.new("UIListLayout")
premadeLayout.Padding = UDim.new(0, 4)
premadeLayout.Parent = premadeScroll

local addPremadeBtn = Instance.new("TextButton")
addPremadeBtn.Size = UDim2.new(1, -10, 0, 25)
addPremadeBtn.Position = UDim2.new(0, 5, 1, -30)
addPremadeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
addPremadeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addPremadeBtn.Text = "+ Add Current Message"
addPremadeBtn.Font = Enum.Font.GothamBold
addPremadeBtn.TextSize = 11
addPremadeBtn.Parent = premadePanel

local addPremadeCorner = Instance.new("UICorner")
addPremadeCorner.CornerRadius = UDim.new(0, 4)
addPremadeCorner.Parent = addPremadeBtn

-- ========== AUTO-REPLY SECTION ==========

local autoReplySection = Instance.new("Frame")
autoReplySection.Size = UDim2.new(1, 0, 1, 0)
autoReplySection.BackgroundTransparency = 1
autoReplySection.Visible = false
autoReplySection.Parent = contentFrame

-- Auto-Reply Toggle
local autoReplyToggle = Instance.new("TextButton")
autoReplyToggle.Size = UDim2.new(1, 0, 0, 35)
autoReplyToggle.Position = UDim2.new(0, 0, 0, 0)
autoReplyToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
autoReplyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoReplyToggle.Text = "AUTO-REPLY: OFF"
autoReplyToggle.Font = Enum.Font.GothamBold
autoReplyToggle.TextSize = 14
autoReplyToggle.Parent = autoReplySection

local autoReplyCorner = Instance.new("UICorner")
autoReplyCorner.CornerRadius = UDim.new(0, 6)
autoReplyCorner.Parent = autoReplyToggle

-- Target Input
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, 0, 0, 20)
targetLabel.Position = UDim2.new(0, 0, 0, 45)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
targetLabel.Text = "Target Username:"
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextSize = 11
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = autoReplySection

local targetInput = Instance.new("TextBox")
targetInput.Size = UDim2.new(1, 0, 0, 30)
targetInput.Position = UDim2.new(0, 0, 0, 68)
targetInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
targetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
targetInput.Text = ""
targetInput.PlaceholderText = "Enter username..."
targetInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
targetInput.Font = Enum.Font.Gotham
targetInput.TextSize = 12
targetInput.ClearTextOnFocus = false
targetInput.Parent = autoReplySection

local targetInputCorner = Instance.new("UICorner")
targetInputCorner.CornerRadius = UDim.new(0, 6)
targetInputCorner.Parent = targetInput

-- Reply Input
local replyLabel = Instance.new("TextLabel")
replyLabel.Size = UDim2.new(1, 0, 0, 20)
replyLabel.Position = UDim2.new(0, 0, 0, 105)
replyLabel.BackgroundTransparency = 1
replyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
replyLabel.Text = "Reply Message:"
replyLabel.Font = Enum.Font.Gotham
replyLabel.TextSize = 11
replyLabel.TextXAlignment = Enum.TextXAlignment.Left
replyLabel.Parent = autoReplySection

local replyInput = Instance.new("TextBox")
replyInput.Size = UDim2.new(1, 0, 0, 50)
replyInput.Position = UDim2.new(0, 0, 0, 128)
replyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
replyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
replyInput.Text = ""
replyInput.PlaceholderText = "Reply message..."
replyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
replyInput.Font = Enum.Font.Gotham
replyInput.TextSize = 12
replyInput.TextXAlignment = Enum.TextXAlignment.Left
replyInput.TextYAlignment = Enum.TextYAlignment.Top
replyInput.MultiLine = true
replyInput.TextWrapped = true
replyInput.ClearTextOnFocus = false
replyInput.Parent = autoReplySection

local replyInputCorner = Instance.new("UICorner")
replyInputCorner.CornerRadius = UDim.new(0, 6)
replyInputCorner.Parent = replyInput

-- Char Counter for Reply
local replyCharCounter = Instance.new("TextLabel")
replyCharCounter.Size = UDim2.new(0, 50, 0, 18)
replyCharCounter.Position = UDim2.new(1, -52, 0, 158)
replyCharCounter.BackgroundTransparency = 1
replyCharCounter.TextColor3 = Color3.fromRGB(150, 150, 150)
replyCharCounter.Text = "0/200"
replyCharCounter.Font = Enum.Font.Gotham
replyCharCounter.TextSize = 10
replyCharCounter.Parent = autoReplySection

-- Add Target Button
local addTargetBtn = Instance.new("TextButton")
addTargetBtn.Size = UDim2.new(1, 0, 0, 30)
addTargetBtn.Position = UDim2.new(0, 0, 0, 185)
addTargetBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
addTargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addTargetBtn.Text = "+ Add Target"
addTargetBtn.Font = Enum.Font.GothamBold
addTargetBtn.TextSize = 12
addTargetBtn.Parent = autoReplySection

local addTargetCorner = Instance.new("UICorner")
addTargetCorner.CornerRadius = UDim.new(0, 6)
addTargetCorner.Parent = addTargetBtn

-- Targets List
local targetsScroll = Instance.new("ScrollingFrame")
targetsScroll.Size = UDim2.new(1, 0, 0, 80)
targetsScroll.Position = UDim2.new(0, 0, 0, 220)
targetsScroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
targetsScroll.ScrollBarThickness = 4
targetsScroll.Parent = autoReplySection

local targetsScrollCorner = Instance.new("UICorner")
targetsScrollCorner.CornerRadius = UDim.new(0, 6)
targetsScrollCorner.Parent = targetsScroll

local targetsLayout = Instance.new("UIListLayout")
targetsLayout.Padding = UDim.new(0, 4)
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
afkToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
afkToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
afkToggle.Text = "ANTI-AFK: OFF"
afkToggle.Font = Enum.Font.GothamBold
afkToggle.TextSize = 16
afkToggle.Parent = afkSection

local afkCorner = Instance.new("UICorner")
afkCorner.CornerRadius = UDim.new(0, 8)
afkCorner.Parent = afkToggle

-- AFK Info
local afkInfo = Instance.new("TextLabel")
afkInfo.Size = UDim2.new(1, 0, 0, 60)
afkInfo.Position = UDim2.new(0, 0, 0, 60)
afkInfo.BackgroundTransparency = 1
afkInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
afkInfo.Text = "Anti-AFK prevents you from\ngetting kicked for inactivity.\n\nWorks in any game."
afkInfo.Font = Enum.Font.Gotham
afkInfo.TextSize = 12
afkInfo.TextWrapped = true
afkInfo.Parent = afkSection

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
    
    for name, btn in pairs(tabButtons) do
        if name == tabName then
            btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        else
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
    chatCharCounter.TextColor3 = #chatTextbox.Text >= MAX_CHARS and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(150, 150, 150)
end)

replyInput:GetPropertyChangedSignal("Text"):Connect(function()
    if #replyInput.Text > MAX_CHARS then
        replyInput.Text = replyInput.Text:sub(1, MAX_CHARS)
    end
    replyCharCounter.Text = #replyInput.Text.."/"..MAX_CHARS
    replyCharCounter.TextColor3 = #replyInput.Text >= MAX_CHARS and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(150, 150, 150)
end)

-- ========== FOCUSED CLEAR ==========

chatTextbox.Focused:Connect(function()
    chatTextbox.Text = ""
end)

-- ========== SEND MESSAGE FUNCTION ==========

local function sendMessage(msg)
    local message = msg or chatTextbox.Text
    message = message:gsub("^%s+", ""):gsub("%s+\$", ""):gsub("\n", " ")
    
    if message == "" or #message > MAX_CHARS then return false end
    
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
        msgFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        msgFrame.Parent = premadeScroll
        
        local msgCorner = Instance.new("UICorner")
        msgCorner.CornerRadius = UDim.new(0, 4)
        msgCorner.Parent = msgFrame
        
        local msgLabel = Instance.new("TextLabel")
        msgLabel.Size = UDim2.new(1, -30, 1, 0)
        msgLabel.Position = UDim2.new(0, 5, 0, 0)
        msgLabel.BackgroundTransparency = 1
        msgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        msgLabel.Text = msg
        msgLabel.Font = Enum.Font.Gotham
        msgLabel.TextSize = 11
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.TextTruncate = Enum.TextTruncate.AtEnd
        msgLabel.Parent = msgFrame
        
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 22, 0, 22)
        deleteBtn.Position = UDim2.new(1, -25, 0.5, -11)
        deleteBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        deleteBtn.Text = "X"
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.TextSize = 10
        deleteBtn.Parent = msgFrame
        
        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, 4)
        deleteCorner.Parent = deleteBtn
        
        deleteBtn.MouseButton1Click:Connect(function()
            table.remove(premadeMessages, i)
            updatePremadeUI()
        end)
    end
    
    premadeScroll.CanvasSize = UDim2.new(0, 0, 0, #premadeMessages * 32)
end

premadeToggle.MouseButton1Click:Connect(function()
    premadeExpanded = not premadeExpanded
    premadePanel.Visible = premadeExpanded
    premadeToggle.Text = premadeExpanded and "▲ Premade Messages" or "▼ Premade Messages"
    if premadeExpanded then updatePremadeUI() end
end)

addPremadeBtn.MouseButton1Click:Connect(function()
    local msg = chatTextbox.Text:gsub("^%s+", ""):gsub("%s+\$", "")
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
        spamToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
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
        spamToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end)

-- ========== AUTO-REPLY ==========

local function updateTargetsUI()
    for _, child in pairs(targetsScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local i = 0
    for username, reply in pairs(autoReplyTargets) do
        i = i + 1
        local targetFrame = Instance.new("Frame")
        targetFrame.Size = UDim2.new(1, 0, 0, 35)
        targetFrame.BackgroundColor3 = Color3.fromRGB(50, 50 targetFrame.Parent = targetsScroll
        
        local targetCorner = Instance.new("UICorner")
        targetCorner.CornerRadius = UDim.new(0, 4)
        targetCorner.Parent = targetFrame
        
        local targetLabel = Instance.new("TextLabel")
        targetLabel.Size = UDim2.new(1, -30, 0, 15)
        targetLabel.Position = UDim2.new(0, 5, 0, 2)
        targetLabel.BackgroundTransparency = 1
        targetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        targetLabel.Text = "@"..username
        targetLabel.Font = Enum.Font.GothamBold
        targetLabel.TextSize = 11
        targetLabel.TextXAlignment = Enum.TextXAlignment.Left
        targetLabel.Parent = targetFrame
        
        local replyLabel = Instance.new("TextLabel")
        replyLabel.Size = UDim2.new(1, -30, 0, 15)
        replyLabel.Position = UDim2.new(0, 5, 0, 17)
        replyLabel.BackgroundTransparency = 1
        replyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        replyLabel.Text = reply:sub(1, 25)..(#reply > 25 and "..." or "")
        replyLabel.Font = Enum.Font.Gotham
        replyLabel.TextSize = 10
        replyLabel.TextXAlignment = Enum.TextXAlignment.Left
        replyLabel.Parent = targetFrame
        
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 22, 0, 22)
        deleteBtn.Position = UDim2.new(1, -25, 0.5, -11)
        deleteBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        deleteBtn.Text = "X"
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.TextSize = 10
        deleteBtn.Parent = targetFrame
        
        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, 4)
        deleteCorner.Parent = deleteBtn
        
        deleteBtn.MouseButton1Click:Connect(function()
            autoReplyTargets[username] = nil
            updateTargetsUI()
        end)
    end
    
    targetsScroll.CanvasSize = UDim2.new(0, 0, 0, i * 39)
end

addTargetBtn.MouseButton1Click:Connect(function()
    local username = targetInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
    local reply = replyInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
    
    if username ~= "" and reply ~= "" then
        autoReplyTargets[username:lower()] = reply
        targetInput.Text = ""
        replyInput.Text = ""
        updateTargetsUI()
    end
end)

autoReplyToggle.MouseButton1Click:Connect(function()
    autoReplyEnabled = not autoReplyEnabled
    
    if autoReplyEnabled then
        autoReplyToggle.Text = "AUTO-REPLY: ON"
        autoReplyToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        autoReplyToggle.Text = "AUTO-REPLY: OFF"
        autoReplyToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
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

-- Detect messages from other players
Players.PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg)
        if autoReplyEnabled and autoReplyTargets[plr.Name:lower()] then
            sendReply(autoReplyTargets[plr.Name:lower()])
        end
    end)
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then
        plr.Chatted:Connect(function(msg)
            if autoReplyEnabled and autoReplyTargets[plr.Name:lower()] then
                sendReply(autoReplyTargets[plr.Name:lower()])
            end
        end)
    end
end

-- ========== ANTI-AFK ==========

afkToggle.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    
    if antiAfkEnabled then
        afkToggle.Text = "ANTI-AFK: ON"
        afkToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        afkToggle.Text = "ANTI-AFK: OFF"
        afkToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end)

-- Anti-AFK Loop
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

-- ========== TOGGLE WITH KEY ==========

local guiVisible = true

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

-- Initialize
updatePremadeUI()
updateTargetsUI()

print("✅ Chat Hub Loaded")
