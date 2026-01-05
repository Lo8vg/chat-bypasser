-- KBL Bypasser v5.0 - Custom Library Edition
-- Custom UI Library by KBL Team
-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- Settings
local Settings = {
    Enabled = true,
    AutoBypass = true,
    AutoResetFilter = false,
    Language = "Kazakh", -- Default language
    UseUnicode = true,
    UseHomoglyphs = true,
    UseInvisible = true,
    UseCombiningMarks = true
}

-- Extended Homoglyphs
local Homoglyphs = {
    ["a"] = {"а", "ạ", "ά", "ä", "ȃ", "ǎ", "ᵃ", "ᴀ", "α", "ⓐ", "ａ"},
    ["b"] = {"ḅ", "ƅ", "ḃ", "ᵇ", "ɓ", "ʙ", "β", "ⓑ", "ｂ"},
    ["c"] = {"с", "ç", "ċ", "ć", "ᶜ", "ƈ", "ᴄ", "ⓒ", "ｃ"},
    ["d"] = {"ḍ", "đ", "ḋ", "ᵈ", "ɗ", "ᴅ", "ⓓ", "ｄ"},
    ["e"] = {"е", "ẹ", "ė", "ё", "ə", "ᵉ", "ɛ", "ᴇ", "ε", "ⓔ", "ｅ"},
    ["f"] = {"ḟ", "ƒ", "ᶠ", "ꜰ", "ⓕ", "ｆ"},
    ["g"] = {"ġ", "ğ", "ǵ", "ᵍ", "ɠ", "ɢ", "ⓖ", "ｇ"},
    ["h"] = {"һ", "ḥ", "ḣ", "ʰ", "ɦ", "ʜ", "ⓗ", "ｈ"},
    ["i"] = {"і", "ị", "ï", "ı", "ᵢ", "ɪ", "ι", "ⓘ", "ｉ"},
    ["j"] = {"ј", "ĵ", "ʲ", "ɉ", "ᴊ", "ⓙ", "ｊ"},
    ["k"] = {"κ", "ķ", "ḳ", "ᵏ", "ƙ", "ᴋ", "ⓚ", "ｋ"},
    ["l"] = {"ḷ", "ļ", "ł", "ˡ", "ɫ", "ʟ", "ⓛ", "ｌ"},
    ["m"] = {"ṃ", "ṁ", "ᵐ", "ɱ", "ᴍ", "ⓜ", "ｍ"},
    ["n"] = {"ṅ", "ñ", "ń", "ⁿ", "ɲ", "ɴ", "η", "ⓝ", "ｎ"},
    ["o"] = {"о", "ọ", "ö", "ȯ", "ᵒ", "ɵ", "ᴏ", "σ", "ο", "ⓞ", "ｏ"},
    ["p"] = {"р", "ṗ", "ᵖ", "ƥ", "ᴘ", "ρ", "ⓟ", "ｐ"},
    ["q"] = {"ԛ", "ɋ", "ᑫ", "ⓠ", "ｑ"},
    ["r"] = {"ṛ", "ŕ", "ṙ", "ʳ", "ɾ", "ʀ", "ⓡ", "ｒ"},
    ["s"] = {"ѕ", "ṡ", "ś", "ˢ", "ʂ", "ꜱ", "ς", "ⓢ", "ｓ"},
    ["t"] = {"ṭ", "ţ", "ṫ", "ᵗ", "ƭ", "ᴛ", "τ", "ⓣ", "ｔ"},
    ["u"] = {"ụ", "ü", "ů", "ᵘ", "ʉ", "ᴜ", "υ", "ⓤ", "ｕ"},
    ["v"] = {"ṿ", "ᵛ", "ⱱ", "ᴠ", "ν", "ⓥ", "ｖ"},
    ["w"] = {"ẃ", "ẅ", "ʷ", "ɯ", "ᴡ", "ω", "ⓦ", "ｗ"},
    ["x"] = {"х", "ẋ", "ˣ", "χ", "ⓧ", "ｘ"},
    ["y"] = {"у", "ý", "ÿ", "ʸ", "ɏ", "ʏ", "γ", "ⓨ", "ｙ"},
    ["z"] = {"ẓ", "ż", "ź", "ᶻ", "ƶ", "ᴢ", "ⓩ", "ｚ"}
}

-- Invisible Characters
local Invisibles = {
    "\226\128\139", -- Zero-width space
    "\226\128\140", -- Zero-width non-joiner
    "\226\128\141", -- Zero-width joiner
    "\226\129\160", -- Word joiner
    "\194\173" -- Soft hyphen
}

-- Combining Marks
local CombiningMarks = {
    "\204\129", -- Acute
    "\204\128", -- Grave
    "\204\132", -- Macron
    "\204\135", -- Dot above
    "\204\163" -- Dot below
}

