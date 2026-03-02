-- Chat Hub Script (Part 1 - Structure & Settings)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local hubWidth = 280
local hubHeight = 400

-- Prefix Settings
local prefixEnabled = false
local prefixMode = "Fixed" -- "Fixed" or "Rotate"
local prefixEmojis = {"💀", "🔥", "😈"}
local currentEmojiIndex = 1

-- Tab states
local expandedTab = nil

-- Colors (Dark Theme)
local COLORS = {
    background = Color3.fromRGB(30, 30, 35),
    header = Color3.fromRGB(40, 40, 45),
    buttonPrimary = Color3.fromRGB(0, 120, 215),
    buttonDanger = Color3.fromRGB(220, 53, 69),
    buttonSuccess = Color3.fromRGB(40, 167, 69),
    buttonWarning = Color3.fromRGB(255, 193, 7),
    buttonPurple = Color3.fromRGB(111, 66, 193),
    buttonDark = Color3.fromRGB(50, 50, 55),
    textDark = Color3.fromRGB(33, 37, 41),
    textLight = Color3.fromRGB(255, 255, 255),
    textMuted = Color3.fromRGB(150, 150, 150),
    inputBg = Color3.fromRGB(45, 45, 50),
    border = Color3.fromRGB(60, 60, 65),
    cardBg = Color3.fromRGB(35, 35, 40)
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========== HUB BUTTON (Small Square) ==========

local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 50, 0, 50)
hubButton.Position = UDim2.new(0, 20, 0.5, -25)
hubButton.BackgroundColor3 = COLORS.cardBg
hubButton.BorderSizePixel = 0
hubButton.Visible = true
hubButton.Parent = screenGui

local hubButtonCorner = Instance.new("UICorner")
hubButtonCorner.CornerRadius = UDim.new(0, 10)
hubButtonCorner.Parent = hubButton

local hubButtonShadow = Instance.new("UIStroke")
hubButtonShadow.Color = COLORS.border
hubButtonShadow.Thickness = 1
hubButtonShadow.Parent = hubButton

local hubButtonIcon = Instance.new("TextLabel")
hubButtonIcon.Size = UDim2.new(1, 0, 1, 0)
hubButtonIcon.BackgroundTransparency = 1
hubButtonIcon.TextColor3 = COLORS.textLight
hubButtonIcon.Text = "💬"
hubButtonIcon.Font = Enum.Font.GothamBold
hubButtonIcon.TextSize = 22
hubButtonIcon.Parent = hubButton

-- ========== MAIN FRAME ==========

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, hubWidth, 0, hubHeight)
mainFrame.Position = UDim2.new(0.5, -hubWidth/2, 0.5, -hubHeight/2)
mainFrame.BackgroundColor3 = COLORS.background
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 14)
mainFrameCorner.Parent = mainFrame

local mainFrameShadow = Instance.new("UIStroke")
mainFrameShadow.Color = Color3.fromRGB(20, 20, 25)
mainFrameShadow.Thickness = 2
mainFrameShadow.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = COLORS.header
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 14)
titleBarCorner.Parent = titleBar

local titleBarFix = Instance.new("Frame")
titleBarFix.Size = UDim2.new(1, 0, 0, 14)
titleBarFix.Position = UDim2.new(0, 0, 1, -14)
titleBarFix.BackgroundColor3 = COLORS.header
titleBarFix.BorderSizePixel = 0
titleBarFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = COLORS.textLight
titleLabel.Text = "💬 Chat Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 30, 0, 24)
collapseButton.Position = UDim2.new(1, -38, 0.5, -12)
collapseButton.BackgroundColor3 = COLORS.buttonDanger
collapseButton.TextColor3 = COLORS.textLight
collapseButton.Text = "✕"
collapseButton.Font = Enum.Font.GothamBold
collapseButton.TextSize = 12
collapseButton.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseButton

-- ========== TAB BAR ==========

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 35)
tabBar.Position = UDim2.new(0, 0, 0, 40)
tabBar.BackgroundColor3 = COLORS.cardBg
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

local tabBarFix = Instance.new("Frame")
tabBarFix.Size = UDim2.new(1, 0, 0, 14)
tabBarFix.Position = UDim2.new(0, 0, 1, -14)
tabBarFix.BackgroundColor3 = COLORS.cardBg
tabBarFix.BorderSizePixel = 0
tabBarFix.Parent = tabBar

-- Tab Buttons
local tabButtons = {}
local tabNames = {"Quick", "Multi", "Spam", "Prefix", "Settings"}
local tabIcons = {"⚡", "📝", "🔄", "😀", "⚙️"}

for i, name in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1/#tabNames, -4, 1, 0)
    tabBtn.Position = UDim2.new((i-1)/#tabNames, 2, 0, 0)
    tabBtn.BackgroundColor3 = COLORS.buttonDark
    tabBtn.TextColor3 = COLORS.textMuted
    tabBtn.Text = tabIcons[i]
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 14
    tabBtn.Parent = tabBar
    
    local tabBtnCorner = Instance.new("UICorner")
    tabBtnCorner.CornerRadius = UDim.new(0, 6)
    tabBtnCorner.Parent = tabBtn
    
    tabButtons[name] = tabBtn
end

-- ========== CONTENT AREA ==========

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -20, 1, -85)
contentArea.Position = UDim2.new(0, 10, 0, 75)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- Tab Pages
local tabPages = {}
for _, name in ipairs(tabNames) do
    local page = Instance.new("ScrollingFrame")
    page.Name = name.."Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = COLORS.buttonPrimary
    page.Visible = false
    page.Parent = contentArea
    
    tabPages[name] = page
end

-- ========== HELPER FUNCTIONS ==========

local function sendMessage(text)
    if not text or text == "" then return end
    
    -- Apply prefix if enabled
    local finalText = text
    if prefixEnabled and #prefixEmojis > 0 then
        if prefixMode == "Fixed" then
            finalText = table.concat(prefixEmojis, "") .. " " .. text
        else -- Rotate
            local emoji = prefixEmojis[currentEmojiIndex]
            finalText = emoji .. " " .. text
            currentEmojiIndex = currentEmojiIndex + 1
            if currentEmojiIndex > #prefixEmojis then
                currentEmojiIndex = 1
            end
        end
    end
    
    -- Send via TextChatService (new Roblox chat)
    local TextChannel = TextChatService:FindFirstChild("TextChannels")
    if TextChannel then
        local RBXGeneral = TextChannel:FindFirstChild("RBXGeneral")
        if RBXGeneral then
            RBXGeneral:SendAsync(finalText)
        end
    end
    
    -- Fallback: Legacy chat
    local ChatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if ChatRemote then
        local SayMessageRequest = ChatRemote:FindFirstChild("SayMessageRequest")
        if SayMessageRequest then
            SayMessageRequest:FireServer(finalText, "All")
        end
    end
end

local function resizeHub(width, height)
    hubWidth = width
    hubHeight = height
    mainFrame.Size = UDim2.new(0, width, 0, height)
    mainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
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

local hubDragging = false
local hubDragInput, hubDragStart, hubDragPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        hubDragging = true
        hubDragStart = input.Position
        hubDragPos = mainFrame.Position
        
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
        mainFrame.Position = UDim2.new(hubDragPos.X.Scale, hubDragPos.X.Offset + delta.X, hubDragPos.Y.Scale, hubDragPos.Y.Offset + delta.Y)
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

collapseButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

-- ========== TAB SWITCHING (EXPAND/COLLAPSE) ==========

local function setupTabClick(tabName)
    tabButtons[tabName].MouseButton1Click:Connect(function()
        if expandedTab == tabName then
            -- Collapse
            tabPages[tabName].Visible = false
            tabButtons[tabName].BackgroundColor3 = COLORS.buttonDark
            tabButtons[tabName].TextColor3 = COLORS.textMuted
            expandedTab = nil
        else
            -- Collapse previous
            if expandedTab then
                tabPages[expandedTab].Visible = false
                tabButtons[expandedTab].BackgroundColor3 = COLORS.buttonDark
                tabButtons[expandedTab].TextColor3 = COLORS.textMuted
            end
            -- Expand new
            tabPages[tabName].Visible = true
            tabButtons[tabName].BackgroundColor3 = COLORS.buttonPrimary
            tabButtons[tabName].TextColor3 = COLORS.textLight
            expandedTab = tabName
        end
    end)
end

for _, name in ipairs(tabNames) do
    setupTabClick(name)
end
-- Chat Hub Script (Part 2 - Quick Chat Tab)

-- ========== QUICK CHAT TAB ==========

local quickPage = tabPages["Quick"]

local quickLayout = Instance.new("UIListLayout")
quickLayout.Padding = UDim.new(0, 8)
quickLayout.Parent = quickPage

-- Description
local quickDesc = Instance.new("TextLabel")
quickDesc.Size = UDim2.new(1, 0, 0, 20)
quickDesc.BackgroundTransparency = 1
quickDesc.TextColor3 = COLORS.textMuted
quickDesc.Text = "Quick message - clears on focus"
quickDesc.Font = Enum.Font.Gotham
quickDesc.TextSize = 11
quickDesc.TextXAlignment = Enum.TextXAlignment.Left
quickDesc.Parent = quickPage

-- Textbox
local quickInput = Instance.new("TextBox")
quickInput.Size = UDim2.new(1, 0, 0, 80)
quickInput.BackgroundColor3 = COLORS.inputBg
quickInput.TextColor3 = COLORS.textLight
quickInput.Text = ""
quickInput.PlaceholderText = "Type your message..."
quickInput.PlaceholderColor3 = COLORS.textMuted
quickInput.Font = Enum.Font.Gotham
quickInput.TextSize = 13
quickInput.TextWrapped = true
quickInput.MultiLine = true
quickInput.ClearTextOnFocus = false
quickInput.TextYAlignment = Enum.TextYAlignment.Top
quickInput.Parent = quickPage

local quickInputCorner = Instance.new("UICorner")
quickInputCorner.CornerRadius = UDim.new(0, 8)
quickInputCorner.Parent = quickInput

local quickInputStroke = Instance.new("UIStroke")
quickInputStroke.Color = COLORS.border
quickInputStroke.Thickness = 1
quickInputStroke.Parent = quickInput

-- Character Counter
local quickCounter = Instance.new("TextLabel")
quickCounter.Size = UDim2.new(1, 0, 0, 18)
quickCounter.BackgroundTransparency = 1
quickCounter.TextColor3 = COLORS.textMuted
quickCounter.Text = "0/200"
quickCounter.Font = Enum.Font.Gotham
quickCounter.TextSize = 11
quickCounter.TextXAlignment = Enum.TextXAlignment.Right
quickCounter.Parent = quickPage

-- Send Button
local quickSendBtn = Instance.new("TextButton")
quickSendBtn.Size = UDim2.new(1, 0, 0, 40)
quickSendBtn.BackgroundColor3 = COLORS.buttonPrimary
quickSendBtn.TextColor3 = COLORS.textLight
quickSendBtn.Text = "📤 Send Message"
quickSendBtn.Font = Enum.Font.GothamBold
quickSendBtn.TextSize = 14
quickSendBtn.Parent = quickPage

local quickSendBtnCorner = Instance.new("UICorner")
quickSendBtnCorner.CornerRadius = UDim.new(0, 8)
quickSendBtnCorner.Parent = quickSendBtn

-- Quick Chat Functions
local function quickSend()
    local text = quickInput.Text
    if text and text ~= "" then
        sendMessage(text)
        quickInput.Text = ""
        quickCounter.Text = "0/200"
    end
end

-- Clear on focus
quickInput.Focused:Connect(function()
    quickInput.Text = ""
    quickCounter.Text = "0/200"
end)

-- Character counter
quickInput:GetPropertyChangedSignal("Text"):Connect(function()
    local len = #quickInput.Text
    quickCounter.Text = len.."/200"
    if len > 200 then
        quickCounter.TextColor3 = COLORS.buttonDanger
    else
        quickCounter.TextColor3 = COLORS.textMuted
    end
end)

-- Send on button click
quickSendBtn.MouseButton1Click:Connect(quickSend)

-- Send on Enter key
quickInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        quickSend()
    end
end)

-- Update canvas size
quickLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    quickPage.CanvasSize = UDim2.new(0, 0, 0, quickLayout.AbsoluteContentSize.Y + 10)
end)
-- Chat Hub Script (Part 3 - Multi-Line Chat Tab)

