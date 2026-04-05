-- NUCLEAR BYPASS SYSTEM v2.0
-- Uses rare Unicode, mathematical symbols, ancient scripts, and format exploits

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========== RARE UNICODE DATABASE ==========

-- Mathematical Alphanumeric Symbols (VERY rare, barely filtered)
local mathAlpha = {
	A = "𝔄", B = "𝔅", C = "ℭ", D = "𝔇", E = "𝔈", F = "𝔉", G = "𝔊", H = "ℌ", I = "ℑ", J = "𝔍",
	K = "𝔎", L = "𝔏", M = "𝔐", N = "𝔑", O = "𝔒", P = "𝔓", Q = "𝔔", R = "ℜ", S = "𝔖", T = "𝔗",
	U = "𝔘", V = "𝔙", W = "𝔚", X = "𝔛", Y = "𝔜", Z = "ℨ",
	a = "𝔞", b = "𝔟", c = "𝔠", d = "𝔡", e = "𝔢", f = "𝔣", g = "𝔤", h = "𝔥", i = "𝔦", j = "𝔧",
	k = "𝔨", l = "𝔩", m = "𝔪", n = "𝔫", o = "𝔬", p = "𝔭", q = "𝔮", r = "𝔯", s = "𝔰", t = "𝔱",
	u = "𝔲", v = "𝔳", w = "𝔴", x = "𝔵", y = "𝔶", z = "𝔷"
}

-- Double-struck mathematical (very rare)
local doubleStruck = {
	A = "𝔸", B = "𝔹", C = "ℂ", D = "𝔻", E = "𝔼", F = "𝔽", G = "𝔾", H = "ℍ", I = "𝕀", J = "𝕁",
	K = "𝕂", L = "𝕃", M = "𝕄", N = "ℕ", O = "𝕆", P = "ℙ", Q = "ℚ", R = "ℝ", S = "𝕊", T = "𝕋",
	U = "𝕌", V = "𝕍", W = "𝕎", X = "𝕏", Y = "𝕐", Z = "ℤ",
	a = "𝕒", b = "𝕓", c = "𝕔", d = "𝕕", e = "𝕖", f = "𝕗", g = "𝕘", h = "𝕙", i = "𝕚", j = "𝕛",
	k = "𝕜", l = "𝕝", m = "𝕞", n = "𝕟", o = "𝕠", p = "𝕡", q = "𝕢", r = "𝕣", s = "𝕤", t = "𝕥",
	u = "𝕦", v = "𝕧", w = "𝕨", x = "𝕩", y = "𝕪", z = "𝕫"
}

-- Fraktur bold (extremely rare)
local frakturBold = {
	A = "𝕬", B = "𝕭", C = "𝕮", D = "𝕯", E = "𝕰", F = "𝕱", G = "𝕲", H = "𝕳", I = "𝕴", J = "𝕵",
	K = "𝕶", L = "𝕷", M = "𝕸", N = "𝕹", O = "𝕺", P = "𝕻", Q = "𝕼", R = "𝕽", S = "𝕾", T = "𝕿",
	U = "𝖀", V = "𝖁", W = "𝖂", X = "𝖃", Y = "𝖄", Z = "𝖅"
}

-- Ancient Greek letters that look like English
local greekLookalikes = {
	A = "Α", B = "Β", E = "Ε", Z = "Ζ", H = "Η", I = "Ι", K = "Κ", M = "Μ", N = "Ν",
	O = "Ο", P = "Ρ", T = "Τ", Y = "Υ", X = "Χ",
	a = "α", e = "ε", i = "ι", o = "ο", u = "υ"
}

-- Coptic letters (ancient Egyptian, extremely rare in filtering)
local coptic = {
	A = "Ⲁ", B = "Ⲃ", C = "Ⲕ", D = "Ⲇ", E = "Ⲉ", F = "Ⲫ", G = "Ⲅ", H = "Ⲏ", I = "Ⲓ",
	K = "Ⲕ", L = "Ⲗ", M = "Ⲙ", N = "Ⲛ", O = "Ⲟ", P = "Ⲡ", Q = "Ϙ", R = "Ⲣ", S = "Ⲥ",
	T = "Ⲧ", U = "Ⲩ", V = "Ⲃ", X = "Ⲫ", Y = "Ⲩ", Z = "Ⲍ"
}