-- Language Specific Homoglyphs
local LanguageHomoglyphs = {
    Kazakh = {
        ["a"] = {"ä", "å", "ą", "à", "á", "â", "ã", "ā"},
        ["e"] = {"ė", "ę", "ě", "è", "é", "ê", "ë", "ē"},
        ["i"] = {"ï", "į", "ì", "í", "î", "ǐ"},
        ["o"] = {"ö", "ő", "ø", "ò", "ó", "ô", "õ", "ō"},
        ["u"] = {"ü", "ų", "ù", "ú", "û", "ū"},
        ["s"] = {"ş", "š"},
        ["c"] = {"ç", "ć", "č"},
        ["z"] = {"ż", "ź", "ž"},
        ["g"] = {"ğ"},
        ["n"] = {"ń", "ň", "ñ"}
    },
    Albanian = {
        ["c"] = {"ç", "ć", "č"},
        ["e"] = {"ë", "ę", "è", "é", "ê", "ē"},
        ["s"] = {"ş", "š"},
        ["r"] = {"ř"},
        ["z"] = {"ż", "ź", "ž"},
        ["g"] = {"ǵ", "ğ"},
        ["d"] = {"đ"}
    }
}

-- Custom UI Library
local KBLUI = {}
KBLUI.__index = KBLUI

