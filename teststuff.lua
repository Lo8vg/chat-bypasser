-- Advanced Chat Spam Bypass
-- Uses multiple techniques to avoid detection

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatSpamBypass"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Name = "BypassFrame"
frame.Size = UDim2.new(0, 300, 0, 280)
frame.Position = UDim2.new(0.5, -150, 0.5, -140)
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
titleLabel.Text = "💬 Chat Spam Bypass"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Message Templates
local msgTemplates = {
    "hey guys",
    "anyone here",
    "lol nice",
    "gg everyone",
    "who wants to play",
    "this is fun",
    "follow me",
    "check this out",
    "awesome game",
    "let's go"
}

-- Message Input
local msgInput = Instance.new("TextBox")
msgInput.Name = "MessageInput"
msgInput.Size = UDim2.new(1, -20, 0, 30)
msgInput.Position = UDim2.new(0, 10, 0, 40)
msgInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
msgInput.TextColor3 = Color3.fromRGB(255, 255, 255)
msgInput.Text = "test message"
msgInput.PlaceholderText = "Base message (will be varied)"
msgInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
msgInput.Font = Enum.Font.Gotham
msgInput.TextSize = 14
msgInput.Parent = frame

-- Min/Max Delay
local minDelayLabel = Instance.new("TextLabel")
minDelayLabel.Size = UDim2.new(0, 80, 0, 20)
minDelayLabel.Position = UDim2.new(0, 10, 0, 80)
minDelayLabel.BackgroundTransparency = 1
minDelayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
minDelayLabel.Text = "Min Delay:"
minDelayLabel.Font = Enum.Font.Gotham
minDelayLabel.TextSize = 12
minDelayLabel.Parent = frame

local minDelayInput = Instance.new("TextBox")
minDelayInput.Name = "MinDelayInput"
minDelayInput.Size = UDim2.new(0, 40, 0, 20)
minDelayInput.Position = UDim2.new(0, 90, 0, 80)
minDelayInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
minDelayInput.Text = "2"
minDelayInput.Font = Enum.Font.Gotham
minDelayInput.TextSize = 12
minDelayInput.Parent = frame

local maxDelayLabel = Instance.new("TextLabel")
maxDelayLabel.Size = UDim2.new(0, 80, 0, 20)
maxDelayLabel.Position = UDim2.new(0, 140, 0, 80)
maxDelayLabel.BackgroundTransparency = 1
maxDelayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
maxDelayLabel.Text = "Max Delay:"
maxDelayLabel.Font = Enum.Font.Gotham
maxDelayLabel.TextSize = 12
maxDelayLabel.Parent = frame

local maxDelayInput = Instance.new("TextBox")
maxDelayInput.Name = "MaxDelayInput"
maxDelayInput.Size = UDim2.new(0, 40, 0, 20)
maxDelayInput.Position = UDim2.new(0, 220, 0, 80)
maxDelayInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
maxDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
maxDelayInput.Text = "4"
maxDelayInput.Font = Enum.Font.Gotham
maxDelayInput.TextSize = 12
maxDelayInput.Parent = frame

-- Reset Timer
local resetLabel = Instance.new("TextLabel")
resetLabel.Size = UDim2.new(0, 100, 0, 20)
resetLabel.Position = UDim2.new(0, 10, 0, 110)
resetLabel.BackgroundTransparency = 1
resetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
resetLabel.Text = "Reset Timer:"
resetLabel.Font = Enum.Font.Gotham
resetLabel.TextSize = 12
resetLabel.Parent = frame

local resetInput = Instance.new("TextBox")
resetInput.Name = "ResetInput"
resetInput.Size = UDim2.new(0, 40, 0, 20)
resetInput.Position = UDim2.new(0, 110, 0, 110)
resetInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
resetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
resetInput.Text = "15"
resetInput.Font = Enum.Font.Gotham
resetInput.TextSize = 12
resetInput.Parent = frame

local secLabel = Instance.new("TextLabel")
secLabel.Size = UDim2.new(0, 40, 0, 20)
secLabel.Position = UDim2.new(0, 155, 0, 110)
secLabel.BackgroundTransparency = 1
secLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
secLabel.Text = "seconds"
secLabel.Font = Enum.Font.Gotham
secLabel.TextSize = 12
secLabel.Parent = frame

-- Strategy Selection
local strategyLabel = Instance.new("TextLabel")
strategyLabel.Size = UDim2.new(0, 80, 0, 20)
strategyLabel.Position = UDim2.new(0, 10, 0, 140)
strategyLabel.BackgroundTransparency = 1
strategyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
strategyLabel.Text = "Strategy:"
strategyLabel.Font = Enum.Font.Gotham
strategyLabel.TextSize = 12
strategyLabel.Parent = frame

