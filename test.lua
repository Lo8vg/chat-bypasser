-- Chat Bypass GUI (Powerful Multi-Method)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Bypass methods configuration
local bypassMethods = {
    UNICODE = {
        name = "Unicode Homoglyphs",
        enabled = false,
        -- Maps normal chars to unicode lookalikes
        map = {
            a = {"а", "а", "ɑ", "α", "ⓐ", "𝐚", "𝖺", "𝒶", "𝚊", "𝔞"},
            b = {"Ь", "ḅ", "ḇ", "ⓑ", "𝐛", "𝖻", "𝒷", "𝚋", "𝔟"},
            c = {"с", "ϲ", "ς", "ⓒ", "𝐜", "𝖼", "𝒸", "𝚌", "𝔠"},
            d = {"ԁ", "ḋ", "ḍ", "ⓓ", "𝐝", "𝖽", "𝒹", "𝚍", "𝔡"},
            e = {"е", "ҽ", "℮", "ⓔ", "𝐞", "𝖾", "𝑒", "𝚎", "𝔢"},
            f = {"ſ", "ḟ", "ⓕ", "𝐟", "𝖿", "𝒻", "𝚏", "𝔣"},
            g = {"ɡ", "ǥ", "ⓖ", "𝐠", "𝗀", "𝑔", "𝚐", "𝔤"},
            h = {"һ", "ḧ", "ⓗ", "𝐡", "𝗁", "𝒽", "𝚑", "𝔥"},
            i = {"і", "ɩ", "ι", "ⓘ", "𝐢", "𝗂", "𝒾", "𝚒", "𝔦"},
            j = {"ϳ", "ⓙ", "𝐣", "𝗃", "𝒿", "𝚓", "𝔧"},
            k = {"κ", "ķ", "ⓚ", "𝐤", "𝗄", "𝓀", "𝚔", "𝔨"},
            l = {"ⅼ", "ḷ", "ⓛ", "𝐥", "𝗅", "𝓁", "𝚕", "𝔩"},
            m = {"м", "ṁ", "ⓜ", "𝐦", "𝗆", "𝓂", "𝚖", "𝔪"},
            n = {"ո", "ո", "η", "ⓝ", "𝐧", "𝗇", "𝓃", "𝚗", "𝔫"},
            o = {"о", "ο", "σ", "ⓞ", "𝐨", "𝗈", "𝑜", "𝚘", "𝔬"},
            p = {"ρ", "ρ", "ⓟ", "𝐩", "𝗉", "𝓅", "𝚙", "𝔭"},
            q = {"ԛ", "ⓠ", "𝐪", "𝗊", "𝓆", "𝚚", "𝔮"},
            r = {"г", "ṙ", "ⓡ", "𝐫", "𝗋", "𝓇", "𝚛", "𝔯"},
            s = {"ѕ", "ʂ", "ⓢ", "𝐬", "𝗌", "𝓈", "𝚜", "𝔰"},
            t = {"τ", "ṫ", "ⓣ", "𝐭", "𝗍", "𝓉", "𝚝", "𝔱"},
            u = {"υ", "μ", "ⓤ", "𝐮", "𝗎", "𝓊", "𝚞", "𝔲"},
            v = {"ν", "ṿ", "ⓥ", "𝐯", "𝗏", "𝓋", "𝚟", "𝔳"},
            w = {"ԝ", "ⓦ", "𝐰", "𝗐", "𝓌", "𝚠", "𝔴"},
            x = {"χ", "ϰ", "ⓧ", "𝐱", "𝗑", "𝓍", "𝚡", "𝔵"},
            y = {"у", "γ", "ⓨ", "𝐲", "𝗒", "𝓎", "𝚢", "𝔶"},
            z = {"ζ", "ź", "ⓩ", "𝐳", "𝗓", "𝓏", "𝚣", "𝔷"},
            A = {"А", "Α", "Ⓐ", "𝐀", "𝖠", "𝒜", "𝙰", "𝔄"},
            B = {"В", "Β", "Ⓑ", "𝐁", "𝖡", "𝒝", "𝙱", "𝔅"},
            C = {"С", "Ⓒ", "𝐂", "𝖢", "𝒞", "𝙲", "𝕮"},
            D = {"Ḏ", "Ⓓ", "𝐃", "𝖣", "𝒟", "𝙳", "𝔇"},
            E = {"Ε", "ℰ", "Ⓔ", "𝐄", "𝖤", "𝒟", "𝙴", "𝔈"},
            F = {"ℱ", "Ⓕ", "𝐅", "𝖥", "𝒻", "𝙵", "𝔉"},
            G = {"⅁", "Ⓖ", "𝐆", "𝖦", "𝒢", "𝙶", "𝔊"},
            H = {"Η", "Ⓗ", "𝐇", "𝖧", "𝒽", "𝙷", "𝕳"},
            I = {"Ι", "Ⓘ", "𝐈", "𝖨", "𝐼", "𝙸", "𝕴"},
            J = {"Ⓙ", "𝐉", "𝖩", "𝒥", "𝙹", "𝔍"},
            K = {"Κ", "Ⓚ", "𝐊", "𝖪", "𝒦", "𝙺", "𝔎"},
            L = {"Ⅼ", "Ⓛ", "𝐋", "𝖫", "𝐿", "𝙻", "𝔏"},
            M = {"Μ", "Ⓜ", "𝐌", "𝖬", "𝓂", "𝙼", "𝕸"},
            N = {"Ν", "Ⓝ", "𝐍", "𝖭", "𝒩", "𝙽", "𝔑"},
            O = {"Ο", "〇", "Ⓞ", "𝐎", "𝖮", "𝒪", "𝙾", "𝔒"},
            P = {"Ρ", "Ⓟ", "𝐏", "𝖯", "𝒫", "𝙿", "𝔓"},
            Q = {"Ⓠ", "𝐐", "𝖰", "𝒬", "𝚀", "𝔔"},
            R = {"Ṙ", "Ⓡ", "𝐑", "𝖱", "𝑅", "𝚁", "𝕽"},
            S = {"Ѕ", "Ⓢ", "𝐒", "𝖲", "𝒮", "𝚂", "𝔖"},
            T = {"Τ", "Ⓣ", "𝐓", "𝖳", "𝒯", "𝚃", "𝔗"},
            U = {"⋃", "Ⓤ", "𝐔", "𝖴", "𝒰", "𝚄", "𝔘"},
            V = {"∨", "Ⓥ", "𝐕", "𝖵", "𝒱", "𝚅", "𝔙"},
            W = {"Ԝ", "Ⓦ", "𝐖", "𝖶", "𝒲", "𝚆", "𝔚"},
            X = {"Χ", "Ⓧ", "𝐗", "𝖷", "𝒳", "𝚇", "𝔛"},
            Y = {"Υ", "Ⓨ", "𝐘", "𝖸", "𝒴", "𝚈", "𝔜"},
            Z = {"Ζ", "Ⓩ", "𝐙", "𝖹", "𝒵", "𝚉", "𝔛"}
        }
    },
    ZALGO = {
        name = "Zalgo Distortion",
        enabled = false,
        -- Combining diacritical marks for zalgo effect
        marks = {
            "̵", "̶", "̷", "̸", "̻", "̹", "̬", "̥", "̩", "̪", "̫", "͇", "͈", "͉", "͎", "͐",
            "͑", "͒", "͗", "ͣ", "ͤ", "ͥ", "ͦ", "ͧ", "ͨ", "ͩ", "ͪ", "ͫ", "ͬ", "ͭ", "ͮ", "ͯ",
            "̚", "̛", "̜", "̝", "̞", "̟", "̠", "̤", "̥", "̦", "̩", "̪", "̫", "̬", "̭", "̮",
            "̰", "̱", "̲", "̳", "̹", "̺", "̻", "̼", "̽", "̾", "̿", "̀", "́", "͂", "̓", "̈́"
        },
        intensity = 3
    },
    INVISIBLE = {
        name = "Invisible Chars",
        enabled = false,
        -- Various invisible/special characters
        chars = {
            "​", -- Zero-width space
            "‌", -- Zero-width non-joiner
            "‍", -- Zero-width joiner
            "⁠", -- Word joiner
            "", -- Zero-width no-break space
            " ", -- En quad
            " ", -- Em quad
            " ", -- Three-per-em space
            " ", -- Four-per-em space
            " ", -- Six-per-em space
            " ", -- Figure space
            " ", -- Punctuation space
            " ", -- Thin space
            " ", -- Hair space
            "​", "‌", "‍"
        }
    },
    SPACING = {
        name = "Special Spacing",
        enabled = false,
        useZeroWidth = true,
        spacingChar = "​",
        everyNChars = 1
    },
    VERTICAL = {
        name = "Vertical Text",
        enabled = false
    },
    UPSIDEDOWN = {
        name = "Upside Down",
        enabled = false,
        map = {
            a = "ɐ", b = "q", c = "ɔ", d = "p", e = "ǝ", f = "ɟ", g = "ƃ", h = "ɥ", i = "ᴉ",
            j = "ɾ", k = "ʞ", l = "l", m = "ɯ", n = "u", o = "o", p = "d", q = "b", r = "ɹ",
            s = "s", t = "ʇ", u = "n", v = "ʌ", w = "ʍ", x = "x", y = "ʎ", z = "z",
            A = "∀", B = "q", C = "Ɔ", D = "p", E = "Ǝ", F = "Ⅎ", G = "⅁", H = "H", I = "I",
            J = "ſ", K = "ʞ", L = "˥", M = "W", N = "N", O = "O", P = "Ԁ", Q = "Q", R = "ᴚ",
            S = "S", T = "⊥", U = "∩", V = "Λ", W = "M", X = "X", Y = "⅄", Z = "Z",
            ["1"] = "Ɩ", ["2"] = "ᄅ", ["3"] = "Ɛ", ["4"] = "ㄣ", ["5"] = "ϛ", ["6"] = "9",
            ["7"] = "ㄥ", ["8"] = "8", ["9"] = "6", ["0"] = "0",
            ["!"] = "¡", ["?"] = "¿", ["."] = "˙", [","] = "‘", ["'"] = ",", ['"'] = "„"
        }
    },
    FANCY = {
        name = "Fancy Font",
        enabled = false,
        style = 1, -- Different font styles
        fonts = {
            -- Circled
            {["a"] = "ⓐ", ["b"] = "ⓑ", ["c"] = "ⓒ", ["d"] = "ⓓ", ["e"] = "ⓔ", ["f"] = "ⓕ", ["g"] = "ⓖ", ["h"] = "ⓗ", ["i"] = "ⓘ", ["j"] = "ⓙ", ["k"] = "ⓚ", ["l"] = "ⓛ", ["m"] = "ⓜ", ["n"] = "ⓝ", ["o"] = "ⓞ", ["p"] = "ⓟ", ["q"] = "ⓠ", ["r"] = "ⓡ", ["s"] = "ⓢ", ["t"] = "ⓣ", ["u"] = "ⓤ", ["v"] = "ⓥ", ["w"] = "ⓦ", ["x"] = "ⓧ", ["y"] = "ⓨ", ["z"] = "ⓩ"},
            -- Squared
            {["a"] = "🄰", ["b"] = "🄱", ["c"] = "🄲", ["d"] = "🄳", ["e"] = "🄴", ["f"] = "🄵", ["g"] = "🄶", ["h"] = "🄷", ["i"] = "🄸", ["j"] = "🄹", ["k"] = "🄺", ["l"] = "🄻", ["m"] = "🄼", ["n"] = "🄽", ["o"] = "🄾", ["p"] = "🄿", ["q"] = "🅀", ["r"] = "🅁", ["s"] = "🅂", ["t"] = "🅃", ["u"] = "🅄", ["v"] = "🅅", ["w"] = "🅆", ["x"] = "🅇", ["y"] = "🅈", ["z"] = "🅉"},
            -- Bold
            {["a"] = "𝐚", ["b"] = "𝐛", ["c"] = "𝐜", ["d"] = "𝐝", ["e"] = "𝐞", ["f"] = "𝐟", ["g"] = "𝐠", ["h"] = "𝐡", ["i"] = "𝐢", ["j"] = "𝐣", ["k"] = "𝐤", ["l"] = "𝐥", ["m"] = "𝐦", ["n"] = "𝐧", ["o"] = "𝐨", ["p"] = "𝐩", ["q"] = "𝐪", ["r"] = "𝐫", ["s"] = "𝐬", ["t"] = "𝐭", ["u"] = "𝐮", ["v"] = "𝐯", ["w"] = "𝐰", ["x"] = "𝐱", ["y"] = "𝐲", ["z"] = "𝐳", ["A"] = "𝐀", ["B"] = "𝐁", ["C"] = "𝐂", ["D"] = "𝐃", ["E"] = "𝐄", ["F"] = "𝐅", ["G"] = "𝐆", ["H"] = "𝐇", ["I"] = "𝐈", ["J"] = "𝐉", ["K"] = "𝐊", ["L"] = "𝐋", ["M"] = "𝐌", ["N"] = "𝐍", ["O"] = "𝐎", ["P"] = "𝐏", ["Q"] = "𝐐", ["R"] = "𝐑", ["S"] = "𝐒", ["T"] = "𝐓", ["U"] = "𝐔", ["V"] = "𝐕", ["W"] = "𝐖", ["X"] = "𝐗", ["Y"] = "𝐘", ["Z"] = "𝐙"},
            -- Script
            {["a"] = "𝒶", ["b"] = "𝒷", ["c"] = "𝒸", ["d"] = "𝒹", ["e"] = "ℯ", ["f"] = "𝒻", ["g"] = "ℊ", ["h"] = "𝒽", ["i"] = "𝒾", ["j"] = "𝒿", ["k"] = "𝓀", ["l"] = "𝓁", ["m"] = "𝓂", ["n"] = "𝓃", ["o"] = "ℴ", ["p"] = "𝓅", ["q"] = "𝓆", ["r"] = "𝓇", ["s"] = "𝓈", ["t"] = "𝓉", ["u"] = "𝓊", ["v"] = "𝓋", ["w"] = "𝓌", ["x"] = "𝓍", ["y"] = "𝓎", ["z"] = "𝓏", ["A"] = "𝒜", ["B"] = "𝐵", ["C"] = "𝒞", ["D"] = "𝒟", ["E"] = "ℰ", ["F"] = "ℱ", ["G"] = "𝒢", ["H"] = "ℋ", ["I"] = "ℐ", ["J"] = "𝒥", ["K"] = "𝒦", ["L"] = "ℒ", ["M"] = "ℳ", ["N"] = "𝒩", ["O"] = "𝒪", ["P"] = "𝒫", ["Q"] = "𝒬", ["R"] = "ℛ", ["S"] = "𝒮", ["T"] = "𝒯", ["U"] = "𝒰", ["V"] = "𝒱", ["W"] = "𝒲", ["X"] = "𝒳", ["Y"] = "𝒴", ["Z"] = "𝒵"},
            -- Fraktur
            {["a"] = "𝔞", ["b"] = "𝔟", ["c"] = "𝔠", ["d"] = "𝔡", ["e"] = "𝔢", ["f"] = "𝔣", ["g"] = "𝔤", ["h"] = "𝔥", ["i"] = "𝔦", ["j"] = "𝔧", ["k"] = "𝔨", ["l"] = "𝔩", ["m"] = "𝔪", ["n"] = "𝔫", ["o"] = "𝔬", ["p"] = "𝔭", ["q"] = "𝔮", ["r"] = "𝔯", ["s"] = "𝔰", ["t"] = "𝔱", ["u"] = "𝔲", ["v"] = "𝔳", ["w"] = "𝔴", ["x"] = "𝔵", ["y"] = "𝔶", ["z"] = "𝔷", ["A"] = "𝔄", ["B"] = "𝔅", ["C"] = "ℭ", ["D"] = "𝔇", ["E"] = "𝔈", ["F"] = "𝔉", ["G"] = "𝔊", ["H"] = "ℌ", ["I"] = "ℑ", ["J"] = "𝔍", ["K"] = "𝔎", ["L"] = "𝔏", ["M"] = "𝔐", ["N"] = "𝔑", ["O"] = "𝔒", ["P"] = "𝔓", ["Q"] = "𝔔", ["R"] = "ℜ", ["S"] = "𝔖", ["T"] = "𝔗", ["U"] = "𝔘", ["V"] = "𝔙", ["W"] = "𝔚", ["X"] = "𝔛", ["Y"] = "𝔜", ["Z"] = "ℨ"}
        }
    },
    EMOTICON = {
        name = "Emoticon Insert",
        enabled = false,
        emoticons = {"☆", "★", "♦", "♢", "♠", "♣", "♡", "♥", "❤", "✧", "✦", "◆", "◇", "❀", "✿", "❁", "✾", "❃", "❋", "✱", "✲", "✻", "✼", "❈", "❉", "❊", "✫", "✬", "✭", "✮", "✯", "✰", "✴", "✵", "✶", "✷", "✸", "✹", "❂", "❄", "❅", "❆", "❇", "❖", "⟡", "⬥", "⬢", "⬣", "⬟", "⬠", "⯃", "⬤", "⬡", "⬦", "⬧", "⬨", "⬩"},
        position = "end", -- "start", "end", "both", "random"
        frequency = 1 -- Every N messages
    },
    LEETSPEAK = {
        name = "Leetspeak",
        enabled = false,
        intensity = 1, -- 1 = light, 2 = medium, 3 = full
        maps = {
            -- Light leet
            {
                e = "3", a = "4", o = "0", i = "1", s = "5", t = "7"
            },
            -- Medium leet
            {
                a = "4", b = "8", e = "3", g = "6", i = "1", o = "0", s = "5", t = "7", l = "1", z = "2"
            },
            -- Full leet
            {
                a = "4", b = "|3", c = "(", d = "|)", e = "3", f = "|=", g = "6", h = "|-|", i = "1", j = "_|",
                k = "|<", l = "1", m = "|\\/|", n = "|\\|", o = "0", p = "|>", q = "(_,)", r = "|2", s = "5",
                t = "7", u = "|_|", v = "\\/", w = "\\/\\/", x = "><", y = "`/", z = "2"
            }
        }
    },
    CASETOGGLE = {
        name = "Case Toggle",
        enabled = false,
        mode = "random" -- "random", "alternate", "camel"
    },
    SPOILER = {
        name = "Spoiler Tags",
        enabled = false,
        char = "||"
    }
}

