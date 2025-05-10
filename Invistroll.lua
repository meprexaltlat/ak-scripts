local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Variables
local ActiveTrolls = {}  -- Store active troll connections

-- Helper function to find player by partial name
local function findPlayer(partialName)
    partialName = partialName:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():match(partialName) or 
           (player.DisplayName and player.DisplayName:lower():match(partialName)) then
            return player
        end
    end
    return nil
end

-- Body Update Function
local function UpdateBody(player, target)
    local character = player.Character
    local targetChar = target.Character
    
    if not character or not targetChar then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoidRootPart or not targetHRP or not humanoid then return end
    
    -- Keep normal walk speed
    humanoid.WalkSpeed = 16
    
    -- Attach to target
    humanoidRootPart.CFrame = targetHRP.CFrame
    
    -- List of body parts to lift
    local bodyParts = {
        "UpperTorso", "LowerTorso",
        "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand",
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
        "RightUpperLeg", "RightLowerLeg", "RightFoot"
    }
    
    -- Lift body parts
    for _, partName in ipairs(bodyParts) do
        local part = character:FindFirstChild(partName)
        if part then
            local currentPos = part.Position
            part.CFrame = part.CFrame * CFrame.new(0, 10, 0)
            part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end
    
    -- Keep head and HumanoidRootPart in place
    local head = character:FindFirstChild("Head")
    if head then
        head.CFrame = head.CFrame
    end
end

-- Chat command handler
Players.PlayerChatted:Connect(function(type, sender, message)
    if not message:sub(1,1) == "!" then return end
    
    local args = message:split(" ")
    local command = args[1]:lower()
    
    if command == "!invistroll" then
        if #args < 2 then
            -- Notify player they need to specify a target
            return
        end
        
        local targetName = args[2]
        local target = findPlayer(targetName)
        
        if not target then
            -- Notify player that target wasn't found
            return
        end
        
        -- Stop any existing troll for this player
        if ActiveTrolls[sender.UserId] then
            ActiveTrolls[sender.UserId]:Disconnect()
        end
        
        -- Start new troll
        ReplicatedStorage.RagdollEvent:FireServer()
        ActiveTrolls[sender.UserId] = RunService.Heartbeat:Connect(function()
            UpdateBody(sender, target)
        end)
        
    elseif command == "!uninvistroll" then
        -- Stop troll if active
        if ActiveTrolls[sender.UserId] then
            ActiveTrolls[sender.UserId]:Disconnect()
            ActiveTrolls[sender.UserId] = nil
            
            -- Reset body position
            local character = sender.Character
            if character then
                for _, partName in ipairs({
                    "UpperTorso", "LowerTorso",
                    "LeftUpperArm", "LeftLowerArm", "LeftHand",
                    "RightUpperArm", "RightLowerArm", "RightHand",
                    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
                    "RightUpperLeg", "RightLowerLeg", "RightFoot"
                }) do
                    local part = character:FindFirstChild(partName)
                    if part then
                        part.CFrame = part.CFrame * CFrame.new(0, -10, 0)
                    end
                end
            end
            
            ReplicatedStorage.UnragdollEvent:FireServer()
        end
    end
end)

-- Clean up trolls when players leave
Players.PlayerRemoving:Connect(function(player)
    if ActiveTrolls[player.UserId] then
        ActiveTrolls[player.UserId]:Disconnect()
        ActiveTrolls[player.UserId] = nil
    end
end)
