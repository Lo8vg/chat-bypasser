-- Roblox Chat Spam Tester with GUI
-- For Roblox exploits (Synapse X, Script-Ware, etc.)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedModules = game:GetService("ReplicatedStorage"):WaitForChild("ChatModules")
local ChatConstants = require(ReplicatedModules:WaitForChild("ChatConstants"))

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Chat Spam Tester"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20

-- Test Type Section
local TestTypeLabel = Instance.new("TextLabel")
TestTypeLabel.Parent = MainFrame
TestTypeLabel.BackgroundColor3 = Color3.new(0, 0, 0, 0)
TestTypeLabel.BorderSizePixel = 0
TestTypeLabel.Position = UDim2.new(0, 10, 0, 60)
TestTypeLabel.Size = UDim2.new(0, 100, 0, 20)
TestTypeLabel.Font = Enum.Font.SourceSans
TestTypeLabel.Text = "Test Type:"
TestTypeLabel.TextColor3 = Color3.new(1, 1, 1)
TestTypeLabel.TextSize = 16
TestTypeLabel.TextXAlignment = Enum.TextXAlignment.Left

local SingleButton = Instance.new("TextButton")
SingleButton.Parent = MainFrame
SingleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
SingleButton.BorderSizePixel = 0
SingleButton.Position = UDim2.new(0, 110, 0, 60)
SingleButton.Size = UDim2.new(0, 80, 0, 20)
SingleButton.Font = Enum.Font.SourceSans
SingleButton.Text = "Single Msg"
SingleButton.TextColor3 = Color3.new(1, 1, 1)
SingleButton.TextSize = 14

local DoubleButton = Instance.new("TextButton")
DoubleButton.Parent = MainFrame
DoubleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
DoubleButton.BorderSizePixel = 0
DoubleButton.Position = UDim2.new(0, 200, 0, 60)
DoubleButton.Size = UDim2.new(0, 80, 0, 20)
DoubleButton.Font = Enum.Font.SourceSans
DoubleButton.Text = "Double Msg"
DoubleButton.TextColor3 = Color3.new(1, 1, 1)
DoubleButton.TextSize = 14

-- Delay Section
local DelayLabel = Instance.new("TextLabel")
DelayLabel.Parent = MainFrame
DelayLabel.BackgroundColor3 = Color3.new(0, 0, 0, 0)
DelayLabel.BorderSizePixel = 0
DelayLabel.Position = UDim2.new(0, 10, 0, 100)
DelayLabel.Size = UDim2.new(0, 100, 0, 20)
DelayLabel.Font = Enum.Font.SourceSans
DelayLabel.Text = "Delay (sec):"
DelayLabel.TextColor3 = Color3.new(1, 1, 1)
DelayLabel.TextSize = 16
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left

local DelayInput = Instance.new("TextBox")
DelayInput.Parent = MainFrame
DelayInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
DelayInput.BorderSizePixel = 0
DelayInput.Position = UDim2.new(0, 110, 0, 100)
DelayInput.Size = UDim2.new(0, 50, 0, 20)
DelayInput.Font = Enum.Font.SourceSans
DelayInput.Text = "1"
DelayInput.TextColor3 = Color3.new(1, 1, 1)
DelayInput.TextSize = 14

-- Message Section
local Message1Label = Instance.new("TextLabel")
Message1Label.Parent = MainFrame
Message1Label.BackgroundColor3 = Color3.new(0, 0, 0, 0)
Message1Label.BorderSizePixel = 0
Message1Label.Position = UDim2.new(0, 10, 0, 140)
Message1Label.Size = UDim2.new(0, 100, 0, 20)
Message1Label.Font = Enum.Font.SourceSans
Message1Label.Text = "Message 1:"
Message1Label.TextColor3 = Color3.new(1, 1, 1)
Message1Label.TextSize = 16
Message1Label.TextXAlignment = Enum.TextXAlignment.Left

local Message1Input = Instance.new("TextBox")
Message1Input.Parent = MainFrame
Message1Input.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Message1Input.BorderSizePixel = 0
Message1Input.Position = UDim2.new(0, 110, 0, 140)
Message1Input.Size = UDim2.new(0, 280, 0, 20)
Message1Input.Font = Enum.Font.SourceSans
Message1Input.Text = "test message"
Message1Input.TextColor3 = Color3.new(1, 1, 1)
Message1Input.TextSize = 14

