-- TEAM CHANGER

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")

local player = Players.LocalPlayer

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeamChanger"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 30)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mfCorner = Instance.new("UICorner")
mfCorner.CornerRadius = UDim.new(0, 6)
mfCorner.Parent = mainFrame

-- Dropdown Button
local dropBtn = Instance.new("TextButton")
dropBtn.Size = UDim2.new(1, 0, 1, 0)
dropBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropBtn.BorderSizePixel = 0
dropBtn.Text = "Select Team ▼"
dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dropBtn.Font = Enum.Font.GothamBold
dropBtn.TextSize = 12
dropBtn.Parent = mainFrame

local dbCorner = Instance.new("UICorner")
dbCorner.CornerRadius = UDim.new(0, 6)
dbCorner.Parent = dropBtn

-- Dropdown List (hidden by default)
local dropList = Instance.new("Frame")
dropList.Size = UDim2.new(1, 0, 0, 0)
dropList.Position = UDim2.new(0, 0, 1, 2)
dropList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dropList.BorderSizePixel = 0
dropList.Visible = false
dropList.Parent = mainFrame

local dlCorner = Instance.new("UICorner")
dlCorner.CornerRadius = UDim.new(0, 6)
dlCorner.Parent = dropList

local dlLayout = Instance.new("UIListLayout")
dlLayout.SortOrder = Enum.SortOrder.LayoutOrder
dlLayout.Parent = dropList

local dlPadding = Instance.new("UIPadding")
dlPadding.PaddingTop = UDim.new(0, 4)
dlPadding.PaddingBottom = UDim.new(0, 4)
dlPadding.Parent = dropList

-- Populate teams
local teamButtons = {}
local isOpen = false

for _, team in pairs(Teams:GetChildren()) do
    if team:IsA("Team") then
        local teamBtn = Instance.new("TextButton")
        teamBtn.Size = UDim2.new(1, -8, 0, 22)
        teamBtn.Position = UDim2.new(0, 4, 0, 0)
        teamBtn.BackgroundColor3 = team.TeamColor.Color
        teamBtn.BackgroundTransparency = 0.5
        teamBtn.BorderSizePixel = 0
        teamBtn.Text = team.Name
        teamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        teamBtn.Font = Enum.Font.Gotham
        teamBtn.TextSize = 11
        teamBtn.Parent = dropList
        
        local tbCorner = Instance.new("UICorner")
        tbCorner.CornerRadius = UDim.new(0, 4)
        tbCorner.Parent = teamBtn
        
        teamBtn.MouseButton1Click:Connect(function()
            -- Try multiple methods to change team
            
            -- Method 1: Direct team set
            player.Team = team
            
            -- Method 2: TeamColor
            player.TeamColor = team.TeamColor
            
            -- Method 3: Find and fire remotes
            for _, remote in pairs(game:GetDescendants()) do
                if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                    local name = remote.Name:lower()
                    if name:find("team") or name:find("join") or name:find("select") then
                        pcall(function()
                            remote:FireServer(team.Name)
                            remote:FireServer(team)
                            remote:FireServer(team.TeamColor.Name)
                        end)
                    end
                end
            end
            
            -- Method 4: ReplicatedStorage remotes
            local repStorage = game:FindFirstChild("ReplicatedStorage")
            if repStorage then
                for _, remote in pairs(repStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                        pcall(function()
                            remote:FireServer("SetTeam", team.Name)
                            remote:FireServer("JoinTeam", team.Name)
                            remote:FireServer("TeamSelect", team.Name)
                        end)
                    end
                end
            end
            
            dropBtn.Text = team.Name .. " ✓"
            dropList.Visible = false
            isOpen = false
        end)
        
        table.insert(teamButtons, teamBtn)
    end
end

-- Calculate dropdown height based on number of teams
local teamCount = #teamButtons
dlLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    dropList.Size = UDim2.new(1, 0, 0, dlLayout.AbsoluteContentSize.Y + 8)
end)

-- Toggle dropdown
dropBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    dropList.Visible = isOpen
    
    if isOpen then
        dropBtn.Text = "Select Team ▲"
    else
        dropBtn.Text = "Select Team ▼"
    end
end)

-- Dragging
local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Show current team on spawn
player:GetPropertyChangedSignal("Team"):Connect(function()
    if player.Team then
        dropBtn.Text = player.Team.Name
    end
end)

if player.Team then
    dropBtn.Text = player.Team.Name
end

print("✅ Team Changer Loaded")
print("📌 Click dropdown to select team")