-- ========== MULTI-LINE CHAT TAB ==========

local multiPage = tabPages["Multi"]

local multiLayout = Instance.new("UIListLayout")
multiLayout.Padding = UDim.new(0, 8)
multiLayout.Parent = multiPage

-- Description
local multiDesc = Instance.new("TextLabel")
multiDesc.Size = UDim2.new(1, 0, 0, 20)
multiDesc.BackgroundTransparency = 1
multiDesc.TextColor3 = COLORS.textMuted
multiDesc.Text = "Each line = separate message | Enter = new line"
multiDesc.Font = Enum.Font.Gotham
multiDesc.TextSize = 11
multiDesc.TextXAlignment = Enum.TextXAlignment.Left
multiDesc.Parent = multiPage

-- Textbox Container (for scrolling)
local multiContainer = Instance.new("Frame")
multiContainer.Size = UDim2.new(1, 0, 0, 150)
multiContainer.BackgroundColor3 = COLORS.inputBg
multiContainer.Parent = multiPage

local multiContainerCorner = Instance.new("UICorner")
multiContainerCorner.CornerRadius = UDim.new(0, 8)
multiContainerCorner.Parent = multiContainer

local multiContainerStroke = Instance.new("UIStroke")
multiContainerStroke.Color = COLORS.border
multiContainerStroke.Thickness = 1
multiContainerStroke.Parent = multiContainer

-- Scrollable Textbox
local multiInput = Instance.new("TextBox")
multiInput.Size = UDim2.new(1, -16, 1, -16)
multiInput.Position = UDim2.new(0, 8, 0, 8)
multiInput.BackgroundTransparency = 1
multiInput.TextColor3 = COLORS.textLight
multiInput.Text = ""
multiInput.PlaceholderText = "Message 1\nMessage 2\nMessage 3\n..."
multiInput.PlaceholderColor3 = COLORS.textMuted
multiInput.Font = Enum.Font.Gotham
multiInput.TextSize = 13
multiInput.TextWrapped = true
multiInput.MultiLine = true
multiInput.ClearTextOnFocus = false
multiInput.TextYAlignment = Enum.TextYAlignment.Top
multiInput.Parent = multiContainer

-- Line Counter
local multiLineCounter = Instance.new("TextLabel")
multiLineCounter.Size = UDim2.new(1, 0, 0, 18)
multiLineCounter.BackgroundTransparency = 1
multiLineCounter.TextColor3 = COLORS.textMuted
multiLineCounter.Text = "Lines: 0 | Chars: 0/200"
multiLineCounter.Font = Enum.Font.Gotham
multiLineCounter.TextSize = 11
multiLineCounter.TextXAlignment = Enum.TextXAlignment.Right
multiLineCounter.Parent = multiPage

-- Delay Row
local multiDelayRow = Instance.new("Frame")
multiDelayRow.Size = UDim2.new(1, 0, 0, 30)
multiDelayRow.BackgroundTransparency = 1
multiDelayRow.Parent = multiPage

local multiDelayLabel = Instance.new("TextLabel")
multiDelayLabel.Size = UDim2.new(0, 100, 1, 0)
multiDelayLabel.BackgroundTransparency = 1
multiDelayLabel.TextColor3 = COLORS.textLight
multiDelayLabel.Text = "Delay (sec):"
multiDelayLabel.Font = Enum.Font.Gotham
multiDelayLabel.TextSize = 12
multiDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
multiDelayLabel.Parent = multiDelayRow

local multiDelayInput = Instance.new("TextBox")
multiDelayInput.Size = UDim2.new(0, 60, 1, 0)
multiDelayInput.Position = UDim2.new(0, 105, 0, 0)
multiDelayInput.BackgroundColor3 = COLORS.inputBg
multiDelayInput.TextColor3 = COLORS.textLight
multiDelayInput.Text = "0.5"
multiDelay.Font = Enum.Font.Gotham
multiDelayInput.TextSize = 12
multiDelayInput.ClearTextOnFocus = false
multiDelayInput.Parent = multiDelayRow

local multiDelayCorner = Instance.new("UICorner")
multiDelayCorner.CornerRadius = UDim.new(0, 6)
multiDelayCorner.Parent = multiDelayInput

local multiDelayStroke = Instance.new("UIStroke")
multiDelayStroke.Color = COLORS.border
multiDelayStroke.Thickness = 1
multiDelayStroke.Parent = multiDelayInput

-- Status
local multiStatus = Instance.new("TextLabel")
multiStatus.Size = UDim2.new(1, 0, 0, 18)
multiStatus.BackgroundTransparency = 1
multiStatus.TextColor3 = COLORS.textMuted
multiStatus.Text = "Ready"
multiStatus.Font = Enum.Font.Gotham
multiStatus.TextSize = 11
multiStatus.TextXAlignment = Enum.TextXAlignment.Left
multiStatus.Parent = multiPage

-- Send Button
local multiSendBtn = Instance.new("TextButton")
multiSendBtn.Size = UDim2.new(1, 0, 0, 40)
multiSendBtn.BackgroundColor3 = COLORS.buttonPrimary
multiSendBtn.TextColor3 = COLORS.textLight
multiSendBtn.Text = "📤 Send All Messages"
multiSendBtn.Font = Enum.Font.GothamBold
multiSendBtn.TextSize = 14
multiSendBtn.Parent = multiPage

local multiSendBtnCorner = Instance.new("UICorner")
multiSendBtnCorner.CornerRadius = UDim.new(0, 8)
multiSendBtnCorner.Parent = multiSendBtn

-- Multi-Line Functions
local function countLines(text)
    if not text or text == "" then return 0 end
    local count = 1
    for _ in text:gmatch("\n") do
        count = count + 1
    end
    return count
end

local function getLines(text)
    local lines = {}
    for line in text:gmatch("[^\n]+") do
        if line and line:match("%S") then -- Only non-empty lines
            table.insert(lines, line)
        end
    end
    return lines
end

local function updateMultiCounter()
    local text = multiInput.Text
    local lineCount = countLines(text)
    local charCount = #text
    multiLineCounter.Text = "Lines: "..lineCount.." | Chars: "..charCount.."/200"
    
    if charCount > 200 then
        multiLineCounter.TextColor3 = COLORS.buttonDanger
    else
        multiLineCounter.TextColor3 = COLORS.textMuted
    end
end

-- Character counter
multiInput:GetPropertyChangedSignal("Text"):Connect(updateMultiCounter)

-- Send all messages
multiSendBtn.MouseButton1Click:Connect(function()
    local text = multiInput.Text
    if not text or text == "" then return end
    
    local lines = getLines(text)
    if #lines == 0 then return end
    
    local delay = tonumber(multiDelayInput.Text) or 0.5
    if delay < 0.1 then delay = 0.1 end
    
    multiSendBtn.Text = "Sending..."
    multiSendBtn.BackgroundColor3 = COLORS.buttonWarning
    multiStatus.Text = "Sending "..#lines.." messages..."
    
    spawn(function()
        for i, line in ipairs(lines) do
            if line and line ~= "" then
                sendMessage(line)
                multiStatus.Text = "Sent "..i.."/"..#lines
                if i < #lines then
                    wait(delay)
                end
            end
        end
        
        multiStatus.Text = "Done! Sent "..#lines.." messages"
        multiSendBtn.Text = "📤 Send All Messages"
        multiSendBtn.BackgroundColor3 = COLORS.buttonPrimary
        
        -- Clear after sending
        multiInput.Text = ""
        updateMultiCounter()
    end)
end)

-- Update canvas size
multiLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    multiPage.CanvasSize = UDim2.new(0, 0, 0, multiLayout.AbsoluteContentSize.Y + 10)
end)
-- Chat Hub Script (Part 4 - Spam Tab)

-- ========== SPAM TAB ==========

local spamPage = tabPages["Spam"]

local spamLayout = Instance.new("UIListLayout")
spamLayout.Padding = UDim.new(0, 8)
spamLayout.Parent = spamPage

-- Spam Messages Storage
local spamMessages = {}
local spamRunning = false

-- Description
local spamDesc = Instance.new("TextLabel")
spamDesc.Size = UDim2.new(1, 0, 0, 20)
spamDesc.BackgroundTransparency = 1
spamDesc.TextColor3 = COLORS.textMuted
spamDesc.Text = "Add premade messages to spam (loops forever)"
spamDesc.Font = Enum.Font.Gotham
spamDesc.TextSize = 11
spamDesc.TextXAlignment = Enum.TextXAlignment.Left
spamDesc.Parent = spamPage

-- Add Message Row
local addRow = Instance.new("Frame")
addRow.Size = UDim2.new(1, 0, 0, 30)
addRow.BackgroundTransparency = 1
addRow.Parent = spamPage

local spamAddInput = Instance.new("TextBox")
spamAddInput.Size = UDim2.new(1, -70, 1, 0)
spamAddInput.BackgroundColor3 = COLORS.inputBg
spamAddInput.TextColor3 = COLORS.textLight
spamAddInput.Text = ""
spamAddInput.PlaceholderText = "Add new message..."
spamAddInput.PlaceholderColor3 = COLORS.textMuted
spamAddInput.Font = Enum.Font.Gotham
spamAddInput.TextSize = 12
spamAddInput.ClearTextOnFocus = false
spamAddInput.Parent = addRow

local spamAddInputCorner = Instance.new("UICorner")
spamAddInputCorner.CornerRadius = UDim.new(0, 6)
spamAddInputCorner.Parent = spamAddInput

local spamAddInputStroke = Instance.new("UIStroke")
spamAddInputStroke.Color = COLORS.border
spamAddInputStroke.Thickness = 1
spamAddInputStroke.Parent = spamAddInput

local spamAddBtn = Instance.new("TextButton")
spamAddBtn.Size = UDim2.new(0, 60, 1, 0)
spamAddBtn.Position = UDim2.new(1, -65, 0, 0)
spamAddBtn.BackgroundColor3 = COLORS.buttonSuccess
spamAddBtn.TextColor3 = COLORS.textLight
spamAddBtn.Text = "+ Add"
spamAddBtn.Font = Enum.Font.GothamBold
spamAddBtn.TextSize = 11
spamAddBtn.Parent = addRow

local spamAddBtnCorner = Instance.new("UICorner")
spamAddBtnCorner.CornerRadius = UDim.new(0, 6)
spamAddBtnCorner.Parent = spamAddBtn

-- Character Counter for Add
local spamAddCounter = Instance.new("TextLabel")
spamAddCounter.Size = UDim2.new(1, 0, 0, 16)
spamAddCounter.BackgroundTransparency = 1
spamAddCounter.TextColor3 = COLORS.textMuted
spamAddCounter.Text = "0/200"
spamAddCounter.Font = Enum.Font.Gotham
spamAddCounter.TextSize = 10
spamAddCounter.TextXAlignment = Enum.TextXAlignment.Right
spamAddCounter.Parent = spamPage

-- Messages List Label
local spamListLabel = Instance.new("TextLabel")
spamListLabel.Size = UDim2.new(1, 0, 0, 20)
spamListLabel.BackgroundTransparency = 1
spamListLabel.TextColor3 = COLORS.textLight
spamListLabel.Text = "Saved Messages:"
spamListLabel.Font = Enum.Font.GothamBold
spamListLabel.TextSize = 12
spamListLabel.TextXAlignment = Enum.TextXAlignment.Left
spamListLabel.Parent = spamPage

-- Messages Container
local spamListContainer = Instance.new("Frame")
spamListContainer.Size = UDim2.new(1, 0, 0, 120)
spamListContainer.BackgroundColor3 = COLORS.cardBg
spamListContainer.Parent = spamPage

local spamListContainerCorner = Instance.new("UICorner")
spamListContainerCorner.CornerRadius = UDim.new(0, 8)
spamListContainerCorner.Parent = spamListContainer

local spamListContainerStroke = Instance.new("UIStroke")
spamListContainerStroke.Color = COLORS.border
spamListContainerStroke.Thickness = 1
spamListContainerStroke.Parent = spamListContainer

