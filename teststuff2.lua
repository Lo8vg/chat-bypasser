-- || THE BLACK BOX LOGGER ||
-- Automatically saves proof when players leave.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local LOG_FOLDER = "RobloxLogs" -- Folder name in your workspace
local LOG_CHAT_HISTORY = 50 -- How many previous messages to save in the "Last Moments" file

-- State
local ChatHistory = {}
local TargetPlayer = nil
local LoggingEnabled = true

-- || GUI ||
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlackBoxUI"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(1, -260, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "📦 BLACK BOX LOGGER"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 6)
titleCorner.Parent = title

-- Target Display
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, -20, 0, 25)
targetLabel.Position = UDim2.new(0, 10, 0, 40)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
targetLabel.Text = "Target: None"
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextSize = 12
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = mainFrame

-- Buttons
local selectBtn = Instance.new("TextButton")
selectBtn.Size = UDim2.new(1, -20, 0, 30)
selectBtn.Position = UDim2.new(0, 10, 0, 70)
selectBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
selectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
selectBtn.Text = "SELECT TARGET"
selectBtn.Font = Enum.Font.GothamBold
selectBtn.TextSize = 12
selectBtn.Parent = mainFrame
local selectCorner = Instance.new("UICorner")
selectCorner.CornerRadius = UDim.new(0, 4)
selectCorner.Parent = selectBtn

local openFolderBtn = Instance.new("TextButton")
openFolderBtn.Size = UDim2.new(1, -20, 0, 30)
openFolderBtn.Position = UDim2.new(0, 10, 0, 105)
openFolderBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
openFolderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openFolderBtn.Text = "OPEN LOG FOLDER"
openFolderBtn.Font = Enum.Font.GothamBold
openFolderBtn.TextSize = 12
openFolderBtn.Parent = mainFrame
local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 4)
openCorner.Parent = openFolderBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 140)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.Text = "Logging Active..."
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- || FUNCTIONS ||

-- Function to write files
local function writeLog(filename, content)
    -- Uses 'writefile' which is standard in most executors
    if writefile then
        -- Create folder check (simulated by including folder path in filename)
        -- Note: Some executors require makefolder first
        if not isfolder(LOG_FOLDER) then
            if makefolder then
                makefolder(LOG_FOLDER)
            end
        end
        
        writefile(LOG_FOLDER .. "/" .. filename, content)
    else
        warn("Executor does not support 'writefile'")
    end
end

-- Function to capture chat messages
local function onChat(messageObj, speakerName)
    if not LoggingEnabled then return end
    
    -- Check if speaker is valid
    if not speakerName then return end
    
    local timestamp = os.date("%H:%M:%S")
    local logEntry = string.format("[%s] %s: %s", timestamp, speakerName, messageObj)
    
    -- Add to history
    table.insert(ChatHistory, logEntry)
    if #ChatHistory > LOG_CHAT_HISTORY then
        table.remove(ChatHistory, 1)
    end
end

-- Function to handle Player Leaving
local function onPlayerRemoving(plr)
    local timestamp = os.date("%H_%M_%S") -- Use underscores for filename safety
    local dateStamp = os.date("%Y-%m-%d")
    
    -- Basic Log
    local basicContent = string.format("PLAYER LEFT: %s\nTime: %s %s", plr.Name, dateStamp, timestamp)
    writeLog(string.format("Leave_%s_%s.txt", plr.Name, timestamp), basicContent)
    
    statusLabel.Text = "Saved log for: " .. plr.Name
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    
    -- Target Log (The "Receipt")
    if TargetPlayer and plr.Name == TargetPlayer then
        local receiptContent = "=== TARGET LEAVE RECEIPT ===\n"
        receiptContent = receiptContent .. "Target: " .. plr.Name .. "\n"
        receiptContent = receiptContent .. "Time: " .. os.date("%c") .. "\n\n"
        receiptContent = receiptContent .. "=== LAST " .. #ChatHistory .. " MESSAGES ===\n"
        
        for _, msg in pairs(ChatHistory) do
            receiptContent = receiptContent .. msg .. "\n"
        end
        
        -- Save "Receipt"
        writeLog(string.format("RECEIPT_%s_%s.txt", plr.Name, timestamp), receiptContent)
        
        -- Flash screen
        local flash = Instance.new("Frame")
        flash.Size = UDim2.new(1, 0, 1, 0)
        flash.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        flash.BackgroundTransparency = 0.5
        flash.Parent = screenGui
        flash.ZIndex = 100
        
        game:GetService("Debris"):AddItem(flash, 0.2)
        
        TargetPlayer = nil
        targetLabel.Text = "Target: None (Logged)"
    end
end

-- Chat Detection Hook
-- (Works for both TextChatService and Legacy Chat)
spawn(function()
    if TextChatService then
        TextChatService.OnIncomingMessage:Connect(function(message)
            local text = message.Text
            local speaker = message.PrefixText
            
            -- Clean speaker name (usually "PlayerName:" or "[Rank] PlayerName:")
            local cleanName = speaker:gsub(":$", ""):gsub("^%[.-%]%s*", "")
            if cleanName == "" then cleanName = "Unknown" end
            
            onChat(text, cleanName)
        end)
    elseif ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") then
        ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering:Connect(function(data)
            if data and data.FromSpeaker and data.Message then
                onChat(data.Message, data.FromSpeaker)
            end
        end)
    end
end)

-- Player List for Selection
local playerDropdown = Instance.new("ScrollingFrame")
playerDropdown.Size = UDim2.new(1, 0, 0, 150)
playerDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerDropdown.Visible = false
playerDropdown.Parent = mainFrame
playerDropdown.ZIndex = 10
local dropCorner = Instance.new("UICorner")
dropCorner.Parent = playerDropdown
local dropLayout = Instance.new("UIListLayout")
dropLayout.Parent = playerDropdown

selectBtn.MouseButton1Click:Connect(function()
    playerDropdown.Visible = not playerDropdown.Visible
    if playerDropdown.Visible then
        -- Populate list
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
                btn.TextSize = 12
                btn.Parent = playerDropdown
                btn.MouseButton1Click:Connect(function()
                    TargetPlayer = plr.Name
                    targetLabel.Text = "Target: " .. plr.Name
                    targetLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                    playerDropdown.Visible = false
                end)
            end
        end
    end
end)

openFolderBtn.MouseButton1Click:Connect(function()
    -- Some executors use 'loadfile' or specific folder opening commands
    -- 'listfiles' might work to list, but we can't open the folder externally easily.
    -- Best we can do is print the path.
    print("Logs are saved in your Workspace folder inside: " .. LOG_FOLDER)
    -- Notification on screen
    local notify = Instance.new("TextLabel")
    notify.Size = UDim2.new(0, 300, 0, 40)
    notify.Position = UDim2.new(0.5, -150, 0, 50)
    notify.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notify.TextColor3 = Color3.fromRGB(255, 255, 255)
    notify.Text = "Check Console for File Path (F9)"
    notify.Font = Enum.Font.GothamBold
    notify.TextSize = 14
    notify.Parent = screenGui
    notify.ZIndex = 50
    game:GetService("Debris"):AddItem(notify, 3)
end)

-- Connections
Players.PlayerRemoving:Connect(onPlayerRemoving)

print("|| BLACK BOX LOGGER ACTIVE ||")
print("Files will save to: " .. LOG_FOLDER)
