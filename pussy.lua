-- FAGGOT KILLER  //  v2

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local destroyEnabled = false
local targetPlayer = nil
local velocityPower = 999999
local angularPower = 999999
local flingLoop = nil
local bodyVel = nil
local bodyAngVel = nil

-- MULTI
local multiEnabled = false
local multiTargets = {}
local multiIndex = 1
local MULTI_INTERVAL = 0.08
local flingAccum = 0

local C = {
    bg = Color3.fromRGB(14, 15, 18),
    panel = Color3.fromRGB(21, 23, 28),
    card = Color3.fromRGB(26, 29, 36),
    cardSel = Color3.fromRGB(10, 36, 43),
    stroke = Color3.fromRGB(36, 40, 51),
    accent = Color3.fromRGB(0, 225, 255),
    accent2 = Color3.fromRGB(122, 92, 255),
    good = Color3.fromRGB(36, 224, 138),
    bad = Color3.fromRGB(255, 59, 92),
    text = Color3.fromRGB(232, 236, 242),
    muted = Color3.fromRGB(124, 134, 152),
    dim = Color3.fromRGB(74, 82, 96)
}

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
    return c
end

local function stroke(obj, col, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = col
    s.Thickness = thick or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function gradient(obj, a, b, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(a, b)
    g.Rotation = rot or 0
    g.Parent = obj
    return g
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FaggotKillerHub"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ============ HUB BUTTON ============
local hubButton = Instance.new("TextButton")
hubButton.Name = "HubButton"
hubButton.Size = UDim2.new(0, 54, 0, 54)
hubButton.Position = UDim2.new(0, 16, 0.5, -27)
hubButton.BackgroundColor3 = C.panel
hubButton.BorderSizePixel = 0
hubButton.Text = "⚡"
hubButton.TextColor3 = C.accent
hubButton.Font = Enum.Font.GothamBlack
hubButton.TextSize = 22
hubButton.AutoButtonColor = false
hubButton.Parent = screenGui
corner(hubButton, 27)
local hubStroke = stroke(hubButton, C.accent, 1.5, 0.35)
local hubGlow = Instance.new("Frame")
hubGlow.Size = UDim2.new(1, 12, 1, 12)
hubGlow.Position = UDim2.new(0, -6, 0, -6)
hubGlow.BackgroundColor3 = C.accent
hubGlow.BackgroundTransparency = 0.88
hubGlow.BorderSizePixel = 0
hubGlow.ZIndex = 0
hubGlow.Parent = hubButton
corner(hubGlow, 33)

-- ============ MAIN PANEL ============
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 344, 0, 434)
mainFrame.Position = UDim2.new(0.5, -172, 0.5, -217)
mainFrame.BackgroundColor3 = C.bg
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
corner(mainFrame, 14)
stroke(mainFrame, C.stroke, 1)

local bgGrad = gradient(mainFrame, Color3.fromRGB(19, 21, 26), C.bg, 90)

-- accent bar
local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(1, 0, 0, 3)
accentBar.BackgroundColor3 = C.accent
accentBar.BorderSizePixel = 0
accentBar.Parent = mainFrame
local accentGrad = gradient(accentBar, C.accent, C.accent2, 0)

-- title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -140, 0, 18)
title.Position = UDim2.new(0, 16, 0, 9)
title.BackgroundTransparency = 1
title.TextColor3 = C.text
title.Text = "FAGGOT KILLER"
title.Font = Enum.Font.GothamBlack
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -140, 0, 12)
subtitle.Position = UDim2.new(0, 16, 0, 26)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = C.dim
subtitle.Text = "fling suite · v2"
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

