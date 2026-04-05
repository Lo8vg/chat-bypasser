-- Chat Trigger Pro (With Bypass System)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local enabled = false
local spamming = false
local savedMessages = {}
local bypassMode = "none" -- none, spaces, zero, mixed, smart

-- Bypass characters
local zeroWidth = "​" -- invisible character
local specialChars = {".", ",", "-", "'", '"'}

-- ========== BYPASS FUNCTIONS ==========
local function spaceBypass(text)
	local result = ""
	for i = 1, #text do
		result = result .. text:sub(i, i) .. " "
	end
	return result:sub(1, #result - 1)
end

local function zeroWidthBypass(text)
	local result = ""
	for i = 1, #text do
		result = result .. text:sub(i, i) .. zeroWidth
	end
	return result
end

local function mixedBypass(text)
	local result = ""
	for i = 1, #text do
		local char = text:sub(i, i)
		local shouldBypass = math.random(1, 3)
		if shouldBypass == 1 then
			result = result .. char .. zeroWidth
		elseif shouldBypass == 2 then
			result = result .. string.upper(char)
		else
			result = result .. char
		end
	end
	return result
end

local function smartBypass(text)
	-- Flagged words that commonly get tagged
	local flaggedWords = {"loser", "idiot", "stupid", "dumb", "noob", "nub", "trash", 
		"female", "girl", "woman", "head", "kill", "die", "hate", "ugly", "fat",
		"cry", "mad", "rage", "bad", "worst", "terrible", "awful", "wtf", "omg",
		"female", "loser", "head", "off", "haha", "lol", "ez", "easy"}
	
	local lowerText = string.lower(text)
	local result = text
	
	for _, word in ipairs(flaggedWords) do
		local startPos, endPos = string.find(lowerText, word)
		while startPos do
			local originalWord = string.sub(text, startPos, endPos)
			local bypassed = ""
			for i = 1, #originalWord do
				bypassed = bypassed .. string.sub(originalWord, i, i) .. zeroWidth
			end
			result = string.gsub(result, originalWord, bypassed, 1)
			startPos, endPos = string.find(lowerText, word, endPos + 1)
		end
	end
	
	return result
end

local function applyBypass(text)
	if bypassMode == "spaces" then
		return spaceBypass(text)
	elseif bypassMode == "zero" then
		return zeroWidthBypass(text)
	elseif bypassMode == "mixed" then
		return mixedBypass(text)
	elseif bypassMode == "smart" then
		return smartBypass(text)
	else
		return text
	end
end

-- ========== CREATE GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatTriggerPro"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Hub Button
local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 50, 0, 50)
hubButton.Position = UDim2.new(0, 20, 0.5, -25)
hubButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
hubButton.BorderSizePixel = 0
hubButton.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 10)
hubCorner.Parent = hubButton

local hubStroke = Instance.new("UIStroke")
hubStroke.Color = Color3.fromRGB(60, 60, 70)
hubStroke.Thickness = 1
hubStroke.Parent = hubButton

local hubIcon = Instance.new("TextLabel")
hubIcon.Size = UDim2.new(1, 0, 1, 0)
hubIcon.BackgroundTransparency = 1
hubIcon.TextColor3 = Color3.fromRGB(255, 100, 100)
hubIcon.Text = "⚡"
hubIcon.Font = Enum.Font.GothamBold
hubIcon.TextSize = 24
hubIcon.Parent = hubButton

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0, 20, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(40, 40, 50)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 12)
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -45, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
titleLabel.Text = "Chat Trigger Pro"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 22)
closeBtn.Position = UDim2.new(1, -34, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 38)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Trigger Section
local triggerSection = Instance.new("Frame")
triggerSection.Size = UDim2.new(1, -20, 0, 50)
triggerSection.Position = UDim2.new(0, 10, 0, 5)
triggerSection.BackgroundTransparency = 1
triggerSection.Parent = contentFrame

local triggerLabel = Instance.new("TextLabel")
triggerLabel.Size = UDim2.new(1, 0, 0, 16)
triggerLabel.BackgroundTransparency = 1
triggerLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
triggerLabel.Text = "TRIGGER COMMAND"
triggerLabel.Font = Enum.Font.Gotham
triggerLabel.TextSize = 9
triggerLabel.TextXAlignment = Enum.TextXAlignment.Left
triggerLabel.Parent = triggerSection

