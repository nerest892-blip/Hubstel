local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local spawnPosition = hrp.Position

local instaMove = false
local speedEnabled = false
local autoKick = false
local speed = 140

-- GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,240,0,220)
frame.Position = UDim2.new(0.05,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(35,0,60)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner",frame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundColor3 = Color3.fromRGB(60,0,110)
title.Text = "IGORKA HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner",title)

local function makeButton(text,y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-20,0,35)
	b.Position = UDim2.new(0,10,0,y)
	b.BackgroundColor3 = Color3.fromRGB(85,0,150)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.Text = text
	b.Parent = frame
	Instance.new("UICorner",b)
	return b
end

local autoKickBtn = makeButton("Auto Kick OFF",45)
local instaBtn = makeButton("Insta Steal OFF",90)
local speedBtn = makeButton("Speed OFF",135)
local desyncBtn = makeButton("Desync",180)

-- GUI DRAG
local dragging
local dragStart
local startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

title.InputEnded:Connect(function()
	dragging = false
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- ESP
local espEnabled = false

local function createESP(plr)
	if plr == player then return end
	
	local function add(char)
		local root = char:WaitForChild("HumanoidRootPart",5)
		local head = char:WaitForChild("Head",5)
		if not root or not head then return end
		
		local box = Instance.new("BoxHandleAdornment")
		box.Size = Vector3.new(4,6,2)
		box.Adornee = root
		box.AlwaysOnTop = true
		box.Transparency = 0.3
		box.Color3 = Color3.fromRGB(180,0,255)
		box.ZIndex = 10
		box.Parent = root
		
		local bill = Instance.new("BillboardGui")
		bill.Size = UDim2.new(0,120,0,20)
		bill.StudsOffset = Vector3.new(0,3,0)
		bill.AlwaysOnTop = true
		bill.Parent = head
		
		local name = Instance.new("TextLabel")
		name.Size = UDim2.new(1,0,1,0)
		name.BackgroundTransparency = 1
		name.Text = plr.Name
		name.TextColor3 = Color3.fromRGB(200,120,255)
		name.Font = Enum.Font.GothamBold
		name.TextScaled = true
		name.Parent = bill
	end
	
	if plr.Character then
		add(plr.Character)
	end
	
	plr.CharacterAdded:Connect(add)
end

local function enableESP()
	for _,p in pairs(Players:GetPlayers()) do
		createESP(p)
	end
end

enableESP()

-- BUTTONS

autoKickBtn.MouseButton1Click:Connect(function()
	autoKick = not autoKick
	autoKickBtn.Text = autoKick and "Auto Kick ON" or "Auto Kick OFF"
end)

instaBtn.MouseButton1Click:Connect(function()
	instaMove = true
	instaBtn.Text = "Insta Steal ON"

	if autoKick then
		task.delay(2.3,function()
			player:Kick("EZZZ STEAL WITH IGORKA HUB")
		end)
	end
end)

speedBtn.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedBtn.Text = speedEnabled and "Speed ON" or "Speed OFF"
	
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = speedEnabled and 30 or 16
	end
end)

desyncBtn.MouseButton1Click:Connect(function()
	char:BreakJoints()
end)

-- FIXED INSTA STEAL (NO SHAKE)

RunService.RenderStepped:Connect(function(dt)

	if not hrp or not spawnPosition then return end
	
	if instaMove then
		
		local dir = spawnPosition - hrp.Position
		local dist = dir.Magnitude
		
		if dist <= 3 then
			hrp.CFrame = CFrame.new(spawnPosition)
			instaMove = false
			instaBtn.Text = "Insta Steal OFF"
			return
		end
		
		local move = dir.Unit * speed * dt
		hrp.CFrame = hrp.CFrame + move
		
	end
	
end)

-- FIX CHARACTER AFTER RESPAWN

player.CharacterAdded:Connect(function(c)
	char = c
	hrp = c:WaitForChild("HumanoidRootPart")
	
	if speedEnabled then
		local hum = c:WaitForChild("Humanoid")
		hum.WalkSpeed = 30
	end
end)