-- Active bypass configuration
local activeBypasses = {}
local bypassIntensity = 1
local lastEmoticonCount = 0

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BypassChatGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Name = "BypassFrame"
frame.Size = UDim2.new(0, 280, 0, 420)
frame.Position = UDim2.new(0.5, -140, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(80, 60, 120)
frameStroke.Thickness = 2
frameStroke.Parent = frame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 35, 65)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 15)
titleFix.Position = UDim2.new(0, 0, 1, -15)
titleFix.BackgroundColor3 = Color3.fromRGB(45, 35, 65)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
titleLabel.Text = "🔮 Chat Bypass"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Bypass Toggle (Main)
local mainToggle = Instance.new("TextButton")
mainToggle.Size = UDim2.new(0, 50, 0, 25)
mainToggle.Position = UDim2.new(1, -55, 0, 5)
mainToggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
mainToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
mainToggle.Text = "OFF"
mainToggle.Font = Enum.Font.GothamBold
mainToggle.TextSize = 11
mainToggle.Parent = titleBar

local mainToggleCorner = Instance.new("UICorner")
mainToggleCorner.CornerRadius = UDim.new(0, 6)
mainToggleCorner.Parent = mainToggle

local bypassEnabled = false

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -45)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = frame

-- Input Section Label
local inputLabel = Instance.new("TextLabel")
inputLabel.Size = UDim2.new(1, 0, 0, 20)
inputLabel.Position = UDim2.new(0, 0, 0, 0)
inputLabel.BackgroundTransparency = 1
inputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
inputLabel.Text = "Message Input:"
inputLabel.Font = Enum.Font.GothamBold
inputLabel.TextSize = 12
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.Parent = contentFrame