-- Messages ScrollingFrame
local spamScroll = Instance.new("ScrollingFrame")
spamScroll.Size = UDim2.new(1, -16, 1, -16)
spamScroll.Position = UDim2.new(0, 8, 0, 8)
spamScroll.BackgroundTransparency = 1
spamScroll.ScrollBarThickness = 4
spamScroll.ScrollBarImageColor3 = COLORS.buttonPrimary
spamScroll.Parent = spamListContainer

local spamScrollLayout = Instance.new("UIListLayout")
spamScrollLayout.Padding = UDim.new(0, 4)
spamScrollLayout.Parent = spamScroll

-- Delay Row
local spamDelayRow = Instance.new("Frame")
spamDelayRow.Size = UDim2.new(1, 0, 0, 30)
spamDelayRow.BackgroundTransparency = 1
spamDelayRow.Parent = spamPage

local spamDelayLabel = Instance.new("TextLabel")
spamDelayLabel.Size = UDim2.new(0, 100, 1, 0)
spamDelayLabel.BackgroundTransparency = 1
spamDelayLabel.TextColor3 = COLORS.textLight
spamDelayLabel.Text = "Delay (sec):"
spamDelayLabel.Font = Enum.Font.Gotham
spamDelayLabel.TextSize = 12
spamDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
spamDelayLabel.Parent = spamDelayRow

local spamDelayInput = Instance.new("TextBox")
spamDelayInput.Size = UDim2.new(0, 60, 1, 0)
spamDelayInput.Position = UDim2.new(0, 105, 0, 0)
spamDelayInput.BackgroundColor3 = COLORS.inputBg
spamDelayInput.TextColor3 = COLORS.textLight
spamDelayInput.Text = "1.0"
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

-- Message Count
local spamCountLabel = Instance.new("TextLabel")
spamCountLabel.Size = UDim2.new(0, 100, 1, 0)
spamCountLabel.Position = UDim2.new(1, -100, 0, 0)
spamCountLabel.BackgroundTransparency = 1
spamCountLabel.TextColor3 = COLORS.textMuted
spamCountLabel.Text = "Messages: 0"
spamCountLabel.Font = Enum.Font.Gotham
spamCountLabel.TextSize = 11
spamCountLabel.TextXAlignment = Enum.TextXAlignment.Right
spamCountLabel.Parent = spamDelayRow

-- Status
local spamStatus = Instance.new("TextLabel")
spamStatus.Size = UDim2.new(1, 0, 0, 18)
spamStatus.BackgroundTransparency = 1
spamStatus.TextColor3 = COLORS.textMuted
spamStatus.Text = "Ready"
spamStatus.Font = Enum.Font.Gotham
spamStatus.TextSize = 11
spamStatus.TextXAlignment = Enum.TextXAlignment.Left
spamStatus.Parent = spamPage

-- Toggle Button
local spamToggle = Instance.new("TextButton")
spamToggle.Size = UDim2.new(1, 0, 0, 40)
spamToggle.BackgroundColor3 = COLORS.buttonDanger
spamToggle.TextColor3 = COLORS.textLight
spamToggle.Text = "🔄 SPAM: OFF"
spamToggle.Font = Enum.Font.GothamBold
spamToggle.TextSize = 14
spamToggle.Parent = spamPage

local spamToggleCorner = Instance.new("UICorner")
spamToggleCorner.CornerRadius = UDim.new(0, 8)
spamToggleCorner.Parent = spamToggle

-- Spam Functions
local messageButtons = {}

local function updateSpamList()
    -- Clear existing
    for _, btn in pairs(messageButtons) do
        btn:Destroy()
    end
    messageButtons = {}
    
    -- Create new
    for i, msg in ipairs(spamMessages) do
        local msgFrame = Instance.new("Frame")
        msgFrame.Size = UDim2.new(1, 0, 0, 28)
        msgFrame.BackgroundColor3 = COLORS.inputBg
        msgFrame.Parent = spamScroll
        
        local msgFrameCorner = Instance.new("UICorner")
        msgFrameCorner.CornerRadius = UDim.new(0, 5)
        msgFrameCorner.Parent = msgFrame
        
        local msgText = Instance.new("TextLabel")
        msgText.Size = UDim2.new(1, -35, 1, 0)
        msgText.BackgroundTransparency = 1
        msgText.TextColor3 = COLORS.textLight
        msgText.Text = msg
        msgText.Font = Enum.Font.Gotham
        msgText.TextSize = 11
        msgText.TextXAlignment = Enum.TextXAlignment.Left
        msgText.TextTruncate = Enum.TextTruncate.AtEnd
        msgText.Parent = msgFrame
        
        local removeBtn = Instance.new("TextButton")
        removeBtn.Size = UDim2.new(0, 25, 1, 0)
        removeBtn.Position = UDim2.new(1, -27, 0, 0)
        removeBtn.BackgroundColor3 = COLORS.buttonDanger
        removeBtn.TextColor3 = COLORS.textLight
        removeBtn.Text = "✕"
        removeBtn.Font = Enum.Font.GothamBold
        removeBtn.TextSize = 10
        removeBtn.Parent = msgFrame
        
        local removeBtnCorner = Instance.new("UICorner")
        removeBtnCorner.CornerRadius = UDim.new(0, 5)
        removeBtnCorner.Parent = removeBtn
        
        removeBtn.MouseButton1Click:Connect(function()
            table.remove(spamMessages, i)
            updateSpamList()
            spamCountLabel.Text = "Messages: "..#spamMessages
        end)
        
        table.insert(messageButtons, msgFrame)
    end
    
    spamScroll.CanvasSize = UDim2.new(0, 0, 0, #spamMessages * 32)
end

-- Character counter for add input
spamAddInput:GetPropertyChangedSignal("Text"):Connect(function()
    local len = #spamAddInput.Text
    spamAddCounter.Text = len.."/200"
    if len > 200 then
        spamAddCounter.TextColor3 = COLORS.buttonDanger
    else
        spamAddCounter.TextColor3 = COLORS.textMuted
    end
end)

-- Add message
spamAddBtn.MouseButton1Click:Connect(function()
    local text = spamAddInput.Text
    if text and text ~= "" and #text <= 200 then
        table.insert(spamMessages, text)
        spamAddInput.Text = ""
        spamAddCounter.Text = "0/200"
        updateSpamList()
        spamCountLabel.Text = "Messages: "..#spamMessages
    end
end)

-- Also add on Enter
spamAddInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        spamAddBtn.MouseButton1Click:Fire()
    end
end)

-- Toggle spam
spamToggle.MouseButton1Click:Connect(function()
    spamRunning = not spamRunning
    
    if spamRunning then
        if #spamMessages == 0 then
            spamStatus.Text = "Error: No messages to spam!"
            spamRunning = false
            return
        end
        
        spamToggle.Text = "🔄 SPAM: ON"
        spamToggle.BackgroundColor3 = COLORS.buttonSuccess
        spamStatus.Text = "Spamming..."
        
        local delay = tonumber(spamDelayInput.Text) or 1.0
        if delay < 0.1 then delay = 0.1 end
        
        spawn(function()
            local index = 1
            while spamRunning do
                if #spamMessages > 0 then
                    sendMessage(spamMessages[index])
                    spamStatus.Text = "Spamming: "..index.."/"..#spamMessages
                    index = index + 1
                    if index > #spamMessages then
                        index = 1
                    end
                end
                wait(delay)
            end
        end)
    else
        spamToggle.Text = "🔄 SPAM: OFF"
        spamToggle.BackgroundColor3 = COLORS.buttonDanger
        spamStatus.Text = "Stopped"
    end
end)

-- Update canvas size
spamLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    spamPage.CanvasSize = UDim2.new(0, 0, 0, spamLayout.AbsoluteContentSize.Y + 10)
end)
-- Chat Hub Script (Part 5 - Prefix/Emoji Tab)

-- ========== PREFIX TAB ==========

local prefixPage = tabPages["Prefix"]

local prefixLayout = Instance.new("UIListLayout")
prefixLayout.Padding = UDim.new(0, 8)
prefixLayout.Parent = prefixPage

-- Description
local prefixDesc = Instance.new("TextLabel")
prefixDesc.Size = UDim2.new(1, 0, 0, 20)
prefixDesc.BackgroundTransparency = 1
prefixDesc.TextColor3 = COLORS.textMuted
prefixDesc.Text = "Add prefix/emojis before every message"
prefixDesc.Font = Enum.Font.Gotham
prefixDesc.TextSize = 11
prefixDesc.TextXAlignment = Enum.TextXAlignment.Left
prefixDesc.Parent = prefixPage

-- Toggle
local prefixToggle = Instance.new("TextButton")
prefixToggle.Size = UDim2.new(1, 0, 0, 40)
prefixToggle.BackgroundColor3 = COLORS.buttonDanger
prefixToggle.TextColor3 = COLORS.textLight
prefixToggle.Text = "PREFIX: OFF"
prefixToggle.Font = Enum.Font.GothamBold
prefixToggle.TextSize = 14
prefixToggle.Parent = prefixPage

local prefixToggleCorner = Instance.new("UICorner")
prefixToggleCorner.CornerRadius = UDim.new(0, 8)
prefixToggleCorner.Parent = prefixToggle

-- Mode Selection Label
local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, 0, 0, 20)
modeLabel.BackgroundTransparency = 1
modeLabel.TextColor3 = COLORS.textLight
modeLabel.Text = "Mode:"
modeLabel.Font = Enum.Font.GothamBold
modeLabel.TextSize = 12
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = prefixPage

-- Mode Buttons Row
local modeRow = Instance.new("Frame")
modeRow.Size = UDim2.new(1, 0, 0, 35)
modeRow.BackgroundTransparency = 1
modeRow.Parent = prefixPage

local fixedBtn = Instance.new("TextButton")
fixedBtn.Size = UDim2.new(0.5, -4, 1, 0)
fixedBtn.Position = UDim2.new(0, 0, 0, 0)
fixedBtn.BackgroundColor3 = COLORS.buttonPrimary
fixedBtn.TextColor3 = COLORS.textLight
fixedBtn.Text = "📌 Fixed"
fixedBtn.Font = Enum.Font.GothamBold
fixedBtn.TextSize = 12
fixedBtn.Parent = modeRow

local fixedBtnCorner = Instance.new("UICorner")
fixedBtnCorner.CornerRadius = UDim.new(0, 8)
fixedBtnCorner.Parent = fixedBtn

local rotateBtn = Instance.new("TextButton")
rotateBtn.Size = UDim2.new(0.5, -4, 1, 0)
rotateBtn.Position = UDim2.new(0.5, 4, 0, 0)
rotateBtn.BackgroundColor3 = COLORS.buttonDark
rotateBtn.TextColor3 = COLORS.textMuted
rotateBtn.Text = "🔄 Rotate"
rotateBtn.Font = Enum.Font.GothamBold
rotateBtn.TextSize = 12
rotateBtn.Parent = modeRow

local rotateBtnCorner = Instance.new("UICorner")
rotateBtnCorner.CornerRadius = UDim.new(0, 8)
rotateBtnCorner.Parent = rotateBtn

-- Mode Description
local modeDesc = Instance.new("TextLabel")
modeDesc.Size = UDim2.new(1, 0, 0, 35)
modeDesc.BackgroundTransparency = 1
modeDesc.TextColor3 = COLORS.textMuted
modeDesc.Text = "Fixed: All emojis together\n\"💀🔥😈 message\""
modeDesc.Font = Enum.Font.Gotham
modeDesc.TextSize = 10
modeDesc.TextXAlignment = Enum.TextXAlignment.Left
modeDesc.TextWrapped = true
modeDesc.Parent = prefixPage

-- Add Prefix Row
local addPrefixRow = Instance.new("Frame")
addPrefixRow.Size = UDim2.new(1, 0, 0, 30)
addPrefixRow.BackgroundTransparency = 1
addPrefixRow.Parent = prefixPage

local prefixAddInput = Instance.new("TextBox")
prefixAddInput.Size = UDim2.new(1, -70, 1, 0)
prefixAddInput.BackgroundColor3 = COLORS.inputBg
prefixAddInput.TextColor3 = COLORS.textLight
prefixAddInput.Text = ""
prefixAddInput.PlaceholderText = "Add emoji/prefix..."
prefixAddInput.PlaceholderColor3 = COLORS.textMuted
prefixAddInput.Font = Enum.Font.Gotham
prefixAddInput.TextSize = 12
prefixAddInput.ClearTextOnFocus = false
prefixAddInput.Parent = addPrefixRow

