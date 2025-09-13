-- Xeno Hub Script with Loading Screen
-- Made by ! Nexus

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XenoHubUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- // Loading Screen
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoadingFrame.Parent = ScreenGui

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(1, 0, 1, 0)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "Loading Xeno Hub...\nMade by ! Nexus"
LoadingText.TextColor3 = Color3.fromRGB(200, 120, 255)
LoadingText.Font = Enum.Font.GothamBold
LoadingText.TextSize = 32
LoadingText.TextStrokeTransparency = 0.5
LoadingText.Parent = LoadingFrame

-- // Main Hub Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 200)
MainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "Xeno Hub"
Title.TextColor3 = Color3.fromRGB(200, 120, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local WalkLabel = Instance.new("TextLabel")
WalkLabel.Size = UDim2.new(0.5, -10, 0, 30)
WalkLabel.Position = UDim2.new(0, 5, 0, 50)
WalkLabel.Text = "WalkSpeed"
WalkLabel.BackgroundTransparency = 1
WalkLabel.TextColor3 = Color3.fromRGB(255,255,255)
WalkLabel.Parent = MainFrame

local WalkBox = Instance.new("TextBox")
WalkBox.Size = UDim2.new(0.5, -10, 0, 30)
WalkBox.Position = UDim2.new(0.5, 5, 0, 50)
WalkBox.Text = tostring(humanoid.WalkSpeed)
WalkBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
WalkBox.TextColor3 = Color3.fromRGB(255,255,255)
WalkBox.Font = Enum.Font.Gotham
WalkBox.TextSize = 14
WalkBox.Parent = MainFrame

local JumpLabel = Instance.new("TextLabel")
JumpLabel.Size = UDim2.new(0.5, -10, 0, 30)
JumpLabel.Position = UDim2.new(0, 5, 0, 90)
JumpLabel.Text = "JumpPower"
JumpLabel.BackgroundTransparency = 1
JumpLabel.TextColor3 = Color3.fromRGB(255,255,255)
JumpLabel.Parent = MainFrame

local JumpBox = Instance.new("TextBox")
JumpBox.Size = UDim2.new(0.5, -10, 0, 30)
JumpBox.Position = UDim2.new(0.5, 5, 0, 90)
JumpBox.Text = tostring(humanoid.JumpPower)
JumpBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
JumpBox.TextColor3 = Color3.fromRGB(255,255,255)
JumpBox.Font = Enum.Font.Gotham
JumpBox.TextSize = 14
JumpBox.Parent = MainFrame

-- // Functions
local function updateWalkSpeed()
	local value = tonumber(WalkBox.Text)
	if value then
		humanoid.WalkSpeed = math.clamp(value, 0, 200)
	end
end

local function updateJumpPower()
	local value = tonumber(JumpBox.Text)
	if value then
		humanoid.JumpPower = math.clamp(value, 0, 300)
	end
end

WalkBox.FocusLost:Connect(updateWalkSpeed)
JumpBox.FocusLost:Connect(updateJumpPower)

game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		character = char
		humanoid = character:WaitForChild("Humanoid")
	end)
end)

-- // Loading screen fade out
task.wait(2.5) -- how long the loading screen stays
LoadingFrame:TweenSize(UDim2.new(0,0,0,0), "Out", "Quad", 1, true, function()
	LoadingFrame:Destroy()
	MainFrame.Visible = true
end)
