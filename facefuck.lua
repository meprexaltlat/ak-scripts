local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local targetHead = nil
local targetPlayer = nil

local FOLLOW_DISTANCE = -0.7
local HEIGHT_OFFSET = 0.8
local MOVEMENT_SPEED = 0.9
local THRUST_SPEED = 0.5
local THRUST_DISTANCE = 1.5

-- Walking detection thresholds
local WALKING_DETECTION_THRESHOLD = 0.3 -- Minimum distance to consider as walking
local POSITION_HISTORY_SIZE = 3 -- Number of positions to track
local CHECK_INTERVAL = 0.1 -- Time between walk checks in seconds

-- Variables for tracking target walking
local targetPositionHistory = {}
local targetIsWalking = false
local lastWalkCheckTime = 0

getgenv().facefuckactive = false

-- Enhanced function to completely disable all animations
local function disableAllAnimations(character)
    if not character then return end
    
    -- Disable main Animate script
    local animate = character:FindFirstChild("Animate")
    if animate then
        animate.Disabled = true
        
        -- Disable all animation tracks
        for _, child in ipairs(animate:GetChildren()) do
            if child:IsA("StringValue") then
                child.Value = ""
            end
        end
    end
    
    -- Get Humanoid and stop all current animations
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        -- Stop existing animations
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
        
        -- Disable default animations
        humanoid.PlatformStand = true
        humanoid.AutoRotate = false
        
        -- Force idle animation state
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end
    
    -- Disable individual animation controllers
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("LocalScript") and child.Name:match("Controller") then
            child.Disabled = true
        end
    end
    
    -- Set gravity to 0 to prevent falling animation
    workspace.Gravity = 0
end

-- Function to restore animations
local function enableAllAnimations(character)
    if not character then return end
    
    local animate = character:FindFirstChild("Animate")
    if animate then
        animate.Disabled = false
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
    
    -- Re-enable animation controllers
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("LocalScript") and child.Name:match("Controller") then
            child.Disabled = false
        end
    end
    
    workspace.Gravity = 192.2
end

-- Function to check if target is walking by analyzing position history
local function updateTargetWalkingState(head)
    if #targetPositionHistory < POSITION_HISTORY_SIZE then
        table.insert(targetPositionHistory, head.Position)
        return false
    end
    
    -- Shift history and add new position
    table.remove(targetPositionHistory, 1)
    table.insert(targetPositionHistory, head.Position)
    
    -- Calculate total movement distance over time window
    local movementDistance = 0
    for i = 1, #targetPositionHistory - 1 do
        local segment = (targetPositionHistory[i+1] - targetPositionHistory[i]).Magnitude
        movementDistance = movementDistance + segment
    end
    
    -- Check if movement exceeds threshold
    return movementDistance > WALKING_DETECTION_THRESHOLD
end

-- Function to track player respawn and handle retargeting
local function setupCharacterTracking()
    LocalPlayer.CharacterAdded:Connect(function(newCharacter)
        Character = newCharacter
        HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
        
        if getgenv().facefuckactive then
            disableAllAnimations(newCharacter)
            targetHead = findNearestPlayer()
            if targetHead then
                -- Reset tracking variables when retargeting
                targetPositionHistory = {}
                targetIsWalking = false
                task.spawn(function()
                    faceBang(targetHead)
                end)
            else
                print("No nearby player found!")
            end
        end
    end)
end