-- Glagolitic (oldest Slavic script, almost never filtered)
local glagolitic = {
	A = "Ⰰ", B = "Ⰱ", V = "Ⰲ", G = "Ⰳ", D = "Ⰴ", E = "Ⰵ", Z = "Ⰶ", I = "Ⰺ", K = "Ⰽ",
	L = "Ⰾ", M = "Ⰿ", N = "Ⱀ", O = "Ⱁ", P = "Ⱂ", R = "Ⱃ", S = "Ⱄ", T = "Ⱅ", U = "Ⱆ",
	F = "Ⱇ", H = "Ⱈ", C = "Ⱌ", Ch = "Ⱍ", Sh = "Ⱎ"
}

-- Armenian letters (look similar to English)
local armenian = {
	A = "Ա", B = "Բ", C = "Ծ", D = "Դ", E = "Ե", F = "Ֆ", G = "Գ", H = "Հ", I = "Ի",
	K = "Կ", L = "Լ", M = "Մ", N = "Ն", O = "Օ", P = "Պ", Q = "Ք", R = "Ռ", S = "Ս",
	T = "Տ", U = "Ո", V = "Վ", X = "Ձ", Y = "Յ", Z = "Զ"
}

-- Ethiopic (Ge'ez script, extremely rare)
local ethiopic = {
	A = "አ", B = "በ", C = "ቸ", D = "ደ", E = "አ", F = "ፈ", G = "ገ", H = "ሀ", I = "ኢ",
	K = "ከ", L = "ለ", M = "መ", N = "ነ", O = "ኦ", P = "ጰ", Q = "ቀ", R = "ረ", S = "ሰ",
	T = "ተ", U = "ኡ", V = "ቨ", W = "ወ", X = "ኀ", Y = "የ", Z = "ዘ"
}

-- Tifinagh (Berber script, North Africa)
local tifinagh = {
	A = "ⴰ", B = "ⴱ", C = "ⵛ", D = "ⴷ", E = "ⴻ", F = "ⴼ", G = "ⴳ", H = "ⵀ", I = "ⵉ",
	K = "ⴽ", L = "ⵍ", M = "ⵎ", N = "ⵏ", O = "ⵓ", P = "ⵒ", Q = "ⵇ", R = "ⵔ", S = "ⵙ",
	T = "ⵜ", U = "ⵓ", V = "ⵠ", W = "ⵡ", X = "ⵅ", Y = "ⵢ", Z = "ⵣ"
}

-- Superscript and subscript (often not filtered)
local superscripts = {
	A = "ᴬ", B = "ᴮ", C = "ᶜ", D = "ᴰ", E = "ᴱ", F = "ᶠ", G = "ᴳ", H = "ᴴ", I = "ᴵ",
	J = "ᴶ", K = "ᴷ", L = "ᴸ", M = "ᴹ", N = "ᴺ", O = "ᴼ", P = "ᴾ", Q = "ᵠ", R = "ᴿ",
	S = "ˢ", T = "ᵀ", U = "ᵁ", V = "ⱽ", W = "ᵂ", X = "ˣ", Y = "ʸ", Z = "ᶻ"
}

local subscripts = {
	A = "ₐ", B = "ᵦ", C = "ᶜ", D = "ᵈ", E = "ₑ", F = "ᶠ", G = "ᵍ", H = "ₕ", I = "ᵢ",
	K = "ₖ", L = "ₗ", M = "ₘ", N = "ₙ", O = "ₒ", P = "ᵖ", R = "ᵣ", S = "ₛ", T = "ᵗ",
	U = "ᵤ", V = "ᵥ", X = "ₓ", Z = "ᶻ"
}

-- Small caps (often bypass filters)
local smallCaps = {
	A = "ᴀ", B = "ʙ", C = "ᴄ", D = "ᴅ", E = "ᴇ", F = "ғ", G = "ɢ", H = "ʜ", I = "ɪ",
	J = "ᴊ", K = "ᴋ", L = "ʟ", M = "ᴍ", N = "ɴ", O = "ᴏ", P = "ᴘ", Q = "ǫ", R = "ʀ",
	S = "s", T = "ᴛ", U = "ᴜ", V = "ᴠ", W = "ᴡ", X = "x", Y = "ʏ", Z = "ᴢ"
}

-- Regional indicator symbols (for building letters)
local regionalIndicators = {
	A = "🇦", B = "🇧", C = "🇨", D = "🇩", E = "🇪", F = "🇫", G = "🇬", H = "🇭", I = "🇮",
	J = "🇯", K = "🇰", L = "🇱", M = "🇲", N = "🇳", O = "🇴", P = "🇵", Q = "🇶", R = "🇷",
	S = "🇸", T = "🇹", U = "🇺", V = "🇻", W = "🇼", X = "🇽", Y = "🇾", Z = "🇿"
}

-- Enclosed characters (square, circle, parenthesized)
local enclosed = {
	square = {A = "🄰", B = "🄱", C = "🄲", D = "🄳", E = "🄴", F = "🄵", G = "🄶", H = "🄷", I = "🄸",
		J = "🄹", K = "🄺", L = "🄻", M = "🄼", N = "🄽", O = "🄾", P = "🄿", Q = "🅀", R = "🅁",
		S = "🅂", T = "🅃", U = "🅄", V = "🅅", W = "🅆", X = "🅇", Y = "🅈", Z = "🅉"},
	circle = {A = "Ⓐ", B = "Ⓑ", C = "Ⓒ", D = "Ⓓ", E = "Ⓔ", F = "Ⓕ", G = "Ⓖ", H = "Ⓗ", I = "Ⓘ",
		J = "Ⓙ", K = "Ⓚ", L = "Ⓛ", M = "Ⓜ", N = "Ⓝ", O = "Ⓞ", P = "Ⓟ", Q = "Ⓠ", R = "Ⓡ",
		S = "Ⓢ", T = "Ⓣ", U = "Ⓤ", V = "Ⓥ", W = "Ⓦ", X = "Ⓧ", Y = "Ⓨ", Z = "Ⓩ"},
	paren = {A = "⒜", B = "⒝", C = "⒞", D = "⒟", E = "⒠", F = "⒡", G = "⒢", H = "⒣", I = "⒤",
		J = "⒥", K = "⒦", L = "⒧", M = "⒨", N = "⒩", O = "⒪", P = "⒫", Q = "⒬", R = "⒭",
		S = "⒮", T = "⒯", U = "⒰", V = "⒱", W = "⒲", X = "⒳", Y = "⒴", Z = "⒵"}
}

-- Full-width characters (Asian encoding, often bypass)
local fullWidth = {
	A = "Ａ", B = "Ｂ", C = "Ｃ", D = "Ｄ", E = "Ｅ", F = "Ｆ", G = "Ｇ", H = "Ｈ", I = "Ｉ",
	J = "Ｊ", K = "Ｋ", L = "Ｌ", M = "Ｍ", N = "Ｎ", O = "Ｏ", P = "Ｐ", Q = "Ｑ", R = "Ｒ",
	S = "Ｓ", T = "Ｔ", U = "Ｕ", V = "Ｖ", W = "Ｗ", X = "Ｘ", Y = "Ｙ", Z = "Ｚ",
	a = "ａ", b = "ｂ", c = "ｃ", d = "ｄ", e = "ｅ", f = "ｆ", g = "ｇ", h = "ｈ", i = "ｉ",
	j = "ｊ", k = "ｋ", l = "ｌ", m = "ｍ", n = "ｎ", o = "ｏ", p = "ｐ", q = "ｑ", r = "ｒ",
	s = "ｓ", t = "ｔ", u = "ｕ", v = "ｖ", w = "ｗ", x = "ｘ", y = "ｙ", z = "ｚ"
}

-- Format characters (invisible, extremely powerful)
local formatChars = {
	zeroWidthSpace = "\u{200B}",
	zeroWidthNonJoiner = "\u{200C}",
	zeroWidthJoiner = "\u{200D}",
	leftToRightMark = "\u{200E}",
	rightToLeftMark = "\u{200F}",
	leftToRightEmbedding = "\u{202A}",
	rightToLeftEmbedding = "\u{202B}",
	popDirectionalFormatting = "\u{202C}",
	leftToRightOverride = "\u{202D}",
	rightToLeftOverride = "\u{202E}",
	wordJoiner = "\u{2060}",
	functionApplication = "\u{2061}",
	invisibleSeparator = "\u{2063}",
	invisiblePlus = "\u{2064}",
	zeroWidthBrailleBlank = "\u{2800}",
	tagSpace = "\u{E0020}",
	cancelTag = "\u{E007F}"
}

-- Variation selectors (combine with other characters)
local variationSelectors = {
	"\u{FE00}", "\u{FE01}", "\u{FE02}", "\u{FE03}", "\u{FE04}",
	"\u{FE05}", "\u{FE06}", "\u{FE07}", "\u{FE08}", "\u{FE09}",
	"\u{FE0A}", "\u{FE0B}", "\u{FE0C}", "\u{FE0D}", "\u{FE0E}", "\u{FE0F}"
}

-- Combining diacritics (stack on letters)
local combiningMarks = {
	above = {"\u{0300}", "\u{0301}", "\u{0302}", "\u{0303}", "\u{0304}", "\u{0305}", "\u{0306}",
		"\u{0307}", "\u{0308}", "\u{0309}", "\u{030A}", "\u{030B}", "\u{030C}", "\u{030D}",
		"\u{030E}", "\u{030F}", "\u{0310}", "\u{0311}", "\u{0312}", "\u{0313}", "\u{0314}"},
	below = {"\u{0316}", "\u{0317}", "\u{0318}", "\u{0319}", "\u{031A}", "\u{031B}", "\u{031C}",
		"\u{031D}", "\u{031E}", "\u{031F}", "\u{0320}", "\u{0321}", "\u{0322}", "\u{0323}",
		"\u{0324}", "\u{0325}", "\u{0326}", "\u{0327}", "\u{0328}", "\u{0329}", "\u{032A}"},
	overlay = {"\u{0333}", "\u{0334}", "\u{0335}", "\u{0336}", "\u{0337}", "\u{0338}",
		"\u{0339}", "\u{033A}", "\u{033B}", "\u{033C}", "\u{033D}", "\u{033E}", "\u{033F}"}
}

-- Tag characters (hidden text that displays differently)
local tagChars = {}
for i = string.byte("A"), string.byte("Z") do
	tagChars[string.char(i)] = "\u{E0000}" .. string.char(i)
end

-- ========== BYPASS METHODS ==========

local function rareUnicodeBypass(text, scriptType)
	local script
	if scriptType == "math" then script = mathAlpha
	elseif scriptType == "double" then script = doubleStruck
	elseif scriptType == "fraktur" then script = frakturBold
	elseif scriptType == "greek" then script = greekLookalikes
	elseif scriptType == "coptic" then script = coptic
	elseif scriptType == "glagolitic" then script = glagolitic
	elseif scriptType == "armenian" then script = armenian
	elseif scriptType == "ethiopic" then script = ethiopic
	elseif scriptType == "tifinagh" then script = tifinagh
	elseif scriptType == "super" then script = superscripts
	elseif scriptType == "sub" then script = subscripts
	elseif scriptType == "smallcaps" then script = smallCaps
	elseif scriptType == "fullwidth" then script = fullWidth
	elseif scriptType == "regional" then script = regionalIndicators
	else script = mathAlpha end
	
	local result = ""
	for i = 1, #text do
		local char = string.sub(text, i, i)
		local upper = string.upper(char)
		if script[upper] then
			if scriptType == "regional" then
				result = result .. script[upper] .. " "
			elseif char == upper then
				result = result .. script[upper]
			else
				result = result .. (script[char] or script[upper]:lower() or char)
			end
		else
			result = result .. char
		end
	end
	return result
end

local function enclosedBypass(text, style)
	local encType = enclosed[style] or enclosed.square
	local result = ""
	for i = 1, #text do
		local char = string.upper(string.sub(text, i, i))
		if encType[char] then
			result = result .. encType[char]
		else
			result = result .. string.sub(text, i, i)
		end
	end
	return result
end

local function formatInjection(text, intensity)
	local result = ""
	local formats = {
		formatChars.zeroWidthSpace, formatChars.zeroWidthNonJoiner,
		formatChars.zeroWidthJoiner, formatChars.wordJoiner,
		formatChars.leftToRightMark, formatChars.rightToLeftMark,
		formatChars.invisibleSeparator
	}
	
	for i = 1, #text do
		result = result .. string.sub(text, i, i)
		if math.random(1, 100) <= intensity then
			result = result .. formats[math.random(1, #formats)]
			if math.random(1, 3) == 1 then
				result = result .. formats[math.random(1, #formats)]
			end
		end
	end
	return result
end

local function zalgoStack(text, intensity)
	local result = ""
	for i = 1, #text do
		local char = string.sub(text, i, i)
		result = result .. char
		
		local numAbove = math.random(0, intensity)
		local numBelow = math.random(0, math.floor(intensity / 2))
		local numOverlay = math.random(0, math.floor(intensity / 3))
		
		for _ = 1, numAbove do
			result = result .. combiningMarks.above[math.random(1, #combiningMarks.above)]
		end
		for _ = 1, numBelow do
			result = result .. combiningMarks.below[math.random(1, #combiningMarks.below)]
		end
		for _ = 1, numOverlay do
			result = result .. combiningMarks.overlay[math.random(1, #combiningMarks.overlay)]
		end
	end
	return result
end

local function variationSelectorBypass(text)
	local result = ""
	for i = 1, #text do
		result = result .. string.sub(text, i, i)
		if math.random(1, 3) == 1 then
			result = result .. variationSelectors[math.random(1, #variationSelectors)]
		end
	end
	return result
end

local function crazyMixedBypass(text)
	local scripts = {"math", "double", "greek", "coptic", "armenian", "tifinagh", "smallcaps", "fullwidth"}
	local enclosures = {"square", "circle", "paren"}
	local result = ""
	
	for i = 1, #text do
		local char = string.sub(text, i, i)
		local method = math.random(1, 10)
		
		if method <= 3 then
			-- Random script
			local script = scripts[math.random(1, #scripts)]
			result = result .. rareUnicodeBypass(char, script)
		elseif method <= 5 then
			-- Enclosed
			local style = enclosures[math.random(1, #enclosures)]
			result = result .. enclosedBypass(char, style)
		elseif method <= 7 then
			-- Superscript or subscript
			if math.random(1, 2) == 1 then
				result = result .. rareUnicodeBypass(char, "super")
			else
				result = result .. rareUnicodeBypass(char, "sub")
			end
		else
			-- Regular with format injection
			result = result .. char .. formatChars.zeroWidthNonJoiner
		end
	end
	
	return result
end

local function nuclearBypass(text)
	local result = text
	
	-- Layer 1: Rare script conversion
	local scripts = {"math", "coptic", "tifinagh", "armenian"}
	result = rareUnicodeBypass(result, scripts[math.random(1, #scripts)])
	
	-- Layer 2: Format injection
	result = formatInjection(result, 40)
	
	-- Layer 3: Zalgo
	result = zalgoStack(result, 3)
	
	-- Layer 4: Variation selectors
	result = variationSelectorBypass(result)
	
	return result
end

local function absoluteDestruction(text)
	local result = ""
	
	for i = 1, #text do
		local char = string.sub(text, i, i)
		local processed = char
		
		-- Apply random script
		local scripts = {"math", "double", "coptic", "ethiopic", "tifinagh"}
		processed = rareUnicodeBypass(processed, scripts[math.random(1, #scripts)])
		
		-- Add zero-width formats
		processed = processed .. formatChars.zeroWidthNonJoiner
		if math.random(1, 2) == 1 then
			processed = processed .. formatChars.wordJoiner
		end
		
		-- Add combining marks
		processed = processed .. combiningMarks.above[math.random(1, #combiningMarks.above)]
		if math.random(1, 3) == 1 then
			processed = processed .. combiningMarks.below[math.random(1, #combiningMarks.below)]
		end
		
		-- Variation selector
		if math.random(1, 4) == 1 then
			processed = processed .. variationSelectors[math.random(1, #variationSelectors)]
		end
		
		result = result .. processed
	end
	
	return result
end

-- ========== GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NuclearBypassV2"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Hub
local hubButton = Instance.new("Frame")
hubButton.Size = UDim2.new(0, 55, 0, 55)
hubButton.Position = UDim2.new(0, 15, 0.5, -27)
hubButton.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
hubButton.BorderSizePixel = 0
hubButton.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 12)
hubCorner.Parent = hubButton

local hubStroke = Instance.new("UIStroke")
hubStroke.Color = Color3.fromRGB(150, 0, 255)
hubStroke.Thickness = 2
hubStroke.Parent = hubButton

local hubGradient = Instance.new("UIGradient")
hubGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 150))
})
hubGradient.Parent = hubButton

local hubIcon = Instance.new("TextLabel")
hubIcon.Size = UDim2.new(1, 0, 1, 0)
hubIcon.BackgroundTransparency = 1
hubIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
hubIcon.Text = "☠"
hubIcon.Font = Enum.Font.GothamBold
hubIcon.TextSize = 28
hubIcon.Parent = hubButton

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 580)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(150, 0, 255)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Title
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 150))
})
titleGradient.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 15)
titleFix.Position = UDim2.new(0, 0, 1, -15)
titleFix.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "☠ NUCLEAR BYPASS v2.0"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -38, 0.5, -16)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -55)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Original Input
local inputLabel = Instance.new("TextLabel")
inputLabel.Size = UDim2.new(1, 0, 0, 20)
inputLabel.BackgroundTransparency = 1
inputLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
inputLabel.Text = "ORIGINAL MESSAGE"
inputLabel.Font = Enum.Font.GothamBold
inputLabel.TextSize = 11
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.Parent = content

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, 0, 0, 70)
inputBox.Position = UDim2.new(0, 0, 0, 22)
inputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.Text = ""
inputBox.PlaceholderText = "Enter message to bypass..."
inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
inputBox.Font = Enum.Font.Code
inputBox.TextSize = 14
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.TextYAlignment = Enum.TextYAlignment.Top
inputBox.ClearTextOnFocus = false
inputBox.MultiLine = true
inputBox.TextWrapped = true
inputBox.Parent = content

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputBox

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(80, 80, 100)
inputStroke.Thickness = 1
inputStroke.Parent = inputBox

-- Method Selection
local methodLabel = Instance.new("TextLabel")
methodLabel.Size = UDim2.new(1, 0, 0, 20)
methodLabel.Position = UDim2.new(0, 0, 0, 98)
methodLabel.BackgroundTransparency = 1
methodLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
methodLabel.Text = "BYPASS METHOD (Select One)"
methodLabel.Font = Enum.Font.GothamBold
methodLabel.TextSize = 11
methodLabel.TextXAlignment = Enum.TextXAlignment.Left
methodLabel.Parent = content

local methodsContainer = Instance.new("ScrollingFrame")
methodsContainer.Size = UDim2.new(1, 0, 0, 140)
methodsContainer.Position = UDim2.new(0, 0, 0, 120)
methodsContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
methodsContainer.ScrollBarThickness = 4
methodsContainer.ScrollBarImageColor3 = Color3.fromRGB(150, 0, 255)
methodsContainer.Parent = content

local methodsCorner = Instance.new("UICorner")
methodsCorner.CornerRadius = UDim.new(0, 8)
methodsCorner.Parent = methodsContainer

local methodsStroke = Instance.new("UIStroke")
methodsStroke.Color = Color3.fromRGB(50, 50, 70)
methodsStroke.Thickness = 1
methodsStroke.Parent = methodsContainer

local methodsLayout = Instance.new("UIGridLayout")
methodsLayout.CellSize = UDim2.new(0.48, 0, 0, 32)
methodsLayout.CellPadding = UDim2.new(0, 6, 0, 6)
methodsLayout.Parent = methodsContainer

local methods = {
	{name = "MATHEMATICAL", desc = "Math symbols", func = function(t) return rareUnicodeBypass(t, "math") end},
	{name = "DOUBLE-STRUCK", desc = "Bold math", func = function(t) return rareUnicodeBypass(t, "double") end},
	{name = "FRAKTUR", desc = "Gothic script", func = function(t) return rareUnicodeBypass(t, "fraktur") end},
	{name = "GREEK", desc = "Greek letters", func = function(t) return rareUnicodeBypass(t, "greek") end},
	{name = "COPTIC", desc = "Ancient Egyptian", func = function(t) return rareUnicodeBypass(t, "coptic") end},
	{name = "GLAGOLITIC", desc = "Old Slavic", func = function(t) return rareUnicodeBypass(t, "glagolitic") end},
	{name = "ARMENIAN", desc = "Armenian script", func = function(t) return rareUnicodeBypass(t, "armenian") end},
	{name = "ETHIOPIC", desc = "Ge'ez script", func = function(t) return rareUnicodeBypass(t, "ethiopic") end},
	{name = "TIFINAGH", desc = "Berber script", func = function(t) return rareUnicodeBypass(t, "tifinagh") end},
	{name = "SUPERSCRIPT", desc = "Small raised", func = function(t) return rareUnicodeBypass(t, "super") end},
	{name = "SUBSCRIPT", desc = "Small lowered", func = function(t) return rareUnicodeBypass(t, "sub") end},
	{name = "SMALL CAPS", desc = "Tiny capitals", func = function(t) return rareUnicodeBypass(t, "smallcaps") end},
	{name = "FULL-WIDTH", desc = "Asian style", func = function(t) return rareUnicodeBypass(t, "fullwidth") end},
	{name = "REGIONAL", desc = "Flag letters", func = function(t) return rareUnicodeBypass(t, "regional") end},
	{name = "SQUARE", desc = "Boxed letters", func = function(t) return enclosedBypass(t, "square") end},
	{name = "CIRCLE", desc = "Circled letters", func = function(t) return enclosedBypass(t, "circle") end},
	{name = "PAREN", desc = "(Letter)", func = function(t) return enclosedBypass(t, "paren") end},
	{name = "FORMAT INJECT", desc = "Invisible chars", func = function(t) return formatInjection(t, 50) end},
	{name = "ZALGO", desc = "Stacked marks", func = function(t) return zalgoStack(t, 4) end},
	{name = "CRAZY MIX", desc = "Random scripts", func = crazyMixedBypass},
	{name = "NUCLEAR", desc = "Multi-layer", func = nuclearBypass},
	{name = "ABSOLUTE", desc = "Maximum chaos", func = absoluteDestruction}
}

local selectedMethod = 21 -- Nuclear by default
local methodButtons = {}

for i, method in ipairs(methods) do
	local btn = Instance.new("TextButton")
	btn.BackgroundColor3 = i == selectedMethod and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(30, 30, 45)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = method.name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 9
	btn.Parent = methodsContainer
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		selectedMethod = i
		for j, b in ipairs(methodButtons) do
			b.BackgroundColor3 = j == i and Color3.fromRGB(150, 0, 255) or Color3.fromRGB(30, 30, 45)
		end
		generatePreview()
	end)
	
	methodButtons[i] = btn
end

methodsContainer.CanvasSize = UDim2.new(0, 0, 0, math.ceil(#methods / 2) * 38)

-- Preview
local previewLabel = Instance.new("TextLabel")
previewLabel.Size = UDim2.new(1, 0, 0, 20)
previewLabel.Position = UDim2.new(0, 0, 0, 268)
previewLabel.BackgroundTransparency = 1
previewLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
previewLabel.Text = "PREVIEW (What gets sent)"
previewLabel.Font = Enum.Font.GothamBold
previewLabel.TextSize = 11
previewLabel.TextXAlignment = Enum.TextXAlignment.Left
previewLabel.Parent = content

local previewBox = Instance.new("TextBox")
previewBox.Size = UDim2.new(1, 0, 0, 80)
previewBox.Position = UDim2.new(0, 0, 0, 290)
previewBox.BackgroundColor3 = Color3.fromRGB(10, 30, 20)
previewBox.TextColor3 = Color3.fromRGB(0, 255, 150)
previewBox.Text = ""
previewBox.Font = Enum.Font.Code
previewBox.TextSize = 12
previewBox.TextXAlignment = Enum.TextXAlignment.Left
previewBox.TextYAlignment = Enum.TextYAlignment.Top
previewBox.ClearTextOnFocus = false
previewBox.MultiLine = true
previewBox.TextWrapped = true
previewBox.Parent = content

local previewCorner = Instance.new("UICorner")
previewCorner.CornerRadius = UDim.new(0, 8)
previewCorner.Parent = previewBox

local previewStroke = Instance.new("UIStroke")
previewStroke.Color = Color3.fromRGB(0, 100, 50)
previewStroke.Thickness = 1
previewStroke.Parent = previewBox

-- Info label
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 40)
infoLabel.Position = UDim2.new(0, 0, 0, 378)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
infoLabel.Text = "Using rare Unicode scripts: Mathematical Alphanumeric, Coptic, Glagolitic, Ethiopic, Tifinagh, Armenian, Format Characters, Variation Selectors, and Combining Diacritical Marks."
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 9
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = content

-- Send Button
local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(1, 0, 0, 45)
sendBtn.Position = UDim2.new(0, 0, 1, -50)
sendBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendBtn.Text = "☠ SEND BYPASSED MESSAGE"
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 16
sendBtn.Parent = content

local sendBtnCorner = Instance.new("UICorner")
sendBtnCorner.CornerRadius = UDim.new(0, 10)
sendBtnCorner.Parent = sendBtn

local sendBtnGradient = Instance.new("UIGradient")
sendBtnGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 150))
})
sendBtnGradient.Parent = sendBtn

-- ========== FUNCTIONS ==========
local function generatePreview()
	local text = inputBox.Text
	if text == "" then
		previewBox.Text = ""
		return
	end
	
	local result = methods[selectedMethod].func(text)
	previewBox.Text = result
end

inputBox:GetPropertyChangedSignal("Text"):Connect(generatePreview)

local function sendMessage(msg)
	local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
	
	if chatRemote then
		local sayMessage = chatRemote:FindFirstChild("SayMessageRequest")
		if sayMessage then
			sayMessage:FireServer(msg, "All")
			return true
		end
	end
	
	local TextChatService = game:GetService("TextChatService")
	if TextChatService then
		local channel = TextChatService:FindFirstChild("TextChannels")
		if channel then
			local rbxGeneral = channel:FindFirstChild("RBXGeneral")
			if rbxGeneral then
				rbxGeneral:SendAsync(msg)
				return true
			end
		end
	end
	
	return false
end

sendBtn.MouseButton1Click:Connect(function()
	local text = inputBox.Text
	if text == "" then return end
	
	local result = methods[selectedMethod].func(text)
	sendMessage(result)
end)

-- ========== DRAGGING ==========
local dragging = false
local dragInput, dragStart, startPos

hubButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = hubButton.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

hubButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		hubButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local mainDragging = false
local mainDragInput, mainDragStart, mainDragPos

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		mainDragging = true
		mainDragStart = input.Position
		mainDragPos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				mainDragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		mainDragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == mainDragInput and mainDragging then
		local delta = input.Position - mainDragStart
		mainFrame.Position = UDim2.new(mainDragPos.X.Scale, mainDragPos.X.Offset + delta.X, mainDragPos.Y.Scale, mainDragPos.Y.Offset + delta.Y)
	end
end)

-- ========== TOGGLE ==========
hubButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if not dragging then
			hubButton.Visible = false
			mainFrame.Visible = true
		end
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	hubButton.Visible = true
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.RightControl then
		if mainFrame.Visible then
			mainFrame.Visible = false
			hubButton.Visible = true
		else
			hubButton.Visible = not hubButton.Visible
		end
	end
end)

print("☠ Nuclear Bypass v2.0 Loaded - 22 Rare Unicode Methods")
