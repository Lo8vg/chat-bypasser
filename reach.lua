--[[
    Invisible Reach Script (Mobile Friendly)
    Uses hookmethod for better compatibility
]]

local Reach = {
    Enabled = true,
    Distance = 14
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local OriginalNamecall
local Hooked = false
local ToolCache = {}
local OriginalSizes = {}

-- Get nearest player within reach
local function GetNearestPlayer()
    local nearest = nil
    local minDist = Reach.Distance
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if hrp and humanoid and humanoid.Health > 0 then
                local dist = (HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = player
                end
            end
        end
    end
    
    return nearest
end

-- Method 1: Hook namecall for remotes
local function HookNamecall()
    if Hooked then return end
    Hooked = true
    
    OriginalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if Reach.Enabled and (method == "FireServer" or method == "InvokeServer" or method == "fireServer" or method == "invokeServer") then
            local remoteName = self.Name:lower()
            
            -- Common combat remote patterns
            if remoteName:find("hit") or remoteName:find("attack") or remoteName:find("damage") or remoteName:find("swing") or remoteName:find("strike") then
                -- Try to find and modify position/distance args
                for i, arg in pairs(args) do
                    if typeof(arg) == "Instance" and arg:IsA("Player") then
                        -- Already has target, extend the check
                    elseif typeof(arg) == "Vector3" then
                        -- Position argument
                    elseif typeof(arg) == "number" then
                        -- Could be distance, try to extend
                        args[i] = Reach.Distance
                    end
                end
            end
        end
        
        return OriginalNamecall(self, ...)
    end)
end

-- Method 2: Modify tool hitbox directly
local function ModifyToolHitbox(tool)
    if not tool or not tool:IsA("Tool") then return end
    if ToolCache[tool] then return end
    ToolCache[tool] = true
    
    local handle = tool:FindFirstChild("Handle")
    if not handle then return end
    
    -- Store original
    if not OriginalSizes[tool] then
        OriginalSizes[tool] = handle.Size
    end
    
    local function Apply()
        if not Reach.Enabled then
            handle.Size = OriginalSizes[tool] or handle.Size
            return
        end
        
        local orig = OriginalSizes[tool]
        local scale = Reach.Distance / 3
        
        handle.Size = Vector3.new(
            math.max(orig.X, scale),
            math.max(orig.Y, scale),
            math.max(orig.Z, scale)
        )
        handle.Transparency = 1
        handle.Material = Enum.Material.ForceField
        
        -- Kill any visual adornments
        for _, v in pairs(handle:GetChildren()) do
            if v:IsA("BoxHandleAdornment") or v:IsA("SphereHandleAdornment") then
                v:Destroy()
            end
        end
    end
    
    Apply()
    
    -- Keep checking
    task.spawn(function()
        while tool and tool.Parent and ToolCache[tool] do
            Apply()
            task.wait(0.1)
        end
    end)
end

-- Scan tools
local function ScanTools()
    if LocalPlayer.Character then
        for _, item in pairs(LocalPlayer.Character:GetChildren()) do
            if item:IsA("Tool") then
                ModifyToolHitbox(item)
            end
        end
    end
    
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                ModifyToolHitbox(item)
            end
        end
    end
end

-- GUI
local function CreateGUI()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Remove old if exists
    local old = PlayerGui:FindFirstChild("ReachGui")
    if old then old:Destroy() end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ReachGui"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    
    local Button = Instance.new("TextButton")
    Button.Name = "Toggle"
    Button.Size = UDim2.new(0, 110, 0, 45)
    Button.Position = UDim2.new(0, 15, 0.6, 0)
    Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = "Reach: ON (14)"
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamBold
    Button.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Button
    
    -- Draggable for mobile
    local dragging, dragStart, startPos = false, nil, nil
    
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Button.Position
        end
    end)
    
    Button.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            Button.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Toggle on tap
    Button.MouseButton1Click:Connect(function()
        Reach.Enabled = not Reach.Enabled
        Button.Text = "Reach: " .. (Reach.Enabled and "ON" or "OFF") .. " (" .. Reach.Distance .. ")"
        Button.BackgroundColor3 = Reach.Enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        
        -- Re-apply to all tools
        for tool, _ in pairs(ToolCache) do
            if tool and tool:FindFirstChild("Handle") then
                if Reach.Enabled then
                    ModifyToolHitbox(tool)
                else
                    tool.Handle.Size = OriginalSizes[tool] or tool.Handle.Size
                    tool.Handle.Transparency = 0
                end
            end
        end
    end)
    
    return ScreenGui
end

-- Monitor for tools
local function Monitor()
    LocalPlayer.CharacterAdded:Connect(function(char)
        Character = char
        HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
        task.wait(0.3)
        ScanTools()
    end)
    
    if LocalPlayer.Character then
        LocalPlayer.Character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                task.wait(0.1)
                ModifyToolHitbox(child)
            end
        end)
    end
    
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        backpack.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                task.wait(0.1)
                ModifyToolHitbox(child)
            end
        end)
    end
end

-- Main
local function Main()
    print("[Reach] Loading...")
    
    -- Try hook
    local success, err = pcall(HookNamecall)
    if success then
        print("[Reach] Hook installed")
    else
        print("[Reach] Hook failed: " .. tostring(err))
    end
    
    ScanTools()
    Monitor()
    CreateGUI()
    
    print("[Reach] Loaded! Distance: " .. Reach.Distance)
end

Main()
