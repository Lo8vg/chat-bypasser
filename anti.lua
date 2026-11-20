-- FAGGOT KILLER  //  AEGIS  v1

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- tuning
local MAX_SPEED = 120        -- studs/sec before it counts as a fling
local MAX_STEP = 30          -- studs in a single frame before it counts as a teleport
local ANCHOR_TIME = 0.14     -- how long the auto-lock holds
local COUNTER_POWER = 4200   -- return-to-sender burst
local COUNTER_RANGE = 10
local MASS_ARMOR = 100

-- states
local enabled = false
local lockOn = false
local opt = {
    clamp = true,
    restore = true,
    autoAnchor = true,
    voidRescue = true,
    massArmor = true,
    counter = false
}

local spikeCount = 0
local autoAnchorUntil = 0
local weAnchored = false
local lastGoodPos = nil
local counterTarget = nil
local loop = nil
local motorCache = {}

local C = {
    bg = Color3.fromRGB(13, 15, 14),
    panel = Color3.fromRGB(21, 24, 22),
    card = Color3.fromRGB(26, 30, 28),
    cardOn = Color3.fromRGB(11, 40, 30),
    stroke = Color3.fromRGB(36, 42, 39),
    accent = Color3.fromRGB(64, 255, 160),
    accent2 = Color3.fromRGB(0, 190, 255),
    good = Color3.fromRGB(64, 255, 160),
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
mainFrame.Size = UDim2.new(0, 344, 0, 412)
mainFrame.Position = UDim2.new(0.5, -172, 0.5, -206)
mainFrame.BackgroundColor3 = C.bg
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
corner(mainFrame, 14)
stroke(mainFrame, C.stroke, 1)
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
title.Size = UDim2.new(1, -140, 0, 18)
title.Position = UDim2.new(0, 16, 0, 9)
title.BackgroundTransparency = 1
title.TextColor3 = C.text
title.Text = "AEGIS"
title.Font = Enum.Font.GothamBlack
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -140, 0, 12)
subtitle.Position = UDim2.new(0, 16, 0, 26)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = C.dim
subtitle.Text = "anti-fling shield · v1"
subtitle.Font = Enum.Font.Code
subtitle.TextSize = 9
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = titleBar

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
statusLbl.Size = UDim2.new(0, 140, 0, 20)
statusLbl.Position = UDim2.new(0, 13, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3 = C.dim
statusLbl.Text = "OFFLINE"
statusLbl.Font = Enum.Font.Code
statusLbl.TextSize = 10
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Parent = content

local spikeLbl = Instance.new("TextLabel")
spikeLbl.Size = UDim2.new(0, 110, 0, 20)
spikeLbl.Position = UDim2.new(1, -110, 0, 0)
spikeLbl.BackgroundTransparency = 1
spikeLbl.TextColor3 = C.dim
spikeLbl.Text = "0 blocked"
spikeLbl.Font = Enum.Font.Code
spikeLbl.TextSize = 10
spikeLbl.TextXAlignment = Enum.TextXAlignment.Right
spikeLbl.Parent = content

-- LOCK
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

-- rows
local function makeRow(y, label, key, onChange)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 28)
    row.Position = UDim2.new(0, 0, 0, y)
    row.BackgroundTransparency = 1
    row.Parent = content

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -56, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = C.muted
    lbl.Text = label
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local sw = Instance.new("TextButton")
    sw.Size = UDim2.new(0, 40, 0, 20)
    sw.Position = UDim2.new(1, -40, 0, 4)
    sw.BackgroundColor3 = opt[key] and C.cardOn or C.card
    sw.Text = ""
    sw.AutoButtonColor = false
    sw.Parent = row
    corner(sw, 10)
    local swStroke = stroke(sw, opt[key] and C.accent or C.stroke, 1, opt[key] and 0.45 or 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = opt[key] and UDim2.new(0, 21, 0, 2) or UDim2.new(0, 3, 0, 2)
    knob.BackgroundColor3 = opt[key] and C.accent or C.dim
    knob.BorderSizePixel = 0
    knob.Parent = sw
    corner(knob, 8)

    local function paint()
        TweenService:Create(knob, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
            Position = opt[key] and UDim2.new(0, 21, 0, 2) or UDim2.new(0, 3, 0, 2),
            BackgroundColor3 = opt[key] and C.accent or C.dim
        }):Play()
        TweenService:Create(sw, TweenInfo.new(0.16), {
            BackgroundColor3 = opt[key] and C.cardOn or C.card
        }):Play()
        swStroke.Color = opt[key] and C.accent or C.stroke
        swStroke.Transparency = opt[key] and 0.45 or 0
        lbl.TextColor3 = opt[key] and C.text or C.muted
    end

    sw.MouseButton1Click:Connect(function()
        opt[key] = not opt[key]
        paint()
        if onChange then onChange(opt[key]) end
    end)

    return row
