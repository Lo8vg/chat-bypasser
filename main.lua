--[[
    ███████╗██████╗  █████╗  ██████╗██╗  ██╗███████╗██████╗ 
    ██╔════╝██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
    ███████╗██████╔╝███████║██║     █████╔╝ █████╗  ██████╔╝
    ╚════██║██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
    ███████║██║     ██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
    ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
    
    Advanced Auto Fling v1.0
    Powerful player fling system with GUI
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Fling Settings
local FlingSettings = {
    Enabled = false,
    Target = nil,
    AutoFling = false,
    FlingSpeed = 0.1,
    FlingForce = Vector3.new(0, 5000, 0),
    RandomForce = false,
    RandomRange = 2000,
    AntiDetection = true,
    FlingMethod = "Velocity", -- "Velocity", "BodyVelocity", "Impulse"
    LoopDelay = 0.1,
    MaxDistance = 1000,
    AutoSelect = false,
    AutoSelectMethod = "Nearest", -- "Nearest", "Random", "Health"
    VisualEffects = true,
    SoundEffects = false,
    Notification = true
}

-- Fling Methods
local FlingMethods = {
    ["Velocity"] = function(target, force)
        if target and target:FindFirstChild("HumanoidRootPart") then
            target.HumanoidRootPart.Velocity = force
        end
    end,
    
    ["BodyVelocity"] = function(target, force)
        if target and target:FindFirstChild("HumanoidRootPart") then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.P = 5000
            bv.Velocity = force
            bv.Parent = target.HumanoidRootPart
            
            game:GetService("Debris"):AddItem(bv, 0.1)
        end
    end,
    
    ["Impulse"] = function(target, force)
        if target and target:FindFirstChild("HumanoidRootPart") then
            local impulse = Instance.new("BodyVelocity")
            impulse.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            impulse.P = 10000
            impulse.Velocity = force * 10
            impulse.Parent = target.HumanoidRootPart
            
            game:GetService("Debris"):AddItem(impulse, 0.05)
        end
    end
}

-- Helper Functions
local function GetPlayerByName(name)
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(name:lower()) then
            return player
        end
    end
    return nil
end

local function GetNearestPlayer()
    local nearest = nil
    local distance = FlingSettings.MaxDistance
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < distance then
                distance = dist
                nearest = player
            end
        end
    end
    
    return nearest
end

local function GetRandomPlayer()
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(players, player)
        end
    end
    
    if #players > 0 then
        return players[math.random(1, #players)]
    end
    return nil
end

local function GetPlayerByHealth()
    local lowest = nil
    local health = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character and player.Character:FindFirstChild("Humanoid") then
            local hp = player.Character.Humanoid.Health
            if hp < health then
                health = hp
                lowest = player
            end
        end
    end
    
    return lowest
end

local function GetRandomForce()
    if not FlingSettings.RandomForce then return FlingSettings.FlingForce end
    
    local base = FlingSettings.FlingForce
    local range = FlingSettings.RandomRange
    
    return Vector3.new(
        base.X + math.random(-range, range),
        base.Y + math.random(-range, range),
        base.Z + math.random(-range, range)
    )
end

local function CreateVisualEffect(target)
    if not FlingSettings.VisualEffects or not target or not target.Character then return end
    
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Create explosion effect
    local explosion = Instance.new("Explosion")
    explosion.Position = hrp.Position
    explosion.BlastRadius = 10
    explosion.BlastPressure = 0
    explosion.DestroyJointRadiusPercent = 0
    explosion.ExplosionType = Enum.ExplosionType.NoCraters
    explosion.Parent = Workspace
    
    game:GetService("Debris"):AddItem(explosion, 1)
end

local function PlaySoundEffect()
    if not FlingSettings.SoundEffects then return end
    
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://138167260" -- Explosion sound
    sound.Volume = 0.5
    sound.Parent = Workspace
    sound:Play()
    
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

local function Notify(title, message)
    if not FlingSettings.Notification then return end
    
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[Advanced Fling] " .. title .. ": " .. message;
        Color = Color3.fromRGB(255, 0, 0);
        Font = Enum.Font.SourceSansBold;
        FontSize = 18;
    })
end

-- Main Fling Function
local function FlingTarget(target)
    if not target or not target.Character then return end
    
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Apply anti-detection
    if FlingSettings.AntiDetection then
        -- Random delay
        task.wait(math.random(0.05, 0.15))
    end
    
    -- Get force
    local force = GetRandomForce()
    
    -- Apply fling method
    local method = FlingMethods[FlingSettings.FlingMethod]
    if method then
        method(target, force)
    end
    
    -- Visual effects
    CreateVisualEffect(target)
    PlaySoundEffect()
    
    -- Notification
    Notify("Target Flung", target.Name)
end

-- Auto Fling Loop
local function AutoFlingLoop()
    while FlingSettings.AutoFling do
        -- Get target
        local target = FlingSettings.Target
        
        -- Auto-select if enabled
        if FlingSettings.AutoSelect and not target then
            if FlingSettings.AutoSelectMethod == "Nearest" then
                target = GetNearestPlayer()
            elseif FlingSettings.AutoSelectMethod == "Random" then
                target = GetRandomPlayer()
            elseif FlingSettings.AutoSelectMethod == "Health" then
                target = GetPlayerByHealth()
            end
        end
        
        -- Fling target
        if target then
            FlingTarget(target)
        end
        
        -- Wait for next iteration
        task.wait(FlingSettings.LoopDelay)
    end
end

-- Create Advanced GUI
local Window = Rayfield:CreateWindow({
    Name = "Advanced Auto Fling v1.0",
    LoadingTitle = "Advanced Fling",
    LoadingSubtitle = "Loading fling system...",
    ConfigurationSaving = {
        Enabled = false
    },
    CustomTheme = {
        Background = Color3.fromRGB(20, 20, 20),
        Titlebar = Color3.fromRGB(255, 0, 0),
        Tab = Color3.fromRGB(139, 0, 0),
        Accent = Color3.fromRGB(255, 0, 0),
        TextColor = Color3.fromRGB(255, 255, 255)
    }
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Target Selection")

MainTab:CreateInput({
    Name = "Player Name",
    PlaceholderText = "Enter player name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        FlingSettings.Target = GetPlayerByName(Text)
        if FlingSettings.Target then
            Notify("Target Selected", FlingSettings.Target.Name)
        else
            Notify("Error", "Player not found")
        end
    end
})

MainTab:CreateDropdown({
    Name = "Quick Select",
    Options = {"Nearest", "Random", "Lowest Health"},
    CurrentOption = "Nearest",
    Flag = "QuickSelectDropdown",
    Callback = function(Option)
        if Option == "Nearest" then
            FlingSettings.Target = GetNearestPlayer()
        elseif Option == "Random" then
            FlingSettings.Target = GetRandomPlayer()
        elseif Option == "Lowest Health" then
            FlingSettings.Target = GetPlayerByHealth()
        end
        
        if FlingSettings.Target then
            Notify("Target Selected", FlingSettings.Target.Name)
        else
            Notify("Error", "No valid target")
        end
    end
})

MainTab:CreateSection("Fling Control")

MainTab:CreateToggle({
    Name = "Auto Fling",
    CurrentValue = false,
    Flag = "AutoFlingToggle",
    Callback = function(Value)
        FlingSettings.AutoFling = Value
        if Value then
            spawn(AutoFlingLoop)
            Notify("Auto Fling", "Started")
        else
            Notify("Auto Fling", "Stopped")
        end
    end
})

MainTab:CreateButton({
    Name = "Fling Target Once",
    Callback = function()
        if FlingSettings.Target then
            FlingTarget(FlingSettings.Target)
        else
            Notify("Error", "No target selected")
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSection("Fling Settings")

SettingsTab:CreateSlider({
    Name = "Fling Speed",
    Range = {0.05, 1},
    Increment = 0.05,
    CurrentValue = 0.1,
    Flag = "FlingSpeedSlider",
    Callback = function(Value)
        FlingSettings.LoopDelay = Value
    end
})

SettingsTab:CreateSlider({
    Name = "Max Distance",
    Range = {100, 5000},
    Increment = 100,
    CurrentValue = 1000,
    Flag = "MaxDistanceSlider",
    Callback = function(Value)
        FlingSettings.MaxDistance = Value
    end
})

SettingsTab:CreateDropdown({
    Name = "Fling Method",
    Options = {"Velocity", "BodyVelocity", "Impulse"},
    CurrentOption = "Velocity",
    Flag = "FlingMethodDropdown",
    Callback = function(Option)
        FlingSettings.FlingMethod = Option
    end
})

SettingsTab:CreateSection("Force Settings")

SettingsTab:CreateToggle({
    Name = "Random Force",
    CurrentValue = false,
    Flag = "RandomForceToggle",
    Callback = function(Value)
        FlingSettings.RandomForce = Value
    end
})

SettingsTab:CreateSlider({
    Name = "Random Force Range",
    Range = {500, 10000},
    Increment = 500,
    CurrentValue = 2000,
    Flag = "RandomForceRangeSlider",
    Callback = function(Value)
        FlingSettings.RandomRange = Value
    end
})

SettingsTab:CreateSlider({
    Name = "Base Force Y",
    Range = {1000, 20000},
    Increment = 1000,
    CurrentValue = 5000,
    Flag = "BaseForceYSlider",
    Callback = function(Value)
        FlingSettings.FlingForce = Vector3.new(FlingSettings.FlingForce.X, Value, FlingSettings.FlingForce.Z)
    end
})

-- Advanced Tab
local AdvancedTab = Window:CreateTab("Advanced", 4483362458)

AdvancedTab:CreateSection("Auto Selection")

AdvancedTab:CreateToggle({
    Name = "Auto Select Targets",
    CurrentValue = false,
    Flag = "AutoSelectToggle",
    Callback = function(Value)
        FlingSettings.AutoSelect = Value
    end
})

AdvancedTab:CreateDropdown({
    Name = "Auto Select Method",
    Options = {"Nearest", "Random", "Health"},
    CurrentOption = "Nearest",
    Flag = "AutoSelectMethodDropdown",
    Callback = function(Option)
        FlingSettings.AutoSelectMethod = Option
    end
})

AdvancedTab:CreateSection("Effects & Detection")

AdvancedTab:CreateToggle({
    Name = "Visual Effects",
    CurrentValue = true,
    Flag = "VisualEffectsToggle",
    Callback = function(Value)
        FlingSettings.VisualEffects = Value
    end
})

AdvancedTab:CreateToggle({
    Name = "Sound Effects",
    CurrentValue = false,
    Flag = "SoundEffectsToggle",
    Callback = function(Value)
        FlingSettings.SoundEffects = Value
    end
})

AdvancedTab:CreateToggle({
    Name = "Anti-Detection",
    CurrentValue = true,
    Flag = "AntiDetectionToggle",
    Callback = function(Value)
        FlingSettings.AntiDetection = Value
    end
})

AdvancedTab:CreateToggle({
    Name = "Notifications",
    CurrentValue = true,
    Flag = "NotificationsToggle",
    Callback = function(Value)
        FlingSettings.Notification = Value
    end
})

-- Player List Tab
local PlayerListTab = Window:CreateTab("Player List", 4483362458)

PlayerListTab:CreateSection("Players in Server")

local function UpdatePlayerList()
    PlayerListTab:CreateParagraph({
        Title = "Online Players",
        Content = table.concat(Players:GetPlayers(), ", ")
    })
end

UpdatePlayerList()

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

-- Startup Notification
Notify("System Ready", "Advanced Auto Fling loaded successfully!")

print("═══════════════════════════")
print("Advanced Auto Fling v1.0 Loaded")
print("Select target and start flinging!")
print("═══════════════════════════")