-- Input Textbox
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, 0, 0, 80)
inputBox.Position = UDim2.new(0, 0, 0, 22)
inputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.Text = ""
inputBox.PlaceholderText = "Type your message here..."
inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 14
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.TextYAlignment = Enum.TextYAlignment.Top
inputBox.ClearTextOnFocus = false
inputBox.MultiLine = true
inputBox.TextWrapped = true
inputBox.Parent = contentFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputBox

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(70, 50, 100)
inputStroke.Thickness = 1
inputStroke.Parent = inputBox

-- Output Section Label
local outputLabel = Instance.new("TextLabel")
outputLabel.Size = UDim2.new(1, 0, 0, 20)
outputLabel.Position = UDim2.new(0, 0, 0, 108)
outputLabel.BackgroundTransparency = 1
outputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
outputLabel.Text = "Bypassed Output:"
outputLabel.Font = Enum.Font.GothamBold
outputLabel.TextSize = 12
outputLabel.TextXAlignment = Enum.TextXAlignment.Left
outputLabel.Parent = contentFrame

-- Output Textbox
local outputBox = Instance.new("TextBox")
outputBox.Size = UDim2.new(1, 0, 0, 60)
outputBox.Position = UDim2.new(0, 0, 0, 130)
outputBox.BackgroundColor3 = Color3.fromRGB(30, 45, 35)
outputBox.TextColor3 = Color3.fromRGB(150, 255, 150)
outputBox.Text = ""
outputBox.PlaceholderText = "Bypassed message will appear here..."
outputBox.PlaceholderColor3 = Color3.fromRGB(80, 120, 80)
outputBox.Font = Enum.Font.Gotham
outputBox.TextSize = 13
outputBox.TextXAlignment = Enum.TextXAlignment.Left
outputBox.TextYAlignment = Enum.TextYAlignment.Top
outputBox.ClearTextOnFocus = false
outputBox.MultiLine = true
outputBox.TextWrapped = true
outputBox.ReadOnly = true
outputBox.Parent = contentFrame

