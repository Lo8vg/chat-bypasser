-- COMBO DESTROYER v2 (Compact)
local P,UIS,RS=game:GetService("Players"),game:GetService("UserInputService"),game:GetService("RunService")
local LP=P.LocalPlayer local PG=LP:WaitForChild("PlayerGui")

-- Settings
local ON,TP,CMD=false,nil,0
local VEL,ANG,TLPT,MASS,SWRD=true,true,true,true,true
local MODE="devastate"
local VP,AP,SW,REACH=999999,999999,3,15

-- GUI
local SG=Instance.new("ScreenGui",PG) SG.Name="CD" SG.ResetOnSpawn=false
local C=Instance.new("UICorner")

local HB=Instance.new("TextButton") HB.Size=UDim2.new(0,44,0,44) HB.Position=UDim2.new(0,15,0.5,-22) HB.BackgroundColor3=Color3.new(1,1,1) HB.Text="💀" HB.Font=Enum.Font.GothamBold HB.TextSize=20 HB.TextColor3=Color3.fromRGB(33,37,41) HB.Parent=SG
C:Clone().Parent=HB HB.BorderSizePixel=0

local MF=Instance.new("Frame") MF.Size=UDim2.new(0,700,0,320) MF.Position=UDim2.new(0.5,-350,0.5,-160) MF.BackgroundColor3=Color3.fromRGB(245,245,245) MF.Visible=false MF.Parent=SG
C:Clone().Parent=MF MF.BorderSizePixel=0

local TB=Instance.new("Frame") TB.Size=UDim2.new(1,0,0,32) TB.BackgroundColor3=Color3.new(1,1,1) TB.Parent=MF
local TBC=C:Clone() TBC.Parent=TB
local TBF=Instance.new("Frame") TBF.Size=UDim2.new(1,0,0,12) TBF.Position=UDim2.new(0,0,1,-12) TBF.BackgroundColor3=Color3.new(1,1,1) TBF.Parent=TB TBF.BorderSizePixel=0

local TL=Instance.new("TextLabel") TL.Size=UDim2.new(1,-80,1,0) TL.Position=UDim2.new(0,12,0,0) TL.BackgroundTransparency=1 TL.Text="💀 COMBO DESTROYER" TL.Font=Enum.Font.GothamBold TL.TextSize=13 TL.TextColor3=Color3.fromRGB(33,37,41) TL.TextXAlignment=Enum.TextXAlignment.Left TL.Parent=TB

local KB=Instance.new("TextButton") KB.Size=UDim2.new(0,60,0,22) KB.Position=UDim2.new(1,-66,0.5,-11) KB.BackgroundColor3=Color3.fromRGB(220,53,69) KB.Text="KILL" KB.Font=Enum.Font.GothamBold KB.TextSize=10 KB.TextColor3=Color3.new(1,1,1) KB.Parent=TB
C:Clone().Parent=KB KB.BorderSizePixel=0

-- Left Panel
local LPN=Instance.new("Frame") LPN.Size=UDim2.new(0.33,0,1,-40) LPN.Position=UDim2.new(0,10,0,36) LPN.BackgroundTransparency=1 LPN.Parent=MF

local TGL=Instance.new("TextButton") TGL.Size=UDim2.new(1,0,0,36) TGL.BackgroundColor3=Color3.fromRGB(220,53,69) TGL.Text="DESTROY: OFF" TGL.Font=Enum.Font.GothamBold TGL.TextSize=14 TGL.TextColor3=Color3.new(1,1,1) TGL.Parent=LPN
C:Clone().Parent=TGL TGL.BorderSizePixel=0

local KC=Instance.new("TextLabel") KC.Size=UDim2.new(1,0,0,16) KC.Position=UDim2.new(0,0,0,42) KC.BackgroundTransparency=1 KC.Text="Attacks: 0" KC.Font=Enum.Font.GothamBold KC.TextSize=10 KC.TextColor3=Color3.fromRGB(40,167,69) KC.Parent=LPN

local SL=Instance.new("TextLabel") SL.Size=UDim2.new(1,0,0,14) SL.Position=UDim2.new(0,0,0,60) SL.BackgroundTransparency=1 SL.Text="Select Target:" SL.Font=Enum.Font.GothamBold SL.TextSize=9 SL.TextColor3=Color3.fromRGB(33,37,41) SL.TextXAlignment=Enum.TextXAlignment.Left SL.Parent=LPN

