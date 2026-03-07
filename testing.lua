-- Custom Chat GUI (TALL + Spam Cycle Messages + Emoji Prefix)

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
local emojiExpanded = false
local spamIndex = 1

-- Emoji prefix settings
local emojiPrefixEnabled = false
local emojiPrefixMode = "FIXED" -- "FIXED" or "ROTATE"
local selectedEmoji = "😀"
local emojiIndex = 1

-- Available emojis
local emojiList = {
    "😀", "😃", "😄", "😁", "😅", "😂", "🤣", "😊", "😇", "🙂",
    "😉", "😌", "😍", "🥰", "😘", "😋", "😛", "😜", "🤪", "😎",
    "🤩", "🥳", "😏", "😒", "😞", "😔", "😟", "😕", "🙁", "😣",
    "😖", "😫", "😩", "🥺", "😢", "😭", "😤", "😠", "😡", "🤬",
    "🤯", "😱", "🥵", "🥶", "😳", "🤡", "👻", "👽", "🤖", "💩",
    "👋", "🤚", "🖐️", "✋", "🖖", "👌", "🤌", "🤏", "✌️", "🤞",
    "🤟", "🤘", "🤙", "👈", "👉", "👆", "🖕", "👇", "☝️", "👍",
    "👎", "✊", "👊", "🤛", "🤜", "👏", "🙌", "👐", "🤲", "🤝",
    "🙏", "✍️", "💪", "🦾", "🔥", "⭐", "🌟", "✨", "💫", "🎉",
    "🎊", "💎", "🏆", "🥇", "🥈", "🥉", "💰", "💵", "💳", "👑"
}

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
delayLabel.Size = UDim2.new(0, 25, 0, 32)
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

-- Toggles Row (Emoji + Messages)
local togglesRow = Instance.new("Frame")
togglesRow.Size = UDim2.new(1, -20, 0, 24)
togglesRow.Position = UDim2.new(0, 10, 0, 152)
togglesRow.BackgroundTransparency = 1
togglesRow.Parent = frame

-- Emoji Toggle Button
local emojiToggle = Instance.new("TextButton")
emojiToggle.Size = UDim2.new(0.5, -2, 0, 24)
emojiToggle.Position = UDim2.new(0, 0, 0, 0)
emojiToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
emojiToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
emojiToggle.Text = "😀 Emoji"
emojiToggle.Font = Enum.Font.GothamBold
emojiToggle.TextSize = 11
emojiToggle.Parent = togglesRow

local emojiToggleCorner = Instance.new("UICorner")
emojiToggleCorner.CornerRadius = UDim.new(0, 6)
emojiToggleCorner.Parent = emojiToggle

-- Messages Toggle Button
local messagesToggle = Instance.new("TextButton")
messagesToggle.Size = UDim2.new(0.5, -2, 0, 24)
messagesToggle.Position = UDim2.new(0.5, 2, 0, 0)
messagesToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
messagesToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
messagesToggle.Text = "▼ Messages"
messagesToggle.Font = Enum.Font.GothamBold
messagesToggle.TextSize = 11
messagesToggle.Parent = togglesRow

local messagesToggleCorner = Instance.new("UICorner")
messagesToggleCorner.CornerRadius = UDim.new(0, 6)
messagesToggleCorner.Parent = messagesToggle

-- ========== EMOJI PREFIX PANEL ==========

local emojiPanel = Instance.new("Frame")
emojiPanel.Size = UDim2.new(1, -20, 0, 150)
emojiPanel.Position = UDim2.new(0, 10, 0, 180)
emojiPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
emojiPanel.Visible = false
emojiPanel.Parent = frame

local emojiPanelCorner = Instance.new("UICorner")
emojiPanelCorner.CornerRadius = UDim.new(0, 6)
emojiPanelCorner.Parent = emojiPanel

-- Emoji Enable Toggle
local emojiEnableRow = Instance.new("Frame")
emojiEnableRow.Size = UDim2.new(1, 0, 0, 28)
emojiEnableRow.Position = UDim2.new(0, 0, 0, 5)
emojiEnableRow.BackgroundTransparency = 1
emojiEnableRow.Parent = emojiPanel

local emojiEnableLabel = Instance.new("TextLabel")
emojiEnableLabel.Size = UDim2.new(0, 80, 1, 0)
emojiEnableLabel.Position = UDim2.new(0, 5, 0, 0)
emojiEnableLabel.BackgroundTransparency = 1
emojiEnableLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
emojiEnableLabel.Text = "Emoji Prefix:"
emojiEnableLabel.Font = Enum.Font.Gotham
emojiEnableLabel.TextSize = 11
emojiEnableLabel.TextXAlignment = Enum.TextXAlignment.Left
emojiEnableLabel.Parent = emojiEnableRow

