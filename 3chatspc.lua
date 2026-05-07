local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local MAX_CHARS = 200
local spamEnabled = false
local spamDelay = 3
local messagesExpanded = false
local spamIndex = 1
local backup1Enabled = false
local backup1Delay = 3
local backup1Index = 1
local backup1Expanded = false
local backup2Enabled = false
local backup2Delay = 3
local backup2Index = 1
local backup2Expanded = false

local premadeMessages = {
    "LOOOOOOOOOOOOL PEDRO IS THE GREATEST BULLY TO EVER EXIST AHAHAHAHAHAHAHAHAHAH EZZZZZZZZZZZZZZZZ IM SUPERIOR TO EVERYONE KNEEL DOWN TO ME HAHA KEEP ENTERTAINING ME IM NEVER STOPPING LOLOO IM #1 AHAHAHA",
    "LOOOOOOOOOOOOOOOOOOOOLOLOOOOOLOOOOOOOO PEDRO IS UNDEFEATED AHAHAHAHAHAHAHAHA EZZZZZZZZZZZZZZZZ EVERYONE SERVES ME LOOOOOOOOOOOOL I DONT CARE ABOUT WHAT ANY OF MY FANS HAVE TO SAY I REMAIN THE BEST",
    "BAHABHABAHAHBHABHABAHBAHA EZZZZZZZZZZZZZZZZZZZZZZZZZZ PEDRO IS UNSTOPPABLE AHAHAHAHAHAHAHAHAHAA LOOOOOOOOOOOOOOOOOOOOOOOOOOOL ALL OF U KNEEL DOWN HAHAHAHAHAHA IM THE BEST EVER NO ONE COMES CLOSE TO ME"
}

local backup1Messages = {
    "HAHHAHHAHAHHAHAHHAHAHAHAHA BAHAHBAHABAHAHAHAHAHAHAHAHAHAHAHAHAHAHA LOLOLOLOOOLOLOOLOOLOOOOLOLOLOLOLOL BAHAHHAHHAHHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAAHAHAHAHAHAHAHAH WHY AM I THIS GOOD AND PERFECT",
    "HAHHAHHAHAHHAHAHHAHAHAHAHA BAHABAHABAHABAHAHAHAHAHAHHAHAHAHAHAHAHAHAHAHA LOLOLOLOOOLOLOOOOLOOOOOOOLOLOLOLOLOLOL BAHAHHAHHAHHAHAHAHAHAHAHAHAAHAHAHAHHAHAHAHAHAHAHHAHAHAHAHAHAHAAHAHHAAH PEDRO IS SUPERIOR",
    "BAHABHABAAHAHAHAHAHAHAHHAHAHAHAHAHAHAHABAHBAHABA AGAGAHAHAHHAHAHAHAGAHAGHAGAHAAGHAHAHAHAHA LOLOLOLOLOOOOLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOLOLOLOLO BAHAHAHAHAHAAAHAHAHAHAHAHA PEDRO IS THE BEST EVER"
}

local backup2Messages = {
    "BAHABHABAHABAHBAHAHAHAHAHAHAHA LOOOOOOOOOOOOOOOOOOOOOOOL AGHAGAHAGHAGAHAGHAHAHAHAHAHAHAHAHAHA VHABHABAHABAHBAHABAHABHABAHABHAHAHA AHAHHAHAHAHAHAHAHA LOLOLOLOLOLOLOLOLOLOLOLOLOLOL ITS DYINGG LOLOLOZOLZ"
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomChatGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Name = "ChatFrame"
frame.Size = UDim2.new(0, 240, 0, 220)
frame.Position = UDim2.new(0.5, -120, 0.5, -110)
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

-- Character Counter
local charCounter = Instance.new("TextLabel")
charCounter.Size = UDim2.new(1, -10, 1, 0)
charCounter.Position = UDim2.new(0, 10, 0, 0)
charCounter.BackgroundTransparency = 1
charCounter.TextColor3 = Color3.fromRGB(255, 255, 255)
charCounter.Text = "0/200"
charCounter.Font = Enum.Font.GothamBold
charCounter.TextSize = 13
charCounter.TextXAlignment = Enum.TextXAlignment.Left
charCounter.Parent = titleBar

-- Gear Button
local gearBtn = Instance.new("TextButton")
gearBtn.Size = UDim2.new(0, 28, 0, 22)
gearBtn.Position = UDim2.new(1, -32, 0.5, -11)
gearBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
gearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
gearBtn.Text = "⚙"
gearBtn.Font = Enum.Font.GothamBold
gearBtn.TextSize = 14
gearBtn.Parent = titleBar
local gearCorner = Instance.new("UICorner")
gearCorner.CornerRadius = UDim.new(0, 6)
gearCorner.Parent = gearBtn

-- Textbox (MultiLine = false so Enter sends)
local textbox = Instance.new("TextBox")
textbox.Name = "ChatInput"
textbox.Size = UDim2.new(1, -20, 0, 110)
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
textbox.MultiLine = false
textbox.TextWrapped = true
textbox.Parent = frame
local textboxCorner = Instance.new("UICorner")
textboxCorner.CornerRadius = UDim.new(0, 6)
textboxCorner.Parent = textbox

-- Bottom Row
local bottomRow = Instance.new("Frame")
bottomRow.Size = UDim2.new(1, -20, 0, 32)
bottomRow.Position = UDim2.new(0, 10, 0, 152)
bottomRow.BackgroundTransparency = 1
bottomRow.Parent = frame

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

local delayTextbox = Instance.new("TextBox")
delayTextbox.Size = UDim2.new(0, 35, 0, 32)
delayTextbox.Position = UDim2.new(0, 60, 0, 0)
delayTextbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayTextbox.Text = "3"
delayTextbox.PlaceholderText = "3"
delayTextbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
delayTextbox.Font = Enum.Font.Gotham
delayTextbox.TextSize = 12
delayTextbox.ClearTextOnFocus = false
delayTextbox.Parent = bottomRow
local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 6)
delayCorner.Parent = delayTextbox

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 35, 0, 32)
delayLabel.Position = UDim2.new(0, 98, 0, 0)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
delayLabel.Text = "sec"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 10
delayLabel.Parent = bottomRow

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

