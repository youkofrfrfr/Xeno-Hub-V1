-- Xeno Hub — Full UI with advanced loading and draggable window
-- Made by ! Nexus (patched & styled)
-- Put this as a LocalScript (or run via executor loadstring)

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
if not player then return end
local playerGui = player:WaitForChild("PlayerGui")

-- Avoid duplicate GUI
local old = playerGui:FindFirstChild("XenoHubUI")
if old then old:Destroy() end

-- Root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XenoHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Helper: create corner and stroke
local function styleRounded(instance, radius, stroke)
    local uc = Instance.new("UICorner", instance)
    uc.CornerRadius = UDim.new(0, radius or 8)
    if stroke then
        local us = Instance.new("UIStroke", instance)
        us.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        us.Thickness = stroke.thickness or 1
        us.Color = stroke.color or Color3.fromRGB(0,0,0)
        us.Transparency = stroke.transparency or 0.7
    end
end

-- ============================
-- Loading Screen (advanced)
-- ============================
local LoadingRoot = Instance.new("Frame")
LoadingRoot.Name = "LoadingRoot"
LoadingRoot.Size = UDim2.new(1,0,1,0)
LoadingRoot.Position = UDim2.new(0,0,0,0)
LoadingRoot.BackgroundColor3 = Color3.fromRGB(12,12,16)
LoadingRoot.Parent = ScreenGui

local loadingCenter = Instance.new("Frame", LoadingRoot)
loadingCenter.Size = UDim2.new(0, 560, 0, 220)
loadingCenter.AnchorPoint = Vector2.new(0.5,0.5)
loadingCenter.Position = UDim2.new(0.5,0.45,0.5,0)
loadingCenter.BackgroundTransparency = 1

-- glass panel behind
local glass = Instance.new("Frame", loadingCenter)
glass.Size = UDim2.new(1,0,1,0)
glass.Position = UDim2.new(0,0,0,0)
glass.BackgroundColor3 = Color3.fromRGB(24,24,28)
glass.BackgroundTransparency = 0
styleRounded(glass, 14, {thickness=1, color=Color3.fromRGB(0,0,0), transparency=0.8})
glass.BorderSizePixel = 0
glass.ClipsDescendants = true

-- top bar neon strip (pink)
local topStrip = Instance.new("Frame", glass)
topStrip.Size = UDim2.new(1,0,0,6)
topStrip.Position = UDim2.new(0,0,0,0)
topStrip.BackgroundColor3 = Color3.fromRGB(255, 35, 160)
styleRounded(topStrip, 6)
topStrip.BorderSizePixel = 0

-- glow rainbow ring (left)
local ringContainer = Instance.new("Frame", glass)
ringContainer.Size = UDim2.new(0, 160, 1, -40)
ringContainer.Position = UDim2.new(0, 18, 0, 20)
ringContainer.BackgroundTransparency = 1

local ring = Instance.new("ImageLabel", ringContainer)
ring.Size = UDim2.new(0, 140, 0, 140)
ring.Position = UDim2.new(0, 0, 0, 10)
ring.BackgroundTransparency = 1
ring.Image = "" -- empty circle, we'll fake with gradient + stroke
-- create circular gradient-ish appearance
local ringBg = Instance.new("Frame", ring)
ringBg.Size = UDim2.new(1,0,1,0)
ringBg.BackgroundColor3 = Color3.fromRGB(60,0,120)
ringBg.BorderSizePixel = 0
styleRounded(ringBg, 70)
ringBg.ZIndex = 2

local inner = Instance.new("Frame", ring)
inner.Size = UDim2.new(0.72,0,0.72,0)
inner.Position = UDim2.new(0.14,0,0.14,0)
inner.BackgroundColor3 = Color3.fromRGB(18,18,22)
inner.BorderSizePixel = 0
styleRounded(inner, 60)
inner.ZIndex = 3

-- rainbow gradient effect overlay (animated via rotation)
local rainbow = Instance.new("Frame", ring)
rainbow.Size = UDim2.new(1,0,1,0)
rainbow.BackgroundTransparency = 0
rainbow.BorderSizePixel = 0
styleRounded(rainbow, 70)
rainbow.ZIndex = 1