local hybridBtn = Instance.new("TextButton")
hybridBtn.Name = "HybridButton"
hybridBtn.Size = UDim2.new(0, 80, 0, 20)
hybridBtn.Position = UDim2.new(0, 90, 0, 140)
hybridBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
hybridBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hybridBtn.Text = "Hybrid"
hybridBtn.Font = Enum.Font.GothamBold
hybridBtn.TextSize = 12
hybridBtn.Parent = frame

local randomBtn = Instance.new("TextButton")
randomBtn.Name = "RandomButton"
randomBtn.Size = UDim2.new(0, 80, 0, 20)
randomBtn.Position = UDim2.new(0, 180, 0, 140)
randomBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
randomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
randomBtn.Text = "Random"
randomBtn.Font = Enum.Font.GothamBold
randomBtn.TextSize = 12
randomBtn.Parent = frame

-- Control Buttons
local startBtn = Instance.new("TextButton")
startBtn.Name = "StartButton"
startBtn.Size = UDim2.new(0, 80, 0, 30)
startBtn.Position = UDim2.new(0, 30, 0, 190)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.Text = "START"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
startBtn.Parent = frame

local stopBtn = Instance.new("TextButton")
stopBtn.Name = "StopButton"
stopBtn.Size = UDim2.new(0, 80, 0, 30)
stopBtn.Position = UDim2.new(0, 190, 0, 190)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Text = "STOP"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
stopBtn.Parent = frame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 40)
statusLabel.Position = UDim2.new(0, 10, 0, 230)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Text = "Status: Ready\nStrategy: Hybrid - 3 messages then 15s reset"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

-- Variables
local isRunning = false
local strategy = "hybrid"
local messageCount = 0
local cycleCount = 0

-- Generate unique message
local function generateMessage(baseMsg, index)
    -- Add random variations to make each message unique
    local variations = {"", "!", " :)", " :D", " lol", " hey", " yo"}
    local randomVar = variations[math.random(1, #variations)]
    
    if index % 3 == 0 then
        -- Every third message, use a template
        return msgTemplates[math.random(1, #msgTemplates)]
    else
        -- Otherwise, vary the base message
        return baseMsg .. randomVar
    end
end

-- Send message function
local function sendMessage(msg)
    local message = msg or msgInput.Text
    message = message:gsub("^%s+", ""):gsub("%s+$, "")
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
hybridBtn.MouseButton1Click:Connect(function()
    strategy = "hybrid"
    hybridBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
    randomBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    statusLabel.Text = "Status: Ready\nStrategy: Hybrid - 3 messages then 15s reset"
end)

randomBtn.MouseButton1Click:Connect(function()
    strategy = "random"
    randomBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
    hybridBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    statusLabel.Text = "Status: Ready\nStrategy: Random - No reset timer"
end)

startBtn.MouseButton1Click:Connect(function()
    if isRunning then return end
    
    isRunning = true
    messageCount = 0
    cycleCount = 0
    local minDelay = tonumber(minDelayInput.Text) or 2
    local maxDelay = tonumber(maxDelayInput.Text) or 4
    local resetTime = tonumber(resetInput.Text) or 15
    local baseMessage = msgInput.Text
    
    if minDelay < 0.5 then minDelay = 0.5 end
    if maxDelay < minDelay then maxDelay = minDelay + 1 end
    
    statusLabel.Text = "Status: Running..."
    
    spawn(function()
        while isRunning do
            if strategy == "hybrid" then
                -- Send 3 messages with random delays
                for i = 1, 3 do
                    if not isRunning then break end
                    
                    local message = generateMessage(baseMessage, i)
                    sendMessage(message)
                    messageCount = messageCount + 1
                    cycleCount = cycleCount + 1
                    
                    local delay = math.random(minDelay * 10, maxDelay * 10) / 10
                    statusLabel.Text = "Status: Sent " .. messageCount .. " messages (Cycle " .. cycleCount .. ")"
                    wait(delay)
                end
                
                -- Reset timer
                if isRunning then
                    statusLabel.Text = "Status: Resetting (" .. resetTime .. "s)..."
                    wait(resetTime)
                end
            else -- random strategy
                local message = generateMessage(baseMessage, messageCount)
                sendMessage(message)
                messageCount = messageCount + 1
                
                local delay = math.random(minDelay * 10, maxDelay * 10) / 10
                statusLabel.Text = "Status: Sent " .. messageCount .. " messages"
                wait(delay)
            end
        end
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    isRunning = false
    statusLabel.Text = "Status: Stopped. Sent " .. messageCount .. " messages total"
end)

-- Initialize with hybrid strategy
hybridBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)

print("✅ Chat Spam Bypass Loaded")
