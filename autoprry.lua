------------------------------------------
-- Ultimate High-Speed, Lag-Compensated Parry Script
-- With Aggressive Spamming for Extremely High-Speed Balls
------------------------------------------
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer

local Parried = false
local Connection = nil

-- Returns the ball marked as the "realBall"
local function GetBall()
    for _, Ball in ipairs(workspace.Balls:GetChildren()) do
        if Ball:GetAttribute("realBall") then
            return Ball
        end
    end
end

-- Create (or return an existing) parry visualizer.
-- It appears normally only when it’s your turn.
local playerVisualizer = nil
local function getOrCreatePlayerVisualizer()
    if playerVisualizer and playerVisualizer.Parent then
        return playerVisualizer
    end
    local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end

    playerVisualizer = Instance.new("Part")
    playerVisualizer.Name = "ParryVisualizer"
    playerVisualizer.Shape = Enum.PartType.Ball
    playerVisualizer.Anchored = true
    playerVisualizer.CanCollide = false
    playerVisualizer.Transparency = 0.5  -- visible when it's your turn
    playerVisualizer.Material = Enum.Material.Neon
    playerVisualizer.Color = Color3.new(1, 1, 1) -- default white
    playerVisualizer.Parent = workspace
    
    return playerVisualizer
end

-- Reset any previous connection.
local function ResetConnection()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
end

-- Listen for new balls being added. Reset parry state when the ball's target changes.
workspace.Balls.ChildAdded:Connect(function(child)
    local Ball = GetBall()
    if not Ball then return end
    ResetConnection()
    Connection = Ball:GetAttributeChangedSignal("target"):Connect(function()
        Parried = false
    end)
end)

-- Enhanced spamming function.
-- Sends parry inputs in a burst over a short duration.
local function spamParryBurst(spamCount)
    coroutine.wrap(function()
        local burstDuration = 0.1  -- total time (in seconds) to spread out the spamming
        local delayBetween = burstDuration / spamCount
        for i = 1, spamCount do
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            task.wait(delayBetween)
        end
    end)()
end

