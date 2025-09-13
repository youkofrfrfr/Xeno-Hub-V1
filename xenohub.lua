-- Roblox Owner Tag Script
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer

-- Create notification UI
local function createNotification()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "OwnerTagNotification"
    screenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.2, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 50, 200)
    stroke.Thickness = 2
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Owner Tag Activated"
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Parent = frame

    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, -20, 0, 40)
    message.Position = UDim2.new(0, 10, 0, 40)
    message.BackgroundTransparency = 1
    message.Text = "Your name has been modified. Everyone will see the Owner tag next to your name."
    message.Font = Enum.Font.Gotham
    message.TextColor3 = Color3.fromRGB(200, 200, 200)
    message.TextSize = 14
    message.TextWrapped = true
    message.Parent = frame

    -- Animate the notification
    frame:TweenPosition(UDim2.new(0.5, -150, 0.2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
    
    -- Remove after 5 seconds
    task.delay(5, function()
        frame:TweenPosition(UDim2.new(0.5, -150, -0.2, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.5, true)
        task.wait(0.5)
        screenGui:Destroy()
    end)
end

-- Create overhead tag
local function createOverheadTag()
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    
    local character = LocalPlayer.Character
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Create billboard GUI
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "OwnerTag"
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Adornee = humanoidRootPart
    billboardGui.Parent = humanoidRootPart
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = billboardGui
    
    local tag = Instance.new("TextLabel")
    tag.Size = UDim2.new(1, 0, 1, 0)
    tag.BackgroundTransparency = 1
    tag.Text = "[OWNER] " .. LocalPlayer.DisplayName
    tag.Font = Enum.Font.GothamBold
    tag.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold color
    tag.TextSize = 14
    tag.TextStrokeTransparency = 0.5
    tag.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    tag.Parent = frame
    
    -- Update when character changes
    LocalPlayer.CharacterAdded:Connect(function(newCharacter)
        task.wait(1) -- Wait for character to fully load
        if billboardGui then
            billboardGui:Destroy()
        end
        
        local newRoot = newCharacter:WaitForChild("HumanoidRootPart")
        billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "OwnerTag"
        billboardGui.Size = UDim2.new(0, 200, 0, 50)
        billboardGui.StudsOffset = Vector3.new(0, 3, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.Adornee = newRoot
        billboardGui.Parent = newRoot
        
        local newFrame = Instance.new("Frame")
        newFrame.Size = UDim2.new(1, 0, 1, 0)
        newFrame.BackgroundTransparency = 1
        newFrame.Parent = billboardGui
        
        local newTag = Instance.new("TextLabel")
        newTag.Size = UDim2.new(1, 0, 1, 0)
        newTag.BackgroundTransparency = 1
        newTag.Text = "[OWNER] " .. LocalPlayer.DisplayName
        newTag.Font = Enum.Font.GothamBold
        newTag.TextColor3 = Color3.fromRGB(255, 215, 0)
        newTag.TextSize = 14
        newTag.TextStrokeTransparency = 0.5
        newTag.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        newTag.Parent = newFrame
    end)
    
    -- Update when display name changes
    LocalPlayer:GetPropertyChangedSignal("DisplayName"):Connect(function()
        tag.Text = "[OWNER] " .. LocalPlayer.DisplayName
    end)
end

-- Modify chat messages
local function modifyChatMessages()
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        -- For new TextChatService
        local function onIncomingMessage(message)
            if message.TextSource then
                local player = Players:GetPlayerByUserId(message.TextSource.UserId)
                if player and player == LocalPlayer then
                    -- Modify the message to include owner tag
                    message.Text = "[OWNER] " .. message.Text
                end
            end
            return message
        end
        
        TextChatService.OnIncomingMessage = onIncomingMessage
    else
        -- For legacy chat
        local function onChatMessage(message, recipient, speaker)
            if speaker == LocalPlayer.Name then
                return "[OWNER] " .. message
            end
            return message
        end
        
        -- Hook into the chat service
        local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvents then
            local sayMessageRequest = chatEvents:FindFirstChild("SayMessageRequest")
            if sayMessageRequest then
                local oldFireServer = sayMessageRequest.FireServer
                sayMessageRequest.FireServer = function(self, ...)
                    local args = {...}
                    if #args >= 1 then
                        args[1] = "[OWNER] " .. args[1]
                    end
                    return oldFireServer(self, unpack(args))
                end
            end
        end
    end
end

-- Run all functions
createNotification()
createOverheadTag()
modifyChatMessages()

print("Owner tag script activated! Your name will now show with [OWNER] tag in chat and above your character.")