-- content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -32, 1, -98)
content.Position = UDim2.new(0, 16, 0, 52)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- status row
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 6, 0, 6)
statusDot.Position = UDim2.new(0, 1, 0, 7)
statusDot.BackgroundColor3 = C.dim
statusDot.BorderSizePixel = 0
statusDot.Parent = content
corner(statusDot, 3)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(0, 120, 0, 20)
statusLbl.Position = UDim2.new(0, 13, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3 = C.dim
statusLbl.Text = "IDLE"
statusLbl.Font = Enum.Font.Code
statusLbl.TextSize = 10
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Parent = content

local countChip = Instance.new("TextLabel")
countChip.Size = UDim2.new(0, 96, 0, 20)
countChip.Position = UDim2.new(1, -96, 0, 0)
countChip.BackgroundTransparency = 1
countChip.TextColor3 = C.dim
countChip.Text = "no target"
countChip.Font = Enum.Font.Code
countChip.TextSize = 10
countChip.TextXAlignment = Enum.TextXAlignment.Right
countChip.Parent = content

-- main toggle
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 0, 42)
toggleBtn.Position = UDim2.new(0, 0, 0, 26)
toggleBtn.BackgroundColor3 = C.card
toggleBtn.TextColor3 = C.text
toggleBtn.Text = "ENGAGE"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = content
corner(toggleBtn, 9)
local togStroke = stroke(toggleBtn, C.bad, 1, 0.55)
local togGrad = gradient(toggleBtn, Color3.fromRGB(30, 34, 42), Color3.fromRGB(24, 27, 33), 90)

-- multi row
local multiRow = Instance.new("Frame")
multiRow.Size = UDim2.new(1, 0, 0, 30)
multiRow.Position = UDim2.new(0, 0, 0, 76)
multiRow.BackgroundTransparency = 1
multiRow.Parent = content

local multiLbl = Instance.new("TextLabel")
multiLbl.Size = UDim2.new(0, 160, 1, 0)
multiLbl.BackgroundTransparency = 1
multiLbl.TextColor3 = C.muted
multiLbl.Text = "MULTI"
multiLbl.Font = Enum.Font.Code
multiLbl.TextSize = 10
multiLbl.TextXAlignment = Enum.TextXAlignment.Left
multiLbl.Parent = multiRow

local multiBtn = Instance.new("TextButton")
multiBtn.Size = UDim2.new(0, 118, 0, 24)
multiBtn.Position = UDim2.new(1, -118, 0, 3)
multiBtn.BackgroundColor3 = C.card
multiBtn.TextColor3 = C.muted
multiBtn.Text = "OFF"
multiBtn.Font = Enum.Font.Code
multiBtn.TextSize = 10
multiBtn.AutoButtonColor = false
multiBtn.Parent = multiRow
corner(multiBtn, 12)
local multiStroke = stroke(multiBtn, C.stroke, 1)

local multiKnob = Instance.new("Frame")
multiKnob.Size = UDim2.new(0, 18, 0, 18)
multiKnob.Position = UDim2.new(0, 3, 0, 3)
multiKnob.BackgroundColor3 = C.dim
multiKnob.BorderSizePixel = 0
multiKnob.Parent = multiBtn
corner(multiKnob, 9)

-- section header
local secRow = Instance.new("Frame")
secRow.Size = UDim2.new(1, 0, 0, 16)
secRow.Position = UDim2.new(0, 0, 0, 114)
secRow.BackgroundTransparency = 1
secRow.Parent = content

local secLbl = Instance.new("TextLabel")
secLbl.Size = UDim2.new(1, -60, 1, 0)
secLbl.BackgroundTransparency = 1
secLbl.TextColor3 = C.dim
secLbl.Text = "TARGETS"
secLbl.Font = Enum.Font.Code
secLbl.TextSize = 9
secLbl.TextXAlignment = Enum.TextXAlignment.Left
secLbl.Parent = secRow

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 56, 0, 16)
clearBtn.Position = UDim2.new(1, -56, 0, 0)
clearBtn.BackgroundColor3 = C.card
clearBtn.TextColor3 = C.muted
clearBtn.Text = "CLEAR"
clearBtn.Font = Enum.Font.Code
clearBtn.TextSize = 9
clearBtn.AutoButtonColor = false
clearBtn.Parent = secRow
corner(clearBtn, 4)

