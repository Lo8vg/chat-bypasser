-- Custom Chat GUI (TALL + Spam Cycle + Follow-Up + Ghost)

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
local followUpEnabled = false
local ghostEnabled = false

local premadeMessages = {
    "Hello",
    "GG",
    "What's up",
    "Bye"
}

-- Zero-width space character
local ZWSP = utf8.char(0x200B)

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
titleLabel.Text = "Chat"
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

-- Tab Row
local tabRow = Instance.new("Frame")
tabRow.Size = UDim2.new(1, -20, 0, 24)
tabRow.Position = UDim2.new(0, 10, 0, 152)
tabRow.BackgroundTransparency = 1
tabRow.Parent = frame

-- Messages Tab
local messagesTab = Instance.new("TextButton")
messagesTab.Size = UDim2.new(0.33, -2, 0, 24)
messagesTab.Position = UDim2.new(0, 0, 0, 0)
messagesTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
messagesTab.TextColor3 = Color3.fromRGB(255, 255, 255)
messagesTab.Text = "Msgs"
messagesTab.Font = Enum.Font.GothamBold
messagesTab.TextSize = 10
messagesTab.Parent = tabRow

local messagesTabCorner = Instance.new("UICorner")
messagesTabCorner.CornerRadius = UDim.new(0, 6)
messagesTabCorner.Parent = messagesTab

-- Follow-Up Tab
local followUpTab = Instance.new("TextButton")
followUpTab.Size = UDim2.new(0.33, -2, 0, 24)
followUpTab.Position = UDim2.new(0.33, 2, 0, 0)
followUpTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
followUpTab.TextColor3 = Color3.fromRGB(200, 200, 200)
followUpTab.Text = "Follow"
followUpTab.Font = Enum.Font.GothamBold
followUpTab.TextSize = 10
followUpTab.Parent = tabRow

local followUpTabCorner = Instance.new("UICorner")
followUpTabCorner.CornerRadius = UDim.new(0, 6)
followUpTabCorner.Parent = followUpTab

-- Ghost Tab
local ghostTab = Instance.new("TextButton")
ghostTab.Size = UDim2.new(0.34, -2, 0, 24)
ghostTab.Position = UDim2.new(0.66, 2, 0, 0)
ghostTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ghostTab.TextColor3 = Color3.fromRGB(200, 200, 200)
ghostTab.Text = "Ghost"
ghostTab.Font = Enum.Font.GothamBold
ghostTab.TextSize = 10
ghostTab.Parent = tabRow

local ghostTabCorner = Instance.new("UICorner")
ghostTabCorner.CornerRadius = UDim.new(0, 6)
ghostTabCorner.Parent = ghostTab

-- Messages Panel
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

-- Follow-Up Panel
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

-- Follow-Up Input
local followUpInput = Instance.new("TextBox")
followUpInput.Size = UDim2.new(1, -10, 0, 32)
followUpInput.Position = UDim2.new(0, 5, 0, 40)
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

-- Follow-Up Delay Input
local followUpDelayInput = Instance.new("TextBox")
followUpDelayInput.Size = UDim2.new(0, 60, 0, 28)
followUpDelayInput.Position = UDim2.new(0, 5, 0, 80)
followUpDelayInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
followUpDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
followUpDelayInput.Text = "0.5"
followUpDelayInput.Font = Enum.Font.Gotham
followUpDelayInput.TextSize = 12
followUpDelayInput.ClearTextOnFocus = false
followUpDelayInput.Parent = followUpPanel

local followUpDelayCorner = Instance.new("UICorner")
followUpDelayCorner.CornerRadius = UDim.new(0, 6)
followUpDelayCorner.Parent = followUpDelayInput

-- Follow-Up Delay Label
local followUpDelayLabel = Instance.new("TextLabel")
followUpDelayLabel.Size = UDim2.new(0, 60, 0, 28)
followUpDelayLabel.Position = UDim2.new(0, 70, 0, 80)
followUpDelayLabel.BackgroundTransparency = 1
followUpDelayLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
followUpDelayLabel.Text = "sec delay"
followUpDelayLabel.Font = Enum.Font.Gotham
followUpDelayLabel.TextSize = 10
followUpDelayLabel.Parent = followUpPanel

