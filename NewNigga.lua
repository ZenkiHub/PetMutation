-- Pet Mutation Finder with Styled ESP + Credit Footer
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local mutations = {
    "Shiny", "Inverted", "Frozen", "Windy", "Golden", "Mega", "Tiny",
    "Tranquil", "IronSkin", "Nigga", "Radiant", "Rainbow", "Shocked", "Ascended"
}
local currentMutation = mutations[math.random(#mutations)]
local espVisible = true

local gui = Instance.new("ScreenGui")
gui.Name = "PetMutationFinder"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 185)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BorderColor3 = Color3.fromRGB(80, 80, 90)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(100, 100, 110)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "🔬 Pet Mutation Finder"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local function createButton(text, yPos, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, yPos)
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 16
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.AutoButtonColor = false

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1.2

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.2)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
	end)

	btn.Parent = frame
	return btn
end

local reroll = createButton("🎲 Mutation Reroll", 45, Color3.fromRGB(140, 200, 255))
local toggle = createButton("👁 Toggle Mutation", 90, Color3.fromRGB(180, 255, 180))

-- 🏷 Credit label at the bottom
local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 1, -20)
credit.Text = "Made by Zenki"
credit.TextColor3 = Color3.fromRGB(200, 200, 200)
credit.BackgroundTransparency = 1
credit.Font = Enum.Font.Gotham
credit.TextSize = 13

-- 🔍 Find mutation machine
local function findMachine()
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name:lower():find("mutation") then
			return obj
		end
	end
end

local machine = findMachine()
if not machine or not machine:FindFirstChildWhichIsA("BasePart") then
	warn("Pet Mutation Machine not found.")
	return
end

local basePart = machine:FindFirstChildWhichIsA("BasePart")

-- 💡 Stylish ESP
local espGui = Instance.new("BillboardGui", basePart)
espGui.Name = "MutationESP"
espGui.Adornee = basePart
espGui.Size = UDim2.new(0, 200, 0, 40)
espGui.StudsOffset = Vector3.new(0, 3, 0)
espGui.AlwaysOnTop = true

local espLabel = Instance.new("TextLabel", espGui)
espLabel.Size = UDim2.new(1, 0, 1, 0)
espLabel.BackgroundTransparency = 1
espLabel.Font = Enum.Font.GothamBold
espLabel.TextSize = 24
espLabel.TextStrokeTransparency = 0.3
espLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
espLabel.Text = currentMutation

-- 🌈 Animate rainbow color
local hue = 0
RunService.RenderStepped:Connect(function()
	if espVisible then
		hue = (hue + 0.01) % 1
		espLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
	end
end)

-- ♻️ Reroll effect
local function animateMutationReroll()
	reroll.Text = "⏳ Rerolling..."
	local duration = 2
	local interval = 0.1
	for i = 1, math.floor(duration / interval) do
		espLabel.Text = mutations[math.random(#mutations)]
		wait(interval)
	end
	currentMutation = mutations[math.random(#mutations)]
	espLabel.Text = currentMutation
	reroll.Text = "🎲 Mutation Reroll"
end

toggle.MouseButton1Click:Connect(function()
	espVisible = not espVisible
	espGui.Enabled = espVisible
end)

reroll.MouseButton1Click:Connect(animateMutationReroll)