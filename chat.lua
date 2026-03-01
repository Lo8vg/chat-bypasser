-- Custom Chat GUI (Wide + Big Textbox)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local MAX_CHARS = 200
local spamEnabled = false
local spamDelay = 1
local justSent = false

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomChatGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame (wide)
local frame = Instance.new("Frame")
frame.Name = "ChatFrame"
frame.Size = UDim2.new(0, 420, 0, 80)
frame.Position = UDim2.new(0.5, -210, 0.5, -40)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(60, 60, 60)
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

-- Textbox (big, centered)
local textbox = Instance.new("TextBox")
textbox.Name = "ChatInput"
textbox.Size = UDim2.new(1, -30, 0, 35)
textbox.Position = UDim2.new(0, 15, 0, 10)
textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox.Text = ""
textbox.PlaceholderText = "Message..."
textbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
textbox.Font = Enum.Font.Gotham
textbox.TextSize = 16
textbox.TextXAlignment = Enum.TextXAlignment.Left
textbox.ClearTextOnFocus = false
textbox.ReturnKeyType = Enum.ReturnKeyType.Send
textbox.MultiLine = false
textbox.Parent = frame

local textboxCorner = Instance.new("UICorner")
textboxCorner.CornerRadius = UDim.new(0, 8)
textboxCorner.Parent = textbox

-- Bottom row frame
local bottomFrame = Instance.new("Frame")
bottomFrame.Name = "BottomFrame"
bottomFrame.Size = UDim2.new(1, -30, 0, 28)
bottomFrame.Position = UDim2.new(0, 15, 0, 50)
bottomFrame.BackgroundTransparency = 1
bottomFrame.Parent = frame

-- Send Button
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0, 70, 0, 28)
sendButton.Position = UDim2.new(0, 0, 0, 0)
sendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Text = "Send"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 13
sendButton.Parent = bottomFrame

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 6)
sendCorner.Parent = sendButton

-- Delay Label
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 40, 0, 28)
delayLabel.Position = UDim2.new(0, 80, 0, 0)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
delayLabel.Text = "Delay:"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 12
delayLabel.Parent = bottomFrame

-- Delay Textbox
local delayTextbox = Instance.new("TextBox")
delayTextbox.Size = UDim2.new(0, 40, 0, 28)
delayTextbox.Position = UDim2.new(0, 122, 0, 0)
delayTextbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayTextbox.Text = "1"
delayTextbox.PlaceholderText = "1"
delayTextbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
delayTextbox.Font = Enum.Font.Gotham
delayTextbox.TextSize = 12
delayTextbox.ClearTextOnFocus = false
delayTextbox.Parent = bottomFrame

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 6)
delayCorner.Parent = delayTextbox

-- Spam Button
local spamButton = Instance.new("TextButton")
spamButton.Size = UDim2.new(0, 90, 0, 28)
spamButton.Position = UDim2.new(0.5, -45, 0, 0)
spamButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
spamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spamButton.Text = "SPAM: OFF"
spamButton.Font = Enum.Font.GothamBold
spamButton.TextSize = 12
spamButton.Parent = bottomFrame

local spamCorner = Instance.new("UICorner")
spamCorner.CornerRadius = UDim.new(0, 6)
spamCorner.Parent = spamButton

-- Char Counter
local charCounter = Instance.new("TextLabel")
charCounter.Size = UDim2.new(0, 50, 0, 28)
charCounter.Position = UDim2.new(1, -50, 0, 0)
charCounter.BackgroundTransparency = 1
charCounter.TextColor3 = Color3.fromRGB(150, 150, 150)
charCounter.Text = "0/200"
charCounter.Font = Enum.Font.Gotham
charCounter.TextSize = 11
charCounter.Parent = bottomFrame

-- Dragging (on main frame)
local dragging = false
local dragInput
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
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

frame.InputChanged:Connect(function(input)
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

-- Character limit
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

-- Send message function
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
    if textbox.Text ~= "" then
        sendMessage()
        justSent = true
    end
end)

-- FocusLost - sends message when mobile keyboard "send" is pressed
textbox.FocusLost:Connect(function(enterPressed)
    if textbox.Text ~= "" and enterPressed then
        sendMessage()
        justSent = true
    end
end)

-- Focused - clear text when clicking to type again
textbox.Focused:Connect(function()
    if justSent then
        justSent = false
        textbox.Text = ""
    end
end)

-- Spam toggle
local function toggleSpam()
    spamEnabled = not spamEnabled
    
    if spamEnabled then
        spamDelay = tonumber(delayTextbox.Text) or 1
        if spamDelay < 0.1 then
            spamDelay = 0.1
        end
        
        spamButton.Text = "SPAM: ON"
        spamButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
        spawn(function()
            while spamEnabled do
                local msg = textbox.Text
                if msg ~= "" then
                    sendMessage(msg)
                end
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

print("✅ Custom Chat GUI Loaded (Wide Layout)")