local PS=Instance.new("ScrollingFrame") PS.Size=UDim2.new(1,0,0,120) PS.Position=UDim2.new(0,0,0,78) PS.BackgroundColor3=Color3.fromRGB(250,250,250) PS.ScrollBarThickness=4 PS.Parent=LPN
C:Clone().Parent=PS PS.BorderSizePixel=0
local PL=Instance.new("UIListLayout") PL.Padding=UDim.new(0,2) PL.Parent=PS

local ST=Instance.new("TextLabel") ST.Size=UDim2.new(1,0,0,14) ST.Position=UDim2.new(0,0,0,202) ST.BackgroundTransparency=1 ST.Text="No target" ST.Font=Enum.Font.Gotham ST.TextSize=9 ST.TextColor3=Color3.fromRGB(134,142,150) ST.Parent=LPN

-- Mode Buttons
local ML=Instance.new("TextLabel") ML.Size=UDim2.new(1,0,0,14) ML.Position=UDim2.new(0,0,0,220) ML.BackgroundTransparency=1 ML.Text="Mode:" ML.Font=Enum.Font.GothamBold ML.TextSize=9 ML.TextColor3=Color3.fromRGB(33,37,41) ML.TextXAlignment=Enum.TextXAlignment.Left ML.Parent=LPN

local MB={} local MODES={"devastate","orbital","chaos"}
for i,m in ipairs(MODES)do
	local B=Instance.new("TextButton") B.Size=UDim2.new(0.33,-2,0,28) B.Position=UDim2.new((i-1)/3,0,0,238) B.BackgroundColor3=i==1 and Color3.fromRGB(40,167,69)or Color3.fromRGB(200,200,200) B.Text=m:upper() B.Font=Enum.Font.Gotham B.TextSize=9 B.TextColor3=i==1 and Color3.new(1,1,1)or Color3.fromRGB(33,37,41) B.Parent=LPN
	C:Clone().Parent=B B.BorderSizePixel=0
	B.MouseButton1Click:Connect(function() MODE=m for j,b in pairs(MB)do b.BackgroundColor3=j==m and Color3.fromRGB(40,167,69)or Color3.fromRGB(200,200,200) b.TextColor3=j==m and Color3.new(1,1,1)or Color3.fromRGB(33,37,41)end end)
	MB[m]=B
end

-- Middle Panel
local MPN=Instance.new("Frame") MPN.Size=UDim2.new(0.33,0,1,-40) MPN.Position=UDim2.new(0.33,10,0,36) MPN.BackgroundTransparency=1 MPN.Parent=MF

local SH=Instance.new("TextLabel") SH.Size=UDim2.new(1,0,0,14) SH.BackgroundTransparency=1 SH.Text="⚔️ SWORD" SH.Font=Enum.Font.GothamBold SH.TextSize=10 SH.TextColor3=Color3.fromRGB(0,120,215) SH.Parent=MPN

local SWB=Instance.new("TextButton") SWB.Size=UDim2.new(1,0,0,24) SWB.Position=UDim2.new(0,0,0,18) SWB.BackgroundColor3=Color3.fromRGB(40,167,69) SWB.Text="✓ Auto Sword" SWB.Font=Enum.Font.Gotham SWB.TextSize=9 SWB.TextColor3=Color3.new(1,1,1) SWB.Parent=MPN
C:Clone().Parent=SWB SWB.BorderSizePixel=0

local SWI=Instance.new("TextBox") SWI.Size=UDim2.new(1,0,0,24) SWI.Position=UDim2.new(0,0,0,46) SWI.BackgroundColor3=Color3.new(1,1,1) SWI.Text="Swings: 3" SWI.Font=Enum.Font.Gotham SWI.TextSize=9 SWI.TextColor3=Color3.fromRGB(33,37,41) SWI.Parent=MPN
C:Clone().Parent=SWI Instance.new("UIStroke",SWI)

local RI=Instance.new("TextBox") RI.Size=UDim2.new(1,0,0,24) RI.Position=UDim2.new(0,0,0,74) RI.BackgroundColor3=Color3.new(1,1,1) RI.Text="Reach: 15" RI.Font=Enum.Font.Gotham RI.TextSize=9 RI.TextColor3=Color3.fromRGB(33,37,41) RI.Parent=MPN
C:Clone().Parent=RI Instance.new("UIStroke",RI)

local FH=Instance.new("TextLabel") FH.Size=UDim2.new(1,0,0,14) FH.Position=UDim2.new(0,0,0,108) FH.BackgroundTransparency=1 FH.Text="💥 FLING" FH.Font=Enum.Font.GothamBold FH.TextSize=10 FH.TextColor3=Color3.fromRGB(220,53,69) FH.Parent=MPN