-- Function to find the nearest player
local function findNearestPlayer()
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        return targetPlayer.Character.Head
    end

    local nearestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local distance = (HumanoidRootPart.Position - head.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = head
                    targetPlayer = player
                end
            end
        end
    end

    if targetPlayer then
        targetPlayer.CharacterAdded:Connect(function(newCharacter)
            if getgenv().facefuckactive then
                local head = newCharacter:WaitForChild("Head")
                targetHead = head
                -- Reset tracking variables when character respawns
                targetPositionHistory = {}
                targetIsWalking = false
                faceBang(head)
            end
        end)
    end

    return nearestPlayer
end

-- Continuous animation prevention
local function setupAnimationPrevention()
    RunService.Heartbeat:Connect(function()
        if getgenv().facefuckactive and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                -- Stop any new animations that might play
                for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
                
                -- Maintain physics state
                humanoid.PlatformStand = true
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end
        end
    end)
end

-- Function to lerp between CFrames
local function lerpCFrame(start, target, alpha)
    return start:Lerp(target, alpha)
end

-- Enhanced fast teleport for distant targets
local function fastTeleportIfDistant(currentPosition, targetPosition)
    local distance = (currentPosition.Position - targetPosition.Position).Magnitude
    
    -- If really far away, teleport closer
    if distance > 15 then
        return targetPosition * CFrame.new(0, 0, 3), true
    end
    
    return targetPosition, false
end

-- Function to move and follow the target with walking detection
local function faceBang(head)
    local lastUpdate = tick()
    targetPositionHistory = {}
    targetIsWalking = false
    
    while getgenv().facefuckactive do
        if not head or not head:IsDescendantOf(workspace) then
            if targetPlayer and targetPlayer.Character then
                head = targetPlayer.Character:WaitForChild("Head")
                targetHead = head
                -- Reset tracking variables when retargeting
                targetPositionHistory = {}
                targetIsWalking = false
            else
                print("Target lost! Retargeting...")
                head = findNearestPlayer()
                if not head then
                    print("No nearby player found!")
                    task.wait(1)
                    continue
                end
            end
        end

        disableAllAnimations(LocalPlayer.Character)

        local distanceToTarget = (head.Position - HumanoidRootPart.Position).Magnitude
        local isApproaching = distanceToTarget > 3
        local currentTime = tick()
        local deltaTime = currentTime - lastUpdate
        lastUpdate = currentTime
        
        -- Update walking state at regular intervals
        if currentTime - lastWalkCheckTime >= CHECK_INTERVAL then
            targetIsWalking = updateTargetWalkingState(head)
            lastWalkCheckTime = currentTime
            
            -- Debug output (can be removed in final version)
            if targetIsWalking then
                -- print("Target is walking")
            else
                -- print("Target is stationary")
            end
        end

        if isApproaching then
            local targetCFrame = head.CFrame * CFrame.new(0, HEIGHT_OFFSET, FOLLOW_DISTANCE) * CFrame.Angles(0, math.rad(180), 0)
            
            -- Check if we need to teleport closer
            local adjustedTarget, didTeleport = fastTeleportIfDistant(HumanoidRootPart.CFrame, targetCFrame)
            
            if didTeleport then
                -- Direct teleport when too far
                HumanoidRootPart.CFrame = adjustedTarget
            else
                -- Regular movement with increased speed
                HumanoidRootPart.CFrame = lerpCFrame(HumanoidRootPart.CFrame, targetCFrame, MOVEMENT_SPEED)
            end
        else
            -- If target is walking, just follow; if stationary, use tweening
            if targetIsWalking then
                -- Simple following mode when target is walking
                local targetCFrame = head.CFrame * CFrame.new(0, HEIGHT_OFFSET, FOLLOW_DISTANCE) * CFrame.Angles(0, math.rad(180), 0)
                HumanoidRootPart.CFrame = lerpCFrame(HumanoidRootPart.CFrame, targetCFrame, MOVEMENT_SPEED * 0.7)
            else
                -- Enhanced tweening for stationary targets
                local positions = {
                    head.CFrame * CFrame.new(0, HEIGHT_OFFSET, FOLLOW_DISTANCE) * CFrame.Angles(0, math.rad(180), 0),
                    head.CFrame * CFrame.new(0, HEIGHT_OFFSET, FOLLOW_DISTANCE - THRUST_DISTANCE) * CFrame.Angles(0, math.rad(180), 0),
                }
                
                for _, targetPosition in ipairs(positions) do
                    if not getgenv().facefuckactive then break end
                    
                    local startTime = tick()
                    while (tick() - startTime) < 0.1 do
                        if not getgenv().facefuckactive then break end
                        -- Use a sine-based easing for smoother motion
                        local progress = (tick() - startTime) / 0.1
                        local easedProgress = math.sin(progress * math.pi * 0.5)
                        HumanoidRootPart.CFrame = lerpCFrame(HumanoidRootPart.CFrame, targetPosition, THRUST_SPEED * easedProgress)
                        RunService.RenderStepped:Wait()
                    end
                end
            end
        end
        
        RunService.RenderStepped:Wait()
    end

    enableAllAnimations(LocalPlayer.Character)
end

-- Function to toggle movement
local function toggleMovement()
    if not getgenv().facefuckactive then
        targetPlayer = nil
        targetHead = findNearestPlayer()
        
        if targetHead then
            getgenv().facefuckactive = true
            disableAllAnimations(LocalPlayer.Character)
            -- Reset tracking variables
            targetPositionHistory = {}
            targetIsWalking = false
            lastWalkCheckTime = tick()
            task.spawn(function()
                faceBang(targetHead)
            end)
        else
            print("No nearby player found!")
        end
    else
        getgenv().facefuckactive = false
        targetPlayer = nil
        targetHead = nil
        enableAllAnimations(LocalPlayer.Character)
    end
end

-- Function to create a mobile GUI button
local function createMobileGUI()
    if not UserInputService.TouchEnabled then return end
    
    if PlayerGui:FindFirstChild("FaceBangGui") then
        PlayerGui.FaceBangGui:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FaceBangGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 45, 0, 45)
    container.Position = UDim2.new(0.95, -25, 0.1, 0)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    container.BorderSizePixel = 0
    container.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.2, 0)
    corner.Parent = container

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
    })
    gradient.Rotation = 45
    gradient.Parent = container

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0.8, 0)
    button.Position = UDim2.new(0.5, 0, 0.5, 0)
    button.AnchorPoint = Vector2.new(0.5, 0.5)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.Text = "F"
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Parent = container

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.2, 0)
    buttonCorner.Parent = button

    local status = Instance.new("Frame")
    status.Size = UDim2.new(0, 6, 0, 6)
    status.Position = UDim2.new(1, -4, 0, 4)
    status.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    status.BorderSizePixel = 0
    status.Parent = container

    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(1, 0)
    statusCorner.Parent = status

    button.MouseButton1Click:Connect(function()
        toggleMovement()
        status.BackgroundColor3 = getgenv().facefuckactive and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    end)
end

-- Add keybind for PC users
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Z then
        toggleMovement()
        -- Update mobile GUI status if it exists
        local gui = PlayerGui:FindFirstChild("FaceBangGui")
        if gui then
            local status = gui.Frame:FindFirstChild("Frame")
            if status then
                status.BackgroundColor3 = getgenv().facefuckactive and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
            end
        end
    end
end)

-- Initialize everything
setupCharacterTracking()
setupAnimationPrevention()
createMobileGUI()
