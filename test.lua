-- Chat Command Trigger

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local MAX_CHARS = 200
local enabled = false
local spamming = false

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatTriggerHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========== HUB BUTTON ==========
local hubButton = Instance.new("Frame")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 50, 0, 50)
hubButton.Position = UDim2.new(0, 20, 0.5, -25)
hubButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
hubButton.BorderSizePixel = 2
hubButton.BorderColor3 = Color3.fromRGB(60, 60, 60)
hubButton.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 8)
hubCorner.Parent = hubButton

local hubIcon = Instance.new("TextLabel")
hubIcon.Size = UDim2.new(1, 0, 1, 0)
hubIcon.BackgroundTransparency = 1
hubIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
hubIcon.Text = "⚡"
hubIcon.Font = Enum.Font.GothamBold
hubIcon.TextSize = 22
hubIcon.Parent = hubButton

-- ========== MAIN FRAME ==========
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 300)
mainFrame.Position = UDim2.new(0, 20, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "⚡ Chat Trigger"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Collapse Button
local collapseBtn = Instance.new("TextButton")
collapseBtn.Size = UDim2.new(0, 28, 0, 22)
collapseBtn.Position = UDim2.new(1, -32, 0.5, -11)
collapseBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
collapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
collapseBtn.Text = "×"
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.TextSize = 14
collapseBtn.Parent = titleBar

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 6)
collapseCorner.Parent = collapseBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -28)
contentFrame.Position = UDim2.new(0, 0, 0, 28)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Trigger Input Label
local triggerLabel = Instance.new("TextLabel")
triggerLabel.Size = UDim2.new(1, -20, 0, 16)
triggerLabel.Position = UDim2.new(0, 10, 0, 8)
triggerLabel.BackgroundTransparency = 1
triggerLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
triggerLabel.Text = "Trigger Command (type in chat)"
triggerLabel.Font = Enum.Font.Gotham
triggerLabel.TextSize = 10
triggerLabel.TextXAlignment = Enum.TextXAlignment.Left
triggerLabel.Parent = contentFrame

-- Trigger Textbox
local triggerTextbox = Instance.new("TextBox")
triggerTextbox.Size = UDim2.new(1, -20, 0, 28)
triggerTextbox.Position = UDim2.new(0, 10, 0, 26)
triggerTextbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
triggerTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
triggerTextbox.Text = "-die"
triggerTextbox.PlaceholderText = "-die"
triggerTextbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
triggerTextbox.Font = Enum.Font.Gotham
triggerTextbox.TextSize = 12
triggerTextbox.ClearTextOnFocus = false
triggerTextbox.Parent = contentFrame

local triggerCorner = Instance.new("UICorner")
triggerCorner.CornerRadius = UDim.new(0, 6)
triggerCorner.Parent = triggerTextbox

-- Messages Label
local msgLabel = Instance.new("TextLabel")
msgLabel.Size = UDim2.new(1, -20, 0, 16)
msgLabel.Position = UDim2.new(0, 10, 0, 60)
msgLabel.BackgroundTransparency = 1
msgLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
msgLabel.Text = "Messages (one per line)"
msgLabel.Font = Enum.Font.Gotham
msgLabel.TextSize = 10
msgLabel.TextXAlignment = Enum.TextXAlignment.Left
msgLabel.Parent = contentFrame

-- Messages Textbox
local msgTextbox = Instance.new("TextBox")
msgTextbox.Size = UDim2.new(1, -20, 0, 80)
msgTextbox.Position = UDim2.new(0, 10, 0, 78)
msgTextbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
msgTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
msgTextbox.Text = ""
msgTextbox.PlaceholderText = "Message 1\nMessage 2\nMessage 3"
msgTextbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
msgTextbox.Font = Enum.Font.Gotham
msgTextbox.TextSize = 12
msgTextbox.TextXAlignment = Enum.TextXAlignment.Left
msgTextbox.TextYAlignment = Enum.TextYAlignment.Top
msgTextbox.ClearTextOnFocus = false
msgTextbox.MultiLine = true
msgTextbox.TextWrapped = true
msgTextbox.Parent = contentFrame

local msgCorner = Instance.new("UICorner")
msgCorner.CornerRadius = UDim.new(0, 6)
msgCorner.Parent = msgTextbox