-- Ghost Panel
local ghostPanel = Instance.new("Frame")
ghostPanel.Size = UDim2.new(1, -20, 0, 120)
ghostPanel.Position = UDim2.new(0, 10, 0, 180)
ghostPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ghostPanel.Visible = false
ghostPanel.Parent = frame

local ghostPanelCorner = Instance.new("UICorner")
ghostPanelCorner.CornerRadius = UDim.new(0, 6)
ghostPanelCorner.Parent = ghostPanel

-- Ghost Toggle
local ghostToggle = Instance.new("TextButton")
ghostToggle.Size = UDim2.new(1, -10, 0, 28)
ghostToggle.Position = UDim2.new(0, 5, 0, 5)
ghostToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
ghostToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ghostToggle.Text = "GHOST: OFF"
ghostToggle.Font = Enum.Font.GothamBold
ghostToggle.TextSize = 12
ghostToggle.Parent = ghostPanel

local ghostToggleCorner = Instance.new("UICorner")
ghostToggleCorner.CornerRadius = UDim.new(0, 6)
ghostToggleCorner.Parent = ghostToggle

-- Ghost Lines Label
local ghostLinesLabel = Instance.new("TextLabel")
ghostLinesLabel.Size = UDim2.new(0, 80, 0, 28)
ghostLinesLabel.Position = UDim2.new(0, 5, 0, 40)
ghostLinesLabel.BackgroundTransparency = 1
ghostLinesLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ghostLinesLabel.Text = "Ghost Lines:"
ghostLinesLabel.Font = Enum.Font.Gotham
ghostLinesLabel.TextSize = 11
ghostLinesLabel.TextXAlignment = Enum.TextXAlignment.Left
ghostLinesLabel.Parent = ghostPanel

-- Ghost Lines Input
local ghostLinesInput = Instance.new("TextBox")
ghostLinesInput.Size = UDim2.new(0, 60, 0, 28)
ghostLinesInput.Position = UDim2.new(0, 85, 0, 40)
ghostLinesInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ghostLinesInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ghostLinesInput.Text = "5"
ghostLinesInput.Font = Enum.Font.Gotham
ghostLinesInput.TextSize = 12
ghostLinesInput.ClearTextOnFocus = false
ghostLinesInput.Parent = ghostPanel

local ghostLinesInputCorner = Instance.new("UICorner")
ghostLinesInputCorner.CornerRadius = UDim.new(0, 6)
ghostLinesInputCorner.Parent = ghostLinesInput

-- Ghost Info
local ghostInfo = Instance.new("TextLabel")
ghostInfo.Size = UDim2.new(1, -10, 0, 40)
ghostInfo.Position = UDim2.new(0, 5, 0, 75)
ghostInfo.BackgroundTransparency = 1
ghostInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
ghostInfo.Text = "Invisible lines push message\nto bottom of chat bubble"
ghostInfo.Font = Enum.Font.Gotham
ghostInfo.TextSize = 10
ghostInfo.TextXAlignment = Enum.TextXAlignment.Left
ghostInfo.TextYAlignment = Enum.TextYAlignment.Top
ghostInfo.Parent = ghostPanel

-- Dragging
local dragging = false
local dragInput, dragStart, startPos

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

-- Ghost prefix function
local function getGhostPrefix()
    if not ghostEnabled then return "" end
    local lines = tonumber(ghostLinesInput.Text) or 5
    if lines < 0 then lines = 0 end
    if lines > 50 then lines = 50 end
    return ZWSP .. string.rep("\n", lines)
end

-- Send message function
local function sendMessage(msg)
    local message = msg or textbox.Text
    message = message:gsub("^%s+", ""):gsub("%s+$", "")
    message = message:gsub("\n", " ")
    if message == "" then return false end
    if #message > MAX_CHARS then
        message = message:sub(1, MAX_CHARS)
    end
    local ghostPrefix = getGhostPrefix()
    local finalMessage = ghostPrefix .. message
    
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

