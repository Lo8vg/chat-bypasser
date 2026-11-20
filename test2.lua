-- FAGGOT KILLER  //  AEGIS  v1.2

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- tuning
local MAX_SPEED = 120
local MAX_STEP = 30
local ANCHOR_TIME = 0.14
local SPIKE_COOLDOWN = 0.16
local COUNTER_POWER = 4200
local COUNTER_RANGE = 10
local MASS_ARMOR = 100
local REPAIR_EVERY = 0.3

-- sword guard tuning
local HEAL_DELAY = 0.07
local SWING_RANGE = 22
local SWING_COOLDOWN = 0.14
local REACH_SIZE = 18
local DASH_DIST = 26
local DASH_COOLDOWN = 0.6
local DAMAGE_TRIGGER = 3

local enabled = false
local lockOn = false
local opt = {
    clamp = true,
    restore = true,
    autoAnchor = true,
    voidRescue = true,
    massArmor = true,
    counter = false,
    holdLock = false,
    autoHeal = true,
    reach = true,
    autoSwing = true,
    dash = true
}

local spikeCount = 0
local autoAnchorUntil = 0
local nextSpikeAt = 0
local nextRepairAt = 0
local nextHealAt = 0
local nextSwingAt = 0
local nextDashAt = 0
local weAnchored = false
local lastGoodPos = nil
local lastHealth = 100
local counterTarget = nil
local loop = nil
local motorCache = {}
local reachStore = {}
local myChar = nil
local myRoot = nil
local myHum = nil

local C = {
    bg = Color3.fromRGB(13, 15, 14),
    panel = Color3.fromRGB(21, 24, 22),
    card = Color3.fromRGB(26, 30, 28),
    cardOn = Color3.fromRGB(11, 40, 30),
    stroke = Color3.fromRGB(36, 42, 39),
    accent = Color3.fromRGB(64, 255, 160),
    accent2 = Color3.fromRGB(0, 190, 255),
    bad = Color3.fromRGB(255, 59, 92),
    text = Color3.fromRGB(232, 240, 235),
    muted = Color3.fromRGB(122, 138, 130),
    dim = Color3.fromRGB(72, 84, 78)
}

local function corner(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = o
    return c
end

local function stroke(o, col, t, tr)
    local s = Instance.new("UIStroke")
    s.Color = col
    s.Thickness = t or 1
    s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = o
    return s
end

local function gradient(o, a, b, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(a, b)
    g.Rotation = rot or 0
    g.Parent = o
    return g
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FaggotKillerAegis"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ===== HUB =====
local hubButton = Instance.new("TextButton")
hubButton.Size = UDim2.new(0, 54, 0, 54)
hubButton.Position = UDim2.new(0, 16, 0.5, 80)
hubButton.BackgroundColor3 = C.panel
hubButton.BorderSizePixel = 0
hubButton.Text = "🛡"
hubButton.TextColor3 = C.accent
hubButton.Font = Enum.Font.GothamBlack
hubButton.TextSize = 20
hubButton.AutoButtonColor = false
hubButton.Parent = screenGui
corner(hubButton, 27)
local hubStroke = stroke(hubButton, C.accent, 1.5, 0.35)

-- ===== PANEL =====
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 344, 0, 524)
mainFrame.Position = UDim2.new(0.5, -172, 0.5, -262)
mainFrame.BackgroundColor3 = C.bg
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
corner(mainFrame, 14)
local frameStroke = stroke(mainFrame, C.stroke, 1)
gradient(mainFrame, Color3.fromRGB(18, 22, 20), C.bg, 90)

local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(1, 0, 0, 3)
accentBar.BackgroundColor3 = C.accent
accentBar.BorderSizePixel = 0
accentBar.Parent = mainFrame
local accentGrad = gradient(accentBar, C.accent, C.accent2, 0)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -180, 0, 18)
title.Position = UDim2.new(0, 16, 0, 9)
title.BackgroundTransparency = 1
title.TextColor3 = C.text
title.Text = "AEGIS"
title.Font = Enum.Font.GothamBlack
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -180, 0, 12)
subtitle.Position = UDim2.new(0, 16, 0, 26)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = C.dim
subtitle.Text = "anti-fling + sword guard · v1.2"
subtitle.Font = Enum.Font.Code
subtitle.TextSize = 9
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = titleBar

