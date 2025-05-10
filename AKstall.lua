local targetPositions = {
    Vector3.new(153, -11, 12),
    Vector3.new(153, -11, 42),
    Vector3.new(153, -11, 74),
    Vector3.new(153, -11, 104),
    Vector3.new(153, -11, 139)
}

local messages = {
    "AK ADMIN",
    "ꜰuckiฑg",
    "OWNS",
    "YOU ALL",
    "LOSẸRS"
}

local function fireProximityPrompts(name)
    if fireproximityprompt then
        for _, descendant in ipairs(workspace:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") then
                if not name or descendant.Name == name or descendant.Parent.Name == name then
                    fireproximityprompt(descendant)
                end
            end
        end
    else
        warn("Your exploit does not support firing Proximity Prompts.")
    end
end

local function getRandomElement(list, exclude)
    local element
    repeat
        element = list[math.random(1, #list)]
    until element ~= exclude
    return element
end

local function updateBoothText(message, previousColor, previousFont)
    local colors = { "Red", "Teal", "Lace", "Sun", "Gray", "Cinder" }
    local fonts = { "DenkOne" }

    local randomColor = getRandomElement(colors, previousColor)
    local randomFont = "DenkOne"

    local args = {
        [1] = message,
        [2] = randomColor,
        [3] = randomFont
    }
    game:GetService("ReplicatedStorage"):WaitForChild("UpdateBoothText"):FireServer(unpack(args))

    return randomColor, randomFont
end

local function deleteBoothOwnership()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local deleteBoothOwnershipEvent = replicatedStorage:FindFirstChild("DeleteBoothOwnership")
    if deleteBoothOwnershipEvent and deleteBoothOwnershipEvent:IsA("RemoteEvent") then
        deleteBoothOwnershipEvent:FireServer()
    else
        warn("DeleteBoothOwnership RemoteEvent not found.")
    end
end

local function teleportToTarget(character, targetPosition)
    character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
end

local function keepConstantYAxis(humanoidRootPart)
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.Parent = humanoidRootPart
    bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyPosition.Position = humanoidRootPart.Position

    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if humanoidRootPart and bodyPosition then
            bodyPosition.Position = humanoidRootPart.Position
        else
            connection:Disconnect()
        end
    end)

    return bodyPosition
end

local function executeTeleportationSequence()
    local player = game.Players.LocalPlayer
    if not player then
        return
    end

    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return
    end

    local originalPosition = humanoidRootPart.Position
    local bodyPosition = keepConstantYAxis(humanoidRootPart)

    local previousColor, previousFont = nil, nil

    local noclipEnabled = true
    local function noclip()
        game:GetService("RunService").Stepped:Connect(function()
            if noclipEnabled then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
    noclip()

    for i, position in ipairs(targetPositions) do
        teleportToTarget(character, position)
        wait(1)
        fireProximityPrompts()
        previousColor, previousFont = updateBoothText(messages[i], previousColor, previousFont)
        deleteBoothOwnership()
    end

    noclipEnabled = false
    teleportToTarget(character, originalPosition)

    if bodyPosition then
        bodyPosition:Destroy()
    end
end

executeTeleportationSequence()
