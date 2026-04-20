-- Compact Chat Hub (Fixed Layout + Delay System)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local MAX_CHARS = 200
local caseMode = "normal"
local mimicEnabled = false
local targetPlayer = nil
local suffixes = {}
local suffixIndex = 1
local currentTab = "chat"
local advancedMode = false

-- Delay Settings
local delayMode = "random" -- "random", "sequential", "constant"
local delayList = {0.7, 0.9, 1, 2, 0.8}
local delayIndex = 1 -- for sequential mode
local constantDelay = 0.5

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MultiChatHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========== HUB BUTTON ==========
local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 50, 0, 50)
hubButton.Position = UDim2.new(0, 20, 0.5, -25)
hubButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
hubButton.BorderSizePixel = 2
hubButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
hubButton.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 8)
hubCorner.Parent = hubButton

local hubIcon = Instance.new("TextLabel")
hubIcon.Size = UDim2.new(1, 0, 1, 0)
hubIcon.BackgroundTransparency = 1
hubIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
hubIcon.Text = "💬"
hubIcon.Font = Enum.Font.GothamBold
hubIcon.TextSize = 22
hubIcon.Parent = hubButton

-- ========== MAIN FRAME ==========
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 145)
mainFrame.Position = UDim2.new(0, 20, 0.5, -72)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

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
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "💬 Quick Chat"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Kill Button (X)
local killBtn = Instance.new("TextButton")
killBtn.Size = UDim2.new(0, 28, 0, 22)
killBtn.Position = UDim2.new(1, -32, 0.5, -11)
killBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
killBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
killBtn.Text = "X"
killBtn.Font = Enum.Font.GothamBold
killBtn.TextSize = 14
killBtn.Parent = titleBar

local killCorner = Instance.new("UICorner")
killCorner.CornerRadius = UDim.new(0, 6)
killCorner.Parent = killBtn

-- Settings Button (Gear Icon)
local settingsBtn = Instance.new("TextButton")
settingsBtn.Size = UDim2.new(0, 28, 0, 22)
settingsBtn.Position = UDim2.new(1, -64, 0.5, -11)
settingsBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
settingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsBtn.Text = "⚙"
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextSize = 14
settingsBtn.Parent = titleBar

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 6)
settingsCorner.Parent = settingsBtn

-- Collapse Button (-)
local collapseBtn = Instance.new("TextButton")
collapseBtn.Size = UDim2.new(0, 28, 0, 22)
collapseBtn.Position = UDim2.new(1, -96, 0.5, -11)
collapseBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
collapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
collapseBtn.Text = "-"
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.TextSize = 14
collapseBtn.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseBtn

-- ========== COMPACT CONTENT (Default) ==========
local compactContent = Instance.new("Frame")
compactContent.Size = UDim2.new(1, 0, 1, -28)
compactContent.Position = UDim2.new(0, 0, 0, 28)
compactContent.BackgroundTransparency = 1
compactContent.Parent = mainFrame

-- Textbox (Bigger)
local textbox = Instance.new("TextBox")
textbox.Name = "MultiInput"
textbox.Size = UDim2.new(1, -20, 0, 65)
textbox.Position = UDim2.new(0, 10, 0, 5)
textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox.Text = ""
textbox.PlaceholderText = "Message..."
textbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
textbox.Font = Enum.Font.Gotham
textbox.TextSize = 14
textbox.TextXAlignment = Enum.TextXAlignment.Left
textbox.TextYAlignment = Enum.TextYAlignment.Top
textbox.ClearTextOnFocus = false
textbox.MultiLine = true
textbox.TextWrapped = true
textbox.Parent = compactContent

local textboxCorner = Instance.new("UICorner")
textboxCorner.CornerRadius = UDim.new(0, 6)
textboxCorner.Parent = textbox

-- Button Row (Compact)
local compactRow = Instance.new("Frame")
compactRow.Size = UDim2.new(1, -20, 0, 32)
compactRow.Position = UDim2.new(0, 10, 0, 75)
compactRow.BackgroundTransparency = 1
compactRow.Parent = compactContent

-- Delay Mode Button (shows R/S/C)
local delayModeBtn = Instance.new("TextButton")
delayModeBtn.Size = UDim2.new(0, 32, 1, 0)
delayModeBtn.Position = UDim2.new(0, 0, 0, 0)
delayModeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
delayModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
delayModeBtn.Text = "R"
delayModeBtn.Font = Enum.Font.GothamBold
delayModeBtn.TextSize = 12
delayModeBtn.Parent = compactRow
local delayModeCorner = Instance.new("UICorner")
delayModeCorner.CornerRadius = UDim.new(0, 6)
delayModeCorner.Parent = delayModeBtn