local testBtn = Instance.new("TextButton")
testBtn.Size = UDim2.new(0, 44, 0, 24)
testBtn.Position = UDim2.new(1, -78, 0, 10)
testBtn.BackgroundColor3 = C.card
testBtn.TextColor3 = C.muted
testBtn.Text = "TEST"
testBtn.Font = Enum.Font.Code
testBtn.TextSize = 9
testBtn.AutoButtonColor = false
testBtn.Parent = titleBar
corner(testBtn, 6)
stroke(testBtn, C.stroke, 1)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -32, 0, 10)
closeBtn.BackgroundColor3 = C.card
closeBtn.TextColor3 = C.muted
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 11
closeBtn.AutoButtonColor = false
closeBtn.Parent = titleBar
corner(closeBtn, 7)
stroke(closeBtn, C.stroke, 1)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -32, 1, -98)
content.Position = UDim2.new(0, 16, 0, 52)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 6, 0, 6)
statusDot.Position = UDim2.new(0, 1, 0, 7)
statusDot.BackgroundColor3 = C.dim
statusDot.BorderSizePixel = 0
statusDot.Parent = content
corner(statusDot, 3)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(0, 190, 0, 20)
statusLbl.Position = UDim2.new(0, 13, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3 = C.dim
statusLbl.Text = "OFFLINE"
statusLbl.Font = Enum.Font.Code
statusLbl.TextSize = 10
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.TextTruncate = Enum.TextTruncate.AtEnd
statusLbl.Parent = content

local spikeLbl = Instance.new("TextLabel")
spikeLbl.Size = UDim2.new(0, 90, 0, 20)
spikeLbl.Position = UDim2.new(1, -90, 0, 0)
spikeLbl.BackgroundTransparency = 1
spikeLbl.TextColor3 = C.dim
spikeLbl.Text = "0 blocked"
spikeLbl.Font = Enum.Font.Code
spikeLbl.TextSize = 10
spikeLbl.TextXAlignment = Enum.TextXAlignment.Right
spikeLbl.Parent = content

local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(1, 0, 0, 42)
lockBtn.Position = UDim2.new(0, 0, 0, 26)
lockBtn.BackgroundColor3 = C.card
lockBtn.TextColor3 = C.text
lockBtn.Text = "ENABLE SHIELD"
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 13
lockBtn.AutoButtonColor = false
lockBtn.Parent = content
corner(lockBtn, 9)
local lockStroke = stroke(lockBtn, C.bad, 1, 0.55)
local lockGrad = gradient(lockBtn, Color3.fromRGB(30, 34, 32), Color3.fromRGB(24, 27, 25), 90)

local function section(y, txt)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 14)
    l.Position = UDim2.new(0, 0, 0, y)
    l.BackgroundTransparency = 1
    l.TextColor3 = C.dim
    l.Text = txt
    l.Font = Enum.Font.Code
    l.TextSize = 9
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = content
end

