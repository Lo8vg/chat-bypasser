local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "TestGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 60, 0, 60)
btn.Position = UDim2.new(0, 20, 0.5, -30)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.Text = "TEST"
btn.TextColor3 = Color3.new(1,1,1)
btn.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = btn

print("TEST GUI LOADED")
