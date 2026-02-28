-- Custom Chat Textbox GUI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomChatGui"
screenGui.Parent = playerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Name = "ChatFrame"
frame.Size = UDim2.new(0, 350, 0, 40)
frame.Position = UDim2.new(0, 20, 1, -60)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame

-- Textbox
local textbox = Instance.new("TextBox")
textbox.Name = "ChatInput"
textbox.Size = UDim2.new(1, -80, 1, -10)
textbox.Position = UDim2.new(0, 10, 0, 5)
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
sendButton.Size = UDim2.new(0, 60, 1, -10)
sendButton.Position = UDim2.new(1, -70, 0, 5)
sendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Text = "Send"
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 14
sendButton.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = sendButton

-- Function to send message to chat
local function sendMessage()
    local message = textbox.Text:gsub("^%s+", ""):gsub("%s+$", "") -- trim whitespace
    
    if message == "" then
        return
    end
    
    -- Method 1: Default Roblox Chat System
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(message, "All")
        end
    end
    
    -- Method 2: Fallback (textchat system)
    local TextChatService = game:GetService("TextChatService")
    if TextChatService then
        local channel = TextChatService:FindFirstChild("TextChannels")
        if channel then
            local rbxGeneral = channel:FindFirstChild("RBXGeneral")
            if rbxGeneral then
                rbxGeneral:SendAsync(message)
            end
        end
    end
    
    -- Clear textbox
    textbox.Text = ""
end

-- Button click
sendButton.MouseButton1Click:Connect(sendMessage)

-- Enter key to send
textbox.Focused:Connect(function()
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.Enter then
            if textbox:IsFocused() then
                sendMessage()
                connection:Disconnect()
            end
        end
    end)
end)

-- Toggle GUI with RightControl
local guiVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        frame.Visible = guiVisible
    end
end)

print("✅ Custom Chat GUI Loaded - Press RightControl to toggle")
