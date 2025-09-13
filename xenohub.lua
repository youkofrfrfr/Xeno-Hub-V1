-- Roblox Admin System with Mobile Command Prompt
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Create notification UI
local function createNotification(title, message)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdminNotification"
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

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Parent = frame

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 40)
    messageLabel.Position = UDim2.new(0, 10, 0, 40)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.TextSize = 14
    messageLabel.TextWrapped = true
    messageLabel.Parent = frame

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

-- Create mobile command prompt
local function createCommandPrompt()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdminCommandPrompt"
    screenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    
    -- Toggle button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 50)
    toggleButton.Position = UDim2.new(1, -60, 1, -60)
    toggleButton.AnchorPoint = Vector2.new(1, 1)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 40, 140)
    toggleButton.Text = "CMD"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 16
    toggleButton.ZIndex = 10
    toggleButton.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toggleButton
    
    -- Command panel (initially hidden)
    local commandPanel = Instance.new("Frame")
    commandPanel.Size = UDim2.new(0, 300, 0, 200)
    commandPanel.Position = UDim2.new(1, -310, 1, -210)
    commandPanel.AnchorPoint = Vector2.new(1, 1)
    commandPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    commandPanel.BorderSizePixel = 0
    commandPanel.Visible = false
    commandPanel.ZIndex = 5
    commandPanel.Parent = screenGui
    
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 8)
    panelCorner.Parent = commandPanel
    
    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(100, 50, 200)
    panelStroke.Thickness = 2
    panelStroke.Parent = commandPanel
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Admin Commands"
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 6
    title.Parent = commandPanel
    
    -- Input box
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -20, 0, 36)
    inputBox.Position = UDim2.new(0, 10, 0, 50)
    inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 16
    inputBox.PlaceholderText = "Type command here..."
    inputBox.Text = ""
    inputBox.ClearTextOnFocus = false
    inputBox.ZIndex = 6
    inputBox.Parent = commandPanel
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = inputBox
    
    -- Output box
    local outputBox = Instance.new("ScrollingFrame")
    outputBox.Size = UDim2.new(1, -20, 0, 80)
    outputBox.Position = UDim2.new(0, 10, 0, 100)
    outputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    outputBox.BorderSizePixel = 0
    outputBox.ScrollBarThickness = 4
    outputBox.ZIndex = 6
    outputBox.Parent = commandPanel
    
    local outputCorner = Instance.new("UICorner")
    outputCorner.CornerRadius = UDim.new(0, 6)
    outputCorner.Parent = outputBox
    
    local outputText = Instance.new("TextLabel")
    outputText.Size = UDim2.new(1, -10, 1, -10)
    outputText.Position = UDim2.new(0, 5, 0, 5)
    outputText.BackgroundTransparency = 1
    outputText.Text = "Welcome to Admin System. Type 'help' for commands."
    outputText.Font = Enum.Font.Gotham
    outputText.TextColor3 = Color3.fromRGB(200, 200, 200)
    outputText.TextSize = 14
    outputText.TextXAlignment = Enum.TextXAlignment.Left
    outputText.TextYAlignment = Enum.TextYAlignment.Top
    outputText.TextWrapped = true
    outputText.ZIndex = 7
    outputText.Parent = outputBox
    
    -- Toggle panel visibility
    toggleButton.MouseButton1Click:Connect(function()
        commandPanel.Visible = not commandPanel.Visible
    end)
    
    -- Admin command functions
    local adminCommands = {
        help = function()
            return [[Admin Commands:
- help: Show this help
- fly: Toggle flight mode
- speed [number]: Set walk speed
- jump [number]: Set jump power
- noclip: Toggle noclip mode
- god: Toggle god mode (invincibility)
- kill [player]: Kill a player
- bring [player]: Bring a player to you
- goto [player]: Teleport to a player
- tools: Give yourself all tools
- credits: Show script credits]]
        end,
        
        fly = function()
            local character = LocalPlayer.Character
            if not character then return "No character found" end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return "No humanoid found" end
            
            if humanoid:FindFirstChild("BodyVelocity") then
                humanoid.BodyVelocity:Destroy()
                humanoid.PlatformStand = false
                return "Flight disabled"
            else
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = humanoid
                
                humanoid.PlatformStand = true
                return "Flight enabled. Use space and ctrl to fly."
            end
        end,
        
        speed = function(arg)
            local character = LocalPlayer.Character
            if not character then return "No character found" end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return "No humanoid found" end
            
            local speed = tonumber(arg) or 16
            humanoid.WalkSpeed = speed
            return "Walk speed set to " .. speed
        end,
        
        jump = function(arg)
            local character = LocalPlayer.Character
            if not character then return "No character found" end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return "No humanoid found" end
            
            local power = tonumber(arg) or 50
            humanoid.JumpPower = power
            return "Jump power set to " .. power
        end,
        
        noclip = function()
            local character = LocalPlayer.Character
            if not character then return "No character found" end
            
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not part.CanCollide
                end
            end
            
            return "Noclip " .. (character.Head.CanCollide and "disabled" or "enabled")
        end,
        
        god = function()
            local character = LocalPlayer.Character
            if not character then return "No character found" end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return "No humanoid found" end
            
            humanoid.MaxHealth = humanoid.MaxHealth == math.huge and 100 or math.huge
            humanoid.Health = humanoid.MaxHealth
            
            return "God mode " .. (humanoid.MaxHealth == math.huge and "enabled" or "disabled")
        end,
        
        kill = function(arg)
            local target = findPlayer(arg)
            if not target then return "Player not found: " .. (arg or "nil") end
            
            local character = target.Character
            if not character then return target.Name .. " has no character" end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return target.Name .. " has no humanoid" end
            
            humanoid.Health = 0
            return "Killed " .. target.Name
        end,
        
        bring = function(arg)
            local target = findPlayer(arg)
            if not target then return "Player not found: " .. (arg or "nil") end
            
            local character = target.Character
            if not character then return target.Name .. " has no character" end
            
            local root = character:FindFirstChild("HumanoidRootPart")
            if not root then return target.Name .. " has no root part" end
            
            local myCharacter = LocalPlayer.Character
            if not myCharacter then return "You have no character" end
            
            local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
            if not myRoot then return "You have no root part" end
            
            root.CFrame = myRoot.CFrame + Vector3.new(0, 0, 3)
            return "Brought " .. target.Name .. " to you"
        end,
        
        goto = function(arg)
            local target = findPlayer(arg)
            if not target then return "Player not found: " .. (arg or "nil") end
            
            local character = target.Character
            if not character then return target.Name .. " has no character" end
            
            local root = character:FindFirstChild("HumanoidRootPart")
            if not root then return target.Name .. " has no root part" end
            
            local myCharacter = LocalPlayer.Character
            if not myCharacter then return "You have no character" end
            
            local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
            if not myRoot then return "You have no root part" end
            
            myRoot.CFrame = root.CFrame + Vector3.new(0, 0, 3)
            return "Teleported to " .. target.Name
        end,
        
        tools = function()
            for _, tool in pairs(workspace:GetChildren()) do
                if tool:IsA("Tool") then
                    tool:Clone().Parent = LocalPlayer.Backpack
                end
            end
            return "Added all available tools to your backpack"
        end,
        
        credits = function()
            return "Admin System v1.0\nCreated for mobile Roblox\nInspired by Brainrot's admin system"
        end
    }
    
    -- Helper function to find players
    local function findPlayer(name)
        if not name or name == "" then return nil end
        name = name:lower()
        
        if name == "me" then return LocalPlayer end
        if name == "all" then return "all" end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower():find(name) == 1 or 
               player.DisplayName:lower():find(name) == 1 then
                return player
            end
        end
        
        return nil
    end
    
    -- Process commands
    inputBox.FocusLost:Connect(function(enterPressed)
        if not enterPressed then return end
        
        local commandText = inputBox.Text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
        if commandText == "" then return end
        
        -- Add to output
        outputText.Text = outputText.Text .. "\n> " .. commandText
        
        -- Parse command
        local parts = {}
        for part in commandText:gmatch("%S+") do
            table.insert(parts, part:lower())
        end
        
        local command = parts[1]
        local arg = parts[2] and commandText:sub(#command + 2) or nil
        
        -- Execute command
        if adminCommands[command] then
            local success, result = pcall(adminCommands[command], arg)
            if success then
                outputText.Text = outputText.Text .. "\n" .. tostring(result)
            else
                outputText.Text = outputText.Text .. "\nError: " .. tostring(result)
            end
        else
            outputText.Text = outputText.Text .. "\nUnknown command: " .. command .. ". Type 'help' for commands."
        end
        
        -- Clear input
        inputBox.Text = ""
        
        -- Auto-scroll to bottom
        outputBox.CanvasPosition = Vector2.new(0, outputText.TextBounds.Y)
    end)
    
    -- Make panel draggable
    local dragging = false
    local dragStart, startPos
    
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = commandPanel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                commandPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                                 startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    
    return screenGui
end

-- Initialize the system
createNotification("Admin System Loaded", "Your name has been modified. Type commands using the CMD button.")
createOverheadTag()
createCommandPrompt()

print("Admin system activated! Use the CMD button to access commands.")
