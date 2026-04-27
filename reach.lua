--[[
    Invisible Reach Script (Mobile Friendly)
    Reach: 14 studs
    No visual boxes/indicators
    Always-on by default
]]

local Reach = {}
Reach.Settings = {
    Enabled = true,
    ReachDistance = 14,
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Connections = {}
local OriginalSizes = {}
local ModifiedTools = {}

-- Modify tool hitbox
local function ModifyTool(tool)
    if not tool:IsA("Tool") then return end
    if ModifiedTools[tool] then return end
    
    local handle = tool:FindFirstChild("Handle")
    if not handle then return end
    
    -- Store original
    if not OriginalSizes[tool] then
        OriginalSizes[tool] = handle.Size
    end
    
    ModifiedTools[tool] = true
    
    -- Apply reach
    local function Apply()
        if not Reach.Settings.Enabled then
            if OriginalSizes[tool] then
                handle.Size = OriginalSizes[tool]
            end
            return
        end
        
        local originalSize = OriginalSizes[tool]
        local multiplier = Reach.Settings.ReachDistance / 10
        
        handle.Size = Vector3.new(
            originalSize.X * multiplier,
            originalSize.Y * multiplier,
            originalSize.Z * multiplier
        )
        handle.Transparency = 1
        handle.Material = Enum.Material.ForceField
        
        -- Remove any visual indicators
        for _, child in pairs(handle:GetChildren()) do
            if child:IsA("BoxHandleAdornment") or child:IsA("SphereHandleAdornment") then
                child:Destroy()
            end
        end
    end
    
    Apply()
    
    -- Keep applying on heartbeat
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not tool or not tool.Parent then
            connection:Disconnect()
            ModifiedTools[tool] = nil
            return
        end
        Apply()
    end)
    
    table.insert(Connections, connection)
end

-- Scan for tools
local function ScanTools()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer.Backpack
    
    if character then
        for _, item in pairs(character:GetChildren()) do
            if item:IsA("Tool") then
                ModifyTool(item)
            end
        end
    end
    
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                ModifyTool(item)
            end
        end
    end
end

-- Mobile GUI Toggle Button
local function CreateMobileGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ReachGUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    local Button = Instance.new("TextButton")
    Button.Name = "ToggleBtn"
    Button.Size = UDim2.new(0, 100, 0, 40)
    Button.Position = UDim2.new(0, 20, 0.7, 0)
    Button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = "Reach: ON"
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Button
    
    -- Make it draggable for mobile
    local dragging = false
    local dragStart, startPos
    
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Button.Position
        end
    end)
    
    Button.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            Button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    Button.MouseButton1Click:Connect(function()
        Reach.Settings.Enabled = not Reach.Settings.Enabled
        Button.Text = "Reach: " .. (Reach.Settings.Enabled and "ON" or "OFF")
        Button.BackgroundColor3 = Reach.Settings.Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    end)
end

-- Monitor for tools
local function StartMonitoring()
    Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        ScanTools()
    end)
    
    Connections.ChildAdded = LocalPlayer.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.1)
            ModifyTool(child)
        end
    end)
    
    Connections.BackpackChildAdded = LocalPlayer.Backpack.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.1)
            ModifyTool(child)
        end
    end)
end

-- Cleanup function
function Reach.Cleanup()
    for _, conn in pairs(Connections) do
        if conn then conn:Disconnect() end
    end
    
    for tool, originalSize in pairs(OriginalSizes) do
        if tool and tool:FindFirstChild("Handle") then
            tool.Handle.Size = originalSize
            tool.Handle.Transparency = 0
        end
    end
    
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if gui then
        local reachGui = gui:FindFirstChild("ReachGUI")
        if reachGui then reachGui:Destroy() end
    end
end

-- Initialize
local function Init()
    print("[Reach] Loading...")
    print("[Reach] Distance: 14 studs")
    print("[Reach] Tap the green button to toggle")
    
    ScanTools()
    StartMonitoring()
    CreateMobileGUI()
    
    print("[Reach] Loaded!")
end

Init()

return Reach
