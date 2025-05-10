local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local targetCharacter
local loopConnection
local alignOrientation

local function createAlignOrientation(part)
    -- Destroy any existing AlignOrientation to avoid duplicates
    if alignOrientation then
        alignOrientation:Destroy()
        alignOrientation = nil
    end

    -- Create a new AlignOrientation for smooth rotation
    alignOrientation = Instance.new("AlignOrientation")
    alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOrientation.RigidityEnabled = false  -- Smooth rotation
    alignOrientation.MaxTorque = 50000    -- Reduced from math.huge
    alignOrientation.Responsiveness = 10  -- Reduced from 15
    alignOrientation.Parent = part

    -- Use a unique attachment to avoid conflicts with existing systems
    local existingAttachment = part:FindFirstChild("CustomAlignAttachment")
    if not existingAttachment then
        local attachment = Instance.new("Attachment")
        attachment.Name = "CustomAlignAttachment" -- Unique name to avoid conflicts
        attachment.Parent = part
        alignOrientation.Attachment0 = attachment
    else
        alignOrientation.Attachment0 = existingAttachment
    end
end

local function startLookingAt(targetName)
    -- Find the target player by partial display name
    for _, target in pairs(Players:GetPlayers()) do
        if string.find(target.DisplayName:lower(), targetName:lower()) then
            targetCharacter = target.Character
            break
        end
    end

    -- Clean up any previous connections and AlignOrientation instances
    if loopConnection then
        loopConnection:Disconnect()
        loopConnection = nil
    end
    if alignOrientation then
        alignOrientation:Destroy()
        alignOrientation = nil
    end

    -- Start a new look-at loop if a valid target is found
    if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
        local character = player.Character or player.CharacterAdded:Wait()
        local upperTorso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Head")

        -- Create AlignOrientation on UpperTorso or Head
        if upperTorso then
            createAlignOrientation(upperTorso)
        end

        loopConnection = RunService.Heartbeat:Connect(function()
            if upperTorso and targetCharacter:FindFirstChild("HumanoidRootPart") then
                -- Calculate the direction to the target’s position
                local targetPosition = targetCharacter.HumanoidRootPart.Position
                local lookDirection = (targetPosition - upperTorso.Position).Unit
                
                -- Limit the vertical rotation to prevent excessive tilting
                local horizontalLookDirection = Vector3.new(lookDirection.X, 0, lookDirection.Z).Unit
                local clampedLookDirection = Vector3.new(horizontalLookDirection.X, math.clamp(lookDirection.Y, -0.3, 0.3), horizontalLookDirection.Z)
                
                -- Add distance check to prevent looking when too close
                local distance = (targetPosition - upperTorso.Position).Magnitude
                if distance > 2 then -- Only look if target is more than 2 studs away
                    alignOrientation.CFrame = CFrame.lookAt(upperTorso.Position, upperTorso.Position + clampedLookDirection)
                end
            end
        end)
    end
end

local function stopLooking()
    -- Disconnect the loop connection and clean up AlignOrientation
    if loopConnection then
        loopConnection:Disconnect()
        loopConnection = nil
    end
    if alignOrientation then
        alignOrientation:Destroy()
        alignOrientation = nil
    end
    targetCharacter = nil
end

-- Listen for chat commands and handle start/stop commands
player.Chatted:Connect(function(message)
    if message:sub(1, 7) == "/lookat" then
        local targetName = message:sub(9) -- Extract the target name after the command
        if targetName and #targetName > 0 then
            startLookingAt(targetName)
        end
    elseif message == "/unlookat" then
        stopLooking()
    end
end)