function KBLUI:CreateWindow(config)
    local self = setmetatable({}, KBLUI)
    
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "KBLUI"
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Window
    self.MainWindow = Instance.new("Frame")
    self.MainWindow.Name = "MainWindow"
    self.MainWindow.Size = UDim2.new(0, 400, 0, 500)
    self.MainWindow.Position = UDim2.new(0.5, -200, 0.5, -250)
    self.MainWindow.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.MainWindow.BorderSizePixel = 0
    self.MainWindow.Parent = self.ScreenGui
    
    -- Shadow Effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceScale = 0.05
    shadow.Parent = self.MainWindow
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainWindow
    
    -- Title Text
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Name = "TitleText"
    self.TitleText.Size = UDim2.new(1, -80, 1, 0)
    self.TitleText.Position = UDim2.new(0, 10, 0, 0)
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Text = config.Name or "KBL Bypasser"
    self.TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleText.Font = Enum.Font.SourceSansBold
    self.TitleText.TextSize = 18
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.Parent = self.TitleBar
    
    -- Close Button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -35, 0, 5)
    self.CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    self.CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.CloseButton.Text = "X"
    self.CloseButton.Font = Enum.Font.SourceSansBold
    self.CloseButton.TextSize = 16
    self.CloseButton.Parent = self.TitleBar
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Make window draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainWindow.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and dragInput and input.UserInputType == dragInput.UserInputType then
            local delta = input.Position - dragStart
            self.MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Content Frame
    self.ContentFrame = Instance.new("ScrollingFrame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -20, 1, -60)
    self.ContentFrame.Position = UDim2.new(0, 10, 0, 50)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.ScrollBarThickness = 6
    self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentFrame.Parent = self.MainWindow
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = self.ContentFrame
    
    self.Elements = {}
    
    return self
end

function KBLUI:CreateSection(title)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = "Section_" .. title
    sectionFrame.Size = UDim2.new(1, 0, 0, 30)
    sectionFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sectionFrame.BorderSizePixel = 0
    sectionFrame.Parent = self.ContentFrame
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Name = "SectionLabel"
    sectionLabel.Size = UDim2.new(1, -10, 1, 0)
    sectionLabel.Position = UDim2.new(0, 5, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = "⚡ " .. title
    sectionLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
    sectionLabel.Font = Enum.Font.SourceSansBold
    sectionLabel.TextSize = 16
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = sectionFrame
    
    table.insert(self.Elements, sectionFrame)
    self:UpdateCanvasSize()
    
    return sectionFrame
end

function KBLUI:CreateToggle(config)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle_" .. config.Name
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = self.ContentFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = config.Name
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.Font = Enum.Font.SourceSans
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 60, 0, 30)
    toggleButton.Position = UDim2.new(1, -70, 0, 5)
    toggleButton.BackgroundColor3 = config.CurrentValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = config.CurrentValue and "ON" or "OFF"
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextSize = 14
    toggleButton.Parent = toggleFrame
    
    toggleButton.MouseButton1Click:Connect(function()
        config.CurrentValue = not config.CurrentValue
        toggleButton.BackgroundColor3 = config.CurrentValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        toggleButton.Text = config.CurrentValue and "ON" or "OFF"
        if config.Callback then
            config.Callback(config.CurrentValue)
        end
    end)
    
    table.insert(self.Elements, toggleFrame)
    self:UpdateCanvasSize()
    
    return toggleFrame
end

function KBLUI:CreateButton(config)
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. config.Name
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = config.Name
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.Parent = self.ContentFrame
    
    button.MouseButton1Click:Connect(function()
        if config.Callback then
            config.Callback()
        end
    end)
    
    table.insert(self.Elements, button)
    self:UpdateCanvasSize()
    
    return button
end

function KBLUI:CreateDropdown(config)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "Dropdown_" .. config.Name
    dropdownFrame.Size = UDim2.new(1, 0, 0, 60)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = self.ContentFrame
    
    local dropdownLabel = Instance.new("TextLabel")
    dropdownLabel.Name = "DropdownLabel"
    dropdownLabel.Size = UDim2.new(1, -10, 0, 25)
    dropdownLabel.Position = UDim2.new(0, 5, 0, 5)
    dropdownLabel.BackgroundTransparency = 1
    dropdownLabel.Text = config.Name
    dropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownLabel.Font = Enum.Font.SourceSans
    dropdownLabel.TextSize = 14
    dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    dropdownLabel.Parent = dropdownFrame
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(1, -10, 0, 30)
    dropdownButton.Position = UDim2.new(0, 5, 0, 30)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.Text = config.Options[config.Default] or config.Options[1]
    dropdownButton.Font = Enum.Font.SourceSans
    dropdownButton.TextSize = 14
    dropdownButton.Parent = dropdownFrame
    
    dropdownButton.MouseButton1Click:Connect(function()
        -- Simple dropdown implementation
        local selected = config.Options[config.Default] or config.Options[1]
        if config.Callback then
            config.Callback(selected)
        end
    end)
    
    table.insert(self.Elements, dropdownFrame)
    self:UpdateCanvasSize()
    
    return dropdownFrame
end

function KBLUI:CreateParagraph(config)
    local paragraphFrame = Instance.new("Frame")
    paragraphFrame.Name = "Paragraph_" .. config.Name
    paragraphFrame.Size = UDim2.new(1, 0, 0, 80)
    paragraphFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    paragraphFrame.BorderSizePixel = 0
    paragraphFrame.Parent = self.ContentFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -10, 0, 25)
    titleLabel.Position = UDim2.new(0, 5, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.Title
    titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = paragraphFrame
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "ContentLabel"
    contentLabel.Size = UDim2.new(1, -10, 1, -35)
    contentLabel.Position = UDim2.new(0, 5, 0, 30)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = config.Content
    contentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    contentLabel.Font = Enum.Font.SourceSans
    contentLabel.TextSize = 12
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.TextWrapped = true
    contentLabel.Parent = paragraphFrame
    
    table.insert(self.Elements, paragraphFrame)
    self:UpdateCanvasSize()
    
    return paragraphFrame
end

function KBLUI:Notify(config)
    local notification = Instance.new("ScreenGui")
    notification.Name = "KBLNotification"
    notification.Parent = game:GetService("CoreGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(1, 310, 1, -120)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(128, 0, 128)
    frame.Parent = notification
    
    local glow = Instance.new("UIStroke")
    glow.Color = Color3.fromRGB(200, 100, 255)
    glow.Thickness = 2
    glow.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "⚠️ " .. config.Title
    titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 18
    titleLabel.Parent = frame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 1, -40)
    messageLabel.Position = UDim2.new(0, 10, 0, 35)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = config.Content
    messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageLabel.Font = Enum.Font.SourceSans
    messageLabel.TextSize = 16
    messageLabel.TextWrapped = true
    messageLabel.Parent = frame
    
    frame.Position = UDim2.new(1, 300, 1, -120)
    local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 1, -120)
    })
    tween:Play()
    
    task.wait(config.Duration or 5)
    
    local exitTween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 300, 1, -120)
    })
    exitTween:Play()
    exitTween.Completed:Wait()
    notification:Destroy()
end

function KBLUI:UpdateCanvasSize()
    local totalHeight = 0
    for _, element in pairs(self.Elements) do
        totalHeight = totalHeight + element.Size.Y.Offset + 10
    end
    self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

function KBLUI:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- Filter Reset Function
local function ResetFilter()
    pcall(function()
        for i = 1, 5 do
            pcall(function()
                local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                if channel then
                    channel:SendAsync("\226\128\139")
                end
            end)
            task.wait(0.1)
        end
    end)
    
    pcall(function()
        local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvents then
            local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
            if sayMessage then
                for i = 1, 3 do
                    sayMessage:FireServer("\226\128\139", "All")
                    task.wait(0.1)
                end
            end
        end
    end)
end

