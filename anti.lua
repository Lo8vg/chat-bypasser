-- COLLISION FLING PROTECTION
-- Uses collision groups, anchor glitching, and velocity reset on collision detection

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")

local player = Players.LocalPlayer

-- Create collision groups
local success, err = pcall(function()
    PhysicsService:CreateCollisionGroup("AntiFlingSelf")
    PhysicsService:CreateCollisionGroup("AntiFlingOthers")
    PhysicsService:CollisionGroupSetCollidable("AntiFlingSelf", "AntiFlingOthers", false)
end)

local antiFlingEnabled = false
local lastVelocities = {}
local anchorOnCollision = true
local velocityResetOnSpike = true
local collisionGroupEnabled = true
local spamAnchorEnabled = true

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
end

local function getBodyParts(char)
    local parts = {}
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(parts, v)
        end
    end
    return parts
end

local function setCollisionGroup(char, groupName)
    for _, part in pairs(getBodyParts(char)) do
        PhysicsService:SetPartCollisionGroup(part, groupName)
    end
end

local function applyAntiCollisionFling()
    local myChar = player.Character
    if not myChar then return end
    local myRoot = getRoot(myChar)
    if not myRoot then return end
    
    -- Set YOUR parts to AntiFlingSelf group (doesn't collide with others in AntiFlingOthers)
    if collisionGroupEnabled then
        setCollisionGroup(myChar, "AntiFlingSelf")
    end
    
    -- Set OTHER players to AntiFlingOthers group
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            for _, part in pairs(getBodyParts(plr.Character)) do
                PhysicsService:SetPartCollisionGroup(part, "AntiFlingOthers")
            end
        end
    end
end

local function detectCollisionFling()
    local myChar = player.Character
    if not myChar then return false end
    local myRoot = getRoot(myChar)
    if not myRoot then return false end
    
    local currentVel = myRoot.AssemblyLinearVelocity
    local currentAngVel = myRoot.AssemblyAngularVelocity
    local currentSpeed = currentVel.Magnitude
    local currentAngSpeed = currentAngVel.Magnitude
    
    -- Track velocity history
    table.insert(lastVelocities, {vel = currentVel, ang = currentAngVel, time = tick()})
    if #lastVelocities > 10 then
        table.remove(lastVelocities, 1)
    end
    
    -- Detect sudden velocity spike (collision fling signature)
    if #lastVelocities >= 3 then
        local prev = lastVelocities[#lastVelocities - 1]
        local velDiff = (currentVel - prev.vel).Magnitude
        local timeDiff = tick() - prev.time
        
        -- If velocity jumped significantly in a short time, it's a fling
        if velDiff > 100 and timeDiff < 0.1 then
            return true, currentVel, currentAngVel
        end
    end
    
    -- Detect extreme angular velocity (spinning)
    if currentAngSpeed > 30 then
        return true, currentVel, currentAngVel
    end
    
    -- Detect extreme linear velocity
    if currentSpeed > 200 then
        return true, currentVel, currentAngVel
    end
    
    return false, nil, nil
end

local function counterCollisionFling()
    local myChar = player.Character
    if not myChar then return end
    local myRoot = getRoot(myChar)
    if not myRoot then return end
    
    local isFling, vel, angVel = detectCollisionFling()
    
    if isFling then
        -- Method 1: Instant velocity reset
        if velocityResetOnSpike then
            myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
        
        -- Method 2: Brief anchor (breaks physics chain)
        if anchorOnCollision then
            local humanoid = myChar:FindFirstChild("Humanoid")
            if humanoid then
                local originalHealth = humanoid.Health
                myRoot.Anchored = true
                wait(0.05)
                myRoot.Anchored = false
            end
        end
    end
end

local antiFlingLoop = nil

local function startAntiFling()
    if antiFlingLoop then
        antiFlingLoop:Disconnect()
    end
    
    antiFlingLoop = RunService.Heartbeat:Connect(function()
        if not antiFlingEnabled then return end
        
        applyAntiCollisionFling()
        counterCollisionFling()
    end)
end

local function stopAntiFling()
    if antiFlingLoop then
        antiFlingLoop:Disconnect()
        antiFlingLoop = nil
    end
    
    -- Reset collision groups
    local myChar = player.Character
    if myChar then
        for _, part in pairs(getBodyParts(myChar)) do
            PhysicsService:SetPartCollisionGroup(part, "Default")
        end
    end
end

-- Simple toggle (bind to a key or GUI)
player.CharacterAdded:Connect(function()
    if antiFlingEnabled then
        wait(0.5)
        startAntiFling()
    end
end)

-- Enable by default
antiFlingEnabled = true
startAntiFling()

print("✅ Collision Fling Protection Loaded")
print("   Collision group isolation + velocity spike detection + anchor glitch")
