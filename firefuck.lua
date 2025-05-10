-- Store the player
local player = game.Players.LocalPlayer

-- Control variable
local scriptActive = true
local firingInterval = 0.1 -- Set to a low interval for firing

-- Function to remove hold duration from all proximity prompts in the game
local function removeHoldDurationFromAllPrompts()
    for _, v in ipairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            v.HoldDuration = 0 -- Remove hold duration by setting it to 0
        end
    end
end

-- Function to fire proximity prompts named "Activate" for other players only
local function fireOtherPlayersPrompts(fireCount)
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

-- Function to setup the chat command
local function setupChatCommand()
    game.Players.LocalPlayer.Chatted:Connect(function(message)
        local command, numberStr = message:match("^(%S+)%s*(%S*)") -- Match the command and the number
        if command:lower() == "/firebutton" and numberStr ~= "" then
            local fireCount = tonumber(numberStr) -- Convert the string to a number
            if fireCount and fireCount > 0 then
                removeHoldDurationFromAllPrompts() -- Ensure hold duration is removed
                spawn(function() fireOtherPlayersPrompts(fireCount) end) -- Fire the prompts
                print("Firing " .. fireCount .. " proximity prompts.") -- Confirmation message
            else
                print("Invalid number. Please enter a positive integer.") -- Error message
            end
        end
    end)
end

-- Setup the chat command listener
setupChatCommand()

-- Confirmation message
