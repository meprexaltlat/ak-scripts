-- Store the player
local player = game.Players.LocalPlayer

-- Ensure the character and humanoid root part exist
if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
    warn("Player's character or HumanoidRootPart not found.")
    return
end

-- Store the initial position
local initialPosition = player.Character.HumanoidRootPart.Position

-- Store the initial camera CFrame
local camera = workspace.CurrentCamera
local initialCameraCFrame = camera.CFrame

-- Control variables
local scriptActive = true
local firingInterval = 0.1 -- Set to a low interval for firing

-- Function to check for "DemonMic" in the player's inventory
local function hasDemonMic()
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item.Name == "DemonMic" then
            return true
        end
    end
    return false
end

-- Function to fire proximity prompts named "Activate" for other players only
local function fireOtherPlayersPrompts()
    -- Teleport the player to the new position
    player.Character.HumanoidRootPart.CFrame = CFrame.new(212, 23, 68)

    -- Wait a short moment to ensure the teleport is applied
    wait(0.5)

    -- Fire proximity prompts until "DemonMic" is obtained or the script is deactivated
    while not hasDemonMic() and scriptActive do
        local promptsToFire = {}

        for _, v in ipairs(game:GetService("Workspace"):GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.Name == "Activate" and not v:IsDescendantOf(player.Character) then
                table.insert(promptsToFire, v)

                -- Stop searching when batch size is reached
                if #promptsToFire >= 100000 then 
                    break
                end
            end
        end

        -- Fire each prompt in the batch
        for _, prompt in ipairs(promptsToFire) do
            fireproximityprompt(prompt)
            print("Fired proximity prompt at:", prompt.Parent.Name) -- Debug output
        end

        -- Check if "DemonMic" has been obtained
        if hasDemonMic() then
            print("DemonMic obtained! Stopping script.")
            scriptActive = false
            break
        end

        wait(firingInterval) -- Dynamic firing interval based on UI setting
    end

    -- Ensure the player is still in the game before teleporting back
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Teleport back to the original position
        player.Character.HumanoidRootPart.CFrame = CFrame.new(initialPosition)

        -- Restore the camera to its original CFrame
        camera.CFrame = initialCameraCFrame
    else
        warn("Player's character is missing when trying to teleport back.")
    end
end

-- Start firing proximity prompts
spawn(fireOtherPlayersPrompts)

-- Confirmation message
print("Proximity prompts firing initiated.")