local prefixAddInputCorner = Instance.new("UICorner")
prefixAddInputCorner.CornerRadius = UDim.new(0, 6)
prefixAddInputCorner.Parent = prefixAddInput

local prefixAddInputStroke = Instance.new("UIStroke")
prefixAddInputStroke.Color = COLORS.border
prefixAddInputStroke.Thickness = 1
prefixAddInputStroke.Parent = prefixAddInput

local prefixAddBtn = Instance.new("TextButton")
prefixAddBtn.Size = UDim2.new(0, 60, 1, 0)
prefixAddBtn.Position = UDim2.new(1, -65, 0, 0)
prefixAddBtn.BackgroundColor3 = COLORS.buttonSuccess
prefixAddBtn.TextColor3 = COLORS.textLight
prefixAddBtn.Text = "+ Add"
prefixAddBtn.Font = Enum.Font.GothamBold
prefixAddBtn.TextSize = 11
prefixAddBtn.Parent = addPrefixRow

local prefixAddBtnCorner = Instance.new("UICorner")
prefixAddBtnCorner.CornerRadius = UDim.new(0, 6)
prefixAddBtnCorner.Parent = prefixAddBtn

-- Prefix List Label
local prefixListLabel = Instance.new("TextLabel")
prefixListLabel.Size = UDim2.new(1, 0, 0, 20)
prefixListLabel.BackgroundTransparency = 1
prefixListLabel.TextColor3 = COLORS.textLight
prefixListLabel.Text = "Saved Prefixes:"
prefixListLabel.Font = Enum.Font.GothamBold
prefixListLabel.TextSize = 12
prefixListLabel.TextXAlignment = Enum.TextXAlignment.Left
prefixListLabel.Parent = prefixPage

-- Prefix Container
local prefixListContainer = Instance.new("Frame")
prefixListContainer.Size = UDim2.new(1, 0, 0, 100)
prefixListContainer.BackgroundColor3 = COLORS.cardBg
prefixListContainer.Parent = prefixPage

local prefixListContainerCorner = Instance.new("UICorner")
prefixListContainerCorner.CornerRadius = UDim.new(0, 8)
prefixListContainerCorner.Parent = prefixListContainer

local prefixListContainerStroke = Instance.new("UIStroke")
prefixListContainerStroke.Color = COLORS.border
prefixListContainerStroke.Thickness = 1
prefixListContainerStroke.Parent = prefixListContainer

-- Prefix ScrollingFrame
local prefixScroll = Instance.new("ScrollingFrame")
prefixScroll.Size = UDim2.new(1, -16, 1, -16)
prefixScroll.Position = UDim2.new(0, 8, 0, 8)
prefixScroll.BackgroundTransparency = 1
prefixScroll.ScrollBarThickness = 4
prefixScroll.ScrollBarImageColor3 = COLORS.buttonPrimary
prefixScroll.Parent = prefixListContainer

local prefixScrollLayout = Instance.new("UIListLayout")
prefixScrollLayout.Padding = UDim.new(0, 4)
prefixScrollLayout.Parent = prefixScroll

-- Preview
local prefixPreview = Instance.new("TextLabel")
prefixPreview.Size = UDim2.new(1, 0, 0, 35)
prefixPreview.BackgroundTransparency = 1
prefixPreview.TextColor3 = COLORS.textMuted
prefixPreview.Text = "Preview: [emojis] Your message"
prefixPreview.Font = Enum.Font.Gotham
prefixPreview.TextSize = 11
prefixPreview.TextXAlignment = Enum.TextXAlignment.Left
prefixPreview.TextWrapped = true
prefixPreview.Parent = prefixPage

-- Prefix Functions
local prefixButtons = {}

local function updatePrefixPreview()
    if #prefixEmojis == 0 then
        prefixPreview.Text = "Preview: (no prefix) Your message"
    elseif prefixMode == "Fixed" then
        local combined = table.concat(prefixEmojis, "")
        prefixPreview.Text = "Preview: "..combined.." Your message"
    else
        if currentEmojiIndex > #prefixEmojis then currentEmojiIndex = 1 end
        local current = prefixEmojis[currentEmojiIndex] or ""
        prefixPreview.Text = "Preview: "..current.." Your message (rotating)"
    end
end

local function updatePrefixList()
    -- Clear existing
    for _, btn in pairs(prefixButtons) do
        btn:Destroy()
    end
    prefixButtons = {}
    
    -- Create new
    for i, prefix in ipairs(prefixEmojis) do
        local prefixFrame = Instance.new("Frame")
        prefixFrame.Size = UDim2.new(1, 0, 0, 28)
        prefixFrame.BackgroundColor3 = COLORS.inputBg
        prefixFrame.Parent = prefixScroll
        
        local prefixFrameCorner = Instance.new("UICorner")
        prefixFrameCorner.CornerRadius = UDim.new(0, 5)
        prefixFrameCorner.Parent = prefixFrame
        
        local prefixText = Instance.new("TextLabel")
        prefixText.Size = UDim2.new(1, -35, 1, 0)
        prefixText.BackgroundTransparency = 1
        prefixText.TextColor3 = COLORS.textLight
        prefixText.Text = prefix
        prefixText.Font = Enum.Font.Gotham
        prefixText.TextSize = 12
        prefixText.TextXAlignment = Enum.TextXAlignment.Left
        prefixText.TextTruncate = Enum.TextTruncate.AtEnd
        prefixText.Parent = prefixFrame
        
        local removeBtn = Instance.new("TextButton")
        removeBtn.Size = UDim2.new(0, 25, 1, 0)
        removeBtn.Position = UDim2.new(1, -27, 0, 0)
        removeBtn.BackgroundColor3 = COLORS.buttonDanger
        removeBtn.TextColor3 = COLORS.textLight
        removeBtn.Text = "✕"
        removeBtn.Font = Enum.Font.GothamBold
        removeBtn.TextSize = 10
        removeBtn.Parent = prefixFrame
        
        local removeBtnCorner = Instance.new("UICorner")
        removeBtnCorner.CornerRadius = UDim.new(0, 5)
        removeBtnCorner.Parent = removeBtn
        
        removeBtn.MouseButton1Click:Connect(function()
            table.remove(prefixEmojis, i)
            if currentEmojiIndex > #prefixEmojis then
                currentEmojiIndex = 1
            end
            updatePrefixList()
            updatePrefixPreview()
        end)
        
        table.insert(prefixButtons, prefixFrame)
    end
    
    prefixScroll.CanvasSize = UDim2.new(0, 0, 0, #prefixEmojis * 32)
    updatePrefixPreview()
end

-- Toggle prefix
prefixToggle.MouseButton1Click:Connect(function()
    prefixEnabled = not prefixEnabled
    
    if prefixEnabled then
        prefixToggle.Text = "PREFIX: ON"
        prefixToggle.BackgroundColor3 = COLORS.buttonSuccess
    else
        prefixToggle.Text = "PREFIX: OFF"
        prefixToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

-- Mode buttons
fixedBtn.MouseButton1Click:Connect(function()
    prefixMode = "Fixed"
    fixedBtn.BackgroundColor3 = COLORS.buttonPrimary
    fixedBtn.TextColor3 = COLORS.textLight
    rotateBtn.BackgroundColor3 = COLORS.buttonDark
    rotateBtn.TextColor3 = COLORS.textMuted
    modeDesc.Text = "Fixed: All emojis together\n\"💀🔥😈 message\""
    updatePrefixPreview()
end)

rotateBtn.MouseButton1Click:Connect(function()
    prefixMode = "Rotate"
    rotateBtn.BackgroundColor3 = COLORS.buttonPrimary
    rotateBtn.TextColor3 = COLORS.textLight
    fixedBtn.BackgroundColor3 = COLORS.buttonDark
    fixedBtn.TextColor3 = COLORS.textMuted
    modeDesc.Text = "Rotate: Cycle through emojis\n\"💀 msg\" then \"🔥 msg\"..."
    updatePrefixPreview()
end)

-- Add prefix
prefixAddBtn.MouseButton1Click:Connect(function()
    local text = prefixAddInput.Text
    if text and text ~= "" then
        table.insert(prefixEmojis, text)
        prefixAddInput.Text = ""
        updatePrefixList()
    end
end)

prefixAddInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        prefixAddBtn.MouseButton1Click:Fire()
    end
end)

-- Update canvas size
prefixLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    prefixPage.CanvasSize = UDim2.new(0, 0, 0, prefixLayout.AbsoluteContentSize.Y + 10)
end)

-- Initialize
updatePrefixList()
-- Chat Hub Script (Full Version)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local hubWidth = 280
local hubHeight = 400

-- Prefix Settings
local prefixEnabled = false
local prefixMode = "Fixed"
local prefixEmojis = {"💀", "🔥", "😈"}
local currentEmojiIndex = 1

-- Tab states
local expandedTab = nil

-- Colors (Dark Theme)
local COLORS = {
    background = Color3.fromRGB(30, 30, 35),
    header = Color3.fromRGB(40, 40, 45),
    buttonPrimary = Color3.fromRGB(0, 120, 215),
    buttonDanger = Color3.fromRGB(220, 53, 69),
    buttonSuccess = Color3.fromRGB(40, 167, 69),
    buttonWarning = Color3.fromRGB(255, 193, 7),
    buttonPurple = Color3.fromRGB(111, 66, 193),
    buttonDark = Color3.fromRGB(50, 50, 55),
    textDark = Color3.fromRGB(33, 37, 41),
    textLight = Color3.fromRGB(255, 255, 255),
    textMuted = Color3.fromRGB(150, 150, 150),
    inputBg = Color3.fromRGB(45, 45, 50),
    border = Color3.fromRGB(60, 60, 65),
    cardBg = Color3.fromRGB(35, 35, 40)
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========== HUB BUTTON ==========

local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 50, 0, 50)
hubButton.Position = UDim2.new(0, 20, 0.5, -25)
hubButton.BackgroundColor3 = COLORS.cardBg
hubButton.BorderSizePixel = 0
hubButton.Visible = true
hubButton.Parent = screenGui

local hubButtonCorner = Instance.new("UICorner")
hubButtonCorner.CornerRadius = UDim.new(0, 10)
hubButtonCorner.Parent = hubButton

local hubButtonShadow = Instance.new("UIStroke")
hubButtonShadow.Color = COLORS.border
hubButtonShadow.Thickness = 1
hubButtonShadow.Parent = hubButton

local hubButtonIcon = Instance.new("TextLabel")
hubButtonIcon.Size = UDim2.new(1, 0, 1, 0)
hubButtonIcon.BackgroundTransparency = 1
hubButtonIcon.TextColor3 = COLORS.textLight
hubButtonIcon.Text = "💬"
hubButtonIcon.Font = Enum.Font.GothamBold
hubButtonIcon.TextSize = 22
hubButtonIcon.Parent = hubButton

-- ========== MAIN FRAME ==========

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, hubWidth, 0, hubHeight)
mainFrame.Position = UDim2.new(0.5, -hubWidth/2, 0.5, -hubHeight/2)
mainFrame.BackgroundColor3 = COLORS.background
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 14)
mainFrameCorner.Parent = mainFrame

local mainFrameShadow = Instance.new("UIStroke")
mainFrameShadow.Color = Color3.fromRGB(20, 20, 25)
mainFrameShadow.Thickness = 2
mainFrameShadow.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = COLORS.header
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 14)
titleBarCorner.Parent = titleBar

local titleBarFix = Instance.new("Frame")
titleBarFix.Size = UDim2.new(1, 0, 0, 14)
titleBarFix.Position = UDim2.new(0, 0, 1, -14)
titleBarFix.BackgroundColor3 = COLORS.header
titleBarFix.BorderSizePixel = 0
titleBarFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = COLORS.textLight
titleLabel.Text = "💬 Chat Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 30, 0, 24)
collapseButton.Position = UDim2.new(1, -38, 0.5, -12)
collapseButton.BackgroundColor3 = COLORS.buttonDanger
collapseButton.TextColor3 = COLORS.textLight
collapseButton.Text = "✕"
collapseButton.Font = Enum.Font.GothamBold
collapseButton.TextSize = 12
collapseButton.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseButton

-- ========== TAB BAR ==========

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 35)
tabBar.Position = UDim2.new(0, 0, 0, 40)
tabBar.BackgroundColor3 = COLORS.cardBg
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

