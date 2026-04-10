-- Simple Mobile 2-Message Test
-- Minimal code that will definitely execute

local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0.5, -125, 0.5, -90)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "2-Message Test"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.TextSize = 16

local msg1 = Instance.new("TextBox", frame)
msg1.Position = UDim2.new(0, 10, 0, 40)
msg1.Size = UDim2.new(1, -20, 0, 25)
msg1.Text = "test message"
msg1.TextColor3 = Color3.new(1, 1, 1)
msg1.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

local msg2 = Instance.new("TextBox", frame)
msg2.Position = UDim2.new(0, 10, 0, 70)
msg2.Size = UDim2.new(1, -20, 0, 25)
msg2.Text = "another test"
msg2.TextColor3 = Color3.new(1, 1, 1)
msg2.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

local delay = Instance.new("TextBox", frame)
delay.Position = UDim2.new(0, 10, 0, 100)
delay.Size = UDim2.new(0, 50, 0, 25)
delay.Text = "2"
delay.TextColor3 = Color3.new(1, 1, 1)
delay.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

local startBtn = Instance.new("TextButton", frame)
startBtn.Position = UDim2.new(0, 20, 0, 135)
startBtn.Size = UDim2.new(0, 80, 0, 30)
startBtn.Text = "START"
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.BackgroundColor3 = Color3.new(0.1, 0.5, 0.1)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Position = UDim2.new(0, 150, 0, 135)
stopBtn.Size = UDim2.new(0, 80, 0, 30)
stopBtn.Text = "STOP"
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.BackgroundColor3 = Color3.new(0.5, 0.1, 0.1)

local status = Instance.new("TextLabel", frame)
status.Position = UDim2.new(0, 10, 0, 170)
status.Size = UDim2.new(1, -20, 0, 10)
status.Text = "Ready"
status.TextColor3 = Color3.new(1, 1, 1)
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left

local running = false
local count = 0
local attempted = 0

local function sendMsg(msg)
    attempted = attempted + 1
    local chatRemote = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(msg, "All")
            count = count + 1
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
                rbxGeneral:SendAsync(msg)
                count = count + 1
                return true
            end
        end
    end
    return false
end

startBtn.MouseButton1Click:Connect(function()
    if not running then
        running = true
        count = 0
        attempted = 0
        local delayTime = tonumber(delay.Text) or 2
        
        spawn(function()
            while running do
                sendMsg(msg1.Text)
                status.Text = "Sent " .. count .. " (tried " .. attempted .. ")"
                wait(delayTime)
                
                if running then
                    sendMsg(msg2.Text)
                    status.Text = "Sent " .. count .. " (tried " .. attempted .. ")"
                    wait(delayTime)
                end
            end
        end)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    status.Text = "Stopped. Sent " .. count .. " (tried " .. attempted .. ")"
end)
