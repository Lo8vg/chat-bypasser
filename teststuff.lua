-- || CONFIGURATION ||
-- Edit the messages inside the curly braces below. Add as many as you want, separated by commas.
local LeaveMessages = {
    "Player has left the game!",
    "Goodbye!",
    "See ya later!",
    "Rage quit?",
    "Nice fight, but they ran away.",
    "Wow, someone actually left."
}

local DefaultDelay = 1.0 -- Default delay in seconds (can be changed in GUI)

-- || SERVICES ||
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- || STATE ||
local SelectedPlayers = {} -- Stores names of selected players

-- || GUI CREATION ||
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LeaveAnnouncer"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 120, 0, 35)
toggleBtn.Position = UDim2.new(0, 10, 0, 200)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "Leave Announcer"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 350)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -35, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "🎯 Leave Announcer"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -28, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Delay Frame
local delayFrame = Instance.new("Frame")
delayFrame.Size = UDim2.new(1, -20, 0, 40)
delayFrame.Position = UDim2.new(0, 10, 0, 40)
delayFrame.BackgroundTransparency = 1
delayFrame.Parent = mainFrame

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 80, 1, 0)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
delayLabel.Text = "Delay (s):"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 12
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = delayFrame

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(1, -90, 1, 0)
delayBox.Position = UDim2.new(0, 80, 0, 0)
delayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBox.Text = tostring(DefaultDelay)
delayBox.Font = Enum.Font.Gotham
delayBox.TextSize = 12
delayBox.PlaceholderText = "1.0"
delayBox.Parent = delayFrame

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 4)
delayCorner.Parent = delayBox

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 85)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Text = "Tracking: 0 players"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Player List
local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(1, -20, 1, -120)
listFrame.Position = UDim2.new(0, 10, 0, 110)
listFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
listFrame.Parent = mainFrame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 6)
listCorner.Parent = listFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.Parent = listFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 4)
scrollCorner.Parent = scrollFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 2)
layout.Parent = scrollFrame

-- || FUNCTIONS ||
local function sendChatMessage(msg)
    -- Method 1: TextChatService (Newer games)
    local textChannel = TextChatService:FindFirstChild("TextChannels")
    if textChannel then
        local rbxGeneral = textChannel:FindFirstChild("RBXGeneral")
        if rbxGeneral then
            rbxGeneral:SendAsync(msg)
            return
        end
    end

    -- Method 2: DefaultChatSystemChatEvents (Older games)
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(msg, "All")
        end
    end
end

local function onPlayerLeaving(plrName)
    -- Check if we are tracking this player
    if SelectedPlayers[plrName] then
        -- Get delay
        local delayTime = tonumber(delayBox.Text) or 1.0
        if delayTime < 0.1 then delayTime = 0.1 end

        -- Fire messages in a new thread so we don't hang the game
        spawn(function()
            for i, msg in ipairs(LeaveMessages) do
                -- Replace generic text with player name if needed (optional)
                local finalMsg = msg
                
                -- Send message
                sendChatMessage(finalMsg)
                
                -- Wait for delay (except on last message)
                if i < #LeaveMessages then
                    wait(delayTime)
                end
            end
        end)
        
        -- Remove from tracking list since they left
        SelectedPlayers[plrName] = nil
        updateStatus()
    end
end

-- Update Status Label
function updateStatus()
    local count = 0
    for _ in pairs(SelectedPlayers) do count = count + 1 end
    statusLabel.Text = "Tracking: " .. count .. " players"
end

-- Refresh Player List GUI
function refreshList()
    -- Clear existing buttons
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Add current players
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.Parent = scrollFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn
            
            -- Toggle Selection
            if SelectedPlayers[plr.Name] then
                btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- Blue if selected
            else
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Gray if not
            end
            
            btn.MouseButton1Click:Connect(function()
                if SelectedPlayers[plr.Name] then
                    -- Deselect
                    SelectedPlayers[plr.Name] = nil
                    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                else
                    -- Select
                    SelectedPlayers[plr.Name] = true
                    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                end
                updateStatus()
            end)
        end
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

-- || EVENTS ||
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

Players.PlayerAdded:Connect(function(plr)
    wait(1)
    refreshList()
end)

Players.PlayerRemoving:Connect(function(plr)
    onPlayerLeaving(plr.Name)
    refreshList()
end)

-- Dragging Logic
local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Initialize
refreshList()
print("✅ Leave Announcer Loaded")