-- Clear Button
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 28, 1, 0)
clearBtn.Position = UDim2.new(0, 36, 0, 0)
clearBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.Text = "C"
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 13
clearBtn.Parent = compactRow
local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = clearBtn

-- Delay Settings Button (gear small)
local delaySettingsBtn = Instance.new("TextButton")
delaySettingsBtn.Size = UDim2.new(0, 28, 1, 0)
delaySettingsBtn.Position = UDim2.new(0, 68, 0, 0)
delaySettingsBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
delaySettingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
delaySettingsBtn.Text = "D"
delaySettingsBtn.Font = Enum.Font.GothamBold
delaySettingsBtn.TextSize = 11
delaySettingsBtn.Parent = compactRow
local delaySettingsCorner = Instance.new("UICorner")
delaySettingsCorner.CornerRadius = UDim.new(0, 6)
delaySettingsCorner.Parent = delaySettingsBtn

-- Send Button
local sendAllBtn = Instance.new("TextButton")
sendAllBtn.Size = UDim2.new(1, -100, 1, 0)
sendAllBtn.Position = UDim2.new(0, 100, 0, 0)
sendAllBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
sendAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendAllBtn.Text = "S"
sendAllBtn.Font = Enum.Font.GothamBold
sendAllBtn.TextSize = 14
sendAllBtn.Parent = compactRow
local sendAllCorner = Instance.new("UICorner")
sendAllCorner.CornerRadius = UDim.new(0, 6)
sendAllCorner.Parent = sendAllBtn

-- ========== DELAY DROPDOWN ==========
local delayDropdown = Instance.new("Frame")
delayDropdown.Size = UDim2.new(0, 200, 0, 200)
delayDropdown.Position = UDim2.new(0, 10, 0, 110)
delayDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
delayDropdown.BorderSizePixel = 2
delayDropdown.BorderColor3 = Color3.fromRGB(60, 60, 60)
delayDropdown.Visible = false
delayDropdown.ZIndex = 20
delayDropdown.Parent = compactContent
local delayDropdownCorner = Instance.new("UICorner")
delayDropdownCorner.CornerRadius = UDim.new(0, 8)
delayDropdownCorner.Parent = delayDropdown

-- Mode Title
local modeTitle = Instance.new("TextLabel")
modeTitle.Size = UDim2.new(1, 0, 0, 24)
modeTitle.Position = UDim2.new(0, 0, 0, 5)
modeTitle.BackgroundTransparency = 1
modeTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
modeTitle.Text = "Delay Mode"
modeTitle.Font = Enum.Font.GothamBold
modeTitle.TextSize = 12
modeTitle.Parent = delayDropdown

-- Mode Buttons Row
local modeRow = Instance.new("Frame")
modeRow.Size = UDim2.new(1, -20, 0, 24)
modeRow.Position = UDim2.new(0, 10, 0, 30)
modeRow.BackgroundTransparency = 1
modeRow.Parent = delayDropdown

local randomBtn = Instance.new("TextButton")
randomBtn.Size = UDim2.new(0.33, -2, 1, 0)
randomBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
randomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
randomBtn.Text = "Rnd"
randomBtn.Font = Enum.Font.GothamBold
randomBtn.TextSize = 10
randomBtn.ZIndex = 21
randomBtn.Parent = modeRow
local randomCorner = Instance.new("UICorner")
randomCorner.CornerRadius = UDim.new(0, 6)
randomCorner.Parent = randomBtn

local seqBtn = Instance.new("TextButton")
seqBtn.Size = UDim2.new(0.33, -2, 1, 0)
seqBtn.Position = UDim2.new(0.33, 2, 0, 0)
seqBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
seqBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
seqBtn.Text = "Seq"
seqBtn.Font = Enum.Font.GothamBold
seqBtn.TextSize = 10
seqBtn.ZIndex = 21
seqBtn.Parent = modeRow
local seqCorner = Instance.new("UICorner")
seqCorner.CornerRadius = UDim.new(0, 6)
seqCorner.Parent = seqBtn

local constBtn = Instance.new("TextButton")
constBtn.Size = UDim2.new(0.34, -2, 1, 0)
constBtn.Position = UDim2.new(0.66, 2, 0, 0)
constBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
constBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
constBtn.Text = "Con"
constBtn.Font = Enum.Font.GothamBold
constBtn.TextSize = 10
constBtn.ZIndex = 21
constBtn.Parent = modeRow
local constCorner = Instance.new("UICorner")
constCorner.CornerRadius = UDim.new(0, 6)
constCorner.Parent = constBtn