local triggerBox = Instance.new("TextBox")
triggerBox.Size = UDim2.new(1, 0, 0, 28)
triggerBox.Position = UDim2.new(0, 0, 0, 18)
triggerBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
triggerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
triggerBox.Text = "-die"
triggerBox.PlaceholderText = "-die"
triggerBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
triggerBox.Font = Enum.Font.Gotham
triggerBox.TextSize = 12
triggerBox.ClearTextOnFocus = false
triggerBox.Parent = triggerSection

local triggerCorner = Instance.new("UICorner")
triggerCorner.CornerRadius = UDim.new(0, 6)
triggerCorner.Parent = triggerBox

local triggerStroke = Instance.new("UIStroke")
triggerStroke.Color = Color3.fromRGB(50, 50, 60)
triggerStroke.Thickness = 1
triggerStroke.Parent = triggerBox

-- ========== BYPASS SECTION ==========
local bypassSection = Instance.new("Frame")
bypassSection.Size = UDim2.new(1, -20, 0, 75)
bypassSection.Position = UDim2.new(0, 10, 0, 58)
bypassSection.BackgroundTransparency = 1
bypassSection.Parent = contentFrame

local bypassLabel = Instance.new("TextLabel")
bypassLabel.Size = UDim2.new(1, 0, 0, 16)
bypassLabel.BackgroundTransparency = 1
bypassLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
bypassLabel.Text = "BYPASS MODE"
bypassLabel.Font = Enum.Font.GothamBold
bypassLabel.TextSize = 9
bypassLabel.TextXAlignment = Enum.TextXAlignment.Left
bypassLabel.Parent = bypassSection

-- Bypass Buttons Row 1
local bypassRow1 = Instance.new("Frame")
bypassRow1.Size = UDim2.new(1, 0, 0, 24)
bypassRow1.Position = UDim2.new(0, 0, 0, 18)
bypassRow1.BackgroundTransparency = 1
bypassRow1.Parent = bypassSection

local noneBtn = Instance.new("TextButton")
noneBtn.Size = UDim2.new(0.48, 0, 1, 0)
noneBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
noneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noneBtn.Text = "NONE"
noneBtn.Font = Enum.Font.GothamBold
noneBtn.TextSize = 10
noneBtn.Parent = bypassRow1

local noneCorner = Instance.new("UICorner")
noneCorner.CornerRadius = UDim.new(0, 5)
noneCorner.Parent = noneBtn

local spaceBtn = Instance.new("TextButton")
spaceBtn.Size = UDim2.new(0.48, 0, 1, 0)
spaceBtn.Position = UDim2.new(0.52, 0, 0, 0)
spaceBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
spaceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spaceBtn.Text = "SPACES"
spaceBtn.Font = Enum.Font.GothamBold
spaceBtn.TextSize = 10
spaceBtn.Parent = bypassRow1

local spaceCorner = Instance.new("UICorner")
spaceCorner.CornerRadius = UDim.new(0, 5)
spaceCorner.Parent = spaceBtn

-- Bypass Buttons Row 2
local bypassRow2 = Instance.new("Frame")
bypassRow2.Size = UDim2.new(1, 0, 0, 24)
bypassRow2.Position = UDim2.new(0, 0, 0, 46)
bypassRow2.BackgroundTransparency = 1
bypassRow2.Parent = bypassSection

local zeroBtn = Instance.new("TextButton")
zeroBtn.Size = UDim2.new(0.31, 0, 1, 0)
zeroBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
zeroBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
zeroBtn.Text = "INVISIBLE"
zeroBtn.Font = Enum.Font.GothamBold
zeroBtn.TextSize = 9
zeroBtn.Parent = bypassRow2

local zeroCorner = Instance.new("UICorner")
zeroCorner.CornerRadius = UDim.new(0, 5)
zeroCorner.Parent = zeroBtn

local mixedBtn = Instance.new("TextButton")
mixedBtn.Size = UDim2.new(0.31, 0, 1, 0)
mixedBtn.Position = UDim2.new(0.34, 0, 0, 0)
mixedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
mixedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mixedBtn.Text = "MIXED"
mixedBtn.Font = Enum.Font.GothamBold
mixedBtn.TextSize = 9
mixedBtn.Parent = bypassRow2

local mixedCorner = Instance.new("UICorner")
mixedCorner.CornerRadius = UDim.new(0, 5)
mixedCorner.Parent = mixedBtn