local grad = Instance.new("UIGradient", rainbow)
grad.Rotation = 0
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 49, 128)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 202, 58)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(87, 216, 98)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(56, 200, 231)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(120, 80, 240)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 49, 128)),
}
grad.Offset = Vector2.new(0,0)

-- typewriter loading text
local loadTitle = Instance.new("TextLabel", glass)
loadTitle.Size = UDim2.new(0.57, -20, 0, 46)
loadTitle.Position = UDim2.new(0.42, 10, 0, 30)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = ""
loadTitle.Font = Enum.Font.GothamBold
loadTitle.TextSize = 28
loadTitle.TextColor3 = Color3.fromRGB(220, 200, 255)
loadTitle.TextXAlignment = Enum.TextXAlignment.Left

local loadSub = Instance.new("TextLabel", glass)
loadSub.Size = UDim2.new(0.58, -20, 0, 26)
loadSub.Position = UDim2.new(0.42, 10, 0, 76)
loadSub.BackgroundTransparency = 1
loadSub.Text = "Initializing modules..."
loadSub.Font = Enum.Font.Gotham
loadSub.TextSize = 16
loadSub.TextColor3 = Color3.fromRGB(180,180,190)
loadSub.TextXAlignment = Enum.TextXAlignment.Left

-- progress bar background
local progressBG = Instance.new("Frame", glass)
progressBG.Size = UDim2.new(0.58, -20, 0, 14)
progressBG.Position = UDim2.new(0.42, 10, 0, 118)
progressBG.BackgroundColor3 = Color3.fromRGB(36,36,40)
progressBG.BorderSizePixel = 0
styleRounded(progressBG, 8)

local progressFill = Instance.new("Frame", progressBG)
progressFill.Size = UDim2.new(0,0,1,0)
progressFill.Position = UDim2.new(0,0,0,0)
progressFill.BackgroundColor3 = Color3.fromRGB(255, 43, 150)
styleRounded(progressFill, 8)

local progressText = Instance.new("TextLabel", glass)
progressText.Size = UDim2.new(0.58, -20, 0, 24)
progressText.Position = UDim2.new(0.42, 10, 0, 140)
progressText.BackgroundTransparency = 1
progressText.Text = "0%"
progressText.Font = Enum.Font.Gotham
progressText.TextSize = 14
progressText.TextColor3 = Color3.fromRGB(185,185,185)
progressText.TextXAlignment = Enum.TextXAlignment.Left

-- small footer
local footer = Instance.new("TextLabel", glass)
footer.Size = UDim2.new(1, -36, 0, 18)
footer.Position = UDim2.new(0, 18, 1, -30)
footer.BackgroundTransparency = 1
footer.Text = "Xeno Hub — Loading UI"
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
footer.TextColor3 = Color3.fromRGB(130,130,140)
footer.TextXAlignment = Enum.TextXAlignment.Left

-- animate rainbow ring rotation
spawn(function()
    while LoadingRoot and LoadingRoot.Parent do
        for i = 0, 360, 4 do
            grad.Rotation = i
            task.wait(0.01)
        end
    end
end)

-- typewriter text function
local function typewriter(textLabel, text, speed)
    textLabel.Text = ""
    for i = 1, #text do
        textLabel.Text = string.sub(text, 1, i)
        task.wait(speed or 0.02)
    end
end

-- pretend loading steps (you can make these reflect actual loads)
local steps = {
    {name = "Loading Xeno Core", time = 0.4},
    {name = "Applying UI theme", time = 0.35},
    {name = "Spawning components", time = 0.45},
    {name = "Initializing sliders", time = 0.25},
    {name = "Finalizing", time = 0.6},
}