-- Delay List Title
local delayListTitle = Instance.new("TextLabel")
delayListTitle.Size = UDim2.new(1, 0, 0, 20)
delayListTitle.Position = UDim2.new(0, 0, 0, 58)
delayListTitle.BackgroundTransparency = 1
delayListTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
delayListTitle.Text = "Delays (tap X to remove)"
delayListTitle.Font = Enum.Font.Gotham
delayListTitle.TextSize = 9
delayListTitle.Parent = delayDropdown

-- Delay List Frame
local delayListFrame = Instance.new("Frame")
delayListFrame.Size = UDim2.new(1, -20, 0, 60)
delayListFrame.Position = UDim2.new(0, 10, 0, 78)
delayListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayListFrame.Parent = delayDropdown
local delayListCorner = Instance.new("UICorner")
delayListCorner.CornerRadius = UDim.new(0, 6)
delayListCorner.Parent = delayListFrame

-- Constant Delay Input (shown only in constant mode)
local constDelayLabel = Instance.new("TextLabel")
constDelayLabel.Size = UDim2.new(1, 0, 0, 20)
constDelayLabel.Position = UDim2.new(0, 0, 0, 58)
constDelayLabel.BackgroundTransparency = 1
constDelayLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
constDelayLabel.Text = "Constant Delay"
constDelayLabel.Font = Enum.Font.Gotham
constDelayLabel.TextSize = 9
constDelayLabel.Visible = false
constDelayLabel.Parent = delayDropdown

local constDelayInput = Instance.new("TextBox")
constDelayInput.Size = UDim2.new(1, -20, 0, 28)
constDelayInput.Position = UDim2.new(0, 10, 0, 78)
constDelayInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
constDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
constDelayInput.Text = "0.5"
constDelayInput.PlaceholderText = "0.5"
constDelayInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
constDelayInput.Font = Enum.Font.Gotham
constDelayInput.TextSize = 12
constDelayInput.Visible = false
constDelayInput.Parent = delayDropdown
local constDelayCorner = Instance.new("UICorner")
constDelayCorner.CornerRadius = UDim.new(0, 6)
constDelayCorner.Parent = constDelayInput

-- Add Delay Row
local addDelayRow = Instance.new("Frame")
addDelayRow.Size = UDim2.new(1, -20, 0, 28)
addDelayRow.Position = UDim2.new(0, 10, 0, 142)
addDelayRow.BackgroundTransparency = 1
addDelayRow.Parent = delayDropdown

local addDelayInput = Instance.new("TextBox")
addDelayInput.Size = UDim2.new(1, -40, 1, 0)
addDelayInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
addDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
addDelayInput.Text = ""
addDelayInput.PlaceholderText = "Add delay..."
addDelayInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
addDelayInput.Font = Enum.Font.Gotham
addDelayInput.TextSize = 11
addDelayInput.Parent = addDelayRow
local addDelayCorner = Instance.new("UICorner")
addDelayCorner.CornerRadius = UDim.new(0, 6)
addDelayCorner.Parent = addDelayInput

local addDelayBtn = Instance.new("TextButton")
addDelayBtn.Size = UDim2.new(0, 28, 1, 0)
addDelayBtn.Position = UDim2.new(1, -30, 0, 0)
addDelayBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
addDelayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addDelayBtn.Text = "+"
addDelayBtn.Font = Enum.Font.GothamBold
addDelayBtn.TextSize = 14
addDelayBtn.Parent = addDelayRow
local addDelayBtnCorner = Instance.new("UICorner")
addDelayBtnCorner.CornerRadius = UDim.new(0, 6)
addDelayBtnCorner.Parent = addDelayBtn

-- Clear All Button
local clearDelayBtn = Instance.new("TextButton")
clearDelayBtn.Size = UDim2.new(1, -20, 0, 24)
clearDelayBtn.Position = UDim2.new(0, 10, 0, 175)
clearDelayBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
clearDelayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearDelayBtn.Text = "Clear All Delays"
clearDelayBtn.Font = Enum.Font.GothamBold
clearDelayBtn.TextSize = 11
clearDelayBtn.Parent = delayDropdown
local clearDelayCorner = Instance.new("UICorner")
clearDelayCorner.CornerRadius = UDim.new(0, 6)
clearDelayCorner.Parent = clearDelayBtn

-- Delay List Container (for dynamic items)
local delayScroll = Instance.new("ScrollingFrame")
delayScroll.Size = UDim2.new(1, -6, 1, -6)
delayScroll.Position = UDim2.new(0, 3, 0, 3)
delayScroll.BackgroundTransparency = 1
delayScroll.ScrollBarThickness = 3
delayScroll.Parent = delayListFrame