-- Messages Toggle
local messagesToggle = Instance.new("TextButton")
messagesToggle.Size = UDim2.new(1, -20, 0, 24)
messagesToggle.Position = UDim2.new(0, 10, 0, 190)
messagesToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
messagesToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
messagesToggle.Text = "▼ Messages"
messagesToggle.Font = Enum.Font.GothamBold
messagesToggle.TextSize = 11
messagesToggle.Parent = frame
local messagesToggleCorner = Instance.new("UICorner")
messagesToggleCorner.CornerRadius = UDim.new(0, 6)
messagesToggleCorner.Parent = messagesToggle

-- Messages Panel
local messagesPanel = Instance.new("Frame")
messagesPanel.Size = UDim2.new(1, -20, 0, 120)
messagesPanel.Position = UDim2.new(0, 10, 0, 218)
messagesPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
messagesPanel.Visible = false
messagesPanel.Parent = frame
local messagesPanelCorner = Instance.new("UICorner")
messagesPanelCorner.CornerRadius = UDim.new(0, 6)
messagesPanelCorner.Parent = messagesPanel

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

-- Gear Frame
local gearFrame = Instance.new("Frame")
gearFrame.Name = "GearFrame"
gearFrame.Size = UDim2.new(0, 280, 0, 320)
gearFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
gearFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
gearFrame.BorderSizePixel = 2
gearFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
gearFrame.Visible = false
gearFrame.Parent = screenGui
local gearFrameCorner = Instance.new("UICorner")
gearFrameCorner.CornerRadius = UDim.new(0, 8)
gearFrameCorner.Parent = gearFrame

-- Gear Title Bar
local gearTitleBar = Instance.new("Frame")
gearTitleBar.Name = "TitleBar"
gearTitleBar.Size = UDim2.new(1, 0, 0, 28)
gearTitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
gearTitleBar.BorderSizePixel = 0
gearTitleBar.Parent = gearFrame
local gearTitleCorner = Instance.new("UICorner")
gearTitleCorner.CornerRadius = UDim.new(0, 8)
gearTitleCorner.Parent = gearTitleBar
local gearTitleFix = Instance.new("Frame")
gearTitleFix.Size = UDim2.new(1, 0, 0, 10)
gearTitleFix.Position = UDim2.new(0, 0, 1, -10)
gearTitleFix.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
gearTitleFix.BorderSizePixel = 0
gearTitleFix.Parent = gearTitleBar

local gearTitleLabel = Instance.new("TextLabel")
gearTitleLabel.Size = UDim2.new(1, -10, 1, 0)
gearTitleLabel.Position = UDim2.new(0, 10, 0, 0)
gearTitleLabel.BackgroundTransparency = 1
gearTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gearTitleLabel.Text = "⚙ Backup Spam Systems"
gearTitleLabel.Font = Enum.Font.GothamBold
gearTitleLabel.TextSize = 13
gearTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
gearTitleLabel.Parent = gearTitleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 22)
closeBtn.Position = UDim2.new(1, -32, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = gearTitleBar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Tab Bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -20, 0, 28)
tabBar.Position = UDim2.new(0, 10, 0, 28)
tabBar.BackgroundTransparency = 1
tabBar.Parent = gearFrame

