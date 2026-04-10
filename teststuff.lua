-- Mobile-Friendly Roblox Chat Spam Tester
-- Optimized for mobile exploits (Arceus X, etc.)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Simple GUI for mobile
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Chat Spam Tester"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 16

-- Test Type
local TestType = Instance.new("TextLabel")
TestType.Parent = MainFrame
TestType.Position = UDim2.new(0, 10, 0, 40)
TestType.Size = UDim2.new(0, 80, 0, 20)
TestType.Font = Enum.Font.SourceSans
TestType.Text = "Test Type:"
TestType.TextColor3 = Color3.new(1, 1, 1)
TestType.TextSize = 14

local SingleBtn = Instance.new("TextButton")
SingleBtn.Parent = MainFrame
SingleBtn.Position = UDim2.new(0, 90, 0, 40)
SingleBtn.Size = UDim2.new(0, 70, 0, 20)
SingleBtn.Font = Enum.Font.SourceSans
SingleBtn.Text = "Single"
SingleBtn.TextColor3 = Color3.new(1, 1, 1)
SingleBtn.TextSize = 12
SingleBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)

local DoubleBtn = Instance.new("TextButton")
DoubleBtn.Parent = MainFrame
DoubleBtn.Position = UDim2.new(0, 170, 0, 40)
DoubleBtn.Size = UDim2.new(0, 70, 0, 20)
DoubleBtn.Font = Enum.Font.SourceSans
DoubleBtn.Text = "Double"
DoubleBtn.TextColor3 = Color3.new(1, 1, 1)
DoubleBtn.TextSize = 12
DoubleBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

-- Message input
local MsgLabel = Instance.new("TextLabel")
MsgLabel.Parent = MainFrame
MsgLabel.Position = UDim2.new(0, 10, 0, 70)
MsgLabel.Size = UDim2.new(0, 80, 0, 20)
MsgLabel.Font = Enum.Font.SourceSans
MsgLabel.Text = "Message:"
MsgLabel.TextColor3 = Color3.new(1, 1, 1)
MsgLabel.TextSize = 14

local MsgInput = Instance.new("TextBox")
MsgInput.Parent = MainFrame
MsgInput.Position = UDim2.new(0, 90, 0, 70)
MsgInput.Size = UDim2.new(0, 200, 0, 20)
MsgInput.Font = Enum.Font.SourceSans
MsgInput.Text = "test message"
MsgInput.TextColor3 = Color3.new(1, 1, 1)
MsgInput.TextSize = 12

-- Delay
local DelayLabel = Instance.new("TextLabel")
DelayLabel.Parent = MainFrame
DelayLabel.Position = UDim2.new(0, 10, 0, 100)
DelayLabel.Size = UDim2.new(0, 80, 0, 20)
DelayLabel.Font = Enum.Font.SourceSans
DelayLabel.Text = "Delay (sec):"
DelayLabel.TextColor3 = Color3.new(1, 1, 1)
DelayLabel.TextSize = 14

local DelayInput = Instance.new("TextBox")
DelayInput.Parent = MainFrame
DelayInput.Position = UDim2.new(0, 90, 0, 100)
DelayInput.Size = UDim2.new(0, 50, 0, 20)
DelayInput.Font = Enum.Font.SourceSans
DelayInput.Text = "1"
DelayInput.TextColor3 = Color3.new(1, 1, 1)
DelayInput.TextSize = 12

-- Control buttons
local StartBtn = Instance.new("TextButton")
StartBtn.Parent = MainFrame
StartBtn.Position = UDim2.new(0, 50, 0, 140)
StartBtn.Size = UDim2.new(0, 80, 0, 30)
StartBtn.Font = Enum.Font.SourceSansBold
StartBtn.Text = "START"
StartBtn.TextColor3 = Color3.new(1, 1, 1)
StartBtn.TextSize = 14
StartBtn.BackgroundColor3 = Color3.new(0.1, 0.5, 0.1)

local StopBtn = Instance.new("TextButton")
StopBtn.Parent = MainFrame
StopBtn.Position = UDim2.new(0, 170, 0, 140)
StopBtn.Size = UDim2.new(0, 80, 0, 30)
StopBtn.Font = Enum.Font.SourceSansBold
StopBtn.Text = "STOP"
StopBtn.TextColor3 = Color3.new(1, 1, 1)
StopBtn.TextSize = 14
StopBtn.BackgroundColor3 = Color3.new(0.5, 0.1, 0.1)

-- Status
local Status = Instance.new("TextLabel")
Status.Parent = MainFrame
Status.Position = UDim2.new(0, 10, 0, 180)
Status.Size = UDim2.new(1, -20, 0, 20)
Status.Font = Enum.Font.SourceSans
Status.Text = "Status: Ready"
Status.TextColor3 = Color3.new(1, 1, 1)
Status.TextSize = 12
Status.TextXAlignment = Enum.TextXAlignment.Left

-- Variables
local testType = "single"
local isRunning = false
local messageCount = 0

-- Function to send chat message (simplified for mobile)
local function sendMessage(message)
    local ChatRemote = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents")
    local SayMessageRequest = ChatRemote:WaitForChild("SayMessageRequest")
    SayMessageRequest:FireServer(message)
end

-- Button events
SingleBtn.MouseButton1Click:Connect(function()
    testType = "single"
    SingleBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    DoubleBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Status.Text = "Single message selected"
end)

DoubleBtn.MouseButton1Click:Connect(function()
    testType = "double"
    DoubleBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    SingleBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Status.Text = "Double message selected"
end)

StartBtn.MouseButton1Click:Connect(function()
    if isRunning then return end
    
    isRunning = true
    messageCount = 0
    local delay = tonumber(DelayInput.Text) or 1
    local message = MsgInput.Text
    
    Status.Text = "Testing started..."
    
    spawn(function()
        while isRunning do
            if testType == "single" then
                sendMessage(message)
                messageCount = messageCount + 1
                Status.Text = "Sent " .. messageCount .. " messages"
                wait(delay)
            else -- double
                sendMessage(message)
                messageCount = messageCount + 1
                Status.Text = "Sent " .. messageCount .. " messages"
                wait(delay)
                
                if isRunning then
                    sendMessage(message .. " 2")
                    messageCount = messageCount + 1
                    Status.Text = "Sent " .. messageCount .. " messages"
                    wait(delay)
                end
            end
        end
    end)
end)

StopBtn.MouseButton1Click:Connect(function()
    isRunning = false
    Status.Text = "Stopped. Sent " .. messageCount .. " messages total"
end)

-- Initialize
SingleBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