local VI=Instance.new("TextBox") VI.Size=UDim2.new(1,0,0,24) VI.Position=UDim2.new(0,0,0,126) VI.BackgroundColor3=Color3.new(1,1,1) VI.Text="Vel: 999999" VI.Font=Enum.Font.Gotham VI.TextSize=9 VI.TextColor3=Color3.fromRGB(33,37,41) VI.Parent=MPN
C:Clone().Parent=VI Instance.new("UIStroke",VI)

local AI=Instance.new("TextBox") AI.Size=UDim2.new(1,0,0,24) AI.Position=UDim2.new(0,0,0,154) AI.BackgroundColor3=Color3.new(1,1,1) AI.Text="Ang: 999999" AI.Font=Enum.Font.Gotham AI.TextSize=9 AI.TextColor3=Color3.fromRGB(33,37,41) AI.Parent=MPN
C:Clone().Parent=AI Instance.new("UIStroke",AI)

-- Right Panel (Toggles)
local RPN=Instance.new("Frame") RPN.Size=UDim2.new(0.3,-10,1,-40) RPN.Position=UDim2.new(0.66,10,0,36) RPN.BackgroundTransparency=1 RPN.Parent=MF

local TH=Instance.new("TextLabel") TH.Size=UDim2.new(1,0,0,14) TH.BackgroundTransparency=1 TH.Text="TOGGLES" TH.Font=Enum.Font.GothamBold TH.TextSize=10 TH.TextColor3=Color3.fromRGB(33,37,41) TH.Parent=RPN

local TGTS={{n="Velocity",v=true},{n="Angular",v=true},{n="Teleport",v=true},{n="Mass",v=true}}
local TGB={}
for i,t in ipairs(TGTS)do
	local B=Instance.new("TextButton") B.Size=UDim2.new(1,0,0,22) B.Position=UDim2.new(0,0,0,18+(i-1)*26) B.BackgroundColor3=Color3.fromRGB(40,167,69) B.Text="✓ "..t.n B.Font=Enum.Font.Gotham B.TextSize=9 B.TextColor3=Color3.new(1,1,1) B.Parent=RPN
	C:Clone().Parent=B B.BorderSizePixel=0
	B.MouseButton1Click:Connect(function() t.v=not t.v B.Text=(t.v and"✓ "or"✗ ")..t.n B.BackgroundColor3=t.v and Color3.fromRGB(40,167,69)or Color3.fromRGB(220,53,69) end)
	TGB[t.n]=B
end

-- Dragging
local DG,DI,DS,SP=false,nil,nil,nil
HB.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then DG=true DS=i.Position SP=HB.Position i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then DG=false end)end end)
HB.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then DI=i end end)
UIS.InputChanged:Connect(function(i) if i==DI and DG then local d=i.Position-DS HB.Position=UDim2.new(SP.X.Scale,SP.X.Offset+d.X,SP.Y.Scale,SP.Y.Offset+d.Y)end end)

local HDG,HDI,HDS,HP=false,nil,nil,nil
TB.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then HDG=true HDS=i.Position HP=MF.Position i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then HDG=false end)end end)
TB.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then HDI=i end end)
UIS.InputChanged:Connect(function(i) if i==HDI and HDG then local d=i.Position-HDS MF.Position=UDim2.new(HP.X.Scale,HP.X.Offset+d.X,HP.Y.Scale,HP.Y.Offset+d.Y)end end)

-- Hub Toggle
HB.MouseButton1Click:Connect(function() HB.Visible=false MF.Visible=true end)
KB.MouseButton1Click:Connect(function() MF.Visible=false HB.Visible=true end)

-- Player List
local PBS={}
local function UPL() for _,b in pairs(PBS)do b:Destroy() end PBS={} local CY=0 for _,p in pairs(P:GetPlayers())do if p~=LP then local B=Instance.new("TextButton") B.Size=UDim2.new(1,0,0,20) B.Position=UDim2.new(0,0,0,CY) B.BackgroundColor3=TP==p and Color3.fromRGB(0,120,215)or Color3.fromRGB(240,240,240) B.Text=p.Name B.Font=Enum.Font.Gotham B.TextSize=9 B.TextColor3=TP==p and Color3.new(1,1,1)or Color3.fromRGB(33,37,41) B.Parent=PS C:Clone().Parent=B B.BorderSizePixel=0 B.MouseButton1Click:Connect(function() TP=p ST.Text="Target: "..p.Name UPL() end) CY=CY+22 table.insert(PBS,B) end end PS.CanvasSize=UDim2.new(0,0,0,CY) end
P.PlayerAdded:Connect(UPL) P.PlayerRemoving:Connect(function() wait(0.3) UPL() end) UPL()