local backup1TabBtn = Instance.new("TextButton")
backup1TabBtn.Size = UDim2.new(0.5, -5, 1, -4)
backup1TabBtn.Position = UDim2.new(0, 2, 0, 2)
backup1TabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
backup1TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
backup1TabBtn.Text = "Safe Spam"
backup1TabBtn.Font = Enum.Font.GothamBold
backup1TabBtn.TextSize = 11
backup1TabBtn.Parent = tabBar
local backup1TabCorner = Instance.new("UICorner")
backup1TabCorner.CornerRadius = UDim.new(0, 6)
backup1TabCorner.Parent = backup1TabBtn

local backup2TabBtn = Instance.new("TextButton")
backup2TabBtn.Size = UDim2.new(0.5, -5, 1, -4)
backup2TabBtn.Position = UDim2.new(0.5, 3, 0, 2)
backup2TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
backup2TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
backup2TabBtn.Text = "Victim Dying"
backup2TabBtn.Font = Enum.Font.GothamBold
backup2TabBtn.TextSize = 11
backup2TabBtn.Parent = tabBar
local backup2TabCorner = Instance.new("UICorner")
backup2TabCorner.CornerRadius = UDim.new(0, 6)
backup2TabCorner.Parent = backup2TabBtn

-- Backup 1 Content
local backup1Content = Instance.new("Frame")
backup1Content.Size = UDim2.new(1, -20, 1, -66)
backup1Content.Position = UDim2.new(0, 10, 0, 56)
backup1Content.BackgroundTransparency = 1
backup1Content.Visible = true
backup1Content.Parent = gearFrame

local backup1Textbox = Instance.new("TextBox")
backup1Textbox.Name = "Backup1Input"
backup1Textbox.Size = UDim2.new(1, 0, 0, 60)
backup1Textbox.Position = UDim2.new(0, 0, 0, 5)
backup1Textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
backup1Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
backup1Textbox.Text = ""
backup1Textbox.PlaceholderText = "Safe Spam Message..."
backup1Textbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
backup1Textbox.Font = Enum.Font.Gotham
backup1Textbox.TextSize = 14
backup1Textbox.TextXAlignment = Enum.TextXAlignment.Left
backup1Textbox.TextYAlignment = Enum.TextYAlignment.Top
backup1Textbox.ClearTextOnFocus = false
backup1Textbox.MultiLine = false
backup1Textbox.TextWrapped = true
backup1Textbox.Parent = backup1Content
local backup1TextboxCorner = Instance.new("UICorner")
backup1TextboxCorner.CornerRadius = UDim.new(0, 6)
backup1TextboxCorner.Parent = backup1Textbox

local backup1CharCounter = Instance.new("TextLabel")
backup1CharCounter.Size = UDim2.new(0, 40, 0, 20)
backup1CharCounter.Position = UDim2.new(1, -45, 0, 5)
backup1CharCounter.BackgroundTransparency = 1
backup1CharCounter.TextColor3 = Color3.fromRGB(150, 150, 150)
backup1CharCounter.Text = "0/200"
backup1CharCounter.Font = Enum.Font.Gotham
backup1CharCounter.TextSize = 10
backup1CharCounter.Parent = backup1Content

local backup1BottomRow = Instance.new("Frame")
backup1BottomRow.Size = UDim2.new(1, 0, 0, 28)
backup1BottomRow.Position = UDim2.new(0, 0, 0, 70)
backup1BottomRow.BackgroundTransparency = 1
backup1BottomRow.Parent = backup1Content

local backup1SendButton = Instance.new("TextButton")
backup1SendButton.Size = UDim2.new(0, 50, 1, 0)
backup1SendButton.Position = UDim2.new(0, 0, 0, 0)
backup1SendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
backup1SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
backup1SendButton.Text = "Send"
backup1SendButton.Font = Enum.Font.GothamBold
backup1SendButton.TextSize = 11
backup1SendButton.Parent = backup1BottomRow
local backup1SendCorner = Instance.new("UICorner")
backup1SendCorner.CornerRadius = UDim.new(0, 6)
backup1SendCorner.Parent = backup1SendButton

local backup1DelayTextbox = Instance.new("TextBox")
backup1DelayTextbox.Size = UDim2.new(0, 30, 1, 0)
backup1DelayTextbox.Position = UDim2.new(0, 55, 0, 0)
backup1DelayTextbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
backup1DelayTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
backup1DelayTextbox.Text = "3"
backup1DelayTextbox.PlaceholderText = "3"
backup1DelayTextbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
backup1DelayTextbox.Font = Enum.Font.Gotham
backup1DelayTextbox.TextSize = 11
backup1DelayTextbox.ClearTextOnFocus = false
backup1DelayTextbox.Parent = backup1BottomRow
local backup1DelayCorner = Instance.new("UICorner")
backup1DelayCorner.CornerRadius = UDim.new(0, 6)
backup1DelayCorner.Parent = backup1DelayTextbox