local tabBarFix = Instance.new("Frame")
tabBarFix.Size = UDim2.new(1, 0, 0, 14)
tabBarFix.Position = UDim2.new(0, 0, 1, -14)
tabBarFix.BackgroundColor3 = COLORS.cardBg
tabBarFix.BorderSizePixel = 0
tabBarFix.Parent = tabBar

-- Tab Buttons
local tabButtons = {}
local tabNames = {"Quick", "Multi", "Spam", "Prefix", "Settings"}
local tabIcons = {"⚡", "📝", "🔄", "😀", "⚙️"}

for i, name in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1/#tabNames, -4, 1, 0)
    tabBtn.Position = UDim2.new((i-1)/#tabNames, 2, 0, 0)
    tabBtn.BackgroundColor3 = COLORS.buttonDark
    tabBtn.TextColor3 = COLORS.textMuted
    tabBtn.Text = tabIcons[i]
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 14
    tabBtn.Parent = tabBar
    
    local tabBtnCorner = Instance.new("UICorner")
    tabBtnCorner.CornerRadius = UDim.new(0, 6)
    tabBtnCorner.Parent = tabBtn
    
    tabButtons[name] = tabBtn
end

-- ========== CONTENT AREA ==========

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -20, 1, -85)
contentArea.Position = UDim2.new(0, 10, 0, 75)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- Tab Pages
local tabPages = {}
for _, name in ipairs(tabNames) do
    local page = Instance.new("ScrollingFrame")
    page.Name = name.."Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = COLORS.buttonPrimary
    page.Visible = false
    page.Parent = contentArea
    
    tabPages[name] = page
end

-- ========== HELPER FUNCTIONS ==========

local function sendMessage(text)
    if not text or text == "" then return end
    
    -- Apply prefix if enabled
    local finalText = text
    if prefixEnabled and #prefixEmojis > 0 then
        if prefixMode == "Fixed" then
            finalText = table.concat(prefixEmojis, "") .. " " .. text
        else
            local emoji = prefixEmojis[currentEmojiIndex]
            finalText = emoji .. " " .. text
            currentEmojiIndex = currentEmojiIndex + 1
            if currentEmojiIndex > #prefixEmojis then
                currentEmojiIndex = 1
            end
        end
    end
    
    -- Send via TextChatService (new Roblox chat)
    local TextChannel = TextChatService:FindFirstChild("TextChannels")
    if TextChannel then
        local RBXGeneral = TextChannel:FindFirstChild("RBXGeneral")
        if RBXGeneral then
            RBXGeneral:SendAsync(finalText)
        end
    end
    
    -- Fallback: Legacy chat
    local ChatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if ChatRemote then
        local SayMessageRequest = ChatRemote:FindFirstChild("SayMessageRequest")
        if SayMessageRequest then
            SayMessageRequest:FireServer(finalText, "All")
        end
    end
end

local function resizeHub(width, height)
    hubWidth = width
    hubHeight = height
    mainFrame.Size = UDim2.new(0, width, 0, height)
    mainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
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

local hubDragging = false
local hubDragInput, hubDragStart, hubDragPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        hubDragging = true
        hubDragStart = input.Position
        hubDragPos = mainFrame.Position
        
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
        mainFrame.Position = UDim2.new(hubDragPos.X.Scale, hubDragPos.X.Offset + delta.X, hubDragPos.Y.Scale, hubDragPos.Y.Offset + delta.Y)
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

collapseButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

-- ========== TAB SWITCHING ==========

local function setupTabClick(tabName)
    tabButtons[tabName].MouseButton1Click:Connect(function()
        if expandedTab == tabName then
            tabPages[tabName].Visible = false
            tabButtons[tabName].BackgroundColor3 = COLORS.buttonDark
            tabButtons[tabName].TextColor3 = COLORS.textMuted
            expandedTab = nil
        else
            if expandedTab then
                tabPages[expandedTab].Visible = false
                tabButtons[expandedTab].BackgroundColor3 = COLORS.buttonDark
                tabButtons[expandedTab].TextColor3 = COLORS.textMuted
            end
            tabPages[tabName].Visible = true
            tabButtons[tabName].BackgroundColor3 = COLORS.buttonPrimary
            tabButtons[tabName].TextColor3 = COLORS.textLight
            expandedTab = tabName
        end
    end)
end

for _, name in ipairs(tabNames) do
    setupTabClick(name)
end

-- ========== QUICK CHAT TAB ==========

local quickPage = tabPages["Quick"]

local quickLayout = Instance.new("UIListLayout")
quickLayout.Padding = UDim.new(0, 8)
quickLayout.Parent = quickPage

local quickDesc = Instance.new("TextLabel")
quickDesc.Size = UDim2.new(1, 0, 0, 20)
quickDesc.BackgroundTransparency = 1
quickDesc.TextColor3 = COLORS.textMuted
quickDesc.Text = "Quick message - clears on focus"
quickDesc.Font = Enum.Font.Gotham
quickDesc.TextSize = 11
quickDesc.TextXAlignment = Enum.TextXAlignment.Left
quickDesc.Parent = quickPage

local quickInput = Instance.new("TextBox")
quickInput.Size = UDim2.new(1, 0, 0, 80)
quickInput.BackgroundColor3 = COLORS.inputBg
quickInput.TextColor3 = COLORS.textLight
quickInput.Text = ""
quickInput.PlaceholderText = "Type your message..."
quickInput.PlaceholderColor3 = COLORS.textMuted
quickInput.Font = Enum.Font.Gotham
quickInput.TextSize = 13
quickInput.TextWrapped = true
quickInput.MultiLine = true
quickInput.ClearTextOnFocus = false
quickInput.TextYAlignment = Enum.TextYAlignment.Top
quickInput.Parent = quickPage

local quickInputCorner = Instance.new("UICorner")
quickInputCorner.CornerRadius = UDim.new(0, 8)
quickInputCorner.Parent = quickInput

local quickInputStroke = Instance.new("UIStroke")
quickInputStroke.Color = COLORS.border
quickInputStroke.Thickness = 1
quickInputStroke.Parent = quickInput

local quickCounter = Instance.new("TextLabel")
quickCounter.Size = UDim2.new(1, 0, 0, 18)
quickCounter.BackgroundTransparency = 1
quickCounter.TextColor3 = COLORS.textMuted
quickCounter.Text = "0/200"
quickCounter.Font = Enum.Font.Gotham
quickCounter.TextSize = 11
quickCounter.TextXAlignment = Enum.TextXAlignment.Right
quickCounter.Parent = quickPage

local quickSendBtn = Instance.new("TextButton")
quickSendBtn.Size = UDim2.new(1, 0, 0, 40)
quickSendBtn.BackgroundColor3 = COLORS.buttonPrimary
quickSendBtn.TextColor3 = COLORS.textLight
quickSendBtn.Text = "📤 Send Message"
quickSendBtn.Font = Enum.Font.GothamBold
quickSendBtn.TextSize = 14
quickSendBtn.Parent = quickPage

local quickSendBtnCorner = Instance.new("UICorner")
quickSendBtnCorner.CornerRadius = UDim.new(0, 8)
quickSendBtnCorner.Parent = quickSendBtn

local function quickSend()
    local text = quickInput.Text
    if text and text ~= "" then
        sendMessage(text)
        quickInput.Text = ""
        quickCounter.Text = "0/200"
    end
end

quickInput.Focused:Connect(function()
    quickInput.Text = ""
    quickCounter.Text = "0/200"
end)

quickInput:GetPropertyChangedSignal("Text"):Connect(function()
    local len = #quickInput.Text
    quickCounter.Text = len.."/200"
    if len > 200 then
        quickCounter.TextColor3 = COLORS.buttonDanger
    else
        quickCounter.TextColor3 = COLORS.textMuted
    end
end)

quickSendBtn.MouseButton1Click:Connect(quickSend)

quickInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        quickSend()
    end
end)

quickLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    quickPage.CanvasSize = UDim2.new(0, 0, 0, quickLayout.AbsoluteContentSize.Y + 10)
end)

-- ========== MULTI-LINE CHAT TAB ==========

local multiPage = tabPages["Multi"]

local multiLayout = Instance.new("UIListLayout")
multiLayout.Padding = UDim.new(0, 8)
multiLayout.Parent = multiPage

local multiDesc = Instance.new("TextLabel")
multiDesc.Size = UDim2.new(1, 0, 0, 20)
multiDesc.BackgroundTransparency = 1
multiDesc.TextColor3 = COLORS.textMuted
multiDesc.Text = "Each line = separate message | Enter = new line"
multiDesc.Font = Enum.Font.Gotham
multiDesc.TextSize = 11
multiDesc.TextXAlignment = Enum.TextXAlignment.Left
multiDesc.Parent = multiPage

local multiContainer = Instance.new("Frame")
multiContainer.Size = UDim2.new(1, 0, 0, 150)
multiContainer.BackgroundColor3 = COLORS.inputBg
multiContainer.Parent = multiPage

local multiContainerCorner = Instance.new("UICorner")
multiContainerCorner.CornerRadius = UDim.new(0, 8)
multiContainerCorner.Parent = multiContainer

local multiContainerStroke = Instance.new("UIStroke")
multiContainerStroke.Color = COLORS.border
multiContainerStroke.Thickness = 1
multiContainerStroke.Parent = multiContainer

local multiInput = Instance.new("TextBox")
multiInput.Size = UDim2.new(1, -16, 1, -16)
multiInput.Position = UDim2.new(0, 8, 0, 8)
multiInput.BackgroundTransparency = 1
multiInput.TextColor3 = COLORS.textLight
multiInput.Text = ""
multiInput.PlaceholderText = "Message 1\nMessage 2\nMessage 3\n..."
multiInput.PlaceholderColor3 = COLORS.textMuted
multiInput.Font = Enum.Font.Gotham
multiInput.TextSize = 13
multiInput.TextWrapped = true
multiInput.MultiLine = true
multiInput.ClearTextOnFocus = false
multiInput.TextYAlignment = Enum.TextYAlignment.Top
multiInput.Parent = multiContainer

local multiLineCounter = Instance.new("TextLabel")
multiLineCounter.Size = UDim2.new(1, 0, 0, 18)
multiLineCounter.BackgroundTransparency = 1
multiLineCounter.TextColor3 = COLORS.textMuted
multiLineCounter.Text = "Lines: 0 | Chars: 0/200"
multiLineCounter.Font = Enum.Font.Gotham
multiLineCounter.TextSize = 11
multiLineCounter.TextXAlignment = Enum.TextXAlignment.Right
multiLineCounter.Parent = multiPage

local multiDelayRow = Instance.new("Frame")
multiDelayRow.Size = UDim2.new(1, 0, 0, 30)
multiDelayRow.BackgroundTransparency = 1
multiDelayRow.Parent = multiPage

local multiDelayLabel = Instance.new("TextLabel")
multiDelayLabel.Size = UDim2.new(0, 100, 1, 0)
multiDelayLabel.BackgroundTransparency = 1
multiDelayLabel.TextColor3 = COLORS.textLight
multiDelayLabel.Text = "Delay (sec):"
multiDelayLabel.Font = Enum.Font.Gotham
multiDelayLabel.TextSize = 12
multiDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
multiDelayLabel.Parent = multiDelayRow

local multiDelayInput = Instance.new("TextBox")
multiDelayInput.Size = UDim2.new(0, 60, 1, 0)
multiDelayInput.Position = UDim2.new(0, 105, 0, 0)
multiDelayInput.BackgroundColor3 = COLORS.inputBg
multiDelayInput.TextColor3 = COLORS.textLight
multiDelayInput.Text = "0.5"
multiDelayInput.Font = Enum.Font.Gotham
multiDelayInput.TextSize = 12
multiDelayInput.ClearTextOnFocus = false
multiDelayInput.Parent = multiDelayRow

local multiDelayCorner = Instance.new("UICorner")
multiDelayCorner.CornerRadius = UDim.new(0, 6)
multiDelayCorner.Parent = multiDelayInput

local multiDelayStroke = Instance.new("UIStroke")
multiDelayStroke.Color = COLORS.border
multiDelayStroke.Thickness = 1
multiDelayStroke.Parent = multiDelayInput