-- player list
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, 0, 0, 158)
playerList.Position = UDim2.new(0, 0, 0, 134)
playerList.BackgroundColor3 = C.panel
playerList.BorderSizePixel = 0
playerList.ScrollBarThickness = 3
playerList.ScrollBarImageColor3 = C.stroke
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.Parent = content
corner(playerList, 9)
stroke(playerList, C.stroke, 1)
local plLayout = Instance.new("UIListLayout")
plLayout.Padding = UDim.new(0, 4)
plLayout.Parent = playerList
local plPad = Instance.new("UIPadding")
plPad.PaddingTop = UDim.new(0, 6)
plPad.PaddingLeft = UDim.new(0, 6)
plPad.PaddingRight = UDim.new(0, 6)
plPad.Parent = playerList

local emptyLbl = Instance.new("TextLabel")
emptyLbl.Size = UDim2.new(1, -12, 0, 30)
emptyLbl.Position = UDim2.new(0, 6, 0, 60)
emptyLbl.BackgroundTransparency = 1
emptyLbl.TextColor3 = C.dim
emptyLbl.Text = "waiting for players..."
emptyLbl.Font = Enum.Font.Code
emptyLbl.TextSize = 10
emptyLbl.Parent = playerList

-- footer
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

-- ============ DRAG: HUB ============
local dragging = false
local dragInput, dragStart, startPos

hubButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = hubButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
hubButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local d = input.Position - dragStart
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

-- ============ DRAG: PANEL ============
local mfDragging = false
local mfDragInput, mfDragStart, mfDragPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mfDragging = true
        mfDragStart = input.Position
        mfDragPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then mfDragging = false end
        end)
    end
end)
titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        mfDragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == mfDragInput and mfDragging then
        local d = input.Position - mfDragStart
        mainFrame.Position = UDim2.new(mfDragPos.X.Scale, mfDragPos.X.Offset + d.X, mfDragPos.Y.Scale, mfDragPos.Y.Offset + d.Y)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    hubButton.Visible = true
end)

-- ============ VISUALS ============
local statusTween
local function setStatus(text, col, pulsing)
    statusLbl.Text = text
    statusLbl.TextColor3 = col
    statusDot.BackgroundColor3 = col
    if statusTween then statusTween:Cancel() end
    statusTween = TweenService:Create(statusDot, TweenInfo.new(0.25), { BackgroundTransparency = pulsing and 0 or 0.55 })
end

RunService.RenderStepped:Connect(function()
    local t = tick()
    accentGrad.Offset = Vector2.new(math.sin(t * 0.7) * 0.6, 0)
    if destroyEnabled then
        statusDot.BackgroundTransparency = 0.15 + math.abs(math.sin(t * 4)) * 0.6
        hubStroke.Transparency = 0.1 + math.abs(math.sin(t * 4)) * 0.5
    else
        hubStroke.Transparency = 0.35
    end
end)

-- ============ KILL GUI ============
killGuiBtn.MouseButton1Click:Connect(function()
    destroyEnabled = false
    if flingLoop then flingLoop:Disconnect() flingLoop = nil end
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
    if bodyAngVel then bodyAngVel:Destroy() bodyAngVel = nil end
    screenGui:Destroy()
end)

-- ============ LIST ============
local playerButtons = {}

local function inMulti(plr)
    return table.find(multiTargets, plr) ~= nil
end

