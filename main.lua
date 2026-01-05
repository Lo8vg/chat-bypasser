-- KBL Bypasser v11.0
-- Single method that actually works - NO word-by-word
-- Minimal pattern detection

-- Services
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer

-- ONE METHOD ONLY - Advanced but subtle
local function SingleBypass(text)
    -- Use a single method that's proven to work
    -- Minimal zero-width characters, mostly homoglyph replacement
    
    local replacements = {
        -- Common letters with single replacements (not multiple)
        ["a"] = "а",  -- Cyrillic 'a'
        ["e"] = "е",  -- Cyrillic 'e'
        ["o"] = "о",  -- Cyrillic 'o'
        ["p"] = "р",  -- Cyrillic 'p'
        ["c"] = "с",  -- Cyrillic 'c'
        ["x"] = "х",  -- Cyrillic 'x'
        ["y"] = "у",  -- Cyrillic 'y'
        ["A"] = "А",  -- Cyrillic 'A'
        ["B"] = "В",  -- Cyrillic 'B'
        ["C"] = "С",  -- Cyrillic 'C'
        ["E"] = "Е",  -- Cyrillic 'E'
        ["H"] = "Н",  -- Cyrillic 'H'
        ["K"] = "К",  -- Cyrillic 'K'
        ["M"] = "М",  -- Cyrillic 'M'
        ["O"] = "О",  -- Cyrillic 'O'
        ["P"] = "Р",  -- Cyrillic 'P'
        ["T"] = "Т",  -- Cyrillic 'T'
        ["X"] = "Х",  -- Cyrillic 'X'
        ["Y"] = "У",  -- Cyrillic 'Y'
    }
    
    -- Only replace certain letters, not all
    -- This makes the text look normal but bypasses filters
    local result = ""
    local replaceCount = 0
    
    for i = 1, #text do
        local char = text:sub(i, i)
        local lowerChar = char:lower()
        
        -- Only replace 20-30% of characters to avoid detection
        if replacements[lowerChar] and math.random(1, 4) == 1 and replaceCount < math.floor(#text * 0.3) then
            -- Uppercase stays uppercase, lowercase stays lowercase
            if char == char:upper() then
                -- Find uppercase replacement
                local upperChar = char
                for eng, cyr in pairs(replacements) do
                    if eng:upper() == upperChar then
                        result = result .. cyr:upper()
                        replaceCount = replaceCount + 1
                        break
                    end
                end
            else
                result = result .. replacements[lowerChar]
                replaceCount = replaceCount + 1
            end
        else
            result = result .. char
        end
        
        -- Add ZERO-WIDTH CHARACTERS ONLY at word boundaries
        if i < #text then
            local nextChar = text:sub(i + 1, i + 1)
            if char == " " or nextChar == " " or char == "." or char == "," or char == "!" or char == "?" then
                -- Add a single zero-width character occasionally
                if math.random(1, 10) == 1 then
                    result = result .. "\226\128\139"
                end
            end
        end
    end
    
    return result
end

-- TextChatService detection and sending
local function GetTextChannel()
    local channels = TextChatService:FindFirstChild("TextChannels")
    if channels then
        for _, channel in pairs(channels:GetChildren()) do
            if channel.Name == "RBXGeneral" then
                return channel
            end
        end
    end
    return nil
end

-- Send message through TextChatService
local function SendMessage(text)
    local channel = GetTextChannel()
    if channel then
        local bypassed = SingleBypass(text)
        local success, error = pcall(function()
            channel:SendAsync(bypassed)
        end)
        
        if success then
            return true, "Sent"
        else
            return false, error
        end
    end
    
    -- Fallback to legacy chat
    local chatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
        if sayMessage then
            local bypassed = SingleBypass(text)
            sayMessage:FireServer(bypassed, "All")
            return true, "Sent (legacy)"
        end
    end
    
    return false, "No chat system found"
end

-- Hook TextChatService automatically
local function HookChat()
    local channel = GetTextChannel()
    if channel then
        local originalSendAsync = channel.SendAsync
        
        channel.SendAsync = function(self, message, ...)
            if message and message ~= "" then
                local bypassed = SingleBypass(message)
                return originalSendAsync(self, bypassed, ...)
            end
            return originalSendAsync(self, message, ...)
        end
        return true
    end
    return false
end

-- Simple GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KBLSimpleBypasser"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.Size = UDim2.new(0, 350, 0, 200)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 30)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "KBL Bypasser v11.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 0)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Make draggable
local dragging = false
local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and dragInput and input.UserInputType == dragInput.UserInputType then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Content
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)

