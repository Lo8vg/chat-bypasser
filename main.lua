--[[
    ███████╗██████╗  █████╗  ██████╗██╗  ██╗███████╗██████╗
    ██╔════╝██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
    ███████╗██████╔╝███████║██║     █████╔╝ █████╗  ██████╔╝
    ╚════██║██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
    ███████║██║     ██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
    ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
    
    REAL Auto Fling v3.0
    Simple body attach fling with immediate start
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Fling Settings
local FlingSettings = {
    Enabled = false,
    Target = nil,
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
    Notification = true
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

local function Notify(title, message)
    if not FlingSettings.Notification then return end

    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[REAL Fling] " .. title .. ": " .. message;
        Color = Color3.fromRGB(255, 0, 0);
        Font = Enum.Font.SourceSansBold;
        FontSize = 18;
    })
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

local function StartFling(target)
    if Flinging or not target or not target.Character then return end

    Flinging = true
    FlingSettings.Target = target

    -- Create attachment part
    CreateAttachmentPart()

    -- Setup anti-gravity
    SetupAntiGravity(target)

    -- Get target's HumanoidRootPart
    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
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
    end)

    Notify("Fling Started", "Now flinging: " .. target.Name)
end

local function StopFling()
    if not Flinging then return end

    Flinging = false
    FlingSettings.Target = nil

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

-- Create Simple GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "REAL Auto Fling GUI"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Text = "REAL Auto Fling v3.0"
TitleLabel.TextScaled = true
TitleLabel.Parent = MainFrame

local PlayerInput = Instance.new("TextBox")
PlayerInput.Size = UDim2.new(1, 0, 0, 30)
PlayerInput.Position = UDim2.new(0, 0, 0, 40)
PlayerInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerInput.PlaceholderText = "Enter player name..."
PlayerInput.Parent = MainFrame

local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(1, 0, 0, 30)
StartButton.Position = UDim2.new(0, 0, 0, 80)
StartButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
StartButton.TextColor3 = Color3.fromRGB(0, 0, 0)
StartButton.Text = "Start Fling"
StartButton.Parent = MainFrame

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(1, 0, 0, 30)
StopButton.Position = UDim2.new(0, 0, 0, 120)
StopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.Text = "Stop Fling"
StopButton.Parent = MainFrame

-- Button Callbacks
StartButton.MouseButton1Click:Connect(function()
    local targetName = PlayerInput.Text
    local target = GetPlayerByName(targetName)
    if target then
        FlingSettings.Target = target
        StartFling(target)
    else
        Notify("Error", "Player not found")
    end
end)

StopButton.MouseButton1Click:Connect(function()
    StopFling()
end)

-- Setup auto respawn
SetupAutoRespawn()

-- Startup Notification
Notify("System Ready", "REAL Auto Fling loaded successfully!")

print("═══════════════════════════")
print("REAL Auto Fling v3.0 Loaded")
print("This is the REAL body attach method!")
print("═══════════════════════════")