local multiStatus = Instance.new("TextLabel")
multiStatus.Size = UDim2.new(1, 0, 0, 18)
multiStatus.BackgroundTransparency = 1
multiStatus.TextColor3 = COLORS.textMuted
multiStatus.Text = "Ready"
multiStatus.Font = Enum.Font.Gotham
multiStatus.TextSize = 11
multiStatus.TextXAlignment = Enum.TextXAlignment.Left
multiStatus.Parent = multiPage

local multiSendBtn = Instance.new("TextButton")
multiSendBtn.Size = UDim2.new(1, 0, 0, 40)
multiSendBtn.BackgroundColor3 = COLORS.buttonPrimary
multiSendBtn.TextColor3 = COLORS.textLight
multiSendBtn.Text = "📤 Send All Messages"
multiSendBtn.Font = Enum.Font.GothamBold
multiSendBtn.TextSize = 14
multiSendBtn.Parent = multiPage

local multiSendBtnCorner = Instance.new("UICorner")
multiSendBtnCorner.CornerRadius = UDim.new(0, 8)
multiSendBtnCorner.Parent = multiSendBtn

local function countLines(text)
    if not text or text == "" then return 0 end
    local count = 1
    for _ in text:gmatch("\n") do
        count = count + 1
    end
    return count
end

local function getLines(text)
    local lines = {}
    for line in text:gmatch("[^\n]+") do
        if line and line:match("%S") then
            table.insert(lines, line)
        end
    end
    return lines
end

local function updateMultiCounter()
    local text = multiInput.Text
    local lineCount = countLines(text)
    local charCount = #text
    multiLineCounter.Text = "Lines: "..lineCount.." | Chars: "..charCount.."/200"
    
    if charCount > 200 then
        multiLineCounter.TextColor3 = COLORS.buttonDanger
    else
        multiLineCounter.TextColor3 = COLORS.textMuted
    end
end

multiInput:GetPropertyChangedSignal("Text"):Connect(updateMultiCounter)

multiSendBtn.MouseButton1Click:Connect(function()
    local text = multiInput.Text
    if not text or text == "" then return end
    
    local lines = getLines(text)
    if #lines == 0 then return end
    
    local delay = tonumber(multiDelayInput.Text) or 0.5
    if delay < 0.1 then delay = 0.1 end
    
    multiSendBtn.Text = "Sending..."
    multiSendBtn.BackgroundColor3 = COLORS.buttonWarning
    multiStatus.Text = "Sending "..#lines.." messages..."
    
    spawn(function()
        for i, line in ipairs(lines) do
            if line and line ~= "" then
                sendMessage(line)
                multiStatus.Text = "Sent "..i.."/"..#lines
                if i < #lines then
                    wait(delay)
                end
            end
        end
        
        multiStatus.Text = "Done! Sent "..#lines.." messages"
        multiSendBtn.Text = "📤 Send All Messages"
        multiSendBtn.BackgroundColor3 = COLORS.buttonPrimary
        
        multiInput.Text = ""
        updateMultiCounter()
    end)
end)

multiLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    multiPage.CanvasSize = UDim2.new(0, 0, 0, multiLayout.AbsoluteContentSize.Y + 10)
end)

-- ========== SPAM TAB ==========

local spamPage = tabPages["Spam"]

local spamLayout = Instance.new("UIListLayout")
spamLayout.Padding = UDim.new(0, 8)
spamLayout.Parent = spamPage

local spamMessages = {}
local spamRunning = false

local spamDesc = Instance.new("TextLabel")
spamDesc.Size = UDim2.new(1, 0, 0, 20)
spamDesc.BackgroundTransparency = 1
spamDesc.TextColor3 = COLORS.textMuted
spamDesc.Text = "Add premade messages to spam (loops forever)"
spamDesc.Font = Enum.Font.Gotham
spamDesc.TextSize = 11
spamDesc.TextXAlignment = Enum.TextXAlignment.Left
spamDesc.Parent = spamPage

local addRow = Instance.new("Frame")
addRow.Size = UDim2.new(1, 0, 0, 30)
addRow.BackgroundTransparency = 1
addRow.Parent = spamPage

local spamAddInput = Instance.new("TextBox")
spamAddInput.Size = UDim2.new(1, -70, 1, 0)
spamAddInput.BackgroundColor3 = COLORS.inputBg
spamAddInput.TextColor3 = COLORS.textLight
spamAddInput.Text = ""
spamAddInput.PlaceholderText = "Add new message..."
spamAddInput.PlaceholderColor3 = COLORS.textMuted
spamAddInput.Font = Enum.Font.Gotham
spamAddInput.TextSize = 12
spamAddInput.ClearTextOnFocus = false
spamAddInput.Parent = addRow

local spamAddInputCorner = Instance.new("UICorner")
spamAddInputCorner.CornerRadius = UDim.new(0, 6)
spamAddInputCorner.Parent = spamAddInput

local spamAddInputStroke = Instance.new("UIStroke")
spamAddInputStroke.Color = COLORS.border
spamAddInputStroke.Thickness = 1
spamAddInputStroke.Parent = spamAddInput

local spamAddBtn = Instance.new("TextButton")
spamAddBtn.Size = UDim2.new(0, 60, 1, 0)
spamAddBtn.Position = UDim2.new(1, -65, 0, 0)
spamAddBtn.BackgroundColor3 = COLORS.buttonSuccess
spamAddBtn.TextColor3 = COLORS.textLight
spamAddBtn.Text = "+ Add"
spamAddBtn.Font = Enum.Font.GothamBold
spamAddBtn.TextSize = 11
spamAddBtn.Parent = addRow

local spamAddBtnCorner = Instance.new("UICorner")
spamAddBtnCorner.CornerRadius = UDim.new(0, 6)
spamAddBtnCorner.Parent = spamAddBtn

local spamAddCounter = Instance.new("TextLabel")
spamAddCounter.Size = UDim2.new(1, 0, 0, 16)
spamAddCounter.BackgroundTransparency = 1
spamAddCounter.TextColor3 = COLORS.textMuted
spamAddCounter.Text = "0/200"
spamAddCounter.Font = Enum.Font.Gotham
spamAddCounter.TextSize = 10
spamAddCounter.TextXAlignment = Enum.TextXAlignment.Right
spamAddCounter.Parent = spamPage

local spamListLabel = Instance.new("TextLabel")
spamListLabel.Size = UDim2.new(1, 0, 0, 20)
spamListLabel.BackgroundTransparency = 1
spamListLabel.TextColor3 = COLORS.textLight
spamListLabel.Text = "Saved Messages:"
spamListLabel.Font = Enum.Font.GothamBold
spamListLabel.TextSize = 12
spamListLabel.TextXAlignment = Enum.TextXAlignment.Left
spamListLabel.Parent = spamPage

local spamListContainer = Instance.new("Frame")
spamListContainer.Size = UDim2.new(1, 0, 0, 100)
spamListContainer.BackgroundColor3 = COLORS.cardBg
spamListContainer.Parent = spamPage

local spamListContainerCorner = Instance.new("UICorner")
spamListContainerCorner.CornerRadius = UDim.new(0, 8)
spamListContainerCorner.Parent = spamListContainer

local spamListContainerStroke = Instance.new("UIStroke")
spamListContainerStroke.Color = COLORS.border
spamListContainerStroke.Thickness = 1
spamListContainerStroke.Parent = spamListContainer

local spamScroll = Instance.new("ScrollingFrame")
spamScroll.Size = UDim2.new(1, -16, 1, -16)
spamScroll.Position = UDim2.new(0, 8, 0, 8)
spamScroll.BackgroundTransparency = 1
spamScroll.ScrollBarThickness = 4
spamScroll.ScrollBarImageColor3 = COLORS.buttonPrimary
spamScroll.Parent = spamListContainer

local spamScrollLayout = Instance.new("UIListLayout")
spamScrollLayout.Padding = UDim.new(0, 4)
spamScrollLayout.Parent = spamScroll

local spamDelayRow = Instance.new("Frame")
spamDelayRow.Size = UDim2.new(1, 0, 0, 30)
spamDelayRow.BackgroundTransparency = 1
spamDelayRow.Parent = spamPage

local spamDelayLabel = Instance.new("TextLabel")
spamDelayLabel.Size = UDim2.new(0, 100, 1, 0)
spamDelayLabel.BackgroundTransparency = 1
spamDelayLabel.TextColor3 = COLORS.textLight
spamDelayLabel.Text = "Delay (sec):"
spamDelayLabel.Font = Enum.Font.Gotham
spamDelayLabel.TextSize = 12
spamDelayLabel.TextXAlignment = Enum.TextXAlignment.Left
spamDelayLabel.Parent = spamDelayRow

local spamDelayInput = Instance.new("TextBox")
spamDelayInput.Size = UDim2.new(0, 60, 1, 0)
spamDelayInput.Position = UDim2.new(0, 105, 0, 0)
spamDelayInput.BackgroundColor3 = COLORS.inputBg
spamDelayInput.TextColor3 = COLORS.textLight
spamDelayInput.Text = "1.0"
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

local spamCountLabel = Instance.new("TextLabel")
spamCountLabel.Size = UDim2.new(0, 100, 1, 0)
spamCountLabel.Position = UDim2.new(1, -100, 0, 0)
spamCountLabel.BackgroundTransparency = 1
spamCountLabel.TextColor3 = COLORS.textMuted
spamCountLabel.Text = "Messages: 0"
spamCountLabel.Font = Enum.Font.Gotham
spamCountLabel.TextSize = 11
spamCountLabel.TextXAlignment = Enum.TextXAlignment.Right
spamCountLabel.Parent = spamDelayRow

local spamStatus = Instance.new("TextLabel")
spamStatus.Size = UDim2.new(1, 0, 0, 18)
spamStatus.BackgroundTransparency = 1
spamStatus.TextColor3 = COLORS.textMuted
spamStatus.Text = "Ready"
spamStatus.Font = Enum.Font.Gotham
spamStatus.TextSize = 11
spamStatus.TextXAlignment = Enum.TextXAlignment.Left
spamStatus.Parent = spamPage

local spamToggle = Instance.new("TextButton")
spamToggle.Size = UDim2.new(1, 0, 0, 40)
spamToggle.BackgroundColor3 = COLORS.buttonDanger
spamToggle.TextColor3 = COLORS.textLight
spamToggle.Text = "🔄 SPAM: OFF"
spamToggle.Font = Enum.Font.GothamBold
spamToggle.TextSize = 14
spamToggle.Parent = spamPage

local spamToggleCorner = Instance.new("UICorner")
spamToggleCorner.CornerRadius = UDim.new(0, 8)
spamToggleCorner.Parent = spamToggle

local messageButtons = {}

local function updateSpamList()
    for _, btn in pairs(messageButtons) do
        btn:Destroy()
    end
    messageButtons = {}
    
    for i, msg in ipairs(spamMessages) do
        local msgFrame = Instance.new("Frame")
        msgFrame.Size = UDim2.new(1, 0, 0, 28)
        msgFrame.BackgroundColor3 = COLORS.inputBg
        msgFrame.Parent = spamScroll
        
        local msgFrameCorner = Instance.new("UICorner")
        msgFrameCorner.CornerRadius = UDim.new(0, 5)
        msgFrameCorner.Parent = msgFrame
        
        local msgText = Instance.new("TextLabel")
        msgText.Size = UDim2.new(1, -35, 1, 0)
        msgText.BackgroundTransparency = 1
        msgText.TextColor3 = COLORS.textLight
        msgText.Text = msg
        msgText.Font = Enum.Font.Gotham
        msgText.TextSize = 11
        msgText.TextXAlignment = Enum.TextXAlignment.Left
        msgText.TextTruncate = Enum.TextTruncate.AtEnd
        msgText.Parent = msgFrame
        
        local removeBtn = Instance.new("TextButton")
        removeBtn.Size = UDim2.new(0, 25, 1, 0)
        removeBtn.Position = UDim2.new(1, -27, 0, 0)
        removeBtn.BackgroundColor3 = COLORS.buttonDanger
        removeBtn.TextColor3 = COLORS.textLight
        removeBtn.Text = "✕"
        removeBtn.Font = Enum.Font.GothamBold
        removeBtn.TextSize = 10
        removeBtn.Parent = msgFrame
        
        local removeBtnCorner = Instance.new("UICorner")
        removeBtnCorner.CornerRadius = UDim.new(0, 5)
        removeBtnCorner.Parent = removeBtn
        
        removeBtn.MouseButton1Click:Connect(function()
            table.remove(spamMessages, i)
            updateSpamList()
            spamCountLabel.Text = "Messages: "..#spamMessages
        end)
        
        table.insert(messageButtons, msgFrame)
    end
    
    spamScroll.CanvasSize = UDim2.new(0, 0, 0, #spamMessages * 32)
end

spamAddInput:GetPropertyChangedSignal("Text"):Connect(function()
    local len = #spamAddInput.Text
    spamAddCounter.Text = len.."/200"
    if len > 200 then
        spamAddCounter.TextColor3 = COLORS.buttonDanger
    else
        spamAddCounter.TextColor3 = COLORS.textMuted
    end
end)

spamAddBtn.MouseButton1Click:Connect(function()
    local text = spamAddInput.Text
    if text and text ~= "" and #text <= 200 then
        table.insert(spamMessages, text)
        spamAddInput.Text = ""
        spamAddCounter.Text = "0/200"
        updateSpamList()
        spamCountLabel.Text = "Messages: "..#spamMessages
    end
end)

spamAddInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        spamAddBtn.MouseButton1Click:Fire()
    end
end)