end

local secLbl = Instance.new("TextLabel")
secLbl.Size = UDim2.new(1, 0, 0, 14)
secLbl.Position = UDim2.new(0, 0, 0, 76)
secLbl.BackgroundTransparency = 1
secLbl.TextColor3 = C.dim
secLbl.Text = "LAYERS"
secLbl.Font = Enum.Font.Code
secLbl.TextSize = 9
secLbl.TextXAlignment = Enum.TextXAlignment.Left
secLbl.Parent = content

makeRow(92, "velocity clamp", "clamp")
makeRow(120, "position restore", "restore")
makeRow(148, "auto-lock on hit", "autoAnchor")
makeRow(176, "void rescue", "voidRescue")
makeRow(204, "mass armor", "massArmor", function(on)
    local ch = player.Character
    if not ch then return end
    local r = ch:FindFirstChild("HumanoidRootPart")
    if not r then return end
    if on and enabled then
        r.CustomPhysicalProperties = PhysicalProperties.new(MASS_ARMOR, 0.5, 0.5)
    else
        r.CustomPhysicalProperties = nil
    end
end)
makeRow(232, "counter-fling", "counter")

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
local function getRoot(ch)
    if not ch then return nil end
    return ch:FindFirstChild("HumanoidRootPart")
end

local function getHum(ch)
    if not ch then return nil end
    return ch:FindFirstChildOfClass("Humanoid")
end

local function setStatus(txt, col, pulse)
    statusLbl.Text = txt
    statusLbl.TextColor3 = col
    statusDot.BackgroundColor3 = col
    statusDot.BackgroundTransparency = pulse and 0 or 0.55
end

local function pushSpike()
    spikeCount = spikeCount + 1
    spikeLbl.Text = spikeCount .. " blocked"
    spikeLbl.TextColor3 = C.accent
end

local function unanchor(root)
    if root and weAnchored then
        root.Anchored = false
        weAnchored = false
    end
end

local function anchor(root, duration)
    if not root then return end
    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    root.Anchored = true
    weAnchored = true
    autoAnchorUntil = tick() + duration
end

-- ===== JOINT REPAIR =====
local function cacheMotors(ch)
    motorCache = {}
    for _, d in ipairs(ch:GetDescendants()) do
        if d:IsA("Motor6D") then
            table.insert(motorCache, {
                name = d.Name, p0 = d.Part0, p1 = d.Part1,
                c0 = d.C0, c1 = d.C1, parent = d.Parent
            })
        end
    end
end

local function repairMotors(ch)
    for _, m in ipairs(motorCache) do
        if m.p0 and m.p1 and m.p0.Parent and m.p1.Parent then
            local existing = m.parent and m.parent:FindFirstChild(m.name)
            if not (existing and existing:IsA("Motor6D")) then
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

-- ===== COUNTER =====
local function pickAttacker(myRoot)
    local best, bestDist = nil, COUNTER_RANGE
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local r = getRoot(p.Character)
            local h = getHum(p.Character)
            if r and h and h.Health > 0 then
                local d = (r.Position - myRoot.Position).Magnitude
                if d < bestDist then
                    best, bestDist = p, d
                end
            end
        end
    end
    return best
end

local function fireCounter()
    if not opt.counter or not counterTarget then return end
    local ch = player.Character
    local myRoot = getRoot(ch)
    if not myRoot or not counterTarget.Character then return end
    local tRoot = getRoot(counterTarget.Character)
    local tHum = getHum(counterTarget.Character)
    if not tRoot or not tHum or tHum.Health <= 0 then return end

    myRoot.CFrame = tRoot.CFrame * CFrame.new(math.random(-1, 1), 0, math.random(-2, -1))

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = (tRoot.Position - myRoot.Position).Unit * COUNTER_POWER + Vector3.new(0, COUNTER_POWER, 0)
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

