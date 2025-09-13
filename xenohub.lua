-- Xeno Hub V1 (Patched)
-- Made by ! Nexus

print("✅ Xeno Hub script has started!") -- Debug for executor console

-- Safe notification helper
local function notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title or "Notification";
            Text = text or "";
            Duration = duration or 3;
        })
    end)
end

notify("Xeno Hub", "✅ Xeno Hub is Loading...", 3)

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
if not player then
    warn("Xeno Hub: LocalPlayer not available.")
    return
end

-- Wait for PlayerGui
local playerGui = player:WaitForChild("PlayerGui")

-- Remove old GUI if exists
local existing = playerGui:FindFirstChild("XenoHubUI")
if existing then
    existing:Destroy()
end

-- Root GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XenoHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- // Loading Screen (fullscreen)
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.Position = UDim2.new(0, 0, 0, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = ScreenGui

local LoadingText = Instance.new("TextLabel")
LoadingText.Name = "LoadingText"
LoadingText.Size = UDim2.new(1, 0, 1, 0)
LoadingText.Position = UDim2.new(0, 0, 0, 0)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "Loading Xeno Hub...\nMade by ! Nexus"
LoadingText.TextColor3 = Color3.fromRGB(200, 120, 255)
LoadingText.Font = Enum.Font.GothamBold
LoadingText.TextSize = 32
LoadingText.TextStrokeTransparency = 0.5
LoadingText.TextScaled = false
LoadingText.TextWrapped = true
LoadingText.Parent = LoadingFrame

-- // Main Hub Frame (initially hidden)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 220)
MainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Title bar (used for dragging)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Xeno Hub"
TitleLabel.TextColor3 = Color3.fromRGB(200, 120, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.Parent = TitleBar

local CreditLabel = Instance.new("TextLabel")
CreditLabel.Name = "CreditLabel"
CreditLabel.Size = UDim2.new(0, 72, 1, 0)
CreditLabel.Position = UDim2.new(1, -76, 0, 0)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "by ! Nexus"
CreditLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
CreditLabel.Font = Enum.Font.Gotham
CreditLabel.TextSize = 14
CreditLabel.Parent = TitleBar

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 28, 0, 20)
CloseButton.Position = UDim2.new(1, -34, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    print("Xeno Hub closed by user.")
end)

-- Content area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -16, 1, -56)
Content.Position = UDim2.new(0, 8, 0, 44)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- WalkSpeed label + box
local WalkLabel = Instance.new("TextLabel")
WalkLabel.Size = UDim2.new(0.5, -10, 0, 28)
WalkLabel.Position = UDim2.new(0, 0, 0, 0)
WalkLabel.BackgroundTransparency = 1
WalkLabel.Text = "WalkSpeed"
WalkLabel.TextColor3 = Color3.fromRGB(255,255,255)
WalkLabel.Font = Enum.Font.Gotham
WalkLabel.TextSize = 14
WalkLabel.Parent = Content

local WalkBox = Instance.new("TextBox")
WalkBox.Size = UDim2.new(0.5, -10, 0, 28)
WalkBox.Position = UDim2.new(0.5, 8, 0, 0)
WalkBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
WalkBox.TextColor3 = Color3.fromRGB(255,255,255)
WalkBox.Font = Enum.Font.Gotham
WalkBox.TextSize = 14
WalkBox.Text = "16"
WalkBox.ClearTextOnFocus = false
WalkBox.Parent = Content

-- JumpPower label + box
local JumpLabel = Instance.new("TextLabel")
JumpLabel.Size = UDim2.new(0.5, -10, 0, 28)
JumpLabel.Position = UDim2.new(0, 0, 0, 36)
JumpLabel.BackgroundTransparency = 1
JumpLabel.Text = "JumpPower"
JumpLabel.TextColor3 = Color3.fromRGB(255,255,255)
JumpLabel.Font = Enum.Font.Gotham
JumpLabel.TextSize = 14
JumpLabel.Parent = Content

local JumpBox = Instance.new("TextBox")
JumpBox.Size = UDim2.new(0.5, -10, 0, 28)
JumpBox.Position = UDim2.new(0.5, 8, 0, 36)
JumpBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
JumpBox.TextColor3 = Color3.fromRGB(255,255,255)
JumpBox.Font = Enum.Font.Gotham
JumpBox.TextSize = 14
JumpBox.Text = "50"
JumpBox.ClearTextOnFocus = false
JumpBox.Parent = Content

-- Helper: current humanoid reference
local humanoid = nil
local function setHumanoidFromCharacter(char)
    if not char then return end
    humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if humanoid then
        -- populate default displayed values
        pcall(function()
            WalkBox.Text = tostring(humanoid.WalkSpeed or 16)
            JumpBox.Text = tostring(humanoid.JumpPower or 50)
        end)
    end
end

-- initial character/humanoid
setHumanoidFromCharacter(player.Character)
player.CharacterAdded:Connect(function(char)
    setHumanoidFromCharacter(char)
end)

-- Apply values safely
local function applyWalkSpeed(value)
    if not humanoid then return end
    local num = tonumber(value)
    if not num then return end
    humanoid.WalkSpeed = math.clamp(num, 0, 200)
end

local function applyJumpPower(value)
    if not humanoid then return end
    local num = tonumber(value)
    if not num then return end
    humanoid.JumpPower = math.clamp(num, 0, 300)
end

WalkBox.FocusLost:Connect(function(enterPressed)
    applyWalkSpeed(WalkBox.Text)
end)

JumpBox.FocusLost:Connect(function(enterPressed)
    applyJumpPower(JumpBox.Text)
end)

-- Also apply immediately when pressing Enter in boxes
WalkBox.FocusLost:Connect(function()
    applyWalkSpeed(WalkBox.Text)
end)
JumpBox.FocusLost:Connect(function()
    applyJumpPower(JumpBox.Text)
end)

-- Close on Escape
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        if ScreenGui and ScreenGui.Parent then
            ScreenGui:Destroy()
            print("Xeno Hub closed (Escape).")
        end
    end
end)

-- Draggable TitleBar implementation
do
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local dragInput = nil

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging and dragStart and startPos then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Show main hub after loading fade
spawn(function()
    -- wait a short moment so things can initialize
    task.wait(0.5)

    -- If humanoid exists, use its values to set the boxes
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        setHumanoidFromCharacter(player.Character)
    end

    -- Tween size to zero for loading fade
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenProps = {Size = UDim2.new(0, 0, 0, 0)}
    local tween = TweenService:Create(LoadingFrame, tweenInfo, tweenProps)
    tween:Play()
    tween.Completed:Wait()

    -- cleanup and reveal
    if LoadingFrame then LoadingFrame:Destroy() end
    MainFrame.Visible = true

    notify("Xeno Hub", "✅ Loaded Successfully!", 3)
    print("✅ Xeno Hub is fully loaded!")
end)
