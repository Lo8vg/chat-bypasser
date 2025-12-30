--[[
    ███████╗██████╗  █████╗  ██████╗██╗  ██╗███████╗██████╗ 
    ██╔════╝██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
    ███████╗██████╔╝███████║██║     █████╔╝ █████╗  ██████╔╝
    ╚════██║██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
    ███████║██║     ██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
    ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
    
    REAL Auto Fling v2.0
    Body attach method with continuous fling
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Fling Settings
local FlingSettings = {
    Enabled = false,
    Target = nil,
    AutoFling = false,
    SpinSpeed = 5000, -- Higher = faster spin
    FlingForce = 10000, -- Upward force
    AttachDistance = 0, -- How close to attach (0 = inside)
    AutoRespawn = true, -- Auto respawn if you die
    AutoReattach = true, -- Reattach when target respawns
    AntiGravity = true, -- Prevent target from falling
    NoClip = true, -- NoClip for better attachment
    RotationMethod = "CFrame", -- "CFrame" or "AngularVelocity"
    DeathCheck = true, -- Check if target died
    ReattachDelay = 0.5, -- Delay before reattaching
    VisualEffects = true,
    Notification = true,
    DebugMode = false
}

-- Fling Variables
local FlingConnection = nil
local TargetConnection = nil
local AttachmentPart = nil
local OriginalGravity = nil
local Flinging = false

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
    local distance = 500
    
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

local function CreateAttachmentPart()
    if AttachmentPart then
        AttachmentPart:Destroy()
    end
    
    AttachmentPart = Instance.new("Part")
    AttachmentPart.Name = "FlingAttachment"
    AttachmentPart.Size = Vector3.new(1, 1, 1)
    AttachmentPart.Transparency = 1
    AttachmentPart.Anchored = false
    AttachmentPart.CanCollide = false
    AttachmentPart.Massless = true
    AttachmentPart.Parent = Character
    
    local weld = Instance.new("Weld")
    weld.Part0 = HumanoidRootPart
    weld.Part1 = AttachmentPart
    weld.C0 = CFrame.new(0, 0, 0)
    weld.Parent = AttachmentPart
    
    return AttachmentPart
end

local function Notify(title, message)
    if not FlingSettings.Notification then return end
    
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[REAL Fling] " .. title .. ": " .. message;
        Color = Color3.fromRGB(255, 0, 0);
        Font = Enum.Font.SourceSansBold;
        FontSize = 18;
    })
end

local function Debug(message)
    if FlingSettings.DebugMode then
        print("[REAL Fling Debug]: " .. message)
    end
end

local function SetupAntiGravity(target)
    if not FlingSettings.AntiGravity or not target or not target.Character then return end
    
    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        OriginalGravity = humanoid.JumpPower
        humanoid.JumpPower = 0
        humanoid.UseJumpPower = false
    end
    
    -- Remove any existing BodyVelocity
    for _, obj in pairs(target.Character:GetDescendants()) do
        if obj:IsA("BodyVelocity") or obj:IsA("BodyForce") then
            obj:Destroy()
        end
    end
end

local function RestoreGravity(target)
    if not target or not target.Character or not OriginalGravity then return end
    
    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpPower = OriginalGravity
        humanoid.UseJumpPower = true
    end
end