local delayListLayout = Instance.new("UIListLayout")
delayListLayout.Padding = UDim.new(0, 2)
delayListLayout.Parent = delayScroll

-- Char Counter
local charCounter = Instance.new("TextLabel")
charCounter.Size = UDim2.new(1, -20, 0, 14)
charCounter.Position = UDim2.new(0, 10, 1, -16)
charCounter.BackgroundTransparency = 1
charCounter.TextColor3 = Color3.fromRGB(100, 100, 100)
charCounter.Text = "Lines: 0 | Chars: 0/200"
charCounter.Font = Enum.Font.Gotham
charCounter.TextSize = 9
charCounter.TextXAlignment = Enum.TextXAlignment.Right
charCounter.Parent = compactContent

-- ========== ADVANCED CONTENT (Hidden by default) ==========
local advancedContent = Instance.new("Frame")
advancedContent.Size = UDim2.new(1, 0, 1, -56)
advancedContent.Position = UDim2.new(0, 0, 0, 56)
advancedContent.BackgroundTransparency = 1
advancedContent.Visible = false
advancedContent.Parent = mainFrame

-- Tab Bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 28)
tabBar.Position = UDim2.new(0, 0, 0, 28)
tabBar.BackgroundTransparency = 1
tabBar.Visible = false
tabBar.Parent = mainFrame

local chatTabBtn = Instance.new("TextButton")
chatTabBtn.Size = UDim2.new(0.5, -5, 1, -4)
chatTabBtn.Position = UDim2.new(0, 2, 0, 2)
chatTabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
chatTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
chatTabBtn.Text = "Chat"
chatTabBtn.Font = Enum.Font.GothamBold
chatTabBtn.TextSize = 12
chatTabBtn.Parent = tabBar
local chatTabCorner = Instance.new("UICorner")
chatTabCorner.CornerRadius = UDim.new(0, 6)
chatTabCorner.Parent = chatTabBtn

local mimicTabBtn = Instance.new("TextButton")
mimicTabBtn.Size = UDim2.new(0.5, -5, 1, -4)
mimicTabBtn.Position = UDim2.new(0.5, 3, 0, 2)
mimicTabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mimicTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
mimicTabBtn.Text = "Mimic"
mimicTabBtn.Font = Enum.Font.GothamBold
mimicTabBtn.TextSize = 12
mimicTabBtn.Parent = tabBar
local mimicTabCorner = Instance.new("UICorner")
mimicTabCorner.CornerRadius = UDim.new(0, 6)
mimicTabCorner.Parent = mimicTabBtn

-- Chat Settings Content
local chatSettingsContent = Instance.new("Frame")
chatSettingsContent.Size = UDim2.new(1, 0, 1, -56)
chatSettingsContent.Position = UDim2.new(0, 0, 0, 56)
chatSettingsContent.BackgroundTransparency = 1
chatSettingsContent.Visible = false
chatSettingsContent.Parent = mainFrame

-- Case Mode Buttons
local caseRow = Instance.new("Frame")
caseRow.Size = UDim2.new(1, -20, 0, 24)
caseRow.Position = UDim2.new(0, 10, 0, 10)
caseRow.BackgroundTransparency = 1
caseRow.Parent = chatSettingsContent

local upperBtn = Instance.new("TextButton")
upperBtn.Size = UDim2.new(0.33, -2, 1, 0)
upperBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
upperBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
upperBtn.Text = "UPPER"
upperBtn.Font = Enum.Font.GothamBold
upperBtn.TextSize = 10
upperBtn.Parent = caseRow
local upperCorner = Instance.new("UICorner")
upperCorner.CornerRadius = UDim.new(0, 6)
upperCorner.Parent = upperBtn

local lowerBtn = Instance.new("TextButton")
lowerBtn.Size = UDim2.new(0.33, -2, 1, 0)
lowerBtn.Position = UDim2.new(0.33, 2, 0, 0)
lowerBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
lowerBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
lowerBtn.Text = "lower"
lowerBtn.Font = Enum.Font.Gotham
lowerBtn.TextSize = 10
lowerBtn.Parent = caseRow
local lowerCorner = Instance.new("UICorner")
lowerCorner.CornerRadius = UDim.new(0, 6)
lowerCorner.Parent = lowerBtn