local outputCorner = Instance.new("UICorner")
outputCorner.CornerRadius = UDim.new(0, 8)
outputCorner.Parent = outputBox

local outputStroke = Instance.new("UIStroke")
outputStroke.Color = Color3.fromRGB(50, 100, 50)
outputStroke.Thickness = 1
outputStroke.Parent = outputBox

-- Action Buttons Row
local actionRow = Instance.new("Frame")
actionRow.Size = UDim2.new(1, 0, 0, 32)
actionRow.Position = UDim2.new(0, 0, 0, 196)
actionRow.BackgroundTransparency = 1
actionRow.Parent = contentFrame

local bypassBtn = Instance.new("TextButton")
bypassBtn.Size = UDim2.new(0.33, -3, 1, 0)
bypassBtn.Position = UDim2.new(0, 0, 0, 0)
bypassBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 180)
bypassBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bypassBtn.Text = "🔮 Bypass"
bypassBtn.Font = Enum.Font.GothamBold
bypassBtn.TextSize = 12
bypassBtn.Parent = actionRow

local bypassBtnCorner = Instance.new("UICorner")
bypassBtnCorner.CornerRadius = UDim.new(0, 6)
bypassBtnCorner.Parent = bypassBtn

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.33, -3, 1, 0)
copyBtn.Position = UDim2.new(0.33, 2, 0, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 160)
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Text = "📋 Copy"
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 12
copyBtn.Parent = actionRow