-- run fake loading with progress
spawn(function()
    local total = 0
    for i, step in ipairs(steps) do total = total + step.time end
    local acc = 0

    for i, step in ipairs(steps) do
        typewriter(loadTitle, step.name, 0.02)
        loadSub.Text = ("Step %d/%d"):format(i, #steps)
        local t = 0
        while t < step.time do
            t = t + task.wait(0.02)
            acc = acc + (0.02 / total)
            local pct = math.clamp(acc, 0, 1)
            progressFill:TweenSize(UDim2.new(pct, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
            progressText.Text = math.floor(pct * 100) .. "%"
        end
    end

    -- small pause so user sees 100%
    progressFill:TweenSize(UDim2.new(1,0,1,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    progressText.Text = "100%"
    typewriter(loadTitle, "Ready — Launching Hub", 0.02)

    -- final fade out
    task.wait(0.45)
    local tween = TweenService:Create(LoadingRoot, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Wait()
    LoadingRoot:Destroy()
end)

-- ============================
-- Main UI (matches screenshot look)
-- ============================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 980, 0, 340)
mainFrame.Position = UDim2.new(0.02, 0, 0.03, 0)
mainFrame.AnchorPoint = Vector2.new(0,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(28,28,30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = ScreenGui
styleRounded(mainFrame, 12)

-- top beveled line (thin)
local topBevel = Instance.new("Frame", mainFrame)
topBevel.Size = UDim2.new(1,0,0,6)
topBevel.Position = UDim2.new(0,0,0,0)
topBevel.BackgroundColor3 = Color3.fromRGB(255, 40, 160)
topBevel.BorderSizePixel = 0
styleRounded(topBevel, 6)

-- left sidebar (dark)
local leftSide = Instance.new("Frame", mainFrame)
leftSide.Size = UDim2.new(0, 260, 1, -20)
leftSide.Position = UDim2.new(0, 16, 0, 16)
leftSide.BackgroundColor3 = Color3.fromRGB(30,30,32)
leftSide.BorderSizePixel = 0
styleRounded(leftSide, 10)

-- profile avatar circle top-left inside sidebar
local profileFrame = Instance.new("Frame", leftSide)
profileFrame.Size = UDim2.new(1, -24, 0, 86)
profileFrame.Position = UDim2.new(0,12,0,12)
profileFrame.BackgroundTransparency = 1

local avatar = Instance.new("ImageLabel", profileFrame)
avatar.Size = UDim2.new(0, 56, 0, 56)
avatar.Position = UDim2.new(0, 0, 0, 0)
avatar.BackgroundColor3 = Color3.fromRGB(20,20,20)
avatar.BorderSizePixel = 0
styleRounded(avatar, 28)
avatar.Image = ""
avatar.ImageTransparency = 1

local displayName = Instance.new("TextLabel", profileFrame)
displayName.Size = UDim2.new(1, -64, 0, 26)
displayName.Position = UDim2.new(0, 72, 0, 6)
displayName.BackgroundTransparency = 1
displayName.Text = "Xeno Hub"
displayName.Font = Enum.Font.GothamBold
displayName.TextColor3 = Color3.fromRGB(220,220,225)
displayName.TextSize = 16
displayName.TextXAlignment = Enum.TextXAlignment.Left

local subText = Instance.new("TextLabel", profileFrame)
subText.Size = UDim2.new(1, -64, 0, 20)
subText.Position = UDim2.new(0, 72, 0, 34)
subText.BackgroundTransparency = 1
subText.Text = "Shadow Boxing"
subText.Font = Enum.Font.Gotham
subText.TextColor3 = Color3.fromRGB(150,150,155)
subText.TextSize = 13
subText.TextXAlignment = Enum.TextXAlignment.Left

-- "Functions" header
local functionsLabel = Instance.new("TextLabel", leftSide)
functionsLabel.Size = UDim2.new(1, -24, 0, 28)
functionsLabel.Position = UDim2.new(0, 12, 0, 110)
functionsLabel.BackgroundTransparency = 1
functionsLabel.Text = "Functions"
functionsLabel.Font = Enum.Font.Gotham
functionsLabel.TextSize = 14
functionsLabel.TextColor3 = Color3.fromRGB(200,200,205)
functionsLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Example pink "Player" button
local playerBtn = Instance.new("TextButton", leftSide)
playerBtn.Size = UDim2.new(1, -26, 0, 44)
playerBtn.Position = UDim2.new(0, 12, 0, 140)
playerBtn.BackgroundColor3 = Color3.fromRGB(255, 45, 170)
playerBtn.BorderSizePixel = 0
playerBtn.Text = "Player"
playerBtn.Font = Enum.Font.GothamBold
playerBtn.TextSize = 16
playerBtn.TextColor3 = Color3.fromRGB(255,255,255)
styleRounded(playerBtn, 10)

-- right content area (dark panels for sliders)
local rightArea = Instance.new("Frame", mainFrame)
rightArea.Size = UDim2.new(0, 660, 1, -20)
rightArea.Position = UDim2.new(0, 296, 0, 16)
rightArea.BackgroundTransparency = 1

-- single large card that holds sliders
local card = Instance.new("Frame", rightArea)
card.Size = UDim2.new(1, 0, 1, -10)
card.Position = UDim2.new(0, 0, 0, 0)
card.BackgroundColor3 = Color3.fromRGB(23,23,25)
card.BorderSizePixel = 0
styleRounded(card, 10)

-- internal padding frame
local cardContent = Instance.new("Frame", card)
cardContent.Size = UDim2.new(1, -24, 1, -24)
cardContent.Position = UDim2.new(0, 12, 0, 12)
cardContent.BackgroundTransparency = 1

-- slider creation helper
local function createSlider(parent, yOffset, labelText, defaultValue, maxValue)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, 0, 0, 72)
    container.Position = UDim2.new(0, 0, 0, yOffset)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, -60, 0, 24)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local valueLabel = Instance.new("TextLabel", container)
    valueLabel.Size = UDim2.new(0, 48, 0, 24)
    valueLabel.Position = UDim2.new(1, -48, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextColor3 = Color3.fromRGB(200,200,200)
    valueLabel.TextSize = 14

    local barBG = Instance.new("Frame", container)
    barBG.Size = UDim2.new(1, 0, 0, 18)
    barBG.Position = UDim2.new(0, 0, 0, 30)
    barBG.BackgroundColor3 = Color3.fromRGB(18,18,20)
    barBG.BorderSizePixel = 0
    styleRounded(barBG, 10)

    local fill = Instance.new("Frame", barBG)
    fill.Size = UDim2.new(defaultValue/maxValue, 0, 1, 0)
    fill.Position = UDim2.new(0,0,0,0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 75, 185)
    styleRounded(fill, 10)

    local sliderBtn = Instance.new("TextButton", barBG)
    sliderBtn.Size = UDim2.new(0, 18, 0, 18)
    sliderBtn.Position = UDim2.new(math.clamp(defaultValue/maxValue, 0, 1)-0.03, 0, 0, 0)
    sliderBtn.Text = ""
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    sliderBtn.BorderSizePixel = 0
    styleRounded(sliderBtn, 9)
    sliderBtn.ZIndex = fill.ZIndex + 2

    -- text box for typing
    local inputBox = Instance.new("TextBox", container)
    inputBox.Size = UDim2.new(0, 80, 0, 26)
    inputBox.Position = UDim2.new(1, -88, 0, 36)
    inputBox.BackgroundColor3 = Color3.fromRGB(32,32,34)
    inputBox.TextColor3 = Color3.fromRGB(220,220,220)
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 14
    inputBox.Text = tostring(defaultValue)
    inputBox.ClearTextOnFocus = false
    styleRounded(inputBox, 8)

    -- dragging support
    local dragging = false
    local dragStartX = nil
    local absSize = nil

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStartX = input.Position.X
            absSize = barBG.AbsoluteSize.X
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    sliderBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            -- handled by global InputChanged below
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement and absSize then
            local relative = math.clamp((input.Position.X - barBG.AbsolutePosition.X) / absSize, 0, 1)
            fill.Size = UDim2.new(relative, 0, 1, 0)
            sliderBtn.Position = UDim2.new(relative - 0.03, 0, 0, 0)
            local newVal = math.floor((relative * maxValue) + 0.5)
            valueLabel.Text = tostring(newVal)
            inputBox.Text = tostring(newVal)
            -- update through callback later
            if container._onChange then container._onChange(newVal) end
        end
    end)

    -- click on bar to set position
    barBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local absSize = barBG.AbsoluteSize.X
            local relative = math.clamp((input.Position.X - barBG.AbsolutePosition.X) / absSize, 0, 1)
            fill:TweenSize(UDim2.new(relative, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
            sliderBtn:TweenPosition(UDim2.new(relative - 0.03, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
            local newVal = math.floor((relative * maxValue) + 0.5)
            valueLabel.Text = tostring(newVal)
            inputBox.Text = tostring(newVal)
            if container._onChange then container._onChange(newVal) end
        end
    end)

    -- typing in the input box
    inputBox.FocusLost:Connect(function(enter)
        local num = tonumber(inputBox.Text)
        if num then
            num = math.clamp(math.floor(num + 0.5), 0, maxValue)
            local relative = num / maxValue
            fill:TweenSize(UDim2.new(relative, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
            sliderBtn:TweenPosition(UDim2.new(relative - 0.03, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
            valueLabel.Text = tostring(num)
            inputBox.Text = tostring(num)
            if container._onChange then container._onChange(num) end
        else
            inputBox.Text = valueLabel.Text
        end
    end)

    return {
        Container = container,
        SetOnChange = function(fn) container._onChange = fn end,
        SetValue = function(v)
            local relative = math.clamp((v or 0)/maxValue, 0, 1)
            fill.Size = UDim2.new(relative, 0, 1, 0)
            sliderBtn.Position = UDim2.new(relative - 0.03, 0, 0, 0)
            valueLabel.Text = tostring(math.floor(v+0.5))
            inputBox.Text = tostring(math.floor(v+0.5))
        end,
        GetValue = function()
            return tonumber(valueLabel.Text) or 0
        end
    }
end

-- create sliders and wire to humanoid
local walkSlider = createSlider(cardContent, 0, "WalkSpeed", 16, 200)
local jumpSlider = createSlider(cardContent, 86, "JumpPower", 50, 300)

-- humanoid handling
local humanoid = nil
local function setHumanoid(char)
    if not char then return end
    humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if humanoid then
        -- populate sliders from humanoid values
        walkSlider.SetValue(humanoid.WalkSpeed or 16)
        jumpSlider.SetValue(humanoid.JumpPower or 50)
    end
end

if player.Character then setHumanoid(player.Character) end
player.CharacterAdded:Connect(setHumanoid)

-- apply changes to humanoid
walkSlider.SetOnChange(function(val)
    if humanoid then
        humanoid.WalkSpeed = math.clamp(val, 0, 200)
    end
end)
jumpSlider.SetOnChange(function(val)
    if humanoid then
        humanoid.JumpPower = math.clamp(val, 0, 300)
    end
end)

-- Allow immediate apply when pressing Enter in input boxes (they call FocusLost already)

-- Top-right avatar badge (rounded with purple outline)
local badge = Instance.new("Frame", mainFrame)
badge.Size = UDim2.new(0, 68, 0, 68)
badge.Position = UDim2.new(1, -86, 0, 12)
badge.BackgroundTransparency = 1

local badgeImg = Instance.new("ImageLabel", badge)
badgeImg.Size = UDim2.new(0, 56, 0, 56)
badgeImg.Position = UDim2.new(0.5, -28, 0, 0)
badgeImg.BackgroundColor3 = Color3.fromRGB(20,20,22)
badgeImg.BorderSizePixel = 0
badgeImg.Image = ""
badgeImg.ImageTransparency = 1
styleRounded(badgeImg, 12)

-- purple outline
local outline = Instance.new("Frame", badge)
outline.Size = UDim2.new(0, 64, 0, 64)
outline.Position = UDim2.new(0.5, -32, 0, -4)
outline.BackgroundTransparency = 1
local stroke = Instance.new("UIStroke", outline)
stroke.Color = Color3.fromRGB(150, 100, 240)
stroke.Thickness = 3
stroke.Transparency = 0.12

-- make mainFrame draggable via TitleBar area (use TitleLabel area inside left top of mainFrame)
local dragRoot = mainFrame
local dragging = false
local dragStart = nil
local startPos = nil
local dragInput = nil

-- We'll use the topBevel area + a small invisible drag handle covering header region
local dragHandle = Instance.new("Frame", mainFrame)
dragHandle.Size = UDim2.new(1, 0, 0, 46)
dragHandle.Position = UDim2.new(0, 0, 0, 6)
dragHandle.BackgroundTransparency = 1
dragHandle.Active = true

dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = dragRoot.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

dragHandle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging and dragStart and startPos then
        local delta = input.Position - dragStart
        dragRoot.Position = UDim2.new(
            math.clamp(startPos.X.Scale, 0, 1),
            startPos.X.Offset + delta.X,
            math.clamp(startPos.Y.Scale, 0, 1),
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Shortcut: close on Esc
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        if ScreenGui.Parent then ScreenGui:Destroy() end
    end
end)

-- Little confirmation print
print("✅ Xeno Hub UI created. Waiting for loading to finish...")