local function refreshMeta()
    if multiEnabled then
        countChip.Text = #multiTargets .. " queued"
        countChip.TextColor3 = #multiTargets > 0 and C.accent or C.dim
    else
        countChip.Text = targetPlayer and targetPlayer.Name or "no target"
        countChip.TextColor3 = targetPlayer and C.accent or C.dim
    end
    emptyLbl.Visible = (#playerButtons == 0)
end

local function updatePlayerList()
    for _, b in pairs(playerButtons) do b:Destroy() end
    playerButtons = {}

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local sel = multiEnabled and inMulti(plr) or (not multiEnabled and targetPlayer == plr)

            local card = Instance.new("TextButton")
            card.Size = UDim2.new(1, 0, 0, 34)
            card.BackgroundColor3 = sel and C.cardSel or C.card
            card.Text = ""
            card.AutoButtonColor = false
            card.Parent = playerList
            corner(card, 7)
            local cs = stroke(card, sel and C.accent or C.stroke, 1, sel and 0.4 or 0.2)

            if sel then
                local bar = Instance.new("Frame")
                bar.Size = UDim2.new(0, 2, 0, 18)
                bar.Position = UDim2.new(0, 0, 0.5, -9)
                bar.BackgroundColor3 = C.accent
                bar.BorderSizePixel = 0
                bar.Parent = card
                corner(bar, 1)
            end

            local av = Instance.new("ImageLabel")
            av.Size = UDim2.new(0, 26, 0, 26)
            av.Position = UDim2.new(0, 6, 0.5, -13)
            av.BackgroundColor3 = C.panel
            av.BorderSizePixel = 0
            av.Image = ""
            av.Parent = card
            corner(av, 6)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(1, -80, 1, 0)
            nameLbl.Position = UDim2.new(0, 40, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.TextColor3 = sel and C.text or C.muted
            nameLbl.Text = plr.Name
            nameLbl.Font = Enum.Font.GothamMedium
            nameLbl.TextSize = 11
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nameLbl.Parent = card

            local mark = Instance.new("TextLabel")
            mark.Size = UDim2.new(0, 26, 1, 0)
            mark.Position = UDim2.new(1, -30, 0, 0)
            mark.BackgroundTransparency = 1
            mark.TextColor3 = sel and C.accent or C.dim
            mark.Text = multiEnabled and (sel and "✓" or "+") or (sel and "◉" or "")
            mark.Font = Enum.Font.GothamBold
            mark.TextSize = 12
            mark.Parent = card

            task.spawn(function()
                local ok, img = pcall(function()
                    return Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                end)
                if ok and av.Parent then av.Image = img end
            end)

            card.MouseButton1Click:Connect(function()
                if multiEnabled then
                    local idx = table.find(multiTargets, plr)
                    if idx then
                        table.remove(multiTargets, idx)
                    else
                        table.insert(multiTargets, plr)
                    end
                    if multiIndex > #multiTargets then multiIndex = 1 end
                else
                    targetPlayer = plr
                end
                updatePlayerList()
            end)

            table.insert(playerButtons, card)
        end
    end

    playerList.CanvasSize = UDim2.new(0, 0, 0, plLayout.AbsoluteContentSize.Y + 12)
    refreshMeta()
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function(plr)
    local idx = table.find(multiTargets, plr)
    if idx then
        table.remove(multiTargets, idx)
        if multiIndex > #multiTargets then multiIndex = 1 end
    end
    if targetPlayer == plr then targetPlayer = nil end
    task.wait(0.4)
    updatePlayerList()
end)
updatePlayerList()

clearBtn.MouseButton1Click:Connect(function()
    table.clear(multiTargets)
    multiIndex = 1
    targetPlayer = nil
    updatePlayerList()
end)

-- ============ PHYSICS ============
local function getRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function getSword()
    local ch = player.Character
    if not ch then return nil end
    for _, item in pairs(ch:GetChildren()) do
        if item:IsA("Tool") then return item end
    end
    return nil
end

local function equipSword()
    local ch = player.Character
    local bp = player:FindFirstChild("Backpack")
    if not ch or not bp then return nil end
    local cur = getSword()
    if cur then return cur end
    local hum = ch:FindFirstChild("Humanoid")
    if not hum then return nil end
    for _, item in pairs(bp:GetChildren()) do
        if item:IsA("Tool") then
            hum:EquipTool(item)
            return item
        end
    end
    return nil
end

local function boostMass(char)
    local r = getRoot(char)
    if r then r.CustomPhysicalProperties = PhysicalProperties.new(100, 0.5, 0.5) end
end

local function resetMass(char)
    local r = getRoot(char)
    if r then r.CustomPhysicalProperties = nil end
end

local function devastateFling(targetRoot, myRoot, myHumanoid)
    boostMass(player.Character)
    myRoot.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))

    if bodyVel then bodyVel:Destroy() end
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Name = "CollisionBurst"
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Velocity = Vector3.new(math.random(-1, 1) * velocityPower, velocityPower, math.random(-1, 1) * velocityPower)
    bodyVel.P = math.huge
    bodyVel.Parent = myRoot

    if bodyAngVel then bodyAngVel:Destroy() end
    bodyAngVel = Instance.new("BodyAngularVelocity")
    bodyAngVel.Name = "CollisionSpin"
    bodyAngVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyAngVel.AngularVelocity = Vector3.new(angularPower, angularPower, angularPower)
    bodyAngVel.P = math.huge
    bodyAngVel.Parent = myRoot

    if myHumanoid then myHumanoid.PlatformStand = true end