local function makeRow(y, label, key, onChange)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 24)
    row.Position = UDim2.new(0, 0, 0, y)
    row.BackgroundTransparency = 1
    row.Parent = content

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -52, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = opt[key] and C.text or C.muted
    lbl.Text = label
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local sw = Instance.new("TextButton")
    sw.Size = UDim2.new(0, 36, 0, 18)
    sw.Position = UDim2.new(1, -36, 0, 3)
    sw.BackgroundColor3 = opt[key] and C.cardOn or C.card
    sw.Text = ""
    sw.AutoButtonColor = false
    sw.Parent = row
    corner(sw, 9)
    local swStroke = stroke(sw, opt[key] and C.accent or C.stroke, 1, opt[key] and 0.45 or 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = opt[key] and UDim2.new(0, 19, 0, 2) or UDim2.new(0, 3, 0, 2)
    knob.BackgroundColor3 = opt[key] and C.accent or C.dim
    knob.BorderSizePixel = 0
    knob.Parent = sw
    corner(knob, 7)

    sw.MouseButton1Click:Connect(function()
        opt[key] = not opt[key]
        TweenService:Create(knob, TweenInfo.new(0.16), {
            Position = opt[key] and UDim2.new(0, 19, 0, 2) or UDim2.new(0, 3, 0, 2),
            BackgroundColor3 = opt[key] and C.accent or C.dim
        }):Play()
        TweenService:Create(sw, TweenInfo.new(0.16), {
            BackgroundColor3 = opt[key] and C.cardOn or C.card
        }):Play()
        swStroke.Color = opt[key] and C.accent or C.stroke
        swStroke.Transparency = opt[key] and 0.45 or 0
        lbl.TextColor3 = opt[key] and C.text or C.muted
        if onChange then onChange(opt[key]) end
    end)
end

section(76, "FLING DEFENSE")
makeRow(92, "velocity clamp", "clamp")
makeRow(118, "position restore", "restore")
makeRow(144, "auto-lock on hit", "autoAnchor")
makeRow(170, "void rescue", "voidRescue")
makeRow(196, "mass armor", "massArmor", function(on)
    if not myRoot then return end
    if on and enabled then
        myRoot.CustomPhysicalProperties = PhysicalProperties.new(MASS_ARMOR, 0.5, 0.5)
    else
        myRoot.CustomPhysicalProperties = nil
    end
end)
makeRow(222, "counter-fling", "counter")
makeRow(248, "hold lock (anchor)", "holdLock", function(on)
    if not enabled or not myRoot then return end
    lockOn = on
    if on then
        myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        myRoot.Anchored = true
        weAnchored = true
    else
        myRoot.Anchored = false
        weAnchored = false
    end
end)

section(278, "SWORD GUARD")
makeRow(294, "auto-heal", "autoHeal")
makeRow(320, "reach boost", "reach", function(on)
    local tool = myChar and myChar:FindFirstChildOfClass("Tool")
    if not tool then return end
    local h = tool:FindFirstChild("Handle")
    if not h then return end
    if on then
        reachStore[tool] = reachStore[tool] or h.Size
        h.Size = Vector3.new(h.Size.X, h.Size.Y, REACH_SIZE)
    else
        h.Size = reachStore[tool] or h.Size
    end
end)
makeRow(346, "auto-swing", "autoSwing")
makeRow(372, "escape dash", "dash")

local killGuiBtn = Instance.new("TextButton")
killGuiBtn.Size = UDim2.new(1, 0, 0, 30)
killGuiBtn.Position = UDim2.new(0, 0, 1, -30)
killGuiBtn.BackgroundColor3 = Color3.fromRGB(28, 16, 20)
killGuiBtn.TextColor3 = C.bad
killGuiBtn.Text = "☠  KILL GUI"
killGuiBtn.Font = Enum.Font.GothamBold
killGuiBtn.TextSize = 10
killGuiBtn.AutoButtonColor = false
killGuiBtn.Parent = content
corner(killGuiBtn, 8)
stroke(killGuiBtn, C.bad, 1, 0.6)

-- ===== DRAG =====
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
hubButton.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = i.Position
        startPos = hubButton.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
hubButton.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then dragInput = i end
end)
UserInputService.InputChanged:Connect(function(i)
    if i == dragInput and dragging then
        local d = i.Position - dragStart
        hubButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
hubButton.MouseButton1Click:Connect(function()
    task.wait(0.05)
    if not dragging then
        hubButton.Visible = false
        mainFrame.Visible = true
    end
end)

local mfDrag, mfInput, mfStart, mfPos = false, nil, nil, nil
titleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        mfDrag = true
        mfStart = i.Position
        mfPos = mainFrame.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then mfDrag = false end
        end)
    end
