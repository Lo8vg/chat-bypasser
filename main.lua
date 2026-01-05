-- KBL Bypasser v13.0
-- Based on your feedback - Simple Homoglyphs + Adjective/Noun combos

-- Services
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer

-- Enhanced Simple Homoglyphs - Based on what's working
local function SimpleHomoglyphs(text)
    -- Focus on the letters that actually work
    local workingReplacements = {
        ["a"] = "а",  -- This works
        ["e"] = "е",  -- This works  
        ["o"] = "о",  -- This works
        ["p"] = "р",  -- This works
        ["c"] = "с",  -- This works
        ["x"] = "х",  -- This works
        ["y"] = "у",  -- This works
        ["s"] = "ѕ",  -- This works
        ["i"] = "і",  -- This works
        ["B"] = "В",  -- This works
        ["H"] = "Н",  -- This works
        ["K"] = "К",  -- This works
        ["M"] = "М",  -- This works
        ["T"] = "Т",  -- This works
        ["X"] = "Х",  -- This works
        ["Y"] = "У",  -- This works
        ["A"] = "А",  -- This works
        ["C"] = "С",  -- This works
        ["E"] = "Е",  -- This works
        ["O"] = "О",  -- This works
        ["P"] = "Р",  -- This works
        ["R"] = "Р",  -- This works
        ["g"] = "g",  -- Don't replace g (might cause issues)
        ["h"] = "h",  -- Don't replace h (might cause issues)
        ["l"] = "l",  -- Don't replace l (might cause issues)
        ["t"] = "t",  -- Don't replace t (might cause issues)
        ["u"] = "u",  -- Don't replace u (might cause issues)
        ["v"] = "v",  -- Don't replace v (might cause issues)
        ["w"] = "w",  -- Don't replace w (might cause issues)
        ["z"] = "z",  -- Don't replace z (might cause issues)
        ["n"] = "n",  -- Don't replace n (might cause issues)
        ["m"] = "m",  -- Don't replace m (might cause issues)
        ["d"] = "d",  -- Don't replace d (might cause issues)
        ["f"] = "f",  -- Don't replace f (might cause issues)
        ["j"] = "j",  -- Don't replace j (might cause issues)
        ["k"] = "k",  -- Don't replace k (might cause issues)
        ["q"] = "q",  -- Don't replace q (might cause issues)
        ["r"] = "r",  -- Don't replace r (might cause issues)
        ["b"] = "b",  -- Don't replace b (might cause issues)
    }
    
    -- Only replace the working letters, be conservative
    local result = ""
    local replaceCount = 0
    local maxReplacements = math.floor(#text * 0.4) -- Only replace 40% max
    
    for i = 1, #text do
        local char = text:sub(i, i)
        local lowerChar = char:lower()
        
        -- Only replace if we haven't replaced too many characters
        if workingReplacements[lowerChar] and replaceCount < maxReplacements then
            -- Be more selective about when to replace
            if math.random(1, 3) == 1 then -- Only replace 33% of eligible characters
                if char == char:upper() then
                    -- Find uppercase replacement
                    for eng, cyr in pairs(workingReplacements) do
                        if eng:upper() == char then
                            result = result .. cyr:upper()
                            replaceCount = replaceCount + 1
                            break
                        end
                    end
                else
                    result = result .. workingReplacements[lowerChar]
                    replaceCount = replaceCount + 1
                end
            else
                result = result .. char
            end
        else
            result = result .. char
        end
    end
    
    return result
end

-- Get TextChatService channel
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

-- Send message
local function SendMessage(text)
    local channel = GetTextChannel()
    if channel then
        local bypassed = SimpleHomoglyphs(text)
        local success, error = pcall(function()
            channel:SendAsync(bypassed)
        end)
        
        if success then
            return true, "Sent"
        else
            return false, error
        end
    end
    
    -- Fallback
    local chatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
        if sayMessage then
            local bypassed = SimpleHomoglyphs(text)
            sayMessage:FireServer(bypassed, "All")
            return true, "Sent (legacy)"
        end
    end
    
    return false, "No chat system found"
end

-- Hook chat
local function HookChat()
    local channel = GetTextChannel()
    if channel then
        local originalSendAsync = channel.SendAsync
        
        channel.SendAsync = function(self, message, ...)
            if message and message ~= "" then
                message = SimpleHomoglyphs(message)
            end
            return originalSendAsync(self, message, ...)
        end
        return true
    end
    return false
end

-- Create simple GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KBLTargetedBypasser"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.Size = UDim2.new(0, 400, 0, 350)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "KBL Bypasser v13.0 - Targeted"
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
CloseButton.Position = UDim2.new(1, -35, 0, 5)

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
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)

