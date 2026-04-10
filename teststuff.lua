-- Fixed Mobile Chat Spam Tester
-- Actually sends messages to chat

local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Chat Tester"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.TextSize = 16

local startBtn = Instance.new("TextButton", frame)
startBtn.Position = UDim2.new(0, 20, 0, 50)
startBtn.Size = UDim2.new(0, 80, 0, 30)
startBtn.Text = "START"
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.BackgroundColor3 = Color3.new(0.1, 0.5, 0.1)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Position = UDim2.new(0, 150, 0, 50)
stopBtn.Size = UDim2.new(0, 80, 0, 30)
stopBtn.Text = "STOP"
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.BackgroundColor3 = Color3.new(0.5, 0.1, 0.1)

local status = Instance.new("TextLabel", frame)
status.Position = UDim2.new(0, 20, 0, 100)
status.Size = UDim2.new(0, 210, 0, 30)
status.Text = "Status: Ready"
status.TextColor3 = Color3.new(1, 1, 1)
status.TextSize = 14
status.TextXAlignment = Enum.TextXAlignment.Left

local running = false
local count = 0

-- FIXED: Proper way to send chat messages in Roblox
local function sendMsg(msg)
    -- Method 1: Using ReplicatedStorage (most reliable)
    local chatRemote = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents")
    local sayMessage = chatRemote:WaitForChild("SayMessageRequest")
    sayMessage:FireServer(msg, "All")
    
    -- Method 2: Alternative if above doesn't work
    -- game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
    --     Text = "[System] " .. msg,
    --     Color = Color3.new(1,1,1),
    --     Font = Enum.Font.SourceSansBold,
    --     FontSize = Enum.FontSize.Size18
    -- })
end

startBtn.MouseButton1Click:Connect(function()
    if not running then
        running = true
        count = 0
        spawn(function()
            while running do
                sendMsg("test message")
                count = count + 1
                status.Text = "Sent " .. count .. " messages"
                wait(1)
            end
        end)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    status.Text = "Stopped. Sent " .. count .. " messages"
end)
