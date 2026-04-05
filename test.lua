-- FILTER BREAKER v1.0
-- Attempts multiple normalization-breaking methods

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer

-- ========== ATTACK VECTORS ==========

-- 1. Bidirectional exploits
local bidiChars = {
	ltrOverride = "\u{202D}",
	rtlOverride = "\u{202E}",
	ltrEmbed = "\u{202A}",
	rtlEmbed = "\u{202B}",
	popDir = "\u{202C}",
	ltrIsolate = "\u{2066}",
	rtlIsolate = "\u{2067}",
	firstStrongIsolate = "\u{2068}",
	popIsolate = "\u{2069}"
}

-- 2. Control characters (might break parsing)
local controlChars = {
	"\u{0000}", -- null (might get stripped)
	"\u{0001}", "\u{0002}", "\u{0003}", "\u{0004}", "\u{0005}",
	"\u{0006}", "\u{0007}", "\u{0008}",
	"\u{000B}", -- vertical tab
	"\u{000C}", -- form feed
	"\u{000E}", "\u{000F}",
	"\u{0010}", "\u{0011}", "\u{0012}", "\u{0013}", "\u{0014}",
	"\u{0015}", "\u{0016}", "\u{0017}", "\u{0018}", "\u{0019}",
	"\u{001A}", "\u{001B}", "\u{001C}", "\u{001D}", "\u{001E}", "\u{001F}"
}

-- 3. Combining marks (stack thousands)
local combiningMarks = {}
for i = 0x0300, 0x036F do
	table.insert(combiningMarks, utf8.char(i))
end
for i = 0x0483, 0x0489 do
	table.insert(combiningMarks, utf8.char(i))
end
for i = 0x1AB0, 0x1AFF do
	table.insert(combiningMarks, utf8.char(i))
end
for i = 0x1DC0, 0x1DFF do
	table.insert(combiningMarks, utf8.char(i))
end
for i = 0x20D0, 0x20FF do
	table.insert(combiningMarks, utf8.char(i))
end
for i = 0xFE20, 0xFE2F do
	table.insert(combiningMarks, utf8.char(i))
end

-- 4. Variation selectors
local variationSelectors = {}
for i = 0xFE00, 0xFE0F do
	table.insert(variationSelectors, utf8.char(i))
end
for i = 0xE0100, 0xE01EF do
	table.insert(variationSelectors, utf8.char(i))
end

-- 5. Tags (invisible)
local tags = {}
for i = 0xE0000, 0xE007F do
	table.insert(tags, utf8.char(i))
end

-- 6. Zero-width and format chars
local zeroWidth = {
	"\u{200B}", "\u{200C}", "\u{200D}", "\u{2060}",
	"\u{2061}", "\u{2062}", "\u{2063}", "\u{2064}",
	"\u{FEFF}", "\u{2065}", "\u{2066}", "\u{2067}", "\u{2068}", "\u{2069}"
}

-- ========== BYPASS METHODS ==========

-- Method 1: RTL Override (text displays reversed)
local function rtlBypass(text)
	-- Use RTL override to reverse display order
	return bidiChars.rtlOverride .. text .. bidiChars.popDir
end