local backup1DelayLabel = Instance.new("TextLabel")
backup1DelayLabel.Size = UDim2.new(0, 25, 1, 0)
backup1DelayLabel.Position = UDim2.new(0, 88, 0, 0)
backup1DelayLabel.BackgroundTransparency = 1
backup1DelayLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
backup1DelayLabel.Text = "sec"
backup1DelayLabel.Font = Enum.Font.Gotham
backup1DelayLabel.TextSize = 9
backup1DelayLabel.Parent = backup1BottomRow

local backup1SpamButton = Instance.new("TextButton")
backup1SpamButton.Size = UDim2.new(0, 70, 1, 0)
backup1SpamButton.Position = UDim2.new(1, -70, 0, 0)
backup1SpamButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
backup1SpamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
backup1SpamButton.Text = "SPAM: OFF"
backup1SpamButton.Font = Enum.Font.GothamBold
backup1SpamButton.TextSize = 9
backup1SpamButton.Parent = backup1BottomRow
local backup1SpamCorner = Instance.new("UICorner")
backup1SpamCorner.CornerRadius = UDim.new(0, 6)
backup1SpamCorner.Parent = backup1SpamButton

local backup1MessagesToggle = Instance.new("TextButton")
backup1MessagesToggle.Size = UDim2.new(1, 0, 0, 22)
backup1MessagesToggle.Position = UDim2.new(0, 0, 0, 102)
backup1MessagesToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
backup1MessagesToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
backup1MessagesToggle.Text = "▼ Messages"
backup1MessagesToggle.Font = Enum.Font.GothamBold
backup1MessagesToggle.TextSize = 10
backup1MessagesToggle.Parent = backup1Content
local backup1MessagesToggleCorner = Instance.new("UICorner")
backup1MessagesToggleCorner.CornerRadius = UDim.new(0, 6)
backup1MessagesToggleCorner.Parent = backup1MessagesToggle

local backup1MessagesPanel = Instance.new("Frame")
backup1MessagesPanel.Size = UDim2.new(1, 0, 0, 100)
backup1MessagesPanel.Position = UDim2.new(0, 0, 0, 128)
backup1MessagesPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
backup1MessagesPanel.Visible = false
backup1MessagesPanel.Parent = backup1Content
local backup1MessagesPanelCorner = Instance.new("UICorner")
backup1MessagesPanelCorner.CornerRadius = UDim.new(0, 6)
backup1MessagesPanelCorner.Parent = backup1MessagesPanel

local backup1MessagesScroll = Instance.new("ScrollingFrame")
backup1MessagesScroll.Size = UDim2.new(1, -10, 1, -28)
backup1MessagesScroll.Position = UDim2.new(0, 5, 0, 5)
backup1MessagesScroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
backup1MessagesScroll.ScrollBarThickness = 4
backup1MessagesScroll.Parent = backup1MessagesPanel
local backup1MessagesScrollCorner = Instance.new("UICorner")
backup1MessagesScrollCorner.CornerRadius = UDim.new(0, 4)
backup1MessagesScrollCorner.Parent = backup1MessagesScroll

local backup1MessagesLayout = Instance.new("UIListLayout")
backup1MessagesLayout.Padding = UDim.new(0, 3)
backup1MessagesLayout.Parent = backup1MessagesScroll

local backup1AddMsgButton = Instance.new("TextButton")
backup1AddMsgButton.Size = UDim2.new(1, -10, 0, 20)
backup1AddMsgButton.Position = UDim2.new(0, 5, 1, -24)
backup1AddMsgButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
backup1AddMsgButton.TextColor3 = Color3.fromRGB(255, 255, 255)
backup1AddMsgButton.Text = "+ Add Current Message"
backup1AddMsgButton.Font = Enum.Font.GothamBold
backup1AddMsgButton.TextSize = 10
backup1AddMsgButton.Parent = backup1MessagesPanel
local backup1AddMsgCorner = Instance.new("UICorner")
backup1AddMsgCorner.CornerRadius = UDim.new(0, 6)
backup1AddMsgCorner.Parent = backup1AddMsgButton

-- Backup 2 Content
local backup2Content = Instance.new("Frame")
backup2Content.Size = UDim2.new(1, -20, 1, -66)
backup2Content.Position = UDim2.new(0, 10, 0, 56)
backup2Content.BackgroundTransparency = 1
backup2Content.Visible = false
backup2Content.Parent = gearFrame