local smartBtn = Instance.new("TextButton")
smartBtn.Size = UDim2.new(0.31, 0, 1, 0)
smartBtn.Position = UDim2.new(0.68, 0, 0, 0)
smartBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
smartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
smartBtn.Text = "SMART"
smartBtn.Font = Enum.Font.GothamBold
smartBtn.TextSize = 9
smartBtn.Parent = bypassRow2

local smartCorner = Instance.new("UICorner")
smartCorner.CornerRadius = UDim.new(0, 5)
smartCorner.Parent = smartBtn

-- Bypass status
local bypassStatus = Instance.new("TextLabel")
bypassStatus.Size = UDim2.new(1, 0, 0, 14)
bypassStatus.Position = UDim2.new(0, 0, 0, 72)
bypassStatus.BackgroundTransparency = 1
bypassStatus.TextColor3 = Color3.fromRGB(100, 200, 255)
bypassStatus.Text = "Current: None (No bypass)"
bypassStatus.Font = Enum.Font.Gotham
bypassStatus.TextSize = 8
bypassStatus.TextXAlignment = Enum.TextXAlignment.Left
bypassStatus.Parent = bypassSection

-- ========== UPDATE BYPASS BUTTONS ==========
local function updateBypassButtons()
	noneBtn.BackgroundColor3 = bypassMode == "none" and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(50, 50, 60)
	spaceBtn.BackgroundColor3 = bypassMode == "spaces" and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(50, 50, 60)
	zeroBtn.BackgroundColor3 = bypassMode == "zero" and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(50, 50, 60)
	mixedBtn.BackgroundColor3 = bypassMode == "mixed" and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(50, 50, 60)
	smartBtn.BackgroundColor3 = bypassMode == "smart" and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(50, 50, 60)
	
	local statusText = {
		["none"] = "None (No bypass)",
		["spaces"] = "Spaces (Adds spaces)",
		["zero"] = "Invisible (Hidden chars)",
		["mixed"] = "Mixed (Random bypass)",
		["smart"] = "Smart (Flagged words only)"
	}
	bypassStatus.Text = "Current: "..(statusText[bypassMode] or "None")
end

noneBtn.MouseButton1Click:Connect(function()
	bypassMode = "none"
	updateBypassButtons()
end)

spaceBtn.MouseButton1Click:Connect(function()
	bypassMode = "spaces"
	updateBypassButtons()
end)

zeroBtn.MouseButton1Click:Connect(function()
	bypassMode = "zero"
	updateBypassButtons()
end)

mixedBtn.MouseButton1Click:Connect(function()
	bypassMode = "mixed"
	updateBypassButtons()
end)

smartBtn.MouseButton1Click:Connect(function()
	bypassMode = "smart"
	updateBypassButtons()
end)

-- Messages List Section
local listSection = Instance.new("Frame")
listSection.Size = UDim2.new(1, -20, 0, 115)
listSection.Position = UDim2.new(0, 10, 0, 138)
listSection.BackgroundTransparency = 1
listSection.Parent = contentFrame

local listLabel = Instance.new("TextLabel")
listLabel.Size = UDim2.new(1, 0, 0, 16)
listLabel.BackgroundTransparency = 1
listLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
listLabel.Text = "SAVED MESSAGES"
listLabel.Font = Enum.Font.Gotham
listLabel.TextSize = 9
listLabel.TextXAlignment = Enum.TextXAlignment.Left
listLabel.Parent = listSection

local listContainer = Instance.new("Frame")
listContainer.Size = UDim2.new(1, 0, 0, 90)
listContainer.Position = UDim2.new(0, 0, 0, 18)
listContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
listContainer.Parent = listSection

local listContainerCorner = Instance.new("UICorner")
listContainerCorner.CornerRadius = UDim.new(0, 6)
listContainerCorner.Parent = listContainer

local listContainerStroke = Instance.new("UIStroke")
listContainerStroke.Color = Color3.fromRGB(50, 50, 60)
listContainerStroke.Thickness = 1
listContainerStroke.Parent = listContainer

local scrollingList = Instance.new("ScrollingFrame")
scrollingList.Size = UDim2.new(1, -4, 1, -4)
scrollingList.Position = UDim2.new(0, 2, 0, 2)
scrollingList.BackgroundTransparency = 1
scrollingList.ScrollBarThickness = 4
scrollingList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
scrollingList.Parent = listContainer

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = scrollingList