local normalBtn = Instance.new("TextButton")
normalBtn.Size = UDim2.new(0.34, -2, 1, 0)
normalBtn.Position = UDim2.new(0.66, 2, 0, 0)
normalBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
normalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
normalBtn.Text = "Normal"
normalBtn.Font = Enum.Font.Gotham
normalBtn.TextSize = 10
normalBtn.Parent = caseRow
local normalCorner = Instance.new("UICorner")
normalCorner.CornerRadius = UDim.new(0, 6)
normalCorner.Parent = normalBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 16)
statusLabel.Position = UDim2.new(0, 10, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Text = "Mode: Normal"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = chatSettingsContent

-- Mimic Content
local mimicContent = Instance.new("Frame")
mimicContent.Size = UDim2.new(1, 0, 1, -56)
mimicContent.Position = UDim2.new(0, 0, 0, 56)
mimicContent.BackgroundTransparency = 1
mimicContent.Visible = false
mimicContent.Parent = mainFrame

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, -20, 0, 24)
targetLabel.Position = UDim2.new(0, 10, 0, 8)
targetLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
targetLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
targetLabel.Text = "Target: None"
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextSize = 12
targetLabel.Parent = mimicContent
local targetCorner = Instance.new("UICorner")
targetCorner.CornerRadius = UDim.new(0, 6)
targetCorner.Parent = targetLabel

local selectTargetBtn = Instance.new("TextButton")
selectTargetBtn.Size = UDim2.new(1, -20, 0, 28)
selectTargetBtn.Position = UDim2.new(0, 10, 0, 38)
selectTargetBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
selectTargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
selectTargetBtn.Text = "Select Target"
selectTargetBtn.Font = Enum.Font.GothamBold
selectTargetBtn.TextSize = 12
selectTargetBtn.Parent = mimicContent
local selectTargetCorner = Instance.new("UICorner")
selectTargetCorner.CornerRadius = UDim.new(0, 6)
selectTargetCorner.Parent = selectTargetBtn

local mimicToggle = Instance.new("TextButton")
mimicToggle.Size = UDim2.new(1, -20, 0, 32)
mimicToggle.Position = UDim2.new(0, 10, 0, 72)
mimicToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
mimicToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
mimicToggle.Text = "MIMIC: OFF"
mimicToggle.Font = Enum.Font.GothamBold
mimicToggle.TextSize = 14
mimicToggle.Parent = mimicContent
local mimicToggleCorner = Instance.new("UICorner")
mimicToggleCorner.CornerRadius = UDim.new(0, 6)
mimicToggleCorner.Parent = mimicToggle

local suffixInput = Instance.new("TextBox")
suffixInput.Size = UDim2.new(1, -70, 0, 28)
suffixInput.Position = UDim2.new(0, 10, 0, 110)
suffixInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
suffixInput.TextColor3 = Color3.fromRGB(255, 255, 255)
suffixInput.Text = ""
suffixInput.PlaceholderText = "Add suffix..."
suffixInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
suffixInput.Font = Enum.Font.Gotham
suffixInput.TextSize = 12
suffixInput.ClearTextOnFocus = false
suffixInput.Parent = mimicContent
local suffixInputCorner = Instance.new("UICorner")
suffixInputCorner.CornerRadius = UDim.new(0, 6)
suffixInputCorner.Parent = suffixInput

local addSuffixBtn = Instance.new("TextButton")
addSuffixBtn.Size = UDim2.new(0, 50, 0, 28)
addSuffixBtn.Position = UDim2.new(1, -60, 0, 110)
addSuffixBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
addSuffixBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addSuffixBtn.Text = "Add"
addSuffixBtn.Font = Enum.Font.GothamBold
addSuffixBtn.TextSize = 12
addSuffixBtn.Parent = mimicContent
local addSuffixCorner = Instance.new("UICorner")
addSuffixCorner.CornerRadius = UDim.new(0, 6)
addSuffixCorner.Parent = addSuffixBtn

local suffixListFrame = Instance.new("Frame")
suffixListFrame.Size = UDim2.new(1, -20, 0, 160)
suffixListFrame.Position = UDim2.new(0, 10, 0, 145)
suffixListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
suffixListFrame.Parent = mimicContent
local suffixListCorner = Instance.new("UICorner")
suffixListCorner.CornerRadius = UDim.new(0, 6)
suffixListCorner.Parent = suffixListFrame

local suffixScroll = Instance.new("ScrollingFrame")
suffixScroll.Size = UDim2.new(1, -10, 1, -10)
suffixScroll.Position = UDim2.new(0, 5, 0, 5)
suffixScroll.BackgroundTransparency = 1
suffixScroll.ScrollBarThickness = 4
suffixScroll.Parent = suffixListFrame
local suffixScrollCorner = Instance.new("UICorner")
suffixScrollCorner.CornerRadius = UDim.new(0, 4)
suffixScrollCorner.Parent = suffixScroll