local backup2Textbox = Instance.new("TextBox")
backup2Textbox.Name = "Backup2Input"
backup2Textbox.Size = UDim2.new(1, 0, 0, 60)
backup2Textbox.Position = UDim2.new(0, 0, 0, 5)
backup2Textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
backup2Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
backup2Textbox.Text = ""
backup2Textbox.PlaceholderText = "Victim Dying Message..."
backup2Textbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
backup2Textbox.Font = Enum.Font.Gotham
backup2Textbox.TextSize = 14
backup2Textbox.TextXAlignment = Enum.TextXAlignment.Left
backup2Textbox.TextYAlignment = Enum.TextYAlignment.Top
backup2Textbox.ClearTextOnFocus = false
backup2Textbox.MultiLine = false
backup2Textbox.TextWrapped = true
backup2Textbox.Parent = backup2Content
local backup2TextboxCorner = Instance.new("UICorner")
backup2TextboxCorner.CornerRadius = UDim.new(0, 6)
backup2TextboxCorner.Parent = backup2Textbox

local backup2CharCounter = Instance.new("TextLabel")
backup2CharCounter.Size = UDim2.new(0, 40, 0, 20)
backup2CharCounter.Position = UDim2.new(1, -45, 0, 5)
backup2CharCounter.BackgroundTransparency = 1
backup2CharCounter.TextColor3 = Color3.fromRGB(150, 150, 150)
backup2CharCounter.Text = "0/200"
backup2CharCounter.Font = Enum.Font.Gotham
backup2CharCounter.TextSize = 10
backup2CharCounter.Parent = backup2Content

local backup2BottomRow = Instance.new("Frame")
backup2BottomRow.Size = UDim2.new(1, 0, 0, 28)
backup2BottomRow.Position = UDim2.new(0, 0, 0, 70)
backup2BottomRow.BackgroundTransparency = 1
backup2BottomRow.Parent = backup2Content

local backup2SendButton = Instance.new("TextButton")
backup2SendButton.Size = UDim2.new(0, 50, 1, 0)
backup2SendButton.Position = UDim2.new(0, 0, 0, 0)
backup2SendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
backup2SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
backup2SendButton.Text = "Send"
backup2SendButton.Font = Enum.Font.GothamBold
backup2SendButton.TextSize = 11
backup2SendButton.Parent = backup2BottomRow
local backup2SendCorner = Instance.new("UICorner")
backup2SendCorner.CornerRadius = UDim.new(0, 6)
backup2SendCorner.Parent = backup2SendButton

local backup2DelayTextbox = Instance.new("TextBox")
backup2DelayTextbox.Size = UDim2.new(0, 30, 1, 0)
backup2DelayTextbox.Position = UDim2.new(0, 55, 0, 0)
backup2DelayTextbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
backup2DelayTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
backup2DelayTextbox.Text = "3"
backup2DelayTextbox.PlaceholderText = "3"
backup2DelayTextbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
backup2DelayTextbox.Font = Enum.Font.Gotham
backup2DelayTextbox.TextSize = 11
backup2DelayTextbox.ClearTextOnFocus = false
backup2DelayTextbox.Parent = backup2BottomRow
local backup2DelayCorner = Instance.new("UICorner")
backup2DelayCorner.CornerRadius = UDim.new(0, 6)
backup2DelayCorner.Parent = backup2DelayTextbox

local backup2DelayLabel = Instance.new("TextLabel")
backup2DelayLabel.Size = UDim2.new(0, 25, 1, 0)
backup2DelayLabel.Position = UDim2.new(0, 88, 0, 0)
backup2DelayLabel.BackgroundTransparency = 1
backup2DelayLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
backup2DelayLabel.Text = "sec"
backup2DelayLabel.Font = Enum.Font.Gotham
backup2DelayLabel.TextSize = 9
backup2DelayLabel.Parent = backup2BottomRow

local backup2SpamButton = Instance.new("TextButton")
backup2SpamButton.Size = UDim2.new(0, 70, 1, 0)
backup2SpamButton.Position = UDim2.new(1, -70, 0, 0)
backup2SpamButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
backup2SpamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
backup2SpamButton.Text = "SPAM: OFF"
backup2SpamButton.Font = Enum.Font.GothamBold
backup2SpamButton.TextSize = 9
backup2SpamButton.Parent = backup2BottomRow
local backup2SpamCorner = Instance.new("UICorner")
backup2SpamCorner.CornerRadius = UDim.new(0, 6)
backup2SpamCorner.Parent = backup2SpamButton

local backup2MessagesToggle = Instance.new("TextButton")
backup2MessagesToggle.Size = UDim2.new(1, 0, 0, 22)
backup2MessagesToggle.Position = UDim2.new(0, 0, 0, 102)
backup2MessagesToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
backup2MessagesToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
backup2MessagesToggle.Text = "▼ Messages"
backup2MessagesToggle.Font = Enum.Font.GothamBold
backup2MessagesToggle.TextSize = 10
backup2MessagesToggle.Parent = backup2Content
local backup2MessagesToggleCorner = Instance.new("UICorner")
backup2MessagesToggleCorner.CornerRadius = UDim.new(0, 6)
backup2MessagesToggleCorner.Parent = backup2MessagesToggle

