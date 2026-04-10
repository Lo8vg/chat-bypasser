-- 2-Message Test Script
-- Based on our working version but with 2 different messages

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

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "💬 2-Message Test"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Message 1 Input
local msg1Label = Instance.new("TextLabel")
msg1Label.Size = UDim2.new(0, 60, 0, 20)
msg1Label.Position = UDim2.new(0, 10, 0, 40)
msg1Label.BackgroundTransparency = 1
msg1Label.TextColor3 = Color3.fromRGB(200, 200, 200)
msg1Label.Text = "Message 1:"
msg1Label.Font = Enum.Font.Gotham
msg1Label.TextSize = 12
msg1Label.Parent = frame

local msg1Input = Instance.new("TextBox")
msg1Input.Name = "Message1Input"
msg1Input.Size = UDim2.new(1, -80, 0, 20)
msg1Input.Position = UDim2.new(0, 70, 0, 40)
msg1Input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
msg1Input.TextColor3 = Color3.fromRGB(255, 255, 255)
msg1Input.Text = "test message"
msg1Input.PlaceholderText = "First message"
msg1Input.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
msg1Input.Font = Enum.Font.Gotham
msg1Input.TextSize = 12
msg1Input.Parent = frame

-- Message 2 Input
local msg2Label = Instance.new("TextLabel")
msg2Label.Size = UDim2.new(0, 60, 0, 20)
msg2Label.Position = UDim2.new(0, 10, 0, 70)
msg2Label.BackgroundTransparency = 1
msg2Label.TextColor3 = Color3.fromRGB(200, 200, 200)
msg2Label.Text = "Message 2:"
msg2Label.Font = Enum.Font.Gotham
msg2Label.TextSize = 12
msg2Label.Parent = frame

local msg2Input = Instance.new("TextBox")
msg2Input.Name = "Message2Input"
msg2Input.Size = UDim2.new(1, -80, 0, 20)
msg2Input.Position = UDim2.new(0, 70, 0, 70)
msg2Input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
msg2Input.TextColor3 = Color3.fromRGB(255, 255, 255)
msg2Input.Text = "another test"
msg2Input.PlaceholderText = "Second message"
msg2Input.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
msg2Input.Font = Enum.Font.Gotham
msg2Input.TextSize = 12
msg2Input.Parent = frame

-- Delay Input
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 50, 0, 20)
delayLabel.Position = UDim2.new(0, 10, 0, 100)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
delayLabel.Text = "Delay:"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 12
delayLabel.Parent = frame

local delayInput = Instance.new("TextBox")
delayInput.Name = "DelayInput"
delayInput.Size = UDim2.new(0, 50, 0, 20)
delayInput.Position = UDim2.new(0, 60, 0, 100)
delayInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
delayInput.Text = "2"
delayInput.PlaceholderText = "2"
delayInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
delayInput.Font = Enum.Font.Gotham
delayInput.TextSize = 12
delayInput.Parent = frame

local secLabel = Instance.new("TextLabel")
secLabel.Size = UDim2.new(0, 30, 0, 20)
secLabel.Position = UDim2.new(0, 115, 0, 100)
secLabel.BackgroundTransparency = 1
secLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
secLabel.Text = "seconds"
secLabel.Font = Enum.Font.Gotham
secLabel.TextSize = 12
secLabel.Parent = frame

-- Control Buttons
local startBtn = Instance.new("TextButton")
startBtn.Name = "StartButton"
startBtn.Size = UDim2.new(0, 80, 0, 30)
startBtn.Position = UDim2.new(0, 30, 0, 140)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.Text = "START"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
startBtn.Parent = frame

local stopBtn = Instance.new("TextButton")
stopBtn.Name = "StopButton"
stopBtn.Size = UDim2.new(0, 80, 0, 30)
stopBtn.Position = UDim2.new(0, 170, 0, 140)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Text = "STOP"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
stopBtn.Parent = frame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 180)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Text = "Status: Ready"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

-- Variables
local isRunning = false
local messageCount = 0
local attemptedSends = 0

-- Send message function (using your working method)
local function sendMessage(msg)
    local message = msg
    message = message:gsub("^%s+", ""):gsub("%s+$, "")
    message = message:gsub("\n", " ")
    
    if message == "" then
        return false
    end
    
    attemptedSends = attemptedSends + 1
    
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(message, "All")
            messageCount = messageCount + 1
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
                messageCount = messageCount + 1
                return true
            end
        end
    end
    
    return false
end

startBtn.MouseButton1Click:Connect(function()
    if isRunning then return end
    
    isRunning = true
    messageCount = 0
    attemptedSends = 0
    local delay = tonumber(delayInput.Text) or 2
    local message1 = msg1Input.Text
    local message2 = msg2Input.Text
    
    if delay < 0.1 then
        delay = 0.1
    end
    
    statusLabel.Text = "Status: Testing 2-message pattern..."
    
    spawn(function()
        while isRunning do
            -- Send message 1
            sendMessage(message1)
            statusLabel.Text = "Status: Sent " .. messageCount .. " messages (Attempted: " .. attemptedSends .. ")"
            wait(delay)
            
            if isRunning then
                -- Send message 2
                sendMessage(message2)
                statusLabel.Text = "Status: Sent " .. messageCount .. " messages (Attempted: " .. attemptedSends .. ")"
                wait(delay)
            end
        end
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    isRunning = false
    statusLabel.Text = "Status: Stopped. Sent " .. messageCount .. " messages (Attempted: " .. attemptedSends .. ")"
end)

print("✅ 2-Message Test Loaded")