-- Main update loop
RunService.PreSimulation:Connect(function()
    local Ball = GetBall()
    local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not HRP or not Ball then return end

    -- Only proceed if it’s your turn.
    local isMyTurn = (Ball:GetAttribute("target") == Player.Name)
    local viz = getOrCreatePlayerVisualizer()
    if viz then
        if isMyTurn then
            viz.Transparency = 0.5  -- show visualizer when it’s your turn
            viz.CFrame = HRP.CFrame
        else
            viz.Transparency = 1    -- hide when not your turn
            return
        end
    end

    -- Scale visualization based on distance.
    local minVizScale = 5         -- minimum diameter
    local maxVizScale = 20        -- maximum diameter
    local maxVizDistance = 100    -- distance at which scale is minimum
    local distance = (HRP.Position - Ball.Position).Magnitude
    local ratio = 1 - math.clamp(distance / maxVizDistance, 0, 1)
    local scaleFactor = minVizScale + (maxVizScale - minVizScale) * ratio
    viz.Size = Vector3.new(scaleFactor, scaleFactor, scaleFactor)

    -- Determine duel mode: if the ball is targeting another nearby player.
    local duelMode = false
    local targetName = Ball:GetAttribute("target")
    if targetName and targetName ~= Player.Name then
        local targetPlayer = Players:FindFirstChild(targetName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = targetPlayer.Character.HumanoidRootPart
            if (HRP.Position - targetHRP.Position).Magnitude < 15 then
                duelMode = true
            end
        end
    end

    -- Lag compensation: get your current ping.
    local pingMs = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() or 0
    local ping = pingMs / 1000  -- convert ms to seconds

    local v = Ball.zoomies.VectorVelocity
    local ballSpeed = v.Magnitude
    local gravity = Vector3.new(0, -workspace.Gravity, 0)
    -- Compensate ball position for network lag.
    local compensatedPos = Ball.Position + v * ping + 0.5 * gravity * (ping ^ 2)

    -- Enhanced predictive collision calculation.
    local parryRadius = 5                   -- effective parry sphere radius
    local baseParryTimeThreshold = 0.55       -- base time window (seconds)
    local chainCount = Ball:GetAttribute("chainCount") or 0
    local effectiveParryTimeThreshold = math.max(0.2, baseParryTimeThreshold - 0.05 * chainCount)
    
    local collisionFound = false
    local tCollision = math.huge

    -- For extremely high speeds, use an analytical quadratic solution (ignoring gravity).
    local HIGH_SPEED_THRESHOLD = 150
    if ballSpeed > HIGH_SPEED_THRESHOLD then
        local d = compensatedPos - HRP.Position
        local a = v:Dot(v)
        local b = 2 * d:Dot(v)
        local c = d:Dot(d) - parryRadius^2
        local disc = b*b - 4*a*c
        if disc >= 0 then
            local sqrtDisc = math.sqrt(disc)
            local t1 = (-b - sqrtDisc) / (2 * a)
            local t2 = (-b + sqrtDisc) / (2 * a)
            local candidate = math.huge
            if t1 > 0 then candidate = math.min(candidate, t1) end
            if t2 > 0 then candidate = math.min(candidate, t2) end
            if candidate < math.huge then
                tCollision = candidate
                collisionFound = true
            end
        end
    else
        -- Adaptive iterative simulation with interpolation:
        local dt = math.max(0.0001, 1 / (ballSpeed * 100)) -- even smaller dt for high speeds
        local lastDistance = (compensatedPos - HRP.Position).Magnitude
        for t = 0, effectiveParryTimeThreshold, dt do
            local predictedPos = compensatedPos + v * t + 0.5 * gravity * t^2
            local d = (predictedPos - HRP.Position).Magnitude

            if d <= parryRadius then
                if t == 0 then
                    tCollision = 0
                else
                    local tPrev = t - dt
                    local ratioInterp = (lastDistance - parryRadius) / math.max((lastDistance - d), 0.00001)
                    tCollision = tPrev + ratioInterp * dt
                end
                collisionFound = true
                break
            end
            lastDistance = d
        end
    end

    -- Aggressive fallback: if no collision was found by simulation but the ball is very close and insanely fast,
    -- trigger parry immediately.
    if (not collisionFound) and ((Ball.Position - HRP.Position).Magnitude <= parryRadius * 1.2) and (ballSpeed > HIGH_SPEED_THRESHOLD) then
        tCollision = 0
        collisionFound = true
    end

    local canParry = collisionFound and (tCollision <= effectiveParryTimeThreshold)

    -- Update visualizer color based on readiness.
    if viz then
        if duelMode or canParry then
            viz.Color = Color3.new(0, 1, 0)  -- green indicates ready
        else
            viz.Color = Color3.new(1, 0, 0)  -- red indicates not ready
        end
    end

    -- Execute parry input.
    if duelMode then
        -- In duel mode, use enhanced spamming.
        local minSpamCount = 10   -- increased baseline count
        local maxSpamCount = 50   -- increased maximum count
        local urgencyFactor = (effectiveParryTimeThreshold - tCollision) / effectiveParryTimeThreshold
        urgencyFactor = math.clamp(urgencyFactor, 0, 1)
        local dynamicSpamCount = math.floor(minSpamCount + urgencyFactor * (maxSpamCount - minSpamCount))
        
        local speedMultiplier = math.clamp(ballSpeed / 50, 1, 3)  -- allow up to 3x multiplier
        dynamicSpamCount = math.floor(dynamicSpamCount * speedMultiplier)
        dynamicSpamCount = math.clamp(dynamicSpamCount, minSpamCount, maxSpamCount)
        
        spamParryBurst(dynamicSpamCount)
    elseif canParry then
        -- For extremely high-speed balls outside of duel mode, if collision is imminent,
        -- use an aggressive burst instead of a single input.
        if ballSpeed > HIGH_SPEED_THRESHOLD and tCollision <= 0.05 then
            local aggressiveSpamCount = 50
            spamParryBurst(aggressiveSpamCount)
        else
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        Parried = true
        Ball:SetAttribute("chainCount", chainCount + 1)
        task.delay(1, function() Parried = false end)
    end
end)