local backup2MessagesPanel = Instance.new("Frame")
backup2MessagesPanel.Size = UDim2.new(1, 0, 0, 100)
backup2MessagesPanel.Position = UDim2.new(0, 0, 0, 128)
backup2MessagesPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
backup2MessagesPanel.Visible = false
backup2MessagesPanel.Parent = backup2Content
local backup2MessagesPanelCorner = Instance.new("UICorner")
backup2MessagesPanelCorner.CornerRadius = UDim.new(0, 6)
backup2MessagesPanelCorner.Parent = backup2MessagesPanel

local backup2MessagesScroll = Instance.new("ScrollingFrame")
backup2MessagesScroll.Size = UDim2.new(1, -10, 1, -28)
backup2MessagesScroll.Position = UDim2.new(0, 5, 0, 5)
backup2MessagesScroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
backup2MessagesScroll.ScrollBarThickness = 4
backup2MessagesScroll.Parent = backup2MessagesPanel
local backup2MessagesScrollCorner = Instance.new("UICorner")
backup2MessagesScrollCorner.CornerRadius = UDim.new(0, 4)
backup2MessagesScrollCorner.Parent = backup2MessagesScroll

local backup2MessagesLayout = Instance.new("UIListLayout")
backup2MessagesLayout.Padding = UDim.new(0, 3)
backup2MessagesLayout.Parent = backup2MessagesScroll

local backup2AddMsgButton = Instance.new("TextButton")
backup2AddMsgButton.Size = UDim2.new(1, -10, 0, 20)
backup2AddMsgButton.Position = UDim2.new(0, 5, 1, -24)
backup2AddMsgButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
backup2AddMsgButton.TextColor3 = Color3.fromRGB(255, 255, 255)
backup2AddMsgButton.Text = "+ Add Current Message"
backup2AddMsgButton.Font = Enum.Font.GothamBold
backup2AddMsgButton.TextSize = 10
backup2AddMsgButton.Parent = backup2MessagesPanel
local backup2AddMsgCorner = Instance.new("UICorner")
backup2AddMsgCorner.CornerRadius = UDim.new(0, 6)
backup2AddMsgCorner.Parent = backup2AddMsgButton

-- Kill Button
local killButton = Instance.new("TextButton")
killButton.Size = UDim2.new(1, -20, 0, 24)
killButton.Position = UDim2.new(0, 10, 1, -28)
killButton.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
killButton.TextColor3 = Color3.fromRGB(255, 255, 255)
killButton.Text = "☠ KILL GUI"
killButton.Font = Enum.Font.GothamBold
killButton.TextSize = 11
killButton.Parent = gearFrame
local killCorner = Instance.new("UICorner")
killCorner.CornerRadius = UDim.new(0, 6)
killCorner.Parent = killButton

-- Dragging
local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local gearDragging = false
local gearDragInput, gearDragStart, gearDragPos

gearFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        gearDragging = true
        gearDragStart = input.Position
        gearDragPos = gearFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                gearDragging = false
            end
        end)
    end
end)

gearFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        gearDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == gearDragInput and gearDragging then
        local delta = input.Position - gearDragStart
        gearFrame.Position = UDim2.new(gearDragPos.X.Scale, gearDragPos.X.Offset + delta.X, gearDragPos.Y.Scale, gearDragPos.Y.Offset + delta.Y)
    end
end)

-- SEND FUNCTIONS
local function sendMessage(msg)
    local message = msg or textbox.Text
    message = message:gsub("^%s+", ""):gsub("%s+$", "")
    if message == "" then return false end
    if #message > MAX_CHARS then message = message:sub(1, MAX_CHARS) end
    
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(message, "All")
            return true
        end
    end
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

local function sendBackup1Message(msg)
    local message = msg or backup1Textbox.Text
    message = message:gsub("^%s+", ""):gsub("%s+$", "")
    if message == "" then return false end
    if #message > MAX_CHARS then message = message:sub(1, MAX_CHARS) end
    
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(message, "All")
            return true
        end
    end
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

local function sendBackup2Message(msg)
    local message = msg or backup2Textbox.Text
    message = message:gsub("^%s+", ""):gsub("%s+$", "")
    if message == "" then return false end
    if #message > MAX_CHARS then message = message:sub(1, MAX_CHARS) end
    
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(message, "All")
            return true
        end
    end
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