end

local function swordAttack(targetRoot, myRoot)
    local sword = getSword()
    if not sword then
        sword = equipSword()
        if not sword then return end
    end
    if (targetRoot.Position - myRoot.Position).Magnitude <= 15 then
        sword:Activate()
    end
end

local function softReset()
    if flingLoop then
        flingLoop:Disconnect()
        flingLoop = nil
    end
    bodyVel = nil
    bodyAngVel = nil
    flingAccum = 0
end

local function stopAll()
    softReset()
    multiIndex = 1
    local ch = player.Character
    if ch then
        local r = getRoot(ch)
        local h = ch:FindFirstChild("Humanoid")
        if r then
            r.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
        if h then h.PlatformStand = false end
        resetMass(ch)
    end
end

local function tickFling(dt)
    if not destroyEnabled then return end
    local myChar = player.Character
    if not myChar then return end
    local myRoot = getRoot(myChar)
    local myHumanoid = myChar:FindFirstChild("Humanoid")
    if not myRoot or not myHumanoid then return end
    if myHumanoid.Health <= 0 then return end

    if multiEnabled then
        if #multiTargets == 0 then return end

        local guard = 0
        while #multiTargets > 0 and guard < 40 do
            guard = guard + 1
            if multiIndex > #multiTargets then multiIndex = 1 end
            if multiIndex < 1 then multiIndex = 1 end
            local cur = multiTargets[multiIndex]
            if cur and cur.Parent and cur.Character and getRoot(cur.Character) then break end
            table.remove(multiTargets, multiIndex)
            if multiIndex > #multiTargets then multiIndex = 1 end
        end
        if #multiTargets == 0 then
            refreshMeta()
            return
        end

        local plr = multiTargets[multiIndex]
        local tRoot = getRoot(plr.Character)
        if not tRoot then return end

        devastateFling(tRoot, myRoot, myHumanoid)
        swordAttack(tRoot, myRoot)

        flingAccum = flingAccum + dt
        if flingAccum >= MULTI_INTERVAL then
            flingAccum = 0
            multiIndex = multiIndex + 1
            if multiIndex > #multiTargets then multiIndex = 1 end
        end
        return
    end

    if not targetPlayer then return end
    local tChar = targetPlayer.Character
    if not tChar then return end
    local tRoot = getRoot(tChar)
    if not tRoot then return end
    local tHum = tChar:FindFirstChild("Humanoid")
    if tHum and tHum.Health <= 0 then return end

    devastateFling(tRoot, myRoot, myHumanoid)
    swordAttack(tRoot, myRoot)
end

local function startDestroy()
    if flingLoop then return end
    flingAccum = 0
    flingLoop = RunService.Heartbeat:Connect(function(dt)
        local ok, err = pcall(tickFling, dt)
        if not ok then
            -- never let one bad frame kill the loop
            flingLoop = flingLoop
        end
    end)