local copyBtnCorner = Instance.new("UICorner")
copyBtnCorner.CornerRadius = UDim.new(0, 6)
copyBtnCorner.Parent = copyBtn

local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0.34, -3, 1, 0)
sendBtn.Position = UDim2.new(0.66, 4, 0, 0)
sendBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendBtn.Text = "📤 Send"
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 12
sendBtn.Parent = actionRow

local sendBtnCorner = Instance.new("UICorner")
sendBtnCorner.CornerRadius = UDim.new(0, 6)
sendBtnCorner.Parent = sendBtn

-- Methods Section Label
local methodsLabel = Instance.new("TextLabel")
methodsLabel.Size = UDim2.new(1, 0, 0, 20)
methodsLabel.Position = UDim2.new(0, 0, 0, 236)
methodsLabel.BackgroundTransparency = 1
methodsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
methodsLabel.Text = "Bypass Methods:"
methodsLabel.Font = Enum.Font.GothamBold
methodsLabel.TextSize = 12
methodsLabel.TextXAlignment = Enum.TextXAlignment.Left
methodsLabel.Parent = contentFrame

-- Methods ScrollingFrame
local methodsScroll = Instance.new("ScrollingFrame")
methodsScroll.Size = UDim2.new(1, 0, 1, -260)
methodsScroll.Position = UDim2.new(0, 0, 0, 258)
methodsScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
methodsScroll.ScrollBarThickness = 4
methodsScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 150)
methodsScroll.Parent = contentFrame

