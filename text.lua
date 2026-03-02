-- Multi-Line Chat Hub (Fixed)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local MAX_CHARS = 200
local expanded = false

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MultiChatHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========== HUB BUTTON (Collapsed State) ==========
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

-- ========== MAIN FRAME (Expanded State) ==========
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 280)
mainFrame.Position = UDim2.new(0, 20, 0.5, -140)
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
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "💬 Multi Chat"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Collapse Button
local collapseBtn = Instance.new("TextButton")
collapseBtn.Size = UDim2.new(0, 28, 0, 22)
collapseBtn.Position = UDim2.new(1, -32, 0.5, -11)
collapseBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
collapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
collapseBtn.Text = "×"
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.TextSize = 14
collapseBtn.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -28)
contentFrame.Position = UDim2.new(0, 0, 0, 28)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Textbox Label
local textboxLabel = Instance.new("TextLabel")
textboxLabel.Size = UDim2.new(1, -20, 0, 18)
textboxLabel.Position = UDim2.new(0, 10, 0, 8)
textboxLabel.BackgroundTransparency = 1
textboxLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
textboxLabel.Text = "Multi-line messages (one per line)"
textboxLabel.Font = Enum.Font.Gotham
textboxLabel.TextSize = 10
textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
textboxLabel.Parent = contentFrame

-- Multi-line Textbox
local textbox = Instance.new("TextBox")
textbox.Name = "MultiInput"
textbox.Size = UDim2.new(1, -20, 0, 100)
textbox.Position = UDim2.new(0, 10, 0, 30)
textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox.Text = ""
textbox.PlaceholderText = "Message 1\nMessage 2\nMessage 3"
textbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
textbox.Font = Enum.Font.Gotham
textbox.TextSize = 14
textbox.TextXAlignment = Enum.TextXAlignment.Left
textbox.TextYAlignment = Enum.TextYAlignment.Top
textbox.ClearTextOnFocus = false
textbox.MultiLine = true
textbox.TextWrapped = true
textbox.Parent = contentFrame

local textboxCorner = Instance.new("UICorner")
textboxCorner.CornerRadius = UDim.new(0, 6)
textboxCorner.Parent = textbox

-- Char Counter
local charCounter = Instance.new("TextLabel")
charCounter.Size = UDim2.new(1, -20, 0, 16)
charCounter.Position = UDim2.new(0, 10, 0, 132)
charCounter.BackgroundTransparency = 1
charCounter.TextColor3 = Color3.fromRGB(150, 150, 150)
charCounter.Text = "Lines: 0 | Chars: 0/200"
charCounter.Font = Enum.Font.Gotham
charCounter.TextSize = 10
charCounter.TextXAlignment = Enum.TextXAlignment.Right
charCounter.Parent = contentFrame

-- Delay Row
local delayRow = Instance.new("Frame")
delayRow.Size = UDim2.new(1, -20, 0, 28)
delayRow.Position = UDim2.new(0, 10, 0, 152)
delayRow.BackgroundTransparency = 1
delayRow.Parent = contentFrame

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 45, 1, 0)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
delayLabel.Text = "Delay:"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 11
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = delayRow

local delayTextbox = Instance.new("TextBox")
delayTextbox.Size = UDim2.new(0, 45, 1, 0)
delayTextbox.Position = UDim2.new(0, 48, 0, 0)
delayTextbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayTextbox.Text = "0.5"
delayTextbox.PlaceholderText = "0.5"
delayTextbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
delayTextbox.Font = Enum.Font.Gotham
delayTextbox.TextSize = 11
delayTextbox.ClearTextOnFocus = false
delayTextbox.Parent = delayRow

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 6)
delayCorner.Parent = delayTextbox

local secLabel = Instance.new("TextLabel")
secLabel.Size = UDim2.new(0, 25, 1, 0)
secLabel.Position = UDim2.new(0, 98, 0, 0)
secLabel.BackgroundTransparency = 1
secLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
secLabel.Text = "sec"
secLabel.Font = Enum.Font.Gotham
secLabel.TextSize = 10
secLabel.Parent = delayRow

-- Send All Button
local sendAllBtn = Instance.new("TextButton")
sendAllBtn.Size = UDim2.new(1, -20, 0, 32)
sendAllBtn.Position = UDim2.new(0, 10, 0, 185)
sendAllBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
sendAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendAllBtn.Text = "Send All"
sendAllBtn.Font = Enum.Font.GothamBold
sendAllBtn.TextSize = 13
sendAllBtn.Parent = contentFrame

local sendAllCorner = Instance.new("UICorner")
sendAllCorner.CornerRadius = UDim.new(0, 6)
sendAllCorner.Parent = sendAllBtn

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 16)
statusLabel.Position = UDim2.new(0, 10, 0, 222)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Text = "Ready"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = contentFrame

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

-- ========== DRAGGING FOR MAIN FRAME ==========
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

-- ========== TOGGLE HUB (SAME AS YOUR WORKING SCRIPT) ==========
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
        charCounter.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- ========== SEND MESSAGE FUNCTION ==========
local function sendMessage(msg)
    local message = msg
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

-- ========== MOBILE FIX FOR MULTI-LINE ==========
textbox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        textbox.Text = textbox.Text .. "\n"
        task.wait()
        textbox:CaptureFocus()
    end
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
    
    local delay = tonumber(delayTextbox.Text) or 0.5
    if delay < 0.1 then delay = 0.1 end
    
    sendAllBtn.Text = "Sending..."
    sendAllBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
    statusLabel.Text = "Sending "..#lines.." messages..."
    
    spawn(function()
        for i, line in ipairs(lines) do
            sendMessage(line)
            statusLabel.Text = "Sent "..i.."/"..#lines
            if i < #lines then
                wait(delay)
            end
        end
        sendAllBtn.Text = "Send All"
        sendAllBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        statusLabel.Text = "Done! Sent "..#lines.." messages"
    end)
end)

-- ========== TOGGLE WITH RIGHT CONTROL ==========
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

print("✅ Multi-Line Chat Hub Loaded")