-- Input
local InputBox = Instance.new("TextBox")
InputBox.Name = "InputBox"
InputBox.Parent = ContentFrame
InputBox.Size = UDim2.new(1, -20, 0, 60)
InputBox.Position = UDim2.new(0, 10, 0, 10)
InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.Text = ""
InputBox.Font = Enum.Font.SourceSans
InputBox.TextSize = 14
InputBox.TextWrapped = true
InputBox.PlaceholderText = "Type your message here..."

-- Send Button
local SendButton = Instance.new("TextButton")
SendButton.Name = "SendButton"
SendButton.Parent = ContentFrame
SendButton.Size = UDim2.new(1, -20, 0, 40)
SendButton.Position = UDim2.new(0, 10, 0, 80)
SendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.Text = "SEND"
SendButton.Font = Enum.Font.SourceSansBold
SendButton.TextSize = 16

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = ContentFrame
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Position = UDim2.new(0, 10, 0, 130)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Test Messages
local TestFrame = Instance.new("Frame")
TestFrame.Name = "TestFrame"
TestFrame.Parent = ContentFrame
TestFrame.BackgroundTransparency = 1
TestFrame.Size = UDim2.new(1, -20, 0, 40)
TestFrame.Position = UDim2.new(0, 10, 1, -50)

local TestLabel = Instance.new("TextLabel")
TestLabel.Name = "TestLabel"
TestLabel.Parent = TestFrame
TestLabel.Size = UDim2.new(0.4, 0, 1, 0)
TestLabel.BackgroundTransparency = 1
TestLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TestLabel.Text = "Test:"
TestLabel.Font = Enum.Font.SourceSans
TestLabel.TextSize = 12
TestLabel.TextXAlignment = Enum.TextXAlignment.Left

local TestButtons = {"hi", "hello", "test"}
for i, testText in ipairs(TestButtons) do
    local TestButton = Instance.new("TextButton")
    TestButton.Name = "TestButton_" .. i
    TestButton.Parent = TestFrame
    TestButton.Size = UDim2.new(0.18, 0, 0.8, 0)
    TestButton.Position = UDim2.new(0.4 + (i-1)*0.2, 0, 0.1, 0)
    TestButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TestButton.Text = testText
    TestButton.Font = Enum.Font.SourceSans
    TestButton.TextSize = 12
    
    TestButton.MouseButton1Click:Connect(function()
        InputBox.Text = testText
        local success, result = SendMessage(testText)
        StatusLabel.Text = "Sent: " .. testText .. " - " .. result
    end)
end

-- Send functionality
SendButton.MouseButton1Click:Connect(function()
    if InputBox.Text ~= "" then
        local success, result = SendMessage(InputBox.Text)
        StatusLabel.Text = "Status: " .. result
        if success then
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end
end)

-- Hook chat automatically
task.spawn(function()
    wait(2)
    local hooked = HookChat()
    if hooked then
        StatusLabel.Text = "Auto-bypass: ON (TextChatService)"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        StatusLabel.Text = "Auto-bypass: OFF (Legacy chat)"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    end
end)

-- Simple test on load
StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "[KBL v11.0] Loaded - Single method, no word-by-word";
    Color = Color3.fromRGB(0, 255, 0);
    Font = Enum.Font.SourceSansBold;
})

print("══════════════════════════════════")
print("KBL Bypasser v11.0 - SIMPLE MODE")
print("Using single method: Homoglyph replacement")
print("NO word-by-word, NO multiple methods")
print("══════════════════════════════════")
