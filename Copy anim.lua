--[[
Advanced Frame Copier Controller
Features:
- Perfect 1:1 animation synchronization
- Precise character state replication
- Enhanced position and rotation mimicking
- Robust error handling and state management
- Comprehensive GUI with advanced controls
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")

local Player = Players.LocalPlayer

-- Configuration
local CONFIG = {
    SIDE_OFFSET = 4,
    UPDATE_PRIORITY = Enum.RenderPriority.Character.Value,
    DEFAULT_FADE_TIME = 0.1,
    MIN_SYNC_DISTANCE = 0.1,
    MAX_ROTATION_DELTA = math.rad(1),
    INTERPOLATION_SPEED = 0.5
}

-- State Management
local State = {
    copyActive = false,
    targetPlayer = nil,
    isNearest = false,
    animationPairs = {},
    lastUpdate = tick(),
    previousCFrame = nil,
    interpolationTarget = nil
}

-- Animation State Cache
local AnimationCache = {
    weights = {},
    fadeStates = {},
    priorities = {},
    timePositions = {},
    speeds = {}
}

-- Utility Functions
local function getModelMass(model)
    local mass = 0
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            mass = mass + part:GetMass()
        end
    end
    return mass
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function calculateVelocity(currentPos, lastPos, deltaTime)
    return (currentPos - lastPos) / deltaTime
end

-- Enhanced Player Finding
local function getNearestPlayer()
    local char = Player.Character
    if not (char and char:FindFirstChild("HumanoidRootPart")) then
        return nil
    end
    
    local hrp = char.HumanoidRootPart
    local nearestPlayer = nil
    local nearestDistance = math.huge
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if dist < nearestDistance and p.Character:FindFirstChildOfClass("Humanoid") then
                nearestDistance = dist
                nearestPlayer = p
            end
        end
    end
    
    return nearestPlayer
end

-- Enhanced Animation Management
local function createAnimationTracker(targetTrack)
    local id = targetTrack.Animation.AnimationId
    return {
        id = id,
        lastWeight = targetTrack.WeightCurrent,
        lastSpeed = targetTrack.Speed,
        lastTimePosition = targetTrack.TimePosition,
        priority = targetTrack.Priority,
        fadeTime = targetTrack.FadeTime
    }
end

local function synchronizeAnimation(localTrack, targetTrack)
    local tracker = createAnimationTracker(targetTrack)
    
    -- Precise weight synchronization
    if math.abs(localTrack.WeightCurrent - targetTrack.WeightCurrent) > 0.01 then
        localTrack:AdjustWeight(targetTrack.WeightCurrent, targetTrack.FadeTime)
    end
    
    -- Time position synchronization with error correction
    local timeDiff = math.abs(localTrack.TimePosition - targetTrack.TimePosition)
    if timeDiff > 0.03 then
        localTrack.TimePosition = targetTrack.TimePosition
    end
    
    -- Speed synchronization
    localTrack:AdjustSpeed(targetTrack.Speed)
    
    -- Match additional properties
    localTrack.Priority = targetTrack.Priority
    localTrack.Looped = targetTrack.Looped
    
    return tracker
end

local function updateAnimations(targetChar, localChar)
    if not (targetChar and localChar) then return end
    
    local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
    local localHumanoid = localChar:FindFirstChildOfClass("Humanoid")
    if not (targetHumanoid and localHumanoid) then return end
    
    local targetTracks = targetHumanoid:GetPlayingAnimationTracks()
    local updatedPairs = {}
    local seenAnimations = {}
    
    -- Update existing and create new animations
    for _, targetTrack in ipairs(targetTracks) do
        if targetTrack.Animation and targetTrack.Animation.AnimationId ~= "rbxassetid://0" then
            local animId = targetTrack.Animation.AnimationId
            seenAnimations[animId] = true
            
            -- Find or create matching track
            local pair = nil
            for _, existingPair in ipairs(State.animationPairs) do
                if existingPair.targetTrack == targetTrack then
                    pair = existingPair
                    break
                end
            end
            
            if pair then
                synchronizeAnimation(pair.localTrack, targetTrack)
                table.insert(updatedPairs, pair)
            else
                local newAnim = Instance.new("Animation")
                newAnim.AnimationId = animId
                
                local localTrack = localHumanoid:LoadAnimation(newAnim)
                localTrack:Play(targetTrack.FadeTime)
                
                local newPair = {
                    targetTrack = targetTrack,
                    localTrack = localTrack,
                    tracker = synchronizeAnimation(localTrack, targetTrack)
                }
                table.insert(updatedPairs, newPair)
            end
        end
    end
    
    -- Stop unused animations
    for _, pair in ipairs(State.animationPairs) do
        if not seenAnimations[pair.tracker.id] then
            pair.localTrack:Stop(CONFIG.DEFAULT_FADE_TIME)
        end
    end
    
    State.animationPairs = updatedPairs
end

-- Enhanced Character State Management
local function updateCharacterState(localChar, targetChar)
    local localHumanoid = localChar:FindFirstChildOfClass("Humanoid")
    local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
    
    if not (localHumanoid and targetHumanoid) then return end
    
    -- Update humanoid properties
    localHumanoid.WalkSpeed = targetHumanoid.WalkSpeed
    localHumanoid.JumpPower = targetHumanoid.JumpPower
    localHumanoid.AutoRotate = targetHumanoid.AutoRotate
    localHumanoid.JumpHeight = targetHumanoid.JumpHeight
    
    -- State synchronization with error handling
    pcall(function()
        if localHumanoid:GetState() ~= targetHumanoid:GetState() then
            localHumanoid:ChangeState(targetHumanoid:GetState())
        end
    end)
    
    -- Physics property synchronization
    local localHRP = localChar:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    
    if localHRP and targetHRP then
        -- Calculate target position with offset
        local targetCFrame = targetHRP.CFrame
        local offset = targetCFrame.RightVector * CONFIG.SIDE_OFFSET
        local targetPosition = targetCFrame * CFrame.new(offset)
        
        -- Smooth position interpolation
        if State.previousCFrame then
            local deltaTime = tick() - State.lastUpdate
            local interpolationAlpha = math.min(1, deltaTime * CONFIG.INTERPOLATION_SPEED)
            
            localHRP.CFrame = State.previousCFrame:Lerp(targetPosition, interpolationAlpha)
            
            -- Update velocity
            local velocityVector = calculateVelocity(
                targetPosition.Position,
                State.previousCFrame.Position,
                deltaTime
            )
            localHRP.Velocity = velocityVector
            
            -- Match rotation velocity
            localHRP.RotVelocity = targetHRP.RotVelocity
        else
            localHRP.CFrame = targetPosition
        end
        
        State.previousCFrame = targetPosition
        State.lastUpdate = tick()
    end
end

-- Main Update Loop
local function updateCopier()
    if not State.copyActive then return end
    
    local target = State.isNearest and getNearestPlayer() or State.targetPlayer
    if not (target and target.Character and target.Character.Parent) then return end
    
    local localChar = Player.Character
    if not localChar then return end
    
    updateCharacterState(localChar, target.Character)
    updateAnimations(target.Character, localChar)
end

-- Clean Up Function
local function cleanUp()
    State.copyActive = false
    State.previousCFrame = nil
    
    for _, pair in ipairs(State.animationPairs) do
        if pair.localTrack then
            pair.localTrack:Stop(CONFIG.DEFAULT_FADE_TIME)
        end
    end
    State.animationPairs = {}
end

-- Enhanced GUI Creation
local function createEnhancedGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdvancedFrameCopierGUI"
    screenGui.ResetOnSpawn = false
    
    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mainFrame.BorderSizePixel = 0
    
    -- Add UI corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Create title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleBar.BorderSizePixel = 0
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Advanced Frame Copier"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar
    
    -- Create close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -40, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    
    -- Create target input section
    local targetSection = Instance.new("Frame")
    targetSection.Size = UDim2.new(1, -40, 0, 70)
    targetSection.Position = UDim2.new(0, 20, 0, 60)
    targetSection.BackgroundTransparency = 1
    
    local targetLabel = Instance.new("TextLabel")
    targetLabel.Size = UDim2.new(1, 0, 0, 25)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Text = "Target Player:"
    targetLabel.TextColor3 = Color3.new(1, 1, 1)
    targetLabel.TextSize = 16
    targetLabel.Font = Enum.Font.Gotham
    targetLabel.Parent = targetSection
    
    local targetInput = Instance.new("TextBox")
    targetInput.Size = UDim2.new(1, 0, 0, 35)
    targetInput.Position = UDim2.new(0, 0, 0, 35)
    targetInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    targetInput.TextColor3 = Color3.new(1, 1, 1)
    targetInput.PlaceholderText = "Enter player name or 'nearest'"
    targetInput.Text = ""
    targetInput.TextSize = 14
    targetInput.Font = Enum.Font.Gotham
    targetInput.Parent = targetSection
    
    -- Create toggle button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(1, -40, 0, 50)
    toggleButton.Position = UDim2.new(0, 20, 0, 150)
    toggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    toggleButton.Text = "Start Copying"
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.TextSize = 16
    toggleButton.Font = Enum.Font.GothamBold
    
    -- Add all elements to main frame
    titleBar.Parent = mainFrame
    targetSection.Parent = mainFrame
    toggleButton.Parent = mainFrame
    mainFrame.Parent = screenGui
    
    -- Make the frame draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Connect button functionality
    toggleButton.MouseButton1Click:Connect(function()
        State.copyActive = not State.copyActive
        toggleButton.Text = State.copyActive and "Stop Copying" or "Start Copying"
        toggleButton.BackgroundColor3 = State.copyActive and 
            Color3.fromRGB(200, 50, 50) or 
            Color3.fromRGB(45, 45, 45)
        
        if not State.copyActive then
            cleanUp()
        end
    end)
    
    -- Target input handling
    targetInput.FocusLost:Connect(function(enterPressed)
        local text = targetInput.Text:lower()
        if text == "nearest" then
            State.isNearest = true
            State.targetPlayer = nil
            targetInput.Text = "nearest"
        else
            State.isNearest = false
            local foundPlayer = nil
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= Player and (
                    string.find(p.Name:lower(), text) or 
                    string.find(p.DisplayName:lower(), text)
                ) then
                    foundPlayer = p
                    break
                end
            end
            
            if foundPlayer then
                State.targetPlayer = foundPlayer
                targetInput.Text = foundPlayer.Name
            else
                State.targetPlayer = nil
                targetInput.Text = ""
            end
        end
    end)
    
    -- Close button handling
    closeButton.MouseButton1Click:Connect(function()
        cleanUp()
        screenGui:Destroy()
        if copyConnection then
            copyConnection:Disconnect()
        end
    end)
    
    -- Add status indicator
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -40, 0, 25)
    statusLabel.Position = UDim2.new(0, 20, 0, 210)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: Idle"
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = mainFrame
    
    -- Update status text
    local function updateStatus()
        local status = "Idle"
        if State.copyActive then
            if State.targetPlayer or (State.isNearest and getNearestPlayer()) then
                status = "Active - Copying"
            else
                status = "Active - Waiting for target"
            end
        end
        statusLabel.Text = "Status: " .. status
    end
    
    -- Connect status updates
    RunService.Heartbeat:Connect(updateStatus)
    
    return screenGui
end

-- Enhanced Error Handling
local function safeInvoke(callback, ...)
    local success, result = pcall(callback, ...)
    if not success then
        warn("Frame Copier Error:", result)
        return nil
    end
    return result
end

-- Performance Optimization
local function shouldUpdate()
    local currentTime = tick()
    if currentTime - State.lastUpdate < 1/60 then
        return false
    end
    State.lastUpdate = currentTime
    return true
end

-- Main Controller Setup
local function initializeController()
    -- Bind the update function to RunService
    local copyConnection = RunService:BindToRenderStep(
        "AdvancedFrameCopier",
        CONFIG.UPDATE_PRIORITY,
        function()
            if shouldUpdate() then
                safeInvoke(updateCopier)
            end
        end
    )
    
    -- Create keyboard shortcuts
    ContextActionService:BindAction(
        "ToggleFrameCopier",
        function(_, state, _)
            if state == Enum.UserInputState.Begin then
                State.copyActive = not State.copyActive
                if not State.copyActive then
                    cleanUp()
                end
            end
        end,
        false,
        Enum.KeyCode.RightControl
    )
    
    -- Initialize GUI
    local gui = createEnhancedGUI()
    gui.Parent = Player:WaitForChild("PlayerGui")
    
    -- Set up cleanup on character removal
    Player.CharacterRemoving:Connect(function()
        cleanUp()
    end)
    
    return copyConnection
end

-- Additional Helper Functions
local function getAnimationInfo(track)
    return {
        id = track.Animation.AnimationId,
        speed = track.Speed,
        weight = track.WeightCurrent,
        timePosition = track.TimePosition,
        isPlaying = track.IsPlaying
    }
end

local function syncAllProperties(source, target, properties)
    for _, prop in ipairs(properties) do
        pcall(function()
            target[prop] = source[prop]
        end)
    end
end

-- Advanced Physics Synchronization
local function syncPhysics(localPart, targetPart)
    if not (localPart and targetPart) then return end
    
    local physicsProperties = {
        "CustomPhysicalProperties",
        "Friction",
        "Elasticity",
        "FrictionWeight",
        "ElasticityWeight"
    }
    
    syncAllProperties(targetPart, localPart, physicsProperties)
end

-- Initialize everything
local copyConnection = initializeController()

-- Cleanup handling
game:BindToClose(function()
    cleanUp()
    if copyConnection then
        copyConnection:Disconnect()
    end
end)