-- Method 2: LTR Override with hidden chars
local function ltrBypass(text)
	local result = ""
	for i = 1, #text do
		result = result .. string.sub(text, i, i)
		-- Insert random format characters
		if math.random(1, 3) == 1 then
			result = result .. zeroWidth[math.random(1, #zeroWidth)]
		end
	end
	return bidiChars.ltrOverride .. result .. bidiChars.popDir
end

-- Method 3: Combining mark overflow (thousands of marks)
local function combiningOverflow(text)
	local result = ""
	for i = 1, #text do
		result = result .. string.sub(text, i, i)
		-- Add 50-200 combining marks per character
		local numMarks = math.random(50, 200)
		for _ = 1, numMarks do
			result = result .. combiningMarks[math.random(1, #combiningMarks)]
		end
	end
	return result
end

-- Method 4: Tag character injection
local function tagInjection(text)
	local result = ""
	for i = 1, #text do
		local char = string.sub(text, i, i)
		result = result .. char
		-- Add invisible tags
		if math.random(1, 2) == 1 then
			result = result .. tags[math.random(1, #tags)]
		end
		-- Add variation selectors
		if math.random(1, 3) == 1 then
			result = result .. variationSelectors[math.random(1, #variationSelectors)]
		end
	end
	return result
end

-- Method 5: Control character injection
local function controlInjection(text)
	local result = ""
	for i = 1, #text do
		result = result .. string.sub(text, i, i)
		-- Inject control characters
		if math.random(1, 4) == 1 then
			result = result .. controlChars[math.random(1, #controlChars)]
		end
	end
	return result
end

-- Method 6: Mixed attack (all vectors combined)
local function nuclearAttack(text)
	local result = bidiChars.rtlOverride
	
	for i = 1, #text do
		local char = string.sub(text, i, i)
		result = result .. char
		
		-- Format characters
		result = result .. zeroWidth[math.random(1, #zeroWidth)]
		
		-- Combining marks (heavy)
		for _ = 1, math.random(20, 80) do
			result = result .. combiningMarks[math.random(1, #combiningMarks)]
		end
		
		-- Variation selectors
		if math.random(1, 2) == 1 then
			result = result .. variationSelectors[math.random(1, #variationSelectors)]
		end
		
		-- Tags
		if math.random(1, 3) == 1 then
			result = result .. tags[math.random(1, #tags)]
		end
		
		-- Control chars
		if math.random(1, 5) == 1 then
			result = result .. controlChars[math.random(1, #controlChars)]
		end
	end
	
	return result .. bidiChars.popDir
end

-- Method 7: Word boundary attack (inject format chars at word boundaries)
local function boundaryAttack(text)
	local result = ""
	local words = text:split(" ")
	
	for i, word in ipairs(words) do
		-- Heavy injection at word start
		result = result .. zeroWidth[math.random(1, #zeroWidth)]
		result = result .. bidiChars.ltrIsolate
		
		-- Add combining marks before word
		for _ = 1, math.random(10, 30) do
			result = result .. combiningMarks[math.random(1, #combiningMarks)]
		end
		
		result = result .. word
		
		-- Heavy injection after word
		for _ = 1, math.random(10, 30) do
			result = result .. combiningMarks[math.random(1, #combiningMarks)]
		end
		
		result = result .. bidiChars.popIsolate
		
		if i < #words then
			result = result .. " "
		end
	end
	
	return result
end

-- Method 8: Overlong encoding attempt (2-byte for 1-byte chars)
local function overlongAttack(text)
	local result = ""
	for i = 1, #text do
		local char = string.sub(text, i, i)
		local byte = string.byte(char)
		
		if byte < 128 then
			-- Try overlong representation (might get rejected or might work)
			result = result .. string.char(0xC0 + math.floor(byte / 64), 0x80 + byte % 64)
		else
			result = result .. char
		end
	end
	return result
end

-- Method 9: Fragmentation attack (split across directional changes)
local function fragmentAttack(text)
	local result = ""
	local len = #text
	
	for i = 1, len do
		local char = string.sub(text, i, i)
		
		-- Alternate direction frequently
		if math.random(1, 2) == 1 then
			result = result .. bidiChars.ltrOverride .. char .. bidiChars.popDir
		else
			result = result .. bidiChars.rtlOverride .. char .. bidiChars.popDir
		end
		
		-- Add invisible chars between each
		result = result .. zeroWidth[math.random(1, #zeroWidth)]
	end
	
	return result
end

-- Method 10: Layered attack (multiple methods stacked)
local function layeredAttack(text)
	-- Apply multiple transformations
	local result = text
	
	-- Layer 1: Tag injection
	result = tagInjection(result)
	
	-- Layer 2: Control chars
	result = controlInjection(result)
	
	-- Layer 3: Combining marks
	for i = 1, #result do
		if math.random(1, 3) == 1 then
			result = result:sub(1, i) .. combiningMarks[math.random(1, #combiningMarks)] .. result:sub(i + 1)
		end
	end
	
	-- Layer 4: Bidirectional
	result = bidiChars.rtlOverride .. result .. bidiChars.popDir
	
	return result
end

-- ========== GUI ==========
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FilterBreaker"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Hub
local hub = Instance.new("Frame")
hub.Size = UDim2.new(0, 55, 0, 55)
hub.Position = UDim2.new(0, 15, 0.5, -27)
hub.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
hub.BorderSizePixel = 0
hub.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 12)
hubCorner.Parent = hub

local hubStroke = Instance.new("UIStroke")
hubStroke.Color = Color3.fromRGB(255, 0, 80)
hubStroke.Thickness = 2
hubStroke.Parent = hub

local hubGradient = Instance.new("UIGradient")
hubGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 80)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 0))
})
hubGradient.Parent = hub

local hubLabel = Instance.new("TextLabel")
hubLabel.Size = UDim2.new(1, 0, 1, 0)
hubLabel.BackgroundTransparency = 1
hubLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hubLabel.Text = "☠"
hubLabel.Font = Enum.Font.GothamBold
hubLabel.TextSize = 28
hubLabel.Parent = hub

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 520)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 0, 80)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 0, 80)
title.Text = "☠ FILTER BREAKER v1.0"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -50)
content.Position = UDim2.new(0, 10, 0, 45)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Input
local inputLabel = Instance.new("TextLabel")
inputLabel.Size = UDim2.new(1, 0, 0, 20)
inputLabel.BackgroundTransparency = 1
inputLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
inputLabel.Text = "MESSAGE TO BYPASS"
inputLabel.Font = Enum.Font.GothamBold
inputLabel.TextSize = 11
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.Parent = content

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, 0, 0, 60)
inputBox.Position = UDim2.new(0, 0, 0, 22)
inputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.Text = ""
inputBox.PlaceholderText = "Type message..."
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
inputStroke.Color = Color3.fromRGB(60, 60, 80)
inputStroke.Thickness = 1
inputStroke.Parent = inputBox

-- Method selection
local methodLabel = Instance.new("TextLabel")
methodLabel.Size = UDim2.new(1, 0, 0, 20)
methodLabel.Position = UDim2.new(0, 0, 0, 90)
methodLabel.BackgroundTransparency = 1
methodLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
methodLabel.Text = "ATTACK METHOD"
methodLabel.Font = Enum.Font.GothamBold
methodLabel.TextSize = 11
methodLabel.TextXAlignment = Enum.TextXAlignment.Left
methodLabel.Parent = content

local methods = {
	{name = "RTL", func = rtlBypass, desc = "Right-to-left override"},
	{name = "LTR", func = ltrBypass, desc = "Left-to-right with hidden"},
	{name = "OVERFLOW", func = combiningOverflow, desc = "Thousands of marks"},
	{name = "TAGS", func = tagInjection, desc = "Invisible tags"},
	{name = "CONTROL", func = controlInjection, desc = "Control characters"},
	{name = "NUCLEAR", func = nuclearAttack, desc = "All vectors combined"},
	{name = "BOUNDARY", func = boundaryAttack, desc = "Word boundary injection"},
	{name = "OVERLONG", func = overlongAttack, desc = "Overlong encoding"},
	{name = "FRAGMENT", func = fragmentAttack, desc = "Direction fragments"},
	{name = "LAYERED", func = layeredAttack, desc = "Multiple layers"}
}

local methodButtons = Instance.new("Frame")
methodButtons.Size = UDim2.new(1, 0, 0, 95)
methodButtons.Position = UDim2.new(0, 0, 0, 112)
methodButtons.BackgroundTransparency = 1
methodButtons.Parent = content

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0.48, 0, 0, 28)
grid.CellPadding = UDim2.new(0, 6, 0, 4)
grid.Parent = methodButtons

local selectedMethod = 1
local buttons = {}

for i, method in ipairs(methods) do
	local btn = Instance.new("TextButton")
	btn.BackgroundColor3 = i == 1 and Color3.fromRGB(255, 0, 80) or Color3.fromRGB(30, 30, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = method.name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 10
	btn.Parent = methodButtons
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		selectedMethod = i
		for j, b in ipairs(buttons) do
			b.BackgroundColor3 = j == i and Color3.fromRGB(255, 0, 80) or Color3.fromRGB(30, 30, 40)
		end
	end)
	
	buttons[i] = btn
end

-- Preview
local previewLabel = Instance.new("TextLabel")
previewLabel.Size = UDim2.new(1, 0, 0, 20)
previewLabel.Position = UDim2.new(0, 0, 0, 215)
previewLabel.BackgroundTransparency = 1
previewLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
previewLabel.Text = "PREVIEW"
previewLabel.Font = Enum.Font.GothamBold
previewLabel.TextSize = 11
previewLabel.TextXAlignment = Enum.TextXAlignment.Left
previewLabel.Parent = content

local previewBox = Instance.new("TextBox")
previewBox.Size = UDim2.new(1, 0, 0, 70)
previewBox.Position = UDim2.new(0, 0, 0, 237)
previewBox.BackgroundColor3 = Color3.fromRGB(10, 25, 15)
previewBox.TextColor3 = Color3.fromRGB(0, 255, 150)
previewBox.Text = ""
previewBox.Font = Enum.Font.Code
previewBox.TextSize = 11
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
previewStroke.Color = Color3.fromRGB(0, 80, 40)
previewStroke.Thickness = 1
previewStroke.Parent = previewBox

-- Warning
local warning = Instance.new("TextLabel")
warning.Size = UDim2.new(1, 0, 0, 30)
warning.Position = UDim2.new(0, 0, 0, 315)
warning.BackgroundTransparency = 1
warning.TextColor3 = Color3.fromRGB(255, 200, 0)
warning.Text = "⚠ These methods exploit text rendering. May cause display issues. Some characters might not render for other players."
warning.Font = Enum.Font.Gotham
warning.TextSize = 9
warning.TextWrapped = true
warning.TextXAlignment = Enum.TextXAlignment.Left
warning.TextYAlignment = Enum.TextYAlignment.Top
warning.Parent = content

-- Send button
local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(1, 0, 0, 40)
sendBtn.Position = UDim2.new(0, 0, 1, -45)
sendBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 80)
sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendBtn.Text = "☠ SEND BYPASSED MESSAGE"
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 14
sendBtn.Parent = content

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 10)
sendCorner.Parent = sendBtn

-- ========== PREVIEW UPDATE ==========
local function updatePreview()
	local text = inputBox.Text
	if text == "" then
		previewBox.Text = ""
		return
	end
	
	previewBox.Text = methods[selectedMethod].func(text)
end

inputBox:GetPropertyChangedSignal("Text"):Connect(updatePreview)

for i, btn in ipairs(buttons) do
	btn.MouseButton1Click:Connect(updatePreview)
end

-- ========== SEND ==========
local function sendMessage(msg)
	-- Try TextChatService first
	local textChannel = TextChatService:FindFirstChild("TextChannels")
	if textChannel then
		local rbxGeneral = textChannel:FindFirstChild("RBXGeneral")
		if rbxGeneral then
			local success, err = pcall(function()
				rbxGeneral:SendAsync(msg)
			end)
			if success then return true end
		end
	end
	
	-- Try Legacy Chat
	local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
	if chatEvents then
		local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
		if sayMessage then
			local success, err = pcall(function()
				sayMessage:FireServer(msg, "All")
			end)
			if success then return true end
		end
	end
	
	return false
end

sendBtn.MouseButton1Click:Connect(function()
	local text = inputBox.Text
	if text == "" then return end
	
	local bypassedText = methods[selectedMethod].func(text)
	sendMessage(bypassedText)
end)

-- ========== TOGGLE ==========
local dragging = false
local dragStart, startPos

hub.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = hub.Position
	end
end)

hub.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if not dragging then
			hub.Visible = false
			mainFrame.Visible = true
		end
		dragging = false
	end
end)

hub.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		hub.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	hub.Visible = true
end)

local mainDragging = false
local mainDragStart, mainStartPos

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		mainDragging = true
		mainDragStart = input.Position
		mainStartPos = mainFrame.Position
	end
end)

mainFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		mainDragging = false
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if mainDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - mainDragStart
		mainFrame.Position = UDim2.new(mainStartPos.X.Scale, mainStartPos.X.Offset + delta.X, mainStartPos.Y.Scale, mainStartPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.RightControl then
		if mainFrame.Visible then
			mainFrame.Visible = false
			hub.Visible = true
		else
			hub.Visible = not hub.Visible
		end
	end
end)

print("☠ Filter Breaker v1.0 Loaded")
print("⚠ Using text rendering exploits to bypass normalization")
