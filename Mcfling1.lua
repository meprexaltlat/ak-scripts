local flingForce = 100000
local spinPower = 100000
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")
local physicsService = game:GetService("PhysicsService")
local selectedPart = nil
local isAlive = true

-- Setup collision groups for player interactions
local function setupCollisionGroups()
    if not physicsService:CollisionGroupExists("LocalPlayer") then
        physicsService:CreateCollisionGroup("LocalPlayer")
    end

    if not physicsService:CollisionGroupExists("OtherPlayers") then
        physicsService:CreateCollisionGroup("OtherPlayers")
    end

    -- Set collision rules
    physicsService:CollisionGroupSetCollidable("LocalPlayer", "LocalPlayer", false)
    physicsService:CollisionGroupSetCollidable("LocalPlayer", "OtherPlayers", false)
    physicsService:CollisionGroupSetCollidable("OtherPlayers", "OtherPlayers", true)
    physicsService:CollisionGroupSetCollidable("OtherPlayers", "LocalPlayer", false)
end

local function configurePart(part)
    part.Transparency = 0.5  -- Set part to slightly transparent
    part.CanCollide = false
    physicsService:SetPartCollisionGroup(part, "LocalPlayer")  -- Set the part to the "LocalPlayer" collision group
end

local function applyFlingForce(part)
    while true do
        if part.Parent and isAlive then
            local randomDirection = Vector3.new(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1).unit
            for i = 1, 10 do
                local bodyVelocity = Instance.new("BodyVelocity", part)
                bodyVelocity.Velocity = randomDirection * flingForce
                bodyVelocity.MaxForce = Vector3.new(flingForce, flingForce, flingForce)
                local bodyVelocityOpposite = bodyVelocity:Clone()
                bodyVelocityOpposite.Velocity = -randomDirection * flingForce
                bodyVelocityOpposite.Parent = part
                task.wait(0.05)
                bodyVelocity:Destroy()  -- Clean up after use
                bodyVelocityOpposite:Destroy()
            end
        end
        rs.RenderStepped:Wait()
    end
end

-- Attach the part to the player using AlignPosition and AlignOrientation
local function align(Part0, Part1)
    if not (Part0 and Part1) then return end -- Check if parts are valid

    Part0.CustomPhysicalProperties = PhysicalProperties.new(0.1, 0.1, 0.1, 0.1, 0.1)
    local att1 = Instance.new("Attachment", Part1)
    local att0 = Instance.new("Attachment", Part0)

    local ap = Instance.new("AlignPosition", att0)
    ap.ApplyAtCenterOfMass = true
    ap.MaxForce = 99e9
    ap.MaxVelocity = 99e9
    ap.ReactionForceEnabled = false
    ap.Responsiveness = 200
    ap.RigidityEnabled = false
    ap.Attachment0 = att0
    ap.Attachment1 = att1

    local ao = Instance.new("AlignOrientation", att0)
    ao.MaxAngularVelocity = 99e9
    ao.MaxTorque = 99e9
    ao.PrimaryAxisOnly = false
    ao.ReactionTorqueEnabled = false
    ao.Responsiveness = 200
    ao.RigidityEnabled = false
    ao.Attachment0 = att0
    ao.Attachment1 = att1

    spawn(function()
        while rs.Heartbeat:Wait() and Part0 and Part0.Parent do
            if humanoidRootPart and isAlive then
                Part1.Position = humanoidRootPart.Position
            end
        end
    end)
end

-- Search for the first unanchored model named "Part"
for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") and not v.Anchored and v.Name == "Part" then
        selectedPart = v -- Find the first valid unanchored part
        break
    end
end

if selectedPart then
    selectedPart.CanCollide = false  -- Ensure the selected part doesn't collide
    configurePart(selectedPart)  -- Set transparency and collision properties
    align(selectedPart, humanoidRootPart)  -- Align the selected part with the player
    spawn(function()
        applyFlingForce(selectedPart)  -- Apply fling force to the selected part
    end)

    -- Teleport to the part when it detaches
    rs.RenderStepped:Connect(function()
        if selectedPart and humanoidRootPart and (selectedPart.Position - humanoidRootPart.Position).Magnitude > 5 then
            humanoidRootPart.CFrame = selectedPart.CFrame + Vector3.new(0, 5, 0) -- Teleport to the part if it detaches
        end
    end)
else
    warn("No unanchored part named 'Part' found.")
end

-- Character events
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    isAlive = true
end)

character:WaitForChild("Humanoid").Died:Connect(function()
    isAlive = false
end)

-- Setup collision groups
setupCollisionGroups()

-- Ensure the script runs smoothly across servers
if humanoidRootPart then
    humanoidRootPart.AncestryChanged:Connect(function(_, parent)
        if not parent then
            isAlive = false
        end
    end)
end