local suffixLayout = Instance.new("UIListLayout")
suffixLayout.Padding = UDim.new(0, 2)
suffixLayout.Parent = suffixScroll

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, 120)
dropdownFrame.Position = UDim2.new(0, 10, 0, 68)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dropdownFrame.Visible = false
dropdownFrame.ZIndex = 10
dropdownFrame.Parent = mimicContent
local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 6)
dropdownCorner.Parent = dropdownFrame

local dropdownScroll = Instance.new("ScrollingFrame")
dropdownScroll.Size = UDim2.new(1, -10, 1, -10)
dropdownScroll.Position = UDim2.new(0, 5, 0, 5)
dropdownScroll.BackgroundTransparency = 1
dropdownScroll.ScrollBarThickness = 4
dropdownScroll.ZIndex = 10
dropdownScroll.Parent = dropdownFrame
local dropdownScrollCorner = Instance.new("UICorner")
dropdownScrollCorner.CornerRadius = UDim.new(0, 4)
dropdownScrollCorner.Parent = dropdownScroll

local dropdownLayout = Instance.new("UIListLayout")
dropdownLayout.Padding = UDim.new(0, 2)
dropdownLayout.Parent = dropdownScroll

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

collapseBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

killBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ========== TOGGLE ADVANCED MODE ==========
local function toggleAdvancedMode()
    advancedMode = not advancedMode
    
    if advancedMode then
        mainFrame.Size = UDim2.new(0, 220, 0, 380)
        mainFrame.Position = UDim2.new(0, 20, 0.5, -190)
        
        compactContent.Visible = false
        
        tabBar.Visible = true
        advancedContent.Visible = true
        chatSettingsContent.Visible = true
        mimicContent.Visible = false
        
        titleLabel.Text = "⚙ Settings"
        settingsBtn.Text = "◀"
    else
        mainFrame.Size = UDim2.new(0, 220, 0, 145)
        mainFrame.Position = UDim2.new(0, 20, 0.5, -72)
        
        compactContent.Visible = true
        
        tabBar.Visible = false
        advancedContent.Visible = false
        chatSettingsContent.Visible = false
        mimicContent.Visible = false
        
        titleLabel.Text = "💬 Quick Chat"
        settingsBtn.Text = "⚙"
    end
end

settingsBtn.MouseButton1Click:Connect(function()
    toggleAdvancedMode()
end)

-- ========== TAB SWITCHING ==========
local function switchTab(tab)
    if tab == "chat" then
        currentTab = "chat"
        chatSettingsContent.Visible = true
        mimicContent.Visible = false
        chatTabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        chatTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        mimicTabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        mimicTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    else
        currentTab = "mimic"
        chatSettingsContent.Visible = false
        mimicContent.Visible = true
        chatTabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        chatTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        mimicTabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        mimicTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

chatTabBtn.MouseButton1Click:Connect(function()
    switchTab("chat")
end)

mimicTabBtn.MouseButton1Click:Connect(function()
    switchTab("mimic")
end)

-- ========== CHARACTER LIMIT ==========
textbox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = textbox.Text
    if #text > MAX_CHARS then
        textbox.Text = text:sub(1, MAX_CHARS)
    end
    
    local lineCount = 1
    for _ in textbox.Text:gmatch("\n") do
        lineCount = lineCount + 1
    end
    
    charCounter.Text = "Lines: "..lineCount.." | Chars: "..#textbox.Text.."/"..MAX_CHARS
    
    if #textbox.Text >= MAX_CHARS then
        charCounter.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        charCounter.TextColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

-- ========== SEND MESSAGE FUNCTION ==========
local function sendMessage(msg, preserveCase)
    local message = msg
    
    if not preserveCase then
        if caseMode == "upper" then
            message = string.upper(message)
        elseif caseMode == "lower" then
            message = string.lower(message)
        end
    end
    
    message = message:gsub("^%s+", ""):gsub("%s+$", "")
    
    if message == "" then
        return false
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