local function StartFling(target)
    if Flinging or not target or not target.Character then return end
    
    Flinging = true
    FlingSettings.Target = target
    
    Debug("Starting fling on: " .. target.Name)
    
    -- Create attachment part
    CreateAttachmentPart()
    
    -- Setup anti-gravity
    SetupAntiGravity(target)
    
    -- Get target's HumanoidRootPart
    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
        Debug("Target has no HumanoidRootPart")
        StopFling()
        return
    end
    
    -- NoClip
    if FlingSettings.NoClip then
        local noclip = Instance.new("BodyVelocity")
        noclip.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        noclip.Velocity = Vector3.new(0, 0, 0)
        noclip.Name = "NoClip"
        noclip.Parent = HumanoidRootPart
        
        Debris:AddItem(noclip, 10)
    end
    
    -- Start fling loop
    FlingConnection = RunService.Heartbeat:Connect(function()
        if not FlingSettings.Enabled or not target.Character or not targetHRP or not AttachmentPart then
            StopFling()
            return
        end
        
        -- Check if target died
        if FlingSettings.DeathCheck and target.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
            Debug("Target died, reattaching...")
            if FlingSettings.AutoReattach then
                task.wait(FlingSettings.ReattachDelay)
                target.CharacterAdded:Wait()
                StartFling(target)
            else
                StopFling()
            end
            return
        end
        
        -- Attach to target
        local targetCFrame = targetHRP.CFrame
        local attachCFrame = targetCFrame * CFrame.new(0, FlingSettings.AttachDistance, 0)
        
        -- Move attachment part to target
        AttachmentPart.CFrame = attachCFrame
        
        -- Apply spinning
        if FlingSettings.RotationMethod == "CFrame" then
            -- CFrame rotation method
            local spinAngle = tick() * FlingSettings.SpinSpeed
            local spinCFrame = CFrame.Angles(0, spinAngle, 0)
            
            -- Apply to target
            targetHRP.CFrame = targetHRP.CFrame * spinCFrame
            
            -- Apply upward force
            targetHRP.Velocity = targetHRP.Velocity + Vector3.new(0, FlingSettings.FlingForce * 0.01, 0)
            
        elseif FlingSettings.RotationMethod == "AngularVelocity" then
            -- AngularVelocity method
            local existingAV = targetHRP:FindFirstChild("SpinAV")
            if not existingAV then
                local av = Instance.new("BodyAngularVelocity")
                av.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                av.AngularVelocity = Vector3.new(0, FlingSettings.SpinSpeed * 0.1, 0)
                av.P = 10000
                av.Name = "SpinAV"
                av.Parent = targetHRP
            end
            
            -- Apply upward force
            targetHRP.Velocity = targetHRP.Velocity + Vector3.new(0, FlingSettings.FlingForce * 0.01, 0)
        end
        
        -- Visual effects
        if FlingSettings.VisualEffects and math.random(1, 100) <= 5 then
            local effect = Instance.new("Explosion")
            effect.Position = targetHRP.Position
            effect.BlastRadius = 5
            effect.BlastPressure = 0
            effect.Parent = Workspace
            Debris:AddItem(effect, 0.5)
        end
    end)
    
    Notify("Fling Started", "Now flinging: " .. target.Name)
end

local function StopFling()
    if not Flinging then return end
    
    Flinging = false
    FlingSettings.Target = nil
    
    Debug("Stopping fling")
    
    -- Disconnect connections
    if FlingConnection then
        FlingConnection:Disconnect()
        FlingConnection = nil
    end
    
    if TargetConnection then
        TargetConnection:Disconnect()
        TargetConnection = nil
    end
    
    -- Clean up attachment
    if AttachmentPart then
        AttachmentPart:Destroy()
        AttachmentPart = nil
    end
    
    -- Clean up target
    if FlingSettings.Target and FlingSettings.Target.Character then
        local targetHRP = FlingSettings.Target.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP then
            -- Remove spin
            local spinAV = targetHRP:FindFirstChild("SpinAV")
            if spinAV then
                spinAV:Destroy()
            end
        end
        
        -- Restore gravity
        RestoreGravity(FlingSettings.Target)
    end
    
    -- Clean up self
    local noclip = HumanoidRootPart:FindFirstChild("NoClip")
    if noclip then
        noclip:Destroy()
    end
    
    Notify("Fling Stopped", "No longer flinging")
end

-- Auto respawn
local function SetupAutoRespawn()
    Humanoid.Died:Connect(function()
        if FlingSettings.AutoRespawn and Flinging then
            task.wait(1)
            Player:LoadCharacter()
            
            -- Restart fling after respawn
            if FlingSettings.AutoReattach and FlingSettings.Target then
                task.wait(FlingSettings.ReattachDelay)
                StartFling(FlingSettings.Target)
            end
        end
    end)
end

-- Create Advanced GUI
local Window = Rayfield:CreateWindow({
    Name = "REAL Auto Fling v2.0",
    LoadingTitle = "REAL Fling",
    LoadingSubtitle = "Loading body attach fling...",
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
        local target = GetPlayerByName(Text)
        if target then
            FlingSettings.Target = target
            Notify("Target Selected", target.Name)
        else
            Notify("Error", "Player not found")
        end
    end
})