-- ===== CORE LOOP =====
local function tick(dt)
    if not enabled then return end
    local ch = player.Character
    if not ch then return end
    local root = getRoot(ch)
    local hum = getHum(ch)
    if not root or not hum or hum.Health <= 0 then
        unanchor(root)
        lastGoodPos = nil
        return
    end

    -- ownership + armor upkeep
    if opt.massArmor and not root.CustomPhysicalProperties then
        root.CustomPhysicalProperties = PhysicalProperties.new(MASS_ARMOR, 0.5, 0.5)
    end
    root.Massless = false

    local pos = root.Position
    local vel = root.AssemblyLinearVelocity
    local speed = vel.Magnitude

    -- keep last known good position
    if not lastGoodPos then
        lastGoodPos = pos
    end

    local step = (pos - lastGoodPos).Magnitude
    local spiked = false

    if speed > MAX_SPEED or step > MAX_STEP then
        -- high velocity = real fling. low velocity + far jump = legit teleport
        local isFling = speed > MAX_SPEED or (step > MAX_STEP and speed > MAX_SPEED * 0.5)
        local isLegitTeleport = step > MAX_STEP and speed <= MAX_SPEED * 0.5

        if isFling then
            spiked = true
            pushSpike()
            counterTarget = pickAttacker(root)

            if opt.restore and lastGoodPos then
                root.CFrame = CFrame.new(lastGoodPos) * (root.CFrame - root.CFrame.Position)
            end

            if opt.autoAnchor then
                anchor(root, ANCHOR_TIME)
            elseif opt.clamp then
                local dir = speed > 0 and vel.Unit or Vector3.new(0, 1, 0)
                root.AssemblyLinearVelocity = dir * math.min(speed, MAX_SPEED)
                root.AssemblyAngularVelocity = root.AssemblyAngularVelocity.Unit * 0
            end
        elseif isLegitTeleport then
            lastGoodPos = pos
        end
    end

    -- void rescue
    if opt.voidRescue and lastGoodPos then
        if pos.Y < lastGoodPos.Y - 220 or pos.Y < -120 then
            root.CFrame = CFrame.new(lastGoodPos)
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            if not weAnchored then anchor(root, ANCHOR_TIME) end
        end
    end

    -- release our own anchor
    if weAnchored and tick() >= autoAnchorUntil and not lockOn then
        unanchor(root)
        if opt.counter and counterTarget then fireCounter() end
    end

    -- joint repair (cheap check)
    if math.random() < 0.25 then repairMotors(ch) end
    if hum:GetState() == Enum.HumanoidStateType.Physics and not weAnchored then
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end

    if not weAnchored then
        lastGoodPos = root.Position
    end

    -- passive clamp
    if opt.clamp and not weAnchored and root.AssemblyLinearVelocity.Magnitude > MAX_SPEED then
        local v = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = v.Unit * MAX_SPEED
        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end

local function start()
    if loop then return end
    loop = RunService.Heartbeat:Connect(function(dt)
        pcall(tick, dt)
    end)
end

-- watchdog
task.spawn(function()
    while screenGui.Parent do
        task.wait(0.4)
        if enabled and not loop then start() end
    end
end)

-- ===== VISUALS =====
RunService.RenderStepped:Connect(function()
    local t = tick()
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
    local ch = player.Character
    local root = getRoot(ch)

    if enabled then
        lockBtn.Text = "SHIELD ACTIVE"
        lockBtn.TextColor3 = C.accent
        TweenService:Create(lockBtn, TweenInfo.new(0.2), { BackgroundColor3 = C.cardOn }):Play()
        TweenService:Create(lockGrad, TweenInfo.new(0.2), {
            Color = ColorSequence.new(Color3.fromRGB(18, 62, 46), Color3.fromRGB(14, 44, 33))
        }):Play()
        lockStroke.Color = C.accent
        setStatus("ACTIVE", C.accent, true)
        if ch then
            cacheMotors(ch)
            if root then
                lastGoodPos = root.Position
                if opt.massArmor then
                    root.CustomPhysicalProperties = PhysicalProperties.new(MASS_ARMOR, 0.5, 0.5)
                end
            end
        end
        start()
    else
        lockBtn.Text = "ENABLE SHIELD"
        lockBtn.TextColor3 = C.text
        TweenService:Create(lockBtn, TweenInfo.new(0.2), { BackgroundColor3 = C.card }):Play()
        TweenService:Create(lockGrad, TweenInfo.new(0.2), {
            Color = ColorSequence.new(Color3.fromRGB(30, 34, 32), Color3.fromRGB(24, 27, 25))
        }):Play()
        lockStroke.Color = C.bad
        setStatus("OFFLINE", C.dim, false)
        lockOn = false
        unanchor(root)
        if loop then loop:Disconnect() loop = nil end
        if root then
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            root.CustomPhysicalProperties = nil
        end
        lastGoodPos = nil
    end
end)

killGuiBtn.MouseButton1Click:Connect(function()
    enabled = false
    if loop then loop:Disconnect() loop = nil end
    local root = getRoot(player.Character)
    unanchor(root)
    if root then root.CustomPhysicalProperties = nil end
    screenGui:Destroy()
end)

-- ===== LIFE CYCLE =====
player.CharacterAdded:Connect(function(ch)
    weAnchored = false
    lastGoodPos = nil
    task.wait(0.3)
    if enabled then
        cacheMotors(ch)
        local r = getRoot(ch)
        if r then
            lastGoodPos = r.Position
            if opt.massArmor then
                r.CustomPhysicalProperties = PhysicalProperties.new(MASS_ARMOR, 0.5, 0.5)
            end
        end
        if not loop then start() end
    end
end)

player.CharacterRemoving:Connect(function()
    weAnchored = false
    lastGoodPos = nil
end)

print("[ AEGIS ] loaded")