-- Bypass Helper Functions
local function AddInvisible()
    return Invisibles[math.random(1, #Invisibles)]
end

local function AddCombining()
    return CombiningMarks[math.random(1, #CombiningMarks)]
end

local function GetHomoglyph(char)
    local lower = string.lower(char)
    
    -- Check language-specific homoglyphs first
    if LanguageHomoglyphs[Settings.Language] and LanguageHomoglyphs[Settings.Language][lower] then
        local options = LanguageHomoglyphs[Settings.Language][lower]
        return options[math.random(1, #options)]
    end
    
    -- Fallback to general homoglyphs
    if Homoglyphs[lower] then
        local options = Homoglyphs[lower]
        return options[math.random(1, #options)]
    end
    
    return char
end

-- Main Bypass Function
local function BypassText(text)
    if not Settings.Enabled or text == "" then
        return text
    end
    
    if Settings.AutoResetFilter then
        ResetFilter()
        task.wait(0.2)
    end
    
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        if char == " " then
            result = result .. " "
        else
            if Settings.UseInvisible then
                result = result .. AddInvisible()
            end
            
            if Settings.UseHomoglyphs then
                char = GetHomoglyph(char)
            end
            
            result = result .. char
            
            if Settings.UseCombiningMarks and math.random(1, 100) <= 50 then
                result = result .. AddCombining()
            end
            
            if Settings.UseInvisible then
                result = result .. AddInvisible()
            end
        end
    end
    
    return result
end

-- Send Message Function
local function SendMessage(text)
    local bypassedText = BypassText(text)
    
    pcall(function()
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then
            channel:SendAsync(bypassedText)
        end
    end)
    
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
                    args[1] = BypassText(args[1])
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
            if Settings.Enabled and Settings.AutoBypass and message ~= "\226\128\139" then
                message = BypassText(message)
            end
            return oldSend(self, message, ...)
        end
    end
end)

-- Create UI with Custom Library
local KBLWindow = KBLUI:CreateWindow({
    Name = "KBL Bypasser v5.0"
})

KBLWindow:CreateParagraph({
    Title = "IMPORTANT",
    Content = "For best results, change your Roblox language to:\n• Қазақ тілі (Kazakh)\n• Shqipe (Albanian)\n\nGo to: Roblox Settings → Language"
})

KBLWindow:CreateSection("Auto Bypass")

KBLWindow:CreateToggle({
    Name = "Auto Bypass",
    CurrentValue = Settings.AutoBypass,
    Callback = function(Value)
        Settings.AutoBypass = Value
    end
})

KBLWindow:CreateToggle({
    Name = "Auto Reset Filter",
    CurrentValue = Settings.AutoResetFilter,
    Callback = function(Value)
        Settings.AutoResetFilter = Value
    end
})

KBLWindow:CreateSection("Language Settings")

KBLWindow:CreateDropdown({
    Name = "Language",
    Options = {"Kazakh", "Albanian", "English"},
    Default = "Kazakh",
    Callback = function(Value)
        Settings.Language = Value
        KBLWindow:Notify({
            Title = "Language Changed",
            Content = "Language set to: " .. Value,
            Duration = 3
        })
    end
})

KBLWindow:CreateSection("Bypass Methods")

KBLWindow:CreateToggle({
    Name = "Use Unicode",
    CurrentValue = Settings.UseUnicode,
    Callback = function(Value)
        Settings.UseUnicode = Value
    end
})

KBLWindow:CreateToggle({
    Name = "Use Homoglyphs",
    CurrentValue = Settings.UseHomoglyphs,
    Callback = function(Value)
        Settings.UseHomoglyphs = Value
    end
})

KBLWindow:CreateToggle({
    Name = "Use Invisible Characters",
    CurrentValue = Settings.UseInvisible,
    Callback = function(Value)
        Settings.UseInvisible = Value
    end
})

KBLWindow:CreateToggle({
    Name = "Use Combining Marks",
    CurrentValue = Settings.UseCombiningMarks,
    Callback = function(Value)
        Settings.UseCombiningMarks = Value
    end
})

KBLWindow:CreateSection("Actions")

KBLWindow:CreateButton({
    Name = "Reset Filter Now",
    Callback = function()
        ResetFilter()
        KBLWindow:Notify({
            Title = "Filter Reset",
            Content = "Filter cache cleared",
            Duration = 2
        })
    end
})

KBLWindow:CreateButton({
    Name = "Test Bypass",
    Callback = function()
        SendMessage("Test message")
        KBLWindow:Notify({
            Title = "Test Sent",
            Content = "Test message sent to chat",
            Duration = 2
        })
    end
})

KBLWindow:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        KBLWindow:Destroy()
    end
})

-- Startup Notification
KBLWindow:Notify({
    Title = "KBL Bypasser v5.0",
    Content = "Loaded! Set language to Kazakh or Albanian for best results.",
    Duration = 6
})

print("═══════════════════════════")
print("KBL Bypasser v5.0 Loaded")
print("Custom UI Library Activated")
print("Tip: Use Kazakh or Albanian language")
print("═══════════════════════════")
