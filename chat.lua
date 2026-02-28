-- Custom Chat GUI with Spam Feature

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
local spamConnection = nil

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomChatGui"
screenGui.Parent = playerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Name = "ChatFrame"
frame.Size = UDim2.new(0, 350, 0, 120)
frame.Position = UDim2.new(0, 20, 1, -140)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame

-- Character Counter
local charCounter = Instance.new("TextLabel")
charCounter.Name = "CharCounter"
charCounter.Size = UDim2.new(0, 60, 0, 20)
charCounter.Position = UDim2.new(1, -65, 0, 5)
charCounter.BackgroundTransparency = 1
charCounter.TextColor3 = Color3.fromRGB(150, 150, 150)
charCounter.Text = "0/200"
charCounter.Font = Enum.Font.Gotham
charCounter.TextSize = 12
charCounter.Parent = frame

-- Textbox
local textbox = Instance.new("TextBox")
textbox.Name = "ChatInput"
textbox.Size = UDim2.new(1, -80, 0, 30)
textbox.Position = UDim2.new(0, 10, 0, 10)
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
sendButton.Position = UDim2.new(1, -70, 0, 10)
sendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Text = "Send"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 14
sendButton.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = sendButton

-- Spam Section Label
local spamLabel = Instance.new("TextLabel")
spamLabel.Name = "SpamLabel"
spamLabel.Size = UDim2.new(1, -20, 0, 20)
spamLabel.Position = UDim2.new(0, 10, 0, 45)
spamLabel.BackgroundTransparency = 1
spamLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
spamLabel.Text = "─── SPAM SETTINGS ───"
spamLabel.Font = Enum.Font.GothamBold
spamLabel.TextSize = 12
spamLabel.Parent = frame

-- Spam Message Textbox
local spamTextbox = Instance.new("TextBox")
spamTextbox.Name = "SpamInput"
spamTextbox.Size = UDim2.new(1, -90, 0, 25)
spamTextbox.Position = UDim2.new(0, 10, 0, 68)
spamTextbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
spamTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
spamTextbox.Text = ""
spamTextbox.PlaceholderText = "Spam message..."
spamTextbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
spamTextbox.Font = Enum.Font.Gotham
spamTextbox.TextSize = 12
spamTextbox.TextXAlignment = Enum.TextXAlignment.Left
spamTextbox.ClearTextOnFocus = false
spamTextbox.Parent = frame

local spamTextboxCorner = Instance.new("UICorner")
spamTextboxCorner.CornerRadius = UDim.new(0, 6)
spamTextboxCorner.Parent = spamTextbox

-- Spam Delay Textbox
local delayTextbox = Instance.new("TextBox")
delayTextbox.Name = "DelayInput"
delayTextbox.Size = UDim2.new(0, 50, 0, 25)
delayTextbox.Position = UDim2.new(1, -140, 0, 68)
delayTextbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
delayTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayTextbox.Text = "1"
delayTextbox.PlaceholderText = "Delay"
delayTextbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
delayTextbox.Font = Enum.Font.Gotham
delayTextbox.TextSize = 12
delayTextbox.ClearTextOnFocus = false
delayTextbox.Parent = frame

local delayTextboxCorner = Instance.new("UICorner")
delayTextboxCorner.CornerRadius = UDim.new(0, 6)
delayTextboxCorner.Parent = delayTextbox

-- Spam Toggle Button
local spamButton = Instance.new("TextButton")
spamButton.Name = "SpamButton"
spamButton.Size = UDim2.new(0, 60, 0, 25)
spamButton.Position = UDim2.new(1, -70, 0, 68)
spamButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
spamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spamButton.Text = "OFF"
spamButton.Font = Enum.Font.GothamBold
spamButton.TextSize = 12
spamButton.Parent = frame

local spamButtonCorner = Instance.new("UICorner")
spamButtonCorner.CornerRadius = UDim.new(0, 6)
spamButtonCorner.Parent = spamButton

-- Character limit for main textbox
textbox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = textbox.Text
    if #text > MAX_CHARS then
        textbox.Text = text:sub(1, MAX_CHARS)
    end
    charCounter.Text = #textbox.Text.."/"..MAX_CHARS
    
    -- Change color when near limit
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
    
    -- Truncate to max chars
    if #message > MAX_CHARS then
        message = message:sub(1, MAX_CHARS)
    end
    
    -- Method 1: Default Roblox Chat System
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(message, "All")
            return true
        end
    end
    
    -- Method 2: TextChat system
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
        
        spamButton.Text = "ON"
        spamButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
        -- Start spam loop
        spawn(function()
            while spamEnabled do
                sendMessage(spamMessage)
                wait(spamDelay)
            end
        end)
    else
        spamButton.Text = "OFF"
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