-- Working patterns info
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Name = "InfoLabel"
InfoLabel.Parent = ContentFrame
InfoLabel.Size = UDim2.new(1, -20, 0, 80)
InfoLabel.Position = UDim2.new(0, 10, 0, 10)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.Font = Enum.Font.SourceSans
InfoLabel.TextSize = 12
InfoLabel.TextWrapped = true
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.Text = "Working patterns:\n• Adjective + Noun (ugly whore, stupid hoe)\n• Action phrases (slit ur throat)\n• Racial terms (ape shitskin, subhman)\n• Focus on vowels + specific consonants"

-- Input
local InputBox = Instance.new("TextBox")
InputBox.Name = "InputBox"
InputBox.Parent = ContentFrame
InputBox.Size = UDim2.new(1, -20, 0, 60)
InputBox.Position = UDim2.new(0, 10, 0, 100)
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
SendButton.Position = UDim2.new(0, 10, 0, 170)
SendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.Text = "SEND"
SendButton.Font = Enum.Font.SourceSansBold
SendButton.TextSize = 16

-- Test buttons
local TestFrame = Instance.new("Frame")
TestFrame.Name = "TestFrame"
TestFrame.Parent = ContentFrame
TestFrame.BackgroundTransparency = 1
TestFrame.Size = UDim2.new(1, -20, 0, 80)
TestFrame.Position = UDim2.new(0, 10, 0, 220)

-- Quick test buttons
local testMessages = {
    "ugly whore",
    "stupid hoe", 
    "slit ur throat",
    "ape shitskin",
    "subhman"
}

for i, testMsg in ipairs(testMessages) do
    local TestButton = Instance.new("TextButton")
    TestButton.Name = "TestButton_" .. i
    TestButton.Parent = TestFrame
    TestButton.Size = UDim2.new(0.48, 0, 0, 30)
    TestButton.Position = UDim2.new((i-1) % 2 * 0.52, 0, math.floor((i-1) / 2) * 35, 0)
    TestButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TestButton.Text = testMsg
    TestButton.Font = Enum.Font.SourceSans
    TestButton.TextSize = 12
    
    TestButton.MouseButton1Click:Connect(function()
        InputBox.Text = testMsg
        local success, result = SendMessage(testMsg)
    end)
end

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = ContentFrame
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Position = UDim2.new(0, 10, 0, 310)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Send functionality
SendButton.MouseButton1Click:Connect(function()
    if InputBox.Text ~= "" then
        local success, result = SendMessage(InputBox.Text)
        StatusLabel.Text = "Status: " .. result
        StatusLabel.TextColor3 = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end
end)

-- Hook chat automatically
task.spawn(function()
    wait(2)
    local hooked = HookChat()
    if hooked then
        StatusLabel.Text = "Auto-bypass: ON (Simple Homoglyphs)"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        StatusLabel.Text = "Auto-bypass: OFF (Legacy chat)"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    end
end)

-- Startup message
StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "[KBL v13.0] Targeted bypasser loaded - Based on working patterns!";
    Color = Color3.fromRGB(0, 255, 0);
    Font = Enum.Font.SourceSansBold;
})

print("═══════════════════════════════════════")
print("KBL Bypasser v13.0 - TARGETED METHOD")
print("Based on your feedback:")
print("• Simple Homoglyphs working")
print("• Adjective + Noun patterns working")
print("• Action phrases working")
print("• Racial terms working")
print("═══════════════════════════════════════")