-- ========== GET NEXT DELAY ==========
local function getNextDelay()
    if delayMode == "constant" then
        local d = tonumber(constDelayInput.Text) or 0.5
        if d < 0.1 then d = 0.1 end
        return d
    elseif delayMode == "sequential" then
        if #delayList == 0 then return 0.5 end
        local d = delayList[delayIndex]
        delayIndex = delayIndex + 1
        if delayIndex > #delayList then delayIndex = 1 end
        return d
    else -- random
        if #delayList == 0 then return 0.5 end
        return delayList[math.random(1, #delayList)]
    end
end

-- ========== UPDATE DELAY LIST UI ==========
local function updateDelayListUI()
    for _, child in pairs(delayScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    for i, d in ipairs(delayList) do
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, 0, 0, 20)
        item.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        item.Parent = delayScroll
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 4)
        itemCorner.Parent = item
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -24, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Text = i..". "..d.."s"
        label.Font = Enum.Font.Gotham
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = item
        
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 18, 0, 18)
        delBtn.Position = UDim2.new(1, -20, 0.5, -9)
        delBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.Text = "X"
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 9
        delBtn.Parent = item
        
        local delCorner = Instance.new("UICorner")
        delCorner.CornerRadius = UDim.new(0, 4)
        delCorner.Parent = delBtn
        
        delBtn.MouseButton1Click:Connect(function()
            table.remove(delayList, i)
            if delayIndex > #delayList then delayIndex = 1 end
            updateDelayListUI()
        end)
    end
    
    delayScroll.CanvasSize = UDim2.new(0, 0, 0, delayListLayout.AbsoluteContentSize.Y)
end

-- ========== UPDATE MODE BUTTONS ==========
local function updateModeButtons()
    randomBtn.BackgroundColor3 = delayMode == "random" and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(50, 50, 50)
    randomBtn.TextColor3 = delayMode == "random" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    
    seqBtn.BackgroundColor3 = delayMode == "sequential" and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(50, 50, 50)
    seqBtn.TextColor3 = delayMode == "sequential" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    
    constBtn.BackgroundColor3 = delayMode == "constant" and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(50, 50, 50)
    constBtn.TextColor3 = delayMode == "constant" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    
    -- Update mode button text
    if delayMode == "random" then
        delayModeBtn.Text = "R"
    elseif delayMode == "sequential" then
        delayModeBtn.Text = "S"
    else
        delayModeBtn.Text = "C"
    end
    
    -- Toggle visibility
    delayListFrame.Visible = delayMode ~= "constant"
    delayListTitle.Visible = delayMode ~= "constant"
    constDelayLabel.Visible = delayMode == "constant"
    constDelayInput.Visible = delayMode == "constant"
    addDelayRow.Visible = delayMode ~= "constant"
end

-- ========== DELAY MODE BUTTONS ==========
randomBtn.MouseButton1Click:Connect(function()
    delayMode = "random"
    updateModeButtons()
end)

seqBtn.MouseButton1Click:Connect(function()
    delayMode = "sequential"
    updateModeButtons()
end)

constBtn.MouseButton1Click:Connect(function()
    delayMode = "constant"
    updateModeButtons()
end)

delayModeBtn.MouseButton1Click:Connect(function()
    if delayMode == "random" then
        delayMode = "sequential"
    elseif delayMode == "sequential" then
        delayMode = "constant"
    else
        delayMode = "random"
    end
    updateModeButtons()
end)

-- ========== DELAY SETTINGS TOGGLE ==========
delaySettingsBtn.MouseButton1Click:Connect(function()
    delayDropdown.Visible = not delayDropdown.Visible
end)

-- ========== ADD DELAY ==========
addDelayBtn.MouseButton1Click:Connect(function()
    local text = addDelayInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
    local num = tonumber(text)
    if num and num >= 0.1 then
        table.insert(delayList, num)
        addDelayInput.Text = ""
        updateDelayListUI()
    end
end)

-- ========== CLEAR ALL DELAYS ==========
clearDelayBtn.MouseButton1Click:Connect(function()
    delayList = {}
    delayIndex = 1
    updateDelayListUI()
end)

-- ========== MOBILE FIX FOR MULTI-LINE ==========
textbox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        textbox.Text = textbox.Text .. "\n"
        task.wait()
        textbox:CaptureFocus()
    end
end)

-- ========== CLEAR BUTTON ==========
clearBtn.MouseButton1Click:Connect(function()
    textbox.Text = ""
    statusLabel.Text = "Cleared!"
    wait(0.5)
    statusLabel.Text = "Mode: "..caseMode:gsub("^%l", string.upper)
end)

-- ========== CASE MODE TOGGLES ==========
local function updateCaseButtons()
    upperBtn.BackgroundColor3 = caseMode == "upper" and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(50, 50, 50)
    upperBtn.TextColor3 = caseMode == "upper" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    
    lowerBtn.BackgroundColor3 = caseMode == "lower" and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(50, 50, 50)
    lowerBtn.TextColor3 = caseMode == "lower" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    
    normalBtn.BackgroundColor3 = caseMode == "normal" and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(50, 50, 50)
    normalBtn.TextColor3 = caseMode == "normal" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    
    statusLabel.Text = "Mode: "..caseMode:gsub("^%l", string.upper)
end

upperBtn.MouseButton1Click:Connect(function()
    caseMode = "upper"
    updateCaseButtons()
end)