-- ENTER KEY TO SEND (works because MultiLine = false)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Return then
        -- Main textbox
        if textbox:IsFocused() and textbox.Text ~= "" then
            if sendMessage() then
                textbox.Text = ""
            end
        end
        -- Backup 1 textbox
        if backup1Textbox:IsFocused() and backup1Textbox.Text ~= "" then
            if sendBackup1Message() then
                backup1Textbox.Text = ""
            end
        end
        -- Backup 2 textbox
        if backup2Textbox:IsFocused() and backup2Textbox.Text ~= "" then
            if sendBackup2Message() then
                backup2Textbox.Text = ""
            end
        end
    end
end)

-- Character Counters
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
        charCounter.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

backup1Textbox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = backup1Textbox.Text
    if #text > MAX_CHARS then backup1Textbox.Text = text:sub(1, MAX_CHARS) end
    backup1CharCounter.Text = #backup1Textbox.Text.."/"..MAX_CHARS
    if #backup1Textbox.Text >= MAX_CHARS then
        backup1CharCounter.TextColor3 = Color3.fromRGB(255, 100, 100)
    elseif #backup1Textbox.Text >= MAX_CHARS * 0.8 then
        backup1CharCounter.TextColor3 = Color3.fromRGB(255, 200, 100)
    else
        backup1CharCounter.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

backup2Textbox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = backup2Textbox.Text
    if #text > MAX_CHARS then backup2Textbox.Text = text:sub(1, MAX_CHARS) end
    backup2CharCounter.Text = #backup2Textbox.Text.."/"..MAX_CHARS
    if #backup2Textbox.Text >= MAX_CHARS then
        backup2CharCounter.TextColor3 = Color3.fromRGB(255, 100, 100)
    elseif #backup2Textbox.Text >= MAX_CHARS * 0.8 then
        backup2CharCounter.TextColor3 = Color3.fromRGB(255, 200, 100)
    else
        backup2CharCounter.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- Messages UI
