--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]

-- Function to set camera occlusion mode
local function ncamera()
    local ps = game:GetService("Players")
    local lp = ps.LocalPlayer

    lp.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
end

-- Initialize camera settings
ncamera()

-- Connect to CharacterAdded event to reset camera settings when the character is added
local ps = game:GetService("Players")
local lp = ps.LocalPlayer

lp.CharacterAdded:Connect(function()
    ncamera()
end)

local hasExecutedBadeplate = false
local hasExecutedMcfling2 = false
local hasExecutedMicupfliin = false

if not hasExecutedBadeplate then
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Badeplate"))()
    end)
    
    if not success then
        warn("Failed to load Badeplate script: " .. err)
    else
        hasExecutedBadeplate = true
    end
end

if not hasExecutedMcfling2 then
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Mcfling2"))()
    end)
    
    if not success then
        warn("Failed to load Mcfling2 script: " .. err)
    else
        hasExecutedMcfling2 = true
    end
end

if not hasExecutedMicupfliin then
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Alikhammass/MyAdmin/refs/heads/main/Micupfliin"))()
    end)
    
    if not success then
        warn("Failed to load Micupfliin script: " .. err)
    else
        hasExecutedMicupfliin = true
    end
end

local flingForce = 999999999999999
local spinPower = 9999999999999999
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")
local physicsService = game:GetService("PhysicsService")
local partsToAlign = {}
local selectedPart = nil
local isAlive = true
local originalPosition = humanoidRootPart.Position

-- Setup collision groups for player interactions
local function setupCollisionGroups()
    if not physicsService:CollisionGroupExists("BypassBarrier") then
        physicsService:CreateCollisionGroup("BypassBarrier")
    end
    
    if not physicsService:CollisionGroupExists("Barrier") then
        physicsService:CreateCollisionGroup("Barrier")
    end
    
    -- Set collision rules: BypassBarrier should not collide with Barrier
    physicsService:CollisionGroupSetCollidable("BypassBarrier", "Barrier", false)
end

local function configurePart(part)
    part.Transparency = 1  -- Set to invisible
    part.CanCollide = false
    physicsService:SetPartCollisionGroup(part, "BypassBarrier")  -- Set the part to the "BypassBarrier" collision group
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
    ap.Responsiveness = 1000
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

local function handlePart(v)
    if v:IsA("BasePart") and not v.Anchored and not game.Players:GetPlayerFromCharacter(v.Parent) then
        v:ClearAllChildren()
        v.CanCollide = false
        local part = Instance.new("Part", v)
        part.CFrame = v.CFrame
        part.CanCollide = false
        part.Anchored = true
        part.Size = v.Size + Vector3.new(0.1, 0.1, 0.1)
        part.Transparency = 1  -- Set to invisible
        configurePart(part)
        align(v, part)
        spawn(function()
            applyFlingForce(part)
        end)

        -- Set up collision groups
        physicsService:CreateCollisionGroup("LocalPlayer")
        physicsService:CreateCollisionGroup("OtherPlayers")
        physicsService:CollisionGroupSetCollidable("LocalPlayer", "LocalPlayer", false)
        physicsService:CollisionGroupSetCollidable("LocalPlayer", "OtherPlayers", false)
        physicsService:CollisionGroupSetCollidable("OtherPlayers", "OtherPlayers", true)
        physicsService:CollisionGroupSetCollidable("OtherPlayers", "LocalPlayer", false)
        physicsService:SetPartCollisionGroup(part, "LocalPlayer")
        table.insert(partsToAlign, part)
        
        -- Teleport to part when detached
        rs.RenderStepped:Connect(function()
            if part and humanoidRootPart and (part.Position - humanoidRootPart.Position).Magnitude > 5 then
                humanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 5, 0) -- Teleport to the part if it detaches
            end
        end)
    end
end

-- Search for the first unanchored model named "Part"
for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") and not v.Anchored and v.Name == "Part" then
        selectedPart = v -- Find the first valid unanchored part
        break
    end
end

if selectedPart then
    handlePart(selectedPart)  -- Handle the found part
else
    warn("No unanchored part named 'Part' found.")
end

local function freezePlayer(duration)
    humanoidRootPart.Anchored = true
    task.wait(duration)
    humanoidRootPart.Anchored = false
end

local function returnPartsToPlayer()
    for _, part in ipairs(partsToAlign) do
        if part and part.Parent then
            part.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end

-- Character events
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    isAlive = true
    for _, part in ipairs(partsToAlign) do
        if part and part.Parent then
            align(part.Parent, part)
        end
    end
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