MainTab:CreateButton({
    Name = "Select Nearest Player",
    Callback = function()
        local target = GetNearestPlayer()
        if target then
            FlingSettings.Target = target
            Notify("Target Selected", target.Name)
        else
            Notify("Error", "No players nearby")
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
            if FlingSettings.Target then
                StartFling(FlingSettings.Target)
            else
                Notify("Error", "No target selected")
                FlingSettings.AutoFling = false
            end
        else
            StopFling()
        end
    end
})

MainTab:CreateButton({
    Name = "Start Fling",
    Callback = function()
        if FlingSettings.Target then
            StartFling(FlingSettings.Target)
        else
            Notify("Error", "No target selected")
        end
    end
})

MainTab:CreateButton({
    Name = "Stop Fling",
    Callback = function()
        StopFling()
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSection("Fling Settings")

SettingsTab:CreateSlider({
    Name = "Spin Speed",
    Range = {1000, 10000},
    Increment = 500,
    CurrentValue = 5000,
    Flag = "SpinSpeedSlider",
    Callback = function(Value)
        FlingSettings.SpinSpeed = Value
    end
})

SettingsTab:CreateSlider({
    Name = "Fling Force",
    Range = {5000, 50000},
    Increment = 1000,
    CurrentValue = 10000,
    Flag = "FlingForceSlider",
    Callback = function(Value)
        FlingSettings.FlingForce = Value
    end
})

SettingsTab:CreateSlider({
    Name = "Attach Distance",
    Range = {-5, 5},
    Increment = 0.5,
    CurrentValue = 0,
    Flag = "AttachDistanceSlider",
    Callback = function(Value)
        FlingSettings.AttachDistance = Value
    end
})

SettingsTab:CreateDropdown({
    Name = "Rotation Method",
    Options = {"CFrame", "AngularVelocity"},
    CurrentOption = "CFrame",
    Flag = "RotationMethodDropdown",
    Callback = function(Option)
        FlingSettings.RotationMethod = Option
    end
})

SettingsTab:CreateSection("Advanced Settings")

SettingsTab:CreateToggle({
    Name = "Auto Respawn",
    CurrentValue = true,
    Flag = "AutoRespawnToggle",
    Callback = function(Value)
        FlingSettings.AutoRespawn = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Auto Reattach",
    CurrentValue = true,
    Flag = "AutoReattachToggle",
    Callback = function(Value)
        FlingSettings.AutoReattach = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Anti Gravity",
    CurrentValue = true,
    Flag = "AntiGravityToggle",
    Callback = function(Value)
        FlingSettings.AntiGravity = Value
    end
})

SettingsTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = true,
    Flag = "NoClipToggle",
    Callback = function(Value)
        FlingSettings.NoClip = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Death Check",
    CurrentValue = true,
    Flag = "DeathCheckToggle",
    Callback = function(Value)
        FlingSettings.DeathCheck = Value
    end
})

SettingsTab:CreateSlider({
    Name = "Reattach Delay",
    Range = {0.1, 2},
    Increment = 0.1,
    CurrentValue = 0.5,
    Flag = "ReattachDelaySlider",
    Callback = function(Value)
        FlingSettings.ReattachDelay = Value
    end
})

-- Effects Tab
local EffectsTab = Window:CreateTab("Effects", 4483362458)

EffectsTab:CreateSection("Visual & Audio")

EffectsTab:CreateToggle({
    Name = "Visual Effects",
    CurrentValue = true,
    Flag = "VisualEffectsToggle",
    Callback = function(Value)
        FlingSettings.VisualEffects = Value
    end
})

EffectsTab:CreateToggle({
    Name = "Notifications",
    CurrentValue = true,
    Flag = "NotificationsToggle",
    Callback = function(Value)
        FlingSettings.Notification = Value
    end
})

EffectsTab:CreateToggle({
    Name = "Debug Mode",
    CurrentValue = false,
    Flag = "DebugModeToggle",
    Callback = function(Value)
        FlingSettings.DebugMode = Value
    end
})

-- Setup auto respawn
SetupAutoRespawn()

-- Startup Notification
Notify("System Ready", "REAL Auto Fling loaded successfully!")

print("═══════════════════════════")
print("REAL Auto Fling v2.0 Loaded")
print("This is the REAL body attach method!")
print("═══════════════════════════")