spamToggle.MouseButton1Click:Connect(function()
    spamRunning = not spamRunning
    
    if spamRunning then
        if #spamMessages == 0 then
            spamStatus.Text = "Error: No messages to spam!"
            spamRunning = false
            return
        end
        
        spamToggle.Text = "🔄 SPAM: ON"
        spamToggle.BackgroundColor3 = COLORS.buttonSuccess
        spamStatus.Text = "Spamming..."
        
        local delay = tonumber(spamDelayInput.Text) or 1.0
        if delay < 0.1 then delay = 0.1 end
        
        spawn(function()
            local index = 1
            while spamRunning do
                if #spamMessages > 0 then
                    sendMessage(spamMessages[index])
                    spamStatus.Text = "Spamming: "..index.."/"..#spamMessages
                    index = index + 1
                    if index > #spamMessages then
                        index = 1
                    end
                end
                wait(delay)
            end
        end)
    else
        spamToggle.Text = "🔄 SPAM: OFF"
        spamToggle.BackgroundColor3 = COLORS.buttonDanger
        spamStatus.Text = "Stopped"
    end
end)

spamLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    spamPage.CanvasSize = UDim2.new(0, 0, 0, spamLayout.AbsoluteContentSize.Y + 10)
end)

-- ========== PREFIX TAB ==========

local prefixPage = tabPages["Prefix"]

local prefixLayout = Instance.new("UIListLayout")
prefixLayout.Padding = UDim.new(0, 8)
prefixLayout.Parent = prefixPage

local prefixDesc = Instance.new("TextLabel")
prefixDesc.Size = UDim2.new(1, 0, 0, 20)
prefixDesc.BackgroundTransparency = 1
prefixDesc.TextColor3 = COLORS.textMuted
prefixDesc.Text = "Add prefix/emojis before every message"
prefixDesc.Font = Enum.Font.Gotham
prefixDesc.TextSize = 11
prefixDesc.TextXAlignment = Enum.TextXAlignment.Left
prefixDesc.Parent = prefixPage

local prefixToggle = Instance.new("TextButton")
prefixToggle.Size = UDim2.new(1, 0, 0, 40)
prefixToggle.BackgroundColor3 = COLORS.buttonDanger
prefixToggle.TextColor3 = COLORS.textLight
prefixToggle.Text = "PREFIX: OFF"
prefixToggle.Font = Enum.Font.GothamBold
prefixToggle.TextSize = 14
prefixToggle.Parent = prefixPage

local prefixToggleCorner = Instance.new("UICorner")
prefixToggleCorner.CornerRadius = UDim.new(0, 8)
prefixToggleCorner.Parent = prefixToggle

local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, 0, 0, 20)
modeLabel.BackgroundTransparency = 1
modeLabel.TextColor3 = COLORS.textLight
modeLabel.Text = "Mode:"
modeLabel.Font = Enum.Font.GothamBold
modeLabel.TextSize = 12
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = prefixPage

local modeRow = Instance.new("Frame")
modeRow.Size = UDim2.new(1, 0, 0, 35)
modeRow.BackgroundTransparency = 1
modeRow.Parent = prefixPage

local fixedBtn = Instance.new("TextButton")
fixedBtn.Size = UDim2.new(0.5, -4, 1, 0)
fixedBtn.Position = UDim2.new(0, 0, 0, 0)
fixedBtn.BackgroundColor3 = COLORS.buttonPrimary
fixedBtn.TextColor3 = COLORS.textLight
fixedBtn.Text = "📌 Fixed"
fixedBtn.Font = Enum.Font.GothamBold
fixedBtn.TextSize = 12
fixedBtn.Parent = modeRow

local fixedBtnCorner = Instance.new("UICorner")
fixedBtnCorner.CornerRadius = UDim.new(0, 8)
fixedBtnCorner.Parent = fixedBtn

local rotateBtn = Instance.new("TextButton")
rotateBtn.Size = UDim2.new(0.5, -4, 1, 0)
rotateBtn.Position = UDim2.new(0.5, 4, 0, 0)
rotateBtn.BackgroundColor3 = COLORS.buttonDark
rotateBtn.TextColor3 = COLORS.textMuted
rotateBtn.Text = "🔄 Rotate"
rotateBtn.Font = Enum.Font.GothamBold
rotateBtn.TextSize = 12
rotateBtn.Parent = modeRow

local rotateBtnCorner = Instance.new("UICorner")
rotateBtnCorner.CornerRadius = UDim.new(0, 8)
rotateBtnCorner.Parent = rotateBtn

local modeDesc = Instance.new("TextLabel")
modeDesc.Size = UDim2.new(1, 0, 0, 35)
modeDesc.BackgroundTransparency = 1
modeDesc.TextColor3 = COLORS.textMuted
modeDesc.Text = "Fixed: All emojis together\n\"💀🔥😈 message\""
modeDesc.Font = Enum.Font.Gotham
modeDesc.TextSize = 10
modeDesc.TextXAlignment = Enum.TextXAlignment.Left
modeDesc.TextWrapped = true
modeDesc.Parent = prefixPage

local addPrefixRow = Instance.new("Frame")
addPrefixRow.Size = UDim2.new(1, 0, 0, 30)
addPrefixRow.BackgroundTransparency = 1
addPrefixRow.Parent = prefixPage

local prefixAddInput = Instance.new("TextBox")
prefixAddInput.Size = UDim2.new(1, -70, 1, 0)
prefixAddInput.BackgroundColor3 = COLORS.inputBg
prefixAddInput.TextColor3 = COLORS.textLight
prefixAddInput.Text = ""
prefixAddInput.PlaceholderText = "Add emoji/prefix..."
prefixAddInput.PlaceholderColor3 = COLORS.textMuted
prefixAddInput.Font = Enum.Font.Gotham
prefixAddInput.TextSize = 12
prefixAddInput.ClearTextOnFocus = false
prefixAddInput.Parent = addPrefixRow

local prefixAddInputCorner = Instance.new("UICorner")
prefixAddInputCorner.CornerRadius = UDim.new(0, 6)
prefixAddInputCorner.Parent = prefixAddInput

local prefixAddInputStroke = Instance.new("UIStroke")
prefixAddInputStroke.Color = COLORS.border
prefixAddInputStroke.Thickness = 1
prefixAddInputStroke.Parent = prefixAddInput

local prefixAddBtn = Instance.new("TextButton")
prefixAddBtn.Size = UDim2.new(0, 60, 1, 0)
prefixAddBtn.Position = UDim2.new(1, -65, 0, 0)
prefixAddBtn.BackgroundColor3 = COLORS.buttonSuccess
prefixAddBtn.TextColor3 = COLORS.textLight
prefixAddBtn.Text = "+ Add"
prefixAddBtn.Font = Enum.Font.GothamBold
prefixAddBtn.TextSize = 11
prefixAddBtn.Parent = addPrefixRow

local prefixAddBtnCorner = Instance.new("UICorner")
prefixAddBtnCorner.CornerRadius = UDim.new(0, 6)
prefixAddBtnCorner.Parent = prefixAddBtn

local prefixListLabel = Instance.new("TextLabel")
prefixListLabel.Size = UDim2.new(1, 0, 0, 20)
prefixListLabel.BackgroundTransparency = 1
prefixListLabel.TextColor3 = COLORS.textLight
prefixListLabel.Text = "Saved Prefixes:"
prefixListLabel.Font = Enum.Font.GothamBold
prefixListLabel.TextSize = 12
prefixListLabel.TextXAlignment = Enum.TextXAlignment.Left
prefixListLabel.Parent = prefixPage

local prefixListContainer = Instance.new("Frame")
prefixListContainer.Size = UDim2.new(1, 0, 0, 100)
prefixListContainer.BackgroundColor3 = COLORS.cardBg
prefixListContainer.Parent = prefixPage

local prefixListContainerCorner = Instance.new("UICorner")
prefixListContainerCorner.CornerRadius = UDim.new(0, 8)
prefixListContainerCorner.Parent = prefixListContainer

local prefixListContainerStroke = Instance.new("UIStroke")
prefixListContainerStroke.Color = COLORS.border
prefixListContainerStroke.Thickness = 1
prefixListContainerStroke.Parent = prefixListContainer

local prefixScroll = Instance.new("ScrollingFrame")
prefixScroll.Size = UDim2.new(1, -16, 1, -16)
prefixScroll.Position = UDim2.new(0, 8, 0, 8)
prefixScroll.BackgroundTransparency = 1
prefixScroll.ScrollBarThickness = 4
prefixScroll.ScrollBarImageColor3 = COLORS.buttonPrimary
prefixScroll.Parent = prefixListContainer

local prefixScrollLayout = Instance.new("UIListLayout")
prefixScrollLayout.Padding = UDim.new(0, 4)
prefixScrollLayout.Parent = prefixScroll

local prefixPreview = Instance.new("TextLabel")
prefixPreview.Size = UDim2.new(1, 0, 0, 35)
prefixPreview.BackgroundTransparency = 1
prefixPreview.TextColor3 = COLORS.textMuted
prefixPreview.Text = "Preview: 💀🔥😈 Your message"
prefixPreview.Font = Enum.Font.Gotham
prefixPreview.TextSize = 11
prefixPreview.TextXAlignment = Enum.TextXAlignment.Left
prefixPreview.TextWrapped = true
prefixPreview.Parent = prefixPage

local prefixButtons = {}

local function updatePrefixPreview()
    if #prefixEmojis == 0 then
        prefixPreview.Text = "Preview: (no prefix) Your message"
    elseif prefixMode == "Fixed" then
        local combined = table.concat(prefixEmojis, "")
        prefixPreview.Text = "Preview: "..combined.." Your message"
    else
        if currentEmojiIndex > #prefixEmojis then currentEmojiIndex = 1 end
        local current = prefixEmojis[currentEmojiIndex] or ""
        prefixPreview.Text = "Preview: "..current.." Your message (rotating)"
    end
end