end)
titleBar.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then mfInput = i end
end)
UserInputService.InputChanged:Connect(function(i)
    if i == mfInput and mfDrag then
        local d = i.Position - mfStart
        mainFrame.Position = UDim2.new(mfPos.X.Scale, mfPos.X.Offset + d.X, mfPos.Y.Scale, mfPos.Y.Offset + d.Y)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

-- ===== HELPERS =====
local function getSword()
    if not myChar then return nil end
    return myChar:FindFirstChildOfClass("Tool")
end

local function equipSword()
    local bp = player:FindFirstChild("Backpack")
    if not myChar or not bp or not myHum then return nil end
    local cur = getSword()
    if cur then return cur end
    for _, item in ipairs(bp:GetChildren()) do
        if item:IsA("Tool") then
            myHum:EquipTool(item)
            return item
        end
    end
    return nil
end

local function applyReach(tool)
    if not opt.reach or not tool then return end
    local h = tool:FindFirstChild("Handle")
    if not h then return end
    reachStore[tool] = reachStore[tool] or h.Size
    if h.Size.Z ~= REACH_SIZE then
        h.Size = Vector3.new(h.Size.X, h.Size.Y, REACH_SIZE)
    end
end

local function bindCharacter(ch)
    myChar = ch
    myRoot = ch and ch:FindFirstChild("HumanoidRootPart")
    myHum = ch and ch:FindFirstChildOfClass("Humanoid")
    lastGoodPos = myRoot and myRoot.Position or nil
    lastHealth = myHum and myHum.Health or 100
end

local function flash()
    frameStroke.Color = C.accent
    frameStroke.Transparency = 0
    TweenService:Create(frameStroke, TweenInfo.new(0.45), { Color = C.stroke }):Play()
end

local function pushSpike(who)
    spikeCount = spikeCount + 1
    spikeLbl.Text = spikeCount .. " blocked"
    spikeLbl.TextColor3 = C.accent
    statusLbl.Text = "BLOCKED · " .. (who or "unknown")
    statusLbl.TextColor3 = C.accent
    flash()
    task.delay(0.9, function()
        if enabled then
            statusLbl.Text = "ACTIVE"
            statusLbl.TextColor3 = C.accent
        end
    end)
end

local function unanchor()
    if myRoot and weAnchored then
        myRoot.Anchored = false
        weAnchored = false
    end
end

local function anchor(duration)
    if not myRoot then return end
    myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    if not weAnchored then
        myRoot.Anchored = true
        weAnchored = true
    end
    autoAnchorUntil = os.clock() + duration
end

local function cacheMotors(ch)
    motorCache = {}
    for _, d in ipairs(ch:GetDescendants()) do
        if d:IsA("Motor6D") and d.Part0 and d.Part1 then
            table.insert(motorCache, {
                name = d.Name, p0 = d.Part0, p1 = d.Part1,
                c0 = d.C0, c1 = d.C1, parent = d.Parent
            })
        end
    end
end

local function repairMotors()
    if not myChar or #motorCache == 0 then return end
    for _, m in ipairs(motorCache) do
        if m.parent and m.parent.Parent and m.p0 and m.p1 and m.p0.Parent and m.p1.Parent then
            local ex = m.parent:FindFirstChild(m.name)
            if not (ex and ex:IsA("Motor6D")) then
                local nm = Instance.new("Motor6D")
                nm.Name = m.name
                nm.Part0 = m.p0
                nm.Part1 = m.p1
                nm.C0 = m.c0
                nm.C1 = m.c1
                nm.Parent = m.parent
            end
        end
    end
end

local function pickAttacker(range)
    if not myRoot then return nil end
    local best, bestDist = nil, range
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 then
                local d = (r.Position - myRoot.Position).Magnitude
                if d < bestDist then
                    best, bestDist = p, d
                end
            end
        end
    end
    return best, bestDist
end

local function fireCounter()
    if not opt.counter or not counterTarget or not myRoot then return end
    local tc = counterTarget.Character
    if not tc then counterTarget = nil return end
    local tRoot = tc:FindFirstChild("HumanoidRootPart")
    local tHum = tc:FindFirstChildOfClass("Humanoid")
    if not tRoot or not tHum or tHum.Health <= 0 then counterTarget = nil return end

    myRoot.CFrame = tRoot.CFrame * CFrame.new(math.random(-1, 1), 0, -2)

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, COUNTER_POWER, 0)
    bv.P = math.huge
    bv.Parent = myRoot

    local av = Instance.new("BodyAngularVelocity")
    av.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    av.AngularVelocity = Vector3.new(COUNTER_POWER, COUNTER_POWER, COUNTER_POWER)
    av.P = math.huge
    av.Parent = myRoot

    task.delay(0.22, function()
        if bv then bv:Destroy() end
        if av then av:Destroy() end
    end)
    counterTarget = nil
end