local emojiEnableBtn = Instance.new("TextButton")
emojiEnableBtn.Size = UDim2.new(0, 50, 0, 24)
emojiEnableBtn.Position = UDim2.new(0, 85, 0, 2)
emojiEnableBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
emojiEnableBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
emojiEnableBtn.Text = "OFF"
emojiEnableBtn.Font = Enum.Font.GothamBold
emojiEnableBtn.TextSize = 11
emojiEnableBtn.Parent = emojiEnableRow

local emojiEnableCorner = Instance.new("UICorner")
emojiEnableCorner.CornerRadius = UDim.new(0, 5)
emojiEnableCorner.Parent = emojiEnableBtn

-- Current Emoji Display
local emojiDisplayLabel = Instance.new("TextLabel")
emojiDisplayLabel.Size = UDim2.new(0, 40, 0, 24)
emojiDisplayLabel.Position = UDim2.new(1, -45, 0, 2)
emojiDisplayLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
emojiDisplayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
emojiDisplayLabel.Text = selectedEmoji
emojiDisplayLabel.Font = Enum.Font.GothamBold
emojiDisplayLabel.TextSize = 18
emojiDisplayLabel.Parent = emojiEnableRow

local emojiDisplayCorner = Instance.new("UICorner")
emojiDisplayCorner.CornerRadius = UDim.new(0, 5)
emojiDisplayCorner.Parent = emojiDisplayLabel

-- Mode Selection (Fixed / Rotate)
local modeRow = Instance.new("Frame")
modeRow.Size = UDim2.new(1, 0, 0, 28)
modeRow.Position = UDim2.new(0, 0, 0, 35)
modeRow.BackgroundTransparency = 1
modeRow.Parent = emojiPanel

local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(0, 50, 1, 0)
modeLabel.Position = UDim2.new(0, 5, 0, 0)
modeLabel.BackgroundTransparency = 1
modeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
modeLabel.Text = "Mode:"
modeLabel.Font = Enum.Font.Gotham
modeLabel.TextSize = 11
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = modeRow

local fixedBtn = Instance.new("TextButton")
fixedBtn.Size = UDim2.new(0, 65, 0, 24)
fixedBtn.Position = UDim2.new(0, 55, 0, 2)
fixedBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
fixedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fixedBtn.Text = "FIXED"
fixedBtn.Font = Enum.Font.GothamBold
fixedBtn.TextSize = 10
fixedBtn.Parent = modeRow

local fixedCorner = Instance.new("UICorner")
fixedCorner.CornerRadius = UDim.new(0, 5)
fixedCorner.Parent = fixedBtn

local rotateBtn = Instance.new("TextButton")
rotateBtn.Size = UDim2.new(0, 65, 0, 24)
rotateBtn.Position = UDim2.new(0, 125, 0, 2)
rotateBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
rotateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rotateBtn.Text = "ROTATE"
rotateBtn.Font = Enum.Font.GothamBold
rotateBtn.TextSize = 10
rotateBtn.Parent = modeRow

local rotateCorner = Instance.new("UICorner")
rotateCorner.CornerRadius = UDim.new(0, 5)
rotateCorner.Parent = rotateBtn

-- Emoji Grid Label
local emojiGridLabel = Instance.new("TextLabel")
emojiGridLabel.Size = UDim2.new(1, 0, 0, 18)
emojiGridLabel.Position = UDim2.new(0, 0, 0, 65)
emojiGridLabel.BackgroundTransparency = 1
emojiGridLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
emojiGridLabel.Text = "Select Emoji:"
emojiGridLabel.Font = Enum.Font.Gotham
emojiGridLabel.TextSize = 10
emojiGridLabel.TextXAlignment = Enum.TextXAlignment.Left
emojiGridLabel.Parent = emojiPanel

-- Emoji Grid ScrollingFrame
local emojiScroll = Instance.new("ScrollingFrame")
emojiScroll.Size = UDim2.new(1, 0, 1, -85)
emojiScroll.Position = UDim2.new(0, 0, 0, 83)
emojiScroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
emojiScroll.ScrollBarThickness = 4
emojiScroll.Parent = emojiPanel

local emojiScrollCorner = Instance.new("UICorner")
emojiScrollCorner.CornerRadius = UDim.new(0, 4)
emojiScrollCorner.Parent = emojiScroll

local emojiGrid = Instance.new("UIGridLayout")
emojiGrid.CellSize = UDim2.new(0, 30, 0, 30)
emojiGrid.CellPadding = UDim2.new(0, 2, 0, 2)
emojiGrid.Parent = emojiScroll