-- Toggle Events
SWB.MouseButton1Click:Connect(function() SWRD=not SWRD SWB.Text=SWRD and"✓ Auto Sword"or"✗ Auto Sword" SWB.BackgroundColor3=SWRD and Color3.fromRGB(40,167,69)or Color3.fromRGB(220,53,69) end)

-- Core Functions
local function GR(c) return c:FindFirstChild("HumanoidRootPart")or c:FindFirstChild("Torso")or c:FindFirstChild("UpperTorso") end
local function GS() local c=LP.Character if not c then return nil end for _,t in pairs(c:GetChildren())do if t:IsA("Tool")then return t end end return nil end
local function ES() local c=LP.Character local b=LP:FindFirstChild("Backpack") if not c or not b then return nil end local t=GS() if t then return t end local h=c:FindFirstChild("Humanoid") if not h then return nil end for _,i in pairs(b:GetChildren())do if i:IsA("Tool")then h:EquipTool(i) wait(0.03) return i end end return nil end

local BV,BA=nil,nil
local function BM(c) if not TGTS[4].v then return end local r=GR(c) if r then r.CustomPhysicalProperties=PhysicalProperties.new(100,0.5,0.5) end end
local function RM(c) local r=GR(c) if r then r.CustomPhysicalProperties=nil end end

local function DF(tr,mr,mh)
	VP=tonumber(VI.Text:match("%d+"))or 999999 AP=tonumber(AI.Text:match("%d+"))or 999999
	if TGTS[4].v then BM(LP.Character) end
	if TGTS[3].v then mr.CFrame=tr.CFrame*CFrame.new(math.random(-1,1),math.random(-1,1),math.random(-1,1)) end
	if TGTS[1].v then if BV then BV:Destroy() end BV=Instance.new("BodyVelocity") BV.Name="CB" BV.MaxForce=Vector3.new(math.huge,math.huge,math.huge) BV.Velocity=Vector3.new(math.random(-1,1)*VP,VP,math.random(-1,1)*VP) BV.P=math.huge BV.Parent=mr end
	if TGTS[2].v then if BA then BA:Destroy() end BA=Instance.new("BodyAngularVelocity") BA.Name="CS" BA.MaxTorque=Vector3.new(math.huge,math.huge,math.huge) BA.AngularVelocity=Vector3.new(AP,AP,AP) BA.P=math.huge BA.Parent=mr end
	if mh then mh.PlatformStand=true end
end

local FL=nil
local function SA(tr,mr) if not SWRD then return end REACH=tonumber(RI.Text:match("%d+"))or 15 SW=tonumber(SWI.Text:match("%d+"))or 3 local s=GS() if not s then s=ES() if not s then return end end if(tr.Position-mr.Position).Magnitude<=REACH then for i=1,SW do s:Activate() wait(0.01) end end end

local function ST() if FL then FL:Disconnect() FL=nil end if BV then BV:Destroy() BV=nil end if BA then BA:Destroy() BA=nil end local c=LP.Character if c then local r=GR(c) local h=c:FindFirstChild("Humanoid") if r then r.AssemblyAngularVelocity=Vector3.new() r.AssemblyLinearVelocity=Vector3.new() end if h then h.PlatformStand=false end RM(c) end end

local function STRT() if FL then FL:Disconnect() end FL=RS.Heartbeat:Connect(function() if not ON then return end local c=LP.Character if not c then return end local mr=GR(c) local mh=c:FindFirstChild("Humanoid") if not mr then return end if not TP or not TP.Character then return end local tr=GR(TP.Character) if not tr then return end DF(tr,mr,mh) SA(tr,mr) end) end

-- Main Toggle
TGL.MouseButton1Click:Connect(function()
	ON=not ON
	if ON then
		if not TP then ST.Text="Select target!" ON=false return end
		TGL.Text="DESTROY: ON" TGL.BackgroundColor3=Color3.fromRGB(40,167,69) ST.Text="Destroying: "..TP.Name
		ES() STRT()
	else
		TGL.Text="DESTROY: OFF" TGL.BackgroundColor3=Color3.fromRGB(220,53,69) ST.Text=TP and("Target: "..TP.Name)or"No target"
		ST()
	end
end)

UIS.InputBegan:Connect(function(i) if i.KeyCode==Enum.KeyCode.RightControl then if MF.Visible then MF.Visible=false HB.Visible=true else HB.Visible=not HB.Visible end end end)

LP.CharacterAdded:Connect(function() wait(0.2) if ON then CMD=CMD+1 KC.Text="Attacks: "..CMD ES() STRT() end end)
LP.CharacterRemoving:Connect(function() ST() end)

print("✅ COMBO DESTROYER Loaded")
