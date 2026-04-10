-- Working Mobile Chat Spam Tester
-- Fixed to actually send messages using proper Roblox methods

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatSpamTester"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Name = "TestFrame"
frame.Size = UDim2.new(0, 280, 0, 200)
frame.Position = UDim2.new(0.5, -140, 0.5, -100)
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
titleLabel.Text = "💬 Chat Spam Tester"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Message Input
local msgInput = Instance.new("TextBox")
msgInput.Name = "MessageInput"
msgInput.Size = UDim2.new(1, -20, 0, 30)
msgInput.Position = UDim2.new(0, 10, 0, 40)
msgInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
msgInput.TextColor3 = Color3.fromRGB(255, 255, 255)
msgInput.Text = "test message"
msgInput.PlaceholderText = "Enter message to spam..."
msgInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
msgInput.Font = Enum.Font.Gotham
msgInput.TextSize = 14
msgInput.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = msgInput

-- Delay Input
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 50, 0, 20)
delayLabel.Position = UDim2.new(0, 10, 0, 80)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
delayLabel.Text = "Delay:"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 12
delayLabel.Parent = frame

local delayInput = Instance.new("TextBox")
delayInput.Name = "DelayInput"
delayInput.Size = UDim2.new(0, 50, 0, 20)
delayInput.Position = UDim2.new(0, 60, 0, 80)
delayInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
delayInput.Text = "1"
delayInput.PlaceholderText = "1"
delayInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
delayInput.Font = Enum.Font.Gotham
delayInput.TextSize = 12
delayInput.Parent = frame

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 4)
delayCorner.Parent = delayInput

local secLabel = Instance.new("TextLabel")
secLabel.Size = UDim2.new(0, 30, 0, 20)
secLabel.Position = UDim2.new(0, 115, 0, 80)
secLabel.BackgroundTransparency = 1
secLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
secLabel.Text = "seconds"
secLabel.Font = Enum.Font.Gotham
secLabel.TextSize = 12
secLabel.Parent = frame

-- Test Type
local typeLabel = Instance.new("TextLabel")
typeLabel.Size = UDim2.new(0, 50, 0, 20)
typeLabel.Position = UDim2.new(0, 10, 0, 110)
typeLabel.BackgroundTransparency = 1
typeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
typeLabel.Text = "Type:"
typeLabel.Font = Enum.Font.Gotham
typeLabel.TextSize = 12
typeLabel.Parent = frame

local singleBtn = Instance.new("TextButton")
singleBtn.Name = "SingleButton"
singleBtn.Size = UDim2.new(0, 60, 0, 20)
singleBtn.Position = UDim2.new(0, 60, 0, 110)
singleBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
singleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
singleBtn.Text = "Single"
singleBtn.Font = Enum.Font.GothamBold
singleBtn.TextSize = 12
singleBtn.Parent = frame

local singleCorner = Instance.new("UICorner")
singleCorner.CornerRadius = UDim.new(0, 4)
singleCorner.Parent = singleBtn

local doubleBtn = Instance.new("TextButton")
doubleBtn.Name = "DoubleButton"
doubleBtn.Size = UDim2.new(0, 60, 0, 20)
doubleBtn.Position = UDim2.new(0, 130, 0, 110)
doubleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
doubleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
doubleBtn.Text = "Double"
doubleBtn.Font = Enum.Font.GothamBold
doubleBtn.TextSize = 12
doubleBtn.Parent = frame

local doubleCorner = Instance.new("UICorner")
doubleCorner.CornerRadius = UDim.new(0, 4)
doubleCorner.Parent = doubleBtn

-- Control Buttons
local startBtn = Instance.new("TextButton")
startBtn.Name = "StartButton"
startBtn.Size = UDim2.new(0, 80, 0, 30)
startBtn.Position = UDim2.new(0, 30, 0, 150)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.Text = "START"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
startBtn.Parent = frame

local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 6)
startCorner.Parent = startBtn

local stopBtn = Instance.new("TextButton")
stopBtn.Name = "StopButton"
stopBtn.Size = UDim2.new(0, 80, 0, 30)
stopBtn.Position = UDim2.new(0, 170, 0, 150)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Text = "STOP"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
stopBtn.Parent = frame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 6)
stopCorner.Parent = stopBtn

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 190)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Text = "Status: Ready"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

-- Variables
local isRunning = false
local testType = "single"
local messageCount = 0

-- Send message function (using your working method)
local function sendMessage(msg)
    local message = msg or msgInput.Text
    message = message:gsub("^%s+", ""):gsub("%s+$", "")
    message = message:gsub("\n", " ")
    
    if message == "" then
        return false
    end
    
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(message, "All")
            return true
        end
    end
    
    -- Fallback to TextChatService
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

-- Button Functions
singleBtn.MouseButton1Click:Connect(function()
    testType = "single"
    singleBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
    doubleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    statusLabel.Text = "Status: Single message mode"
end)

doubleBtn.MouseButton1Click:Connect(function()
    testType = "double"
    doubleBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
    singleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    statusLabel.Text = "Status: Double message mode"
end)

startBtn.MouseButton1Click:Connect(function()
    if isRunning then return end
    
    isRunning = true
    messageCount = 0
    local delay = tonumber(delayInput.Text) or 1
    local message = msgInput.Text
    
    if delay < 0.1 then
        delay = 0.1
    end
    
    statusLabel.Text = "Status: Testing started..."
    
    spawn(function()
        while isRunning do
            if testType == "single" then
                sendMessage(message)
                messageCount = messageCount + 1
                statusLabel.Text = "Status: Sent " .. messageCount .. " messages"
                wait(delay)
            else -- double
                sendMessage(message)
                messageCount = messageCount + 1
                statusLabel.Text = "Status: Sent " .. messageCount .. " messages"
                wait(delay)
                
                if isRunning then
                    sendMessage(message .. " 2")
                    messageCount = messageCount + 1
                    statusLabel.Text = "Status: Sent " .. messageCount .. " messages"
                    wait(delay)
                end
            end
        end
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    isRunning = false
    statusLabel.Text = "Status: Stopped. Sent " .. messageCount .. " messages total"
end)

-- Initialize with single message selected
singleBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)

print("✅ Chat Spam Tester Loaded")