end

-- WATCHDOG: re-arms the loop constantly, never stops on its own
task.spawn(function()
    while screenGui.Parent do
        task.wait(0.35)
        if destroyEnabled then
            if not flingLoop then
                startDestroy()
            end
            local ch = player.Character
            if ch and not getSword() then equipSword() end
        end
    end
end)

-- ============ TOGGLES ============
multiBtn.MouseButton1Click:Connect(function()
    multiEnabled = not multiEnabled
    multiIndex = 1
    flingAccum = 0

    local goal = multiEnabled and UDim2.new(0, 97, 0, 3) or UDim2.new(0, 3, 0, 3)
    TweenService:Create(multiKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Position = goal }):Play()
    TweenService:Create(multiKnob, TweenInfo.new(0.18), { BackgroundColor3 = multiEnabled and C.accent or C.dim }):Play()
    TweenService:Create(multiBtn, TweenInfo.new(0.18), { BackgroundColor3 = multiEnabled and C.cardSel or C.card }):Play()
    multiBtn.Text = multiEnabled and "ON   " or "OFF"
    multiBtn.TextColor3 = multiEnabled and C.accent or C.muted
    multiStroke.Color = multiEnabled and C.accent or C.stroke
    multiStroke.Transparency = multiEnabled and 0.4 or 0
    multiLbl.TextColor3 = multiEnabled and C.text or C.muted

    if multiEnabled then
        if targetPlayer then
            if not inMulti(targetPlayer) then table.insert(multiTargets, targetPlayer) end
            targetPlayer = nil
        end
        if destroyEnabled then setStatus("ACTIVE · MULTI", C.accent, true) end
    else
        table.clear(multiTargets)
        if destroyEnabled then setStatus("ACTIVE", C.good, true) end
    end
    updatePlayerList()
end)

toggleBtn.MouseButton1Click:Connect(function()
    if not destroyEnabled then
        if multiEnabled then
            if #multiTargets == 0 then
                setStatus("NO TARGETS", C.bad, false)
                task.delay(1.2, function()
                    if not destroyEnabled then setStatus("IDLE", C.dim, false) end
                end)
                return
            end
        elseif not targetPlayer then
            setStatus("NO TARGET", C.bad, false)
            task.delay(1.2, function()
                if not destroyEnabled then setStatus("IDLE", C.dim, false) end
            end)
            return
        end

        destroyEnabled = true
        toggleBtn.Text = "DISENGAGE"
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(16, 46, 34) }):Play()
        TweenService:Create(togGrad, TweenInfo.new(0.2), { Color = ColorSequence.new(Color3.fromRGB(20, 62, 44), Color3.fromRGB(16, 44, 33)) }):Play()
        togStroke.Color = C.good
        toggleBtn.TextColor3 = C.good
        equipSword()
        setStatus(multiEnabled and "ACTIVE · MULTI" or "ACTIVE", C.good, true)
        startDestroy()
    else
        destroyEnabled = false
        toggleBtn.Text = "ENGAGE"
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), { BackgroundColor3 = C.card }):Play()
        TweenService:Create(togGrad, TweenInfo.new(0.2), { Color = ColorSequence.new(Color3.fromRGB(30, 34, 42), Color3.fromRGB(24, 27, 33)) }):Play()
        togStroke.Color = C.bad
        toggleBtn.TextColor3 = C.text
        stopAll()
        setStatus("IDLE", C.dim, false)
    end
end)

-- ============ LIFE CYCLE (no self-stop) ============
player.CharacterAdded:Connect(function()
    if destroyEnabled then
        task.wait(0.25)
        equipSword()
        startDestroy()
    end
end)

player.CharacterRemoving:Connect(function()
    softReset()
    -- destroyEnabled stays true; watchdog + CharacterAdded bring it right back
end)

print("[ FAGGOT KILLER ] loaded")