local function escapeDash()
    if not myRoot or not lastGoodPos then return end
    local dir = (myRoot.Position - lastGoodPos)
    if dir.Magnitude < 0.5 then dir = Vector3.new(0, 0, 1) else dir = dir.Unit end
    myRoot.CFrame = CFrame.new(lastGoodPos + dir * DASH_DIST + Vector3.new(0, 14, 0))
    myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    lastGoodPos = myRoot.Position
end

-- ===== CORE =====
local function onHeartbeat()
    if not enabled then return end
    if not myChar or not myRoot or not myRoot.Parent then
        bindCharacter(player.Character)
        if not myRoot then return end
    end
    if not myHum or not myHum.Parent or myHum.Health <= 0 then
        unanchor()
        return
    end

    local now = os.clock()

    -- sword guard: heal
    if opt.autoHeal and myHum.Health < myHum.MaxHealth and now >= nextHealAt then
        nextHealAt = now + HEAL_DELAY
        myHum.Health = myHum.MaxHealth
    end

    -- sword guard: reach upkeep
    if opt.reach then
        local tool = getSword()
        if not tool then tool = equipSword() end
        if tool then applyReach(tool) end
    end

    -- sword guard: auto swing
    if opt.autoSwing and now >= nextSwingAt then
        nextSwingAt = now + SWING_COOLDOWN
        local tool = getSword()
        if not tool then tool = equipSword() end
        if tool then
            local target, dist = pickAttacker(SWING_RANGE)
            if target and dist then
                tool:Activate()
            end
        end
    end

    -- damage detection -> dash
    if myHum.Health < lastHealth - DAMAGE_TRIGGER then
        if opt.dash and now >= nextDashAt and not weAnchored then
            nextDashAt = now + DASH_COOLDOWN
            escapeDash()
        end
    end
    lastHealth = myHum.Health

    if opt.massArmor and not myRoot.CustomPhysicalProperties then
        myRoot.CustomPhysicalProperties = PhysicalProperties.new(MASS_ARMOR, 0.5, 0.5)
    end
    if myRoot.Massless then myRoot.Massless = false end

    local pos = myRoot.Position
    local vel = myRoot.AssemblyLinearVelocity
    local speed = vel.Magnitude

    if not lastGoodPos then lastGoodPos = pos end

    if now >= nextSpikeAt and not lockOn then
        local step = (pos - lastGoodPos).Magnitude
        local isFling = speed > MAX_SPEED
        local isTeleport = step > MAX_STEP and speed <= MAX_SPEED * 0.5

        if isFling or (step > MAX_STEP and not isTeleport) then
            nextSpikeAt = now + SPIKE_COOLDOWN
            counterTarget = pickAttacker(COUNTER_RANGE)
            pushSpike(counterTarget and counterTarget.Name)

            if opt.restore and lastGoodPos then
                myRoot.CFrame = CFrame.new(lastGoodPos)
            end

            if opt.autoAnchor then
                anchor(ANCHOR_TIME)
            else
                local dir = speed > 0 and vel.Unit or Vector3.new(0, 1, 0)
                myRoot.AssemblyLinearVelocity = dir * math.min(speed, MAX_SPEED)
                myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        elseif isTeleport then
            lastGoodPos = pos
        end
    end

    if opt.voidRescue and lastGoodPos then
        if pos.Y < lastGoodPos.Y - 220 or pos.Y < -120 then
            myRoot.CFrame = CFrame.new(lastGoodPos)
            myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            if not weAnchored then anchor(ANCHOR_TIME) end
        end
    end

    if weAnchored and not lockOn and now >= autoAnchorUntil then
        unanchor()
        fireCounter()
    end

    if opt.clamp and not weAnchored then
        local v = myRoot.AssemblyLinearVelocity
        if v.Magnitude > MAX_SPEED then
            myRoot.AssemblyLinearVelocity = v.Unit * MAX_SPEED
            myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end

    if now >= nextRepairAt then
        nextRepairAt = now + REPAIR_EVERY
        repairMotors()
        if myHum:GetState() == Enum.HumanoidStateType.Physics and not weAnchored then
            myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end

    if not weAnchored then
        lastGoodPos = myRoot.Position
    end
end

local function start()
    if loop then return end
    loop = RunService.Heartbeat:Connect(function()
        local ok, err = pcall(onHeartbeat)
        if not ok then warn("[AEGIS] " .. tostring(err)) end
    end)