-- Add Message Section
local addSection = Instance.new("Frame")
addSection.Size = UDim2.new(1, -20, 0, 50)
addSection.Position = UDim2.new(0, 10, 0, 258)
addSection.BackgroundTransparency = 1
addSection.Parent = contentFrame

local addLabel = Instance.new("TextLabel")
addLabel.Size = UDim2.new(1, 0, 0, 16)
addLabel.BackgroundTransparency = 1
addLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
addLabel.Text = "ADD NEW MESSAGE"
addLabel.Font = Enum.Font.Gotham
addLabel.TextSize = 9
addLabel.TextXAlignment = Enum.TextXAlignment.Left
addLabel.Parent = addSection

local addBox = Instance.new("TextBox")
addBox.Size = UDim2.new(1, -70, 0, 28)
addBox.Position = UDim2.new(0, 0, 0, 18)
addBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
addBox.TextColor3 = Color3.fromRGB(255, 255, 255)
addBox.Text = ""
addBox.PlaceholderText = "Type message here..."
addBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
addBox.Font = Enum.Font.Gotham
addBox.TextSize = 12
addBox.ClearTextOnFocus = false
addBox.Parent = addSection

local addBoxCorner = Instance.new("UICorner")
addBoxCorner.CornerRadius = UDim.new(0, 6)
addBoxCorner.Parent = addBox

local addBoxStroke = Instance.new("UIStroke")
addBoxStroke.Color = Color3.fromRGB(50, 50, 60)
addBoxStroke.Thickness = 1
addBoxStroke.Parent = addBox

local addBtn = Instance.new("TextButton")
addBtn.Size = UDim2.new(0, 60, 0, 28)
addBtn.Position = UDim2.new(1, -60, 0, 18)
addBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addBtn.Text = "Add"
addBtn.Font = Enum.Font.GothamBold
addBtn.TextSize = 11
addBtn.Parent = addSection

local addBtnCorner = Instance.new("UICorner")
addBtnCorner.CornerRadius = UDim.new(0, 6)
addBtnCorner.Parent = addBtn

-- Settings Row
local settingsRow = Instance.new("Frame")
settingsRow.Size = UDim2.new(1, -20, 0, 30)
settingsRow.Position = UDim2.new(0, 10, 0, 313)
settingsRow.BackgroundTransparency = 1
settingsRow.Parent = contentFrame

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 45, 1, 0)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
delayLabel.Text = "Delay:"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 11
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = settingsRow

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(0, 55, 0, 26)
delayBox.Position = UDim2.new(0, 48, 0, 2)
delayBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBox.Text = "0.5"
delayBox.PlaceholderText = "0.5"
delayBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
delayBox.Font = Enum.Font.Gotham
delayBox.TextSize = 11
delayBox.ClearTextOnFocus = false
delayBox.Parent = settingsRow

local delayBoxCorner = Instance.new("UICorner")
delayBoxCorner.CornerRadius = UDim.new(0, 5)
delayBoxCorner.Parent = delayBox

local delayBoxStroke = Instance.new("UIStroke")
delayBoxStroke.Color = Color3.fromRGB(50, 50, 60)
delayBoxStroke.Thickness = 1
delayBoxStroke.Parent = delayBox

local secLabel = Instance.new("TextLabel")
secLabel.Size = UDim2.new(0, 20, 1, 0)
secLabel.Position = UDim2.new(0, 108, 0, 0)
secLabel.BackgroundTransparency = 1
secLabel.TextColor3 = Color3.fromRGB(120, 120, 130)
secLabel.Text = "sec"
secLabel.Font = Enum.Font.Gotham
secLabel.TextSize = 10
secLabel.Parent = settingsRow

local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(0, 80, 1, 0)
countLabel.Position = UDim2.new(1, -80, 0, 0)
countLabel.BackgroundTransparency = 1
countLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
countLabel.Text = "0 messages"
countLabel.Font = Enum.Font.Gotham
countLabel.TextSize = 10
countLabel.TextXAlignment = Enum.TextXAlignment.Right
countLabel.Parent = settingsRow