-- Create emoji buttons
local function createEmojiGrid()
    for _, emoji in ipairs(emojiList) do
        local emojiBtn = Instance.new("TextButton")
        emojiBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        emojiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        emojiBtn.Text = emoji
        emojiBtn.Font = Enum.Font.GothamBold
        emojiBtn.TextSize = 16
        emojiBtn.Parent = emojiScroll
        
        local emojiBtnCorner = Instance.new("UICorner")
        emojiBtnCorner.CornerRadius = UDim.new(0, 4)
        emojiBtnCorner.Parent = emojiBtn
        
        emojiBtn.MouseButton1Click:Connect(function()
            selectedEmoji = emoji
            emojiDisplayLabel.Text = emoji
            emojiToggle.Text = emoji .. " Emoji"
        end)
    end
end

createEmojiGrid()

-- ========== MESSAGES PANEL ==========

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

-- ========== DRAGGING ==========

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

-- ========== CHARACTER LIMIT ==========

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

-- ========== SEND MESSAGE FUNCTION ==========

local function getEmojiPrefix()
    if not emojiPrefixEnabled then
        return ""
    end
    
    if emojiPrefixMode == "FIXED" then
        return selectedEmoji .. " "
    else -- ROTATE
        local emoji = emojiList[emojiIndex]
        emojiIndex = emojiIndex + 1
        if emojiIndex > #emojiList then
            emojiIndex = 1
        end
        return emoji .. " "
    end
end

local function sendMessage(msg)
    local message = msg or textbox.Text
    message = message:gsub("^%s+", ""):gsub("%s+$", "")
    message = message:gsub("\n", " ")
    
    if message == "" then
        return false
    end
    
    -- Add emoji prefix
    local prefix = getEmojiPrefix()
    message = prefix .. message
    
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

-- ========== UPDATE MESSAGES UI ==========

local function updateMessagesUI()
    for _, child in pairs(messagesScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
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

-- ========== TOGGLE HANDLERS ==========

-- Toggle emoji panel
emojiToggle.MouseButton1Click:Connect(function()
    emojiExpanded = not emojiExpanded
    messagesExpanded = false
    messagesPanel.Visible = false
    messagesToggle.Text = "▼ Messages"
    
    emojiPanel.Visible = emojiExpanded
    
    if emojiExpanded then
        emojiToggle.Text = selectedEmoji .. " Emoji"
        frame.Size = UDim2.new(0, 200, 0, 338)
    else
        emojiToggle.Text = selectedEmoji .. " Emoji"
        frame.Size = UDim2.new(0, 200, 0, 180)
    end
end)

-- Toggle messages panel
messagesToggle.MouseButton1Click:Connect(function()
    messagesExpanded = not messagesExpanded
    emojiExpanded = false
    emojiPanel.Visible = false
    
    messagesPanel.Visible = messagesExpanded
    
    if messagesExpanded then
        messagesToggle.Text = "▲ Messages"
        frame.Size = UDim2.new(0, 200, 0, 308)
    else
        messagesToggle.Text = "▼ Messages"
        frame.Size = UDim2.new(0, 200, 0, 180)
    end
    
    updateMessagesUI()
end)

-- Emoji enable toggle
emojiEnableBtn.MouseButton1Click:Connect(function()
    emojiPrefixEnabled = not emojiPrefixEnabled
    if emojiPrefixEnabled then
        emojiEnableBtn.Text = "ON"
        emojiEnableBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    else
        emojiEnableBtn.Text = "OFF"
        emojiEnableBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end)

-- Mode buttons
fixedBtn.MouseButton1Click:Connect(function()
    emojiPrefixMode = "FIXED"
    fixedBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    rotateBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

rotateBtn.MouseButton1Click:Connect(function()
    emojiPrefixMode = "ROTATE"
    rotateBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    fixedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
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

-- Send button
sendButton.MouseButton1Click:Connect(function()
    if textbox.Text ~= "" then
        sendMessage()
    end
end)

-- FocusLost
textbox.FocusLost:Connect(function(enterPressed)
    if textbox.Text ~= "" and enterPressed then
        sendMessage()
    end
end)

-- Enter key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Enter and textbox:IsFocused() then
        if textbox.Text ~= "" then
            sendMessage()
        end
    end
end)

-- Focused - clear
textbox.Focused:Connect(function()
    textbox.Text = ""
end)

-- ========== SPAM TOGGLE ==========

local function toggleSpam()
    spamEnabled = not spamEnabled
    
    if spamEnabled then
        spamDelay = tonumber(delayTextbox.Text) or 1
        if spamDelay < 0.1 then
            spamDelay = 0.1
        end
        
        spamButton.Text = "SPAM: ON"
        spamButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
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

-- Toggle GUI with RightControl
local guiVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        frame.Visible = guiVisible
    end
end)

-- Initialize
updateMessagesUI()

print("✅ Custom Chat GUI Loaded (with Emoji Prefix + Spam Cycle)")