end

task.spawn(function()
    while screenGui.Parent do
        task.wait(0.4)
        if enabled and not loop then start() end
    end
end)

-- ===== VISUALS =====
RunService.RenderStepped:Connect(function()
    local t = os.clock()
    accentGrad.Offset = Vector2.new(math.sin(t * 0.7) * 0.6, 0)
    if enabled then
        statusDot.BackgroundTransparency = 0.1 + math.abs(math.sin(t * 5)) * 0.6
        hubStroke.Transparency = 0.1 + math.abs(math.sin(t * 5)) * 0.5
    else
        hubStroke.Transparency = 0.35
    end
end)

-- ===== TOGGLES =====
lockBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    bindCharacter(player.Character)

    if enabled then
        lockBtn.Text = "SHIELD ACTIVE"
        lockBtn.TextColor3 = C.accent
        TweenService:Create(lockBtn, TweenInfo.new(0.2), { BackgroundColor3 = C.cardOn }):Play()
        TweenService:Create(lockGrad, TweenInfo.new(0.2), {
            Color = ColorSequence.new(Color3.fromRGB(18, 62, 46), Color3.fromRGB(14, 44, 33))
        }):Play()
        lockStroke.Color = C.accent
        statusLbl.Text = "ACTIVE"
        statusLbl.TextColor3 = C.accent
        statusDot.BackgroundColor3 = C.accent
        if myChar then
            cacheMotors(myChar)
            if myRoot and opt.massArmor then
                myRoot.CustomPhysicalProperties = PhysicalProperties.new(MASS_ARMOR, 0.5, 0.5)
            end
        end
        nextSpikeAt = 0
        nextRepairAt = 0
        nextHealAt = 0
        nextSwingAt = 0
        start()
    else
        lockBtn.Text = "ENABLE SHIELD"
        lockBtn.TextColor3 = C.text
        TweenService:Create(lockBtn, TweenInfo.new(0.2), { BackgroundColor3 = C.card }):Play()
        TweenService:Create(lockGrad, TweenInfo.new(0.2), {
            Color = ColorSequence.new(Color3.fromRGB(30, 34, 32), Color3.fromRGB(24, 27, 25))
        }):Play()
        lockStroke.Color = C.bad
        statusLbl.Text = "OFFLINE"
        statusLbl.TextColor3 = C.dim
        statusDot.BackgroundColor3 = C.dim
        lockOn = false
        unanchor()
        if loop then loop:Disconnect() loop = nil end
        local tool = getSword()
        if tool then
            local h = tool:FindFirstChild("Handle")
            if h and reachStore[tool] then h.Size = reachStore[tool] end
        end
        if myRoot then
            myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            myRoot.CustomPhysicalProperties = nil
        end
        lastGoodPos = nil
    end
end)

testBtn.MouseButton1Click:Connect(function()
    if not enabled then
        statusLbl.Text = "ENABLE FIRST"
        statusLbl.TextColor3 = C.bad
        return
    end
    bindCharacter(player.Character)
    if not myRoot then return end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(math.random(-3000, 3000), 9000, math.random(-3000, 3000))
    bv.P = math.huge
    bv.Parent = myRoot
    task.delay(0.25, function()
        if bv then bv:Destroy() end
    end)
end)

killGuiBtn.MouseButton1Click:Connect(function()
    enabled = false
    if loop then loop:Disconnect() loop = nil end
    unanchor()
    if myRoot then myRoot.CustomPhysicalProperties = nil end
    screenGui:Destroy()
end)

-- ===== LIFE CYCLE =====
player.CharacterAdded:Connect(function(ch)
    weAnchored = false
    bindCharacter(ch)
    task.wait(0.3)
    if enabled then
        bindCharacter(player.Character)
        if myChar then cacheMotors(myChar) end
        if myRoot and opt.massArmor then
            myRoot.CustomPhysicalProperties = PhysicalProperties.new(MASS_ARMOR, 0.5, 0.5)
        end
        if not loop then start() end
    end
end)

player.CharacterRemoving:Connect(function()
    weAnchored = false
    lastGoodPos = nil
end)

print("[ AEGIS ] loaded")