-- Delay Row
local delayRow = Instance.new("Frame")
delayRow.Size = UDim2.new(1, -20, 0, 28)
delayRow.Position = UDim2.new(0, 10, 0, 164)
delayRow.BackgroundTransparency = 1
delayRow.Parent = contentFrame

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 45, 1, 0)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
delayLabel.Text = "Delay:"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 11
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = delayRow

local delayTextbox = Instance.new("TextBox")
delayTextbox.Size = UDim2.new(0, 50, 1, 0)
delayTextbox.Position = UDim2.new(0, 48, 0, 0)
delayTextbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayTextbox.Text = "0.5"
delayTextbox.PlaceholderText = "0.5"
delayTextbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
delayTextbox.Font = Enum.Font.Gotham
delayTextbox.TextSize = 11
delayTextbox.ClearTextOnFocus = false
delayTextbox.Parent = delayRow

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 6)
delayCorner.Parent = delayTextbox

local secLabel = Instance.new("TextLabel")
secLabel.Size = UDim2.new(0, 25, 1, 0)
secLabel.Position = UDim2.new(0, 102, 0, 0)
secLabel.BackgroundTransparency = 1
secLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
secLabel.Text = "sec"
secLabel.Font = Enum.Font.Gotham
secLabel.TextSize = 10
secLabel.Parent = delayRow

-- Enable Toggle
local enableBtn = Instance.new("TextButton")
enableBtn.Size = UDim2.new(1, -20, 0, 32)
enableBtn.Position = UDim2.new(0, 10, 0, 198)
enableBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
enableBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
enableBtn.Text = "OFF - Click to Enable"
enableBtn.Font = Enum.Font.GothamBold
enableBtn.TextSize = 12
enableBtn.Parent = contentFrame

local enableCorner = Instance.new("UICorner")
enableCorner.CornerRadius = UDim.new(0, 6)
enableCorner.Parent = enableBtn

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 236)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Text = "Type trigger in chat to fire messages"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = contentFrame

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

collapseBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	hubButton.Visible = true
end)

-- ========== SEND MESSAGE FUNCTION ==========
local function sendMessage(msg)
	local message = msg:gsub("^%s+", ""):gsub("%s+$", "")
	
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
		enableBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
		enableBtn.Text = "ON - Listening for Trigger"
		statusLabel.Text = "Waiting for: "..triggerTextbox.Text
		statusLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
	else
		enableBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
		enableBtn.Text = "OFF - Click to Enable"
		statusLabel.Text = "Type trigger in chat to fire messages"
		statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	end
end)

-- ========== CHAT DETECTION ==========
local function onChatted(playerWhoChatted, message)
	if not enabled then return end
	if spamming then return end
	
	local trigger = triggerTextbox.Text:gsub("^%s+", ""):gsub("%s+$", "")
	if trigger == "" then return end
	
	if message == trigger then
		local text = msgTextbox.Text
		if text == "" then
			statusLabel.Text = "No messages set!"
			return
		end
		
		local lines = {}
		for line in text:gmatch("[^\n]+") do
			if line:match("%S") then
				table.insert(lines, line)
			end
		end
		
		if #lines == 0 then return end
		
		local delay = tonumber(delayTextbox.Text) or 0.5
		if delay < 0 then delay = 0 end
		
		spamming = true
		statusLabel.Text = "Triggered! Sending..."
		statusLabel.TextColor3 = Color3.fromRGB(255, 193, 7)
		
		task.spawn(function()
			for i, line in ipairs(lines) do
				sendMessage(line)
				statusLabel.Text = "Sent "..i.."/"..#lines
				if i < #lines and delay > 0 then
					task.wait(delay)
				end
			end
			spamming = false
			statusLabel.Text = "Done! Waiting for: "..trigger
			statusLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
		end)
	end
end

-- Hook into chat
Players.PlayerAdded:Connect(function(plr)
	if plr == player then
		plr.Chatted:Connect(function(msg)
			onChatted(plr, msg)
		end)
	end
end)

if player.Chatted then
	player.Chatted:Connect(function(msg)
		onChatted(player, msg)
	end)
end

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

print("✅ Chat Trigger Loaded")
