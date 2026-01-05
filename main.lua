-- KBL Bypasser v6.0 - Advanced Delimiter Method
-- Replicates the {dm00text00dm} style with combining marks

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer

-- Advanced Bypass Settings
local Settings = {
    Enabled = true,
    AutoBypass = true,
    UseDelimiterMethod = true,
    DelimiterStart = "{dm",
    DelimiterEnd = "dm}",
    InvisibleChar = "\226\128\139", -- Zero-width space
    CombiningChar = "\204\131", -- Combining overline
    UseCustomFont = true
}

-- Custom Font Mapping (like what they're using)
local CustomFont = {
    ["a"] = "𝖆", ["A"] = "𝖆",
    ["b"] = "𝖇", ["B"] = "𝖇", 
    ["c"] = "𝖈", ["C"] = "𝖈",
    ["d"] = "𝖉", ["D"] = "𝖉",
    ["e"] = "𝖊", ["E"] = "𝖊",
    ["f"] = "𝖋", ["F"] = "𝖋",
    ["g"] = "𝖌", ["G"] = "𝖌",
    ["h"] = "𝖍", ["H"] = "𝖍",
    ["i"] = "𝖎", ["I"] = "𝖎",
    ["j"] = "𝖏", ["J"] = "𝖏",
    ["k"] = "𝖐", ["K"] = "𝖐",
    ["l"] = "𝖑", ["L"] = "𝖑",
    ["m"] = "𝖒", ["M"] = "𝖒",
    ["n"] = "𝖓", ["N"] = "𝖓",
    ["o"] = "𝖔", ["O"] = "𝖔",
    ["p"] = "𝖕", ["P"] = "𝖕",
    ["q"] = "𝖖", ["Q"] = "𝖖",
    ["r"] = "𝖗", ["R"] = "𝖗",
    ["s"] = "𝖘", ["S"] = "𝖘",
    ["t"] = "𝖙", ["T"] = "𝖙",
    ["u"] = "𝖚", ["U"] = "𝖚",
    ["v"] = "𝖛", ["V"] = "𝖛",
    ["w"] = "𝖜", ["W"] = "𝖜",
    ["x"] = "𝖝", ["X"] = "𝖝",
    ["y"] = "𝖞", ["Y"] = "𝖞",
    ["z"] = "𝖟", ["Z"] = "𝖟",
    [" "] = " ",
    ["!"] = "!",
    ["?"] = "?",
    ["."] = ".",
    [","] = ",",
    ["0"] = "𝟎",
    ["1"] = "𝟏", 
    ["2"] = "𝟐",
    ["3"] = "𝟑",
    ["4"] = "𝟒",
    ["5"] = "𝟓",
    ["6"] = "𝟔",
    ["7"] = "𝟕",
    ["8"] = "𝟖",
    ["9"] = "𝟗"
}

-- Advanced Bypass Function
local function AdvancedBypass(text)
    if not Settings.Enabled or text == "" then return text end
    
    -- Convert to custom font
    local converted = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        converted = converted .. (CustomFont[char] or char)
    end
    
    -- Apply delimiter method
    if Settings.UseDelimiterMethod then
        -- Add combining marks to the delimiters
        local startDelimiter = Settings.DelimiterStart .. Settings.CombiningChar
        local endDelimiter = Settings.CombiningChar .. Settings.DelimiterEnd
        
        -- Add invisible characters between delimiter and text
        local result = startDelimiter .. Settings.InvisibleChar .. Settings.InvisibleChar .. converted .. Settings.InvisibleChar .. Settings.InvisibleChar .. endDelimiter
        
        return result
    end
    
    return converted
end

-- Send Message Function
local function SendMessage(text)
    local bypassedText = AdvancedBypass(text)
    
    -- Try TextChatService
    pcall(function()
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then
            channel:SendAsync(bypassedText)
        end
    end)
    
    -- Try legacy chat
    pcall(function()
        local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvents then
            local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
            if sayMessage then
                sayMessage:FireServer(bypassedText, "All")
            end
        end
    end)
end

-- Hook Chat for Auto-Bypass
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if Settings.Enabled and Settings.AutoBypass and method == "FireServer" then
            local name = self.Name:lower()
            if string.find(name, "say") or string.find(name, "chat") or string.find(name, "message") then
                if type(args[1]) == "string" and args[1] ~= "" then
                    args[1] = AdvancedBypass(args[1])
                    return oldNamecall(self, unpack(args))
                end
            end
        end
        return oldNamecall(self, ...)
    end)
end)

-- Hook TextChatService
pcall(function()
    local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    if channel then
        local oldSend = channel.SendAsync
        channel.SendAsync = function(self, message, ...)
            if Settings.Enabled and Settings.AutoBypass and message ~= "" then
                message = AdvancedBypass(message)
            end
            return oldSend(self, message, ...)
        end
    end
end)

-- Create Simple UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KBLAdvancedBypasser"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Text = "KBL Advanced Bypasser v6.0"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 14
TitleLabel.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 50)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Text = "Status: Active\nMethod: Delimiter + Custom Font\nAuto-Bypass: ON"
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

local TestButton = Instance.new("TextButton")
TestButton.Size = UDim2.new(0, 120, 0, 30)
TestButton.Position = UDim2.new(0, 10, 0, 100)
TestButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
TestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TestButton.Text = "Test Bypass"
TestButton.Font = Enum.Font.SourceSansBold
TestButton.Parent = MainFrame

TestButton.MouseButton1Click:Connect(function()
    SendMessage("this is a test bypass message")
end)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 120, 0, 30)
CloseButton.Position = UDim2.new(0, 170, 0, 100)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "Close"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Startup notification
StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "[KBL Bypasser v6.0] Advanced delimiter method loaded!";
    Color = Color3.fromRGB(0, 255, 0);
    Font = Enum.Font.SourceSansBold;
})

print("═══════════════════════════")
print("KBL Advanced Bypasser v6.0")
print("Method: Delimiter + Custom Font")
print("Status: Active")
print("═══════════════════════════")