local function updatePrefixList()
    for _, btn in pairs(prefixButtons) do
        btn:Destroy()
    end
    prefixButtons = {}
    
    for i, prefix in ipairs(prefixEmojis) do
        local prefixFrame = Instance.new("Frame")
        prefixFrame.Size = UDim2.new(1, 0, 0, 28)
        prefixFrame.BackgroundColor3 = COLORS.inputBg
        prefixFrame.Parent = prefixScroll
        
        local prefixFrameCorner = Instance.new("UICorner")
        prefixFrameCorner.CornerRadius = UDim.new(0, 5)
        prefixFrameCorner.Parent = prefixFrame
        
        local prefixText = Instance.new("TextLabel")
        prefixText.Size = UDim2.new(1, -35, 1, 0)
        prefixText.BackgroundTransparency = 1
        prefixText.TextColor3 = COLORS.textLight
        prefixText.Text = prefix
        prefixText.Font = Enum.Font.Gotham
        prefixText.TextSize = 12
        prefixText.TextXAlignment = Enum.TextXAlignment.Left
        prefixText.TextTruncate = Enum.TextTruncate.AtEnd
        prefixText.Parent = prefixFrame
        
        local removeBtn = Instance.new("TextButton")
        removeBtn.Size = UDim2.new(0, 25, 1, 0)
        removeBtn.Position = UDim2.new(1, -27, 0, 0)
        removeBtn.BackgroundColor3 = COLORS.buttonDanger
        removeBtn.TextColor3 = COLORS.textLight
        removeBtn.Text = "✕"
        removeBtn.Font = Enum.Font.GothamBold
        removeBtn.TextSize = 10
        removeBtn.Parent = prefixFrame
        
        local removeBtnCorner = Instance.new("UICorner")
        removeBtnCorner.CornerRadius = UDim.new(0, 5)
        removeBtnCorner.Parent = removeBtn
        
        removeBtn.MouseButton1Click:Connect(function()
            table.remove(prefixEmojis, i)
            if currentEmojiIndex > #prefixEmojis then
                currentEmojiIndex = 1
            end
            updatePrefixList()
            updatePrefixPreview()
        end)
        
        table.insert(prefixButtons, prefixFrame)
    end
    
    prefixScroll.CanvasSize = UDim2.new(0, 0, 0, #prefixEmojis * 32)
    updatePrefixPreview()
end

prefixToggle.MouseButton1Click:Connect(function()
    prefixEnabled = not prefixEnabled
    
    if prefixEnabled then
        prefixToggle.Text = "PREFIX: ON"
        prefixToggle.BackgroundColor3 = COLORS.buttonSuccess
    else
        prefixToggle.Text = "PREFIX: OFF"
        prefixToggle.BackgroundColor3 = COLORS.buttonDanger
    end
end)

fixedBtn.MouseButton1Click:Connect(function()
    prefixMode = "Fixed"
    fixedBtn.BackgroundColor3 = COLORS.buttonPrimary
    fixedBtn.TextColor3 = COLORS.textLight
    rotateBtn.BackgroundColor3 = COLORS.buttonDark
    rotateBtn.TextColor3 = COLORS.textMuted
    modeDesc.Text = "Fixed: All emojis together\n\"💀🔥😈 message\""
    updatePrefixPreview()
end)

rotateBtn.MouseButton1Click:Connect(function()
    prefixMode = "Rotate"
    rotateBtn.BackgroundColor3 = COLORS.buttonPrimary
    rotateBtn.TextColor3 = COLORS.textLight
    fixedBtn.BackgroundColor3 = COLORS.buttonDark
    fixedBtn.TextColor3 = COLORS.textMuted
    modeDesc.Text = "Rotate: Cycle through emojis\n\"💀 msg\" then \"🔥 msg\"..."
    updatePrefixPreview()
end)

prefixAddBtn.MouseButton1Click:Connect(function()
    local text = prefixAddInput.Text
    if text and text ~= "" then
        table.insert(prefixEmojis, text)
        prefixAddInput.Text = ""
        updatePrefixList()
    end
end)

prefixAddInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        prefixAddBtn.MouseButton1Click:Fire()
    end
end)

prefixLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    prefixPage.CanvasSize = UDim2.new(0, 0, 0, prefixLayout.AbsoluteContentSize.Y + 10)
end)

updatePrefixList()

-- ========== SETTINGS TAB ==========

local settingsPage = tabPages["Settings"]

local settingsLayout = Instance.new("UIListLayout")
settingsLayout.Padding = UDim.new(0, 10)
settingsLayout.Parent = settingsPage

local settingsDesc = Instance.new("TextLabel")
settingsDesc.Size = UDim2.new(1, 0, 0, 20)
settingsDesc.BackgroundTransparency = 1
settingsDesc.TextColor3 = COLORS.textMuted
settingsDesc.Text = "Customize hub appearance"
settingsDesc.Font = Enum.Font.Gotham
settingsDesc.TextSize = 11
settingsDesc.TextXAlignment = Enum.TextXAlignment.Left
settingsDesc.Parent = settingsPage

local widthLabel = Instance.new("TextLabel")
widthLabel.Size = UDim2.new(1, 0, 0, 20)
widthLabel.BackgroundTransparency = 1
widthLabel.TextColor3 = COLORS.textLight
widthLabel.Text = "Hub Width:"
widthLabel.Font = Enum.Font.GothamBold
widthLabel.TextSize = 12
widthLabel.TextXAlignment = Enum.TextXAlignment.Left
widthLabel.Parent = settingsPage

local widthRow = Instance.new("Frame")
widthRow.Size = UDim2.new(1, 0, 0, 35)
widthRow.BackgroundTransparency = 1
widthRow.Parent = settingsPage

local widthInput = Instance.new("TextBox")
widthInput.Size = UDim2.new(0, 80, 1, 0)
widthInput.BackgroundColor3 = COLORS.inputBg
widthInput.TextColor3 = COLORS.textLight
widthInput.Text = tostring(hubWidth)
widthInput.Font = Enum.Font.Gotham
widthInput.TextSize = 12
widthInput.ClearTextOnFocus = false
widthInput.Parent = widthRow

local widthInputCorner = Instance.new("UICorner")
widthInputCorner.CornerRadius = UDim.new(0, 6)
widthInputCorner.Parent = widthInput

local widthInputStroke = Instance.new("UIStroke")
widthInputStroke.Color = COLORS.border
widthInputStroke.Thickness = 1
widthInputStroke.Parent = widthInput

local widthHint = Instance.new("TextLabel")
widthHint.Size = UDim2.new(0, 100, 1, 0)
widthHint.Position = UDim2.new(0, 90, 0, 0)
widthHint.BackgroundTransparency = 1
widthHint.TextColor3 = COLORS.textMuted
widthHint.Text = "pixels (min: 250)"
widthHint.Font = Enum.Font.Gotham
widthHint.TextSize = 10
widthHint.TextXAlignment = Enum.TextXAlignment.Left
widthHint.Parent = widthRow

local heightLabel = Instance.new("TextLabel")
heightLabel.Size = UDim2.new(1, 0, 0, 20)
heightLabel.BackgroundTransparency = 1
heightLabel.TextColor3 = COLORS.textLight
heightLabel.Text = "Hub Height:"
heightLabel.Font = Enum.Font.GothamBold
heightLabel.TextSize = 12
heightLabel.TextXAlignment = Enum.TextXAlignment.Left
heightLabel.Parent = settingsPage

local heightRow = Instance.new("Frame")
heightRow.Size = UDim2.new(1, 0, 0, 35)
heightRow.BackgroundTransparency = 1
heightRow.Parent = settingsPage

local heightInput = Instance.new("TextBox")
heightInput.Size = UDim2.new(0, 80, 1, 0)
heightInput.BackgroundColor3 = COLORS.inputBg
heightInput.TextColor3 = COLORS.textLight
heightInput.Text = tostring(hubHeight)
heightInput.Font = Enum.Font.Gotham
heightInput.TextSize = 12
heightInput.ClearTextOnFocus = false
heightInput.Parent = heightRow

local heightInputCorner = Instance.new("UICorner")
heightInputCorner.CornerRadius = UDim.new(0, 6)
heightInputCorner.Parent = heightInput

local heightInputStroke = Instance.new("UIStroke")
heightInputStroke.Color = COLORS.border
heightInputStroke.Thickness = 1
heightInputStroke.Parent = heightInput

local heightHint = Instance.new("TextLabel")
heightHint.Size = UDim2.new(0, 100, 1, 0)
heightHint.Position = UDim2.new(0, 90, 0, 0)
heightHint.BackgroundTransparency = 1
heightHint.TextColor3 = COLORS.textMuted
heightHint.Text = "pixels (min: 300)"
heightHint.Font = Enum.Font.Gotham
heightHint.TextSize = 10
heightHint.TextXAlignment = Enum.TextXAlignment.Left
heightHint.Parent = heightRow

local applySizeBtn = Instance.new("TextButton")
applySizeBtn.Size = UDim2.new(1, 0, 0, 40)
applySizeBtn.BackgroundColor3 = COLORS.buttonPrimary
applySizeBtn.TextColor3 = COLORS.textLight
applySizeBtn.Text = "Apply Size"
applySizeBtn.Font = Enum.Font.GothamBold
applySizeBtn.TextSize = 14
applySizeBtn.Parent = settingsPage

local applySizeBtnCorner = Instance.new("UICorner")
applySizeBtnCorner.CornerRadius = UDim.new(0, 8)
applySizeBtnCorner.Parent = applySizeBtn

local settingsStatus = Instance.new("TextLabel")
settingsStatus.Size = UDim2.new(1, 0, 0, 20)
settingsStatus.BackgroundTransparency = 1
settingsStatus.TextColor3 = COLORS.textMuted
settingsStatus.Text = "Current: "..hubWidth.." x "..hubHeight
settingsStatus.Font = Enum.Font.Gotham
settingsStatus.TextSize = 11
settingsStatus.TextXAlignment = Enum.TextXAlignment.Left
settingsStatus.Parent = settingsPage

local divider1 = Instance.new("Frame")
divider1.Size = UDim2.new(1, 0, 0, 1)
divider1.BackgroundColor3 = COLORS.border
divider1.BorderSizePixel = 0
divider1.Parent = settingsPage

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(1, 0, 0, 35)
resetBtn.BackgroundColor3 = COLORS.buttonWarning
resetBtn.TextColor3 = COLORS.textDark
resetBtn.Text = "Reset to Default Size"
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 12
resetBtn.Parent = settingsPage

local resetBtnCorner = Instance.new("UICorner")
resetBtnCorner.CornerRadius = UDim.new(0, 8)
resetBtnCorner.Parent = resetBtn

local divider2 = Instance.new("Frame")
divider2.Size = UDim2.new(1, 0, 0, 1)
divider2.BackgroundColor3 = COLORS.border
divider2.BorderSizePixel = 0
divider2.Parent = settingsPage

local keybindLabel = Instance.new("TextLabel")
keybindLabel.Size = UDim2.new(1, 0, 0, 20)
keybindLabel.BackgroundTransparency = 1
keybindLabel.TextColor3 = COLORS.textLight
keybindLabel.Text = "Keybinds:"
keybindLabel.Font = Enum.Font.GothamBold
keybindLabel.TextSize = 12
keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
keybindLabel.Parent = settingsPage

local keybindInfo = Instance.new("TextLabel")
keybindInfo.Size = UDim2.new(1, 0, 0, 20)
keybindInfo.BackgroundTransparency = 1
keybindInfo.TextColor3 = COLORS.textMuted
keybindInfo.Text = "Right CTRL - Toggle Hub"
keybindInfo.Font = Enum.Font.Gotham
keybindInfo.TextSize = 11
keybindInfo.TextXAlignment = Enum.TextXAlignment.Left
keybindInfo.Parent = settingsPage

local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size = UDim2.new(1, 0, 0, 40)
creditsLabel.BackgroundTransparency = 1
creditsLabel.TextColor3 = COLORS.textMuted
creditsLabel.Text = "Made for chat automation"
creditsLabel.Font = Enum.Font.Gotham
creditsLabel.TextSize = 10
creditsLabel.TextXAlignment = Enum.TextXAlignment.Center
creditsLabel.Parent = settingsPage

applySizeBtn.MouseButton1Click:Connect(function()
    local newWidth = tonumber(widthInput.Text) or 280
    local newHeight = tonumber(heightInput.Text) or 400
    
    if newWidth < 250 then newWidth = 250 end
    if newHeight < 300 then newHeight = 300 end
    if newWidth > 600 then newWidth = 600 end
    if newHeight > 800 then newHeight = 800 end
    
    resizeHub(newWidth, newHeight)
    settingsStatus.Text = "Applied: "..newWidth.." x "..newHeight
    widthInput.Text = tostring(newWidth)
    heightInput.Text = tostring(newHeight)
end)

resetBtn.MouseButton1Click:Connect(function()
    resizeHub(280, 400)
    widthInput.Text = "280"
    heightInput.Text = "400"
    settingsStatus.Text = "Reset to: 280 x 400"
end)

settingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    settingsPage.CanvasSize = UDim2.new(0, 0, 0, settingsLayout.AbsoluteContentSize.Y + 10)
end)

-- ========== KEYBIND ==========

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

print("✅ Chat Hub Loaded")
print("   Tabs: Quick, Multi, Spam, Prefix, Settings")
print("   Press Right CTRL to toggle")
print("   Click tabs to expand/collapse")
