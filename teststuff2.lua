-- || MOBILE BLACK BOX LOGGER (Compact) ||
-- GUI Based Logger for Mobile

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local MAX_LOGS = 100
local TargetPlayer = nil
local Logs = {}

-- || GUI CREATION ||
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileLogger"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Toggle Button (Small)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "📜"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

-- Main Frame (450x260)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 260) -- Changed size
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -130) -- Centered
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 15)
titleFix.Position = UDim2.new(0, 0, 1, -15)
titleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "📋 LIVE LOGGER"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Parent = titleBar

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(0, 150, 1, 0)
targetLabel.Position = UDim2.new(1, -150, 0, 0)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
targetLabel.Text = "Target: None"
targetLabel.Font = Enum.Font.GothamBold
targetLabel.TextSize = 11
targetLabel.TextXAlignment = Enum.TextXAlignment.Right
targetLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 25)
closeBtn.Position = UDim2.new(1, -35, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Log Frame (Middle)
local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(1, -20, 1, -80) -- Adjusted to fit new height
logFrame.Position = UDim2.new(0, 10, 0, 40)
logFrame.BackgroundTransparency = 1
logFrame.ScrollBarThickness = 4
logFrame.Parent = mainFrame

local logLayout = Instance.new("UIListLayout")
logLayout.Padding = UDim.new(0, 2)
logLayout.Parent = logFrame

-- Bottom Buttons
local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, -20, 0, 30)
btnRow.Position = UDim2.new(0, 10, 1, -40)
btnRow.BackgroundTransparency = 1
btnRow.Parent = mainFrame

local selectTargetBtn = Instance.new("TextButton")
selectTargetBtn.Size = UDim2.new(0.5, -5, 1, 0)
selectTargetBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
selectTargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
selectTargetBtn.Text = "SELECT TARGET"
selectTargetBtn.Font = Enum.Font.GothamBold
selectTargetBtn.TextSize = 11
selectTargetBtn.Parent = btnRow
local selectCorner = Instance.new("UICorner")
selectCorner.CornerRadius = UDim.new(0, 6)
selectCorner.Parent = selectTargetBtn

local copyLogBtn = Instance.new("TextButton")
copyLogBtn.Size = UDim2.new(0.5, -5, 1, 0)
copyLogBtn.Position = UDim2.new(0.5, 5, 0, 0)
copyLogBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
copyLogBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyLogBtn.Text = "COPY LAST 10"
copyLogBtn.Font = Enum.Font.GothamBold
copyLogBtn.TextSize = 11
copyLogBtn.Parent = btnRow
local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyLogBtn

-- || FUNCTIONS ||

local function AddLog(text, color)
    color = color or Color3.fromRGB(255, 255, 255)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = logFrame
    
    game:GetService("RunService").RenderStepped:Wait()
    label.Size = UDim2.new(1, 0, 0, label.TextBounds.Y)
    
    table.insert(Logs, {Text = text, Color = color})
    
    if #Logs > MAX_LOGS then
        table.remove(Logs, 1)
        if logFrame:GetChildren()[1] then
            logFrame:GetChildren()[1]:Destroy()
        end
    end
    
    logFrame.CanvasSize = UDim2.new(0, 0, 0, logLayout.AbsoluteContentSize.Y)
    logFrame.CanvasPosition = Vector2.new(0, math.huge)
end

local function CopyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        return true
    else
        return false
    end
end

-- Chat Detection
local function OnChat(message, speakerName)
    local timeStr = os.date("%H:%M:%S")
    local logText = string.format("[%s] %s: %s", timeStr, speakerName, message)
    AddLog(logText, Color3.fromRGB(200, 200, 200))
end

-- Player Events
local function OnPlayerAdded(plr)
    local timeStr = os.date("%H:%M:%S")
    AddLog(string.format("--> %s JOINED", plr.Name), Color3.fromRGB(0, 255, 0))
end

local function OnPlayerRemoving(plr)
    local timeStr = os.date("%H:%M:%S")
    AddLog(string.format("<-- %s LEFT", plr.Name), Color3.fromRGB(255, 60, 60))
    
    if TargetPlayer and plr.Name == TargetPlayer then
        AddLog("!!! TARGET DETECTED LEAVING !!!", Color3.fromRGB(255, 255, 0))
        
        local receipt = "=== TARGET LEAVE LOG ===\n"
        receipt = receipt .. "Target: " .. plr.Name .. "\n"
        receipt = receipt .. "Time: " .. os.date("%c") .. "\n"
        receipt = receipt .. "=== LAST CHAT MESSAGES ===\n"
        
        local count = 0
        for i = #Logs, 1, -1 do
            if count >= 10 then break end
            receipt = receipt .. Logs[i].Text .. "\n"
            count = count + 1
        end
        
        if CopyToClipboard(receipt) then
            AddLog("[Copied Log to Clipboard!]", Color3.fromRGB(0, 255, 255))
        else
            AddLog("[Failed to Copy - Check Console]", Color3.fromRGB(255, 100, 0))
        end
        
        TargetPlayer = nil
        targetLabel.Text = "Target: None"
        targetLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        mainFrame.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
        wait(0.2)
        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end
end

-- Hook Chat
spawn(function()
    if TextChatService then
        TextChatService.OnIncomingMessage:Connect(function(msgObj)
            if msgObj and msgObj.Text and msgObj.PrefixText then
                local speaker = msgObj.PrefixText:gsub(":$", "")
                local text = msgObj.Text
                OnChat(text, speaker)
            end
        end)
    end
    
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents", true)
    if chatEvents then
        chatEvents.OnMessageDoneFiltering:Connect(function(data)
            if data and data.FromSpeaker and data.Message then
                OnChat(data.Message, data.FromSpeaker)
            end
        end)
    end
end)

-- || BUTTON EVENTS ||

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    toggleBtn.Visible = not mainFrame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    toggleBtn.Visible = true
end)

copyLogBtn.MouseButton1Click:Connect(function()
    local receipt = "=== MANUAL LOG COPY ===\n"
    local count = 0
    for i = #Logs, 1, -1 do
        if count >= 10 then break end
        receipt = receipt .. Logs[i].Text .. "\n"
        count = count + 1
    end
    
    if CopyToClipboard(receipt) then
        AddLog("[Manual Copy Successful]", Color3.fromRGB(0, 255, 255))
    else
        AddLog("[Copy Failed]", Color3.fromRGB(255, 100, 0))
    end
end)

-- Target Selection Dropdown
local playerDropdown = Instance.new("ScrollingFrame")
playerDropdown.Size = UDim2.new(1, 0, 0, 150)
playerDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerDropdown.Visible = false
playerDropdown.Position = UDim2.new(0, 0, 1, 0)
playerDropdown.ZIndex = 20
playerDropdown.Parent = btnRow
local dropCorner = Instance.new("UICorner")
dropCorner.Parent = playerDropdown
local dropLayout = Instance.new("UIListLayout")
dropLayout.Parent = playerDropdown

selectTargetBtn.MouseButton1Click:Connect(function()
    playerDropdown.Visible = not playerDropdown.Visible
    if playerDropdown.Visible then
        for _, child in pairs(playerDropdown:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 25)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Text = plr.Name
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 11
                btn.Parent = playerDropdown
                btn.MouseButton1Click:Connect(function()
                    TargetPlayer = plr.Name
                    targetLabel.Text = "Target: " .. plr.Name
                    targetLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    playerDropdown.Visible = false
                end)
            end
        end
    end
end)

-- Initialize Players
Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then
        OnPlayerAdded(plr)
    end
end

AddLog("Logger Initialized.", Color3.fromRGB(0, 200, 255))