lowerBtn.MouseButton1Click:Connect(function()
    caseMode = "lower"
    updateCaseButtons()
end)

normalBtn.MouseButton1Click:Connect(function()
    caseMode = "normal"
    updateCaseButtons()
end)

-- ========== SEND ALL BUTTON ==========
sendAllBtn.MouseButton1Click:Connect(function()
    local text = textbox.Text
    if text == "" then return end
    
    local lines = {}
    for line in text:gmatch("[^\n]+") do
        if line:match("%S") then
            table.insert(lines, line)
        end
    end
    
    if #lines == 0 then return end
    
    sendAllBtn.Text = "..."
    sendAllBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
    
    spawn(function()
        for i, line in ipairs(lines) do
            sendMessage(line)
            if i < #lines then
                local d = getNextDelay()
                wait(d)
            end
        end
        sendAllBtn.Text = "S"
        sendAllBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end)
end)

-- ========== MIMIC FUNCTIONS ==========
local function updateSuffixList()
    for _, child in pairs(suffixScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    for i, suffix in ipairs(suffixes) do
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, 0, 0, 24)
        item.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        item.Parent = suffixScroll
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 4)
        itemCorner.Parent = item
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -30, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Text = i..". "..suffix
        label.Font = Enum.Font.Gotham
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.Parent = item
        
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 24, 0, 24)
        deleteBtn.Position = UDim2.new(1, -26, 0, 0)
        deleteBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        deleteBtn.Text = "X"
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.TextSize = 10
        deleteBtn.Parent = item
        
        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, 4)
        deleteCorner.Parent = deleteBtn
        
        deleteBtn.MouseButton1Click:Connect(function()
            table.remove(suffixes, i)
            if suffixIndex > #suffixes then suffixIndex = 1 end
            updateSuffixList()
        end)
    end
    
    suffixScroll.CanvasSize = UDim2.new(0, 0, 0, suffixLayout.AbsoluteContentSize.Y)
end

local function onPlayerChatted(plr, msg)
    if not mimicEnabled then return end
    if targetPlayer == nil then return end
    if plr ~= targetPlayer then return end
    if #suffixes == 0 then return end
    
    local suffix = suffixes[suffixIndex]
    local mimicMsg = '"' .. msg .. '" ' .. suffix
    sendMessage(mimicMsg, true)
    
    suffixIndex = suffixIndex + 1
    if suffixIndex > #suffixes then
        suffixIndex = 1
    end
end

local function setupPlayerListener(plr)
    plr.Chatted:Connect(function(msg)
        onPlayerChatted(plr, msg)
    end)
end

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then
        setupPlayerListener(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        setupPlayerListener(plr)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr == targetPlayer then
        targetPlayer = nil
        targetLabel.Text = "Target: None"
        mimicEnabled = false
        mimicToggle.Text = "MIMIC: OFF"
        mimicToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end)

local function updateDropdown()
    for _, child in pairs(dropdownScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 24)
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 11
            btn.ZIndex = 10
            btn.Parent = dropdownScroll
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                targetPlayer = plr
                targetLabel.Text = "Target: " .. plr.Name
                dropdownFrame.Visible = false
            end)
        end
    end
    
    dropdownScroll.CanvasSize = UDim2.new(0, 0, 0, dropdownLayout.AbsoluteContentSize.Y)
end

selectTargetBtn.MouseButton1Click:Connect(function()
    if dropdownFrame.Visible then
        dropdownFrame.Visible = false
    else
        updateDropdown()
        dropdownFrame.Visible = true
    end
end)

mimicToggle.MouseButton1Click:Connect(function()
    if targetPlayer == nil then
        return
    end
    
    mimicEnabled = not mimicEnabled
    
    if mimicEnabled then
        mimicToggle.Text = "MIMIC: ON"
        mimicToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        mimicToggle.Text = "MIMIC: OFF"
        mimicToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end)

addSuffixBtn.MouseButton1Click:Connect(function()
    local text = suffixInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if text ~= "" then
        table.insert(suffixes, text)
        suffixInput.Text = ""
        updateSuffixList()
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if dropdownFrame.Visible then
            dropdownFrame.Visible = false
        end
        if delayDropdown.Visible then
            delayDropdown.Visible = false
        end
    end
end)

local guiVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        if mainFrame.Visible then
            mainFrame.Visible = false
            hubButton.Visible = guiVisible
        else
            guiVisible = not guiVisible
            hubButton.Visible = guiVisible
        end
    end
end)

-- Initialize delay list UI
updateDelayListUI()
updateModeButtons()

print("✅ Compact Multi-Chat Hub Loaded")
print("📌 Delay Mode: Random (R) - Click 'D' to customize delays")
