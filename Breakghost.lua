-- Store the player and initial position
for _, b in pairs(Workspace:GetChildren()) do
    if b.Name == game.Players.LocalPlayer.Name then
        for _, v in pairs(Workspace[game.Players.LocalPlayer.Name]:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end

-- Teleport to the new position
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(258, 3, 59)

local player = game.Players.LocalPlayer
local initialPosition = player.Character and player.Character:WaitForChild("HumanoidRootPart").Position

-- Control variables
local scriptActive = true
local firingInterval = 0.1 -- Set to a low interval for firing
local fireCount = 99999 -- Set to fire 99,999 times

-- Tweening Service
local TweenService = game:GetService("TweenService")

-- Function to fire proximity prompts named "Activate" for other players only
local function fireOtherPlayersPrompts()
    for i = 1, fireCount do
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

        wait(firingInterval) -- Dynamic firing interval based on UI setting
    end
end

-- Start firing proximity prompts
spawn(fireOtherPlayersPrompts)

-- Confirmation message
print("Proximity prompts firing initiated.")