local Message2Label = Instance.new("TextLabel")
Message2Label.Parent = MainFrame
Message2Label.BackgroundColor3 = Color3.new(0, 0, 0, 0)
Message2Label.BorderSizePixel = 0
Message2Label.Position = UDim2.new(0, 10, 0, 170)
Message2Label.Size = UDim2.new(0, 100, 0, 20)
Message2Label.Font = Enum.Font.SourceSans
Message2Label.Text = "Message 2:"
Message2Label.TextColor3 = Color3.new(1, 1, 1)
Message2Label.TextSize = 16
Message2Label.TextXAlignment = Enum.TextXAlignment.Left

local Message2Input = Instance.new("TextBox")
Message2Input.Parent = MainFrame
Message2Input.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Message2Input.BorderSizePixel = 0
Message2Input.Position = UDim2.new(0, 110, 0, 170)
Message2Input.Size = UDim2.new(0, 280, 0, 20)
Message2Input.Font = Enum.Font.SourceSans
Message2Input.Text = "another test"
Message2Input.TextColor3 = Color3.new(1, 1, 1)
Message2Input.TextSize = 14

-- Control Buttons
local StartButton = Instance.new("TextButton")
StartButton.Parent = MainFrame
StartButton.BackgroundColor3 = Color3.new(0.1, 0.5, 0.1)
StartButton.BorderSizePixel = 0
StartButton.Position = UDim2.new(0, 110, 0, 220)
StartButton.Size = UDim2.new(0, 80, 0, 30)
StartButton.Font = Enum.Font.SourceSansBold
StartButton.Text = "Start"
StartButton.TextColor3 = Color3.new(1, 1, 1)
StartButton.TextSize = 16

local StopButton = Instance.new("TextButton")
StopButton.Parent = MainFrame
StopButton.BackgroundColor3 = Color3.new(0.5, 0.1, 0.1)
StopButton.BorderSizePixel = 0
StopButton.Position = UDim2.new(0, 210, 0, 220)
StopButton.Size = UDim2.new(0, 80, 0, 30)
StopButton.Font = Enum.Font.SourceSansBold
StopButton.Text = "Stop"
StopButton.TextColor3 = Color3.new(1, 1, 1)
StopButton.TextSize = 16

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0, 0)
StatusLabel.BorderSizePixel = 0
StatusLabel.Position = UDim2.new(0, 10, 0, 260)
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Variables
local testType = "single"
local isRunning = false
local messageCount = 0
local spamLoop = nil

-- Function to send chat message
local function sendMessage(message)
    local ChatRemote = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents")
    local SayMessageRequest = ChatRemote:WaitForChild("SayMessageRequest")
    SayMessageRequest:FireServer(message, ChatConstants.AllChannels)
end

-- Button Functions
SingleButton.MouseButton1Click:Connect(function()
    testType = "single"
    SingleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    DoubleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    StatusLabel.Text = "Status: Test type set to Single Message"
end)

DoubleButton.MouseButton1Click:Connect(function()
    testType = "double"
    DoubleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    SingleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    StatusLabel.Text = "Status: Test type set to Double Message"
end)

StartButton.MouseButton1Click:Connect(function()
    if isRunning then return end
    
    isRunning = true
    messageCount = 0
    local delay = tonumber(DelayInput.Text) or 1
    local message1 = Message1Input.Text
    local message2 = Message2Input.Text
    
    StatusLabel.Text = "Status: Running test..."
    
    spamLoop = spawn(function()
        while isRunning do
            if testType == "single" then
                sendMessage(message1)
                messageCount = messageCount + 1
                StatusLabel.Text = "Status: Sent " .. messageCount .. " messages"
                wait(delay)
            elseif testType == "double" then
                sendMessage(message1)
                messageCount = messageCount + 1
                StatusLabel.Text = "Status: Sent " .. messageCount .. " messages"
                wait(delay)
                
                if isRunning then
                    sendMessage(message2)
                    messageCount = messageCount + 1
                    StatusLabel.Text = "Status: Sent " .. messageCount .. " messages"
                    wait(delay)
                end
            end
        end
    end)
end)

StopButton.MouseButton1Click:Connect(function()
    isRunning = false
    if spamLoop then
        spamLoop:Disconnect()
    end
    StatusLabel.Text = "Status: Stopped. Sent " .. messageCount .. " messages total"
end)

-- Initialize with single message selected
SingleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