-- Send with follow-up
local function sendWithFollowUp()
    local msg = textbox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if msg == "" then return end
    sendMessage(msg)
    textbox.Text = ""
    if followUpEnabled then
        local fuMsg = followUpInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if fuMsg ~= "" then
            local delay = tonumber(followUpDelayInput.Text) or 0.5
            task.delay(delay, function()
                sendMessage(fuMsg)
            end)
        end
    end
end

-- Update messages UI
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

-- Tab switching
local currentTab = "messages"

local function switchTab(tab)
    currentTab = tab
    messagesTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    messagesTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    messagesTab.Text = "Msgs"
    followUpTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    followUpTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    followUpTab.Text = "Follow"
    ghostTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ghostTab.TextColor3 = Color3.fromRGB(200, 200, 200)
    ghostTab.Text = "Ghost"
    
    messagesPanel.Visible = false
    followUpPanel.Visible = false
    ghostPanel.Visible = false
    
    if tab == "messages" then
        messagesTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        messagesTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        messagesTab.Text = "Msgs"
        messagesPanel.Visible = messagesExpanded
    elseif tab == "followup" then
        followUpTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        followUpTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        followUpPanel.Visible = true
    elseif tab == "ghost" then
        ghostTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ghostTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        ghostPanel.Visible = true
    end
end

messagesTab.MouseButton1Click:Connect(function() switchTab("messages") end)
followUpTab.MouseButton1Click:Connect(function() switchTab("followup") end)
ghostTab.MouseButton1Click:Connect(function() switchTab("ghost") end)

messagesTab.MouseButton2Click:Connect(function()
    if currentTab == "messages" then
        messagesExpanded = not messagesExpanded
        messagesPanel.Visible = messagesExpanded
        if messagesExpanded then
            frame.Size = UDim2.new(0, 200, 0, 310)
        else
            frame.Size = UDim2.new(0, 200, 0, 180)
        end
    end
end)

-- Toggles
followUpToggle.MouseButton1Click:Connect(function()
    followUpEnabled = not followUpEnabled
    if followUpEnabled then
        followUpToggle.Text = "FOLLOW-UP: ON"
        followUpToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        followUpToggle.Text = "FOLLOW-UP: OFF"
        followUpToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end)

ghostToggle.MouseButton1Click:Connect(function()
    ghostEnabled = not ghostEnabled
    if ghostEnabled then
        ghostToggle.Text = "GHOST: ON"
        ghostToggle.BackgroundColor3 = Color3.fromRGB(157, 77, 255)
    else
        ghostToggle.Text = "GHOST: OFF"
        ghostToggle.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end)

-- Buttons
addMsgButton.MouseButton1Click:Connect(function()
    local msg = textbox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if msg ~= "" then
        table.insert(premadeMessages, msg)
        updateMessagesUI()
        textbox.Text = ""
    end
end)

sendButton.MouseButton1Click:Connect(function()
    if textbox.Text ~= "" then sendWithFollowUp() end
end)

textbox.FocusLost:Connect(function(enterPressed)
    if textbox.Text ~= "" and enterPressed then sendWithFollowUp() end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Enter and textbox:IsFocused() then
        if textbox.Text ~= "" then sendWithFollowUp() end
    end
end)

-- Spam toggle
local function toggleSpam()
    spamEnabled = not spamEnabled
    if spamEnabled then
        spamDelay = tonumber(delayTextbox.Text) or 1
        if spamDelay < 0.1 then spamDelay = 0.1 end
        spamButton.Text = "SPAM: ON"
        spamButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        if #premadeMessages > 0 then
            spamIndex = 1
            task.spawn(function()
                while spamEnabled do
                    sendMessage(premadeMessages[spamIndex])
                    spamIndex = spamIndex + 1
                    if spamIndex > #premadeMessages then spamIndex = 1 end
                    task.wait(spamDelay)
                end
            end)
        else
            task.spawn(function()
                while spamEnabled do
                    if textbox.Text ~= "" then sendMessage() end
                    task.wait(spamDelay)
                end
            end)
        end
    else
        spamButton.Text = "SPAM: OFF"
        spamButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end

spamButton.MouseButton1Click:Connect(toggleSpam)

-- Toggle GUI
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        frame.Visible = guiVisible
    end
end)

-- Init
updateMessagesUI()
switchTab("messages")

print("Chat GUI Loaded - RightControl to toggle")
