-- Custom Chat GUI with Spam Feature (Mobile Friendly + Draggable)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local MAX_CHARS = 200
local spamEnabled = false
local spamMessage = ""
local spamDelay = 1

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomChatGui"
screenGui.Parent = playerGui

-- Main Frame (larger for mobile)
local frame = Instance.new("Frame")
frame.Name = "ChatFrame"
frame.Size = UDim2.new(0, 380, 0, 180)
frame.Position = UDim2.new(0.5, -190, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(60, 60, 60)
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

-- Title Bar (for dragging)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "💬 Custom Chat"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Character Counter
local charCounter = Instance.new("TextLabel")
charCounter.Name = "CharCounter"
charCounter.Size = UDim2.new(0, 60, 0, 20)
charCounter.Position = UDim2.new(1, -65, 0, 35)
charCounter.BackgroundTransparency = 1
charCounter.TextColor3 = Color3.fromRGB(150, 150, 150)
charCounter.Text = "0/200"
charCounter.Font = Enum.Font.Gotham
charCounter.TextSize = 12
charCounter.Parent = frame

-- Textbox Label
local textboxLabel = Instance.new("TextLabel")
textboxLabel.Size = UDim2.new(0, 100, 0, 20)
textboxLabel.Position = UDim2.new(0, 10, 0, 35)
textboxLabel.BackgroundTransparency = 1
textboxLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
textboxLabel.Text = "Message:"
textboxLabel.Font = Enum.Font.Gotham
textboxLabel.TextSize = 12
textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
textboxLabel.Parent = frame

-- Textbox
local textbox = Instance.new("TextBox")
textbox.Name = "ChatInput"
textbox.Size = UDim2.new(1, -80, 0, 30)
textbox.Position = UDim2.new(0, 10, 0, 55)
textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox.Text = ""
textbox.PlaceholderText = "Type message..."
textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
textbox.Font = Enum.Font.Gotham
textbox.TextSize = 14
textbox.TextXAlignment = Enum.TextXAlignment.Left
textbox.ClearTextOnFocus = false
textbox.Parent = frame

local textboxCorner = Instance.new("UICorner")
textboxCorner.CornerRadius = UDim.new(0, 6)
textboxCorner.Parent = textbox

-- Send Button
local sendButton = Instance.new("TextButton")
sendButton.Name = "SendButton"
sendButton.Size = UDim2.new(0, 60, 0, 30)
sendButton.Position = UDim2.new(1, -70, 0, 55)
sendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Text = "Send"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 14
sendButton.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = sendButton

-- Divider
local divider = Instance.new("Frame")
divider.Name = "Divider"
divider.Size = UDim2.new(1, -20, 0, 2)
divider.Position = UDim2.new(0, 10, 0, 95)
divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
divider.BorderSizePixel = 0
divider.Parent = frame

-- Spam Section Label
local spamLabel = Instance.new("TextLabel")
spamLabel.Name = "SpamLabel"
spamLabel.Size = UDim2.new(1, -20, 0, 20)
spamLabel.Position = UDim2.new(0, 10, 0, 100)
spamLabel.BackgroundTransparency = 1
spamLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
spamLabel.Text = "🔄 SPAM SETTINGS"
spamLabel.Font = Enum.Font.GothamBold
spamLabel.TextSize = 12
spamLabel.TextXAlignment = Enum.TextXAlignment.Left
spamLabel.Parent = frame

-- Spam Message Textbox
local spamTextbox = Instance.new("TextBox")
spamTextbox.Name = "SpamInput"
spamTextbox.Size = UDim2.new(1, -20, 0, 30)
spamTextbox.Position = UDim2.new(0, 10, 0, 122)
spamTextbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
spamTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
spamTextbox.Text = ""
spamTextbox.PlaceholderText = "Spam message..."
spamTextbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
spamTextbox.Font = Enum.Font.Gotham
spamTextbox.TextSize = 14
spamTextbox.TextXAlignment = Enum.TextXAlignment.Left
spamTextbox.ClearTextOnFocus = false
spamTextbox.Parent = frame

local spamTextboxCorner = Instance.new("UICorner")
spamTextboxCorner.CornerRadius = UDim.new(0, 6)
spamTextboxCorner.Parent = spamTextbox

-- Bottom buttons frame
local bottomFrame = Instance.new("Frame")
bottomFrame.Name = "BottomFrame"
bottomFrame.Size = UDim2.new(1, -20, 0, 30)
bottomFrame.Position = UDim2.new(0, 10, 0, 158)
bottomFrame.BackgroundTransparency = 1
bottomFrame.Parent = frame

-- Delay Label
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 40, 0, 30)
delayLabel.Position = UDim2.new(0, 0, 0, 0)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
delayLabel.Text = "Delay:"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 12
delayLabel.Parent = bottomFrame

-- Spam Delay Textbox
local delayTextbox = Instance.new("TextBox")
delayTextbox.Name = "DelayInput"
delayTextbox.Size = UDim2.new(0, 60, 0, 30)
delayTextbox.Position = UDim2.new(0, 45, 0, 0)
delayTextbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
delayTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayTextbox.Text = "1"
delayTextbox.PlaceholderText = "1"
delayTextbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
delayTextbox.Font = Enum.Font.Gotham
delayTextbox.TextSize = 14
delayTextbox.Parent = bottomFrame

local delayTextboxCorner = Instance.new("UICorner")
delayTextboxCorner.CornerRadius = UDim.new(0, 6)
delayTextboxCorner.Parent = delayTextbox

-- Spam Toggle Button
local spamButton = Instance.new("TextButton")
spamButton.Name = "SpamButton"
spamButton.Size = UDim2.new(0, 80, 0, 30)
spamButton.Position = UDim2.new(1, -80, 0, 0)
spamButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
spamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spamButton.Text = "SPAM: OFF"
spamButton.Font = Enum.Font.GothamBold
spamButton.TextSize = 12
spamButton.Parent = bottomFrame

local spamButtonCorner = Instance.new("UICorner")
spamButtonCorner.CornerRadius = UDim.new(0, 6)
spamButtonCorner.Parent = spamButton

-- Dragging functionality
local dragging = false
local dragInput
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
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

titleBar.InputChanged:Connect(function(input)
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

-- Character limit for main textbox
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

-- Function to send message to chat
local function sendMessage(msg)
    local message = msg or textbox.Text
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

-- Send button click
sendButton.MouseButton1Click:Connect(function()
    if sendMessage() then
        textbox.Text = ""
    end
end)

-- Enter key to send
textbox.Focused:Connect(function()
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.Enter then
            if textbox:IsFocused() then
                if sendMessage() then
                    textbox.Text = ""
                end
                connection:Disconnect()
            end
        end
    end)
end)

-- Spam toggle function
local function toggleSpam()
    spamEnabled = not spamEnabled
    
    if spamEnabled then
        spamMessage = spamTextbox.Text
        if spamMessage == "" then
            spamMessage = "Spam message here"
        end
        
        spamDelay = tonumber(delayTextbox.Text) or 1
        if spamDelay < 0.1 then
            spamDelay = 0.1
        end
        
        spamButton.Text = "SPAM: ON"
        spamButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
        spawn(function()
            while spamEnabled do
                sendMessage(spamMessage)
                wait(spamDelay)
            end
        end)
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

print("✅ Custom Chat GUI Loaded - Press RightControl to toggle")
print("✅ Drag the title bar to move")
