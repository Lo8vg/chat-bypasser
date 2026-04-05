-- COLLISION FLING PROTECTION v2
-- Fixed: No spawn delay, real collision groups, instant spike detection, no counter-force garbage

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")

local player = Players.LocalPlayer

-- Create collision groups ONCE at startup
local collisionGroupsCreated = false
pcall(function()
    PhysicsService:CreateCollisionGroup("AntiFlingSelf")
    PhysicsService:CreateCollisionGroup("AntiFlingOthers")
    PhysicsService:CollisionGroupSetCollidable("AntiFlingSelf", "AntiFlingOthers", false)
    collisionGroupsCreated = true
end)

local antiFlingEnabled = false

local function getRoot(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
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
    if not collisionGroupsCreated then return end
    for _, part in pairs(getBodyParts(char)) do
        PhysicsService:SetPartCollisionGroup(part, groupName)
    end
end

-- INSTANT spawn protection - NO WAIT
local function protectCharacter(char)
    if not antiFlingEnabled then return end
    
    local root = getRoot(char)
    if not root then return end
    
    -- Set collision group immediately
    if collisionGroupsCreated then
        setCollisionGroup(char, "AntiFlingSelf")
    end
    
    -- Brief anchor on spawn to break any immediate physics
    root.Anchored = true
    task.defer(function()
        task.wait(0.03)
        root.Anchored = false
    end)
end

-- Track velocities for spike detection
local prevVelocity = Vector3.new()
local prevAngVelocity = Vector3.new()
local prevTime = tick()

local function detectAndNeutralizeSpike()
    local myChar = player.Character
    local root = getRoot(myChar)
    if not root then return end
    
    local currentVel = root.AssemblyLinearVelocity
    local currentAng = root.AssemblyAngularVelocity
    local currentTime = tick()
    local dt = currentTime - prevTime
    
    if dt <= 0 then
        prevVelocity = currentVel
        prevAngVelocity = currentAng
        prevTime = currentTime
        return
    end
    
    local velSpike = (currentVel - prevVelocity).Magnitude / dt
    local angSpike = (currentAng - prevAngVelocity).Magnitude / dt
    
    -- Instant neutralization on ANY spike
    if velSpike > 500 or currentVel.Magnitude > 150 then
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
    
    if angSpike > 100 or currentAng.Magnitude > 50 then
        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
    
    prevVelocity = currentVel
    prevAngVelocity = currentAng
    prevTime = currentTime
end

local antiFlingLoop = nil

local function startAntiFling()
    if antiFlingLoop then
        antiFlingLoop:Disconnect()
    end
    
    -- Protect current character IMMEDIATELY
    if player.Character then
        protectCharacter(player.Character)
    end
    
    antiFlingLoop = RunService.Heartbeat:Connect(function()
        if not antiFlingEnabled then return end
        
        local myChar = player.Character
        if not myChar then return end
        
        -- Keep collision groups applied
        if collisionGroupsCreated then
            setCollisionGroup(myChar, "AntiFlingSelf")
            
            -- Apply to others
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    setCollisionGroup(plr.Character, "AntiFlingOthers")
                end
            end
        end
        
        detectAndNeutralizeSpike()
    end)
end

local function stopAntiFling()
    if antiFlingLoop then
        antiFlingLoop:Disconnect()
        antiFlingLoop = nil
    end
    
    -- Reset collision groups
    if player.Character then
        setCollisionGroup(player.Character, "Default")
    end
end

-- Character added: IMMEDIATE protection, NO WAIT
player.CharacterAdded:Connect(function(char)
    if antiFlingEnabled then
        protectCharacter(char)
    end
end)

-- Enable immediately
antiFlingEnabled = true
startAntiFling()

print("✅ Collision Fling Protection v2 Loaded")
print("   NO spawn delay, REAL collision groups, INSTANT spike neutralization")