-- Enable Button
local enableBtn = Instance.new("TextButton")
enableBtn.Size = UDim2.new(1, -20, 0, 34)
enableBtn.Position = UDim2.new(0, 10, 0, 348)
enableBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
enableBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
enableBtn.Text = "DISABLED - Click to Enable"
enableBtn.Font = Enum.Font.GothamBold
enableBtn.TextSize = 12
enableBtn.Parent = contentFrame

local enableBtnCorner = Instance.new("UICorner")
enableBtnCorner.CornerRadius = UDim.new(0, 6)
enableBtnCorner.Parent = enableBtn

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

-- Main frame dragging
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

-- ========== UPDATE MESSAGE LIST ==========
local function updateList()
	for _, child in pairs(scrollingList:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	
	countLabel.Text = #savedMessages.." messages"
	
	for i, msg in ipairs(savedMessages) do
		local msgFrame = Instance.new("Frame")
		msgFrame.Size = UDim2.new(1, 0, 0, 22)
		msgFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		msgFrame.Parent = scrollingList
		
		local msgCorner = Instance.new("UICorner")
		msgCorner.CornerRadius = UDim.new(0, 4)
		msgCorner.Parent = msgFrame
		
		local msgText = Instance.new("TextLabel")
		msgText.Size = UDim2.new(1, -30, 1, 0)
		msgText.Position = UDim2.new(0, 8, 0, 0)
		msgText.BackgroundTransparency = 1
		msgText.TextColor3 = Color3.fromRGB(220, 220, 230)
		msgText.Text = msg
		msgText.Font = Enum.Font.Gotham
		msgText.TextSize = 10
		msgText.TextXAlignment = Enum.TextXAlignment.Left
		msgText.TextTruncate = Enum.TextTruncate.AtEnd
		msgText.Parent = msgFrame
		
		local removeBtn = Instance.new("TextButton")
		removeBtn.Size = UDim2.new(0, 20, 0, 20)
		removeBtn.Position = UDim2.new(1, -24, 0.5, -10)
		removeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		removeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		removeBtn.Text = "×"
		removeBtn.Font = Enum.Font.GothamBold
		removeBtn.TextSize = 11
		removeBtn.Parent = msgFrame
		
		local removeCorner = Instance.new("UICorner")
		removeCorner.CornerRadius = UDim.new(0, 4)
		removeCorner.Parent = removeBtn
		
		removeBtn.MouseButton1Click:Connect(function()
			table.remove(savedMessages, i)
			updateList()
		end)
	end
	
	scrollingList.CanvasSize = UDim2.new(0, 0, 0, #savedMessages * 26)
end

-- ========== ADD MESSAGE ==========
addBtn.MouseButton1Click:Connect(function()
	local msg = addBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
	if msg ~= "" then
		table.insert(savedMessages, msg)
		addBox.Text = ""
		updateList()
	end
end)

addBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local msg = addBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
		if msg ~= "" then
			table.insert(savedMessages, msg)
			addBox.Text = ""
			updateList()
		end
	end
end)

-- ========== SEND MESSAGE FUNCTION ==========
local function sendMessage(msg)
	local message = applyBypass(msg)
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
	
	local TextChatService = game:GetService("TextChatService")
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

-- ========== ENABLE TOGGLE ==========
enableBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	
	if enabled then
		enableBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
		enableBtn.Text = "ENABLED - Listening..."
	else
		enableBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		enableBtn.Text = "DISABLED - Click to Enable"
	end
end)

-- ========== CHAT DETECTION ==========
local function onChatted(msg)
	if not enabled then return end
	if spamming then return end
	
	local trigger = triggerBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
	if trigger == "" then return end
	
	if msg == trigger then
		if #savedMessages == 0 then
			return
		end
		
		local delay = tonumber(delayBox.Text) or 0.5
		if delay < 0 then delay = 0 end
		
		spamming = true
		
		task.spawn(function()
			for i, line in ipairs(savedMessages) do
				sendMessage(line)
				if i < #savedMessages and delay > 0 then
					task.wait(delay)
				end
			end
			spamming = false
		end)
	end
end

player.Chatted:Connect(onChatted)

-- ========== TOGGLE WITH RIGHT CONTROL ==========
local guiVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.RightControl then
		if mainFrame.Visible then
			mainFrame.Visible = false
			hubButton.Visible = guiVisible
		else
			guiVisible = not guiVisible
			hubButton.Visible = guiVisible
		end
	end
end)

updateBypassButtons()
updateList()
print("✅ Chat Trigger Pro Loaded (With Bypass System)")
