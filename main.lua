-- KBL Bypasser v12.0
-- Ultimate bypass with language switching and ALL methods
-- Tests multiple approaches to find what works

-- Services
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

-- Language switching test
local AvailableLanguages = {
    "English", "Spanish", "French", "German", "Italian", "Portuguese",
    "Russian", "Chinese", "Japanese", "Korean", "Arabic", "Turkish",
    "Polish", "Dutch", "Swedish", "Norwegian", "Danish", "Finnish",
    "Greek", "Hebrew", "Hindi", "Thai", "Vietnamese", "Indonesian"
}

-- ALL bypass methods in one arsenal
local BypassMethods = {
    -- Method 1: Simple Homoglyphs (Most basic)
    ["Simple Homoglyphs"] = function(text)
        local replacements = {
            ["a"] = "а", ["A"] = "А",
            ["e"] = "е", ["E"] = "Е",
            ["o"] = "о", ["O"] = "О",
            ["p"] = "р", ["P"] = "Р",
            ["c"] = "с", ["C"] = "С",
            ["x"] = "х", ["X"] = "Х",
            ["y"] = "у", ["Y"] = "У",
            ["s"] = "ѕ", ["S"] = "Ѕ",
            ["i"] = "і", ["I"] = "І",
            ["B"] = "В", ["H"] = "Н",
            ["K"] = "К", ["M"] = "М",
            ["T"] = "Т", ["a"] = "ɑ",
            ["e"] = "ε", ["o"] = "ο",
            ["t"] = "τ", ["h"] = "η",
            ["n"] = "η", ["u"] = "μ",
            ["v"] = "ν", ["w"] = "ω",
        }
        
        local result = ""
        for i = 1, #text do
            local char = text:sub(i, i)
            if replacements[char] then
                result = result .. replacements[char]
            else
                result = result .. char
            end
        end
        return result
    end,
    
    -- Method 2: Invisible Splitting
    ["Invisible Split"] = function(text)
        -- Split words with invisible characters
        local invisibleChars = {
            "\226\128\139", -- Zero width space
            "\226\128\140", -- Zero width non-joiner
            "\226\128\141", -- Zero width joiner
            "\226\128\142", -- Left-to-right mark
            "\226\128\143", -- Right-to-left mark
            "\226\129\165", -- Two dot leader
            "\226\129\166", -- Three dot leader
        }
        
        local result = ""
        local words = {}
        local currentWord = ""
        
        -- Split into words
        for i = 1, #text do
            local char = text:sub(i, i)
            if char == " " then
                if currentWord ~= "" then
                    table.insert(words, currentWord)
                    currentWord = ""
                end
                table.insert(words, " ")
            else
                currentWord = currentWord .. char
            end
        end
        if currentWord ~= "" then
            table.insert(words, currentWord)
        end
        
        -- Reconstruct with invisible separators
        for i, word in ipairs(words) do
            if word ~= " " then
                -- Insert invisible character every 2-3 characters
                local newWord = ""
                for j = 1, #word do
                    newWord = newWord .. word:sub(j, j)
                    if j % math.random(2, 3) == 0 and j < #word then
                        newWord = newWord .. invisibleChars[math.random(1, #invisibleChars)]
                    end
                end
                result = result .. newWord
            else
                result = result .. " "
            end
        end
        
        return result
    end,
    
    -- Method 3: Font Style Mixing
    ["Font Style Mix"] = function(text)
        -- Mix different Unicode font styles
        local fonts = {
            normal = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"},
            bold = {"𝐚","𝐛","𝐜","𝐝","𝐞","𝐟","𝐠","𝐡","𝐢","𝐣","𝐤","𝐥","𝐦","𝐧","𝐨","𝐩","𝐪","𝐫","𝐬","𝐭","𝐮","𝐯","𝐰","𝐱","𝐲","𝐳"},
            italic = {"𝑎","𝑏","𝑐","𝑑","𝑒","𝑓","𝑔","ℎ","𝑖","𝑗","𝑘","𝑙","𝑚","𝑛","𝑜","𝑝","𝑞","𝑟","𝑠","𝑡","𝑢","𝑣","𝑤","𝑥","𝑦","𝑧"},
            script = {"𝒶","𝒷","𝒸","𝒹","𝑒","𝒻","𝑔","𝒽","𝒾","𝒿","𝓀","𝓁","𝓂","𝓃","𝑜","𝓅","𝓆","𝓇","𝓈","𝓉","𝓊","𝓋","𝓌","𝓍","𝓎","𝓏"},
            fraktur = {"𝔞","𝔟","𝔠","𝔡","𝔢","𝔣","𝔤","𝔥","𝔦","𝔧","𝔨","𝔩","𝔪","𝔫","𝔬","𝔭","𝔮","𝔯","𝔰","𝔱","𝔲","𝔳","𝔴","𝔵","𝔶","𝔷"},
            doublestruck = {"𝕒","𝕓","𝕔","𝕕","𝕖","𝕗","𝕘","𝕙","𝕚","𝕛","𝕜","𝕝","𝕞","𝕟","𝕠","𝕡","𝕢","𝕣","𝕤","𝕥","𝕦","𝕧","𝕨","𝕩","𝕪","𝕫"},
            monospace = {"𝚊","𝚋","𝚌","𝚍","𝚎","𝚏","𝚐","𝚑","𝚒","𝚓","𝚔","𝚕","𝚖","𝚗","𝚘","𝚙","𝚚","𝚛","𝚜","𝚝","𝚞","𝚟","𝚠","𝚡","𝚢","𝚣"},
            sansserif = {"𝖺","𝖻","𝖼","𝖽","𝖾","𝖿","𝗀","𝗁","𝗂","𝗃","𝗄","𝗅","𝗆","𝗇","𝗈","𝗉","𝗊","𝗋","𝗌","𝗍","𝗎","𝗏","𝗐","𝗑","𝗒","𝗓"},
        }
        
        local result = ""
        local fontOrder = {"normal", "bold", "italic", "script", "fraktur", "doublestruck", "monospace", "sansserif"}
        local fontIndex = 1
        
        for i = 1, #text do
            local char = text:sub(i, i):lower()
            if char >= "a" and char <= "z" then
                local index = string.byte(char) - 96
                local currentFont = fontOrder[fontIndex]
                
                if fonts[currentFont] and fonts[currentFont][index] then
                    result = result .. fonts[currentFont][index]
                else
                    result = result .. char
                end
                
                -- Rotate fonts
                fontIndex = fontIndex + 1
                if fontIndex > #fontOrder then
                    fontIndex = 1
                end
            else
                result = result .. text:sub(i, i)
            end
        end
        
        return result
    end,
    
    -- Method 4: Reverse Text + Invisible
    ["Reverse + Invisible"] = function(text)
        -- Reverse text and add invisible markers
        local reversed = string.reverse(text)
        
        -- Add invisible characters at strategic points
        local result = ""
        for i = 1, #reversed do
            result = result .. reversed:sub(i, i)
            if i % 2 == 0 then
                result = result .. "\226\128\139"
            end
        end
        
        -- Add direction markers
        return "\226\128\142" .. result .. "\226\128\143"
    end,
    
    -- Method 5: Emoji Padding
    ["Emoji Padding"] = function(text)
        -- Pad with small/invisible emojis
        local tinyEmojis = {
            "⃝", "⃞", "⃟", "⃠", "⃡", "⃢", "⃣", "◌", "○", "●",
            "​", "‌", "‍", "⁠", "⁡", "⁢", "⁣", "⁤", "⁦", "⁧",
            "⁨", "⁩", "⁪", "⁫", "⁬", "⁭", "⁮", "⁯"
        }
        
        local result = ""
        for i = 1, #text do
            local char = text:sub(i, i)
            result = result .. char
            
            -- Add tiny emoji every 1-3 characters
            if math.random(1, 3) == 1 then
                result = result .. tinyEmojis[math.random(1, #tinyEmojis)]
            end
        end
        
        return result
    end,
    
    -- Method 6: Language Script Mix
    ["Script Mix"] = function(text)
        -- Mix different language scripts
        local scripts = {
            latin = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"},
            cyrillic = {"а","б","ц","д","е","ф","г","һ","і","ј","к","л","м","п","о","р","ԛ","г","ѕ","т","υ","ѵ","ш","х","у","z"},
            greek = {"α","β","ψ","δ","ε","φ","γ","η","ι","ξ","κ","λ","μ","ν","ο","π","θ","ρ","σ","τ","υ","v","ω","χ","υ","ζ"},
            math = {"𝛼","𝛽","𝛾","𝛿","𝜀","𝜑","𝑔","ℎ","𝑖","𝑗","𝑘","𝑙","𝑚","𝑛","𝑜","𝑝","𝑞","𝑟","𝑠","𝑡","𝑢","𝑣","𝑤","𝑥","𝑦","𝑧"},
        }
        
        local scriptOrder = {"latin", "cyrillic", "greek", "math"}
        local scriptIndex = 1
        
        local result = ""
        for i = 1, #text do
            local char = text:sub(i, i):lower()
            if char >= "a" and char <= "z" then
                local index = string.byte(char) - 96
                local currentScript = scriptOrder[scriptIndex]
                
                if scripts[currentScript] and scripts[currentScript][index] then
                    result = result .. scripts[currentScript][index]
                else
                    result = result .. char
                end
                
                -- Rotate scripts
                scriptIndex = scriptIndex + 1
                if scriptIndex > #scriptOrder then
                    scriptIndex = 1
                end
            else
                result = result .. text:sub(i, i)
            end
        end
        
        return result
    end,
    
    -- Method 7: Delimiter Method (Like {dm00text00dm})
    ["Delimiter Method"] = function(text)
        -- Wrap text in custom delimiters
        local delimiters = {
            {"❰", "❱"},
            {"⟦", "⟧"},
            {"⦇", "⦈"},
            {"⌈", "⌉"},
            {"⌊", "⌋"},
            {"⟅", "⟆"},
            {"⟬", "⟭"},
            {"⦃", "⦄"},
            {"❴", "❵"},
            {"❮", "❯"},
        }
        
        local chosen = delimiters[math.random(1, #delimiters)]
        local zeroWidth = "\226\128\139"
        
        return chosen[1] .. zeroWidth .. zeroWidth .. text .. zeroWidth .. zeroWidth .. chosen[2]
    end,
    
    -- Method 8: Character Spacing
    ["Character Spacing"] = function(text)
        -- Add varying spaces between characters
        local spaces = {
            " ", -- Normal space
            " ", -- En quad
            " ", -- Em quad
            " ", -- En space
            " ", -- Em space
            " ", -- Three-per-em space
            " ", -- Four-per-em space
            " ", -- Six-per-em space
            " ", -- Figure space
            " ", -- Punctuation space
            " ", -- Thin space
            " ", -- Hair space
            "​", -- Zero width space
        }
        
        local result = ""
        for i = 1, #text do
            result = result .. text:sub(i, i)
            if i < #text then
                -- Add random spacing
                result = result .. spaces[math.random(1, #spaces)]
            end
        end
        
        return result
    end,
    
    -- Method 9: HTML Entity Style
    ["HTML Entity Style"] = function(text)
        -- Convert to HTML entity style (but with invisible chars)
        local result = ""
        for i = 1, #text do
            local char = text:sub(i, i)
            local code = string.byte(char)
            
            -- Occasionally write as HTML entity
            if math.random(1, 3) == 1 then
                result = result .. "&#" .. code .. ";"
            else
                result = result .. char
            end
            
            -- Add zero-width occasionally
            if math.random(1, 4) == 1 then
                result = result .. "\226\128\139"
            end
        end
        
        return result
    end,
    
    -- Method 10: Base64 Encoding + Padding
    ["Base64 + Padding"] = function(text)
        -- Encode in base64 then add padding
        local base64 = game:GetService("HttpService"):Base64Encode(text)
        
        -- Add random padding characters
        local padding = {"=", "≡", "≈", "≋", "≌", "≍", "≎", "≏"}
        local padded = base64
        
        for i = 1, math.random(2, 5) do
            padded = padded .. padding[math.random(1, #padding)]
        end
        
        return padded
    end,
}

-- Advanced TextChatService detection
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

-- Send message with selected method
local function SendMessage(method, text)
    local channel = GetTextChannel()
    if not channel then
        return false, "No TextChatService channel found"
    end
    
    local bypassedText = ""
    if BypassMethods[method] then
        bypassedText = BypassMethods[method](text)
    else
        bypassedText = text
    end
    
    local success, error = pcall(function()
        channel:SendAsync(bypassedText)
    end)
    
    return success, error or "Sent"
end

-- Test all methods
local function TestAllMethods(text)
    local results = {}
    local channel = GetTextChannel()
    
    if not channel then
        return results
    end
    
    for methodName, methodFunc in pairs(BypassMethods) do
        local bypassedText = methodFunc(text)
        
        local success, error = pcall(function()
            channel:SendAsync("[TEST] " .. methodName .. ": " .. bypassedText)
        end)
        
        results[methodName] = {
            success = success,
            error = error,
            text = bypassedText
        }
        
        wait(1) -- Wait between tests
    end
    
    return results
end

-- Hook chat automatically
local function HookChat(method)
    local channel = GetTextChannel()
    if channel then
        local originalSendAsync = channel.SendAsync
        
        channel.SendAsync = function(self, message, ...)
            if message and message ~= "" and BypassMethods[method] then
                message = BypassMethods[method](message)
            end
            return originalSendAsync(self, message, ...)
        end
        return true
    end
    return false
end

-- Create advanced GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KBLUltimateBypasser"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.Size = UDim2.new(0, 500, 0, 550)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -275)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "KBL Ultimate Bypasser v12.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
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

UserInputService.InputChanged:Connect(function(input)
    if dragging and dragInput and input.UserInputType == dragInput.UserInputType then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Tab System
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundTransparency = 1
TabContainer.Size = UDim2.new(1, 0, 0, 50)
TabContainer.Position = UDim2.new(0, 0, 0, 40)

local Tabs = {"Single Test", "Batch Test", "Auto-Bypass", "Settings"}
local CurrentTab = "Single Test"

local function CreateTabButton(name, index)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = "Tab_" .. name
    TabButton.Parent = TabContainer
    TabButton.Size = UDim2.new(1 / #Tabs, 0, 1, 0)
    TabButton.Position = UDim2.new((index-1) * (1 / #Tabs), 0, 0, 0)
    TabButton.BackgroundColor3 = name == CurrentTab and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Text = name
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.TextSize = 14
    
    TabButton.MouseButton1Click:Connect(function()
        CurrentTab = name
        -- Update all tabs
        for _, tabName in ipairs(Tabs) do
            local btn = TabContainer:FindFirstChild("Tab_" .. tabName)
            if btn then
                btn.BackgroundColor3 = tabName == CurrentTab and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
            end
        end
        UpdateTabContent()
    end)
    
    return TabButton
end

for i, tabName in ipairs(Tabs) do
    CreateTabButton(tabName, i)
end

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Size = UDim2.new(1, 0, 1, -90)
ContentFrame.Position = UDim2.new(0, 0, 0, 90)

-- Single Test Tab
local SingleTestFrame = Instance.new("Frame")
SingleTestFrame.Name = "SingleTestFrame"
SingleTestFrame.Parent = ContentFrame
SingleTestFrame.BackgroundTransparency = 1
SingleTestFrame.Size = UDim2.new(1, 0, 1, 0)
SingleTestFrame.Visible = false

local MethodDropdown = Instance.new("TextButton")
MethodDropdown.Name = "MethodDropdown"
MethodDropdown.Parent = SingleTestFrame
MethodDropdown.Size = UDim2.new(1, -20, 0, 40)
MethodDropdown.Position = UDim2.new(0, 10, 0, 10)
MethodDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MethodDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
MethodDropdown.Text = "Select Method ▼"
MethodDropdown.Font = Enum.Font.SourceSansBold
MethodDropdown.TextSize = 14

local MessageInput = Instance.new("TextBox")
MessageInput.Name = "MessageInput"
MessageInput.Parent = SingleTestFrame
MessageInput.Size = UDim2.new(1, -20, 0, 80)
MessageInput.Position = UDim2.new(0, 10, 0, 60)
MessageInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MessageInput.TextColor3 = Color3.fromRGB(255, 255, 255)
MessageInput.Text = ""
MessageInput.Font = Enum.Font.SourceSans
MessageInput.TextSize = 14
MessageInput.TextWrapped = true
MessageInput.PlaceholderText = "Type your message here..."

local SendButton = Instance.new("TextButton")
SendButton.Name = "SendButton"
SendButton.Parent = SingleTestFrame
SendButton.Size = UDim2.new(1, -20, 0, 45)
SendButton.Position = UDim2.new(0, 10, 0, 150)
SendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.Text = "SEND TEST"
SendButton.Font = Enum.Font.SourceSansBold
SendButton.TextSize = 16

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = SingleTestFrame
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Position = UDim2.new(0, 10, 0, 205)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Batch Test Tab
local BatchTestFrame = Instance.new("Frame")
BatchTestFrame.Name = "BatchTestFrame"
BatchTestFrame.Parent = ContentFrame
BatchTestFrame.BackgroundTransparency = 1
BatchTestFrame.Size = UDim2.new(1, 0, 1, 0)
BatchTestFrame.Visible = false

local TestMessageInput = Instance.new("TextBox")
TestMessageInput.Name = "TestMessageInput"
TestMessageInput.Parent = BatchTestFrame
TestMessageInput.Size = UDim2.new(1, -20, 0, 60)
TestMessageInput.Position = UDim2.new(0, 10, 0, 10)
TestMessageInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TestMessageInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TestMessageInput.Text = "test bypass"
TestMessageInput.Font = Enum.Font.SourceSans
TestMessageInput.TextSize = 14
TestMessageInput.TextWrapped = true

local TestAllButton = Instance.new("TextButton")
TestAllButton.Name = "TestAllButton"
TestAllButton.Parent = BatchTestFrame
TestAllButton.Size = UDim2.new(1, -20, 0, 45)
TestAllButton.Position = UDim2.new(0, 10, 0, 80)
TestAllButton.BackgroundColor3 = Color3.fromRGB(215, 120, 0)
TestAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TestAllButton.Text = "TEST ALL METHODS"
TestAllButton.Font = Enum.Font.SourceSansBold
TestAllButton.TextSize = 16

local TestResults = Instance.new("ScrollingFrame")
TestResults.Name = "TestResults"
TestResults.Parent = BatchTestFrame
TestResults.Size = UDim2.new(1, -20, 0, 250)
TestResults.Position = UDim2.new(0, 10, 0, 135)
TestResults.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TestResults.BorderSizePixel = 1
TestResults.BorderColor3 = Color3.fromRGB(60, 60, 60)
TestResults.ScrollBarThickness = 6
TestResults.CanvasSize = UDim2.new(0, 0, 0, 0)

-- Auto-Bypass Tab
local AutoBypassFrame = Instance.new("Frame")
AutoBypassFrame.Name = "AutoBypassFrame"
AutoBypassFrame.Parent = ContentFrame
AutoBypassFrame.BackgroundTransparency = 1
AutoBypassFrame.Size = UDim2.new(1, 0, 1, 0)
AutoBypassFrame.Visible = false

local AutoMethodDropdown = Instance.new("TextButton")
AutoMethodDropdown.Name = "AutoMethodDropdown"
AutoMethodDropdown.Parent = AutoBypassFrame
AutoMethodDropdown.Size = UDim2.new(1, -20, 0, 40)
AutoMethodDropdown.Position = UDim2.new(0, 10, 0, 10)
AutoMethodDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AutoMethodDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoMethodDropdown.Text = "Select Auto Method ▼"
AutoMethodDropdown.Font = Enum.Font.SourceSansBold
AutoMethodDropdown.TextSize = 14

local AutoToggle = Instance.new("TextButton")
AutoToggle.Name = "AutoToggle"
AutoToggle.Parent = AutoBypassFrame
AutoToggle.Size = UDim2.new(1, -20, 0, 40)
AutoToggle.Position = UDim2.new(0, 10, 0, 60)
AutoToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
AutoToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoToggle.Text = "AUTO-BYPASS: OFF"
AutoToggle.Font = Enum.Font.SourceSansBold
AutoToggle.TextSize = 16

local AutoStatus = Instance.new("TextLabel")
AutoStatus.Name = "AutoStatus"
AutoStatus.Parent = AutoBypassFrame
AutoStatus.Size = UDim2.new(1, -20, 0, 100)
AutoStatus.Position = UDim2.new(0, 10, 0, 110)
AutoStatus.BackgroundTransparency = 1
AutoStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
AutoStatus.Font = Enum.Font.SourceSans
AutoStatus.TextSize = 12
AutoStatus.TextWrapped = true
AutoStatus.Text = "Auto-bypass will automatically process all chat messages.\n\nStatus: Not hooked"

-- Settings Tab
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Parent = ContentFrame
SettingsFrame.BackgroundTransparency = 1
SettingsFrame.Size = UDim2.new(1, 0, 1, 0)
SettingsFrame.Visible = false

local LanguageLabel = Instance.new("TextLabel")
LanguageLabel.Name = "LanguageLabel"
LanguageLabel.Parent = SettingsFrame
LanguageLabel.Size = UDim2.new(1, -20, 0, 30)
LanguageLabel.Position = UDim2.new(0, 10, 0, 10)
LanguageLabel.BackgroundTransparency = 1
LanguageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LanguageLabel.Text = "Try switching Roblox language to:"
LanguageLabel.Font = Enum.Font.SourceSansBold
LanguageLabel.TextSize = 14
LanguageLabel.TextXAlignment = Enum.TextXAlignment.Left

local LanguageList = Instance.new("ScrollingFrame")
LanguageList.Name = "LanguageList"
LanguageList.Parent = SettingsFrame
LanguageList.Size = UDim2.new(1, -20, 0, 200)
LanguageList.Position = UDim2.new(0, 10, 0, 50)
LanguageList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LanguageList.BorderSizePixel = 1
LanguageList.BorderColor3 = Color3.fromRGB(60, 60, 60)
LanguageList.ScrollBarThickness = 6
LanguageList.CanvasSize = UDim2.new(0, 0, 0, #AvailableLanguages * 35)

for i, language in ipairs(AvailableLanguages) do
    local LangButton = Instance.new("TextButton")
    LangButton.Size = UDim2.new(1, -10, 0, 30)
    LangButton.Position = UDim2.new(0, 5, 0, (i-1) * 35)
    LangButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    LangButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LangButton.Text = language
    LangButton.Font = Enum.Font.SourceSans
    LangButton.TextSize = 12
    LangButton.Parent = LanguageList
    
    LangButton.MouseButton1Click:Connect(function()
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[KBL] Try switching Roblox language to: " .. language;
            Color = Color3.fromRGB(255, 255, 0);
            Font = Enum.Font.SourceSansBold;
        })
    end)
end

-- Method Dropdown Menu
local DropdownFrame = Instance.new("Frame")
DropdownFrame.Name = "DropdownFrame"
DropdownFrame.Parent = MainFrame
DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
DropdownFrame.BorderSizePixel = 1
DropdownFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
DropdownFrame.Size = UDim2.new(0.9, 0, 0, 200)
DropdownFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
DropdownFrame.Visible = false

local DropdownScrolling = Instance.new("ScrollingFrame")
DropdownScrolling.Name = "DropdownScrolling"
DropdownScrolling.Parent = DropdownFrame
DropdownScrolling.BackgroundTransparency = 1
DropdownScrolling.Size = UDim2.new(1, 0, 1, 0)
DropdownScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownScrolling.ScrollBarThickness = 6

local DropdownLayout = Instance.new("UIListLayout")
DropdownLayout.Padding = UDim.new(0, 2)
DropdownLayout.Parent = DropdownScrolling

-- Populate method dropdown
local selectedMethod = "Simple Homoglyphs"
for methodName, _ in pairs(BypassMethods) do
    local MethodButton = Instance.new("TextButton")
    MethodButton.Size = UDim2.new(1, -10, 0, 30)
    MethodButton.Position = UDim2.new(0, 5, 0, (#DropdownScrolling:GetChildren() - 1) * 32)
    MethodButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    MethodButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MethodButton.Text = methodName
    MethodButton.Font = Enum.Font.SourceSans
    MethodButton.TextSize = 12
    MethodButton.Parent = DropdownScrolling
    
    MethodButton.MouseButton1Click:Connect(function()
        selectedMethod = methodName
        MethodDropdown.Text = methodName .. " ▼"
        AutoMethodDropdown.Text = methodName .. " ▼"
        DropdownFrame.Visible = false
    end)
    
    DropdownScrolling.CanvasSize = UDim2.new(0, 0, 0, (#DropdownScrolling:GetChildren() - 1) * 32)
end

-- Show dropdown
MethodDropdown.MouseButton1Click:Connect(function()
    DropdownFrame.Visible = not DropdownFrame.Visible
    DropdownFrame.Position = UDim2.new(0.05, 0, MethodDropdown.Position.Y.Scale + 0.1, MethodDropdown.Position.Y.Offset)
end)

AutoMethodDropdown.MouseButton1Click:Connect(function()
    DropdownFrame.Visible = not DropdownFrame.Visible
    DropdownFrame.Position = UDim2.new(0.05, 0, AutoMethodDropdown.Position.Y.Scale + 0.1, AutoMethodDropdown.Position.Y.Offset)
end)

-- Send message
SendButton.MouseButton1Click:Connect(function()
    if MessageInput.Text ~= "" then
        local success, result = SendMessage(selectedMethod, MessageInput.Text)
        StatusLabel.Text = success and "✓ Message sent!" or "✗ Error: " .. tostring(result)
        StatusLabel.TextColor3 = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end
end)

-- Test all methods
TestAllButton.MouseButton1Click:Connect(function()
    local message = TestMessageInput.Text
    if message == "" then
        message = "test bypass"
    end
    
    TestResults:ClearAllChildren()
    TestResults.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local yOffset = 5
    for methodName, methodFunc in pairs(BypassMethods) do
        local ResultLabel = Instance.new("TextLabel")
        ResultLabel.Size = UDim2.new(1, -10, 0, 30)
        ResultLabel.Position = UDim2.new(0, 5, 0, yOffset)
        ResultLabel.BackgroundTransparency = 1
        ResultLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        ResultLabel.Text = methodName .. ": Testing..."
        ResultLabel.Font = Enum.Font.SourceSans
        ResultLabel.TextSize = 12
        ResultLabel.TextXAlignment = Enum.TextXAlignment.Left
        ResultLabel.Parent = TestResults
        
        yOffset = yOffset + 35
        
        -- Test the method
        task.spawn(function()
            local bypassedText = methodFunc(message)
            local success, error = pcall(function()
                local channel = GetTextChannel()
                if channel then
                    channel:SendAsync("[TEST] " .. methodName .. ": " .. bypassedText)
                end
            end)
            
            ResultLabel.Text = methodName .. ": " .. (success and "✓ Sent" or "✗ Failed")
            ResultLabel.TextColor3 = success and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        end)
        
        wait(0.5) -- Space out tests
    end
    
    TestResults.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end)

-- Auto-bypass toggle
local autoHooked = false
AutoToggle.MouseButton1Click:Connect(function()
    if autoHooked then
        -- Unhook
        autoHooked = false
        AutoToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        AutoToggle.Text = "AUTO-BYPASS: OFF"
        AutoStatus.Text = "Auto-bypass disabled.\n\nTo re-enable, click the button again."
    else
        -- Hook
        autoHooked = HookChat(selectedMethod)
        if autoHooked then
            AutoToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            AutoToggle.Text = "AUTO-BYPASS: ON"
            AutoStatus.Text = "Auto-bypass enabled!\n\nAll chat messages will be processed with:\n" .. selectedMethod .. "\n\nChannel: RBXGeneral"
        else
            AutoStatus.Text = "Failed to hook TextChatService.\nMake sure you're in a game with chat enabled."
        end
    end
end)

-- Update tab content
local function UpdateTabContent()
    SingleTestFrame.Visible = CurrentTab == "Single Test"
    BatchTestFrame.Visible = CurrentTab == "Batch Test"
    AutoBypassFrame.Visible = CurrentTab == "Auto-Bypass"
    SettingsFrame.Visible = CurrentTab == "Settings"
end

UpdateTabContent()

-- Initialize
task.spawn(function()
    wait(1)
    local channel = GetTextChannel()
    if channel then
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[KBL v12.0] Ultimate bypasser loaded!";
            Color = Color3.fromRGB(0, 255, 0);
            Font = Enum.Font.SourceSansBold;
        })
        
        StatusLabel.Text = "Connected to TextChatService"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        StatusLabel.Text = "WARNING: No TextChatService channel found"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    end
end)

print("═══════════════════════════════════════════════")
print("KBL Ultimate Bypasser v12.0")
print("Loaded " .. #AvailableLanguages .. " language suggestions")
print("Loaded " .. #BypassMethods .. " bypass methods")
print("═══════════════════════════════════════════════")
