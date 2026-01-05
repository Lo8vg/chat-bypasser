-- KBL Bypasser v7.0
-- Actually bypasses Roblox filters with multiple methods
-- Custom Rayfield-style UI without dependencies

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- Advanced bypass methods
local BypassMethods = {
    -- Method 1: Zero-width character obfuscation
    ZeroWidthSpam = function(text)
        local result = ""
        for i = 1, #text do
            local char = text:sub(i, i)
            result = result .. "\226\128\139" .. char .. "\226\128\140"
        end
        return result
    end,
    
    -- Method 2: Homoglyph substitution
    HomoglyphReplace = function(text)
        local homoglyphs = {
            ["a"] = "а", ["A"] = "А",
            ["c"] = "с", ["C"] = "С",
            ["e"] = "е", ["E"] = "Е",
            ["o"] = "о", ["O"] = "О",
            ["p"] = "р", ["P"] = "Р",
            ["x"] = "х", ["X"] = "Х",
            ["y"] = "у", ["Y"] = "У",
            ["i"] = "і", ["I"] = "І",
            ["s"] = "ѕ", ["S"] = "Ѕ",
            ["n"] = "п", ["N"] = "П",
            ["m"] = "м", ["M"] = "М",
            ["t"] = "т", ["T"] = "Т",
            ["r"] = "г", ["R"] = "Г",
            ["b"] = "ъ", ["B"] = "Ъ",
            ["d"] = "ԁ", ["D"] = "Ԁ",
            ["l"] = "ӏ", ["L"] = "ӏ",
            ["g"] = "ԍ", ["G"] = "Ԍ",
            ["h"] = "һ", ["H"] = "Н",
            ["k"] = "к", ["K"] = "К",
            ["f"] = "ғ", ["F"] = "Ғ",
            ["u"] = "υ", ["U"] = "υ",
            ["v"] = "ν", ["V"] = "Ν",
            ["w"] = "ω", ["W"] = "Ω",
            ["z"] = "ʐ", ["Z"] = "Ζ"
        }
        
        local result = ""
        for i = 1, #text do
            local char = text:sub(i, i)
            result = result .. (homoglyphs[char] or char)
        end
        return result
    end,
    
    -- Method 3: Delimiter method (like {dm00text00dm})
    DelimiterMethod = function(text)
        -- Custom delimiters with combining marks
        local startDelim = "{d" .. "\204\131" .. "m" -- d̅m
        local endDelim = "d" .. "\204\131" .. "m}" -- d̅m}
        local invisible = "\226\128\139"
        
        return startDelim .. invisible .. text .. invisible .. endDelim
    end,
    
    -- Method 4: Unicode mixing
    UnicodeMix = function(text)
        local unicodeMix = {
            ["a"] = {"à", "á", "â", "ã", "ä", "å", "ā", "ă", "ą"},
            ["e"] = {"è", "é", "ê", "ë", "ē", "ĕ", "ė", "ę", "ě"},
            ["i"] = {"ì", "í", "î", "ï", "ð", "ī", "ĭ", "į", "ı"},
            ["o"] = {"ò", "ó", "ô", "õ", "ö", "ø", "ō", "ŏ", "ő"},
            ["u"] = {"ù", "ú", "û", "ü", "ū", "ŭ", "ů", "ű", "ų"},
            ["s"] = {"ś", "ş", "š", "ș"},
            ["c"] = {"ç", "ć", "ĉ", "ċ", "č"},
            ["n"] = {"ñ", "ń", "ņ", "ň", "ŉ", "ŋ"},
            ["r"] = {"ŕ", "ŗ", "ř"},
            ["l"] = {"ĺ", "ļ", "ľ", "ŀ", "ł"},
            ["t"] = {"ţ", "ť", "ŧ"},
            ["z"] = {"ź", "ż", "ž"},
            ["d"] = {"ď", "đ"},
            ["g"] = {"ğ", "ĝ", "ġ", "ģ"}
        }
        
        local result = ""
        for i = 1, #text do
            local char = text:sub(i, i):lower()
            if unicodeMix[char] then
                result = result .. unicodeMix[char][math.random(1, #unicodeMix[char])]
            else
                result = result .. text:sub(i, i)
            end
        end
        return result
    end,
    
    -- Method 5: Space manipulation
    SpaceManipulation = function(text)
        local spaces = {" ", "\t", "\n", "\v", "\f", "\r"}
        local zeroWidthSpaces = {
            "\226\128\139", "\226\128\140", "\226\128\141", 
            "\226\128\142", "\226\128\143", "\226\128\144"
        }
        
        local result = ""
        for i = 1, #text do
            local char = text:sub(i, i)
            if char == " " then
                -- Randomly replace spaces with zero-width spaces
                if math.random(1, 3) == 1 then
                    result = result .. zeroWidthSpaces[math.random(1, #zeroWidthSpaces)]
                else
                    result = result .. char
                end
            else
                result = result .. char
            end
        end
        return result
    end,
    
    -- Method 6: Character reversal (right-to-left)
    RTLReverse = function(text)
        -- Use Unicode right-to-left marks
        local rtlMark = "\u{202E}"
        local rtlEmbed = "\u{202B}"
        
        return rtlMark .. text:reverse() .. rtlEmbed
    end
}

-- Settings
local Settings = {
    Enabled = true,
    AutoBypass = true,
    SelectedMethod = "DelimiterMethod",
    UseMultipleMethods = false,
    ResetFilterOnSend = true
}

-- Filter reset function
local function ResetFilter()
    for i = 1, 3 do
        pcall(function()
            local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if channel then
                channel:SendAsync("\226\128\139")
            end
        end)
        task.wait(0.1)
    end
end

-- Main bypass function
local function AdvancedBypass(text)
    if not Settings.Enabled or text == "" then return text end
    
    if Settings.ResetFilterOnSend then
        ResetFilter()
        task.wait(0.05)
    end
    
    local bypassed = text
    
    if Settings.UseMultipleMethods then
        -- Apply multiple methods randomly
        for methodName, methodFunc in pairs(BypassMethods) do
            if math.random(1, 2) == 1 then
                bypassed = methodFunc(bypassed)
            end
        end
    else
        -- Use selected method
        bypassed = BypassMethods[Settings.SelectedMethod](bypassed)
    end
    
    return bypassed
end

-- Send message function
local function SendMessage(text)
    local bypassed = AdvancedBypass(text)
    
    pcall(function()
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then
            channel:SendAsync(bypassed)
            return
        end
    end)
    
    pcall(function()
        local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvents then
            local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
            if sayMessage then
                sayMessage:FireServer(bypassed, "All")
            end
        end
    end)
end

-- Hook chat for auto-bypass
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

-- Custom UI Library
local KBLUI = {}
KBLUI.__index = KBLUI

function KBLUI:CreateWindow(config)
    local self = setmetatable({}, KBLUI)
    
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "KBLUI"
    self.ScreenGui.Parent = game.CoreGui
    
    -- Main Window
    self.MainWindow = Instance.new("Frame")
    self.MainWindow.Name = "MainWindow"
    self.MainWindow.Size = UDim2.new(0, 450, 0, 550)
    self.MainWindow.Position = UDim2.new(0.5, -225, 0.5, -275)
    self.MainWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.MainWindow.BorderSizePixel = 1
    self.MainWindow.BorderColor3 = Color3.fromRGB(60, 60, 60)
    self.MainWindow.Parent = self.ScreenGui
    
    -- Shadow Effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 12, 1, 12)
    shadow.Position = UDim2.new(0, -6, 0, -6)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceScale = 0.05
    shadow.Parent = self.MainWindow
    
    -- Top Bar
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.Size = UDim2.new(1, 0, 0, 40)
    self.TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.TopBar.BorderSizePixel = 0
    self.TopBar.Parent = self.MainWindow
    
    -- Title
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Size = UDim2.new(1, -80, 1, 0)
    self.Title.Position = UDim2.new(0, 10, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = config.Name or "KBL Bypasser v7.0"
    self.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Title.Font = Enum.Font.SourceSansBold
    self.Title.TextSize = 18
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.TopBar
    
    -- Close Button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -35, 0, 5)
    self.CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    self.CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.CloseButton.Text = "X"
    self.CloseButton.Font = Enum.Font.SourceSansBold
    self.CloseButton.TextSize = 16
    self.CloseButton.Parent = self.TopBar
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Make draggable
    local dragging = false
    local dragStart, startPos
    
    self.TopBar.InputBegan:Connect(function(input)
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
    
    self.TopBar.InputChanged:Connect(function(input)
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
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(1, -20, 0, 40)
    self.TabContainer.Position = UDim2.new(0, 10, 0, 45)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.MainWindow
    
    -- Content Frame
    self.ContentFrame = Instance.new("ScrollingFrame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -20, 1, -100)
    self.ContentFrame.Position = UDim2.new(0, 10, 0, 90)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.ScrollBarThickness = 6
    self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentFrame.Parent = self.MainWindow
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 15)
    layout.Parent = self.ContentFrame
    
    self.Elements = {}
    self.Tabs = {}
    
    return self
end

function KBLUI:CreateTab(name, icon)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "Tab_" .. name
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.Position = UDim2.new(0, (#self.Tabs * 105), 0, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.Text = name
    tabButton.Font = Enum.Font.SourceSansBold
    tabButton.TextSize = 14
    tabButton.Parent = self.TabContainer
    
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = "TabFrame_" .. name
    tabFrame.Size = UDim2.new(1, -20, 1, -100)
    tabFrame.Position = UDim2.new(0, 10, 0, 90)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.ScrollBarThickness = 6
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabFrame.Visible = false
    tabFrame.Parent = self.MainWindow
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 15)
    tabLayout.Parent = tabFrame
    
    table.insert(self.Tabs, {
        Name = name,
        Button = tabButton,
        Frame = tabFrame
    })
    
    tabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)
    
    -- Make first tab active
    if #self.Tabs == 1 then
        self:SwitchTab(name)
    end
    
    return tabFrame
end

function KBLUI:SwitchTab(tabName)
    for _, tab in pairs(self.Tabs) do
        if tab.Name == tabName then
            tab.Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            tab.Frame.Visible = true
        else
            tab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            tab.Frame.Visible = false
        end
    end
end

function KBLUI:CreateSection(tabFrame, title)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = "Section_" .. title
    sectionFrame.Size = UDim2.new(1, 0, 0, 40)
    sectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    sectionFrame.BorderSizePixel = 0
    sectionFrame.Parent = tabFrame
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Name = "SectionLabel"
    sectionLabel.Size = UDim2.new(1, -10, 1, 0)
    sectionLabel.Position = UDim2.new(0, 5, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = "    " .. title
    sectionLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
    sectionLabel.Font = Enum.Font.SourceSansBold
    sectionLabel.TextSize = 16
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.TextYAlignment = Enum.TextYAlignment.Center
    sectionLabel.Parent = sectionFrame
    
    -- Update canvas size
    task.wait()
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
    
    return sectionFrame
end

function KBLUI:CreateToggle(tabFrame, config)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle_" .. config.Name
    toggleFrame.Size = UDim2.new(1, 0, 0, 45)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = tabFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = config.Name
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.Font = Enum.Font.SourceSans
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.TextYAlignment = Enum.TextYAlignment.Center
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 60, 0, 30)
    toggleButton.Position = UDim2.new(1, -70, 0, 7)
    toggleButton.BackgroundColor3 = config.CurrentValue and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = config.CurrentValue and "ON" or "OFF"
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextSize = 14
    toggleButton.Parent = toggleFrame
    
    toggleButton.MouseButton1Click:Connect(function()
        config.CurrentValue = not config.CurrentValue
        toggleButton.BackgroundColor3 = config.CurrentValue and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        toggleButton.Text = config.CurrentValue and "ON" or "OFF"
        if config.Callback then
            config.Callback(config.CurrentValue)
        end
    end)
    
    -- Update canvas size
    task.wait()
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
    
    return toggleFrame
end

function KBLUI:CreateButton(tabFrame, config)
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. config.Name
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(100, 100, 100)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = config.Name
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.Parent = tabFrame
    
    button.MouseButton1Click:Connect(function()
        if config.Callback then
            config.Callback()
        end
    end)
    
    -- Update canvas size
    task.wait()
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
    
    return button
end

function KBLUI:CreateDropdown(tabFrame, config)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "Dropdown_" .. config.Name
    dropdownFrame.Size = UDim2.new(1, 0, 0, 60)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.Parent = tabFrame
    
    local dropdownLabel = Instance.new("TextLabel")
    dropdownLabel.Name = "DropdownLabel"
    dropdownLabel.Size = UDim2.new(1, 0, 0, 25)
    dropdownLabel.Position = UDim2.new(0, 0, 0, 0)
    dropdownLabel.BackgroundTransparency = 1
    dropdownLabel.Text = config.Name
    dropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownLabel.Font = Enum.Font.SourceSans
    dropdownLabel.TextSize = 14
    dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    dropdownLabel.TextYAlignment = Enum.TextYAlignment.Center
    dropdownLabel.Parent = dropdownFrame
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(1, 0, 0, 30)
    dropdownButton.Position = UDim2.new(0, 0, 0, 30)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownButton.BorderSizePixel = 1
    dropdownButton.BorderColor3 = Color3.fromRGB(80, 80, 80)
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.Text = config.Options[config.Default] or config.Options[1]
    dropdownButton.Font = Enum.Font.SourceSans
    dropdownButton.TextSize = 14
    dropdownButton.Parent = dropdownFrame
    
    dropdownButton.MouseButton1Click:Connect(function()
        -- Simple dropdown - cycles through options
        local current = dropdownButton.Text
        local nextIndex = 1
        for i, option in ipairs(config.Options) do
            if option == current then
                nextIndex = i + 1
                if nextIndex > #config.Options then
                    nextIndex = 1
                end
                break
            end
        end
        dropdownButton.Text = config.Options[nextIndex]
        if config.Callback then
            config.Callback(config.Options[nextIndex])
        end
    end)
    
    -- Update canvas size
    task.wait()
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
    
    return dropdownFrame
end

function KBLUI:CreateInput(tabFrame, config)
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = "Input_" .. config.Name
    inputFrame.Size = UDim2.new(1, 0, 0, 70)
    inputFrame.BackgroundTransparency = 1
    inputFrame.Parent = tabFrame
    
    local inputLabel = Instance.new("TextLabel")
    inputLabel.Name = "InputLabel"
    inputLabel.Size = UDim2.new(1, 0, 0, 25)
    inputLabel.Position = UDim2.new(0, 0, 0, 0)
    inputLabel.BackgroundTransparency = 1
    inputLabel.Text = config.Name
    inputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputLabel.Font = Enum.Font.SourceSans
    inputLabel.TextSize = 14
    inputLabel.TextXAlignment = Enum.TextXAlignment.Left
    inputLabel.TextYAlignment = Enum.TextYAlignment.Center
    inputLabel.Parent = inputFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "InputBox"
    textBox.Size = UDim2.new(1, 0, 0, 35)
    textBox.Position = UDim2.new(0, 0, 0, 30)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textBox.BorderSizePixel = 1
    textBox.BorderColor3 = Color3.fromRGB(70, 70, 70)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Text = config.PlaceholderText or ""
    textBox.Font = Enum.Font.SourceSans
    textBox.TextSize = 14
    textBox.PlaceholderText = config.PlaceholderText or ""
    textBox.TextWrapped = true
    textBox.Parent = inputFrame
    
    if config.Callback then
        textBox:GetPropertyChangedSignal("Text"):Connect(function()
            config.Callback(textBox.Text)
        end)
    end
    
    -- Update canvas size
    task.wait()
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
    
    return inputFrame
end

function KBLUI:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- Create UI
local KBLWindow = KBLUI:CreateWindow({
    Name = "KBL Bypasser v7.0"
})

-- Create tabs
local mainTab = KBLWindow:CreateTab("Main", "⚙️")
local bypassTab = KBLWindow:CreateTab("Bypass", "🔧")
local settingsTab = KBLWindow:CreateTab("Settings", "⚡")

-- Main Tab
KBLWindow:CreateSection(mainTab, "Status")
KBLWindow:CreateToggle(mainTab, {
    Name = "Enable Bypasser",
    CurrentValue = Settings.Enabled,
    Callback = function(value)
        Settings.Enabled = value
    end
})

KBLWindow:CreateToggle(mainTab, {
    Name = "Auto Bypass",
    CurrentValue = Settings.AutoBypass,
    Callback = function(value)
        Settings.AutoBypass = value
    end
})

KBLWindow:CreateToggle(mainTab, {
    Name = "Reset Filter",
    CurrentValue = Settings.ResetFilterOnSend,
    Callback = function(value)
        Settings.ResetFilterOnSend = value
    end
})

KBLWindow:CreateSection(mainTab, "Actions")
KBLWindow:CreateButton(mainTab, {
    Name = "Test Bypass",
    Callback = function()
        SendMessage("Test message: hello world")
    end
})

KBLWindow:CreateButton(mainTab, {
    Name = "Reset Filter Now",
    Callback = function()
        ResetFilter()
    end
})

-- Bypass Tab
KBLWindow:CreateSection(bypassTab, "Methods")
KBLWindow:CreateDropdown(bypassTab, {
    Name = "Bypass Method",
    Options = {"ZeroWidthSpam", "HomoglyphReplace", "DelimiterMethod", "UnicodeMix", "SpaceManipulation", "RTLReverse"},
    Default = "DelimiterMethod",
    Callback = function(value)
        Settings.SelectedMethod = value
    end
})

KBLWindow:CreateToggle(bypassTab, {
    Name = "Use Multiple Methods",
    CurrentValue = Settings.UseMultipleMethods,
    Callback = function(value)
        Settings.UseMultipleMethods = value
    end
})

KBLWindow:CreateSection(bypassTab, "Test Messages")
KBLWindow:CreateButton(bypassTab, {
    Name = "Test Simple Message",
    Callback = function()
        SendMessage("Hello world")
    end
})

KBLWindow:CreateButton(bypassTab, {
    Name = "Test Filtered Word",
    Callback = function()
        SendMessage("test")
    end
})

KBLWindow:CreateInput(bypassTab, {
    Name = "Custom Message",
    PlaceholderText = "Type message here...",
    Callback = function(text)
        if text ~= "" then
            SendMessage(text)
        end
    end
})

-- Settings Tab
KBLWindow:CreateSection(settingsTab, "Advanced")
KBLWindow:CreateButton(settingsTab, {
    Name = "Unload Bypasser",
    Callback = function()
        KBLWindow:Destroy()
    end
})

KBLWindow:CreateSection(settingsTab, "Debug")
KBLWindow:CreateButton(settingsTab, {
    Name = "Print Settings",
    Callback = function()
        print("=== KBL Bypasser Settings ===")
        print("Enabled:", Settings.Enabled)
        print("Auto Bypass:", Settings.AutoBypass)
        print("Selected Method:", Settings.SelectedMethod)
        print("Use Multiple Methods:", Settings.UseMultipleMethods)
        print("Reset Filter:", Settings.ResetFilterOnSend)
    end
})

-- Hook TextChatService
pcall(function()
    local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    if channel then
        local oldSend = channel.SendAsync
        channel.SendAsync = function(self, message, ...)
            if Settings.Enabled and Settings.AutoBypass and message ~= "" and message ~= "\226\128\139" then
                message = AdvancedBypass(message)
            end
            return oldSend(self, message, ...)
        end
    end
end)

-- Startup message
StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "[KBL Bypasser v7.0] Loaded successfully!";
    Color = Color3.fromRGB(0, 255, 0);
    Font = Enum.Font.SourceSansBold;
})

print("═══════════════════════════")
print("KBL Bypasser v7.0")
print("Custom UI with Rayfield Style")
print("═══════════════════════════")
