-- CHAT BYPASS - Hardcoded, automatic, no options
-- Uses custom input, not Roblox chat

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========== HARDCODED BYPASS ==========

-- Zero-width characters
local zw = {
	"\u{200B}", "\u{200C}", "\u{200D}", "\u{2060}",
	"\u{2061}", "\u{2062}", "\u{2063}", "\u{FEFF}",
	"\u{200E}", "\u{200F}", "\u{202A}", "\u{202B}"
}

-- Combining marks
local combining = {
	"\u{0300}", "\u{0301}", "\u{0302}", "\u{0303}",
	"\u{0304}", "\u{0305}", "\u{0306}", "\u{0307}",
	"\u{0308}", "\u{0309}", "\u{030A}", "\u{030B}",
	"\u{030C}", "\u{030D}", "\u{030E}", "\u{030F}",
	"\u{0310}", "\u{0311}", "\u{0312}", "\u{0313}",
	"\u{0327}", "\u{0328}", "\u{0329}", "\u{032A}",
	"\u{0333}", "\u{0334}", "\u{0335}", "\u{0336}"
}

local function autoBypass(text)
	local result = ""
	
	for i = 1, #text do
		local char = string.sub(text, i, i)
		
		if char == " " then
			-- Spaces stay clean
			result = result .. " "
		else
			-- Add character
			result = result .. char
			
			-- Add 2-4 random combining marks
			local numMarks = math.random(2, 4)
			for _ = 1, numMarks do
				result = result .. combining[math.random(1, #combining)]
			end
			
			-- Add zero-width (always)
			result = result .. zw[math.random(1, #zw)]
		end
	end
	
	return result
end

-- ========== SEND MESSAGE ==========

local function sendMessage(msg)
	-- Try TextChatService first
	local success = false
	
	pcall(function()
		local textChannels = TextChatService:FindFirstChild("TextChannels")
		if textChannels then
			local rbxGeneral = textChannels:FindFirstChild("RBXGeneral")
			if rbxGeneral then
				rbxGeneral:SendAsync(msg)
				success = true
			end
		end
	end)
	
	-- Try legacy chat
	if not success then
		pcall(function()
			local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
			if chatEvents then
				local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
				if sayMessage then
					sayMessage:FireServer(msg, "All")
					success = true
				end
			end
		end)
	end
	
	return success
end

-- ========== GUI ==========

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BypassChat"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 50)
frame.Position = UDim2.new(0.5, -175, 1, -80)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(255, 60, 60)
frameStroke.Thickness = 1
frameStroke.Parent = frame

-- Input Box
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -70, 1, -10)
inputBox.Position = UDim2.new(0, 5, 0, 5)
inputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.Text = ""
inputBox.PlaceholderText = "Type message..."
inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 14
inputBox.ClearTextOnFocus = false
inputBox.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputBox

-- Send Button
local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0, 55, 1, -10)
sendBtn.Position = UDim2.new(1, -60, 0, 5)
sendBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendBtn.Text = "SEND"
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 12
sendBtn.Parent = frame

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 8)
sendCorner.Parent = sendBtn

-- Draggable
local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Toggle with Right Control
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.RightControl then
		frame.Visible = not frame.Visible
	end
end)

-- Send on button click
sendBtn.MouseButton1Click:Connect(function()
	local text = inputBox.Text
	if text ~= "" then
		local bypassed = autoBypass(text)
		sendMessage(bypassed)
		inputBox.Text = ""
	end
end)

-- Send on Enter
inputBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local text = inputBox.Text
		if text ~= "" then
			local bypassed = autoBypass(text)
			sendMessage(bypassed)
			inputBox.Text = ""
		end
	end
end)

print("[BYPASS] Loaded - Just type and send, automatically bypasses everything")