local methodsScrollCorner = Instance.new("UICorner")
methodsScrollCorner.CornerRadius = UDim.new(0, 8)
methodsScrollCorner.Parent = methodsScroll

local methodsLayout = Instance.new("UIListLayout")
methodsLayout.Padding = UDim.new(0, 4)
methodsLayout.Parent = methodsScroll

local methodsPadding = Instance.new("UIPadding")
methodsPadding.PaddingTop = UDim.new(0, 6)
methodsPadding.PaddingLeft = UDim.new(0, 6)
methodsPadding.PaddingRight = UDim.new(0, 6)
methodsPadding.Parent = methodsScroll

-- ========== BYPASS FUNCTIONS ==========

local function applyUnicodeBypass(text)
    local result = ""
    for char in text:gmatch(".") do
        local lowerChar = char:lower()
        if bypassMethods.UNICODE.map[lowerChar] then
            local alternatives = bypassMethods.UNICODE.map[lowerChar]
            local replacement = alternatives[math.random(1, #alternatives)]
            -- Preserve case approximation
            if char:upper() == char and char:lower() ~= char then
                result = result .. replacement
            else
                result = result .. replacement
            end
        else
            result = result .. char
        end
    end
    return result
end

local function applyZalgoBypass(text)
    local result = ""
    local marks = bypassMethods.ZALGO.marks
    local intensity = bypassMethods.ZALGO.intensity
    
    for char in text:gmatch(".") do
        result = result .. char
        if char:match("%a") then
            for _ = 1, math.random(1, intensity) do
                result = result .. marks[math.random(1, #marks)]
            end
        end
    end
    return result
end

local function applyInvisibleBypass(text)
    local result = ""
    local chars = bypassMethods.INVISIBLE.chars
    
    for char in text:gmatch(".") do
        result = result .. char
        if char ~= " " and math.random() < 0.5 then
            result = result .. chars[math.random(1, #chars)]
        end
    end
    return result
end

local function applySpacingBypass(text)
    local result = ""
    local zw = bypassMethods.SPACING.spacingChar
    
    for char in text:gmatch(".") do
        result = result .. char
        if char ~= " " then
            result = result .. zw
        end
    end
    return result
end

local function applyVerticalBypass(text)
    local result = ""
    for i, char in ipairs(text:gmatch(".")) do
        if i > 1 then
            result = result .. "\n"
        end
        result = result .. char
    end
    return result
end

local function applyUpsideDownBypass(text)
    local result = ""
    local map = bypassMethods.UPSIDEDOWN.map
    
    -- Reverse and convert
    for i = #text, 1, -1 do
        local char = text:sub(i, i)
        if map[char] then
            result = result .. map[char]
        else
            result = result .. char
        end
    end
    return result
end

local function applyFancyBypass(text)
    local result = ""
    local font = bypassMethods.FANCY.fonts[bypassMethods.FANCY.style]
    
    if not font then return text end
    
    for char in text:gmatch(".") do
        if font[char] then
            result = result .. font[char]
        elseif font[char:lower()] then
            result = result .. font[char:lower()]
        else
            result = result .. char
        end
    end
    return result
end

local function applyEmoticonBypass(text)
    local emoticons = bypassMethods.EMOTICON.emoticons
    local position = bypassMethods.EMOTICON.position
    local emote = emoticons[math.random(1, #emoticons)]
    
    if position == "start" then
        return emote .. " " .. text
    elseif position == "end" then
        return text .. " " .. emote
    elseif position == "both" then
        return emote .. " " .. text .. " " .. emoticons[math.random(1, #emoticons)]
    else -- random
        if math.random() < 0.5 then
            return emote .. " " .. text
        else
            return text .. " " .. emote
        end
    end
end

local function applyLeetspeakBypass(text)
    local result = ""
    local map = bypassMethods.LEETSPEAK.maps[bypassMethods.LEETSPEAK.intensity] or bypassMethods.LEETSPEAK.maps[1]
    
    for char in text:gmatch(".") do
        local lowerChar = char:lower()
        if map[lowerChar] and math.random() < 0.7 then
            result = result .. map[lowerChar]
        else
            result = result .. char
        end
    end
    return result
end

local function applyCaseToggleBypass(text)
    local result = ""
    local mode = bypassMethods.CASETOGGLE.mode
    local upper = false
    
    for i, char in ipairs(text:gmatch(".")) do
        if mode == "random" then
            if math.random() < 0.5 then
                result = result .. char:upper()
            else
                result = result .. char:lower()
            end
        elseif mode == "alternate" then
            if upper then
                result = result .. char:upper()
            else
                result = result .. char:lower()
            end
            upper = not upper
        else -- camel
            if i == 1 or (text:sub(i-1, i-1) == " ") then
                result = result .. char:upper()
            else
                result = result .. char:lower()
            end
        end
    end
    return result
end

local function applySpoilerBypass(text)
    return bypassMethods.SPOILER.char .. text .. bypassMethods.SPOILER.char
end

local function applyBypass(text)
    if not bypassEnabled or text == "" then
        return text
    end
    
    local result = text
    
    -- Apply active bypasses in order
    for _, methodName in ipairs(activeBypasses) do
        if methodName == "UNICODE" and bypassMethods.UNICODE.enabled then
            result = applyUnicodeBypass(result)
        elseif methodName == "ZALGO" and bypassMethods.ZALGO.enabled then
            result = applyZalgoBypass(result)
        elseif methodName == "INVISIBLE" and bypassMethods.INVISIBLE.enabled then
            result = applyInvisibleBypass(result)
        elseif methodName == "SPACING" and bypassMethods.SPACING.enabled then
            result = applySpacingBypass(result)
        elseif methodName == "VERTICAL" and bypassMethods.VERTICAL.enabled then
            result = applyVerticalBypass(result)
        elseif methodName == "UPSIDEDOWN" and bypassMethods.UPSIDEDOWN.enabled then
            result = applyUpsideDownBypass(result)
        elseif methodName == "FANCY" and bypassMethods.FANCY.enabled then
            result = applyFancyBypass(result)
        elseif methodName == "EMOTICON" and bypassMethods.EMOTICON.enabled then
            result = applyEmoticonBypass(result)
        elseif methodName == "LEETSPEAK" and bypassMethods.LEETSPEAK.enabled then
            result = applyLeetspeakBypass(result)
        elseif methodName == "CASETOGGLE" and bypassMethods.CASETOGGLE.enabled then
            result = applyCaseToggleBypass(result)
        elseif methodName == "SPOILER" and bypassMethods.SPOILER.enabled then
            result = applySpoilerBypass(result)
        end
    end
    
    return result
end

-- ========== SEND MESSAGE ==========

local function sendMessage(msg)
    local message = msg or outputBox.Text
    message = message:gsub("^%s+", ""):gsub("%s+$", "")
    
    if message == "" then
        return false
    end
    
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    
    if chatRemote then
        local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(message, "All")
            return true
        end
    end
    
    if TextChatService then
        local channel = TextChatService:FindFirstChild("TextChannels")
        if channel then
            local rbxGeneral = channel:FindFirstChild("RBXGeneral")
            if rbxGeneral then
                rbxGeneral:SendAsync(message)
                return true
            end
        end
    end
    
    return false
end

-- ========== CREATE METHOD TOGGLES ==========

local methodToggles = {}

local function createMethodToggle(methodKey, data, parent)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 36)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    toggleFrame.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 24)
    toggleBtn.Position = UDim2.new(1, -55, 0.5, -12)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Text = "OFF"
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 10
    toggleBtn.Parent = toggleFrame
    
    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(0, 5)
    toggleBtnCorner.Parent = toggleBtn
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -60, 1, 0)
    nameLabel.Position = UDim2.new(0, 8, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    nameLabel.Text = data.name
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 12
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = toggleFrame
    
    toggleBtn.MouseButton1Click:Connect(function()
        data.enabled = not data.enabled
        if data.enabled then
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
            if not table.find(activeBypasses, methodKey) then
                table.insert(activeBypasses, methodKey)
            end
        else
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
            local idx = table.find(activeBypasses, methodKey)
            if idx then
                table.remove(activeBypasses, idx)
            end
        end
    end)
    
    methodToggles[methodKey] = toggleBtn
end

-- Create all method toggles
for methodKey, data in pairs(bypassMethods) do
    createMethodToggle(methodKey, data, methodsScroll)
end

-- Update canvas size
methodsScroll.CanvasSize = UDim2.new(0, 0, 0, methodsLayout.AbsoluteContentSize.Y + 12)

-- ========== BUTTON HANDLERS ==========

bypassBtn.MouseButton1Click:Connect(function()
    local input = inputBox.Text
    if input ~= "" then
        local bypassed = applyBypass(input)
        outputBox.Text = bypassed
    end
end)

copyBtn.MouseButton1Click:Connect(function()
    if outputBox.Text ~= "" then
        -- Copy to clipboard
        local clipboard = outputBox.Text
        if setclipboard then
            setclipboard(clipboard)
        else
            -- Fallback: select text for manual copy
            outputBox:ReleaseFocus()
            outputBox.SelectionStart = 1
            outputBox.CursorPosition = #clipboard + 1
        end
        -- Flash green to indicate copied
        copyBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        copyBtn.Text = "✓ Copied!"
        wait(0.5)
        copyBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 160)
        copyBtn.Text = "📋 Copy"
    end
end)

sendBtn.MouseButton1Click:Connect(function()
    if bypassEnabled and inputBox.Text ~= "" then
        local bypassed = applyBypass(inputBox.Text)
        sendMessage(bypassed)
        outputBox.Text = bypassed
    elseif outputBox.Text ~= "" then
        sendMessage(outputBox.Text)
    end
end)

mainToggle.MouseButton1Click:Connect(function()
    bypassEnabled = not bypassEnabled
    if bypassEnabled then
        mainToggle.Text = "ON"
        mainToggle.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
    else
        mainToggle.Text = "OFF"
        mainToggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

-- Auto-bypass on input change
inputBox:GetPropertyChangedSignal("Text"):Connect(function()
    if bypassEnabled then
        local bypassed = applyBypass(inputBox.Text)
        outputBox.Text = bypassed
    end
end)

-- ========== DRAGGING ==========

local dragging = false
local dragInput
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.Y < (frame.AbsolutePosition.Y + 35) then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle GUI with RightControl
local guiVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        frame.Visible = guiVisible
    end
end)

print("🔮 Chat Bypass GUI Loaded - Press RightControl to toggle")
print("Available methods: Unicode, Zalgo, Invisible, Spacing, Vertical, UpsideDown, Fancy, Emoticon, Leetspeak, CaseToggle, Spoiler")