local function updateMessagesUI()
    for _, child in pairs(messagesScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
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
    messagesScroll.CanvasSize = UDim2.new(0, 0, 0, #premadeMessages * 32)
end

messagesToggle.MouseButton1Click:Connect(function()
    messagesExpanded = not messagesExpanded
    messagesPanel.Visible = messagesExpanded
    if messagesExpanded then
        messagesToggle.Text = "▲ Messages"
        frame.Size = UDim2.new(0, 240, 0, 350)
    else
        messagesToggle.Text = "▼ Messages"
        frame.Size = UDim2.new(0, 240, 0, 220)
    end
    updateMessagesUI()
end)

addMsgButton.MouseButton1Click:Connect(function()
    local msg = textbox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if msg ~= "" then
        table.insert(premadeMessages, msg)
        updateMessagesUI()
        textbox.Text = ""
    end
end)

sendButton.MouseButton1Click:Connect(function()
    if textbox.Text ~= "" then
        sendMessage()
        textbox.Text = ""
    end
end)

local function toggleSpam()
    spamEnabled = not spamEnabled
    if spamEnabled then
        spamDelay = tonumber(delayTextbox.Text) or 3
        if spamDelay < 0.1 then spamDelay = 0.1 end
        spamButton.Text = "SPAM: ON"
        spamButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        if #premadeMessages > 0 then
            spamIndex = 1
            spawn(function()
                while spamEnabled do
                    local msg = premadeMessages[spamIndex]
                    if msg then sendMessage(msg) end
                    spamIndex = spamIndex + 1
                    if spamIndex > #premadeMessages then spamIndex = 1 end
                    wait(spamDelay)
                end
            end)
        else
            spawn(function()
                while spamEnabled do
                    local msg = textbox.Text
                    if msg ~= "" then sendMessage(msg) end
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

-- Backup 1 Functions
local function updateBackup1MessagesUI()
    for _, child in pairs(backup1MessagesScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for i, msg in ipairs(backup1Messages) do
        local msgFrame = Instance.new("Frame")
        msgFrame.Size = UDim2.new(1, 0, 0, 28)
        msgFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        msgFrame.Parent = backup1MessagesScroll
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
            table.remove(backup1Messages, i)
            updateBackup1MessagesUI()
        end)
    end
    backup1MessagesScroll.CanvasSize = UDim2.new(0, 0, 0, #backup1Messages * 32)
end

backup1MessagesToggle.MouseButton1Click:Connect(function()
    backup1Expanded = not backup1Expanded
    backup1MessagesPanel.Visible = backup1Expanded
    if backup1Expanded then
        backup1MessagesToggle.Text = "▲ Messages"
    else
        backup1MessagesToggle.Text = "▼ Messages"
    end
    updateBackup1MessagesUI()
end)

backup1AddMsgButton.MouseButton1Click:Connect(function()
    local msg = backup1Textbox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if msg ~= "" then
        table.insert(backup1Messages, msg)
        updateBackup1MessagesUI()
        backup1Textbox.Text = ""
    end
end)

backup1SendButton.MouseButton1Click:Connect(function()
    if backup1Textbox.Text ~= "" then
        sendBackup1Message()
        backup1Textbox.Text = ""
    end
end)

local function toggleBackup1Spam()
    backup1Enabled = not backup1Enabled
    if backup1Enabled then
        backup1Delay = tonumber(backup1DelayTextbox.Text) or 3
        if backup1Delay < 0.1 then backup1Delay = 0.1 end
        backup1SpamButton.Text = "SPAM: ON"
        backup1SpamButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        if #backup1Messages > 0 then
            backup1Index = 1
            spawn(function()
                while backup1Enabled do
                    local msg = backup1Messages[backup1Index]
                    if msg then sendBackup1Message(msg) end
                    backup1Index = backup1Index + 1
                    if backup1Index > #backup1Messages then backup1Index = 1 end
                    wait(backup1Delay)
                end
            end)
        else
            spawn(function()
                while backup1Enabled do
                    local msg = backup1Textbox.Text
                    if msg ~= "" then sendBackup1Message(msg) end
                    wait(backup1Delay)
                end
            end)
        end
    else
        backup1SpamButton.Text = "SPAM: OFF"
        backup1SpamButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end

backup1SpamButton.MouseButton1Click:Connect(toggleBackup1Spam)

-- Backup 2 Functions
local function updateBackup2MessagesUI()
    for _, child in pairs(backup2MessagesScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for i, msg in ipairs(backup2Messages) do
        local msgFrame = Instance.new("Frame")
        msgFrame.Size = UDim2.new(1, 0, 0, 28)
        msgFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        msgFrame.Parent = backup2MessagesScroll
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
            table.remove(backup2Messages, i)
            updateBackup2MessagesUI()
        end)
    end
    backup2MessagesScroll.CanvasSize = UDim2.new(0, 0, 0, #backup2Messages * 32)
end

backup2MessagesToggle.MouseButton1Click:Connect(function()
    backup2Expanded = not backup2Expanded
    backup2MessagesPanel.Visible = backup2Expanded
    if backup2Expanded then
        backup2MessagesToggle.Text = "▲ Messages"
    else
        backup2MessagesToggle.Text = "▼ Messages"
    end
    updateBackup2MessagesUI()
end)

backup2AddMsgButton.MouseButton1Click:Connect(function()
    local msg = backup2Textbox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if msg ~= "" then
        table.insert(backup2Messages, msg)
        updateBackup2MessagesUI()
        backup2Textbox.Text = ""
    end
end)

backup2SendButton.MouseButton1Click:Connect(function()
    if backup2Textbox.Text ~= "" then
        sendBackup2Message()
        backup2Textbox.Text = ""
    end
end)

local function toggleBackup2Spam()
    backup2Enabled = not backup2Enabled
    if backup2Enabled then
        backup2Delay = tonumber(backup2DelayTextbox.Text) or 3
        if backup2Delay < 0.1 then backup2Delay = 0.1 end
        backup2SpamButton.Text = "SPAM: ON"
        backup2SpamButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        if #backup2Messages > 0 then
            backup2Index = 1
            spawn(function()
                while backup2Enabled do
                    local msg = backup2Messages[backup2Index]
                    if msg then sendBackup2Message(msg) end
                    backup2Index = backup2Index + 1
                    if backup2Index > #backup2Messages then backup2Index = 1 end
                    wait(backup2Delay)
                end
            end)
        else
            spawn(function()
                while backup2Enabled do
                    local msg = backup2Textbox.Text
                    if msg ~= "" then sendBackup2Message(msg) end
                    wait(backup2Delay)
                end
            end)
        end
    else
        backup2SpamButton.Text = "SPAM: OFF"
        backup2SpamButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end

backup2SpamButton.MouseButton1Click:Connect(toggleBackup2Spam)

-- Gear Menu Toggle
gearBtn.MouseButton1Click:Connect(function()
    gearFrame.Visible = not gearFrame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    gearFrame.Visible = false
end)

-- Kill Button
killButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local function switchTab(tab)
    if tab == "backup1" then
        backup1Content.Visible = true
        backup2Content.Visible = false
        backup1TabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        backup1TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        backup2TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        backup2TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    else
        backup1Content.Visible = false
        backup2Content.Visible = true
        backup1TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        backup1TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        backup2TabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        backup2TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

backup1TabBtn.MouseButton1Click:Connect(function()
    switchTab("backup1")
end)

backup2TabBtn.MouseButton1Click:Connect(function()
    switchTab("backup2")
end)

-- Initialize
updateMessagesUI()
updateBackup1MessagesUI()
updateBackup2MessagesUI()

print("✅ Custom Chat GUI Loaded (PC Version)")
