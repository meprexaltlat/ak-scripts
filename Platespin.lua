local spinPower = 800  -- Spin power
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TouchInputService")
local partsToAlign = {}
local isAlive = true
local originalPosition = humanoidRootPart.Position

-- Create and configure the "Void" part
local Void = Instance.new("Part")
Void.Parent = workspace.Terrain
Void.Name = "Void"
Void.Transparency = 1  -- Make it invisible, adjust if needed
Void.Anchored = true
Void.Size = Vector3.new(2048, 1, 2048)
Void.Position = Vector3.new(0, workspace.FallenPartsDestroyHeight, 0)
Void.Locked = true
Void.CanCollide = true  -- Ensure you can walk on it

-- Update the "Void" position to follow the player
spawn(function()
    while true do
        pcall(function()
            if humanoidRootPart then
                Void.Position = Vector3.new(humanoidRootPart.Position.X, workspace.FallenPartsDestroyHeight, humanoidRootPart.Position.Z)
            end
        end)
        task.wait(0)
    end
end)

-- Function to make blue parts invisible and set collision properties
local function configureBlueParts(part)
    part.Transparency = 1  -- Make the part invisible
    part.CanCollide = false  -- Ensure the player cannot collide with it
end

-- Function to align parts to follow the player
local function align(Part0, Part1)
    Part0.CustomPhysicalProperties = PhysicalProperties.new(0.1, 0.1, 0.1, 0.1, 0.1)

    local att1 = Instance.new("Attachment")
    att1.Orientation = Vector3.new(0, 0, 0)
    att1.Position = Vector3.new(0, 0, 0)
    att1.Archivable = true
    local att0 = att1:Clone()

    local ap = Instance.new("AlignPosition", att0)
    ap.ApplyAtCenterOfMass = true
    ap.MaxForce = 9e9
    ap.MaxVelocity = 9e9
    ap.ReactionForceEnabled = false
    ap.Responsiveness = 200
    ap.RigidityEnabled = false

    local ao = Instance.new("AlignOrientation", att0)
    ao.MaxAngularVelocity = 9e9
    ao.MaxTorque = 9e9
    ao.PrimaryAxisOnly = false
    ao.ReactionTorqueEnabled = false
    ao.Responsiveness = 200
    ao.RigidityEnabled = false

    ap.Attachment1 = att1
    ap.Attachment0 = att0
    ao.Attachment1 = att1
    ao.Attachment0 = att0

    att1.Parent = Part1
    att0.Parent = Part0
    
    spawn(function()
        while rs.Heartbeat:Wait() and Part0 and Part0.Parent do
            if humanoidRootPart and isAlive then
                Part1.Position = humanoidRootPart.Position
            end
        end
    end)
end

-- Spin parts with a given power
local function spinPart(part, power)
    while true do
        if part.Parent and isAlive then
            part.CFrame = part.CFrame * CFrame.Angles(0, math.rad(power), 0)
        end
        rs.RenderStepped:Wait()
    end
end

-- Function to handle parts named "Wobbly"
local function handlePart(v)
    if v.Name ~= "Wobbly" then
        return
    end

    v:ClearAllChildren()
    v.CanCollide = false  -- Ensure the part doesn't collide with other objects
    
    -- Set CFrames for the Wobbly parts based on their positions
    local newCFrames = {
        CFrame.new(87.8022995, 233.506561, -28.0461788, 0.0211223252, 2.18218588e-06, -0.9997769, 0.706885397, 0.707170367, 0.0149359386, 0.707012653, -0.707043171, 0.0149355391),
        CFrame.new(87.8022995, 233.506561, -28.0461788, 0.0211275108, -7.10994097e-10, -0.999776781, -0.000931725313, 0.999999583, -1.96901419e-05, 0.999776363, 0.000931933348, 0.0211275015),
        CFrame.new(87.8022995, 233.506561, -28.0461788, 0.021118952, 1.32023808e-06, -0.999776959, 0.866299808, -0.499189168, 0.0182987675, -0.499077797, -0.866493046, -0.0105434963)
    }

    -- Set the CFrame of the part
    v.CFrame = newCFrames[#partsToAlign + 1]  -- Set the CFrame based on the current count of aligned parts

    local part = Instance.new("Part", v)
    part.CFrame = v.CFrame
    part.CanCollide = false  -- Ensure the player cannot collide with it
    part.Anchored = true
    part.Size = v.Size + Vector3.new(0.1, 0.1, 0.1)
    part.Transparency = 0.5
    
    configureBlueParts(part)  -- Make blue parts invisible and non-collidable
    align(v, part)
    spawn(function()
        spinPart(part, spinPower)  -- Spin power of 800
    end)

    table.insert(partsToAlign, part)
end

-- Apply functions to all "Wobbly" parts in the workspace
for _, v in pairs(workspace:GetChildren()) do
    handlePart(v)
end

-- Function to freeze the player for a brief moment
local function freezePlayer(duration)
    humanoidRootPart.Anchored = true
    task.wait(duration)
    humanoidRootPart.Anchored = false
end

-- Teleport to the clicked orange plate or player and back to the original position
local function teleportToAndBack(part)
    local initialPosition = humanoidRootPart.Position
    humanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)  -- Teleport above the plate/player
    freezePlayer(1)  -- Freeze player for 1 second to prevent falling
    task.wait(1)  -- Wait for 1 second at the part/player
    humanoidRootPart.CFrame = CFrame.new(initialPosition)  -- Teleport back to original position
end

-- Detect tapping on orange plates or players (mobile)
local function onTouchTap(touchPositions, gameProcessedEvent)
    if not gameProcessedEvent then
        local touch = touchPositions[1]
        local touchLocation = uis:GetMouseLocation()  -- Get where the touch occurred
        local ray = workspace.CurrentCamera:ViewportPointToRay(touchLocation.X, touchLocation.Y, 0)
        local part, position = workspace:FindPartOnRayWithIgnoreList(Ray.new(ray.Origin, ray.Direction * 5000), {player.Character})

        if part and (part.BrickColor == BrickColor.new("Bright orange") or game.Players:GetPlayerFromCharacter(part.Parent)) then
            teleportToAndBack(part)
        end
    end
end

uis.TouchTap:Connect(onTouchTap)

-- Handle player respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    isAlive = true

    -- Reapply alignment after respawn
    for _, part in ipairs(partsToAlign) do
        if part and part.Parent then
            align(part.Parent, part)
        end
    end
end)

-- Handle player death
character:WaitForChild("Humanoid").Died:Connect(function()
    isAlive = false
end)
